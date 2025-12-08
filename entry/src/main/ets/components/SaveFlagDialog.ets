/**
 * 保存国旗图片对话框组件
 */

import { image } from '@kit.ImageKit';

@CustomDialog
export struct SaveFlagDialog {
  controller: CustomDialogController;
  pixelMap: image.PixelMap | null = null;
  @State private dialogProgress: number = 1.0;
  private dialogTimer: number = -1;
  private readonly DIALOG_AUTO_CLOSE_TIME: number = 8000;

  onClose?: () => void;
  onSaveSuccess?: () => void;
  onSaveError?: (error: Error) => void;
  saveScreenshot?: () => Promise<void>;

  aboutToAppear(): void {
    this.startCountdown();
  }

  aboutToDisappear(): void {
    this.stopCountdown();
  }

  private startCountdown(): void {
    this.stopCountdown();
    const closeTime = this.DIALOG_AUTO_CLOSE_TIME;
    const startTime = Date.now();
    this.dialogProgress = 1.0;
    const updateInterval = 200;
    const tick = () => {
      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, closeTime - elapsed);
      this.dialogProgress = remaining / closeTime;
      if (remaining <= 0) {
        this.stopCountdown();
        this.handleClose();
        return;
      }
      this.dialogTimer = setTimeout(tick, updateInterval);
    };
    this.dialogTimer = setTimeout(tick, updateInterval);
  }

  private stopCountdown(): void {
    if (this.dialogTimer !== -1) {
      clearTimeout(this.dialogTimer);
      this.dialogTimer = -1;
    }
  }

  private handleClose(): void {
    this.stopCountdown();
    // 确保在关闭时调用 onClose 回调以释放 PixelMap
    if (this.onClose) {
      this.onClose();
    }
    this.controller.close();
  }

  private handleUserInteraction(): void {
    this.stopCountdown();
  }

  private async handleSave(event: ClickEvent, result: SaveButtonOnClickResult): Promise<void> {
    this.handleUserInteraction();

    if (result === SaveButtonOnClickResult.SUCCESS && this.pixelMap) {
      try {
        if (!this.saveScreenshot) {
          throw new Error('缺少保存回调函数');
        }

        await this.saveScreenshot();
        if (this.onSaveSuccess) {
          this.onSaveSuccess();
        }
        this.handleClose();
      } catch (error) {
        const err = error instanceof Error ? error : new Error(String(error));
        console.error('[SaveFlagDialog] 保存图片失败：', err.message);

        if (this.onSaveError) {
          this.onSaveError(err);
        }
      }
    } else {
      console.error('[SaveFlagDialog] 图片保存失败或被取消');
      if (this.onSaveError) {
        this.onSaveError(new Error('保存图片失败或被取消'));
      }
    }
  }

  build() {
    Column() {
      Column() {
        Column() {
          if (this.pixelMap) {
            Image(this.pixelMap)
              .width('85%')
              .height(140)
              .objectFit(ImageFit.Contain)
              .borderRadius(8)
              .margin({ top: 20, bottom: 16 })
              .onClick(() => {
                this.handleUserInteraction();
              })
          }

          Text('保存国旗图片到相册')
            .fontSize(15)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 16 })

          Row() {
            Button('取消')
              .fontSize(14)
              .fontColor($r('app.color.text_primary'))
              .backgroundColor($r('app.color.bg_secondary'))
              .width(110)
              .height(40)
              .onClick(() => {
                this.handleClose();
              })

            Blank().width(16)

            SaveButton({
              icon: SaveIconStyle.FULL_FILLED,
              text: SaveDescription.SAVE_IMAGE,
              buttonType: ButtonType.Capsule
            })
              .width(110)
              .height(40)
              .fontSize(14)
              .backgroundColor($r('app.color.button_primary'))
              .fontColor(Color.White)
              .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
                await this.handleSave(event, result);
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ bottom: 20 })
        }
        .width('100%')

        Progress({ value: this.dialogProgress * 100, total: 100, type: ProgressType.Linear })
          .width('100%')
          .height(3)
          .color($r('app.color.button_primary'))
          .backgroundColor($r('app.color.bg_secondary'))
          .borderRadius(12)
      }
      .width(300)
      .backgroundColor($r('app.color.bg_card'))
      .borderRadius(16)
      .clip(true)
      .onClick(() => {
        this.handleUserInteraction();
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .onClick(() => {
      this.handleClose();
    })
  }
}

