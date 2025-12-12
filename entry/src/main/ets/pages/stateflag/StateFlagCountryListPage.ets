import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { CountryStateData, getAllCountryStateData } from '../../utils/StateFlagData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

@Entry
@Component
struct StateFlagCountryListPage {
  @State countryList: CountryStateData[] = [];
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.countryList = getAllCountryStateData();
  }
  
  private getCountryName(country: CountryStateData): string {
    return LocalizationUtil.isEnglish(this.currentLanguage) ? country.countryName : country.countryNameCN;
  }
  
  private getStateCountText(country: CountryStateData): string {
    // 根据国家代码获取对应的本地化字符串资源
    const countryCode = country.countryCode;
    
    switch (countryCode) {
      case 'jp':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_jp').id);
      case 'us':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_us').id);
      case 'de':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_de').id);
      case 'au':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_au').id);
      case 'br':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_br').id);
      case 'ca':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_ca').id);
      case 'kr':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_kr').id);
      case 'ch':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_ch').id);
      case 'gb':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_gb').id);
      case 'it':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_it').id);
      case 'es':
        return this.context.resourceManager.getStringSync($r('app.string.state_count_es').id);
      default:
        // 降级方案：显示数量
        return `${country.states.length}`;
    }
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
                  Text(this.getCountryName(country))
                    .fontSize(17)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_primary'))
                  Text(this.getStateCountText(country))
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
        .edgeEffect(EdgeEffect.Spring)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
    }
    .title(this.context.resourceManager.getStringSync($r('app.string.state_flags').id))
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}

