import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import {
  Country,
  FlagDesign,
  InternationalOrg,
  getCountryByCode,
  getFlagDesign,
  getInternationalOrgByCode,
  getLocalizedCountryName,
  getLocalizedCapital,
  getLocalizedFlagDesign,
  getLocalizedRegionName,
  getLocalizedOrgName,
  getLocalizedOrgHeadquarters,
  isInternationalOrg
} from '../../utils/countryData'
import { WatchFlagImage } from './WatchFlagImage'
import { LocalizationUtil } from '../../utils/LocalizationUtil'

@Entry
@Component
struct CountryDetailPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State country: Country | null = null
  @State internationalOrg: InternationalOrg | null = null
  @State flagDesign: FlagDesign | undefined = undefined
  private scrollScroller: Scroller = new Scroller()
  private readonly emptyCountry: Country = {
    code: '',
    name: '',
    nameCN: '',
    capital: '',
    capitalCN: '',
    region: '',
    population: 0,
    area: 0
  }

  async aboutToAppear() {
    await this.loadCountry()
  }

  private async loadCountry(): Promise<void> {
    const params = router.getParams() as Record<string, Object>
    const code = params?.['code'] as string
    if (!code) {
      this.country = null
      this.internationalOrg = null
      this.flagDesign = undefined
      return
    }
    if (isInternationalOrg(code)) {
      this.country = null
      this.flagDesign = undefined
      this.internationalOrg = getInternationalOrgByCode(code) ?? null
    } else {
      this.internationalOrg = null
      const found = getCountryByCode(code)
      this.country = found || null
      this.flagDesign = getFlagDesign(code)
    }
  }

  private formatPopulation(population: number): string {
    const rm = getContext(this) as common.UIAbilityContext;
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      if (population >= 1_000_000_000) {
        return `${(population / 1_000_000_000).toFixed(2)}${rm.resourceManager.getStringSync($r('app.string.population_unit_billion_short').id)}`;
      }
      if (population >= 1_000_000) {
        return `${(population / 1_000_000).toFixed(1)}${rm.resourceManager.getStringSync($r('app.string.population_unit_million_short').id)}`;
      }
      if (population >= 1_000) {
        return `${(population / 1_000).toFixed(0)}${rm.resourceManager.getStringSync($r('app.string.population_unit_thousand_short').id)}`;
      }
      return population.toString();
    }
    if (population >= 100000000) {
      return `${(population / 100000000).toFixed(2)}${rm.resourceManager.getStringSync($r('app.string.population_unit_billion_short').id)}`;
    }
    if (population >= 10000) {
      return `${(population / 10000).toFixed(0)}${rm.resourceManager.getStringSync($r('app.string.population_unit_million_short').id)}`;
    }
    return `${population}${rm.resourceManager.getStringSync($r('app.string.population_unit_person').id)}`;
  }

  private formatArea(area: number): string {
    const rm = getContext(this) as common.UIAbilityContext;
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      if (area >= 1_000_000) {
        return `${(area / 1_000_000).toFixed(2)}${rm.resourceManager.getStringSync($r('app.string.area_unit_million_km2_short').id)}`;
      }
      return `${area.toFixed(0)}${rm.resourceManager.getStringSync($r('app.string.area_unit_km2_short').id)}`;
    }
    if (area >= 10000) {
      return `${(area / 10000).toFixed(2)}${rm.resourceManager.getStringSync($r('app.string.area_unit_million_km2_short').id)}`;
    }
    return `${area.toFixed(0)}${rm.resourceManager.getStringSync($r('app.string.area_unit_km2_short').id)}`;
  }

  @Builder
  private InfoRow(label: Resource | string, value: string, labelWeight: number = 4, valueWeight: number = 6) {
    Row() {
      Text(label)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.7)')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(labelWeight)
        .textAlign(TextAlign.Start)

      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.End)
        .layoutWeight(valueWeight)
        .margin({ left: 8 })
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(VerticalAlign.Top)
  }

  /** 英文国际组织详情：标签与内容分行，便于长英文展示 */
  @Builder
  private OrgInfoRowEnglish(label: Resource | string, value: string) {
    Column() {
      Text(label)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.7)')
        .width('100%')
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .lineHeight(16)

      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Start)
        .lineHeight(18)
        .margin({ top: 4 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ top: 6, bottom: 6 })
  }

  private getFlagDescription(): Resource | string {
    if (!this.country) {
      return ''
    }
    const description = getLocalizedFlagDesign(this.flagDesign, this.currentLanguage)
    if (description) {
      return description
    }
    return $r('app.string.watch_flag_desc_unavailable')
  }

  private getInternationalOrgDescription(): string {
    if (!this.internationalOrg) {
      return ''
    }
    if (LocalizationUtil.isEnglish(this.currentLanguage) && this.internationalOrg.descriptionEN) {
      return this.internationalOrg.descriptionEN
    }
    return this.internationalOrg.description ?? ''
  }

  private getOrgTypeDisplay(org: InternationalOrg): string {
    return LocalizationUtil.isEnglish(this.currentLanguage) ? org.orgType : org.orgTypeCN
  }

  /** 中文界面下主标题下方展示英文别名；英文界面不展示中文名 */
  private getInternationalOrgSecondaryName(org: InternationalOrg): string {
    return org.name
  }

  private getInternationalOrgTitleMaxLines(): number {
    return LocalizationUtil.isEnglish(this.currentLanguage) ? 4 : 2
  }

  private getDisplayCountry(): Country {
    return this.country ?? this.emptyCountry
  }

  private hasContent(): boolean {
    return this.country !== null || this.internationalOrg !== null
  }

  build() {

      Scroll(this.scrollScroller) {
        Column() {
          if (this.country) {
            WatchFlagImage({ code: this.country.code, flagWidth: 90, flagHeight: 60 })
              .margin({ bottom: 12 })

            Text(getLocalizedCountryName(this.getDisplayCountry(), this.currentLanguage))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 6, bottom: 10 })

            Column() {
              this.InfoRow($r('app.string.capital'), getLocalizedCapital(this.getDisplayCountry(), this.currentLanguage))
              this.InfoRow($r('app.string.region'), getLocalizedRegionName(this.getDisplayCountry().region, this.currentLanguage))
              this.InfoRow($r('app.string.population'), this.formatPopulation(this.getDisplayCountry().population), 5, 5)
              this.InfoRow($r('app.string.area'), this.formatArea(this.getDisplayCountry().area))
            }
            .width('85%')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor('rgba(255, 255, 255, 0.08)')
            .borderRadius(8)
            .margin({ bottom: 12 })

            Column() {
              Text($r('app.string.about_flag'))
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .fontColor('rgba(255, 255, 255, 0.7)')
                .margin({ bottom: 6 })

              Text(this.getFlagDescription())
                .fontSize(12)
                .fontColor('#FFFFFF')
                .lineHeight(16)
                .textAlign(TextAlign.Start)
            }
            .width('85%')
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 12, right: 12, top: 8, bottom: 10 })
            .backgroundColor('rgba(255, 255, 255, 0.08)')
            .borderRadius(8)
            .margin({ bottom: 8 })
          } else if (this.internationalOrg) {
            WatchFlagImage({ code: this.internationalOrg.code, flagWidth: 90, flagHeight: 60 })
              .margin({ bottom: 12 })

            Text(getLocalizedOrgName(this.internationalOrg, this.currentLanguage))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .textAlign(TextAlign.Center)
              .maxLines(this.getInternationalOrgTitleMaxLines())
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({
                top: 6,
                bottom: LocalizationUtil.isEnglish(this.currentLanguage) ? 10 : 4
              })

            if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
              Text(this.getInternationalOrgSecondaryName(this.internationalOrg))
                .fontSize(12)
                .fontColor('rgba(255, 255, 255, 0.65)')
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 10 })
            }

            if (LocalizationUtil.isEnglish(this.currentLanguage)) {
              Column() {
                this.OrgInfoRowEnglish($r('app.string.headquarters'),
                  getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage))
                this.OrgInfoRowEnglish($r('app.string.region'),
                  getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage))
                this.OrgInfoRowEnglish($r('app.string.org_type'), this.getOrgTypeDisplay(this.internationalOrg))
                this.OrgInfoRowEnglish($r('app.string.coverage_population'),
                  this.formatPopulation(this.internationalOrg.population))
                if (this.internationalOrg.website) {
                  this.OrgInfoRowEnglish($r('app.string.website'), this.internationalOrg.website)
                }
              }
              .width('85%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('rgba(255, 255, 255, 0.08)')
              .borderRadius(8)
              .margin({ bottom: 12 })
            } else {
              Column() {
                this.InfoRow($r('app.string.headquarters'),
                  getLocalizedOrgHeadquarters(this.internationalOrg, this.currentLanguage))
                this.InfoRow($r('app.string.region'),
                  getLocalizedRegionName(this.internationalOrg.region, this.currentLanguage))
                this.InfoRow($r('app.string.org_type'), this.getOrgTypeDisplay(this.internationalOrg))
                this.InfoRow($r('app.string.coverage_population'),
                  this.formatPopulation(this.internationalOrg.population), 5, 5)
                if (this.internationalOrg.website) {
                  this.InfoRow($r('app.string.website'), this.internationalOrg.website, 4, 6)
                }
              }
              .width('85%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('rgba(255, 255, 255, 0.08)')
              .borderRadius(8)
              .margin({ bottom: 12 })
            }

            if (this.getInternationalOrgDescription().length > 0) {
              Column() {
                Text($r('app.string.description'))
                  .fontSize(12)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('rgba(255, 255, 255, 0.7)')
                  .margin({ bottom: 6 })

                Text(this.getInternationalOrgDescription())
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .lineHeight(16)
                  .textAlign(TextAlign.Start)
              }
              .width('85%')
              .alignItems(HorizontalAlign.Start)
              .padding({ left: 12, right: 12, top: 8, bottom: 10 })
              .backgroundColor('rgba(255, 255, 255, 0.08)')
              .borderRadius(8)
              .margin({ bottom: 8 })
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 24, bottom: 24 })
        .visibility(this.hasContent() ? Visibility.Visible : Visibility.None)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .focusable(true)
      .defaultFocus(true)

    .height('100%')
    .padding({ left: 16, right: 16, top: 0, bottom: 0 })
    .backgroundColor('#000000')
  }
}
