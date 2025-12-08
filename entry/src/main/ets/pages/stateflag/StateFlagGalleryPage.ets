import router from '@ohos.router';
import { CountryStateData, StateInfo, getCountryStateData, getStateFlagPath } from '../../utils/StateFlagData';

interface RouterParams {
  countryCode: string;
}

@Entry
@Component
struct StateFlagGalleryPage {
  @State countryData: CountryStateData | undefined = undefined;
  @State isLoading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    // 延迟加载以显示loading状态
    setTimeout(() => {
      if (params && params.countryCode) {
        this.countryData = getCountryStateData(params.countryCode);
      }
      this.isLoading = false;
    }, 600);
  }

  build() {
    Navigation() {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text('加载中...')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.bg_page'))
      } else if (this.countryData) {
        Column() {
          // 顶部国家信息
          Column() {
            Image($rawfile(`flags/${this.countryData.countryCode}.svg`))
              .width(64)
              .height(42)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 8 })

            Text(this.countryData.countryNameCN)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`共 ${this.countryData.states.length} 个${this.countryData.stateLabel}`)
              .fontSize(13)
              .fontColor($r('app.color.text_tertiary'))
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ bottom: 12 })
          .alignItems(HorizontalAlign.Center)

          // 州旗网格
          Grid() {
            ForEach(this.countryData.states, (state: StateInfo) => {
              GridItem() {
                Column() {
                  Image($rawfile(getStateFlagPath(this.countryData!.countryCode, state.code)))
                    .width('100%')
                    .height(72)
                    .objectFit(ImageFit.Contain)
                    .borderRadius(4)

                  Text(state.nameCN)
                    .fontSize(12)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ top: 8 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
                .padding(10)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(12)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/stateflag/StateFlagDetailPage',
                    params: {
                      countryCode: this.countryData!.countryCode,
                      stateCode: state.code
                    }
                  });
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.bg_page'))
      } else {
        Column() {
          Text('暂无数据')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.bg_page'))
      }
    }
    .title(this.countryData ? `${this.countryData.countryNameCN}${this.countryData.stateLabel}旗` : '州旗画廊')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}

