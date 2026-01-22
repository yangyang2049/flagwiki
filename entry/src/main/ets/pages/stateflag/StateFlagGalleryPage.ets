import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { CountryStateData, StateInfo, getCountryStateData, getStateFlagPath } from '../../utils/StateFlagData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

interface RouterParams {
  countryCode: string;
}

@Entry
@Component
  struct StateFlagGalleryPage {
  @State countryData: CountryStateData | undefined = undefined;
  @State isLoading: boolean = true;
  @State clickedItemKey: string = '';
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;

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
  
  private getCountryName(): string {
    if (!this.countryData) return '';
    return LocalizationUtil.isEnglish(this.currentLanguage) 
      ? this.countryData.countryName 
      : this.countryData.countryNameCN;
  }
  
  private getStateName(state: StateInfo): string {
    return LocalizationUtil.isEnglish(this.currentLanguage) ? state.name : state.nameCN;
  }
  
  private getTotalCountText(): string {
    if (!this.countryData) return '';
    const countryCode = this.countryData.countryCode;
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    
    // 获取对应的本地化字符串
    let countText = '';
    switch (countryCode) {
      case 'jp':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_jp').id);
        break;
      case 'us':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_us').id);
        break;
      case 'de':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_de').id);
        break;
      case 'au':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_au').id);
        break;
      case 'br':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_br').id);
        break;
      case 'ca':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_ca').id);
        break;
      case 'kr':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_kr').id);
        break;
      case 'ch':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_ch').id);
        break;
      case 'gb':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_gb').id);
        break;
      case 'it':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_it').id);
        break;
      case 'es':
        countText = this.context.resourceManager.getStringSync($r('app.string.state_count_es').id);
        break;
      default:
        countText = `${this.countryData.states.length}`;
    }
    
    // 添加"共"或"Total"前缀
    if (isEnglish) {
      return `Total ${countText}`;
    } else {
      return `共 ${countText}`;
    }
  }

  build() {
    Navigation() {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 12 })
        }
        .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.bg_page'))
      } else if (this.countryData) {
        Row() {
          Column() {
            // 顶部国家信息
            Column() {
              Image($rawfile(`flags/${this.countryData.countryCode}.svg`))
                .width(64)
                .height(42)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 8 })

              Text(this.getCountryName())
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Text(this.getTotalCountText())
                .fontSize(13)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 4 })
            }
            .width('100%')
              .padding(24)
              .backgroundColor(Color.Transparent)
              .alignItems(HorizontalAlign.Center)

            // 州旗网格
            Scroll() {
              Grid() {
                ForEach(this.countryData.states, (state: StateInfo) => {
                  GridItem() {
                    Column() {
                      Image($rawfile(getStateFlagPath(this.countryData!.countryCode, state.code)))
                        .width('100%')
                        .height(72)
                        .objectFit(ImageFit.Contain)
                        .borderRadius(4)

                      Text(this.getStateName(state))
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
                .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            }
            .layoutWeight(1)
              .scrollBar(BarState.Off)
              .edgeEffect(EdgeEffect.Spring)
          }
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.bg_page'))
          .constraintSize({ maxWidth: getContentMaxWidth() })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          Text(this.context.resourceManager.getStringSync($r('app.string.no_data').id))
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.bg_page'))
      }
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
  }
}

