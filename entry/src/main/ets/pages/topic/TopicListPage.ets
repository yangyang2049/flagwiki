import router from '@ohos.router';
import { TopicItem, getAllTopics } from './TopicData';

@Entry
@Component
  struct TopicListPage {
  @State topics: TopicItem[] = [];

  aboutToAppear() {
    this.topics = getAllTopics();
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          List() {
            ForEach(this.topics, (topic: TopicItem) => {
              ListItem() {
                Row() {
                  // 左侧图标
                  Column() {
                    Text(topic.emoji)
                      .fontSize(36)
                  }
                  .width(64)
                    .height(64)
                    .backgroundColor($r('app.color.bg_blue_light'))
                    .borderRadius(16)
                    .justifyContent(FlexAlign.Center)

                  // 中间文字
                  Column() {
                    Text(topic.name)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_primary'))

                    Text(topic.description)
                      .fontSize(13)
                      .fontColor($r('app.color.text_secondary'))
                      .margin({ top: 4 })
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .alignItems(HorizontalAlign.Start)
                    .margin({ left: 16 })
                    .layoutWeight(1)

                  // 右侧箭头
                  Image($r('app.media.icon_arrow_right'))
                    .width(20)
                    .height(20)
                }
                .width('100%')
                  .padding(16)
                  .backgroundColor($r('app.color.bg_card'))
                  .borderRadius(16)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/topic/TopicDetailPage',
                      params: { topicId: topic.id }
                    });
                  })
              }
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            })
          }
          .width('100%')
          .height('100%')
          .padding({ top: 8, bottom: 16 })
          .edgeEffect(EdgeEffect.Spring)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .height('100%')
        .constraintSize({ maxWidth: 320 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title('专题')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
  }
}
