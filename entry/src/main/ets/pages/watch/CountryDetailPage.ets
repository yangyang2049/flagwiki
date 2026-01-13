import router from '@ohos.router'
import { Country, FlagDesign, getCountryByCode, getFlagDesign, getLocalizedCountryName, getLocalizedCapital, getLocalizedFlagDesign, getLocalizedRegionName } from '../../utils/countryData'
import { LocalizationUtil } from '../../utils/LocalizationUtil'

@Entry
@Component
struct CountryDetailPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State country: Country | null = null
  @State flagDesign: FlagDesign | undefined = undefined

  async aboutToAppear() {
    await this.loadCountry()
  }

  private async loadCountry(): Promise<void> {
    const params = router.getParams() as Record<string, Object>
    const code = params?.['code'] as string
    if (code) {
      const found = getCountryByCode(code)
      this.country = found || null
      this.flagDesign = getFlagDesign(code)
    }
  }

  private formatPopulation(population: number): string {
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      if (population >= 1_000_000_000) {
        return `${(population / 1_000_000_000).toFixed(2)} B`
      }
      if (population >= 1_000_000) {
        return `${(population / 1_000_000).toFixed(1)} M`
      }
      if (population >= 1_000) {
        return `${(population / 1_000).toFixed(0)} K`
      }
      return population.toString()
    }
    if (population >= 100000000) {
      return `${(population / 100000000).toFixed(2)} 亿人`
    }
    if (population >= 10000) {
      return `${(population / 10000).toFixed(0)} 万人`
    }
    return `${population} 人`
  }

  private formatArea(area: number): string {
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      if (area >= 1_000_000) {
        return `${(area / 1_000_000).toFixed(2)} M km²`
      }
      return `${area.toFixed(0)} km²`
    }
    if (area >= 10000) {
      return `${(area / 10000).toFixed(2)} 万km²`
    }
    return `${area.toFixed(0)} km²`
  }

  @Builder
  private InfoRow(label: Resource | string, value: string) {
    Row() {
      Text(label)
        .fontSize(12)
        .fontColor('rgba(255, 255, 255, 0.7)')

      Blank()

      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
  }

  private getFlagDescription(): string {
    if (!this.country) {
      return ''
    }
    const description = getLocalizedFlagDesign(this.flagDesign, this.currentLanguage)
    if (description) {
      return description
    }
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      return `The flag of ${this.country.name} is a symbol of its history, culture, and values.`
    }
    return `${this.country.nameCN}的国旗是这个国家的重要象征，代表着国家的历史、文化和价值观。`
  }

  build() {
    Column() {
      Scroll() {
        if (this.country) {
          Column() {
            Image($rawfile(`flags/${this.country.code}.svg`))
              .width(90)
              .height(60)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })

            Text(getLocalizedCountryName(this.country, this.currentLanguage))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 6, bottom: 10 })

            Column() {
              this.InfoRow($r('app.string.capital'), getLocalizedCapital(this.country, this.currentLanguage))
              this.InfoRow($r('app.string.region'), getLocalizedRegionName(this.country.region, this.currentLanguage))
              this.InfoRow($r('app.string.population'), this.formatPopulation(this.country.population))
              this.InfoRow($r('app.string.area'), this.formatArea(this.country.area))
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
            }
            .width('85%')
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 12, right: 12, top: 8, bottom: 10 })
            .backgroundColor('rgba(255, 255, 255, 0.08)')
            .borderRadius(8)
            .margin({ bottom: 8 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 24, bottom: 24 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, top: 0, bottom: 0 })
    .backgroundColor('#000000')
  }
}
