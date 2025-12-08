interface TaxRateItem {
    category: string;
    items: string[];
    rate: string;
}

@Entry
@Component
    struct TaxRateListPage {
    private taxRates: TaxRateItem[] = [
        {
            category: '13% 税率',
            rate: '13%',
            items: ['销售货物', '加工修理修配劳务', '有形动产租赁', '进口货物（一般）']
        },
        {
            category: '9% 税率',
            rate: '9%',
            items: ['交通运输服务', '邮政服务', '基础电信服务', '建筑服务', '不动产租赁', '销售不动产', '转让土地使用权', '农产品']
        },
        {
            category: '6% 税率',
            rate: '6%',
            items: ['增值电信服务', '金融服务', '现代服务（研发、信息技术、文化创意等）', '生活服务（餐饮、住宿、教育等）', '销售无形资产']
        },
        {
            category: '5% 征收率',
            rate: '5%',
            items: ['不动产销售（简易）', '不动产经营租赁（简易）', '劳务派遣（差额）']
        },
        {
            category: '3% 征收率',
            rate: '3%',
            items: ['小规模纳税人（一般）', '简易计税项目']
        },
        {
            category: '0% 税率',
            rate: '0%',
            items: ['出口货物', '跨境应税行为', '航天运输服务', '国际运输服务']
        }
    ];

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    ForEach(this.taxRates, (rateItem: TaxRateItem, index: number) => {
                        Column() {
                            Row() {
                                Text(rateItem.category)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                Blank()
                                Text(rateItem.rate)
                                    .fontSize(20)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.button_primary'))
                            }
              .width('100%')
                                .margin({ bottom: 12 })

                            ForEach(rateItem.items, (item: string) => {
                                Row() {
                                    Text('•')
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ right: 8 })
                                    Text(item)
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_secondary'))
                                }
                .width('100%')
                                    .margin({ bottom: 6 })
                            })
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: index === 0 ? 0 : 16, left: 16, right: 16 })
                            .alignItems(HorizontalAlign.Start)
                    }, (rateItem: TaxRateItem) => rateItem.category)

                    Column() {
                        Text('💡 提示')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.color_orange'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 以上为增值税基本税率，具体以税务机关核定为准')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 小规模纳税人2023-2027年可享受1%优惠税率')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 部分行业有特殊税收优惠政策')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_yellow_light'))
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .layoutWeight(1)
                .scrollBar(BarState.Off)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('开票税点列表')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

