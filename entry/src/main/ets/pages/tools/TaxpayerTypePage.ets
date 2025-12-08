import { AmountInput } from '../../components/AmountInput';

@Entry
@Component
    struct TaxpayerTypePage {
    @State annualRevenue: string = '';
    @State result: string = '';
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.annualRevenue || this.annualRevenue.trim() === '') {
            this.errorMessage = '请输入年应税销售额';
            return false;
        }
        const revenue = parseFloat(this.annualRevenue);
        if (isNaN(revenue) || revenue < 0) {
            this.errorMessage = '年应税销售额不能为负数';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private judge(): void {
        if (!this.validateInputs()) {
            return;
        }

        const revenue = parseFloat(this.annualRevenue);

        if (revenue > 5000000) {
            this.result = '一般纳税人';
        } else {
            this.result = '小规模纳税人';
        }
        this.showResult = true;
    }

    build() {
        Column() {
            Navigation() {
                Scroll() {
                    Column() {
                        Column() {
                            AmountInput({
                                label: '年应税销售额（元）',
                                placeholder: '请输入预计年销售额',
                                value: this.annualRevenue,
                                onChange: (val: string) => {
                                    this.annualRevenue = val;
                                }
                            })

                            Text('标准：年销售额500万元')
                                .fontSize(12)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ top: 8 })
                                .alignSelf(ItemAlign.Start)

                            if (this.errorMessage) {
                                Text(this.errorMessage)
                                    .fontSize(12)
                                    .fontColor($r('app.color.color_red'))
                                    .margin({ top: 8 })
                                    .alignSelf(ItemAlign.Start)
                            }
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 0, left: 16, right: 16 })

                        Button('判断')
                            .type(ButtonType.Normal)
                            .backgroundColor($r('app.color.button_primary'))
                            .fontColor($r('app.color.text_white'))
                            .fontSize(16)
                            .width('80%')
                            .constraintSize({ maxWidth: 320 })
                            .height(48)
                            .borderRadius(8)
                            .margin({ top: 16, left: 16, right: 16 })
                            .onClick(() => this.judge())

                        if (this.showResult) {
                            Column() {
                                Text('建议身份')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_tertiary'))
                                Text(this.result)
                                    .fontSize(28)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor(this.result === '一般纳税人' ? $r('app.color.button_primary') : $r('app.color.color_green'))
                                    .margin({ top: 8 })
                            }
              .width('100%')
                                .padding(24)
                                .backgroundColor($r('app.color.bg_card'))
                                .margin({ top: 16, left: 16, right: 16 })
                        }

                        // 对比表
                        Row() {
                            Column() {
                                Text('小规模纳税人')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_green'))
                                    .margin({ bottom: 12 })
                                Text('• 年销售额≤500万')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 征收率3%/5%')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 账务处理简单')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 季度≤30万免税')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 不可抵扣进项')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                            }
              .layoutWeight(1)
                                .padding(16)
                                .backgroundColor($r('app.color.bg_green_light'))
                                .borderRadius(8)
                                .alignItems(HorizontalAlign.Start)

                            Column() {
                                Text('一般纳税人')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.button_primary'))
                                    .margin({ bottom: 12 })
                                Text('• 年销售额>500万')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 税率6%/9%/13%')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 账务要求规范')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 无免税额度')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 4 })
                                Text('• 可抵扣进项税')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_secondary'))
                            }
              .layoutWeight(1)
                                .padding(16)
                                .backgroundColor($r('app.color.bg_blue_light'))
                                .borderRadius(8)
                                .margin({ left: 12 })
                                .alignItems(HorizontalAlign.Start)
                        }
            .width('100%')
                            .padding({ left: 16, right: 16 })
                            .margin({ top: 16 })

                        Column() {
                            Text('选择建议')
                                .fontSize(15)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 12 })
                            Text('• 进项较多（采购成本高）→ 一般纳税人')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ bottom: 4 })
                            Text('• 主要成本是人工 → 小规模纳税人')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ bottom: 4 })
                            Text('• 客户要求专票 → 一般纳税人')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ bottom: 4 })
                            Text('• 小规模可主动申请转一般纳税人')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom: 16
                            })
                            .alignItems(HorizontalAlign.Start)
                    }
                }
        .scrollBar(BarState.Off)
                    .backgroundColor($r('app.color.bg_page'))
            }
      .title('纳税人身份判断')
                .titleMode(NavigationTitleMode.Mini)
                .hideBackButton(false)
                .backgroundColor($r('app.color.bg_page'))
        }
    }
}