import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { pasteboard } from '@kit.BasicServicesKit';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { Country, getCountryByCode, FlagDesign, getFlagDesign, getFlagImageSource, InternationalOrg, getInternationalOrgByCode, isInternationalOrg, getLocalizedCountryName, getLocalizedCapital, getLocalizedRegionName, getLocalizedFlagDesign, getLocalizedOrgName, getLocalizedOrgHeadquarters } from '../../utils/countryData';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { SaveFlagDialog } from '../../components/SaveFlagDialog';
import { FavoritesManager } from '../../utils/favoritesManager';
import { getCoatOfArmsImageSource } from '../../utils/coatOfArmsUtil';
import { getFlagHistory, FlagHistoryItem } from '../../utils/FlagHistoryData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

interface RouterParams {
  countryCode: string;
}

@Entry
@Component
  struct FlagDetailPage {
  @State country: Country | undefined = undefined;
  @State internationalOrg: InternationalOrg | undefined = undefined;
  @State flagDesign: FlagDesign | undefined = undefined;
  @State isReading: boolean = false;
  @State isSharing: boolean = false;
  @State showTtsFirstUseDialog: boolean = false;
  @State flagPixelMap: image.PixelMap | null = null;
  @State isFavorite: boolean = false;
  @State coatOfArmsResource: Resource | null = null;
  @State flagHistoryItems: FlagHistoryItem[] = [];
  @State sharePixelMap: image.PixelMap | null = null;
  @State showCopyHint: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private readonly FLAG_CONTAINER_ID = 'flagImageContainer';
  private readonly FLAG_DOWNLOAD_CONTAINER_ID = 'flagDownloadContainer';
  private readonly SHARE_CONTAINER_ID = 'flagShareContainer';
  private readonly COPY_HINT_PREF_KEY = 'detail_page_copy_hint_shown';
  private countryCode: string = '';
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';

  // 保存对话框控制器
  private saveDialogController: CustomDialogController = new CustomDialogController({
    builder: SaveFlagDialog({
      pixelMap: this.flagPixelMap,
      onClose: () => {
        this.releaseFlagPixelMap();
      },
      onSaveSuccess: () => {
        promptAction.showToast({
          message: $r('app.string.flag_saved'),
          duration: 2000
        });
        this.releaseFlagPixelMap();
      },
      onSaveError: (error: Error) => {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.save_failed').id),
          duration: 2000
        });
        this.releaseFlagPixelMap();
      },
      saveScreenshot: async () => {
        await this.doSaveFlag();
      }
    }),
    autoCancel: false,
    customStyle: true
  });

  async aboutToAppear() {
    // 获取当前系统语言（已通过 @StorageLink 自动同步）
    
    const params = router.getParams() as RouterParams;
    if (params && params.countryCode) {
      this.countryCode = params.countryCode;
      if (isInternationalOrg(params.countryCode)) {
        this.internationalOrg = getInternationalOrgByCode(params.countryCode);
      } else {
        this.country = getCountryByCode(params.countryCode);
        this.flagDesign = getFlagDesign(params.countryCode);
        // 加载历史国旗数据（仅国家，不包括国际组织）
        this.flagHistoryItems = getFlagHistory(this.countryCode);
      }
    }

    // 初始化 TextReader
    try {
      await TextReaderUtil.init(this.context);
      TextReaderUtil.setEventListener();
      TextReaderUtil.setActionListener();
    } catch (err) {
      console.error(`Failed to init TextReader: ${JSON.stringify(err)}`);
    }

    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());

    // 初始化收藏管理器并检查收藏状态
    await FavoritesManager.init(this.context);
    await this.checkFavoriteStatus();

    // 加载国徽（仅国家，不包括国际组织）
    if (this.country) {
      this.loadCoatOfArms();
    }

    // 检查是否需要显示复制提示
    this.checkAndShowCopyHint();
  }

  private async checkAndShowCopyHint(): Promise<void> {
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const hintShown = await prefs.get(this.COPY_HINT_PREF_KEY, false);
      if (!hintShown) {
        // 延迟显示，确保页面已加载
        setTimeout(() => {
          this.showCopyHint = true;
        }, 500);
      }
    } catch (err) {
      console.error('[FlagDetailPage] Failed to check copy hint:', err);
    }
  }

  private async dismissCopyHint(): Promise<void> {
    this.showCopyHint = false;
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      await prefs.put(this.COPY_HINT_PREF_KEY, true);
      await prefs.flush();
    } catch (err) {
      console.error('[FlagDetailPage] Failed to save copy hint preference:', err);
    }
  }

  private async copyToClipboard(text: string): Promise<void> {
    try {
      const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
      const systemPasteboard = pasteboard.getSystemPasteboard();
      await systemPasteboard.setData(pasteData);
      
        promptAction.showToast({
          message: $r('app.string.copied'),
          duration: 1500
        });
    } catch (err) {
      console.error('[FlagDetailPage] Failed to copy to clipboard:', err);
      promptAction.showToast({
        message: $r('app.string.copy_failed'),
        duration: 2000
      });
    }
  }

  /**
   * 加载国徽
   */
  private loadCoatOfArms(): void {
    if (!this.country) return;

    // 从media文件夹加载预下载的国徽
    const resource = getCoatOfArmsImageSource(this.country.code);
    if (resource) {
      this.coatOfArmsResource = resource;
    }
  }

  private async checkFavoriteStatus(): Promise<void> {
    const pageUrl = `flag:${this.countryCode}`;
    this.isFavorite = await FavoritesManager.isFavorite(pageUrl);
  }

  private async toggleFavorite(): Promise<void> {
    let name = this.context.resourceManager.getStringSync($r('app.string.unknown').id);
    if (this.internationalOrg) {
      name = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
    } else if (this.country) {
      name = getLocalizedCountryName(this.country, this.currentLanguage);
    }
    const pageUrl = `flag:${this.countryCode}`;

    if (this.isFavorite) {
      await FavoritesManager.removeFavorite(pageUrl);
      this.isFavorite = false;
      promptAction.showToast({
        message: $r('app.string.favorited'),
        duration: 2000
      });
    } else {
      await FavoritesManager.addFavorite({ name: name, pageUrl: pageUrl });
      this.isFavorite = true;
      promptAction.showToast({
        message: $r('app.string.favorited'),
        duration: 2000
      });
    }
  }

  private releaseFlagPixelMap(): void {
    if (this.flagPixelMap) {
      try {
        this.flagPixelMap.release();
      } catch (e) {
        console.warn('[FlagDetailPage] Failed to release pixelmap:', e);
      }
      this.flagPixelMap = null;
    }
  }

  private releaseSharePixelMap(): void {
    if (this.sharePixelMap) {
      try {
        this.sharePixelMap.release();
      } catch (e) {
        console.warn('[FlagDetailPage] Failed to release share pixelmap:', e);
      }
      this.sharePixelMap = null;
    }
  }

  private async onDownloadClick(): Promise<void> {
    if (!this.country && !this.internationalOrg) return;

    try {
      promptAction.showToast({
        message: $r('app.string.preparing_image'),
        duration: 1000
      });

      // 先释放之前的 PixelMap，避免内存泄漏
      this.releaseFlagPixelMap();

      // 如果已有对话框打开，先关闭并释放资源
      if (this.saveDialogController) {
        try {
          this.saveDialogController.close();
        } catch (e) {
          console.warn('[FlagDetailPage] Failed to close existing dialog:', e);
        }
      }

      // 截取国旗容器快照
      const pixmap = await screenshotManager.captureSnapshot(this.FLAG_CONTAINER_ID);
      if (!pixmap) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.screenshot_failed').id),
          duration: 2000
        });
        return;
      }

      this.flagPixelMap = pixmap;

      // 更新对话框并显示
      this.saveDialogController = new CustomDialogController({
        builder: SaveFlagDialog({
          pixelMap: this.flagPixelMap,
          onClose: () => {
            this.releaseFlagPixelMap();
          },
          onSaveSuccess: () => {
            promptAction.showToast({
              message: this.context.resourceManager.getStringSync($r('app.string.flag_saved').id),
              duration: 2000
            });
          },
          onSaveError: (error: Error) => {
            promptAction.showToast({
              message: this.context.resourceManager.getStringSync($r('app.string.save_failed_with_error').id, error.message),
              duration: 2000
            });
            this.releaseFlagPixelMap();
          },
          saveScreenshot: async () => {
            await this.doSaveFlag();
          }
        }),
        autoCancel: false,
        customStyle: true
      });

      this.saveDialogController.open();
    } catch (error) {
      console.error('[FlagDetailPage] Download error:', error);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.download_failed').id),
        duration: 2000
      });
    }
  }

  private async doSaveFlag(): Promise<void> {
    if (!this.flagPixelMap || (!this.country && !this.internationalOrg)) {
      throw new Error('图片或组织信息不存在');
    }

    let name = this.context.resourceManager.getStringSync($r('app.string.unknown').id);
    if (this.internationalOrg) {
      name = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
    } else if (this.country) {
      name = getLocalizedCountryName(this.country, this.currentLanguage);
    }
    const flagText = this.context.resourceManager.getStringSync($r('app.string.flag').id);
    const fileName = screenshotManager.generateFileName(flagText, name);
    const success = await screenshotManager.saveToGallery(
      this.flagPixelMap,
      fileName,
      this.context,
      false // 不自动释放，由对话框管理
    );

    if (!success) {
      throw new Error('保存到相册失败');
    }
  }

  aboutToDisappear() {
    // 页面销毁时停止朗读
    if (this.isReading) {
      TextReaderUtil.stopRead();
      this.isReading = false;
    }
    // 页面销毁时释放 PixelMap，避免内存泄漏
    this.releaseFlagPixelMap();
    this.releaseSharePixelMap();
  }

  @Builder
  buildInternationalOrgPage() {
    if (this.internationalOrg) {
      Scroll() {
        Column() {
          // 隐藏的分享容器（包含旗帜、基本信息）
          Column() {
            if (this.internationalOrg) {
              this.ShareContentBuilder()
            }
          }
          .id(this.SHARE_CONTAINER_ID)
          .position({ x: -1000, y: -1000 })
          .width(400)
          .backgroundColor($r('app.color.bg_page'))

          // 隐藏的下载容器（无 padding，仅用于截图）
          Column() {
            Image(getFlagImageSource(this.internationalOrg.code))
              .width('100%')
              .height(200)
              .objectFit(ImageFit.Contain)
          }
          .width(400)
            .height(200)
            .backgroundColor(Color.White)
            .id(this.FLAG_DOWNLOAD_CONTAINER_ID)
            .position({ x: -1000, y: -1000 })

          // 旗帜图片（展示用，有 padding）
          Column() {
            Image(getFlagImageSource(this.internationalOrg.code))
              .width('100%')
              .height(200)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
            .padding(16)
            .id(this.FLAG_CONTAINER_ID)

          // 组织名称（可复制）
          Column() {
            Text(getLocalizedOrgName(this.internationalOrg, this.currentLanguage))
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .textAlign(TextAlign.Center)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: 4 })
              .onClick(() => {
                if (this.internationalOrg) {
                  this.copyToClipboard(getLocalizedOrgName(this.internationalOrg, this.currentLanguage));
                }
              })

            // 只在中文环境显示次要名称（英文名称）
            if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
              Text(this.internationalOrg.name)
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .textAlign(TextAlign.Center)
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .onClick(() => {
                  if (this.internationalOrg) {
                    this.copyToClipboard(this.internationalOrg.name);
                  }
                })
            }
          }
          .width('100%')
            .padding({ left: 16, right: 16, top: 20, bottom: 16 })
            .alignItems(HorizontalAlign.Center)

          // 基本信息卡片
          Row() {
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.basic_info').id))
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              this.InfoItem($r('app.string.headquarters'), getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage))
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem($r('app.string.region'), getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage))
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem($r('app.string.org_type'), LocalizationUtil.isEnglish(this.currentLanguage) ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN)
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.coverage_population').id), this.formatPopulation(this.internationalOrg.population))
              if (this.internationalOrg.website) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.website').id), this.internationalOrg.website)
              }
              if (this.internationalOrg.description || this.internationalOrg.descriptionEN) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.DescriptionItem($r('app.string.description'), LocalizationUtil.isEnglish(this.currentLanguage) ? (this.internationalOrg.descriptionEN || this.internationalOrg.description || '') : (this.internationalOrg.description || this.internationalOrg.descriptionEN || ''), true)
              }
            }
          .padding(16)
              .layoutWeight(1)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
          }
          .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 8 })

          // 底部操作按钮
          Row({ space: 16 }) {
            // 收藏按钮
            Button() {
              Row({ space: 8 }) {
                Image(this.isFavorite ? $r('app.media.icon_favorite_selected') : $r('app.media.icon_favorite'))
                  .width(20)
                  .height(20)
                Text(this.isFavorite ? $r('app.string.favorited') : $r('app.string.favorite'))
                  .fontSize(15)
                  .fontColor(this.isFavorite ? $r('app.color.button_primary') : $r('app.color.text_primary'))
              }
            }
          .layoutWeight(1)
              .height(48)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .onClick(() => {
                this.toggleFavorite();
              })

            // 下载按钮
            Button() {
              Row({ space: 8 }) {
                Image($r('app.media.icon_download'))
                  .width(20)
                  .height(20)
                Text($r('app.string.download'))
                  .fontSize(15)
                  .fontColor($r('app.color.text_primary'))
              }
            }
          .layoutWeight(1)
              .height(48)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .onClick(() => {
                this.onDownloadClick();
              })
          }
          .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 20, bottom: 24 })
        }
        .width('100%')
      }
      .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor($r('app.color.bg_page'))
    }
  }

  build() {
    Stack() {
      Navigation() {
      if (this.internationalOrg) {
        this.buildInternationalOrgPage()
      } else if (this.country) {
        Scroll() {
          Column() {
            // 隐藏的分享容器（包含国旗、关于、关于这面国旗）
            Column() {
              if (this.country) {
                this.ShareContentBuilder()
              }
            }
            .id(this.SHARE_CONTAINER_ID)
            .position({ x: -1000, y: -1000 })
            .width(400)
            .backgroundColor($r('app.color.bg_page'))

            // 隐藏的下载容器（无 padding，仅用于截图）
            Column() {
              Image(getFlagImageSource(this.country.code))
                .width('100%')
                .height(200)
                .objectFit(ImageFit.Contain)
            }
            .width(400)
              .height(200)
              .backgroundColor(Color.White)
              .id(this.FLAG_DOWNLOAD_CONTAINER_ID)
              .position({ x: -1000, y: -1000 })

            // 国旗图片（展示用，有 padding）
            Column() {
              Image(getFlagImageSource(this.country.code))
                .width('100%')
                .height(200)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
              .padding(16)
              .id(this.FLAG_CONTAINER_ID)

            // 国家名称（可复制）
            Column() {
              Text(getLocalizedCountryName(this.country, this.currentLanguage))
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 4 })
                .onClick(() => {
                  if (this.country) {
                    this.copyToClipboard(getLocalizedCountryName(this.country, this.currentLanguage));
                  }
                })

              Text(this.country.name)
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .onClick(() => {
                  if (this.country) {
                    this.copyToClipboard(this.country.name);
                  }
                })
            }
            .width('100%')
              .padding({ left: 16, right: 16, top: 20, bottom: 16 })
              .alignItems(HorizontalAlign.Center)

            // 基本信息卡片
            Row() {
              Column() {
                Text($r('app.string.basic_info'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 16 })
                  .alignSelf(ItemAlign.Start)

                this.InfoItem($r('app.string.capital'), getLocalizedCapital(this.country, this.currentLanguage))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem($r('app.string.region'), getLocalizedRegionName(this.country.region, this.currentLanguage))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem($r('app.string.population'), this.formatPopulation(this.country.population))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem($r('app.string.area'), this.formatArea(this.country.area))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem($r('app.string.country_code'), this.country.code.toUpperCase())
              }
              .padding(16)
                .layoutWeight(1)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(16)
            }
            .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 8 })

            // 关于这面国旗
            Row() {
              Column() {
                Text($r('app.string.about_flag'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 16 })
                  .alignSelf(ItemAlign.Start)

                this.InfoItem($r('app.string.flag_proportion'), this.getFlagProportion())
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem($r('app.string.adopted_date'), this.getFlagAdopted())
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 16 })

                Text(this.getFlagDescription())
                  .fontSize(14)
                  .fontColor($r('app.color.text_dark'))
                  .lineHeight(22)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .onClick(() => {
                    this.copyToClipboard(this.getFlagDescription());
                  })
              }
              .padding(16)
                .layoutWeight(1)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(16)
                .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 16 })

            // 历史国旗banner（如果有历史数据且是国家，显示在国徽前面）
            if (this.country && this.flagHistoryItems && this.flagHistoryItems.length > 0) {
              this.HistoricalFlagsBanner()
            }

            // 国徽（如果有）
            if (this.coatOfArmsResource) {
              Row() {
                Column() {
                  Text($r('app.string.coat_of_arms'))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ bottom: 16 })
                    .alignSelf(ItemAlign.Start)

                  Column() {
                    Image(this.coatOfArmsResource)
                      .width(200)
                      .height(200)
                      .objectFit(ImageFit.Contain)
                  }
                  .width('100%')
                    .alignItems(HorizontalAlign.Center)
                }
                .padding(16)
                  .layoutWeight(1)
                  .backgroundColor($r('app.color.bg_card'))
                  .borderRadius(16)
                  .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
                .padding({ left: 16, right: 16 })
                .margin({ top: 16 })
            }

            // 底部操作按钮
            Row({ space: 16 }) {
              // 收藏按钮
              Button() {
                Row({ space: 8 }) {
                  Image(this.isFavorite ? $r('app.media.icon_favorite_selected') : $r('app.media.icon_favorite'))
                    .width(20)
                    .height(20)
                  Text(this.isFavorite ? $r('app.string.favorited') : $r('app.string.favorite'))
                    .fontSize(15)
                    .fontColor(this.isFavorite ? $r('app.color.button_primary') : $r('app.color.text_primary'))
                }
              }
              .layoutWeight(1)
                .height(48)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(12)
                .onClick(() => {
                  this.toggleFavorite();
                })

              // 下载按钮
              Button() {
                Row({ space: 8 }) {
                  Image($r('app.media.icon_download'))
                    .width(20)
                    .height(20)
                  Text($r('app.string.download'))
                    .fontSize(15)
                    .fontColor($r('app.color.text_primary'))
                }
              }
              .layoutWeight(1)
                .height(48)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(12)
                .onClick(() => {
                  this.onDownloadClick();
                })
            }
            .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 20, bottom: 24 })
          }
          .width('100%')
        }
        .width('100%')
          .height('100%')
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .backgroundColor($r('app.color.bg_page'))
      } else {
        Column() {
        Text($r('app.string.unknown'))
          .fontSize(16)
          .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
      }
    }
    .titleMode(NavigationTitleMode.Mini)
      .backgroundColor($r('app.color.bg_page'))
      .menus(this.MenuBuilder)

    // 复制提示 Snackbar（底部显示）
    if (this.showCopyHint) {
      this.CopyHintSnackbar()
    }

    // TTS首次使用提示对话框
    if (this.showTtsFirstUseDialog) {
      this.TtsFirstUseDialog()
    }
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }

  @Builder
  CopyHintSnackbar() {
    Row() {
      Text($r('app.string.copy_hint'))
        .fontSize(14)
        .fontColor(Color.White)
        .layoutWeight(1)

      Button() {
        Text($r('app.string.got_it'))
          .fontSize(14)
          .fontColor(Color.White)
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.dismissCopyHint();
      })
    }
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ left: 16, right: 16, bottom: 16 })
    .backgroundColor('rgba(0, 0, 0, 0.85)')
    .borderRadius(12)
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
      // 只在中文环境下显示朗读按钮
      if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
        Image($r('app.media.icon_voice'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.onReadClick();
          })
      }

      Image($r('app.media.icon_share'))
        .width(22)
        .height(22)
        .onClick(() => {
          this.onShareClick();
        })
    }
    .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: 16 })
  }

  @Builder
  DescriptionItem(label: Resource | string, value: string, copyable: boolean = false) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 8 })
        .alignSelf(ItemAlign.Start)
      Text(value)
        .fontSize(15)
        .fontColor($r('app.color.text_primary'))
        .lineHeight(22)
        .alignSelf(ItemAlign.Start)
        .onClick(() => {
          if (copyable) {
            this.copyToClipboard(value);
          }
        })
    }
    .width('100%')
      .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ShareContentBuilder() {
    if (this.internationalOrg) {
      // 国际组织分享内容
      Column({ space: 16 }) {
        // 旗帜图片
        Column() {
          Image(getFlagImageSource(this.internationalOrg.code))
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_page'))

        // 组织名称
        Column() {
          Text(getLocalizedOrgName(this.internationalOrg, this.currentLanguage))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          // 只在中文环境显示次要名称（英文名称）
          if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
            Text(this.internationalOrg.name)
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 16 })
          .alignItems(HorizontalAlign.Center)

        // 基本信息卡片
        Row() {
          Column() {
            Text($r('app.string.basic_info'))
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            this.InfoItem($r('app.string.headquarters'), getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.region'), getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.org_type'), LocalizationUtil.isEnglish(this.currentLanguage) ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.coverage_population').id), this.formatPopulation(this.internationalOrg.population))
            if (this.internationalOrg.website) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.website').id), this.internationalOrg.website)
            }
            if (this.internationalOrg.description || this.internationalOrg.descriptionEN) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.DescriptionItem($r('app.string.description'), LocalizationUtil.isEnglish(this.currentLanguage) ? (this.internationalOrg.descriptionEN || this.internationalOrg.description || '') : (this.internationalOrg.description || this.internationalOrg.descriptionEN || ''), true)
            }
          }
          .padding(16)
            .layoutWeight(1)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(16)
        }
        .width('100%')
          .padding({ left: 16, right: 16 })
      }
      .width('100%')
        .padding({ top: 20, bottom: 20 })
        .backgroundColor($r('app.color.bg_page'))
    } else if (this.country) {
      Column({ space: 16 }) {
        // 国旗图片
        Column() {
          Image(getFlagImageSource(this.country.code))
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_page'))

        // 国家名称
        Column() {
          Text(getLocalizedCountryName(this.country, this.currentLanguage))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          Text(LocalizationUtil.isEnglish(this.currentLanguage) ? this.country.nameCN : this.country.name)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 16 })
          .alignItems(HorizontalAlign.Center)

        // 基本信息卡片（关于）
        Row() {
          Column() {
            Text($r('app.string.basic_info'))
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            this.InfoItem($r('app.string.capital'), getLocalizedCapital(this.country, this.currentLanguage))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.region'), getLocalizedRegionName(this.country.region, this.currentLanguage))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.population'), this.formatPopulation(this.country.population))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.area'), this.formatArea(this.country.area))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.country_code'), this.country.code.toUpperCase())
          }
          .padding(16)
            .layoutWeight(1)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(16)
        }
        .width('100%')
          .padding({ left: 16, right: 16 })

        // 关于这面国旗
        Row() {
          Column() {
            Text($r('app.string.about_flag'))
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            this.InfoItem($r('app.string.flag_proportion'), this.getFlagProportion())
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem($r('app.string.adopted_date'), this.getFlagAdopted())
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 16 })

            Text(this.getFlagDescription())
              .fontSize(14)
              .fontColor($r('app.color.text_dark'))
              .lineHeight(22)
              .width('100%')
              .textAlign(TextAlign.Start)
          }
          .padding(16)
            .layoutWeight(1)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(16)
            .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
          .padding({ left: 16, right: 16 })
      }
      .width('100%')
        .padding({ top: 20, bottom: 20 })
        .backgroundColor($r('app.color.bg_page'))
    }
  }

  @Builder
  InfoItem(label: Resource | string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
      Blank()
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
    }
    .width('100%')
    .onClick(() => {
      this.copyToClipboard(value);
    })
  }

  private getRegionName(region: string): string {
    return getLocalizedRegionName(region, this.currentLanguage);
  }

  private formatPopulation(population: number): string {
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    
    if (isEnglish) {
      // English format: use thousand, million, billion
      if (population >= 1000000000) {
        return (population / 1000000000).toFixed(2) + ' billion';
      } else if (population >= 1000000) {
        return (population / 1000000).toFixed(2) + ' million';
      } else if (population >= 1000) {
        return (population / 1000).toFixed(0) + ' thousand';
      }
      return population.toString();
    } else {
      // Chinese format: use 万 and 亿
      if (population >= 100000000) {
        return (population / 100000000).toFixed(2) + ' 亿人';
      } else if (population >= 10000) {
        return (population / 10000).toFixed(0) + ' 万人';
      }
      return population.toString() + ' 人';
    }
  }

  private formatArea(area: number): string {
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    
    if (isEnglish) {
      // English format: use thousand, million for square kilometers
      if (area >= 1000000) {
        return (area / 1000000).toFixed(2) + ' million km²';
      } else if (area >= 1000) {
        return (area / 1000).toFixed(0) + ' thousand km²';
      }
      return area.toFixed(0) + ' km²';
    } else {
      // Chinese format: use 万平方公里
      if (area >= 10000) {
        return (area / 10000).toFixed(2) + ' 万平方公里';
      }
      return area.toFixed(0) + ' 平方公里';
    }
  }

  private getFlagDescription(): string {
    if (!this.country) {
      return '';
    }

    // 使用本地化的标志设计描述
    if (this.flagDesign) {
      return getLocalizedFlagDesign(this.flagDesign, this.currentLanguage);
    }

    // 如果没有设计描述，返回默认描述
    const countryName = getLocalizedCountryName(this.country, this.currentLanguage);
    return this.context.resourceManager.getStringSync($r('app.string.flag_default_description').id, countryName);
  }

  private getFlagProportion(): string {
    if (this.flagDesign && this.flagDesign.proportion) {
      return this.flagDesign.proportion;
    }
    return this.context.resourceManager.getStringSync($r('app.string.unknown').id);
  }

  private getFlagAdopted(): string {
    if (this.flagDesign && this.flagDesign.adopted) {
      return this.flagDesign.adopted;
    }
    return this.context.resourceManager.getStringSync($r('app.string.unknown').id);
  }

  private getReadContent(): string {
    const lines: string[] = [];
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);

    if (this.internationalOrg) {
      const orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      const otherName = isEnglish ? this.internationalOrg.nameCN : this.internationalOrg.name;
      const headquarters = getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage);
      const region = getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage);
      const orgType = isEnglish ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN;
      
      if (isEnglish) {
        lines.push(`${orgName}, also known as ${otherName}.`);
        lines.push(`Headquarters is located in ${headquarters}.`);
        lines.push(`Region: ${region}.`);
        lines.push(`Organization type: ${orgType}.`);
        lines.push(`Coverage population: approximately ${this.formatPopulation(this.internationalOrg.population)}.`);
      } else {
        lines.push(`${orgName}${this.context.resourceManager.getStringSync($r('app.string.also_known_as').id, otherName)}。`);
        lines.push(this.context.resourceManager.getStringSync($r('app.string.headquarters_located').id, headquarters) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.region_is').id, region) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.org_type_is').id, orgType) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.coverage_population_approx').id, this.formatPopulation(this.internationalOrg.population)) + '。');
      }
      if (this.internationalOrg.website) {
        if (isEnglish) {
          lines.push(this.context.resourceManager.getStringSync($r('app.string.website_colon_en').id, this.internationalOrg.website) + '.');
        } else {
          lines.push(this.context.resourceManager.getStringSync($r('app.string.website_colon').id, this.internationalOrg.website) + '。');
        }
      }
      const description = isEnglish ? (this.internationalOrg.descriptionEN || this.internationalOrg.description) : (this.internationalOrg.description || this.internationalOrg.descriptionEN);
      if (description) {
        lines.push(`${description}`);
      }
    } else if (this.country) {
      const countryName = getLocalizedCountryName(this.country, this.currentLanguage);
      const otherName = isEnglish ? this.country.nameCN : this.country.name;
      const capital = getLocalizedCapital(this.country, this.currentLanguage);
      const region = getLocalizedRegionName(this.country.region, this.currentLanguage);
      
      if (isEnglish) {
        lines.push(`${countryName}${this.context.resourceManager.getStringSync($r('app.string.also_known_as_en').id, otherName)}.`);
        lines.push(this.context.resourceManager.getStringSync($r('app.string.capital_colon_en').id, capital) + '.');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.region_colon_en').id, region) + '.');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.population_colon_en').id, this.formatPopulation(this.country.population)) + '.');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.area_colon_en').id, this.formatArea(this.country.area)) + '.');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.flag_proportion_en').id, this.getFlagProportion()) + '.');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.adopted_date_en').id, this.getFlagAdopted()) + '.');
      } else {
        lines.push(`${countryName}${this.context.resourceManager.getStringSync($r('app.string.also_known_as').id, otherName)}。`);
        lines.push(this.context.resourceManager.getStringSync($r('app.string.capital_is').id, capital) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.region_belongs').id, region) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.population_colon').id, this.formatPopulation(this.country.population)) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.area_colon').id, this.formatArea(this.country.area)) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.flag_proportion_is').id, this.getFlagProportion()) + '。');
        lines.push(this.context.resourceManager.getStringSync($r('app.string.adopted_date_is').id, this.getFlagAdopted()) + '。');
      }
      lines.push(this.getFlagDescription());
    } else {
      return '';
    }

    return lines.join('');
  }

  private async onReadClick(): Promise<void> {
    if (this.isReading) {
      TextReaderUtil.stopRead();
      this.isReading = false;
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.stop_reading').id),
        duration: 2000
      });
    } else {
      // 检查是否首次使用TTS功能
      const isFirstUse = await TextReaderUtil.isFirstUse(this.context);
      if (isFirstUse) {
        // 显示首次使用提示对话框
        this.showTtsFirstUseDialog = true;
      } else {
        // 直接开始朗读
        await this.startReading();
      }
    }
  }

  private async startReading(): Promise<void> {
    try {
      let title = this.context.resourceManager.getStringSync($r('app.string.details').id);
      if (this.internationalOrg) {
        title = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      } else if (this.country) {
        title = getLocalizedCountryName(this.country, this.currentLanguage);
      }
      const content = this.getReadContent();
      await TextReaderUtil.startRead(this.context, title, content);
      this.isReading = true;
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.start_reading').id),
        duration: 2000
      });
    } catch (err) {
      console.error(`Failed to start read: ${JSON.stringify(err)}`);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.reading_unavailable').id),
        duration: 2000
      });
    }
  }

  private async onTtsFirstUseDialogConfirm(): Promise<void> {
    // 标记已显示
    await TextReaderUtil.markFirstUseShown(this.context);
    this.showTtsFirstUseDialog = false;
    // 开始朗读
    await this.startReading();
  }

  private async onShareClick(): Promise<void> {
    if (this.isSharing || (!this.country && !this.internationalOrg)) return;

    this.isSharing = true;
    promptAction.showToast({
      message: this.context.resourceManager.getStringSync($r('app.string.preparing_share').id),
      duration: 1500
    });

    let tempFilePath: string | null = null;

    try {
      // 先释放之前的 PixelMap
      this.releaseSharePixelMap();

      // 截取分享容器内容（包含国旗、关于、关于这面国旗）
      const pixmap = await screenshotManager.captureSnapshot(this.SHARE_CONTAINER_ID);
      if (!pixmap) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.screenshot_failed').id),
          duration: 2000
        });
        this.isSharing = false;
        return;
      }

      this.sharePixelMap = pixmap;

      // 创建图像打包器并打包为 ArrayBuffer
      const imagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 90
      };
      
      const imageData: ArrayBuffer = await imagePacker.packing(pixmap, packOpts);
      console.info(`[FlagDetailPage] Image packed, data size: ${imageData.byteLength} bytes`);

      // 保存到临时文件
      const timestamp = Date.now();
      tempFilePath = this.context.cacheDir + '/share_flag_detail_' + timestamp + '.jpg';
      
      // 使用同步文件操作
      const fileHandle = fs.openSync(tempFilePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(fileHandle.fd, imageData);
      fs.closeSync(fileHandle);
      
      // 验证文件是否存在且不为空
      const stat = fs.statSync(tempFilePath);
      if (stat.size === 0) {
        throw new Error('Image file is empty');
      }
      
      console.info(`[FlagDetailPage] Image file created: ${tempFilePath}, size: ${stat.size} bytes`);

      // 获取文件URI
      const imageUri = fileUri.getUriFromPath(tempFilePath);
      console.info(`[FlagDetailPage] Image URI: ${imageUri}`);
      
      // 获取图片类型描述符
      const utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg', uniformTypeDescriptor.UniformDataType.IMAGE);
      console.info(`[FlagDetailPage] UTD Type ID: ${utdTypeId}`);

      // 使用图片URI分享
      let orgName = this.context.resourceManager.getStringSync($r('app.string.details').id);
      if (this.internationalOrg) {
        orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      } else if (this.country) {
        orgName = getLocalizedCountryName(this.country, this.currentLanguage);
      }
      const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
      const flagTypeText = this.internationalOrg 
        ? this.context.resourceManager.getStringSync($r('app.string.flag').id)
        : this.context.resourceManager.getStringSync($r('app.string.national_flag').id);
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${orgName} ${flagTypeText}`,
        description: this.context.resourceManager.getStringSync($r('app.string.from_app').id)
      });
      
      console.info(`[FlagDetailPage] ShareData created: utd=${utdTypeId}, uri=${imageUri}`);

      const controller = new systemShare.ShareController(shareData);
      
      // 显示分享面板
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      console.info('[FlagDetailPage] Share panel opened successfully');
      
      // 分享成功后释放 PixelMap
      this.releaseSharePixelMap();
      
      // 延迟删除文件，确保分享完成
      setTimeout(() => {
        if (tempFilePath) {
          try {
            fs.unlinkSync(tempFilePath);
            console.info(`[FlagDetailPage] Temp file deleted: ${tempFilePath}`);
          } catch (unlinkError) {
            console.warn('[FlagDetailPage] Failed to delete temp file:', unlinkError);
          }
        }
      }, 5000); // 5秒后删除

    } catch (err) {
      const error = err as BusinessError;
      console.error(`[FlagDetailPage] Failed to share: code: ${error?.code}, message: ${error?.message}`);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
        duration: 2000
      });
      
      // 清理资源
      this.releaseSharePixelMap();
      if (tempFilePath) {
        try {
          fs.unlinkSync(tempFilePath);
        } catch (unlinkError) {
          console.warn('[FlagDetailPage] Failed to delete temp file on error:', unlinkError);
        }
      }
    } finally {
      this.isSharing = false;
    }
  }

  private buildShareText(): string {
    const lines: string[] = [];
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);

    if (this.internationalOrg) {
      const orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      const otherName = isEnglish ? this.internationalOrg.nameCN : this.internationalOrg.name;
      const headquarters = getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage);
      const region = getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage);
      const orgType = isEnglish ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN;
      
      lines.push(`🏳️ ${orgName} (${otherName})`);
      lines.push('');
      if (isEnglish) {
        lines.push(`📍 ${this.context.resourceManager.getStringSync($r('app.string.headquarters').id)}: ${headquarters}`);
        lines.push(`🌍 ${this.context.resourceManager.getStringSync($r('app.string.region').id)}: ${region}`);
        lines.push(`🏛️ ${this.context.resourceManager.getStringSync($r('app.string.org_type').id)}: ${orgType}`);
        lines.push(`👥 ${this.context.resourceManager.getStringSync($r('app.string.coverage_population').id)}: ${this.formatPopulation(this.internationalOrg.population)}`);
        if (this.internationalOrg.website) {
          lines.push(`🌐 ${this.context.resourceManager.getStringSync($r('app.string.website').id)}: ${this.internationalOrg.website}`);
        }
        const descriptionText = this.internationalOrg.descriptionEN || this.internationalOrg.description;
        if (descriptionText) {
          lines.push('');
          lines.push(`📝 ${this.context.resourceManager.getStringSync($r('app.string.description').id)}: ${descriptionText}`);
        }
      } else {
        lines.push(`📍 ${this.context.resourceManager.getStringSync($r('app.string.headquarters').id)}：${headquarters}`);
        lines.push(`🌍 ${this.context.resourceManager.getStringSync($r('app.string.region').id)}：${region}`);
        lines.push(`🏛️ ${this.context.resourceManager.getStringSync($r('app.string.org_type').id)}：${orgType}`);
        lines.push(`👥 ${this.context.resourceManager.getStringSync($r('app.string.coverage_population').id)}：${this.formatPopulation(this.internationalOrg.population)}`);
        if (this.internationalOrg.website) {
          lines.push(`🌐 ${this.context.resourceManager.getStringSync($r('app.string.website').id)}：${this.internationalOrg.website}`);
        }
        const descriptionTextCN = this.internationalOrg.description || this.internationalOrg.descriptionEN;
        if (descriptionTextCN) {
          lines.push('');
          lines.push(`📝 ${this.context.resourceManager.getStringSync($r('app.string.description').id)}：${descriptionTextCN}`);
        }
      }
    } else if (this.country) {
      const countryName = getLocalizedCountryName(this.country, this.currentLanguage);
      const otherName = isEnglish ? this.country.nameCN : this.country.name;
      const capital = getLocalizedCapital(this.country, this.currentLanguage);
      const region = getLocalizedRegionName(this.country.region, this.currentLanguage);
      
      lines.push(`🏳️ ${countryName} (${otherName})`);
      lines.push('');
      if (isEnglish) {
        lines.push(`📍 ${this.context.resourceManager.getStringSync($r('app.string.capital').id)}: ${capital}`);
        lines.push(`🌍 ${this.context.resourceManager.getStringSync($r('app.string.region').id)}: ${region}`);
        lines.push(`👥 ${this.context.resourceManager.getStringSync($r('app.string.population').id)}: ${this.formatPopulation(this.country.population)}`);
        lines.push(`📐 ${this.context.resourceManager.getStringSync($r('app.string.area').id)}: ${this.formatArea(this.country.area)}`);

        if (this.flagDesign) {
          lines.push('');
          lines.push(`📏 ${this.context.resourceManager.getStringSync($r('app.string.flag_proportion').id)}: ${this.flagDesign.proportion}`);
          lines.push(`📅 ${this.context.resourceManager.getStringSync($r('app.string.adopted_date').id)}: ${this.flagDesign.adopted}`);
          const designDesc = getLocalizedFlagDesign(this.flagDesign, this.currentLanguage);
          if (designDesc) {
            lines.push('');
            lines.push(`🎨 ${designDesc}`);
          }
        }
      } else {
        lines.push(`📍 ${this.context.resourceManager.getStringSync($r('app.string.capital').id)}：${capital}`);
        lines.push(`🌍 ${this.context.resourceManager.getStringSync($r('app.string.region').id)}：${region}`);
        lines.push(`👥 ${this.context.resourceManager.getStringSync($r('app.string.population').id)}：${this.formatPopulation(this.country.population)}`);
        lines.push(`📐 ${this.context.resourceManager.getStringSync($r('app.string.area').id)}：${this.formatArea(this.country.area)}`);

        if (this.flagDesign) {
          lines.push('');
          lines.push(`📏 ${this.context.resourceManager.getStringSync($r('app.string.flag_proportion').id)}：${this.flagDesign.proportion}`);
          lines.push(`📅 ${this.context.resourceManager.getStringSync($r('app.string.adopted_date').id)}：${this.flagDesign.adopted}`);
          const designDesc = getLocalizedFlagDesign(this.flagDesign, this.currentLanguage);
          if (designDesc) {
            lines.push('');
            lines.push(`🎨 ${designDesc}`);
          }
        }
      }
    } else {
      return '';
    }

    lines.push('');
    const fromAppText = this.context.resourceManager.getStringSync($r('app.string.from_app').id);
    lines.push(`—— ${fromAppText}`);

    return lines.join('\n');
  }

  @Builder
  HistoricalFlagsBanner() {
    Row() {
      Column() {
        // 标题行 - 完全复制涂鸦说明的样式
        Row() {
          Text($r('app.string.historical_flags'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Blank()

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
        .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: 12 })

        // 历史国旗Grid（最多显示3个，只显示一行，显示最早的3个）
        Grid() {
          ForEach(this.flagHistoryItems.slice().sort((a, b) => a.year - b.year).slice(0, 3), (item: FlagHistoryItem, index: number) => {
            GridItem() {
              Column() {
                Image($rawfile(`flag_history/${item.imagePath}.png`))
                  .width('100%')
                  .height(60)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
                .padding(8)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(8)
            }
          }, (item: FlagHistoryItem, index: number) => `history_${item.countryCode}_${item.year}_${index}`)
        }
        .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .width('100%')
          .cachedCount(3)
      }
      .width('100%')
        .padding(16)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/flaghistory/FlagHistoryPage',
            params: { countryCode: this.countryCode }
          }).catch((err: Error) => {
            console.error(`Navigation failed: ${err.message}`);
          });
        })
    }
    .width('100%')
      .padding({ left: 16, right: 16 })
      .margin({ top: 16 })
  }

  @Builder
  TtsFirstUseDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          // 不允许点击遮罩层关闭，必须点击确认按钮
        })

      // 对话框
      Column() {
        Text($r('app.string.tts_first_use_title'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 16 })

        Text($r('app.string.tts_first_use_message'))
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .width('100%')
          .margin({ bottom: 20 })

        Button($r('app.string.tts_first_use_confirm'))
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.white'))
          .fontSize(16)
          .width('100%')
          .height(44)
          .borderRadius(8)
          .onClick(async () => {
            await this.onTtsFirstUseDialogConfirm();
          })
      }
      .width('85%')
        .constraintSize({ maxWidth: 400 })
        .padding({ left: 24, right: 24, top: 24, bottom: 24 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .shadow({
          radius: 20,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
    }
    .width('100%')
      .height('100%')
  }
}

