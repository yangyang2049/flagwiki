import { AmountInput } from '../../components/AmountInput';

import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct LoanCalcPage {
    @State principal: string = '';
    @State rate: string = '';
    @State months: string = '';
    @State loanType: number = 0; // 0:等额本息 1:等额本金
    @State monthlyPayment: number = 0;
    @State totalPayment: number = 0;
    @State totalInterest: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.principal || this.principal.trim() === '') {
            this.errorMessage = '请输入贷款金额';
            return false;
        }
        if (!this.rate || this.rate.trim() === '') {
            this.errorMessage = '请输入年利率';
            return false;
        }
        if (!this.months || this.months.trim() === '') {
            this.errorMessage = '请输入贷款期限';
            return false;
        }
        const p = parseFloat(this.principal);
        const annualRate = parseFloat(this.rate);
        const n = parseInt(this.months);
        if (isNaN(p) || p <= 0) {
            this.errorMessage = '贷款金额必须大于0';
            return false;
        }
        if (isNaN(annualRate) || annualRate < 0) {
            this.errorMessage = '年利率不能为负数';
            return false;
        }
        if (isNaN(n) || n <= 0) {
            this.errorMessage = '贷款期限必须大于0';
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
        const annualRate = parseFloat(this.rate);
        const n = parseInt(this.months);
        const monthlyRate = annualRate / 100 / 12;

        if (this.loanType === 0) {
            // 等额本息
            if (monthlyRate > 0) {
                this.monthlyPayment = p * monthlyRate * Math.pow(1 + monthlyRate, n) /
                    (Math.pow(1 + monthlyRate, n) - 1);
            } else {
                this.monthlyPayment = p / n;
            }
            this.totalPayment = this.monthlyPayment * n;
        } else {
            // 等额本金 - 首月还款
            const principalPerMonth = p / n;
            this.monthlyPayment = principalPerMonth + p * monthlyRate;
            this.totalPayment = p + (n + 1) * p * monthlyRate / 2;
        }

        this.totalInterest = this.totalPayment - p;
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 还款方式选择
                    Column() {
                        Row() {
                            this.TypeButton('等额本息', 0)
                            this.TypeButton('等额本金', 1)
                        }
                        .width('100%')
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 输入区域
                    Column() {
                        AmountInput({
                            label: '贷款金额（元）',
                            placeholder: '请输入贷款金额',
                            value: this.principal,
                            onChange: (val: string) => {
                                this.principal = val;
                            }
                        })
                            .margin({ bottom: 16 })
                        this.InputField('年利率（%）', this.rate, (v: string) => { this.rate = v; }, InputType.Normal)
                        this.InputField('贷款期限（月）', this.months, (v: string) => { this.months = v; }, InputType.Number)

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

                    // 计算按钮
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
                            // 关闭键盘
                            inputMethod.getController().stopInputSession();
                        })

                    // 结果展示
                    if (this.showResult) {
                        Column() {
                            Text('还款计划')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            Row() {
                                Text(this.loanType === 0 ? '月供' : '首月还款')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.monthlyPayment.toFixed(2)}`)
                                    .fontSize(18)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.button_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('还款总额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.totalPayment.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('利息总额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.totalInterest.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontColor($r('app.color.color_red'))
                            }
              .width('100%')

                            if (this.loanType === 1) {
                                Text('等额本金：每月递减，首月最多')
                                    .fontSize(12)
                                    .fontColor($r('app.color.text_tertiary'))
                                    .margin({ top: 12 })
                            }
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }
                }
            }
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('贷款计算器')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TypeButton(text: string, type: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.loanType === type ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.loanType === type ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.loanType = type; })
    }

    @Builder
    InputField(label: string, value: string, onChange: (v: string) => void, inputType: InputType = InputType.Number) {
        Column() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ bottom: 8 })
            TextInput({ text: value, placeholder: '请输入' })
                .type(inputType)
                .height(48)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(8)
                .onChange((newValue: string) => {
                    // 根据输入类型选择验证方法
                    let validatedValue = newValue;
                    if (inputType === InputType.Number) {
                        // 判断是否为期限（整数）还是利率（小数）
                        // 通过 label 判断
                        if (label.includes('期限') || label.includes('月')) {
                            validatedValue = InputValidator.validateIntegerInput(newValue);
                        } else {
                            validatedValue = InputValidator.validateNumberInput(newValue);
                        }
                    }
                    onChange(validatedValue);
                })
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }
}

