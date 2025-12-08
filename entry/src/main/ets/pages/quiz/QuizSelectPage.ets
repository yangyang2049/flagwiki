import router from '@ohos.router';

@Entry
@Component
struct QuizSelectPage {
  build() {
    Navigation() {
      Column() {
        // 看旗猜国名
        Row() {
          Column() {
            Text('🏳️')
              .fontSize(40)
          }
          .width(72)
          .height(72)
          .backgroundColor($r('app.color.bg_blue_light'))
          .borderRadius(16)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text('看旗猜国名')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('根据国旗图案，选择正确的国家名称')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
          .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
        .padding(20)
        .margin({ left: 16, right: 16, top: 16 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(20)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/quiz/QuizLevelsPage',
            params: { quizType: 'flagToName' }
          });
        })

        // 看名猜国旗
        Row() {
          Column() {
            Text('🌍')
              .fontSize(40)
          }
          .width(72)
          .height(72)
          .backgroundColor($r('app.color.bg_blue_light'))
          .borderRadius(16)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text('看名猜国旗')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('根据国家名称，选择正确的国旗图案')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
          .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
        .padding(20)
        .margin({ left: 16, right: 16, top: 16 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(20)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/quiz/QuizLevelsPage',
            params: { quizType: 'nameToFlag' }
          });
        })

        // 说明
        Column() {
          Text('完成每关挑战，解锁更多关卡')
            .fontSize(13)
            .fontColor($r('app.color.text_tertiary'))
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .margin({ top: 32 })
      }
      .width('100%')
      .height('100%')
    }
    .title('国旗猜猜')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}
