import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct SmallVatPage {
    @State revenue: string = '';
    @State taxRate: number = 0.03; // 默认选择 3%
    @State isExempt: boolean = false;
    @State vatAmount: number = 0;
    @State revenueExcludingTax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.revenue || this.revenue.trim() === '') {
            this.errorMessage = '请输入含税销售额';
            return false;
        }
        const revenueNum = parseFloat(this.revenue);
        if (isNaN(revenueNum) || revenueNum <= 0) {
            this.errorMessage = '含税销售额必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const revenueNum = parseFloat(this.revenue);

        if (this.isExempt) {
            this.vatAmount = 0;
            this.revenueExcludingTax = revenueNum;
        } else {
            this.revenueExcludingTax = revenueNum / (1 + this.taxRate);
            this.vatAmount = revenueNum - this.revenueExcludingTax;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 税率选择
                    Column() {
                        Text('征收率')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Row() {
                            this.RateButton('1%', 0.01)
                            this.RateButton('3%', 0.03)
                            this.RateButton('5%', 0.05)
                        }
                        .width('100%')
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 输入金额
                    Column() {
                        AmountInput({
                            label: '含税销售额（元）',
                            placeholder: '请输入含税销售额',
                            value: this.revenue,
                            onChange: (val: string) => {
                                this.revenue = val;
                            }
                        })

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
                        .margin({ top: 16, left: 16, right: 16 })

                    Button('计算')
                        .type(ButtonType.Normal)
                        .backgroundColor($r('app.color.button_primary'))
                        .fontColor($r('app.color.text_white'))
                        .fontSize(16)
                        .width('80%')
                        .constraintSize({ maxWidth: 320 })
                        .height(48)
                        .borderRadius(8)
                        .margin({ top: 16, left: 16, right: 16 })
                        .onClick(() => {
                            this.calculate();
                            inputMethod.getController().stopInputSession();
                        })

                    if (this.showResult) {
                        Column() {
                            Text('计算结果')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            Row() {
                                Text('不含税销售额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.revenueExcludingTax.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('应缴增值税')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.vatAmount.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor(this.isExempt ? $r('app.color.color_green') : $r('app.color.color_red'))
                            }
              .width('100%')

                            if (this.isExempt) {
                                Text('✓ 符合免税条件')
                                    .fontSize(13)
                                    .fontColor($r('app.color.color_green'))
                                    .margin({ top: 12 })
                            }
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    // 说明
                    Column() {
                        Text('小规模纳税人政策')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Text('• 年销售额≤500万元')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 6 })
                        Text('• 一般征收率3%，特殊行业5%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 6 })
                        Text('• 月销售额≤10万或季度≤30万免征')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 6 })
                        Text('• 2023-2027年征收率1%优惠政策')
                            .fontSize(13)
                            .fontColor($r('app.color.button_primary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('小规模纳税人增值税')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    RateButton(text: string, rate: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.taxRate === rate ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.taxRate === rate ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.taxRate = rate; })
    }
}

