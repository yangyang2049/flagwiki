import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { Country, getCountryByCode, FlagDesign, getFlagDesign, getFlagImageSource, InternationalOrg, getInternationalOrgByCode, isInternationalOrg } from '../../utils/countryData';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { SaveFlagDialog } from '../../components/SaveFlagDialog';
import { FavoritesManager } from '../../utils/favoritesManager';
import { getCoatOfArmsImageSource } from '../../utils/coatOfArmsUtil';
import { getFlagHistory, FlagHistoryItem } from '../../utils/FlagHistoryData';

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
  @State flagHistoryItems: FlagHistoryItem[] = [];
  @State sharePixelMap: image.PixelMap | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private readonly FLAG_CONTAINER_ID = 'flagImageContainer';
  private readonly FLAG_DOWNLOAD_CONTAINER_ID = 'flagDownloadContainer';
  private readonly SHARE_CONTAINER_ID = 'flagShareContainer';
  private countryCode: string = '';

  // 保存对话框控制器
  private saveDialogController: CustomDialogController = new CustomDialogController({
    builder: SaveFlagDialog({
      pixelMap: this.flagPixelMap,
      onClose: () => {
        this.releaseFlagPixelMap();
      },
      onSaveSuccess: () => {
        promptAction.showToast({
          message: '国旗图片已保存到相册',
          duration: 2000
        });
        this.releaseFlagPixelMap();
      },
      onSaveError: (error: Error) => {
        promptAction.showToast({
          message: `保存失败: ${error.message}`,
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
    const name = this.internationalOrg?.nameCN || this.country?.nameCN || '未知';
    const pageUrl = `flag:${this.countryCode}`;

    if (this.isFavorite) {
      await FavoritesManager.removeFavorite(pageUrl);
      this.isFavorite = false;
      promptAction.showToast({
        message: '已取消收藏',
        duration: 2000
      });
    } else {
      await FavoritesManager.addFavorite({ name: name, pageUrl: pageUrl });
      this.isFavorite = true;
      promptAction.showToast({
        message: '已添加到收藏',
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
        message: '正在准备图片...',
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
          message: '截取图片失败',
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
              message: '国旗图片已保存到相册',
              duration: 2000
            });
          },
          onSaveError: (error: Error) => {
            promptAction.showToast({
              message: `保存失败: ${error.message}`,
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
        message: '下载失败',
        duration: 2000
      });
    }
  }

  private async doSaveFlag(): Promise<void> {
    if (!this.flagPixelMap || (!this.country && !this.internationalOrg)) {
      throw new Error('图片或组织信息不存在');
    }

    const name = this.internationalOrg?.nameCN || this.country?.nameCN || '未知';
    const fileName = screenshotManager.generateFileName('旗帜', name);
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

          // 组织名称
          Column() {
            Text(this.internationalOrg.nameCN)
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: 4 })

            Text(this.internationalOrg.name)
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
              Text('基本信息')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              this.InfoItem('总部', this.internationalOrg.headquartersCN)
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem('地区', this.internationalOrg.region)
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem('组织类型', this.internationalOrg.orgTypeCN)
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem('覆盖人口', this.formatPopulation(this.internationalOrg.population))
              if (this.internationalOrg.website) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('网站', this.internationalOrg.website)
              }
              if (this.internationalOrg.description) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.DescriptionItem('简介', this.internationalOrg.description)
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
                Text(this.isFavorite ? '已收藏' : '收藏')
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
                Text('下载')
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
    Navigation() {
      if (this.internationalOrg) {
        this.buildInternationalOrgPage()
      } else if (this.country) {
        Scroll() {
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

            // 国家名称
            Column() {
              Text(this.country.nameCN)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 4 })

              Text(this.country.name)
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
                Text('基本信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 16 })
                  .alignSelf(ItemAlign.Start)

                this.InfoItem('首都', this.country.capitalCN)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('所属地区', this.getRegionName(this.country.region))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('人口', this.formatPopulation(this.country.population))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('面积', this.formatArea(this.country.area))
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('国家代码', this.country.code.toUpperCase())
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
                Text('关于这面国旗')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 16 })
                  .alignSelf(ItemAlign.Start)

                this.InfoItem('国旗比例', this.getFlagProportion())
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoItem('采用日期', this.getFlagAdopted())
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

            // 历史国旗banner（如果有历史数据且是国家，显示在国徽前面）
            if (this.country && this.flagHistoryItems && this.flagHistoryItems.length > 0) {
              this.HistoricalFlagsBanner()
            }

            // 国徽（如果有）
            if (this.coatOfArmsResource) {
              Row() {
                Column() {
                  Text('国徽')
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
                  Text(this.isFavorite ? '已收藏' : '收藏')
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
                  Text('下载')
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
          Text('国家信息加载失败')
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

  private getRegionName(region: string): string {
    const regionMap: Record<string, string> = {
      'Asia': '亚洲',
      'Europe': '欧洲',
      'Africa': '非洲',
      'Americas': '美洲',
      'Oceania': '大洋洲'
    };
    return regionMap[region] || region;
  }

  private formatPopulation(population: number): string {
    if (population >= 100000000) {
      return (population / 100000000).toFixed(2) + ' 亿人';
    } else if (population >= 10000) {
      return (population / 10000).toFixed(0) + ' 万人';
    }
    return population.toString() + ' 人';
  }

  private formatArea(area: number): string {
    if (area >= 10000) {
      return (area / 10000).toFixed(2) + ' 万平方公里';
    }
    return area.toFixed(0) + ' 平方公里';
  }

  private getFlagDescription(): string {
    if (!this.country) {
      return '';
    }

    // 使用 flagDesign 中的中文描述
    if (this.flagDesign && this.flagDesign.designCN) {
      return this.flagDesign.designCN;
    }

    return `${this.country.nameCN}的国旗是这个国家的重要象征，代表着国家的历史、文化和价值观。`;
  }

  private getFlagProportion(): string {
    if (this.flagDesign && this.flagDesign.proportion) {
      return this.flagDesign.proportion;
    }
    return '未知';
  }

  private getFlagAdopted(): string {
    if (this.flagDesign && this.flagDesign.adopted) {
      return this.flagDesign.adopted;
    }
    return '未知';
  }

  private getReadContent(): string {
    const lines: string[] = [];

    if (this.internationalOrg) {
      lines.push(`${this.internationalOrg.nameCN}，英文名${this.internationalOrg.name}。`);
      lines.push(`总部位于${this.internationalOrg.headquartersCN}。`);
      lines.push(`地区是${this.internationalOrg.region}。`);
      lines.push(`组织类型是${this.internationalOrg.orgTypeCN}。`);
      lines.push(`覆盖人口约${this.formatPopulation(this.internationalOrg.population)}。`);
      if (this.internationalOrg.website) {
        lines.push(`网站：${this.internationalOrg.website}。`);
      }
      if (this.internationalOrg.description) {
        lines.push(`${this.internationalOrg.description}`);
      }
    } else if (this.country) {
      lines.push(`${this.country.nameCN}，英文名${this.country.name}。`);
      lines.push(`首都是${this.country.capitalCN}。`);
      lines.push(`所属地区是${this.getRegionName(this.country.region)}。`);
      lines.push(`人口${this.formatPopulation(this.country.population)}。`);
      lines.push(`面积${this.formatArea(this.country.area)}。`);
      lines.push(`国旗比例为${this.getFlagProportion()}。`);
      lines.push(`采用日期是${this.getFlagAdopted()}。`);
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
        message: '已停止朗读',
        duration: 2000
      });
    } else {
      try {
        const title = this.internationalOrg?.nameCN || this.country?.nameCN || '详情';
        const content = this.getReadContent();
        await TextReaderUtil.startRead(this.context, title, content);
        this.isReading = true;
        promptAction.showToast({
          message: '开始朗读',
          duration: 2000
        });
      } catch (err) {
        console.error(`Failed to start read: ${JSON.stringify(err)}`);
        promptAction.showToast({
          message: '朗读功能暂不可用',
          duration: 2000
        });
      }
    }
  }

  private async onShareClick(): Promise<void> {
    if (this.isSharing || (!this.country && !this.internationalOrg)) return;

    this.isSharing = true;
    promptAction.showToast({
      message: '正在准备分享...',
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
          message: '截取图片失败',
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
      const orgName = this.internationalOrg?.nameCN || this.country?.nameCN || '详情';
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${orgName}${this.internationalOrg ? '旗帜' : '国旗'}`,
        description: '来自国旗小百科'
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
        message: '分享失败',
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

    if (this.internationalOrg) {
      lines.push(`🏳️ ${this.internationalOrg.nameCN} (${this.internationalOrg.name})`);
      lines.push('');
      lines.push(`📍 总部：${this.internationalOrg.headquartersCN}`);
      lines.push(`🌍 地区：${this.internationalOrg.region}`);
      lines.push(`🏛️ 组织类型：${this.internationalOrg.orgTypeCN}`);
      lines.push(`👥 覆盖人口：${this.formatPopulation(this.internationalOrg.population)}`);
      if (this.internationalOrg.website) {
        lines.push(`🌐 网站：${this.internationalOrg.website}`);
      }
      if (this.internationalOrg.description) {
        lines.push('');
        lines.push(`📝 简介：${this.internationalOrg.description}`);
      }
    } else if (this.country) {
      lines.push(`🏳️ ${this.country.nameCN} (${this.country.name})`);
      lines.push('');
      lines.push(`📍 首都：${this.country.capitalCN}`);
      lines.push(`🌍 地区：${this.getRegionName(this.country.region)}`);
      lines.push(`👥 人口：${this.formatPopulation(this.country.population)}`);
      lines.push(`📐 面积：${this.formatArea(this.country.area)}`);

      if (this.flagDesign) {
        lines.push('');
        lines.push(`📏 国旗比例：${this.flagDesign.proportion}`);
        lines.push(`📅 采用日期：${this.flagDesign.adopted}`);
        if (this.flagDesign.designCN) {
          lines.push('');
          lines.push(`🎨 ${this.flagDesign.designCN}`);
        }
      }
    } else {
      return '';
    }

    lines.push('');
    lines.push('—— 来自「国旗小百科」');

    return lines.join('\n');
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
          Text(this.internationalOrg.nameCN)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          Text(this.internationalOrg.name)
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
            Text('基本信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            this.InfoItem('总部', this.internationalOrg.headquartersCN)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('地区', this.internationalOrg.region)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('组织类型', this.internationalOrg.orgTypeCN)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('覆盖人口', this.formatPopulation(this.internationalOrg.population))
            if (this.internationalOrg.website) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem('网站', this.internationalOrg.website)
            }
            if (this.internationalOrg.description) {
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.DescriptionItem('简介', this.internationalOrg.description)
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
          Text(this.country.nameCN)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 })

          Text(this.country.name)
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
            Text('基本信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            this.InfoItem('首都', this.country.capitalCN)
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('所属地区', this.getRegionName(this.country.region))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('人口', this.formatPopulation(this.country.population))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('面积', this.formatArea(this.country.area))
            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
            this.InfoItem('国家代码', this.country.code.toUpperCase())
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
              Text('关于这面国旗')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              this.InfoItem('国旗比例', this.getFlagProportion())
              Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
              this.InfoItem('采用日期', this.getFlagAdopted())
              if (this.flagDesign.designCN) {
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.DescriptionItem('设计说明', this.flagDesign.designCN)
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

  @Builder
  HistoricalFlagsBanner() {
    Row() {
      Column() {
        // 标题行 - 完全复制涂鸦说明的样式
        Row() {
          Text('历史国旗')
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

        // 历史国旗Grid（最多显示3个，只显示一行）
        Grid() {
          ForEach(this.flagHistoryItems.slice(0, 3), (item: FlagHistoryItem, index: number) => {
            GridItem() {
              Column() {
                Image($rawfile(`flag_history/${item.imagePath}.webp`))
                  .width('100%')
                  .height(60)
                  .objectFit(ImageFit.Contain)
                  .borderRadius(4)
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
}

