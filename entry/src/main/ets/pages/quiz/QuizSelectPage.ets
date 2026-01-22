import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

@Entry
@Component
struct QuizSelectPage {
  private context = getContext(this) as common.UIAbilityContext;

  build(): void {
    Navigation() {
      Row() {
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
            Text(this.context.resourceManager.getStringSync($r('app.string.quiz_flag_to_name').id))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.context.resourceManager.getStringSync($r('app.string.quiz_flag_to_name_desc').id))
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
            Text(this.context.resourceManager.getStringSync($r('app.string.quiz_name_to_flag').id))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.context.resourceManager.getStringSync($r('app.string.quiz_name_to_flag_desc').id))
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
          Text(this.context.resourceManager.getStringSync($r('app.string.complete_levels_to_unlock').id))
            .fontSize(13)
            .fontColor($r('app.color.text_tertiary'))
            .textAlign(TextAlign.Center)
          }
          .width('100%')
          .margin({ top: 32 })
        }
        .width('100%')
        .height('100%')
        .constraintSize({ maxWidth: getContentMaxWidth() })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title(this.context.resourceManager.getStringSync($r('app.string.game_quiz').id))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
  }
}
