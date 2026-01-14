import router from '@ohos.router'
import { Countries, Country, Continent, ContinentNames, ContinentNamesEN, getLocalizedCountryName } from '../../utils/countryData'
import { LocalizationUtil } from '../../utils/LocalizationUtil'

@Entry
@Component
struct ContinentPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State continent: Continent = 'Asia'
  @State continentCountries: Country[] = []

  aboutToAppear() {
    this.loadContinent()
  }

  private loadContinent(): void {
    const params = router.getParams() as Record<string, Object>
    const value = params?.['continent'] as string
    if (value && ['Asia', 'Europe', 'Africa', 'Americas', 'Oceania'].includes(value)) {
      this.continent = value as Continent
    }
    this.continentCountries = Countries.filter(country => country.region === this.continent)
  }

  private getContinentName(): string {
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      return ContinentNamesEN[this.continent] || this.continent
    }
    return ContinentNames[this.continent] || this.continent
  }

  build() {
    Column() {
      Text(this.getContinentName())
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 8, bottom: 8 })

      Scroll() {
        Column() {
          ForEach(this.continentCountries, (country: Country) => {
            Row() {
              Image($rawfile(`flags/${country.code}.svg`))
                .width(32)
                .height(26)
                .objectFit(ImageFit.Contain)
                .margin({ right: 10 })

              Text(getLocalizedCountryName(country, this.currentLanguage))
                .fontSize(16)
                .fontColor('#FFFFFF')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .layoutWeight(1)
                .textAlign(TextAlign.Start)

              Blank()
            }
            .width('80%')
            .height(52)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/watch/CountryDetailPage',
                params: {
                  code: country.code
                }
              })
            })
            .margin({ bottom: 8 })
          }, (country: Country) => country.code)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 4, bottom: 0 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .focusable(true)
      .defaultFocus(true)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 0 })
    .backgroundColor('#000000')
  }
}
