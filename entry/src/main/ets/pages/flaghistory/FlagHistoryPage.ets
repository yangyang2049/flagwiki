/**
 * 历史国旗详情页
 * 显示各国国旗的历史变迁
 */

import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { getFlagHistory, FlagHistoryItem } from '../../utils/FlagHistoryData';
import { getCountryByCode, getLocalizedCountryName } from '../../utils/countryData';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

@Entry
@Component
  struct FlagHistoryPage {
  @State countryCode: string = '';
  @State historyItems: FlagHistoryItem[] = [];
  @State countryName: string = '';
  @State isSharing: boolean = false;
  @State sharePixelMap: image.PixelMap | null = null;
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;
  private readonly SHARE_CONTAINER_ID = 'flagHistoryShareContainer';

  aboutToAppear() {
    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());

    const params = router.getParams() as Record<string, string>;
    if (params && params['countryCode']) {
      this.countryCode = params['countryCode'];
      this.loadHistoryData();
    }
  }

  private onLanguageChanged(): void {
    // 语言变化时更新国家名称
    if (this.countryCode) {
      this.updateCountryName();
    }
  }

  private loadHistoryData(): void {
    const items = getFlagHistory(this.countryCode);
    // 按年份倒序排序
    this.historyItems = items.slice().sort((a, b) => b.year - a.year);
    this.updateCountryName();
  }

  private updateCountryName(): void {
    const country = getCountryByCode(this.countryCode);
    if (country) {
      this.countryName = getLocalizedCountryName(country, this.currentLanguage);
    }
  }

  aboutToDisappear() {
    // 释放 PixelMap
    this.releaseSharePixelMap();
  }

  private releaseSharePixelMap(): void {
    if (this.sharePixelMap) {
      try {
        this.sharePixelMap.release();
      } catch (e) {
        console.warn('[FlagHistoryPage] Failed to release pixelmap:', e);
      }
      this.sharePixelMap = null;
    }
  }

  private async onShareClick(): Promise<void> {
    if (this.isSharing || this.historyItems.length === 0) return;

    this.isSharing = true;
    promptAction.showToast({
      message: this.context.resourceManager.getStringSync($r('app.string.preparing_share').id),
      duration: 1500
    });

    let tempFilePath: string | null = null;

    try {
      // 先释放之前的 PixelMap
      this.releaseSharePixelMap();

      // 截取页面内容
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
      // 参考 jifen 项目：使用 packing 方法而不是 packToData
      const imagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 90  // 参考 jifen 项目使用 90% 质量
      };
      
      const imageData: ArrayBuffer = await imagePacker.packing(pixmap, packOpts);
      console.info(`[FlagHistoryPage] Image packed, data size: ${imageData.byteLength} bytes`);

      // 保存到临时文件 - 参考 jifen 项目：使用同步文件操作
      // 使用与 jifen 项目相同的路径格式
      const timestamp = Date.now();
      tempFilePath = this.context.cacheDir + '/share_flag_history_' + timestamp + '.jpg';
      
      // 使用同步文件操作（参考 jifen 项目）
      const fileHandle = fs.openSync(tempFilePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(fileHandle.fd, imageData);
      fs.closeSync(fileHandle);
      
      // 验证文件是否存在且不为空
      const stat = fs.statSync(tempFilePath);
      if (stat.size === 0) {
        throw new Error('Image file is empty');
      }
      
      console.info(`[FlagHistoryPage] Image file created: ${tempFilePath}, size: ${stat.size} bytes`);

      // 获取文件URI - 参考 jifen 项目：直接使用 fileUri.getUriFromPath
      const imageUri = fileUri.getUriFromPath(tempFilePath);
      console.info(`[FlagHistoryPage] Image URI: ${imageUri}`);
      
      // 获取图片类型描述符 - 完全按照 jifen 项目的方式
      const utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg', uniformTypeDescriptor.UniformDataType.IMAGE);
      console.info(`[FlagHistoryPage] UTD Type ID: ${utdTypeId}`);

      // 使用图片URI分享 - 参考 jifen 项目：使用 DETAIL 预览模式
      const historicalFlagsText = this.context.resourceManager.getStringSync($r('app.string.historical_flags').id);
      const fromAppText = this.context.resourceManager.getStringSync($r('app.string.from_app').id);
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${this.countryName} ${historicalFlagsText}`,
        description: fromAppText
      });
      
      console.info(`[FlagHistoryPage] ShareData created: utd=${utdTypeId}, uri=${imageUri}`);

      const controller = new systemShare.ShareController(shareData);
      
      // 显示分享面板
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL  // 参考 jifen 项目使用 DETAIL
      });

      console.info('[FlagHistoryPage] Share panel opened successfully');
      
      // 分享成功后释放 PixelMap
      // 注意：不立即删除文件，让分享系统有时间访问文件
      // 参考 jifen 项目，它们也不删除临时文件
      this.releaseSharePixelMap();
      
      // 延迟删除文件，确保分享完成
      setTimeout(() => {
        if (tempFilePath) {
          try {
            fs.unlinkSync(tempFilePath);
            console.info(`[FlagHistoryPage] Temp file deleted: ${tempFilePath}`);
          } catch (unlinkError) {
            console.warn('[FlagHistoryPage] Failed to delete temp file:', unlinkError);
          }
        }
      }, 5000); // 5秒后删除

    } catch (err) {
      const error = err as BusinessError;
      console.error(`[FlagHistoryPage] Failed to share: code: ${error?.code}, message: ${error?.message}`);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
        duration: 2000
      });
      
      // 清理资源
      this.releaseSharePixelMap();
      if (tempFilePath) {
        try {
          await fs.unlink(tempFilePath);
        } catch (unlinkError) {
          console.warn('[FlagHistoryPage] Failed to delete temp file on error:', unlinkError);
        }
      }
    } finally {
      this.isSharing = false;
    }
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 隐藏的分享容器（用于截图）
          Column() {
            if (this.historyItems.length > 0) {
              this.ShareContentBuilder()
            }
          }
          .id(this.SHARE_CONTAINER_ID)
          .position({ x: -1000, y: -1000 })
          .width(400)
          .backgroundColor($r('app.color.bg_page'))

          if (this.historyItems.length === 0) {
            // 无历史数据
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.no_data').id))
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 100 })
            }
            .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
          } else {
            // 显示历史国旗列表
            Column() {
              this.HistoryContentBuilder()
            }
            .width('100%')
              .padding({ left: 16, right: 16 })
          }
        }
        .width('100%')
          .padding({ bottom: 20 })
      }
      .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor($r('app.color.bg_page'))
    }
    .title('')
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .menus(this.MenuBuilder)
      .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
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
  ShareContentBuilder() {
    Column() {
      // 标题
      Text(`${this.countryName} ${this.context.resourceManager.getStringSync($r('app.string.flag_history').id)}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 20 })
        .alignSelf(ItemAlign.Start)

      // 历史国旗列表（按年份倒序）
      ForEach(this.historyItems, (item: FlagHistoryItem, index: number) => {
        Row() {
          // 左侧时间线
          Column() {
            // 时间线上的点
            Circle()
              .width(12)
              .height(12)
              .fill($r('app.color.button_primary'))

            // 时间线（竖线）
            Column()
              .width(2)
              .height(180)
              .backgroundColor($r('app.color.text_secondary'))
              .opacity(0.25)
              .margin({ top: 1 })
          }
          .width(24)
            .alignItems(HorizontalAlign.Center)
            .margin({ right: 16 })

          // 右侧内容
          Column() {
            // 年份标签
            Row() {
              Text(item.year.toString())
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              if (index === 0) {
                Text(this.context.resourceManager.getStringSync($r('app.string.current').id))
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ left: 2 })
              }
            }
            .width('100%')
              .margin({ bottom: 4 })
              .alignItems(VerticalAlign.Center)

            // 国旗图片（更窄）
            Image($rawfile(`flag_history/${item.imagePath}.webp`))
              .width('60%')
              .height(160)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })
              .alignSelf(ItemAlign.Start)
          }
            .width('100%')
            .padding({ left: 12, right: 12 })
            .borderRadius(16)
        }
        .width('100%')
          .margin({ bottom: 12 })
      })
    }
    .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  HistoryContentBuilder() {
    Column() {
      // 标题
      Text(`${this.countryName} ${this.context.resourceManager.getStringSync($r('app.string.flag_history').id)}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 20 })
        .alignSelf(ItemAlign.Start)

      // 历史国旗列表（按年份倒序）
      ForEach(this.historyItems, (item: FlagHistoryItem, index: number) => {
        Row() {
          // 左侧时间线
          Column() {
            // 时间线上的点
            Circle()
              .width(12)
              .height(12)
              .fill($r('app.color.button_primary'))

            // 时间线（竖线）
            Column()
              .width(2)
              .height(180)
              .backgroundColor($r('app.color.text_secondary'))
              .opacity(0.25)
              .margin({ top: 1 })
          }
          .width(24)
            .alignItems(HorizontalAlign.Center)
            .margin({ right: 16 })

          // 右侧内容
          Column() {
            // 年份标签
            Row() {
              Text(item.year.toString())
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              if (index === 0) {
                Text(this.context.resourceManager.getStringSync($r('app.string.current').id))
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ left: 2 })
              }
            }
            .width('100%')
              .margin({ bottom: 4 })
              .alignItems(VerticalAlign.Center)

            // 国旗图片（更窄）
            // 图片资源名称格式：flag_history_{countryCode}_{year}
            // 例如：flag_history_cn_1912
            Image($rawfile(`flag_history/${item.imagePath}.webp`))
              .width('60%')
              .height(160)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })
              .alignSelf(ItemAlign.Start)
          }
            .width('100%')
            .padding({ left: 12, right: 12 })
            .borderRadius(16)
        }
        .width('100%')
          .margin({ bottom: 12 })
      })
    }
    .width('100%')
      .padding({ left: 16, right: 16 })
  }
}

