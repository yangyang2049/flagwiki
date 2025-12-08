import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct DepreciationPage {
    @State assetValue: string = '';
    @State residualRate: string = '5';
    @State usefulLife: string = '';
    @State annualDepreciation: number = 0;
    @State monthlyDepreciation: number = 0;
    @State residualValue: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.assetValue || this.assetValue.trim() === '') {
            this.errorMessage = '请输入资产原值';
            return false;
        }
        if (!this.usefulLife || this.usefulLife.trim() === '') {
            this.errorMessage = '请输入使用年限';
            return false;
        }
        const value = parseFloat(this.assetValue);
        const rate = parseFloat(this.residualRate) || 0;
        const years = parseInt(this.usefulLife);
        if (isNaN(value) || value <= 0) {
            this.errorMessage = '资产原值必须大于0';
            return false;
        }
        if (isNaN(rate) || rate < 0 || rate > 100) {
            this.errorMessage = '残值率应在0-100%之间';
            return false;
        }
        if (isNaN(years) || years <= 0) {
            this.errorMessage = '使用年限必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const value = parseFloat(this.assetValue);
        const rate = parseFloat(this.residualRate) || 0;
        const years = parseInt(this.usefulLife);

        this.residualValue = value * rate / 100;
        this.annualDepreciation = (value - this.residualValue) / years;
        this.monthlyDepreciation = this.annualDepreciation / 12;
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 确保内容从顶部开始
                    Column() {
                        AmountInput({
                            label: '资产原值（元）',
                            placeholder: '请输入',
                            value: this.assetValue,
                            onChange: (val: string) => {
                                this.assetValue = val;
                            }
                        })
                        .margin({ bottom: 16 })
                        this.InputField('残值率（%）', this.residualRate, (v: string) => { this.residualRate = v; })
                        this.InputField('使用年限（年）', this.usefulLife, (v: string) => { this.usefulLife = v; })

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
                        .alignItems(HorizontalAlign.Start)

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
                            Text('直线法折旧')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.ResultRow('残值', this.residualValue)
                            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
                            this.ResultRow('年折旧额', this.annualDepreciation, true)
                            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
                            this.ResultRow('月折旧额', this.monthlyDepreciation, true)
                        }
                        .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    // 说明
                    Column() {
                        Text('常见折旧年限')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 房屋建筑物：20年')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 机器设备：10年')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 运输工具：4年')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 电子设备：3年')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
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
        .title('折旧摊销')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
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
                    // 原值用数字验证，使用年限用整数验证
                    let validatedValue = newValue;
                    if (label.includes('年限')) {
                        validatedValue = InputValidator.validateIntegerInput(newValue);
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

    @Builder
    ResultRow(label: string, value: number, highlight: boolean = false) {
        Row() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`¥${value.toFixed(2)}`)
                .fontSize(highlight ? 18 : 16)
                .fontWeight(highlight ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(highlight ? $r('app.color.button_primary') : $r('app.color.text_primary'))
        }
    .width('100%')
    }
}
