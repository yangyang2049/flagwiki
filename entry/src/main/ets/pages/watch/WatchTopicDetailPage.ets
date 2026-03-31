import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { TopicItem, getTopicById, getTopicName, getTopicDescription } from '../topic/TopicData'
import {
  Country,
  getCountryByCode,
  getInternationalOrgByCode,
  getLocalizedCountryName,
  getLocalizedOrgName,
  isInternationalOrg
} from '../../utils/countryData'
import { EtiquetteSection, getLocalizedEtiquetteContent } from '../topic/FlagEtiquetteData'
import { ManufacturingSection, getLocalizedManufacturingContent } from '../topic/FlagManufacturingData'
import { VexillologySection, getLocalizedVexillologyContent } from '../topic/FlagVexillologyData'
import { HistorySection, getLocalizedFlagHistoryContent } from '../topic/FiveStarRedFlagHistoryData'
import { WatchLayout } from '../../utils/WatchUiConstants'
import { WatchFlagImage } from './WatchFlagImage'

interface RouterParams {
  topicId: string
}

interface DisplayItem {
  code: string
  nameCN: string
  name: string
}

interface SimilarFlagPair {
  code1: string
  nameCN1: string
  code2: string
  nameCN2: string
}

/** 与专题列表行宽一致 */
const WATCH_TOPIC_CONTENT_WIDTH: string = '80%'

@Entry
@Component
struct WatchTopicDetailPage {
  @StorageLink('currentLanguage') @Watch('onCurrentLanguageChanged') currentLanguage: string = 'zh'
  @State topic: TopicItem | undefined = undefined
  @State displayItems: DisplayItem[] = []
  @State isLoading: boolean = true
  @State etiquetteSections: EtiquetteSection[] = []
  @State manufacturingSections: ManufacturingSection[] = []
  @State vexillologySections: VexillologySection[] = []
  @State flagHistorySections: HistorySection[] = []
  @State isKnowledgeTopic: boolean = false
  @State similarFlagPairs: SimilarFlagPair[] = []
  private scroller: Scroller = new Scroller()
  private context = getContext(this) as common.UIAbilityContext

  private onCurrentLanguageChanged(): void {
    if (!this.topic || !this.isKnowledgeTopic) {
      return
    }
    this.loadKnowledgeContent()
  }

  aboutToAppear(): void {
    const params = router.getParams() as RouterParams
    if (params && params.topicId) {
      this.topic = getTopicById(params.topicId)
      if (this.topic) {
        this.isKnowledgeTopic = this.topic.countryCodes.length === 0
        if (this.isKnowledgeTopic) {
          this.loadKnowledgeContent()
        } else if (this.topic.id === 'similar-flags') {
          this.loadSimilarFlags()
        } else {
          this.loadCountries()
        }
      }
    }
  }

  private loadCountries(): void {
    if (!this.topic) {
      return
    }
    this.isLoading = true
    const displayList: DisplayItem[] = []
    for (const code of this.topic.countryCodes) {
      if (isInternationalOrg(code)) {
        const org = getInternationalOrgByCode(code)
        if (org) {
          displayList.push({ code: org.code, nameCN: org.nameCN, name: org.name })
        }
      } else {
        const country = getCountryByCode(code)
        if (country) {
          displayList.push({ code: country.code, nameCN: country.nameCN, name: country.name })
        }
      }
    }
    this.displayItems = displayList
    this.isLoading = false
  }

  private loadKnowledgeContent(): void {
    if (!this.topic) {
      return
    }
    this.isLoading = true
    if (this.topic.id === 'etiquette') {
      this.etiquetteSections = getLocalizedEtiquetteContent(this.currentLanguage)
    } else if (this.topic.id === 'manufacturing') {
      this.manufacturingSections = getLocalizedManufacturingContent(this.currentLanguage)
    } else if (this.topic.id === 'vexillology') {
      this.vexillologySections = getLocalizedVexillologyContent(this.currentLanguage)
    } else if (this.topic.id === 'flag-history') {
      this.flagHistorySections = getLocalizedFlagHistoryContent(this.currentLanguage)
    }
    this.isLoading = false
  }

  private loadSimilarFlags(): void {
    if (!this.topic) {
      return
    }
    this.isLoading = true
    this.similarFlagPairs = [
      { code1: 'mc', nameCN1: '', code2: 'id', nameCN2: '' },
      { code1: 'nl', nameCN1: '', code2: 'lu', nameCN2: '' },
      { code1: 'ro', nameCN1: '', code2: 'td', nameCN2: '' },
      { code1: 'cn', nameCN1: '', code2: 'vn', nameCN2: '' },
      { code1: 'ke', nameCN1: '', code2: 'ss', nameCN2: '' },
      { code1: 'ad', nameCN1: '', code2: 'md', nameCN2: '' },
      { code1: 'ir', nameCN1: '', code2: 'tj', nameCN2: '' },
      { code1: 'ie', nameCN1: '', code2: 'ci', nameCN2: '' }
    ]
    this.isLoading = false
  }

  private getCountText(): string {
    if (!this.topic || this.isKnowledgeTopic) {
      return ''
    }
    const count = this.topic.id === 'similar-flags' ? this.similarFlagPairs.length : this.displayItems.length
    if (this.topic.id === 'international') {
      return this.context.resourceManager.getStringSync($r('app.string.total_organizations').id, count.toString())
    }
    if (this.topic.id === 'similar-flags') {
      return this.context.resourceManager.getStringSync($r('app.string.total_similar_flags').id, count.toString())
    }
    return this.context.resourceManager.getStringSync($r('app.string.total_countries').id, count.toString())
  }

  private openFlagDetail(code: string): void {
    router.pushUrl({ url: 'pages/watch/CountryDetailPage', params: { code } }).catch((err: Error) => {
      console.error(`WatchTopicDetailPage navigation: ${err.message}`)
    })
  }

  private getItemDisplayName(item: DisplayItem): string {
    if (isInternationalOrg(item.code)) {
      const org = getInternationalOrgByCode(item.code)
      return org ? getLocalizedOrgName(org, this.currentLanguage) : item.nameCN
    }
    const country = getCountryByCode(item.code)
    return country ? getLocalizedCountryName(country as Country, this.currentLanguage) : item.nameCN
  }

  private getCountryNameByCode(code: string): string {
    const country = getCountryByCode(code)
    return country ? getLocalizedCountryName(country as Country, this.currentLanguage) : code
  }

  private getSimilarFlagPairTitle(pair: SimilarFlagPair): string {
    const name1 = this.getCountryNameByCode(pair.code1)
    const name2 = this.getCountryNameByCode(pair.code2)
    return this.context.resourceManager.getStringSync(
      $r('app.string.similar_flag_pair_title').id,
      name1,
      name2
    )
  }

  @Builder
  KnowledgeSectionCard(title: string, content: string) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .margin({ bottom: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Text(content)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.85)')
        .lineHeight(18)
        .width('100%')
        .textAlign(TextAlign.Start)
    }
    .width('100%')
      .padding(12)
      .backgroundColor('rgba(255, 255, 255, 0.08)')
      .borderRadius(10)
      .margin({ bottom: WatchLayout.listItemGap })
  }

  @Builder
  KnowledgeBlock() {
    if (this.topic?.id === 'etiquette') {
      ForEach(this.etiquetteSections, (section: EtiquetteSection, index: number) => {
        this.KnowledgeSectionCard(section.title, section.content)
      }, (section: EtiquetteSection, index: number) => `et-${index}`)
    } else if (this.topic?.id === 'manufacturing') {
      ForEach(this.manufacturingSections, (section: ManufacturingSection, index: number) => {
        this.KnowledgeSectionCard(section.title, section.content)
      }, (section: ManufacturingSection, index: number) => `mf-${index}`)
    } else if (this.topic?.id === 'vexillology') {
      ForEach(this.vexillologySections, (section: VexillologySection, index: number) => {
        this.KnowledgeSectionCard(section.title, section.content)
      }, (section: VexillologySection, index: number) => `vx-${index}`)
    } else if (this.topic?.id === 'flag-history') {
      ForEach(this.flagHistorySections, (section: HistorySection, index: number) => {
        this.KnowledgeSectionCard(section.title, section.content)
      }, (section: HistorySection, index: number) => `fh-${index}`)
    }
  }

  @Builder
  SimilarFlagsBlock() {
    ForEach(this.similarFlagPairs, (pair: SimilarFlagPair, index: number) => {
      Column() {
        Text(this.getSimilarFlagPairTitle(pair))
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .margin({ bottom: 8 })
          .width('100%')
          .textAlign(TextAlign.Center)

        Row() {
          Column() {
            WatchFlagImage({ code: pair.code1, flagHeight: 44 })
            Text(this.getCountryNameByCode(pair.code1))
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.9)')
              .margin({ top: 4 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .layoutWeight(1)
            .onClick(() => {
              this.openFlagDetail(pair.code1)
            })

          Blank().width(8)

          Column() {
            WatchFlagImage({ code: pair.code2, flagHeight: 44 })
            Text(this.getCountryNameByCode(pair.code2))
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.9)')
              .margin({ top: 4 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .layoutWeight(1)
            .onClick(() => {
              this.openFlagDetail(pair.code2)
            })
        }
        .width('100%')
      }
      .width('100%')
        .padding(10)
        .backgroundColor('rgba(255, 255, 255, 0.08)')
        .borderRadius(10)
        .margin({ bottom: WatchLayout.listItemGap })
    }, (pair: SimilarFlagPair, index: number) => `sf-${pair.code1}-${pair.code2}-${index}`)
  }

  @Builder
  FlagGridItemWatch(item: DisplayItem) {
    Column() {
      WatchFlagImage({ code: item.code, flagHeight: 36 })
      Text(this.getItemDisplayName(item))
        .fontSize(10)
        .fontColor('rgba(255,255,255,0.9)')
        .margin({ top: 4 })
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
      .padding(6)
      .backgroundColor('rgba(255, 255, 255, 0.08)')
      .borderRadius(8)
      .onClick(() => {
        this.openFlagDetail(item.code)
      })
  }

  @Builder
  FlagGridBlock() {
    Grid() {
      ForEach(this.displayItems, (item: DisplayItem, index: number) => {
        GridItem() {
          this.FlagGridItemWatch(item)
        }
      }, (item: DisplayItem, index: number) => `${item.code}-${index}`)
    }
    .columnsTemplate('1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .width('100%')
  }

  build() {
    Navigation() {
      Row() {
        Row() {
          if (this.topic) {
            Scroll(this.scroller) {
              Column() {
                Text(this.topic.emoji)
                  .fontSize(32)
                  .margin({ bottom: 8 })

                Text(getTopicName(this.topic.id, this.context, this.currentLanguage))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                  .width('100%')
                  .textAlign(TextAlign.Center)

                Text(getTopicDescription(this.topic.id, this.context, this.currentLanguage))
                  .fontSize(11)
                  .fontColor('rgba(255, 255, 255, 0.75)')
                  .lineHeight(16)
                  .margin({ top: 6 })
                  .width('100%')
                  .textAlign(TextAlign.Center)

                if (!this.isKnowledgeTopic) {
                  Text(this.getCountText())
                    .fontSize(10)
                    .fontColor('rgba(255, 255, 255, 0.5)')
                    .margin({ top: 6 })
                    .width('100%')
                    .textAlign(TextAlign.Center)
                }

                if (this.isLoading) {
                  Column() {
                    LoadingProgress()
                      .width(28)
                      .height(28)
                      .color('#FFFFFF')
                    Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
                      .fontSize(11)
                      .fontColor('rgba(255,255,255,0.6)')
                      .margin({ top: 8 })
                  }
                  .width('100%')
                    .padding({ top: 24 })
                } else if (this.isKnowledgeTopic) {
                  Column() {
                    this.KnowledgeBlock()
                  }
                  .width('100%')
                    .alignItems(HorizontalAlign.Start)
                    .margin({ top: 12 })
                } else if (this.topic.id === 'similar-flags') {
                  Column() {
                    this.SimilarFlagsBlock()
                  }
                  .width('100%')
                    .margin({ top: 12 })
                } else {
                  Column() {
                    this.FlagGridBlock()
                  }
                  .width('100%')
                    .margin({ top: 12 })
                }
              }
              .width('100%')
                .alignItems(HorizontalAlign.Center)
                .padding({ top: 8, bottom: 24 })
            }
            .width('100%')
              .layoutWeight(1)
              .scrollable(ScrollDirection.Vertical)
              .scrollBar(BarState.Off)
              .edgeEffect(EdgeEffect.Spring)
          } else {
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.no_data').id))
                .fontSize(12)
                .fontColor('rgba(255,255,255,0.6)')
            }
            .width('100%')
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
          }
        }
        .width(WATCH_TOPIC_CONTENT_WIDTH)
          .height('100%')
      }
      .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .backgroundColor('#000000')
  }
}
