import { generateBarcode, scanCore } from '@kit.ScanKit'
import { image } from '@kit.ImageKit'

@Component
export struct WatchPrivacyAgreement {
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') currentLanguage: string = 'zh'
  @State qrCode: image.PixelMap | null = null
  @State qrCodeGenerating: boolean = false
  private scrollScroller: Scroller = new Scroller()
  private readonly agreementUrlZh: string = 'https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1829857329265255744'
  private readonly agreementUrlEn: string = 'https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=en&agreementId=1863260437127140928'
  onConfirmClick: () => void = () => {}
  onCancelClick: () => void = () => {}

  aboutToAppear(): void {
    void this.generateQRCode()
  }

  private onLanguageChanged(): void {
    void this.generateQRCode()
  }

  private getAgreementUrl(): string {
    if (this.currentLanguage === 'en' || this.currentLanguage.startsWith('en-')) {
      return this.agreementUrlEn
    }
    return this.agreementUrlZh
  }

  private async generateQRCode(): Promise<void> {
    this.qrCodeGenerating = true
    try {
      const pixelMap: image.PixelMap = await generateBarcode.createBarcode(this.getAgreementUrl(), {
        scanType: scanCore.ScanType.QR_CODE,
        width: 300,
        height: 300
      })
      this.qrCode = pixelMap
    } catch (err) {
      console.error('[WatchPrivacyAgreement] Failed to generate QR code:', JSON.stringify(err))
      this.qrCode = null
    } finally {
      this.qrCodeGenerating = false
    }
  }

  build() {
    Column() {
      Scroll(this.scrollScroller) {
        Column() {
          Text($r('app.string.watch_privacy_agreement'))
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .margin({ top: 24, bottom: 12 })

          Column() {
            if (this.qrCode) {
              Image(this.qrCode)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Column() {
                LoadingProgress()
                  .width(32)
                  .height(32)
                  .color('#FFFFFF')
                Text(this.qrCodeGenerating ? $r('app.string.watch_qr_code_generating') : $r('app.string.watch_load_failed'))
                  .fontSize(10)
                  .fontColor('rgba(255, 255, 255, 0.7)')
                  .margin({ top: 8 })
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
          }
          .width('40%')
          .aspectRatio(1)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .padding(8)
          .margin({ bottom: 8 })

          Text($r('app.string.watch_scan_to_view_details'))
            .fontSize(10)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ bottom: 12 })

          Button($r('app.string.watch_confirm'))
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .width('40%')
            .height(28)
            .backgroundColor($r('app.color.button_primary'))
            .borderRadius(8)
            .margin({ bottom: 8 })
            .onClick(() => {
              this.onConfirmClick()
            })

          Text($r('app.string.watch_cancel'))
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .width('40%')
            .textAlign(TextAlign.Center)
            .padding({ top: 6, bottom: 6 })
            .margin({ bottom: 20 })
            .onClick(() => {
              this.onCancelClick()
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
