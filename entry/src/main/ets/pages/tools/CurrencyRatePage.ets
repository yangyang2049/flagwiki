interface Currency {
    name: string;
    code: string;
    symbol: string;
    buyRate: number;
    sellRate: number;
    midRate: number;
}

@Entry
@Component
    struct CurrencyRatePage {
    @State updateTime: string = '';
    @State currencies: Currency[] = [
        { name: '美元', code: 'USD', symbol: '$', buyRate: 7.12, sellRate: 7.15, midRate: 7.135 },
        { name: '欧元', code: 'EUR', symbol: '€', buyRate: 7.85, sellRate: 7.88, midRate: 7.865 },
        { name: '英镑', code: 'GBP', symbol: '£', buyRate: 9.05, sellRate: 9.08, midRate: 9.065 },
        { name: '日元', code: 'JPY', symbol: '¥', buyRate: 0.0485, sellRate: 0.0488, midRate: 0.04865 },
        { name: '港币', code: 'HKD', symbol: 'HK$', buyRate: 0.91, sellRate: 0.915, midRate: 0.9125 },
        { name: '澳元', code: 'AUD', symbol: 'A$', buyRate: 4.75, sellRate: 4.78, midRate: 4.765 },
        { name: '加元', code: 'CAD', symbol: 'C$', buyRate: 5.25, sellRate: 5.28, midRate: 5.265 },
        { name: '新加坡元', code: 'SGD', symbol: 'S$', buyRate: 5.35, sellRate: 5.38, midRate: 5.365 },
        { name: '瑞士法郎', code: 'CHF', symbol: 'CHF', buyRate: 8.15, sellRate: 8.18, midRate: 8.165 },
        { name: '新西兰元', code: 'NZD', symbol: 'NZ$', buyRate: 4.35, sellRate: 4.38, midRate: 4.365 }
    ];

    aboutToAppear(): void {
        this.updateTime = this.getCurrentTime();
    }

    private getCurrentTime(): string {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Row() {
                        Text('更新时间：' + this.updateTime)
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                        Blank()
                        Text('刷新')
                            .fontSize(12)
                            .fontColor($r('app.color.button_primary'))
                            .onClick(() => {
                                this.updateTime = this.getCurrentTime();
                            })
                    }
          .width('100%')
                        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                        .margin({ top: 16 })

                    Column() {
                        Row() {
                            Text('货币')
                                .fontSize(13)
                                .fontWeight(FontWeight.Medium)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(2)
                            Text('现汇买入')
                                .fontSize(13)
                                .fontWeight(FontWeight.Medium)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(1)
                                .textAlign(TextAlign.Center)
                            Text('现汇卖出')
                                .fontSize(13)
                                .fontWeight(FontWeight.Medium)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(1)
                                .textAlign(TextAlign.Center)
                            Text('中间价')
                                .fontSize(13)
                                .fontWeight(FontWeight.Medium)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(1)
                                .textAlign(TextAlign.Center)
                        }
            .width('100%')
                            .padding({ top: 12, bottom: 12, left: 16, right: 16 })
                            .backgroundColor($r('app.color.bg_secondary'))

                        ForEach(this.currencies, (currency: Currency, index: number) => {
                            Row() {
                                Column() {
                                    Text(currency.name)
                                        .fontSize(14)
                                        .fontWeight(FontWeight.Medium)
                                        .fontColor($r('app.color.text_primary'))
                                    Text(currency.code)
                                        .fontSize(11)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ top: 2 })
                                }
                .alignItems(HorizontalAlign.Start)
                                    .layoutWeight(2)

                                Text(currency.buyRate.toFixed(4))
                                    .fontSize(13)
                                    .fontColor($r('app.color.color_green'))
                                    .layoutWeight(1)
                                    .textAlign(TextAlign.Center)

                                Text(currency.sellRate.toFixed(4))
                                    .fontSize(13)
                                    .fontColor($r('app.color.color_red'))
                                    .layoutWeight(1)
                                    .textAlign(TextAlign.Center)

                                Text(currency.midRate.toFixed(4))
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_secondary'))
                                    .layoutWeight(1)
                                    .textAlign(TextAlign.Center)
                            }
              .width('100%')
                                .padding({ top: 14, bottom: 14, left: 16, right: 16 })
                                .backgroundColor($r('app.color.bg_card'))

                            if (index < this.currencies.length - 1) {
                                Divider()
                                    .color($r('app.color.gray_border'))
                                    .margin({ left: 16, right: 16 })
                            }
                        })
                    }
          .width('100%')
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 0, left: 16, right: 16 })

                    Column() {
                        Text('💡 说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 现汇买入价：银行买入外币的价格')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 现汇卖出价：银行卖出外币的价格')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 中间价：买入价和卖出价的平均值')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 汇率实时变动，仅供参考，以银行实际报价为准')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_orange_light'))
                        .borderRadius(0)
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('货币牌价')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

