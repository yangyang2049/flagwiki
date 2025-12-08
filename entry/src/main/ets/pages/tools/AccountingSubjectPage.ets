interface SubjectCategory {
    name: string;
    subjects: string[];
}

@Entry
@Component
    struct AccountingSubjectPage {
    private categories: SubjectCategory[] = [
        {
            name: '资产类',
            subjects: [
                '库存现金', '银行存款', '其他货币资金', '交易性金融资产', '应收票据',
                '应收账款', '预付账款', '应收股利', '应收利息', '其他应收款',
                '坏账准备', '材料采购', '在途物资', '原材料', '材料成本差异',
                '库存商品', '发出商品', '商品进销差价', '委托加工物资', '周转材料',
                '存货跌价准备', '持有至到期投资', '持有至到期投资减值准备', '可供出售金融资产',
                '长期股权投资', '长期股权投资减值准备', '投资性房地产', '长期应收款',
                '固定资产', '累计折旧', '固定资产减值准备', '在建工程', '工程物资',
                '固定资产清理', '无形资产', '累计摊销', '无形资产减值准备', '商誉',
                '长期待摊费用', '递延所得税资产', '待处理财产损溢'
            ]
        },
        {
            name: '负债类',
            subjects: [
                '短期借款', '交易性金融负债', '应付票据', '应付账款', '预收账款',
                '应付职工薪酬', '应交税费', '应付利息', '应付股利', '其他应付款',
                '递延收益', '长期借款', '应付债券', '长期应付款', '专项应付款',
                '预计负债', '递延所得税负债'
            ]
        },
        {
            name: '所有者权益类',
            subjects: [
                '实收资本', '资本公积', '盈余公积', '本年利润', '利润分配',
                '库存股'
            ]
        },
        {
            name: '成本类',
            subjects: [
                '生产成本', '制造费用', '劳务成本', '研发支出'
            ]
        },
        {
            name: '损益类',
            subjects: [
                '主营业务收入', '其他业务收入', '公允价值变动损益', '投资收益',
                '营业外收入', '主营业务成本', '其他业务成本', '税金及附加',
                '销售费用', '管理费用', '财务费用', '资产减值损失', '营业外支出',
                '所得税费用', '以前年度损益调整'
            ]
        }
    ];

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    ForEach(this.categories, (category: SubjectCategory, index: number) => {
                        Column() {
                            Text(category.name)
                                .fontSize(16)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 12 })

                            Column() {
                                ForEach(category.subjects, (subject: string, index: number) => {
                                    Row() {
                                        Text(subject)
                                            .fontSize(14)
                                            .fontColor($r('app.color.text_dark'))
                                            .layoutWeight(1)
                                    }
                  .width('100%')
                                        .padding({ top: 10, bottom: 10, left: 12, right: 12 })
                                        .backgroundColor(index % 2 === 0 ? $r('app.color.bg_quaternary') : $r('app.color.bg_card'))

                                    if (index < category.subjects.length - 1) {
                                        Divider()
                                            .color($r('app.color.gray_border'))
                                            .margin({ left: 12, right: 12 })
                                    }
                                })
                            }
              .width('100%')
                                .backgroundColor($r('app.color.bg_card'))
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .borderRadius(0)
                            .margin({ top: index === 0 ? 0 : 16, left: 16, right: 16 })
                            .alignItems(HorizontalAlign.Start)
                    }, (category: SubjectCategory) => category.name)

                    Column() {
                        Text('💡 说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 以上为常用会计科目汇总')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 具体科目设置需根据企业实际情况')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 新会计准则可能有所调整')
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
    .title('会计科目汇总')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

