import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct ProfitMarginPage {
    @State revenue: string = '';
    @State cost: string = '';
    @State expense: string = '';
    @State grossProfit: number = 0;
    @State netProfit: number = 0;
    @State grossMargin: number = 0;
    @State netMargin: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.revenue || this.revenue.trim() === '') {
            this.errorMessage = '请输入销售收入';
            return false;
        }
        const revenueNum = parseFloat(this.revenue);
        if (isNaN(revenueNum) || revenueNum <= 0) {
            this.errorMessage = '销售收入必须大于0';
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
        const costNum = parseFloat(this.cost) || 0;
        const expenseNum = parseFloat(this.expense) || 0;

        this.grossProfit = revenueNum - costNum;
        this.netProfit = revenueNum - costNum - expenseNum;

        if (revenueNum > 0) {
            this.grossMargin = (this.grossProfit / revenueNum) * 100;
            this.netMargin = (this.netProfit / revenueNum) * 100;
        } else {
            this.grossMargin = 0;
            this.netMargin = 0;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        AmountInput({
                            label: '销售收入（元）',
                            value: this.revenue,
                            placeholder: '请输入销售收入',
                            onChange: (v: string) => { this.revenue = v; }
                        })
                        .margin({ bottom: 16 })

                        AmountInput({
                            label: '销售成本（元）',
                            value: this.cost,
                            placeholder: '请输入销售成本',
                            onChange: (v: string) => { this.cost = v; }
                        })
                        .margin({ bottom: 16 })

                        AmountInput({
                            label: '期间费用（元）',
                            value: this.expense,
                            placeholder: '请输入期间费用',
                            onChange: (v: string) => { this.expense = v; }
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
                            Row() {
                                Column() {
                                    Text('毛利率')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`${this.grossMargin.toFixed(2)}%`)
                                        .fontSize(28)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.button_primary'))
                                        .margin({ top: 4 })
                                    Text(`毛利润 ¥${this.grossProfit.toFixed(2)}`)
                                        .fontSize(11)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)
                                    .padding(16)
                                    .backgroundColor($r('app.color.bg_blue_light'))

                                Column() {
                                    Text('净利率')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                    Text(`${this.netMargin.toFixed(2)}%`)
                                        .fontSize(28)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor(this.netMargin >= 0 ? $r('app.color.color_green') : $r('app.color.color_red'))
                                        .margin({ top: 4 })
                                    Text(`净利润 ¥${this.netProfit.toFixed(2)}`)
                                        .fontSize(11)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ top: 4 })
                                }
                .layoutWeight(1)
                                    .padding(16)
                                    .backgroundColor(this.netMargin >= 0 ? $r('app.color.bg_green_light') : $r('app.color.bg_red_light'))
                                    .margin({ left: 12 })
                            }
              .width('100%')
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    Column() {
                        Text('计算公式')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('毛利率 = (收入 - 成本) ÷ 收入 × 100%')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('净利率 = (收入 - 成本 - 费用) ÷ 收入 × 100%')
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
    .title('毛利率/净利率')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

}

