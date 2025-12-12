import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { TopicItem, getAllTopics, getLocalizedTopicName } from '../topic/TopicData';
import { WeeklyFlagItem, getCurrentWeekFlag } from '../../utils/WeeklyFlagData';
import { getCountryByCode, getFlagImageSource, getLocalizedCountryName } from '../../utils/countryData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

@Component
export struct HomePage {
  @Prop refreshKey: number = 0;
  @State funFactIndex: number = 0;
  @State weeklyFlag: WeeklyFlagItem | undefined = undefined;
  @StorageLink('currentLanguage') systemLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;
  onTabChange: (index: number) => void = () => {};

  aboutToAppear() {
    this.weeklyFlag = getCurrentWeekFlag();
    // 随机显示趣味知识
    this.funFactIndex = Math.floor(Math.random() * this.getFunFacts().length);
  }

  private getRegionName(region: string): Resource | string {
    const regionMap: Record<string, Resource> = {
      'Asia': $r('app.string.continent_asia'),
      'Europe': $r('app.string.continent_europe'),
      'Africa': $r('app.string.continent_africa'),
      'Americas': $r('app.string.continent_americas'),
      'Oceania': $r('app.string.continent_oceania')
    };
    return regionMap[region] || region;
  }

  private getWeeklyFlagRegion(): Resource | string {
    if (!this.weeklyFlag) return '';
    const country = getCountryByCode(this.weeklyFlag.countryCode);
    if (country) {
      return this.getRegionName(country.region);
    }
    return '';
  }

  // 国旗趣味小知识
  private getFunFacts(): string[] {
    return [
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_1').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_2').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_3').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_4').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_5').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_6').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_7').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_8').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_9').id),
      this.context.resourceManager.getStringSync($r('app.string.fun_fact_10').id)
    ];
  }

  private switchFunFact(): void {
    this.funFactIndex = (this.funFactIndex + 1) % this.getFunFacts().length;
  }

  // 格式化日期
  private formatDate(dateStr: string): string {
    const parts = dateStr.split('-');
    if (parts.length !== 2) return dateStr;
    
    const month = parseInt(parts[0]);
    const day = parseInt(parts[1]);
    
    const isEnglish = LocalizationUtil.isEnglish(this.systemLanguage);
    if (isEnglish) {
      const monthResources: Resource[] = [
        $r('app.string.month_jan'), $r('app.string.month_feb'), $r('app.string.month_mar'),
        $r('app.string.month_apr'), $r('app.string.month_may'), $r('app.string.month_jun'),
        $r('app.string.month_jul'), $r('app.string.month_aug'), $r('app.string.month_sep'),
        $r('app.string.month_oct'), $r('app.string.month_nov'), $r('app.string.month_dec')
      ];
      const monthName = this.context.resourceManager.getStringSync(monthResources[month - 1].id);
      return `${monthName} ${day}`;
    } else {
      const monthResources: Resource[] = [
        $r('app.string.month_1'), $r('app.string.month_2'), $r('app.string.month_3'),
        $r('app.string.month_4'), $r('app.string.month_5'), $r('app.string.month_6'),
        $r('app.string.month_7'), $r('app.string.month_8'), $r('app.string.month_9'),
        $r('app.string.month_10'), $r('app.string.month_11'), $r('app.string.month_12')
      ];
      const monthName = this.context.resourceManager.getStringSync(monthResources[month - 1].id);
      const daySuffix = this.context.resourceManager.getStringSync($r('app.string.day_suffix').id);
      return `${monthName}${day}${daySuffix}`;
    }
  }

  // 获取本地化的国家名称
  private getLocalizedCountryNameByCode(countryCode: string): string {
    const country = getCountryByCode(countryCode);
    if (!country) return '';
    return getLocalizedCountryName(country, this.systemLanguage);
  }

  build() {
    Scroll() {
      Column() {
        // 欢迎卡片
        Column() {
          Row() {
            Column() {
              Text($r('app.string.app_welcome_title'))
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text($r('app.string.app_welcome_subtitle'))
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
              Image(getFlagImageSource('in'))
                .width(40)
                .height(27)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: -25 })
                .offset({ x: -32, y: 12 })

              // 美国 - 左侧
              Image(getFlagImageSource('us'))
                .width(42)
                .height(28)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: -12 })
                .offset({ x: -16, y: 4 })

              // 巴西 - 右侧
              Image(getFlagImageSource('br'))
                .width(42)
                .height(28)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: 12 })
                .offset({ x: 16, y: 4 })

              // 法国 - 最右侧
              Image(getFlagImageSource('fr'))
                .width(40)
                .height(27)
                .objectFit(ImageFit.Contain)
                .rotate({ angle: 25 })
                .offset({ x: 32, y: 12 })

              // 中国 - 中间，最上层
              Image(getFlagImageSource('cn'))
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
              Text($r('app.string.weekly_flag'))
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .margin({ bottom: 16 })

            Row() {
              // 国旗图片
              Image(getFlagImageSource(this.weeklyFlag.countryCode))
                .width(120)
                .height(80)
                .objectFit(ImageFit.Contain)
                .margin({ right: 16 })

              // 国家信息
              Column() {
                Text(this.getLocalizedCountryNameByCode(this.weeklyFlag.countryCode))
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 6 })
                Row() {
                  Text($r('app.string.national_day'))
                    .fontSize(13)
                    .fontColor($r('app.color.text_secondary'))
                  Text(`: ${this.formatDate(this.weeklyFlag.nationalDay)}`)
                    .fontSize(13)
                    .fontColor($r('app.color.text_secondary'))
                }
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
              Text($r('app.string.quick_entrance'))
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
              Text($r('app.string.flag_gallery'))
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
              Text($r('app.string.state_flags'))
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
              Text($r('app.string.flag_quiz'))
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
              Text($r('app.string.favorites'))
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
            Text($r('app.string.topic_recommendations'))
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Blank()
            Text('›')
              .fontSize(22)
              .fontColor($r('app.color.button_primary'))
          }
          .width('100%')
          .margin({ bottom: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/topic/TopicListPage' });
          })

          // 横向滚动的专题卡片
          Scroll() {
            Row() {
              ForEach(getAllTopics(this.systemLanguage).slice(0, 4), (topic: TopicItem) => {
                Column() {
                  Text(topic.emoji)
                    .fontSize(32)
                    .margin({ bottom: 8 })
                  Text(getLocalizedTopicName(topic, this.systemLanguage))
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_primary'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
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
            Text($r('app.string.fun_facts'))
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

          Text(this.getFunFacts()[this.funFactIndex])
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
