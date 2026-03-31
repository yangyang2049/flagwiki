import router from '@ohos.router'
import { common } from '@kit.AbilityKit'
import { TopicItem, getAllTopicsForDisplay, getTopicName } from '../topic/TopicData'
import { WatchLayout } from '../../utils/WatchUiConstants'

@Component
export struct WatchTopicPage {
  @State topics: TopicItem[] = []
  @StorageLink('currentLanguage') @Watch('onWatchTopicLanguageChanged') currentLanguage: string = 'zh'
  private scroller: Scroller = new Scroller()
  private context = getContext(this) as common.UIAbilityContext

  private onWatchTopicLanguageChanged(): void {
    this.topics = getAllTopicsForDisplay(this.currentLanguage)
  }

  aboutToAppear(): void {
    this.topics = getAllTopicsForDisplay(this.currentLanguage)
  }

  build() {
    Column() {
      Text($r('app.string.topic'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 8, bottom: 8 })

      Scroll(this.scroller) {
        Column() {
          ForEach(this.topics, (topic: TopicItem) => {
            Row() {
              Text(topic.emoji)
                .fontSize(18)
                .margin({ right: 8 })
              Text(getTopicName(topic.id, this.context, this.currentLanguage))
                .fontSize(15)
                .fontColor('#FFFFFF')
                .layoutWeight(1)
                .maxLines(2)
                .lineHeight(20)
                .textAlign(TextAlign.Start)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('80%')
            .alignItems(VerticalAlign.Center)
            .padding({ left: 10, right: 10, top: 8, bottom: 8 })
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/watch/WatchTopicDetailPage',
                params: { topicId: topic.id }
              })
            })
            .margin({ bottom: WatchLayout.listItemGap })
          }, (topic: TopicItem) => topic.id)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 4, bottom: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .focusable(true)
      .defaultFocus(true)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#000000')
  }
}
