import { inputMethod } from '@kit.IMEKit';
import { AmountInput } from '../../components/AmountInput';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct CompoundInterestPage {
    @State principal: string = '';
    @State annualRate: string = '';
    @State years: string = '';
    @State compoundFrequency: number = 1; // 复利频率：1=年，2=半年，4=季度，12=月
    @State finalAmount: number = 0;
    @State totalInterest: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private frequencyLabels: string[] = ['年复利', '半年复利', '季度复利', '月复利'];
    private frequencyValues: number[] = [1, 2, 4, 12];

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
        const m = this.frequencyValues[this.compoundFrequency];

        if (p > 0 && r > 0 && n > 0) {
            // 复利公式：A = P(1 + r/m)^(m*n)
            const ratePerPeriod = r / 100 / m;
            const totalPeriods = m * n;
            this.finalAmount = p * Math.pow(1 + ratePerPeriod, totalPeriods);
            this.totalInterest = this.finalAmount - p;
        } else {
            this.finalAmount = 0;
            this.totalInterest = 0;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        Text('复利频率')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Row() {
                            ForEach(this.frequencyLabels, (label: string, index: number) => {
                                this.FrequencyButton(label, index)
                            })
                        }
            .width('100%')
                            .justifyContent(FlexAlign.SpaceBetween)
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
                            Text('复利终值')
                                .fontSize(14)
                                .fontColor($r('app.color.text_tertiary'))
                            Text(`¥${this.finalAmount.toFixed(2)}`)
                                .fontSize(32)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                                .margin({ top: 8 })

                            Divider()
                                .color($r('app.color.gray_border'))
                                .margin({ top: 16, bottom: 16 })

                            Row() {
                                Column() {
                                    Text('本金')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`¥${parseFloat(this.principal || '0').toFixed(2)}`)
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Medium)
                                        .fontColor($r('app.color.text_dark'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)

                                Divider()
                                    .vertical(true)
                                    .height(50)
                                    .color($r('app.color.gray_border'))

                                Column() {
                                    Text('利息收益')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`¥${this.totalInterest.toFixed(2)}`)
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Medium)
                                        .fontColor($r('app.color.color_green'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)
                            }
              .width('100%')

                            Text(`复利频率：${this.frequencyLabels[this.compoundFrequency]}`)
                                .fontSize(12)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ top: 16 })
                        }
            .width('100%')
                            .padding(24)
                            .backgroundColor($r('app.color.bg_card'))
                            .borderRadius(0)
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    Column() {
                        Text('复利计算公式')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('A = P(1 + r/m)^(m×n)')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('其中：')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• A = 复利终值')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 2 })
                        Text('• P = 本金')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 2 })
                        Text('• r = 年化收益率')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 2 })
                        Text('• m = 复利频率（年/半年/季度/月）')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 2 })
                        Text('• n = 投资年限')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ top: 8 })
                        Text('💡 复利频率越高，收益越大')
                            .fontSize(13)
                            .fontColor($r('app.color.button_primary'))
                            .margin({ top: 8 })
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
    .title('复利计算器')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    FrequencyButton(label: string, index: number) {
        Button(label)
            .type(ButtonType.Normal)
            .fontSize(12)
            .fontColor(this.compoundFrequency === index ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.compoundFrequency === index ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(36)
            .borderRadius(16)
            .onClick(() => { this.compoundFrequency = index; })
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

