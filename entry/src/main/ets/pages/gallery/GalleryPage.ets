import router from '@ohos.router';
import {
  Country,
  Continent,
  ContinentNames,
  getCountriesByContinent,
  getAllContinents,
  getFlagImageSource
} from '../../utils/countryData';

@Component
export struct GalleryPage {
  @State countries: Country[] = [];
  @State filteredCountries: Country[] = [];
  @State selectedContinent: Continent = 'World';
  @State searchText: string = '';
  @Prop @Watch('onSearchExpandedChanged') isSearchExpanded: boolean = false;

  aboutToAppear() {
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
    // 按中文名称排序
    this.countries.sort((a, b) => a.nameCN.localeCompare(b.nameCN, 'zh-CN'));
    this.filterCountries();
  }

  private filterCountries(): void {
    if (this.searchText.trim() === '') {
      this.filteredCountries = this.countries;
    } else {
      const keyword = this.searchText.trim().toLowerCase();
      this.filteredCountries = this.countries.filter((country) => {
        return country.nameCN.toLowerCase().includes(keyword) ||
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
      // 搜索区域
      if (this.isSearchExpanded) {
        Row() {
          Search({ value: this.searchText, placeholder: '搜索国家或地区' })
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

      // 洲际筛选器
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

      // 国旗网格
      if (this.filteredCountries.length === 0) {
        Column() {
          if (this.searchText.trim() !== '') {
            Text('未找到匹配的国家')
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))
          } else {
            Text('加载中...')
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Grid() {
          ForEach(this.filteredCountries, (country: Country) => {
            GridItem() {
              this.FlagItem(country)
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
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
    Text(ContinentNames[continent])
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
      Text(country.nameCN)
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
