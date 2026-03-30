import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { TopicItem, getAllTopics, getTopicName } from '../topic/TopicData';
import { WeeklyFlagItem, getCurrentWeekFlag } from '../../utils/WeeklyFlagData';
import { getCountryByCode, getFlagImageSource, getLocalizedCountryName } from '../../utils/countryData';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

@Component
export struct HomePage {
  @Prop refreshKey: number = 0;
  /** 画廊在主界面 Tab 中的索引（无国歌扩展时为 1，有国歌时为 2） */
  @Prop galleryTabIndex: number = 1;
  @State funFactIndex: number = 0;
  @State weeklyFlag: WeeklyFlagItem | undefined = undefined;
  @State funFactsList: string[] = [];
  @StorageLink('currentLanguage') @Watch('onCurrentLanguageChanged') currentLanguage: string = 'zh';
  @StorageLink('optionalModuleStateFlagsReady') stateFlagsModuleReady: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  onTabChange: (index: number) => void = () => {};

  private get isEnglish(): boolean {
    try {
      if (!this.currentLanguage) {
        return false;
      }
      return LocalizationUtil.isEnglish(this.currentLanguage);
    } catch (e) {
      return false;
    }
  }

  private onCurrentLanguageChanged(): void {
    // 当语言改变时，重新加载 fun facts 并更新索引
    this.loadFunFacts();
    this.updateFunFactIndex();
  }

  aboutToAppear() {
    this.weeklyFlag = getCurrentWeekFlag();
    // 加载 fun facts
    this.loadFunFacts();
    // Ensure funFacts is available before accessing length
    this.updateFunFactIndex();
  }

  private loadFunFacts(): void {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const facts: string[] = [];
      // 使用资源映射表，避免动态构建资源ID可能的问题
      const factResources: Resource[] = [
        $r('app.string.fun_fact_1'),
        $r('app.string.fun_fact_2'),
        $r('app.string.fun_fact_3'),
        $r('app.string.fun_fact_4'),
        $r('app.string.fun_fact_5'),
        $r('app.string.fun_fact_6'),
        $r('app.string.fun_fact_7'),
        $r('app.string.fun_fact_8'),
        $r('app.string.fun_fact_9'),
        $r('app.string.fun_fact_10')
      ];
      
      for (let i = 0; i < factResources.length; i++) {
        try {
          const fact = context.resourceManager.getStringSync(factResources[i].id);
          // 检查获取到的字符串是否为空
          if (fact && fact.trim().length > 0) {
            facts.push(fact);
          } else {
            // 如果获取到的字符串为空，记录警告但继续
            console.warn(`[HomePage] fun_fact_${i + 1} is empty`);
          }
        } catch (err) {
          // 如果单个资源获取失败，记录错误但继续
          console.error(`[HomePage] Failed to load fun_fact_${i + 1}:`, err);
        }
      }
      this.funFactsList = facts;
    } catch (e) {
      // 如果出错，返回空数组
      console.error('[HomePage] Failed to load fun facts:', e);
      this.funFactsList = [];
    }
  }

  private updateFunFactIndex(): void {
    try {
      const facts = this.funFactsList || [];
      this.funFactIndex = facts.length > 0 ? Math.floor(Math.random() * facts.length) : 0;
    } catch (e) {
      // 如果出错，使用默认值
      this.funFactIndex = 0;
    }
  }

  private getTopicCount(): number {
    // 如果内容宽度 >= 600vp，显示5个，否则显示4个
    return getContentMaxWidth() >= 600 ? 5 : 4;
  }

  @Builder
  shortcutItem(emoji: string, title: string, onClick: () => void) {
    Column() {
      Stack() {
        Circle()
          .width(48)
          .height(48)
          .fill($r('app.color.bg_blue_light'))
        Text(emoji)
          .fontSize(22)
      }
      Text(title)
        .fontSize(13)
        .fontColor($r('app.color.text_dark'))
        .margin({ top: 10 })
    }
    .layoutWeight(1)
    .onClick(onClick)
  }

  private getRegionName(region: string): string {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      let resource: Resource;
      switch (region) {
        case 'Asia':
          resource = $r('app.string.region_asia');
          break;
        case 'Europe':
          resource = $r('app.string.region_europe');
          break;
        case 'Africa':
          resource = $r('app.string.region_africa');
          break;
        case 'Americas':
          resource = $r('app.string.region_americas');
          break;
        case 'Oceania':
          resource = $r('app.string.region_oceania');
          break;
        default:
          return region; // fallback to original region name
      }
      return context.resourceManager.getStringSync(resource.id);
    } catch (e) {
      return region; // fallback
    }
  }

  private getWeeklyFlagCountryName(): string {
    if (!this.weeklyFlag) return '';
    const country = getCountryByCode(this.weeklyFlag.countryCode);
    return country ? getLocalizedCountryName(country, this.currentLanguage) : this.weeklyFlag.countryNameCN;
  }

  private getWeeklyFlagNationalDay(): string {
    if (!this.weeklyFlag) return '';
    const dayStr = this.isEnglish 
      ? this.weeklyFlag.nationalDay.replace('-', '/')
      : this.weeklyFlag.nationalDay.replace('-', '月') + '日';
    return this.context.resourceManager.getStringSync($r('app.string.national_day_colon').id) + dayStr;
  }

  private getWeeklyFlagRegion(): string {
    if (!this.weeklyFlag) return '';
    const country = getCountryByCode(this.weeklyFlag.countryCode);
    if (country) {
      return this.getRegionName(country.region);
    }
    return '';
  }

  private getCurrentFunFact(): string {
    try {
      const facts = this.funFactsList || [];
      if (facts && Array.isArray(facts) && facts.length > 0 && this.funFactIndex >= 0 && this.funFactIndex < facts.length) {
        const fact: string = facts[this.funFactIndex];
        return fact !== undefined && fact !== null ? fact : '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  private switchFunFact(): void {
    try {
      const facts = this.funFactsList || [];
      if (facts.length > 0) {
        this.funFactIndex = (this.funFactIndex + 1) % facts.length;
      }
    } catch (e) {
      // 如果出错，重置为0
      this.funFactIndex = 0;
    }
  }

  build() {
    Scroll() {
      Row() {
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

            // 国旗装饰
            Stack() {
              // 美国
              Image(getFlagImageSource('us'))
                .width(36)
                .height(24)
                .objectFit(ImageFit.Contain)
                .offset({ x: -20, y: 0 })

              // 中国 - 中间
              Image(getFlagImageSource('cn'))
                .width(42)
                .height(28)
                .objectFit(ImageFit.Contain)
                .offset({ x: 0, y: -4 })

              // 法国
              Image(getFlagImageSource('fr'))
                .width(36)
                .height(24)
                .objectFit(ImageFit.Contain)
                .offset({ x: 20, y: 0 })
            }
            .width(90)
            .height(50)
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
                Text(this.getWeeklyFlagCountryName())
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .margin({ bottom: 6 })
                Text(this.getWeeklyFlagNationalDay())
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
            Text($r('app.string.quick_entrance'))
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .width('100%')
          .margin({ bottom: 16 })

          Row() {
            this.shortcutItem('🇺🇳', this.context.resourceManager.getStringSync($r('app.string.flag_gallery').id), () => this.onTabChange(this.galleryTabIndex))
            if (this.stateFlagsModuleReady) {
              this.shortcutItem('🇺🇸', this.context.resourceManager.getStringSync($r('app.string.state_flags').id), () => router.pushUrl({ url: 'pages/stateflag/StateFlagCountryListPage' }))
            }
            this.shortcutItem('🎯', this.context.resourceManager.getStringSync($r('app.string.flag_quiz').id), () => router.pushUrl({ url: 'pages/quiz/QuizSelectPage' }))
            this.shortcutItem('⭐', this.context.resourceManager.getStringSync($r('app.string.favorites').id), () => router.pushUrl({ url: 'pages/profile/FavoritesPage' }))
          }
          .width('100%')
        }
        .width('100%')
        .padding(20)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .margin({ top: 16 })

        // 国旗涂鸦（单独入口）
        Row() {
          Stack() {
            Circle()
              .width(48)
              .height(48)
              .fill($r('app.color.bg_blue_light'))
            Text('🎨')
              .fontSize(22)
          }
          .margin({ right: 14 })

          Column() {
            Text(this.context.resourceManager.getStringSync($r('app.string.home_paint_entry_title').id))
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Text(this.context.resourceManager.getStringSync($r('app.string.home_paint_entry_subtitle').id))
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
              .maxLines(2)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('›')
            .fontSize(22)
            .fontColor($r('app.color.gray_disabled'))
        }
        .width('100%')
        .padding({ left: 18, right: 18, top: 16, bottom: 16 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .margin({ top: 16 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'pages/paintgame/PaintHomePage' })
            .catch((err: Error) => {
              console.error(`Failed to open PaintHomePage: ${err.message}`);
            });
        })

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
              .onClick(() => {
                router.pushUrl({ url: 'pages/topic/TopicListPage' });
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 横向滚动的专题卡片
          Scroll() {
            Row() {
              ForEach(getAllTopics().slice(0, this.getTopicCount()), (topic: TopicItem) => {
                Column() {
                  Text(topic.emoji)
                    .fontSize(32)
                    .margin({ bottom: 8 })
                  Text(getTopicName(topic.id, this.context, this.currentLanguage))
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

          Text(this.getCurrentFunFact())
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
        .constraintSize({ maxWidth: getContentMaxWidth() })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .focusable(true)
    .defaultFocus(true)
  }
}
