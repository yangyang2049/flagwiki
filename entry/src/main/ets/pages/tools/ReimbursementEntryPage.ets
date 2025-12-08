interface EntryTemplate {
  name: string;
  category: string;
  debit: string[];
  credit: string[];
  note: string;
  color: string;
}

@Entry
@Component
struct ReimbursementEntryPage {
  @State selectedTemplate: number = -1;

  private templates: EntryTemplate[] = [
    {
      name: '差旅费报销',
      category: '管理费用',
      color: '#1677FF',
      debit: ['管理费用—差旅费'],
      credit: ['银行存款', '或：库存现金', '或：其他应付款—员工报销'],
      note: '适用于员工出差产生的交通、住宿、餐饮等费用'
    },
    {
      name: '办公费报销',
      category: '管理费用',
      color: '#52C41A',
      debit: ['管理费用—办公费'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于购买办公用品、文具、打印等费用'
    },
    {
      name: '业务招待费',
      category: '管理费用',
      color: '#FA8C16',
      debit: ['管理费用—业务招待费'],
      credit: ['银行存款', '或：库存现金'],
      note: '注意：业务招待费税前扣除有限额（发生额的60%与年销售收入的5‰，两者取较小值）'
    },
    {
      name: '交通费报销',
      category: '管理费用',
      color: '#722ED1',
      debit: ['管理费用—交通费'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于市内交通、打车、停车费等'
    },
    {
      name: '通讯费报销',
      category: '管理费用',
      color: '#13C2C2',
      debit: ['管理费用—通讯费'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于电话费、网络费等通讯相关费用'
    },
    {
      name: '差旅费（含进项税）',
      category: '管理费用',
      color: '#FA541C',
      debit: ['管理费用—差旅费', '应交税费—应交增值税（进项税额）'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于取得增值税专用发票的差旅费，可抵扣进项税'
    },
    {
      name: '项目费用报销',
      category: '项目成本',
      color: '#EB2F96',
      debit: ['工程施工—XX项目', '或：研发支出—XX项目'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于项目制公司的项目相关费用'
    },
    {
      name: '销售费用报销',
      category: '销售费用',
      color: '#2F54EB',
      debit: ['销售费用—差旅费', '或：销售费用—业务招待费'],
      credit: ['银行存款', '或：库存现金'],
      note: '适用于销售部门产生的相关费用'
    }
  ];

  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 说明
          Column() {
            Text('报销会计分录模板')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 12 })

            Text('会计人员在处理报销时需要根据费用类型制作相应的会计凭证。以下是常见报销类型的会计分录模板。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 0, left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)

          // 模板列表
          ForEach(this.templates, (template: EntryTemplate, index: number) => {
            Column() {
              // 模板标题
              Row() {
                Column() {
                  Text(template.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                  Text(template.category)
                    .fontSize(12)
                    .fontColor($r('app.color.text_tertiary'))
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text('查看')
                  .fontSize(13)
                  .fontColor($r('app.color.button_primary'))
                  .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                  .borderRadius(4)
                  .border({ width: 1, color: $r('app.color.button_primary') })
              }
              .width('100%')
              .margin({ bottom: 16 })
              .onClick(() => {
                this.selectedTemplate = this.selectedTemplate === index ? -1 : index;
              })

              // 展开显示分录详情
              if (this.selectedTemplate === index) {
                Column() {
                  // 借方
                  Column() {
                    Text('借方')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.color_red'))
                      .alignSelf(ItemAlign.Start)
                      .margin({ bottom: 8 })

                    ForEach(template.debit, (item: string) => {
                      Row() {
                        Text('借：')
                          .fontSize(14)
                          .fontColor($r('app.color.color_red'))
                          .fontWeight(FontWeight.Bold)
                          .margin({ right: 8 })
                        Text(item)
                          .fontSize(14)
                          .fontColor($r('app.color.text_primary'))
                      }
                      .width('100%')
                      .margin({ bottom: 6 })
                    })
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor($r('app.color.bg_red_light'))
                  .borderRadius(8)
                  .margin({ bottom: 12 })
                  .alignItems(HorizontalAlign.Start)

                  // 贷方
                  Column() {
                    Text('贷方')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.color_green'))
                      .alignSelf(ItemAlign.Start)
                      .margin({ bottom: 8 })

                    ForEach(template.credit, (item: string) => {
                      Row() {
                        Text('贷：')
                          .fontSize(14)
                          .fontColor($r('app.color.color_green'))
                          .fontWeight(FontWeight.Bold)
                          .margin({ right: 8 })
                        Text(item)
                          .fontSize(14)
                          .fontColor($r('app.color.text_primary'))
                      }
                      .width('100%')
                      .margin({ bottom: 6 })
                    })
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor($r('app.color.bg_green_light'))
                  .borderRadius(8)
                  .margin({ bottom: 12 })
                  .alignItems(HorizontalAlign.Start)

                  // 注意事项
                  if (template.note) {
                    Row() {
                      Text('💡')
                        .fontSize(14)
                        .margin({ right: 8 })
                      Text(template.note)
                        .fontSize(12)
                        .fontColor($r('app.color.text_secondary'))
                        .layoutWeight(1)
                    }
                    .width('100%')
                    .padding(12)
                    .backgroundColor($r('app.color.bg_secondary'))
                    .borderRadius(8)
                  }
                }
                .width('100%')
                .margin({ top: 8 })
              }
            }
            .width('100%')
            .padding(20)
            .backgroundColor($r('app.color.bg_card'))
            .margin({ top: 16, left: 16, right: 16 })
            .alignItems(HorizontalAlign.Start)
          })

          // 通用说明
          Column() {
            Text('通用说明')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            Text('• 报销金额 = 发票金额（含税）')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
              .alignSelf(ItemAlign.Start)

            Text('• 取得专票时，需分离进项税额，借记"应交税费—应交增值税（进项税额）"')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
              .alignSelf(ItemAlign.Start)

            Text('• 费用科目可根据公司实际情况调整（如：管理费用、销售费用、研发支出等）')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
              .alignSelf(ItemAlign.Start)

            Text('• 支付方式根据实际情况选择：银行存款、库存现金、其他应付款等')
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .alignSelf(ItemAlign.Start)
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 16, left: 16, right: 16, bottom: 16 })
          .alignItems(HorizontalAlign.Start)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor($r('app.color.bg_page'))
    }
    .title('会计分录模板')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
  }
}

