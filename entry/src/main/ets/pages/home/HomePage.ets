import router from '@ohos.router';
import { TopicItem, getAllTopics } from '../topic/TopicData';
import { WeeklyFlagItem, getCurrentWeekFlag } from '../../utils/WeeklyFlagData';
import { getCountryByCode } from '../../utils/countryData';

@Component
export struct HomePage {
  @Prop refreshKey: number = 0;
  @State funFactIndex: number = 0;
  @State weeklyFlag: WeeklyFlagItem | undefined = undefined;
  onTabChange: (index: number) => void = () => {};

  aboutToAppear() {
    this.weeklyFlag = getCurrentWeekFlag();
  }

  private getRegionName(region: string): string {
    const regionMap: Record<string, string> = {
      'Asia': '亚洲',
      'Europe': '欧洲',
      'Africa': '非洲',
      'Americas': '美洲',
      'Oceania': '大洋洲'
    };
    return regionMap[region] || region;
  }

  private getWeeklyFlagRegion(): string {
    if (!this.weeklyFlag) return '';
    const country = getCountryByCode(this.weeklyFlag.countryCode);
    if (country) {
      return this.getRegionName(country.region);
    }
    return '';
  }

  // 国旗趣味小知识
  private funFacts: string[] = [
    '🇳🇵 尼泊尔是世界上唯一非矩形的国旗，由两个三角形组成！',
    '🇨🇭 瑞士和梵蒂冈是世界上仅有的两个正方形国旗！',
    '🇯🇵 日本国旗上的红色圆形代表太阳，日本被称为"日出之国"！',
    '🇱🇾 利比亚在1977-2011年使用过世界上唯一的纯色国旗（绿色）！',
    '🇲🇨 摩纳哥和印度尼西亚的国旗几乎相同，只是尺寸比例不同！',
    '🇩🇰 丹麦国旗是世界上使用时间最长的国旗，自1219年开始使用！',
    '🇧🇷 巴西国旗上的27颗星星代表26个州和1个联邦区！',
    '🇺🇸 美国国旗的50颗星代表50个州，13道条纹代表最初的13个殖民地！',
    '🇨🇦 加拿大国旗上的枫叶有11个尖角，这是经过风洞测试最清晰的设计！',
    '🇬🇧 英国国旗"米字旗"由英格兰、苏格兰和爱尔兰的旗帜组合而成！'
  ];

  private switchFunFact(): void {
    this.funFactIndex = (this.funFactIndex + 1) % this.funFacts.length;
  }

  build() {
    Scroll() {
      Column() {
        // 欢迎卡片
        Column() {
          Row() {
            Column() {
              Text('国旗小百科')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text('探索世界各国国旗的奥秘')
                .fontSize(14)
                .fontColor($r('app.color.text_white'))
                .opacity(0.85)
                .margin({ top: 8 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            // 扇形国旗装饰
            Stack() {
              // 印度 - 最左侧
              Image($rawfile('flags/in.svg'))
                .width(40)
                .height(27)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: -25 })
                .offset({ x: -32, y: 12 })

              // 美国 - 左侧
              Image($rawfile('flags/us.svg'))
                .width(42)
                .height(28)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: -12 })
                .offset({ x: -16, y: 4 })

              // 巴西 - 右侧
              Image($rawfile('flags/br.svg'))
                .width(42)
                .height(28)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: 12 })
                .offset({ x: 16, y: 4 })

              // 法国 - 最右侧
              Image($rawfile('flags/fr.svg'))
                .width(40)
                .height(27)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: 25 })
                .offset({ x: 32, y: 12 })

              // 中国 - 中间，最上层
              Image($rawfile('flags/cn.svg'))
                .width(48)
                .height(32)
                .objectFit(ImageFit.Contain)
                .offset({ x: 0, y: -8 })
            }
            .width(110)
            .height(65)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .padding({ top: 24, bottom: 24, left: 20, right: 20 })
        .linearGradient({
          angle: 135,
          colors: [[$r('app.color.button_primary'), 0], [$r('app.color.blue'), 1]]
        })
        .borderRadius(16)
        .margin({ top: 16 })

        // 本周国旗
        if (this.weeklyFlag) {
          Column() {
            Row() {
              Text('本周国旗')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .margin({ bottom: 16 })

            Row() {
              // 国旗图片
              Image($rawfile(`flags/${this.weeklyFlag.countryCode}.svg`))
                .width(120)
                .height(80)
                .objectFit(ImageFit.Contain)
                .margin({ right: 16 })

              // 国家信息
              Column() {
                Text(this.weeklyFlag.countryNameCN)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 6 })
                Text(`国庆日: ${this.weeklyFlag.nationalDay.replace('-', '月')}日`)
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 4 })
                Text(this.getWeeklyFlagRegion())
                  .fontSize(12)
                  .fontColor($r('app.color.text_tertiary'))
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.bg_secondary'))
            .borderRadius(12)
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(16)
          .margin({ top: 16 })
          .onClick(() => {
            if (this.weeklyFlag) {
              router.pushUrl({
                url: 'pages/gallery/FlagDetailPage',
                params: { countryCode: this.weeklyFlag.countryCode }
              });
            }
          })
        }

        // 快捷入口区
        Column() {
          Row() {
            Text('快捷入口')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .width('100%')
          .margin({ bottom: 16 })

          Row() {
            // 国旗画廊
            Column() {
              Stack() {
                Circle()
                  .width(48)
                  .height(48)
                  .fill($r('app.color.bg_blue_light'))
                Text('🇺🇳')
                  .fontSize(22)
              }
              Text('国旗画廊')
                .fontSize(13)
                .fontColor($r('app.color.text_dark'))
                .margin({ top: 10 })
            }
            .layoutWeight(1)
            .onClick(() => {
              this.onTabChange(1);
            })

            // 各国州旗
            Column() {
              Stack() {
                Circle()
                  .width(48)
                  .height(48)
                  .fill($r('app.color.bg_blue_light'))
                Text('🇺🇸')
                  .fontSize(22)
              }
              Text('各国州旗')
                .fontSize(13)
                .fontColor($r('app.color.text_dark'))
                .margin({ top: 10 })
            }
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/stateflag/StateFlagCountryListPage' });
            })

            // 国旗猜猜
            Column() {
              Stack() {
                Circle()
                  .width(48)
                  .height(48)
                  .fill($r('app.color.bg_blue_light'))
                Text('🎯')
                  .fontSize(22)
              }
              Text('国旗猜猜')
                .fontSize(13)
                .fontColor($r('app.color.text_dark'))
                .margin({ top: 10 })
            }
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/quiz/QuizSelectPage' });
            })

            // 收藏夹
            Column() {
              Stack() {
                Circle()
                  .width(48)
                  .height(48)
                  .fill($r('app.color.bg_blue_light'))
                Text('⭐')
                  .fontSize(22)
              }
              Text('收藏夹')
                .fontSize(13)
                .fontColor($r('app.color.text_dark'))
                .margin({ top: 10 })
            }
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/profile/FavoritesPage' });
            })
          }
          .width('100%')
        }
        .width('100%')
        .padding(20)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .margin({ top: 16 })

        // 专题推荐
        Column() {
          Row() {
            Text('专题推荐')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Blank()
            Text('›')
              .fontSize(22)
              .fontColor($r('app.color.button_primary'))
              .onClick(() => {
                router.pushUrl({ url: 'pages/topic/TopicListPage' });
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 横向滚动的专题卡片
          Scroll() {
            Row() {
              ForEach(getAllTopics().slice(0, 4), (topic: TopicItem) => {
                Column() {
                  Text(topic.emoji)
                    .fontSize(32)
                    .margin({ bottom: 8 })
                  Text(topic.name)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_primary'))
                    .maxLines(1)
                }
                .width(90)
                .height(90)
                .padding(12)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(12)
                .margin({ right: 12 })
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/topic/TopicDetailPage',
                    params: { topicId: topic.id }
                  });
                })
              })
            }
          }
          .width('100%')
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding(20)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .margin({ top: 16 })

        // 趣味小知识
        Column() {
          Row() {
            Text('💡 趣味小知识')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Blank()
            Image($r('app.media.icon_redo'))
              .width(20)
              .height(20)
              .onClick(() => {
                this.switchFunFact();
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          Text(this.funFacts[this.funFactIndex])
            .fontSize(15)
            .fontColor($r('app.color.text_dark'))
            .lineHeight(24)
        }
        .width('100%')
        .padding(20)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .margin({ top: 16, bottom: 16 })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}
