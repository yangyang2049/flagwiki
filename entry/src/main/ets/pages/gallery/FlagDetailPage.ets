import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { Country, getCountryByCode, FlagDesign, getFlagDesign, getFlagImageSource, InternationalOrg, getInternationalOrgByCode, isInternationalOrg, getLocalizedCountryName, getLocalizedCapital, getLocalizedFlagDesign, getLocalizedOrgHeadquarters, getLocalizedOrgName } from '../../utils/countryData';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { SaveFlagDialog } from '../../components/SaveFlagDialog';
import { FavoritesManager } from '../../utils/favoritesManager';
import { getCoatOfArmsImageSource } from '../../utils/coatOfArmsUtil';
import { DeviceHelper } from '../../utils/DeviceHelper';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
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
  @State flagPixelMap: image.PixelMap | null = null;
  @State isFavorite: boolean = false;
  @State coatOfArmsResource: Resource | null = null;
  @State sharePixelMap: image.PixelMap | null = null;
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;
  private readonly FLAG_CONTAINER_ID = 'flagImageContainer';
  private readonly FLAG_DOWNLOAD_CONTAINER_ID = 'flagDownloadContainer';
  private readonly SHARE_CONTAINER_ID = 'flagShareContainer';
  private countryCode: string = '';
  private readonly isWearable: boolean = DeviceHelper.isWearable();

  private get isEnglish(): boolean {
    return LocalizationUtil.isEnglish(this.currentLanguage);
  }

  // 保存对话框控制器
  private saveDialogController: CustomDialogController = new CustomDialogController({
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
        this.releaseFlagPixelMap();
      },
      onSaveError: (error: Error) => {
        promptAction.showToast({
          message: `${this.context.resourceManager.getStringSync($r('app.string.save_failed').id)}: ${error.message}`,
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
    const params = router.getParams() as RouterParams;
    if (params && params.countryCode) {
      this.countryCode = params.countryCode;
      if (isInternationalOrg(params.countryCode)) {
        this.internationalOrg = getInternationalOrgByCode(params.countryCode);
      } else {
        this.country = getCountryByCode(params.countryCode);
        this.flagDesign = getFlagDesign(params.countryCode);
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
    let name: string;
    if (this.internationalOrg) {
      name = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
    } else if (this.country) {
      name = getLocalizedCountryName(this.country, this.currentLanguage);
    } else {
      name = this.context.resourceManager.getStringSync($r('app.string.unknown').id);
    }
    const pageUrl = `flag:${this.countryCode}`;

    if (this.isFavorite) {
      await FavoritesManager.removeFavorite(pageUrl);
      this.isFavorite = false;
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.favorite_removed').id),
        duration: 2000
      });
    } else {
      await FavoritesManager.addFavorite({ name: name, pageUrl: pageUrl });
      this.isFavorite = true;
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.favorite_added').id),
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
        message: this.context.resourceManager.getStringSync($r('app.string.preparing_image').id), 
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
              message: `${this.context.resourceManager.getStringSync($r('app.string.save_failed').id)}: ${error.message}`,
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

    let name: string;
    if (this.internationalOrg) {
      name = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
    } else if (this.country) {
      name = getLocalizedCountryName(this.country, this.currentLanguage);
    } else {
      name = this.context.resourceManager.getStringSync($r('app.string.unknown').id);
    }
    const flagLabel = this.context.resourceManager.getStringSync($r('app.string.flag').id);
    const fileName = screenshotManager.generateFileName(flagLabel, name);
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
  buildInternationalOrgContent() {
    Column() {
      // 隐藏的分享容器（包含旗帜和基本信息）
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
        Image(getFlagImageSource(this.internationalOrg!.code))
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
        Image(getFlagImageSource(this.internationalOrg!.code))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(16)
      .id(this.FLAG_CONTAINER_ID)

      // 组织名称
      Column() {
        Text(this.isEnglish ? this.internationalOrg!.name : this.internationalOrg!.nameCN)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 4 })

        Text(this.isEnglish ? this.internationalOrg!.nameCN : this.internationalOrg!.name)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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

          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.headquarters').id), getLocalizedOrgHeadquarters(this.internationalOrg!, this.currentLanguage))
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.region').id), this.getRegionName(this.internationalOrg!.region))
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.org_type').id), this.isEnglish ? this.internationalOrg!.orgType : this.internationalOrg!.orgTypeCN)
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.coverage_population').id), this.formatPopulation(this.internationalOrg!.population))
          if (this.internationalOrg!.website) {
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.website').id), this.internationalOrg!.website)
          }
          if (this.internationalOrg!.description || this.internationalOrg!.descriptionEN) {
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.DescriptionItem(this.context.resourceManager.getStringSync($r('app.string.description').id), this.getInternationalOrgDescription())
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
        .focusable(!this.isWearable)
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
        .focusable(!this.isWearable)
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

  @Builder
  buildCountryContent() {
    Column() {
      // 隐藏的分享容器（包含国旗和基本信息）
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
        Image(getFlagImageSource(this.country!.code))
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
        Image(getFlagImageSource(this.country!.code))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(16)
      .id(this.FLAG_CONTAINER_ID)

      // 国家名称
      Column() {
        Text(getLocalizedCountryName(this.country!, this.currentLanguage))
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 4 })

        Text(this.isEnglish ? this.country!.nameCN : this.country!.name)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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

          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.capital').id), this.getCountryCapital())
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.region').id), this.getRegionName(this.country!.region))
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.population').id), this.formatPopulation(this.country!.population))
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.area').id), this.formatArea(this.country!.area))
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.country_code').id), this.country!.code.toUpperCase())
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

          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.flag_proportion').id), this.getFlagProportion())
          Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
          this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.adopted_date').id), this.getFlagAdopted())
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
      .margin({ top: 16 })

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
        .focusable(!this.isWearable)
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
        .focusable(!this.isWearable)
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

  @Builder
  buildContent() {
    if (this.internationalOrg) {
      this.buildInternationalOrgContent()
    } else if (this.country) {
      this.buildCountryContent()
    } else {
      Column() {
        Text($r('app.string.country_info_load_failed'))
          .fontSize(16)
          .fontColor($r('app.color.text_tertiary'))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  build() {
    if (this.isWearable) {
      Column() {
        Scroll() {
          this.buildContent()
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .scrollable(ScrollDirection.Vertical)
        .focusable(true)
        .defaultFocus(true)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
    } else {
      Navigation() {
        Scroll() {
          Row() {
            Column() {
              this.buildContent()
            }
            .width('100%')
            .constraintSize({ maxWidth: getContentMaxWidth() })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .scrollable(ScrollDirection.Vertical)
        .focusable(true)
        .defaultFocus(true)
        .backgroundColor($r('app.color.bg_page'))
      }
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
      .backgroundColor($r('app.color.bg_page'))
      .menus(this.MenuBuilder)
    }
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
      Image($r('app.media.icon_voice'))
        .width(24)
        .height(24)
        .onClick(() => {
          this.onReadClick();
        })

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
  DescriptionItem(label: string, value: string) {
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
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  InfoItem(label: string, value: string) {
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
  }

  private getCountryCapital(): string {
    if (!this.country) return '';
    return getLocalizedCapital(this.country, this.currentLanguage);
  }

  private getRegionName(region: string): string {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      let resource: Resource;
      switch (region) {
        case 'Asia':
          resource = $r('app.string.region_asia');
          break;
        case 'Europe':
          resource = $r('app.string.region_europe');
          break;
        case 'Africa':
          resource = $r('app.string.region_africa');
          break;
        case 'Americas':
          resource = $r('app.string.region_americas');
          break;
        case 'Oceania':
          resource = $r('app.string.region_oceania');
          break;
        default:
          return region; // fallback to original region name
      }
      return context.resourceManager.getStringSync(resource.id);
    } catch (e) {
      return region; // fallback
    }
  }

  private formatPopulation(population: number): string {
    const rm = this.context.resourceManager;
    if (this.isEnglish) {
      if (population >= 1000000000) {
        return (population / 1000000000).toFixed(2) + rm.getStringSync($r('app.string.population_unit_billion').id);
      } else if (population >= 1000000) {
        return (population / 1000000).toFixed(2) + rm.getStringSync($r('app.string.population_unit_million').id);
      } else if (population >= 1000) {
        return (population / 1000).toFixed(0) + rm.getStringSync($r('app.string.population_unit_thousand').id);
      }
      return population.toString() + rm.getStringSync($r('app.string.population_unit_person').id);
    } else {
      if (population >= 100000000) {
        return (population / 100000000).toFixed(2) + rm.getStringSync($r('app.string.population_unit_billion').id);
      } else if (population >= 10000) {
        return (population / 10000).toFixed(0) + rm.getStringSync($r('app.string.population_unit_million').id);
      }
      return population.toString() + rm.getStringSync($r('app.string.population_unit_person').id);
    }
  }

  private formatArea(area: number): string {
    const rm = this.context.resourceManager;
    if (this.isEnglish) {
      if (area >= 1000000) {
        return (area / 1000000).toFixed(2) + rm.getStringSync($r('app.string.area_unit_million_km2').id);
      } else if (area >= 1000) {
        return (area / 1000).toFixed(2) + rm.getStringSync($r('app.string.area_unit_thousand_km2').id);
      }
      return area.toFixed(0) + rm.getStringSync($r('app.string.area_unit_km2').id);
    } else {
      if (area >= 10000) {
        return (area / 10000).toFixed(2) + rm.getStringSync($r('app.string.area_unit_million_km2').id);
      }
      return area.toFixed(0) + rm.getStringSync($r('app.string.area_unit_km2').id);
    }
  }

  private getFlagDesignDescription(): string {
    return getLocalizedFlagDesign(this.flagDesign, this.currentLanguage);
  }

  private getFlagDescription(): string {
    if (!this.country) {
      return '';
    }

    // 使用 flagDesign 中的描述
    if (this.flagDesign) {
      return this.getFlagDesignDescription();
    }

    // 默认描述
    const countryName = this.isEnglish ? this.country.name : this.country.nameCN;
    return this.context.resourceManager.getStringSync($r('app.string.default_flag_description').id, countryName);
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

  private getInternationalOrgDescription(): string {
    if (!this.internationalOrg) return '';
    if (this.isEnglish && this.internationalOrg.descriptionEN) {
      return this.internationalOrg.descriptionEN;
    }
    return this.internationalOrg.description || '';
  }

  private getReadContent(): string {
    const lines: string[] = [];
    const rm = this.context.resourceManager;

    if (this.internationalOrg) {
      const orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      const orgNameOther = this.isEnglish ? this.internationalOrg.nameCN : this.internationalOrg.name;
      const headquarters = getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage);
      const orgType = this.isEnglish ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN;
      const region = this.getRegionName(this.internationalOrg.region);
      const description = this.isEnglish && this.internationalOrg.descriptionEN ? this.internationalOrg.descriptionEN : (this.internationalOrg.description || '');

      lines.push(orgName + rm.getStringSync($r('app.string.read_other_name').id, orgNameOther));
      lines.push(rm.getStringSync($r('app.string.read_org_headquarters').id, headquarters));
      lines.push(rm.getStringSync($r('app.string.read_org_region').id, region));
      lines.push(rm.getStringSync($r('app.string.read_org_type').id, orgType));
      lines.push(rm.getStringSync($r('app.string.read_org_population').id, this.formatPopulation(this.internationalOrg.population)));
      if (this.internationalOrg.website) {
        lines.push(rm.getStringSync($r('app.string.read_org_website').id, this.internationalOrg.website));
      }
      if (description) {
        lines.push(description);
      }

    } else if (this.country) {
      const countryName = getLocalizedCountryName(this.country, this.currentLanguage);
      const countryNameOther = this.isEnglish ? this.country.nameCN : this.country.name;
      const capital = this.getCountryCapital();
      const region = this.getRegionName(this.country.region);

      lines.push(countryName + rm.getStringSync($r('app.string.read_other_name').id, countryNameOther));
      lines.push(rm.getStringSync($r('app.string.read_capital').id, capital));
      lines.push(rm.getStringSync($r('app.string.read_region').id, region));
      lines.push(rm.getStringSync($r('app.string.read_population').id, this.formatPopulation(this.country.population)));
      lines.push(rm.getStringSync($r('app.string.read_area').id, this.formatArea(this.country.area)));
      lines.push(rm.getStringSync($r('app.string.read_flag_proportion').id, this.getFlagProportion()));
      lines.push(rm.getStringSync($r('app.string.read_adopted_date').id, this.getFlagAdopted()));
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
      try {
        let title: string;
        if (this.internationalOrg) {
          title = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
        } else if (this.country) {
          title = getLocalizedCountryName(this.country, this.currentLanguage);
        } else {
          title = this.context.resourceManager.getStringSync($r('app.string.details').id);
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

      // 截取分享容器内容
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

      // 获取文件URI
      const imageUri = fileUri.getUriFromPath(tempFilePath);

      // 获取图片类型描述符
      const utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg', uniformTypeDescriptor.UniformDataType.IMAGE);

      // 使用图片URI分享
      let orgName: string;
      if (this.internationalOrg) {
        orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      } else if (this.country) {
        orgName = getLocalizedCountryName(this.country, this.currentLanguage);
      } else {
        orgName = this.context.resourceManager.getStringSync($r('app.string.details').id);
      }
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${orgName}${this.internationalOrg ? this.context.resourceManager.getStringSync($r('app.string.flag').id) : this.context.resourceManager.getStringSync($r('app.string.national_flag').id)}`, 
        description: this.context.resourceManager.getStringSync($r('app.string.from_app').id)
      });

      const controller = new systemShare.ShareController(shareData);

      // 显示分享面板
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      // 分享成功后释放 PixelMap
      this.releaseSharePixelMap();

      // 延迟删除文件，确保分享完成
      setTimeout(() => {
        if (tempFilePath) {
          try {
            fs.unlinkSync(tempFilePath);
          } catch (unlinkError) {
            console.warn('[FlagDetailPage] Failed to delete temp file:', unlinkError);
          }
        }
      }, 5000);

    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to share: code: ${error?.code}, message: ${error?.message}`);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
        duration: 2000
      });

      // 清理资源
      this.releaseSharePixelMap();
      if (tempFilePath) {
        try {
          fs.unlinkSync(tempFilePath);
        } catch (e) {
          // ignore
        }
      }
    } finally {
      this.isSharing = false;
    }
  }

  private buildShareText(): string {
    const lines: string[] = [];
    const rm = this.context.resourceManager;

    if (this.internationalOrg) {
      const orgName = getLocalizedOrgName(this.internationalOrg, this.currentLanguage);
      const orgNameOther = this.isEnglish ? this.internationalOrg.nameCN : this.internationalOrg.name;
      const headquarters = getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage);
      const orgType = this.isEnglish ? this.internationalOrg.orgType : this.internationalOrg.orgTypeCN;
      const region = this.getRegionName(this.internationalOrg.region);
      const description = this.isEnglish && this.internationalOrg.descriptionEN ? this.internationalOrg.descriptionEN : (this.internationalOrg.description || '');

      lines.push(`🏳️ ${orgName} (${orgNameOther})`);
      lines.push('');
      lines.push(rm.getStringSync($r('app.string.share_headquarters').id) + headquarters);
      lines.push(rm.getStringSync($r('app.string.share_region').id) + region);
      lines.push(rm.getStringSync($r('app.string.share_org_type').id) + orgType);
      lines.push(rm.getStringSync($r('app.string.share_coverage_population').id) + this.formatPopulation(this.internationalOrg.population));
      if (this.internationalOrg.website) {
        lines.push(rm.getStringSync($r('app.string.share_website').id) + this.internationalOrg.website);
      }
      if (description) {
        lines.push('');
        lines.push(rm.getStringSync($r('app.string.share_introduction').id) + description);
      }
    } else if (this.country) {
      const countryName = getLocalizedCountryName(this.country, this.currentLanguage);
      const countryNameOther = this.isEnglish ? this.country.nameCN : this.country.name;
      const capital = this.getCountryCapital();
      const region = this.getRegionName(this.country.region);

      lines.push(`🏳️ ${countryName} (${countryNameOther})`);
      lines.push('');
      lines.push(rm.getStringSync($r('app.string.share_capital').id) + capital);
      lines.push(rm.getStringSync($r('app.string.share_region').id) + region);
      lines.push(rm.getStringSync($r('app.string.share_population').id) + this.formatPopulation(this.country.population));
      lines.push(rm.getStringSync($r('app.string.share_area').id) + this.formatArea(this.country.area));

      if (this.flagDesign) {
        lines.push('');
        lines.push(rm.getStringSync($r('app.string.share_flag_proportion').id) + this.flagDesign.proportion);
        lines.push(rm.getStringSync($r('app.string.share_adopted_date').id) + this.flagDesign.adopted);
        const designDesc = this.getFlagDesignDescription();
        if (designDesc) {
          lines.push('');
          lines.push(rm.getStringSync($r('app.string.share_design').id) + designDesc);
        }
      }
    } else {
      return '';
    }

    lines.push('');
    lines.push(`—— ${rm.getStringSync($r('app.string.from_app').id)}`);

    return lines.join('\n');
  }

  @Builder
  ShareContentBuilder() {
    if (this.internationalOrg) {
      // 国际组织分享内容
      Column({ space: 16 }) {
        // 旗帜图片
        Column() {
          Image(getFlagImageSource(this.internationalOrg!.code))
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_page'))

        // 组织名称
        Column() {
          Text(getLocalizedOrgName(this.internationalOrg!, this.currentLanguage))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          Text(this.isEnglish ? this.internationalOrg!.nameCN : this.internationalOrg!.name)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
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

            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.headquarters').id), getLocalizedOrgHeadquarters(this.internationalOrg!, this.currentLanguage))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.region').id), this.getRegionName(this.internationalOrg!.region))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.org_type').id), this.isEnglish ? this.internationalOrg!.orgType : this.internationalOrg!.orgTypeCN)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.coverage_population').id), this.formatPopulation(this.internationalOrg!.population))
            if (this.internationalOrg!.website) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.website').id), this.internationalOrg!.website)
            }
            if (this.internationalOrg!.description || this.internationalOrg!.descriptionEN) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.DescriptionItem(this.context.resourceManager.getStringSync($r('app.string.description').id), this.getInternationalOrgDescription())
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
          Image(getFlagImageSource(this.country!.code))
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_page'))

        // 国家名称
        Column() {
          Text(getLocalizedCountryName(this.country!, this.currentLanguage))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          Text(this.isEnglish ? this.country!.nameCN : this.country!.name)
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

            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.capital').id), this.getCountryCapital())
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.region').id), this.getRegionName(this.country!.region))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.population').id), this.formatPopulation(this.country!.population))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.area').id), this.formatArea(this.country!.area))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.country_code').id), this.country!.code.toUpperCase())
          }
          .padding(16)
            .layoutWeight(1)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(16)
        }
        .width('100%')
          .padding({ left: 16, right: 16 })

        // 关于这面国旗
        if (this.flagDesign) {
          Row() {
            Column() {
              Text($r('app.string.about_flag'))
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.flag_proportion').id), this.getFlagProportion())
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem(this.context.resourceManager.getStringSync($r('app.string.adopted_date').id), this.getFlagAdopted())
              if (this.flagDesign.designCN) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.DescriptionItem(this.context.resourceManager.getStringSync($r('app.string.description').id), this.getFlagDesignDescription())
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
      }
      .width('100%')
        .padding({ top: 20, bottom: 20 })
        .backgroundColor($r('app.color.bg_page'))
    }
  }
}