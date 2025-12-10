/**
 * 历史国旗详情页
 * 显示各国国旗的历史变迁
 */

import router from '@ohos.router';
import { getFlagHistory, FlagHistoryItem } from '../../utils/FlagHistoryData';
import { getCountryByCode } from '../../utils/countryData';

@Entry
@Component
  struct FlagHistoryPage {
  @State countryCode: string = '';
  @State historyItems: FlagHistoryItem[] = [];
  @State countryName: string = '';

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['countryCode']) {
      this.countryCode = params['countryCode'];
      this.historyItems = getFlagHistory(this.countryCode);

      const country = getCountryByCode(this.countryCode);
      if (country) {
        this.countryName = country.nameCN;
      }
    }
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          if (this.historyItems.length === 0) {
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
            // 显示历史国旗列表
            Column() {
              // 标题
              Text(`${this.countryName}国旗变迁史`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ top: 20, bottom: 20 })
                .alignSelf(ItemAlign.Start)

              // 历史国旗列表（按年份倒序）
              ForEach(this.historyItems.sort((a, b) => b.year - a.year), (item: FlagHistoryItem, index: number) => {
                Row() {
                  // 左侧时间线
                  Column() {
                    // 时间线上的点
                    Circle()
                      .width(12)
                      .height(12)
                      .fill($r('app.color.button_primary'))

                    // 时间线（竖线）
                    Column()
                      .width(2)
                      .height(180)
                      .backgroundColor($r('app.color.text_secondary'))
                      .opacity(0.25)
                      .margin({ top: 1 })
                  }
                  .width(24)
                    .alignItems(HorizontalAlign.Center)
                    .margin({ right: 16 })

                  // 右侧内容
                  Column() {
                    // 年份标签
                    Row() {
                      Text(item.year.toString())
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .fontColor($r('app.color.text_primary'))

                      if (index === 0) {
                        Text('（当前）')
                          .fontSize(14)
                          .fontColor($r('app.color.text_secondary'))
                          .margin({ left: 8 })
                      }
                    }
                    .width('100%')
                      .margin({ bottom: 4 })
                      .alignItems(VerticalAlign.Center)

                    // 国旗图片（更窄）
                    // 图片资源名称格式：flag_history_{countryCode}_{year}
                    // 例如：flag_history_cn_1912
                    Image($rawfile(`flag_history/${item.imagePath}.png`))
                      .width('60%')
                      .height(160)
                      .objectFit(ImageFit.Contain)
                      .margin({ bottom: 12 })
                      .alignSelf(ItemAlign.Start)
                  }
                    .width('100%')
                    .padding({ left: 12, right: 12 })
                    .borderRadius(16)
                }
                .width('100%')
                  .margin({ bottom: 12 })
              })
            }
            .width('100%')
              .padding({ left: 16, right: 16 })
          }
        }
        .width('100%')
          .padding({ bottom: 20 })
      }
      .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor($r('app.color.bg_page'))
    }
    .title('')
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor($r('app.color.bg_page'))
  }
}

