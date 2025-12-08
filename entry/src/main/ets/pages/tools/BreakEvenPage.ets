import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct BreakEvenPage {
    @State fixedCost: string = '';
    @State unitPrice: string = '';
    @State unitCost: string = '';
    @State breakEvenQuantity: number = 0;
    @State breakEvenRevenue: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.fixedCost || this.fixedCost.trim() === '') {
            this.errorMessage = '请输入固定成本';
            return false;
        }
        if (!this.unitPrice || this.unitPrice.trim() === '') {
            this.errorMessage = '请输入单位售价';
            return false;
        }
        if (!this.unitCost || this.unitCost.trim() === '') {
            this.errorMessage = '请输入单位变动成本';
            return false;
        }
        const fixed = parseFloat(this.fixedCost);
        const price = parseFloat(this.unitPrice);
        const cost = parseFloat(this.unitCost);
        if (isNaN(fixed) || fixed < 0) {
            this.errorMessage = '固定成本不能为负数';
            return false;
        }
        if (isNaN(price) || price <= 0) {
            this.errorMessage = '单位售价必须大于0';
            return false;
        }
        if (isNaN(cost) || cost < 0) {
            this.errorMessage = '单位变动成本不能为负数';
            return false;
        }
        if (price <= cost) {
            this.errorMessage = '售价必须高于成本才能盈利';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const fixed = parseFloat(this.fixedCost);
        const price = parseFloat(this.unitPrice);
        const cost = parseFloat(this.unitCost);

        if (price > cost) {
            this.breakEvenQuantity = fixed / (price - cost);
            this.breakEvenRevenue = this.breakEvenQuantity * price;
        } else {
            this.breakEvenQuantity = 0;
            this.breakEvenRevenue = 0;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        AmountInput({
                            label: '固定成本（元）',
                            placeholder: '如：房租、人工等',
                            value: this.fixedCost,
                            onChange: (v: string) => {
                                this.fixedCost = v;
                            }
                        })
                        .margin({ bottom: 16 })

                        AmountInput({
                            label: '单位售价（元）',
                            placeholder: '每件产品售价',
                            value: this.unitPrice,
                            onChange: (v: string) => {
                                this.unitPrice = v;
                            }
                        })
                        .margin({ bottom: 16 })

                        AmountInput({
                            label: '单位变动成本（元）',
                            placeholder: '每件产品成本',
                            value: this.unitCost,
                            onChange: (v: string) => {
                                this.unitCost = v;
                            }
                        })
                        .margin({ bottom: 16 })

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
                            Text('盈亏平衡点')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            Row() {
                                Column() {
                                    Text('保本销量（件）')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`${this.breakEvenQuantity.toFixed(0)}`)
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
                                    Text('保本销售额')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`¥${this.breakEvenRevenue.toFixed(2)}`)
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
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    // 说明
                    Column() {
                        Text('计算公式')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('盈亏平衡点 = 固定成本 ÷ (单价 - 单位变动成本)')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 销量超过此点即可盈利')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)
                        Text('• 边际贡献 = 单价 - 单位变动成本')
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
        .title('盈亏平衡点')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

}

