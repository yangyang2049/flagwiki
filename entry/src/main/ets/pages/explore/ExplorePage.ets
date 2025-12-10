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
          Text('国旗猜猜')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('看旗猜国名、看名猜国旗')
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
          Text('假旗找茬')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('在四面国旗中找出假旗')
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
          Text('拼写挑战')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('看国旗，输入国家名称')
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
          Text('知识问答')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('趣味国旗百科问答')
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
          Text('记忆翻牌')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('翻牌配对，锻炼记忆力')
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
        router.pushUrl({ url: 'pages/memory/MemoryLevelsPage' });
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
          Text('国旗猜猜乐')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text('快速识别国旗，挑战你的反应')
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
        router.pushUrl({ url: 'pages/explore/HeadsUpPlayPage' });
      })
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
