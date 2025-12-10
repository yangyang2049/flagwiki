/**
 * 历史国旗列表页
 * 显示所有有历史数据的国家列表
 */

import router from '@ohos.router';
import { getAllFlagHistory, CountryFlagHistory } from '../../utils/FlagHistoryData';
import { getCountryByCode } from '../../utils/countryData';
import { getFlagImageSource } from '../../utils/countryData';

@Entry
@Component
    struct FlagHistoryListPage {
    @State historyList: CountryFlagHistory[] = [];

    aboutToAppear() {
        this.historyList = getAllFlagHistory();
    }

    private getCountryName(countryCode: string): string {
        const country = getCountryByCode(countryCode);
        return country?.nameCN || '';
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    if (this.historyList.length === 0) {
                        // 无历史数据
                        Column() {
                            Text('暂无历史数据')
                                .fontSize(16)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ top: 100 })
                        }
            .width('100%')
                            .height('100%')
                            .justifyContent(FlexAlign.Center)
                            .alignItems(HorizontalAlign.Center)
                    } else {
                        // 国家列表
                        ForEach(this.historyList, (item: CountryFlagHistory, index: number) => {
                            Row() {
                                // 当前国旗
                                Image(getFlagImageSource(item.countryCode))
                                    .width(60)
                                    .height(40)
                                    .objectFit(ImageFit.Contain)
                                    .borderRadius(4)
                                    .border({ width: 1, color: $r('app.color.gray_very_light') })

                                Column() {
                                    Text(this.getCountryName(item.countryCode))
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Medium)
                                        .fontColor($r('app.color.text_primary'))
                                        .alignSelf(ItemAlign.Start)

                                    Text(`${item.history.length}个历史版本`)
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_secondary'))
                                        .margin({ top: 4 })
                                        .alignSelf(ItemAlign.Start)
                                }
                  .alignItems(HorizontalAlign.Start)
                                    .margin({ left: 12 })
                                    .layoutWeight(1)

                                Image($r('app.media.icon_arrow_right'))
                                    .width(20)
                                    .height(20)
                                    .opacity(0.5)
                            }
                .width('100%')
                                .padding(16)
                                .backgroundColor($r('app.color.bg_card'))
                                .borderRadius(12)
                                .margin({ bottom: 12 })
                                .alignItems(VerticalAlign.Center)
                                .onClick(() => {
                                    router.pushUrl({
                                        url: 'pages/flaghistory/FlagHistoryPage',
                                        params: { countryCode: item.countryCode }
                                    });
                                })
                        }, (item: CountryFlagHistory) => item.countryCode)
                    }
                }
        .width('100%')
                    .padding({ left: 16, right: 16, top: 16, bottom: 20 })
            }
      .width('100%')
                .height('100%')
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
        }
    .title('历史国旗')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
    }
}

