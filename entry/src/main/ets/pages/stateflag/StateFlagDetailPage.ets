import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { image } from '@kit.ImageKit';
import { CountryStateData, StateInfo, getCountryStateData, getStateFlagPath } from '../../utils/StateFlagData';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { SaveFlagDialog } from '../../components/SaveFlagDialog';

interface RouterParams {
  countryCode: string;
  stateCode: string;
}

@Entry
@Component
struct StateFlagDetailPage {
  @State countryData: CountryStateData | undefined = undefined;
  @State stateInfo: StateInfo | undefined = undefined;
  @State isLoading: boolean = true;
  @State flagPixelMap: image.PixelMap | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private readonly FLAG_CONTAINER_ID = 'stateFlagContainer';
  private saveDialogController: CustomDialogController | null = null;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    // 延迟加载以显示loading状态
    setTimeout(() => {
      if (params && params.countryCode && params.stateCode) {
        this.countryData = getCountryStateData(params.countryCode);
        if (this.countryData) {
          this.stateInfo = this.countryData.states.find(s => s.code === params.stateCode);
        }
      }
      this.isLoading = false;
    }, 600);

    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());
  }

  private releaseFlagPixelMap(): void {
    if (this.flagPixelMap) {
      try {
        this.flagPixelMap.release();
      } catch (e) {
        console.warn('[StateFlagDetailPage] Failed to release pixelmap:', e);
      }
      this.flagPixelMap = null;
    }
  }

  private async onDownloadClick(): Promise<void> {
    if (!this.countryData || !this.stateInfo) return;

    try {
      promptAction.showToast({
        message: '正在准备图片...',
        duration: 1000
      });

      const pixmap = await screenshotManager.captureSnapshot(this.FLAG_CONTAINER_ID);
      if (!pixmap) {
        promptAction.showToast({
          message: '截取图片失败',
          duration: 2000
        });
        return;
      }

      this.flagPixelMap = pixmap;

      this.saveDialogController = new CustomDialogController({
        builder: SaveFlagDialog({
          pixelMap: this.flagPixelMap,
          onClose: () => {
            this.releaseFlagPixelMap();
          },
          onSaveSuccess: () => {
            promptAction.showToast({
              message: '旗帜图片已保存到相册',
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
      console.error('[StateFlagDetailPage] Download error:', error);
      promptAction.showToast({
        message: '下载失败',
        duration: 2000
      });
    }
  }

  private async doSaveFlag(): Promise<void> {
    if (!this.flagPixelMap || !this.stateInfo) {
      throw new Error('图片或州旗信息不存在');
    }

    const fileName = screenshotManager.generateFileName('州旗', this.stateInfo.nameCN);
    const success = await screenshotManager.saveToGallery(
      this.flagPixelMap,
      fileName,
      this.context,
      false
    );

    if (!success) {
      throw new Error('保存到相册失败');
    }
  }

  build() {
    Navigation() {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text('加载中...')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.bg_page'))
      } else if (this.countryData && this.stateInfo) {
        Scroll() {
          Column() {
            // 州旗图片
            Column() {
              Image($rawfile(getStateFlagPath(this.countryData.countryCode, this.stateInfo.code)))
                .width('100%')
                .height(240)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .padding({ top: 32, bottom: 32, left: 24, right: 24 })
            .backgroundColor($r('app.color.bg_secondary'))
            .id(this.FLAG_CONTAINER_ID)

            // 州名称
            Column() {
              Text(this.stateInfo.nameCN)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .textAlign(TextAlign.Center)
                .margin({ bottom: 4 })

              Text(this.stateInfo.name)
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 20, bottom: 16 })
            .alignItems(HorizontalAlign.Center)

            // 基本信息卡片
            Row() {
              Column() {
                Text('基本信息')
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .alignSelf(ItemAlign.Start)
                  .margin({ bottom: 16 })

                this.InfoRow('所属国家', `${this.countryData.countryEmoji} ${this.countryData.countryNameCN}`)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoRow('首府', this.stateInfo.capitalCN)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoRow('地区', this.stateInfo.regionCN)
              }
              .padding(20)
              .layoutWeight(1)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 16, bottom: 16 })
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
          Text('暂无数据')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.bg_page'))
      }
    }
    .title(this.stateInfo?.nameCN || '州旗详情')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
    .menus(this.MenuBuilder)
  }

  @Builder
  MenuBuilder() {
    Row() {
      Image($r('app.media.icon_download'))
        .width(22)
        .height(22)
        .onClick(() => {
          this.onDownloadClick();
        })
    }
    .height('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Center)
    .padding({ right: 16 })
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .width(80)

      Text(value)
        .fontSize(15)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
  }
}

