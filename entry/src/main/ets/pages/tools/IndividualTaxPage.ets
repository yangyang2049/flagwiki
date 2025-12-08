import common from '@ohos.app.ability.common';
import { NumberSeparator, NumberFormatter } from '../../utils/numberFormatter';
import { PageSettings } from '../../utils/pageSettings';
import { PageSeparatorSettings } from '../../components/PageSeparatorSettings';
import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct IndividualTaxPage {
    @State revenue: string = '';
    @State taxRate: number = 0.01;
    @State tax: number = 0;
    @State showResult: boolean = false;
    @State numberSeparator: NumberSeparator = NumberSeparator.THOUSAND;
    @State showSettingsDialog: boolean = false;
    private context = getContext(this) as common.UIAbilityContext;
    private pageName: string = 'IndividualTaxPage';

    async aboutToAppear() {
        await PageSettings.init(this.context);
        this.numberSeparator = await PageSettings.getEffectiveSeparator(this.pageName);
    }

    private async onSeparatorChange(separator: NumberSeparator) {
        this.numberSeparator = separator;
    }

    private rates: number[] = [0.005, 0.01, 0.015, 0.02];
    private rateLabels: string[] = ['0.5%', '1%', '1.5%', '2%'];
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.revenue || this.revenue.trim() === '') {
            this.errorMessage = '请输入营业收入';
            return false;
        }
        const revenueNum = parseFloat(this.revenue);
        if (isNaN(revenueNum) || revenueNum <= 0) {
            this.errorMessage = '营业收入必须大于0';
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
        this.tax = revenueNum * this.taxRate;
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 设置对话框
                    if (this.showSettingsDialog) {
                        PageSeparatorSettings({
                            pageName: this.pageName,
                            showDialog: this.showSettingsDialog,
                            onSeparatorChange: (separator: NumberSeparator) => {
                                this.onSeparatorChange(separator);
                            },
                            onDialogClose: () => {
                                this.showSettingsDialog = false;
                            }
                        })
                    }

                    Column() {
                        Text('核定征收率')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Row() {
                            ForEach(this.rateLabels, (label: string, index: number) => {
                                Button(label)
                                    .type(ButtonType.Normal)
                                    .fontSize(13)
                                    .fontColor(this.taxRate === this.rates[index] ? $r('app.color.text_white') : $r('app.color.text_secondary'))
                                    .backgroundColor(this.taxRate === this.rates[index] ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
                                    .height(36)
                                    .borderRadius(16)
                                    .margin({ right: 8 })
                                    .onClick(() => { this.taxRate = this.rates[index]; })
                            })
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    Column() {
                        AmountInput({
                            label: '营业收入（元）',
                            value: this.revenue,
                            placeholder: '请输入月/季度营业收入',
                            onChange: (v: string) => { this.revenue = v; }
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
                                Text('营业收入')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${NumberFormatter.formatCurrency(parseFloat(this.revenue || '0'), this.numberSeparator)}`)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('应缴税额')
                                    .fontSize(15)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                Blank()
                                Text(`¥${NumberFormatter.formatCurrency(this.tax, this.numberSeparator)}`)
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

                    Column() {
                        Text('核定征收说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 适用于账簿不健全的个体工商户')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 税务机关核定应税所得率')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 不同行业核定率不同(0.5%-2%)')
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
    .title('个体户核定征收')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TitleBarBuilder() {
        Row() {
            Blank()
            Image($r('app.media.icon_settings'))
                .width(24)
                .height(24)
                .onClick(() => {
                    this.showSettingsDialog = true;
                })
        }
        .width('100%')
            .height('100%')
            .padding({ right: 16 })
    }
}

