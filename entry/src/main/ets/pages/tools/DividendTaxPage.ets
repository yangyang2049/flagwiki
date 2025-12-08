import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct DividendTaxPage {
    @State dividend: string = '';
    @State shareholderType: number = 0; // 0:个人 1:企业
    @State tax: number = 0;
    @State afterTax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.dividend || this.dividend.trim() === '') {
            this.errorMessage = '请输入分红金额';
            return false;
        }
        const dividendNum = parseFloat(this.dividend);
        if (isNaN(dividendNum) || dividendNum <= 0) {
            this.errorMessage = '分红金额必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const dividendNum = parseFloat(this.dividend);

        if (this.shareholderType === 0) {
            this.tax = dividendNum * 0.20;
        } else {
            this.tax = 0; // 居民企业间分红免税
        }

        this.afterTax = dividendNum - this.tax;
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        Text('股东类型')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Row() {
                            this.TypeButton('个人股东', 0)
                            this.TypeButton('企业股东', 1)
                        }
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16 })

                    Column() {
                        AmountInput({
                            label: '分红金额（元）',
                            placeholder: '请输入分红金额',
                            value: this.dividend,
                            onChange: (val: string) => {
                                this.dividend = val;
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
                            Text('计算结果')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            Row() {
                                Text('分红金额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${parseFloat(this.dividend || '0').toFixed(2)}`)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('应缴税额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.tax.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor(this.tax > 0 ? $r('app.color.color_red') : $r('app.color.color_green'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('税后到手')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                Blank()
                                Text(`¥${this.afterTax.toFixed(2)}`)
                                    .fontSize(18)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.button_primary'))
                            }
              .width('100%')

                            if (this.shareholderType === 1) {
                                Text('✓ 居民企业间分红免征企业所得税')
                                    .fontSize(12)
                                    .fontColor($r('app.color.color_green'))
                                    .margin({ top: 12 })
                            }
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    Column() {
                        Text('分红税政策')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 个人股东：20%个人所得税')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 居民企业：符合条件的分红免税')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 上市公司分红持股期限有优惠')
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
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('股权分红税')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TypeButton(text: string, type: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.shareholderType === type ? $r('app.color.bg_card') : $r('app.color.text_secondary'))
            .backgroundColor(this.shareholderType === type ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.shareholderType = type; })
    }
}

