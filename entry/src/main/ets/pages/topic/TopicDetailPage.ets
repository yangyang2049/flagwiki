import router from '@ohos.router';
import { TopicItem, getTopicById, getTopicName, getTopicDescription } from './TopicData';
import { getCountryByCode, Country, getFlagImageSource, getInternationalOrgByCode, InternationalOrg, isInternationalOrg, getLocalizedCountryName, getLocalizedOrgName } from '../../utils/countryData';
import { EtiquetteSection, getEtiquetteContent } from './FlagEtiquetteData';
import { ManufacturingSection, getManufacturingContent } from './FlagManufacturingData';
import { VexillologySection, getVexillologyContent } from './FlagVexillologyData';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import { DeviceHelper } from '../../utils/DeviceHelper';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

interface RouterParams {
  topicId: string;
}

interface DisplayItem {
  code: string;
  nameCN: string;
  name: string;
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
  @State isKnowledgeTopic: boolean = false;
  @State isReading: boolean = false;
  @State similarFlagPairs: SimilarFlagPair[] = [];
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;

  private get isEnglish(): boolean {
    return LocalizationUtil.isEnglish(this.currentLanguage);
  }

  async aboutToAppear() {
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
            name: org.name
          });
        }
      } else {
        const country = getCountryByCode(code);
        if (country) {
          countryList.push(country);
          displayList.push({
            code: country.code,
            nameCN: country.nameCN,
            name: country.name
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

    // 根据专题ID加载对应的知识内容
    if (this.topic.id === 'etiquette') {
      this.etiquetteSections = getEtiquetteContent();
    } else if (this.topic.id === 'manufacturing') {
      this.manufacturingSections = getManufacturingContent();
    } else if (this.topic.id === 'vexillology') {
      this.vexillologySections = getVexillologyContent();
    }

    this.isLoading = false;
  }

  private loadSimilarFlags(): void {
    if (!this.topic) return;

    this.isLoading = true;

    // 相似旗组合定义（只存储代码，名称在显示时动态获取）
    const pairs: SimilarFlagPair[] = [
      { code1: 'mc', nameCN1: '', code2: 'id', nameCN2: '' },
      { code1: 'nl', nameCN1: '', code2: 'lu', nameCN2: '' },
      { code1: 'ro', nameCN1: '', code2: 'td', nameCN2: '' },
      { code1: 'cn', nameCN1: '', code2: 'vn', nameCN2: '' },
      { code1: 'ke', nameCN1: '', code2: 'ss', nameCN2: '' },
      { code1: 'ad', nameCN1: '', code2: 'md', nameCN2: '' },
      { code1: 'ir', nameCN1: '', code2: 'tj', nameCN2: '' },
      { code1: 'ie', nameCN1: '', code2: 'ci', nameCN2: '' }
    ];

    this.similarFlagPairs = pairs;
    this.isLoading = false;
  }

  private getCountText(): string {
    if (!this.topic || this.isKnowledgeTopic) {
      return '';
    }
    const count = this.topic.id === 'similar-flags' ? this.similarFlagPairs.length : this.displayItems.length;
    if (this.topic.id === 'international') {
      return this.context.resourceManager.getStringSync($r('app.string.total_organizations').id, count.toString());
    } else if (this.topic.id === 'similar-flags') {
      return this.context.resourceManager.getStringSync($r('app.string.total_similar_flags').id, count.toString());
    } else {
      return this.context.resourceManager.getStringSync($r('app.string.total_countries').id, count.toString());
    }
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          if (this.topic) {
            Column() {
              // 专题介绍卡片 - 无圆角
              Column() {
                Text(this.topic.emoji)
                  .fontSize(48)
                  .margin({ bottom: 12 })

                Text(getTopicName(this.topic.id, this.context, this.currentLanguage))
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))

                Text(getTopicDescription(this.topic.id, this.context, this.currentLanguage))
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
                .backgroundColor(DeviceHelper.isPadOr2in1() ? Color.Transparent : $r('app.color.bg_card'))

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
            .constraintSize({ maxWidth: getContentMaxWidth() })
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
            .constraintSize({ maxWidth: getContentMaxWidth() })
          }
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
    .menus(this.isKnowledgeTopic ? this.MenuBuilder : undefined)
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
      Image($r('app.media.icon_voice'))
        .width(24)
        .height(24)
        .onClick(() => {
          this.onReadClick();
        })
    }
    .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: 16 })
  }

  private getReadContent(): string {
    if (!this.topic) return '';

    const lines: string[] = [];
    lines.push(this.topic.description);
    lines.push('');

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
    }

    return lines.join('\n');
  }

  private async onReadClick(): Promise<void> {
    if (this.isReading) {
      TextReaderUtil.stopRead();
      this.isReading = false;
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.reading_stopped').id),
        duration: 2000
      });
    } else {
      try {
        const title = this.topic ? getTopicName(this.topic.id, this.context, this.currentLanguage) : this.context.resourceManager.getStringSync($r('app.string.topic_detail').id);
        const content = this.getReadContent();
        await TextReaderUtil.startRead(this.context, title, content);
        this.isReading = true;
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.reading_started').id),
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
              // 标题：xxx和xxx
              Text(this.getSimilarFlagPairTitle(pair))
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

                  Text(this.getCountryNameByCode(pair.code1))
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

                  Text(this.getCountryNameByCode(pair.code2))
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

      Text(this.getItemDisplayName(item))
        .fontSize(13)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
      .padding(12)
      .backgroundColor($r('app.color.bg_card'))
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

  private getItemDisplayName(item: DisplayItem): string {
    if (isInternationalOrg(item.code)) {
      const org = getInternationalOrgByCode(item.code);
      return org ? getLocalizedOrgName(org, this.currentLanguage) : item.nameCN;
    } else {
      const country = getCountryByCode(item.code);
      return country ? getLocalizedCountryName(country, this.currentLanguage) : item.nameCN;
    }
  }

  private getCountryNameByCode(code: string): string {
    const country = getCountryByCode(code);
    return country ? getLocalizedCountryName(country, this.currentLanguage) : code;
  }

  private getSimilarFlagPairTitle(pair: SimilarFlagPair): string {
    const name1 = this.getCountryNameByCode(pair.code1);
    const name2 = this.getCountryNameByCode(pair.code2);
    if (this.isEnglish) {
      return `${name1} and ${name2}`;
    } else {
      return `${name1}和${name2}`;
    }
  }
}
