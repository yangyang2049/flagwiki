import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct GeneralVatPage {
    @State outputRevenue: string = '';
    @State outputRate: number = 0.13;
    @State inputCost: string = '';
    @State inputRate: number = 0.13;
    @State outputTax: number = 0;
    @State inputTax: number = 0;
    @State payableTax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.outputRevenue || this.outputRevenue.trim() === '') {
            this.errorMessage = '请输入含税销售额';
            return false;
        }
        const outputNum = parseFloat(this.outputRevenue);
        if (isNaN(outputNum) || outputNum <= 0) {
            this.errorMessage = '含税销售额必须大于0';
            return false;
        }
        if (!this.inputCost || this.inputCost.trim() === '') {
            this.errorMessage = '请输入含税采购额';
            return false;
        }
        const inputNum = parseFloat(this.inputCost);
        if (isNaN(inputNum) || inputNum < 0) {
            this.errorMessage = '含税采购额不能为负数';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const outputNum = parseFloat(this.outputRevenue);
        const inputNum = parseFloat(this.inputCost) || 0;

        // 销项税额 = 不含税销售额 × 税率
        const outputExcludingTax = outputNum / (1 + this.outputRate);
        this.outputTax = outputExcludingTax * this.outputRate;

        // 进项税额 = 不含税采购额 × 税率
        const inputExcludingTax = inputNum / (1 + this.inputRate);
        this.inputTax = inputExcludingTax * this.inputRate;

        // 应纳税额 = 销项 - 进项
        this.payableTax = Math.max(0, this.outputTax - this.inputTax);

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 销项税
                    Column() {
                        Text('销项（销售）')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 16 })

                        AmountInput({
                            label: '含税销售额（元）',
                            placeholder: '请输入含税销售额',
                            value: this.outputRevenue,
                            onChange: (val: string) => {
                                this.outputRevenue = val;
                            }
                        })

                        Text('税率')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ top: 16, bottom: 8 })
                        Row() {
                            this.RateButton('13%', 0.13, true)
                            this.RateButton('9%', 0.09, true)
                            this.RateButton('6%', 0.06, true)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 进项税
                    Column() {
                        Text('进项（采购）')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 16 })

                        AmountInput({
                            label: '含税采购额（元）',
                            placeholder: '请输入含税采购额',
                            value: this.inputCost,
                            onChange: (val: string) => {
                                this.inputCost = val;
                            }
                        })

                        Text('税率')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ top: 16, bottom: 8 })
                        Row() {
                            this.RateButton('13%', 0.13, false)
                            this.RateButton('9%', 0.09, false)
                            this.RateButton('6%', 0.06, false)
                            this.RateButton('3%', 0.03, false)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)

                        if (this.errorMessage) {
                            Text(this.errorMessage)
                                .fontSize(12)
                                .fontColor($r('app.color.color_red'))
                                .margin({ top: 16 })
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
                                Text('销项税额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.outputTax.toFixed(2)}`)
                                    .fontSize(15)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')
                                .padding({ top: 6, bottom: 6 })

                            Row() {
                                Text('进项税额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`-¥${this.inputTax.toFixed(2)}`)
                                    .fontSize(15)
                                    .fontColor($r('app.color.color_green'))
                            }
              .width('100%')
                                .padding({ top: 6, bottom: 6 })

                            Divider().color($r('app.color.button_primary')).margin({ top: 8, bottom: 8 })

                            Row() {
                                Text('应缴增值税')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                Blank()
                                Text(`¥${this.payableTax.toFixed(2)}`)
                                    .fontSize(18)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_red'))
                            }
              .width('100%')

                            if (this.inputTax > this.outputTax) {
                                Text('进项大于销项，留抵税额可结转下期')
                                    .fontSize(12)
                                    .fontColor($r('app.color.button_primary'))
                                    .margin({ top: 12 })
                            }
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                    }
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('一般纳税人增值税')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    RateButton(text: string, rate: number, isOutput: boolean) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(13)
            .fontColor((isOutput ? this.outputRate === rate : this.inputRate === rate) ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor((isOutput ? this.outputRate === rate : this.inputRate === rate) ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(36)
            .borderRadius(16)
            .margin({ right: 8 })
            .onClick(() => {
                if (isOutput) {
                    this.outputRate = rate;
                } else {
                    this.inputRate = rate;
                }
            })
    }
}

