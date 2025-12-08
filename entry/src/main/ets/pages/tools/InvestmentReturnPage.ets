import { AmountInput } from '../../components/AmountInput';

import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct InvestmentReturnPage {
    @State principal: string = '';
    @State annualRate: string = '';
    @State years: string = '';
    @State investmentType: number = 0; // 0: 单利 1: 复利
    @State finalAmount: number = 0;
    @State totalReturn: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.principal || this.principal.trim() === '') {
            this.errorMessage = '请输入本金';
            return false;
        }
        if (!this.annualRate || this.annualRate.trim() === '') {
            this.errorMessage = '请输入年化收益率';
            return false;
        }
        if (!this.years || this.years.trim() === '') {
            this.errorMessage = '请输入投资期限';
            return false;
        }
        const p = parseFloat(this.principal);
        const r = parseFloat(this.annualRate);
        const n = parseFloat(this.years);
        if (isNaN(p) || p <= 0) {
            this.errorMessage = '本金必须大于0';
            return false;
        }
        if (isNaN(r) || r < 0) {
            this.errorMessage = '年化收益率不能为负数';
            return false;
        }
        if (isNaN(n) || n <= 0) {
            this.errorMessage = '投资期限必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const p = parseFloat(this.principal);
        const r = parseFloat(this.annualRate);
        const n = parseFloat(this.years);

        if (this.investmentType === 0) {
            // 单利
            this.totalReturn = p * r * n / 100;
            this.finalAmount = p + this.totalReturn;
        } else {
            // 复利
            this.finalAmount = p * Math.pow(1 + r / 100, n);
            this.totalReturn = this.finalAmount - p;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        Text('投资类型')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Row() {
                            this.TypeButton('单利', 0)
                            this.TypeButton('复利', 1)
                        }
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 0, left: 16, right: 16 })

                    Column() {
                        AmountInput({
                            label: '本金（元）',
                            placeholder: '请输入本金',
                            value: this.principal,
                            onChange: (val: string) => {
                                this.principal = val;
                            }
                        })
                            .margin({ bottom: 16 })
                        this.InputField('年化收益率（%）', this.annualRate, (v: string) => { this.annualRate = v; })
                        this.InputField('投资年限', this.years, (v: string) => { this.years = v; })
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
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
                            Row() {
                                Column() {
                                    Text('最终金额')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`¥${this.finalAmount.toFixed(2)}`)
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.button_primary'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)

                                Divider()
                                    .vertical(true)
                                    .height(60)
                                    .color($r('app.color.gray_border'))

                                Column() {
                                    Text('投资收益')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`¥${this.totalReturn.toFixed(2)}`)
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.color_green'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)
                            }
              .width('100%')
                        }
            .width('100%')
                            .padding(24)
                            .backgroundColor($r('app.color.bg_card'))
                            .borderRadius(0)
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    Column() {
                        Text('计算公式')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('单利：最终金额 = 本金 × (1 + 年化收益率 × 年限)')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('复利：最终金额 = 本金 × (1 + 年化收益率)^年限')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('• 单利：利息不产生利息')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 复利：利息再投资，收益更高')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('投资收益计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TypeButton(text: string, type: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.investmentType === type ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.investmentType === type ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.investmentType = type; })
    }

    @Builder
    InputField(label: string, value: string, onChange: (v: string) => void) {
        Column() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ bottom: 8 })
            TextInput({ text: value, placeholder: '请输入' })
                .type(InputType.Number)
                .height(48)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(8)
                .onChange((newValue: string) => {
                    // 根据标签判断验证方式
                    let validatedValue = newValue;
                    if (label.includes('收益率') || label.includes('利率') || label.includes('%')) {
                        validatedValue = InputValidator.validatePercentageInput(newValue);
                    } else {
                        validatedValue = InputValidator.validateNumberInput(newValue);
                    }
                    onChange(validatedValue);
                })
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }
}

