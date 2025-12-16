import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { TopicItem, getAllTopics, getLocalizedTopicName, getLocalizedTopicDescription } from './TopicData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

@Entry
@Component
  struct TopicListPage {
  @State topics: TopicItem[] = [];
  private context = getContext(this) as common.UIAbilityContext;
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') currentLanguage: string = 'zh';

  aboutToAppear() {
    this.topics = getAllTopics(this.currentLanguage);
  }

  private onLanguageChanged(): void {
    // 语言变化时重新加载专题列表
    this.topics = getAllTopics(this.currentLanguage);
  }

  build() {
    Navigation() {
      List() {
        ForEach(this.topics, (topic: TopicItem) => {
          // 所有专题显示为列表项
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
                  Text(getLocalizedTopicName(topic, this.currentLanguage))
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))

                  Text(getLocalizedTopicDescription(topic, this.currentLanguage))
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
    }
    .title($r('app.string.topic_recommendations'))
      .titleMode(NavigationTitleMode.Mini)
      .backgroundColor($r('app.color.bg_page'))
  }
}

