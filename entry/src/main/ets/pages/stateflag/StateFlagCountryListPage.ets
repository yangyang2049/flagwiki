import router from '@ohos.router';
import { CountryStateData, getAllCountryStateData } from '../../utils/StateFlagData';

@Entry
@Component
struct StateFlagCountryListPage {
  @State countryList: CountryStateData[] = [];

  aboutToAppear() {
    this.countryList = getAllCountryStateData();
  }

  build() {
    Navigation() {
      Column() {
        List() {
          ForEach(this.countryList, (country: CountryStateData) => {
            ListItem() {
              Row() {
                // 国旗图片
                Image($rawfile(`flags/${country.countryCode}.svg`))
                  .width(60)
                  .height(40)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 16 })

                // 国家信息
                Column() {
                  Text(country.countryNameCN)
                    .fontSize(17)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_primary'))
                  Text(`${country.states.length} 个${country.stateLabel}`)
                    .fontSize(13)
                    .fontColor($r('app.color.text_tertiary'))
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text('›')
                  .fontSize(20)
                  .fontColor($r('app.color.gray_disabled'))
              }
              .width('100%')
              .padding(16)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
            }
            .margin({ bottom: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/stateflag/StateFlagGalleryPage',
                params: { countryCode: country.countryCode }
              });
            })
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 16 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
    }
    .title('各国州旗')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}

