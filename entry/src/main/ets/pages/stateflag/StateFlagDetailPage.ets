import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { image } from '@kit.ImageKit';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { CountryStateData, StateInfo, getCountryStateData, getStateFlagPath } from '../../utils/StateFlagData';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { SaveFlagDialog } from '../../components/SaveFlagDialog';
import { FavoritesManager } from '../../utils/favoritesManager';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

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
  @State isFavorite: boolean = false;
  @State isReading: boolean = false;
  @State isSharing: boolean = false;
  @State sharePixelMap: image.PixelMap | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private readonly FLAG_CONTAINER_ID = 'stateFlagContainer';
  private readonly FLAG_DOWNLOAD_CONTAINER_ID = 'stateFlagDownloadContainer';
  private readonly SHARE_CONTAINER_ID = 'stateFlagShareContainer';
  private saveDialogController: CustomDialogController | null = null;
  private countryCode: string = '';
  private stateCode: string = '';

  async aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params && params.countryCode && params.stateCode) {
      this.countryCode = params.countryCode;
      this.stateCode = params.stateCode;
    }

    // 延迟加载以显示loading状态
    setTimeout(async () => {
      if (this.countryCode && this.stateCode) {
        this.countryData = getCountryStateData(this.countryCode);
        if (this.countryData) {
          this.stateInfo = this.countryData.states.find(s => s.code === this.stateCode);
        }
      }
      this.isLoading = false;

      // 检查收藏状态
      await this.checkFavoriteStatus();
    }, 600);

    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());

    // 初始化收藏管理器
    await FavoritesManager.init(this.context);
  }

  private async checkFavoriteStatus(): Promise<void> {
    const pageUrl = `stateflag:${this.countryCode}:${this.stateCode}`;
    this.isFavorite = await FavoritesManager.isFavorite(pageUrl);
  }

  private async toggleFavorite(): Promise<void> {
    const name = this.stateInfo?.nameCN || this.context.resourceManager.getStringSync($r('app.string.unknown').id);
    const pageUrl = `stateflag:${this.countryCode}:${this.stateCode}`;

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
        console.warn('[StateFlagDetailPage] Failed to release pixelmap:', e);
      }
      this.flagPixelMap = null;
    }
  }

  private releaseSharePixelMap(): void {
    if (this.sharePixelMap) {
      try {
        this.sharePixelMap.release();
      } catch (e) {
        console.warn('[StateFlagDetailPage] Failed to release share pixelmap:', e);
      }
      this.sharePixelMap = null;
    }
  }

  private async onDownloadClick(): Promise<void> {
    if (!this.countryData || !this.stateInfo) return;

    try {
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.preparing_image').id),
        duration: 1000
      });

      // 先释放之前的 PixelMap，避免内存泄漏
      this.releaseFlagPixelMap();

      // 截取下载容器快照（无 padding）
      const pixmap = await screenshotManager.captureSnapshot(this.FLAG_DOWNLOAD_CONTAINER_ID);
      if (!pixmap) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.screenshot_failed').id),
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
              message: this.context.resourceManager.getStringSync($r('app.string.flag_saved_to_album').id),
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
      console.error('[StateFlagDetailPage] Download error:', error);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.download_failed').id),
        duration: 2000
      });
    }
  }

  private async doSaveFlag(): Promise<void> {
    if (!this.flagPixelMap || !this.stateInfo) {
      throw new Error(this.context.resourceManager.getStringSync($r('app.string.image_or_state_info_not_exist').id));
    }

    const fileName = screenshotManager.generateFileName(this.context.resourceManager.getStringSync($r('app.string.state_flag_details').id), this.stateInfo.nameCN);
    const success = await screenshotManager.saveToGallery(
      this.flagPixelMap,
      fileName,
      this.context,
      false
    );

    if (!success) {
      throw new Error(this.context.resourceManager.getStringSync($r('app.string.failed_to_save_to_album').id));
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
          Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
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
          Row() {
            Column() {
            // 隐藏的分享容器（包含州旗和基本信息）
            Column({ space: 16 }) {
              // 州旗图片
              Column() {
                Image($rawfile(getStateFlagPath(this.countryData.countryCode, this.stateInfo.code)))
                  .width('100%')
                  .height(200)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
                .padding(16)
                .backgroundColor($r('app.color.bg_page'))

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
                  Text(this.context.resourceManager.getStringSync($r('app.string.basic_info').id))
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .alignSelf(ItemAlign.Start)
                    .margin({ bottom: 16 })

                  this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.belongs_to_country').id), `${this.countryData.countryEmoji} ${this.countryData.countryNameCN}`)
                  Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                  this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.capital').id), this.stateInfo.capitalCN)
                  Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                  this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.region').id), this.stateInfo.regionCN)
                }
                .padding(20)
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
              .id(this.SHARE_CONTAINER_ID)
              .position({ x: -1000, y: -1000 })

            // 隐藏的下载容器（无 padding，仅用于截图）
            Column() {
              Image($rawfile(getStateFlagPath(this.countryData.countryCode, this.stateInfo.code)))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Fill)
            }
            .width(400)
            .height(240)
            .id(this.FLAG_DOWNLOAD_CONTAINER_ID)
            .position({ x: -1000, y: -1000 })

            // 州旗图片（展示用，有 padding）
            Column() {
              Image($rawfile(getStateFlagPath(this.countryData.countryCode, this.stateInfo.code)))
                .width('100%')
                .height(240)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .padding(16)
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
                Text(this.context.resourceManager.getStringSync($r('app.string.basic_info').id))
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .alignSelf(ItemAlign.Start)
                  .margin({ bottom: 16 })

                this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.belongs_to_country').id), `${this.countryData.countryEmoji} ${this.countryData.countryNameCN}`)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.capital').id), this.stateInfo.capitalCN)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InfoRow(this.context.resourceManager.getStringSync($r('app.string.region').id), this.stateInfo.regionCN)
              }
              .padding(20)
              .layoutWeight(1)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 16 })

            // 底部操作按钮
            Row({ space: 16 }) {
              // 收藏按钮
              Button() {
                Row({ space: 8 }) {
                  Image(this.isFavorite ? $r('app.media.icon_favorite_selected') : $r('app.media.icon_favorite'))
                    .width(20)
                    .height(20)
                  Text(this.isFavorite ? this.context.resourceManager.getStringSync($r('app.string.favorited').id) : this.context.resourceManager.getStringSync($r('app.string.favorite').id))
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
                  Text(this.context.resourceManager.getStringSync($r('app.string.download').id))
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
            .constraintSize({ maxWidth: getContentMaxWidth() })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor($r('app.color.bg_page'))
      } else {
        Column() {
          Text(this.context.resourceManager.getStringSync($r('app.string.no_data').id))
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.bg_page'))
      }
    }
    .title(this.stateInfo?.nameCN || this.context.resourceManager.getStringSync($r('app.string.state_flag_details').id))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
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

  private getReadContent(): string {
    if (!this.countryData || !this.stateInfo) {
      return '';
    }

    const lines: string[] = [];
    lines.push(`${this.stateInfo.nameCN}` + this.context.resourceManager.getStringSync($r('app.string.read_other_name').id, this.stateInfo.name));
    lines.push(this.context.resourceManager.getStringSync($r('app.string.read_state_belongs_to').id, this.countryData.countryNameCN));
    lines.push(this.context.resourceManager.getStringSync($r('app.string.read_state_capital').id, this.stateInfo.capitalCN));
    lines.push(this.context.resourceManager.getStringSync($r('app.string.read_state_region').id, this.stateInfo.regionCN));

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
        const title = this.stateInfo?.nameCN || this.context.resourceManager.getStringSync($r('app.string.state_flag_details').id);
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
    if (this.isSharing || !this.countryData || !this.stateInfo) return;

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
      tempFilePath = this.context.cacheDir + '/share_state_flag_' + timestamp + '.jpg';

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
      const stateName = this.stateInfo.nameCN;
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: this.context.resourceManager.getStringSync($r('app.string.share_state_flag_title').id, stateName),
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
            console.warn('[StateFlagDetailPage] Failed to delete temp file:', unlinkError);
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
    if (!this.countryData || !this.stateInfo) {
      return '';
    }

    const lines: string[] = [];
    lines.push(`🏳️ ${this.stateInfo.nameCN} (${this.stateInfo.name})`);
    lines.push('');
    lines.push(this.context.resourceManager.getStringSync($r('app.string.share_state_country').id) + `${this.countryData.countryEmoji} ${this.countryData.countryNameCN}`);
    lines.push(this.context.resourceManager.getStringSync($r('app.string.share_state_capital').id) + this.stateInfo.capitalCN);
    lines.push(this.context.resourceManager.getStringSync($r('app.string.share_state_region').id) + this.stateInfo.regionCN);
    lines.push('');
    lines.push('—— ' + this.context.resourceManager.getStringSync($r('app.string.from_app_plain').id));

    return lines.join('\n');
  }
}

