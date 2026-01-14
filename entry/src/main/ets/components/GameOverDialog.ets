@CustomDialog
export struct GameOverDialog {
  controller: CustomDialogController;
  title: string = '';
  message: string = '';
  backText: string = '';
  restartText: string = '';
  onBack?: () => void;
  onRestart?: () => void;

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: 12 })

      Text(this.message)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: 20 })

      Row() {
        Button(this.backText)
          .layoutWeight(1)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.bg_secondary'))
          .fontColor($r('app.color.text_primary'))
          .margin({ right: 8 })
          .onClick(() => {
            if (this.onBack) {
              this.onBack();
            }
            this.controller.close();
          })

        Button(this.restartText)
          .layoutWeight(1)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_white'))
          .onClick(() => {
            if (this.onRestart) {
              this.onRestart();
            }
            this.controller.close();
          })
      }
    }
    .width(300)
    .padding(20)
    .backgroundColor($r('app.color.bg_card'))
    .borderRadius(16)
  }
}
