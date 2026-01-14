import router from '@ohos.router'
import { WatchLayout } from '../../utils/WatchUiConstants'

@Component
export struct PracticePage {
  build() {
    Column() {
      Text($r('app.string.watch_practice'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 8, bottom: 8 })

      Column() {
        Row() {
          Text($r('app.string.watch_name_to_flag'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
        }
        .width('80%')
        .height(44)
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(8)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/watch/NameToFlagPage'
          })
        })
        .margin({ bottom: WatchLayout.listItemGap })

        Row() {
          Text($r('app.string.watch_flag_to_name'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
        }
        .width('80%')
        .height(44)
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(8)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/watch/FlagToNamePage'
          })
        })

        Row() {
          Text($r('app.string.watch_flashcards'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
        }
        .width('80%')
        .height(44)
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(8)
        .margin({ top: WatchLayout.listItemGap })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/watch/FlashcardPage'
          })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#000000')
  }
}
