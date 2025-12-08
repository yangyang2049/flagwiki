import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct CorporateTaxPage {
    @State revenue: string = '';
    @State cost: string = '';
    @State taxType: number = 0; // 0:小微企业 1:普通企业
    @State profit: number = 0;
    @State tax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.revenue || this.revenue.trim() === '') {
            this.errorMessage = '请输入年度收入';
            return false;
        }
        const revenueNum = parseFloat(this.revenue);
        if (isNaN(revenueNum) || revenueNum < 0) {
            this.errorMessage = '年度收入不能为负数';
            return false;
        }
        if (!this.cost || this.cost.trim() === '') {
            this.errorMessage = '请输入年度成本费用';
            return false;
        }
        const costNum = parseFloat(this.cost);
        if (isNaN(costNum) || costNum < 0) {
            this.errorMessage = '年度成本费用不能为负数';
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
        const costNum = parseFloat(this.cost);
        this.profit = revenueNum - costNum;

        if (this.profit <= 0) {
            this.tax = 0;
        } else if (this.taxType === 0) {
            // 小微企业优惠
            if (this.profit <= 3000000) {
                this.tax = this.profit * 0.05; // 实际税负5%
            } else {
                this.tax = 3000000 * 0.05 + (this.profit - 3000000) * 0.25;
            }
        } else {
            this.tax = this.profit * 0.25;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 企业类型选择
                    Column() {
                        Row() {
                            this.TypeButton('小微企业', 0)
                            this.TypeButton('普通企业', 1)
                        }
                            .width('100%')
                    }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0 })

                    // 输入区域
                    Column() {
                        AmountInput({
                            label: '年度收入（元）',
                            placeholder: '请输入',
                            value: this.revenue,
                            onChange: (val: string) => {
                                this.revenue = val;
                            }
                        })
                            .margin({ bottom: 16 })
                        AmountInput({
                            label: '年度成本费用（元）',
                            placeholder: '请输入',
                            value: this.cost,
                            onChange: (val: string) => {
                                this.cost = val;
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
                        .margin({ top: 16 })

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
                        .margin({ top: 16 })
                        .alignSelf(ItemAlign.Center)
                        .onClick(() => {
                            this.calculate();
                            inputMethod.getController().stopInputSession();
                        })

                    // 结果展示
                    if (this.showResult) {
                        Column() {
                            Text('计算结果')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.ResultRow('应纳税所得额', this.profit)
                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                            this.ResultRow('应缴企业所得税', this.tax, true)

                            if (this.taxType === 0 && this.profit > 0) {
                                Text('✓ 享受小微企业优惠税率')
                                    .fontSize(12)
                                    .fontColor($r('app.color.color_green'))
                                    .margin({ top: 12 })
                            }
                        }
                            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16 })
                    }

                    // 说明
                    Column() {
                        Text('税率说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 普通企业：25%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 小微企业（≤300万）：实际税负5%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 高新技术企业：15%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                    }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
            }
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
            .title('企业所得税')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TypeButton(text: string, type: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.taxType === type ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.taxType === type ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.taxType = type; })
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
                    const validatedValue = InputValidator.validateNumberInput(newValue);
                    onChange(validatedValue);
                })
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }

    @Builder
    ResultRow(label: string, value: number, isHighlight: boolean = false) {
        Row() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`¥${value.toFixed(2)}`)
                .fontSize(isHighlight ? 18 : 16)
                .fontWeight(FontWeight.Bold)
                .fontColor(isHighlight ? $r('app.color.color_red') : $r('app.color.text_primary'))
        }
            .width('100%')
    }
}

