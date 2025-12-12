import router from '@ohos.router';

@Component
export struct ExplorePage {

  build() {
    Scroll() {
      Column() {
        // 国旗猜猜卡片
        Row() {
          Column() {
            Text('🎯')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_flag_quiz'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_flag_quiz_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/quiz/QuizSelectPage' });
          })

        // 假旗找茬卡片
        Row() {
          Column() {
            Text('🔍')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_fake_flag'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_fake_flag_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/fakeflag/FakeFlagLevelsPage' });
          })

        // 拼写挑战卡片
        Row() {
          Column() {
            Text('⌨️')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_spelling'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_spelling_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/inputgame/InputLevelsPage' });
          })

        // 知识问答卡片
        Row() {
          Column() {
            Text('🧩')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_trivia'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_trivia_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/trivia/TriviaLevelsPage' });
          })

        // 记忆翻牌卡片
        Row() {
          Column() {
            Text('🃏')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_memory'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_memory_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/memory/MemoryLevelsPage' });
          })

        // 分组连线卡片
        Row() {
          Column() {
            Text('🔗')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_connections'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_connections_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/connections/ConnectionsLevelsPage' });
          })

        // HeadsUp 卡片
        Row() {
          Column() {
            Text('👀')
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_headsup'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_headsup_desc'))
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
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/explore/HeadsUpPlayPage' });
          })
      }
      .width('100%')
      .padding({ bottom: 60 })
    }
    .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.bg_page'))
  }
}
