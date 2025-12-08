interface LawCategory {
    name: string;
    laws: string[];
}

@Entry
@Component
    struct TaxLawLibraryPage {
    private categories: LawCategory[] = [
        {
            name: '税收法律法规',
            laws: [
                '中华人民共和国税收征收管理法',
                '中华人民共和国个人所得税法',
                '中华人民共和国企业所得税法',
                '中华人民共和国增值税暂行条例',
                '中华人民共和国消费税暂行条例',
                '中华人民共和国城市维护建设税法',
                '中华人民共和国印花税法',
                '中华人民共和国车辆购置税法',
                '中华人民共和国资源税法',
                '中华人民共和国环境保护税法'
            ]
        },
        {
            name: '财务会计法规',
            laws: [
                '中华人民共和国会计法',
                '企业会计准则',
                '小企业会计准则',
                '企业财务通则',
                '会计基础工作规范',
                '企业内部控制基本规范',
                '企业内部控制应用指引',
                '企业内部控制评价指引'
            ]
        },
        {
            name: '发票管理法规',
            laws: [
                '中华人民共和国发票管理办法',
                '中华人民共和国发票管理办法实施细则',
                '增值税专用发票使用规定',
                '网络发票管理办法',
                '电子发票管理办法'
            ]
        },
        {
            name: '税收优惠政策',
            laws: [
                '小微企业普惠性税收减免政策',
                '研发费用加计扣除政策',
                '高新技术企业税收优惠政策',
                '西部大开发税收优惠政策',
                '支持疫情防控税收优惠政策',
                '支持重点群体创业就业税收政策',
                '支持企业重组改制税收政策'
            ]
        },
        {
            name: '税务征管规定',
            laws: [
                '纳税信用管理办法',
                '重大税收违法失信案件信息公布办法',
                '税务登记管理办法',
                '税务行政复议规则',
                '税务行政处罚裁量权行使规则',
                '税收违法行为检举管理办法'
            ]
        }
    ];

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    ForEach(this.categories, (category: LawCategory, index: number) => {
                        Column() {
                            Text(category.name)
                                .fontSize(16)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 12 })

                            Column() {
                                ForEach(category.laws, (law: string, index: number) => {
                                    Row() {
                                        Text('📄')
                                            .fontSize(16)
                                            .margin({ right: 8 })
                                        Text(law)
                                            .fontSize(14)
                                            .fontColor($r('app.color.text_dark'))
                                            .layoutWeight(1)
                                    }
                  .width('100%')
                                        .padding({ top: 12, bottom: 12, left: 12, right: 12 })

                                    if (index < category.laws.length - 1) {
                                        Divider()
                                            .color($r('app.color.gray_border'))
                                            .margin({ left: 12, right: 12 })
                                    }
                                })
                            }
              .width('100%')
                                .backgroundColor($r('app.color.bg_quaternary'))
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .borderRadius(0)
                            .margin({ top: index === 0 ? 0 : 16, left: 16, right: 16 })
                            .alignItems(HorizontalAlign.Start)
                    }, (category: LawCategory) => category.name)

                    Column() {
                        Text('💡 提示')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 本工具提供常用财税法规索引')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 具体法规内容请查阅官方最新版本')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 建议访问国家税务总局、财政部官网')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_yellow_light'))
                        .borderRadius(0)
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('财税法规库')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

