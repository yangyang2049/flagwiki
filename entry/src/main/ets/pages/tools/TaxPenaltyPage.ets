import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct TaxPenaltyPage {
    @State taxAmount: string = '';
    @State overdueDays: string = '';
    @State penaltyAmount: number = 0;
    private readonly penaltyRate: number = 0.05; // 固定滞纳金率 0.05%（每日）
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.taxAmount || this.taxAmount.trim() === '') {
            this.errorMessage = '请输入税款金额';
            return false;
        }
        const tax = parseFloat(this.taxAmount);
        if (isNaN(tax) || tax <= 0) {
            this.errorMessage = '税款金额必须大于0';
            return false;
        }
        if (!this.overdueDays || this.overdueDays.trim() === '') {
            this.errorMessage = '请输入滞纳天数';
            return false;
        }
        const days = parseInt(this.overdueDays);
        if (isNaN(days) || days <= 0) {
            this.errorMessage = '滞纳天数必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const tax = parseFloat(this.taxAmount);
        const days = parseInt(this.overdueDays);
        // 固定滞纳金率：0.05%（每日），转换为小数：0.05% = 0.0005
        const rate = this.penaltyRate / 100;

        if (tax > 0 && days > 0) {
            this.penaltyAmount = tax * rate * days;
        } else {
            this.penaltyAmount = 0;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        AmountInput({
                            label: '税款金额（元）',
                            placeholder: '请输入税款金额',
                            value: this.taxAmount,
                            onChange: (val: string) => {
                                this.taxAmount = val;
                            }
                        })
                            .margin({ bottom: 16 })

                        this.InputField('滞纳天数', this.overdueDays, (v: string) => { this.overdueDays = v; })

                        Row() {
                            Text('滞纳金率（日）')
                                .fontSize(14)
                                .fontColor($r('app.color.text_secondary'))
                            Blank()
                            Text('0.05%')
                                .fontSize(14)
                                .fontColor($r('app.color.text_primary'))
                                .fontWeight(FontWeight.Medium)
                        }
                        .width('100%')
                        .margin({ top: 16, bottom: 8 })
                        .padding({ top: 12, bottom: 12 })

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
                        .borderRadius(0)
                        .margin({ top: 0, left: 16, right: 16 })

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
                            Text('滞纳金')
                                .fontSize(14)
                                .fontColor($r('app.color.text_tertiary'))
                            Text(`¥${this.penaltyAmount.toFixed(2)}`)
                                .fontSize(32)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.color_red'))
                                .margin({ top: 8 })
                            Text(`税款：¥${parseFloat(this.taxAmount || '0').toFixed(2)}`)
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ top: 12 })
                            Text(`滞纳天数：${this.overdueDays}天`)
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ top: 4 })
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
                        Text('滞纳金 = 税款金额 × 滞纳金率 × 滞纳天数')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('• 一般滞纳金率为每日0.05%（万分之五）')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 滞纳天数从税款缴纳期限届满次日起计算')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 具体税率以税务机关规定为准')
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
    .title('税款滞纳金计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    InputField(label: string, value: string, onChange: (v: string) => void, placeholder: string = '请输入') {
        Column() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ bottom: 8 })
            TextInput({ text: value, placeholder: placeholder })
                .type(InputType.Number)
                .height(48)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(8)
                .onChange((newValue: string) => {
                    // 滞纳天数应该是整数
                    const validatedValue = InputValidator.validateIntegerInput(newValue);
                    onChange(validatedValue);
                })
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }
}

