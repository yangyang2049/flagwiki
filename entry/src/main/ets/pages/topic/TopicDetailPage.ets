import router from '@ohos.router';
import { TopicItem, getTopicById, getLocalizedTopicName, getLocalizedTopicDescription } from './TopicData';
import { getCountryByCode, Country, getFlagImageSource, getInternationalOrgByCode, InternationalOrg, isInternationalOrg, getLocalizedCountryName, getLocalizedOrgName } from '../../utils/countryData';
import { EtiquetteSection, getEtiquetteContent, getLocalizedEtiquetteContent } from './FlagEtiquetteData';
import { ManufacturingSection, getManufacturingContent, getLocalizedManufacturingContent } from './FlagManufacturingData';
import { VexillologySection, getVexillologyContent, getLocalizedVexillologyContent } from './FlagVexillologyData';
import { HistorySection, getFlagHistoryContent, getLocalizedFlagHistoryContent } from './FiveStarRedFlagHistoryData';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

interface RouterParams {
  topicId: string;
}

interface DisplayItem {
  code: string;
  nameCN: string;
  name: string;
  localizedName: string; // 本地化名称
}

interface SimilarFlagPair {
  code1: string;
  nameCN1: string;
  code2: string;
  nameCN2: string;
}

@Entry
@Component
  struct TopicDetailPage {
  @State topic: TopicItem | undefined = undefined;
  @State countries: Country[] = [];
  @State displayItems: DisplayItem[] = [];
  @State isLoading: boolean = true;
  @State etiquetteSections: EtiquetteSection[] = [];
  @State manufacturingSections: ManufacturingSection[] = [];
  @State vexillologySections: VexillologySection[] = [];
  @State flagHistorySections: HistorySection[] = [];
  @State isKnowledgeTopic: boolean = false;
  @State isReading: boolean = false;
  @State similarFlagPairs: SimilarFlagPair[] = [];
  private context = getContext(this) as common.UIAbilityContext;
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';

  async aboutToAppear() {
    // 获取当前系统语言（已通过 @StorageLink 自动同步）
    const params = router.getParams() as RouterParams;
    if (params && params.topicId) {
      this.topic = getTopicById(params.topicId);
      if (this.topic) {
        // 判断是否为知识性专题（countryCodes为空数组）
        this.isKnowledgeTopic = this.topic.countryCodes.length === 0;
        if (this.isKnowledgeTopic) {
          this.loadKnowledgeContent();
          // 初始化 TextReader（仅知识性专题需要）
          try {
            await TextReaderUtil.init(this.context);
            TextReaderUtil.setEventListener();
            TextReaderUtil.setActionListener();
          } catch (err) {
            console.error(`Failed to init TextReader: ${JSON.stringify(err)}`);
          }
        } else if (this.topic.id === 'similar-flags') {
          this.loadSimilarFlags();
        } else {
          this.loadCountries();
        }
      }
    }
  }

  aboutToDisappear() {
    // 页面销毁时停止朗读
    if (this.isReading) {
      TextReaderUtil.stopRead();
      this.isReading = false;
    }
  }

  private getCountText(): string {
    if (!this.topic) {
      return '';
    }
    let count: number;
    if (this.topic.id === 'similar-flags') {
      // 相似旗专题：每个 pair 包含 2 个国家
      count = this.similarFlagPairs.length * 2;
    } else {
      count = this.displayItems.length;
    }
    const countStr = count.toString();
    if (this.topic.id === 'international') {
      return this.context.resourceManager.getStringSync($r('app.string.total_organizations').id, countStr);
    } else {
      return this.context.resourceManager.getStringSync($r('app.string.total_countries').id, countStr);
    }
  }

  private loadCountries(): void {
    if (!this.topic) return;

    // 显示loading
    this.isLoading = true;

    // 同步加载国家数据（移除不必要的延迟）
    const countryList: Country[] = [];
    const displayList: DisplayItem[] = [];

    for (const code of this.topic.countryCodes) {
      if (isInternationalOrg(code)) {
        const org = getInternationalOrgByCode(code);
        if (org) {
          displayList.push({
            code: org.code,
            nameCN: org.nameCN,
            name: org.name,
            localizedName: getLocalizedOrgName(org, this.currentLanguage)
          });
        }
      } else {
        const country = getCountryByCode(code);
        if (country) {
          countryList.push(country);
          displayList.push({
            code: country.code,
            nameCN: country.nameCN,
            name: country.name,
            localizedName: getLocalizedCountryName(country, this.currentLanguage)
          });
        }
      }
    }
    this.countries = countryList;
    this.displayItems = displayList;
    this.isLoading = false;
  }

  private loadKnowledgeContent(): void {
    if (!this.topic) return;

    this.isLoading = true;

    // 根据专题ID加载对应的知识内容（使用本地化内容）
    if (this.topic.id === 'etiquette') {
      this.etiquetteSections = getLocalizedEtiquetteContent(this.currentLanguage);
    } else if (this.topic.id === 'manufacturing') {
      this.manufacturingSections = getLocalizedManufacturingContent(this.currentLanguage);
    } else if (this.topic.id === 'vexillology') {
      this.vexillologySections = getLocalizedVexillologyContent(this.currentLanguage);
    } else if (this.topic.id === 'flag-history') {
      this.flagHistorySections = getLocalizedFlagHistoryContent(this.currentLanguage);
    }

    this.isLoading = false;
  }

  private loadSimilarFlags(): void {
    if (!this.topic) return;

    this.isLoading = true;

    // 相似旗组合定义（使用本地化名称）
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    const pairs: SimilarFlagPair[] = [
      { 
        code1: 'mc', 
        nameCN1: isEnglish ? 'Monaco' : '摩纳哥', 
        code2: 'id', 
        nameCN2: isEnglish ? 'Indonesia' : '印尼' 
      },
      { 
        code1: 'nl', 
        nameCN1: isEnglish ? 'Netherlands' : '荷兰', 
        code2: 'lu', 
        nameCN2: isEnglish ? 'Luxembourg' : '卢森堡' 
      },
      { 
        code1: 'ro', 
        nameCN1: isEnglish ? 'Romania' : '罗马尼亚', 
        code2: 'td', 
        nameCN2: isEnglish ? 'Chad' : '乍得' 
      },
      { 
        code1: 'cn', 
        nameCN1: isEnglish ? 'China' : '中国', 
        code2: 'vn', 
        nameCN2: isEnglish ? 'Vietnam' : '越南' 
      },
      { 
        code1: 'ke', 
        nameCN1: isEnglish ? 'Kenya' : '肯尼亚', 
        code2: 'ss', 
        nameCN2: isEnglish ? 'South Sudan' : '南苏丹' 
      },
      { 
        code1: 'ad', 
        nameCN1: isEnglish ? 'Andorra' : '安道尔', 
        code2: 'md', 
        nameCN2: isEnglish ? 'Moldova' : '摩尔多瓦' 
      },
      { 
        code1: 'ir', 
        nameCN1: isEnglish ? 'Iran' : '伊朗', 
        code2: 'tj', 
        nameCN2: isEnglish ? 'Tajikistan' : '塔吉克斯坦' 
      },
      { 
        code1: 'ie', 
        nameCN1: isEnglish ? 'Ireland' : '爱尔兰', 
        code2: 'ci', 
        nameCN2: isEnglish ? 'Ivory Coast' : '科特迪瓦' 
      }
    ];

    this.similarFlagPairs = pairs;
    this.isLoading = false;
  }

  build() {
    Navigation() {
      if (this.topic) {
        Column() {
          // 专题介绍卡片 - 无圆角
          Column() {
            Text(this.topic.emoji)
              .fontSize(48)
              .margin({ bottom: 12 })

            Text(getLocalizedTopicName(this.topic, this.currentLanguage))
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(getLocalizedTopicDescription(this.topic, this.currentLanguage))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 8 })
              .textAlign(TextAlign.Center)

            if (!this.isKnowledgeTopic) {
              Text(this.getCountText())
                .fontSize(13)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 8 })
            }
          }
          .width('100%')
            .padding(24)
            .backgroundColor($r('app.color.bg_card'))

          // 内容区域：知识性专题显示知识内容，相似旗显示特殊UI，否则显示国旗列表
          if (this.isKnowledgeTopic) {
            this.KnowledgeContentView()
          } else if (this.topic.id === 'similar-flags') {
            this.SimilarFlagsView()
          } else {
            this.FlagListView()
          }
        }
        .width('100%')
          .height('100%')
      } else {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 12 })
        }
        .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
      }
    }
    .title('')
      .titleMode(NavigationTitleMode.Mini)
      .backgroundColor($r('app.color.bg_page'))
      .menus(this.isKnowledgeTopic ? this.MenuBuilder : undefined)
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
      // 只在中文环境下显示朗读按钮
      if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
        Image($r('app.media.icon_voice'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.onReadClick();
          })
      }
    }
    .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: 16 })
  }

  private getReadContent(): string {
    if (!this.topic) return '';

    const lines: string[] = [];
    const topicName = getLocalizedTopicName(this.topic, this.currentLanguage);
    const topicDesc = getLocalizedTopicDescription(this.topic, this.currentLanguage);
    lines.push(topicName);
    lines.push(topicDesc);
    lines.push('');

    // 使用本地化的内容（section.title 和 section.content 已经是本地化的）
    if (this.topic.id === 'etiquette') {
      for (const section of this.etiquetteSections) {
        lines.push(section.title);
        lines.push(section.content);
        lines.push('');
      }
    } else if (this.topic.id === 'manufacturing') {
      for (const section of this.manufacturingSections) {
        lines.push(section.title);
        lines.push(section.content);
        lines.push('');
      }
    } else if (this.topic.id === 'vexillology') {
      for (const section of this.vexillologySections) {
        lines.push(section.title);
        lines.push(section.content);
        lines.push('');
      }
    } else if (this.topic.id === 'flag-history') {
      for (const section of this.flagHistorySections) {
        lines.push(section.title);
        lines.push(section.content);
        lines.push('');
      }
    }

    return lines.join('\n');
  }

  private async onReadClick(): Promise<void> {
    if (this.isReading) {
      TextReaderUtil.stopRead();
      this.isReading = false;
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.stop_reading').id),
          duration: 2000
        });
    } else {
      try {
        const title = this.topic ? getLocalizedTopicName(this.topic, this.currentLanguage) : this.context.resourceManager.getStringSync($r('app.string.details').id);
        const content = this.getReadContent();
        await TextReaderUtil.startRead(this.context, title, content);
        this.isReading = true;
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.start_reading').id),
          duration: 2000
        });
      } catch (err) {
        console.error(`Failed to start read: ${JSON.stringify(err)}`);
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.reading_unavailable').id),
          duration: 2000
        });
      }
    }
  }

  @Builder
  SimilarFlagsView() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .width(40)
          .height(40)
          .color($r('app.color.button_primary'))
        Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
          .fontSize(14)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 12 })
      }
      .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
    } else {
      Scroll() {
        Column() {
          ForEach(this.similarFlagPairs, (pair: SimilarFlagPair, index: number) => {
            Column() {
              // 标题：xxx和xxx（使用本地化文本）
              Text(LocalizationUtil.isEnglish(this.currentLanguage) ? `${pair.nameCN1} and ${pair.nameCN2}` : `${pair.nameCN1}和${pair.nameCN2}`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 12 })
                .width('100%')
                .textAlign(TextAlign.Center)

              // 两个国旗并排显示
              Row() {
                // 第一个国旗
                Column() {
                  Image(getFlagImageSource(pair.code1))
                    .width('100%')
                    .height(80)
                    .objectFit(ImageFit.Contain)
                    .borderRadius(8)

                  Text(pair.nameCN1)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ top: 8 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/gallery/FlagDetailPage',
                      params: { countryCode: pair.code1 }
                    }).catch((err: Error) => {
                      console.error(`Navigation failed: ${err.message}`);
                    });
                  })

                // 中间分隔
                Blank()
                  .width(16)

                // 第二个国旗
                Column() {
                  Image(getFlagImageSource(pair.code2))
                    .width('100%')
                    .height(80)
                    .objectFit(ImageFit.Contain)
                    .borderRadius(8)

                  Text(pair.nameCN2)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ top: 8 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/gallery/FlagDetailPage',
                      params: { countryCode: pair.code2 }
                    }).catch((err: Error) => {
                      console.error(`Navigation failed: ${err.message}`);
                    });
                  })
              }
              .width('100%')
            }
            .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
              .margin({ bottom: 16 })
          }, (pair: SimilarFlagPair, index: number) => `pair_${pair.code1}_${pair.code2}_${index}`)
        }
        .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      }
      .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
    }
  }

  @Builder
  FlagListView() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .width(40)
          .height(40)
          .color($r('app.color.button_primary'))
        Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
          .fontSize(14)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 12 })
      }
      .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
    } else {
      Scroll() {
        Grid() {
          ForEach(this.displayItems, (item: DisplayItem, index: number) => {
            GridItem() {
              this.FlagGridItem(item)
            }
          }, (item: DisplayItem, index: number) => `${item.code}_${index}`)
        }
        .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .cachedCount(9)
      }
      .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
    }
  }

  @Builder
  KnowledgeContentView() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .width(40)
          .height(40)
          .color($r('app.color.button_primary'))
        Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
          .fontSize(14)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 12 })
      }
      .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
    } else {
      Scroll() {
        Column() {
          if (this.topic?.id === 'etiquette') {
            ForEach(this.etiquetteSections, (section: EtiquetteSection, index: number) => {
              this.KnowledgeSection(section.title, section.content, index)
            }, (section: EtiquetteSection, index: number) => `etiquette_${index}`)
          } else if (this.topic?.id === 'manufacturing') {
            ForEach(this.manufacturingSections, (section: ManufacturingSection, index: number) => {
              this.KnowledgeSection(section.title, section.content, index)
            }, (section: ManufacturingSection, index: number) => `manufacturing_${index}`)
          } else if (this.topic?.id === 'vexillology') {
            ForEach(this.vexillologySections, (section: VexillologySection, index: number) => {
              this.KnowledgeSection(section.title, section.content, index)
            }, (section: VexillologySection, index: number) => `vexillology_${index}`)
          } else if (this.topic?.id === 'flag-history') {
            ForEach(this.flagHistorySections, (section: HistorySection, index: number) => {
              this.KnowledgeSection(section.title, section.content, index)
            }, (section: HistorySection, index: number) => `flag-history_${index}`)
          }
        }
        .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      }
      .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .edgeEffect(EdgeEffect.Spring)
    }
  }

  @Builder
  KnowledgeSection(title: string, content: string, index: number) {
    Column() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })
        .width('100%')

      Text(content)
        .fontSize(15)
        .fontColor($r('app.color.text_primary'))
        .lineHeight(24)
        .width('100%')
    }
    .width('100%')
      .padding(20)
      .backgroundColor($r('app.color.bg_card'))
      .borderRadius(16)
      .margin({ bottom: 16 })
  }

  @Builder
  FlagGridItem(item: DisplayItem) {
    Column() {
      Image(getFlagImageSource(item.code))
        .width('100%')
        .height(60)
        .objectFit(ImageFit.Contain)
        .borderRadius(4)

      Text(item.localizedName)
        .fontSize(13)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
      .padding(12)
      .backgroundColor($r('app.color.bg_flag_topic'))
      .borderRadius(12)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/gallery/FlagDetailPage',
          params: { countryCode: item.code }
        }).catch((err: Error) => {
          console.error(`Navigation failed: ${err.message}`);
        });
      })
  }
}
