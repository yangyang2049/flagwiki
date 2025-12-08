import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct SurtaxPage {
    @State vatAmount: string = '';
    @State cityType: number = 0; // 0:市区 1:县镇 2:其他
    @State cityTax: number = 0;
    @State educationTax: number = 0;
    @State localEducationTax: number = 0;
    @State totalSurtax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private cityRates: number[] = [0.07, 0.05, 0.01];
    private cityLabels: string[] = ['市区(7%)', '县镇(5%)', '其他(1%)'];

    private validateInputs(): boolean {
        if (!this.vatAmount || this.vatAmount.trim() === '') {
            this.errorMessage = '请输入增值税税额';
            return false;
        }
        const vat = parseFloat(this.vatAmount);
        if (isNaN(vat) || vat <= 0) {
            this.errorMessage = '增值税税额必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const vat = parseFloat(this.vatAmount);
        const cityRate = this.cityRates[this.cityType];

        this.cityTax = vat * cityRate;
        this.educationTax = vat * 0.03;
        this.localEducationTax = vat * 0.02;
        this.totalSurtax = this.cityTax + this.educationTax + this.localEducationTax;

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 地区选择
                    Column() {
                        Text('纳税地点')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Row() {
                            ForEach(this.cityLabels, (label: string, index: number) => {
                                Button(label)
                                    .type(ButtonType.Normal)
                                    .fontSize(13)
                                    .fontColor(this.cityType === index ? $r('app.color.bg_card') : $r('app.color.text_secondary'))
                                    .backgroundColor(this.cityType === index ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
                                    .height(36)
                                    .borderRadius(16)
                                    .margin({ right: 8 })
                                    .onClick(() => { this.cityType = index; })
                            })
                        }
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 输入增值税
                    Column() {
                        AmountInput({
                            label: '增值税税额（元）',
                            placeholder: '请输入已计算的增值税额',
                            value: this.vatAmount,
                            onChange: (val: string) => {
                                this.vatAmount = val;
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
                        .fontColor($r('app.color.bg_card'))
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
                            Text('附加税明细')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.TaxRow('城市维护建设税', this.cityLabels[this.cityType], this.cityTax)
                            Divider().color($r('app.color.gray_very_light')).margin({ top: 10, bottom: 10 })
                            this.TaxRow('教育费附加', '3%', this.educationTax)
                            Divider().color($r('app.color.gray_very_light')).margin({ top: 10, bottom: 10 })
                            this.TaxRow('地方教育附加', '2%', this.localEducationTax)
                            Divider().color($r('app.color.button_primary')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('附加税合计')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                Blank()
                                Text(`¥${this.totalSurtax.toFixed(2)}`)
                                    .fontSize(18)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_red'))
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
                        Text('附加税说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Text('附加税以增值税、消费税为计税依据：')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('• 城建税：市区7%、县镇5%、其他1%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 教育费附加：3%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 地方教育附加：2%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
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
    .title('附加税计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TaxRow(name: string, rate: string, amount: number) {
        Row() {
            Column() {
                Text(name)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                Text(rate)
                    .fontSize(12)
                    .fontColor($r('app.color.text_tertiary'))
                    .margin({ top: 2 })
            }
      .alignItems(HorizontalAlign.Start)

            Blank()
            Text(`¥${amount.toFixed(2)}`)
                .fontSize(15)
                .fontColor($r('app.color.text_primary'))
        }
    .width('100%')
    }
}

