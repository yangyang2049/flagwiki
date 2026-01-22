import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import display from '@ohos.display';
import {
  Country,
  Continent,
  ContinentNames,
  ContinentNamesEN,
  getCountriesByContinent,
  getAllContinents,
  getFlagImageSource,
  getLocalizedCountryName,
  getLocalizedRegionName
} from '../../utils/countryData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';
import { DeviceHelper } from '../../utils/DeviceHelper';

@Component
export struct GalleryPage {
  @State countries: Country[] = [];
  @State filteredCountries: Country[] = [];
  @State selectedContinent: Continent = 'World';
  @State searchText: string = '';
  @State screenWidth: number = 360;
  @Prop @Watch('onSearchExpandedChanged') isSearchExpanded: boolean = false;
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') systemLanguage: string = 'zh';
  @Prop context?: common.UIAbilityContext;
  private appContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.updateScreenWidth();
    this.loadCountries();
  }

  private updateScreenWidth(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      this.screenWidth = px2vp(displayInfo.width);
    } catch (error) {
      console.error('[GalleryPage] Error getting screen width:', error);
      this.screenWidth = 360;
    }
  }

  private getGridColumns(): string {
    // 根据屏幕宽度和是否为pad/2in1调整列数
    const isPadOr2in1 = DeviceHelper.isPadOr2in1();
    if (isPadOr2in1) {
      // pad/2in1: 根据宽度调整，但保持全屏
      if (this.screenWidth >= 1200) {
        return '1fr 1fr 1fr 1fr 1fr 1fr'; // 6列
      } else if (this.screenWidth >= 900) {
        return '1fr 1fr 1fr 1fr 1fr'; // 5列
      } else if (this.screenWidth >= 600) {
        return '1fr 1fr 1fr 1fr'; // 4列
      } else {
        return '1fr 1fr 1fr'; // 3列
      }
    } else {
      // 手机: 保持3列
      return '1fr 1fr 1fr';
    }
  }

  private onLanguageChanged(): void {
    this.loadCountries();
  }

  private onSearchExpandedChanged(): void {
    if (!this.isSearchExpanded) {
      this.searchText = '';
      this.filterCountries();
    }
  }

  private loadCountries(): void {
    this.countries = getCountriesByContinent(this.selectedContinent);
    // 按本地化名称排序
    const isEnglish = LocalizationUtil.isEnglish(this.systemLanguage);
    this.countries.sort((a, b) => {
      const nameA = getLocalizedCountryName(a, this.systemLanguage);
      const nameB = getLocalizedCountryName(b, this.systemLanguage);
      return isEnglish ? nameA.localeCompare(nameB, 'en') : nameA.localeCompare(nameB, 'zh-CN');
    });
    this.filterCountries();
  }

  private filterCountries(): void {
    if (this.searchText.trim() === '') {
      this.filteredCountries = this.countries;
    } else {
      const keyword = this.searchText.trim().toLowerCase();
      this.filteredCountries = this.countries.filter((country) => {
        const localizedName = getLocalizedCountryName(country, this.systemLanguage).toLowerCase();
        return localizedName.includes(keyword) ||
          country.nameCN.toLowerCase().includes(keyword) ||
          country.name.toLowerCase().includes(keyword) ||
          country.code.toLowerCase().includes(keyword) ||
          country.capitalCN.toLowerCase().includes(keyword);
      });
    }
  }

  private selectContinent(continent: Continent): void {
    this.selectedContinent = continent;
    this.loadCountries();
  }

  private onSearchChange(value: string): void {
    this.searchText = value;
    this.filterCountries();
  }

  private goToFlagDetail(country: Country): void {
    router.pushUrl({
      url: 'pages/gallery/FlagDetailPage',
      params: {
        countryCode: country.code
      }
    }).catch((err: Error) => {
      console.error(`Navigation failed: ${err.message}`);
    });
  }

  build() {
    Column() {
      // 搜索区域 - 全宽
      if (this.isSearchExpanded) {
        Row() {
          Search({ 
            value: this.searchText, 
            placeholder: this.appContext.resourceManager.getStringSync($r('app.string.search_country_or_region').id) 
          })
            .layoutWeight(1)
            .height(40)
            .onChange((value: string) => {
              this.onSearchChange(value);
            })
            .onSubmit((value: string) => {
              this.onSearchChange(value);
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      }

      // 洲际筛选器 - 全宽
      Scroll() {
        Row() {
          ForEach(getAllContinents(), (continent: Continent) => {
            this.ContinentChip(continent)
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(44)
      .backgroundColor($r('app.color.bg_title_bar'))

      // 国旗网格 - 全宽，根据屏幕宽度调整列数
      if (this.filteredCountries.length === 0) {
        Column() {
          if (this.searchText.trim() !== '') {
            Text(this.appContext.resourceManager.getStringSync($r('app.string.no_matching_countries').id))
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))

            Text(this.appContext.resourceManager.getStringSync($r('app.string.modify_keywords_or_select').id))
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .margin({ top: 8 })
              .opacity(0.7)
          } else {
            Text(this.appContext.resourceManager.getStringSync($r('app.string.loading').id))
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Grid() {
          ForEach(this.filteredCountries, (country: Country) => {
            GridItem() {
              this.FlagItem(country)
            }
          })
        }
        .columnsTemplate(this.getGridColumns())
        .columnsGap(12)
        .rowsGap(16)
        .padding({ left: 16, right: 16, top: 12, bottom: 16 })
        .layoutWeight(1)
        .backgroundColor($r('app.color.bg_gallery'))
        .edgeEffect(EdgeEffect.Spring)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_title_bar'))
  }

  @Builder
  ContinentChip(continent: Continent) {
    Text(LocalizationUtil.isEnglish(this.systemLanguage) ? ContinentNamesEN[continent] : ContinentNames[continent])
      .fontSize(14)
      .fontWeight(this.selectedContinent === continent ? FontWeight.Medium : FontWeight.Normal)
      .fontColor(this.selectedContinent === continent ? $r('app.color.white') : $r('app.color.text_secondary'))
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor(this.selectedContinent === continent ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
      .borderRadius(16)
      .margin({ right: 8 })
      .onClick(() => {
        this.selectContinent(continent);
      })
  }

  @Builder
  FlagItem(country: Country) {
    Column() {
      // 国旗图片
      Image(getFlagImageSource(country.code))
        .width('100%')
        .height(65)
        .objectFit(ImageFit.Contain)

      // 国家名称
      Text(getLocalizedCountryName(country, this.systemLanguage))
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .padding({ top: 10, bottom: 10, left: 4, right: 4 })
    }
    .width('100%')
      .onClick(() => {
        this.goToFlagDetail(country);
      })
  }
}
