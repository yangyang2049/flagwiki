interface InvoiceType {
  name: string;
  features: string[];
  deductible: boolean;
}

@Entry
@Component
struct InvoiceTypePage {
  private invoiceTypes: InvoiceType[] = [
    {
      name: '增值税专用发票',
      features: ['一般纳税人开具', '可抵扣进项税', '三联或六联', '需认证后抵扣'],
      deductible: true
    },
    {
      name: '增值税普通发票',
      features: ['一般纳税人和小规模均可开具', '不可抵扣进项税', '两联', '可作为成本费用凭证'],
      deductible: false
    },
    {
      name: '增值税电子普通发票',
      features: ['与纸质普票同等法律效力', '可自行打印', '便于保存和传输', '防伪验证方便'],
      deductible: false
    },
    {
      name: '增值税电子专用发票',
      features: ['与纸质专票同等法律效力', '可抵扣进项税', '电子签章', '全流程电子化'],
      deductible: true
    },
    {
      name: '机动车销售统一发票',
      features: ['购买机动车专用', '可抵扣进项税', '含车辆信息', '上牌必备'],
      deductible: true
    },
    {
      name: '通行费电子发票',
      features: ['高速公路通行费', '左上角标"通行费"', '可按规定抵扣', 'ETC用户专用'],
      deductible: true
    }
  ];

  build() {
    Navigation() {
      Scroll() {
        Column() {
          ForEach(this.invoiceTypes, (invoice: InvoiceType, index: number) => {
            Column() {
              Row() {
                Text(invoice.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .layoutWeight(1)
                Text(invoice.deductible ? '可抵扣' : '不可抵扣')
                  .fontSize(12)
                  .fontColor(invoice.deductible ? $r('app.color.color_green') : $r('app.color.color_orange'))
                  .backgroundColor(invoice.deductible ? $r('app.color.bg_green_light') : $r('app.color.bg_yellow_light'))
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(4)
              }
              .width('100%')
              .margin({ bottom: 12 })

              ForEach(invoice.features, (feature: string) => {
                Row() {
                  Text('•')
                    .fontSize(14)
                    .fontColor($r('app.color.button_primary'))
                    .margin({ right: 8 })
                  Text(feature)
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
          }, (invoice: InvoiceType) => invoice.name)

          // 专票vs普票对比
          Column() {
            Text('专票 vs 普票')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            Row() {
              Column() {
                Text('专用发票')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.button_primary'))
                  .margin({ bottom: 8 })
                Text('✓ 可抵扣进项税')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 4 })
                Text('✓ 一般纳税人开具')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 4 })
                Text('✓ 需要认证')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
              }
              .layoutWeight(1)
              .padding(16)
              .backgroundColor($r('app.color.bg_blue_light'))
              .borderRadius(8)

              Column() {
                Text('普通发票')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.color_green'))
                  .margin({ bottom: 8 })
                Text('✗ 不可抵扣')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 4 })
                Text('✓ 均可开具')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 4 })
                Text('✓ 无需认证')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
              }
              .layoutWeight(1)
              .padding(16)
              .backgroundColor($r('app.color.bg_green_light'))
              .borderRadius(8)
              .margin({ left: 12 })
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 16, left: 16, right: 16, bottom: 16 })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor($r('app.color.bg_page'))
    }
    .title('发票类型说明')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
  }
}

