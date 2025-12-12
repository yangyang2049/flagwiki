import router from '@ohos.router';

@Entry
@Component
export struct DataInfoPage {

  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 数据概览卡片
          Column() {
            Text($r('app.string.data_info_overview'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 12 })
              .width('100%')
            
            Text($r('app.string.data_info_overview_content'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(12)
          .margin({ top: 16 })

          // 数据来源卡片
          Column() {
            Text($r('app.string.data_info_source'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 12 })
              .width('100%')
            
            Text($r('app.string.data_info_source_content'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(12)
          .margin({ top: 12 })

          // 说明卡片
          Column() {
            Text($r('app.string.data_info_note'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 12 })
              .width('100%')
            
            Text($r('app.string.data_info_note_content'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(12)
          .margin({ top: 12 })

          // 州旗/省旗数据卡片
          Column() {
            Text($r('app.string.data_info_state_flags'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 12 })
              .width('100%')
            
            Text($r('app.string.data_info_state_flags_content'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(12)
          .margin({ top: 12 })

          // 更多数据即将到来卡片
          Column() {
            Text($r('app.string.data_info_more_coming'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 12 })
              .width('100%')
            
            Text($r('app.string.data_info_more_coming_content'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(12)
          .margin({ top: 12, bottom: 16 })
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
    }
    .title($r('app.string.data_info_title'))
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
  }

  onBackPress(): boolean {
    router.back();
    return true;
  }
}
