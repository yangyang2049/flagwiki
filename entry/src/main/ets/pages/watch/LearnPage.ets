import router from '@ohos.router'
import { Countries, Continent, ContinentNames, ContinentNamesEN } from '../../utils/countryData'
import { LocalizationUtil } from '../../utils/LocalizationUtil'

@Component
export struct LearnPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  private readonly continents: Continent[] = ['Asia', 'Europe', 'Africa', 'Americas', 'Oceania']

  private getContinentName(continent: Continent): string {
    if (LocalizationUtil.isEnglish(this.currentLanguage)) {
      return ContinentNamesEN[continent] || continent
    }
    return ContinentNames[continent] || continent
  }

  private getTotalCount(continent: Continent): number {
    return Countries.filter(country => country.region === continent).length
  }

  build() {
    Column() {
      Text($r('app.string.watch_learn'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 8, bottom: 8 })

      Scroll() {
        Column() {
          ForEach(this.continents, (continent: Continent) => {
            Row() {
              Text(this.getContinentName(continent))
                .fontSize(16)
                .fontColor('#FFFFFF')

              Blank()

              Text(`${this.getTotalCount(continent)}`)
                .fontSize(14)
                .fontColor('rgba(255, 255, 255, 0.7)')
            }
            .width('80%')
            .height(44)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/watch/ContinentPage',
                params: {
                  continent
                }
              })
            })
            .margin({ bottom: 10 })
          }, (continent: Continent) => continent)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 4, bottom: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#000000')
  }
}
