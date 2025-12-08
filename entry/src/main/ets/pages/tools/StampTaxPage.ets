import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';


interface StampTaxRate {
    name: string;
    rate: number;
    rateText: string;
}


@Entry
@Component
    struct StampTaxPage {
    @State amount: string = '';
    @State contractType: number = 0;
    @State tax: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private taxRates: StampTaxRate[] = [
        { name: '购销合同', rate: 0.0003, rateText: '0.03%' },
        { name: '加工承揽合同', rate: 0.0005, rateText: '0.05%' },
        { name: '建设工程勘察设计', rate: 0.0005, rateText: '0.05%' },
        { name: '建筑安装工程', rate: 0.0003, rateText: '0.03%' },
        { name: '财产租赁合同', rate: 0.001, rateText: '0.1%' },
        { name: '货物运输合同', rate: 0.0005, rateText: '0.05%' },
        { name: '仓储保管合同', rate: 0.001, rateText: '0.1%' },
        { name: '借款合同', rate: 0.00005, rateText: '0.005%' },
        { name: '财产保险合同', rate: 0.001, rateText: '0.1%' },
        { name: '技术合同', rate: 0.0003, rateText: '0.03%' },
        { name: '产权转移书据', rate: 0.0005, rateText: '0.05%' }
    ];

    private validateInputs(): boolean {
        if (!this.amount || this.amount.trim() === '') {
            this.errorMessage = '请输入合同金额';
            return false;
        }
        const amt = parseFloat(this.amount);
        if (isNaN(amt) || amt <= 0) {
            this.errorMessage = '合同金额必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const amt = parseFloat(this.amount);
        this.tax = amt * this.taxRates[this.contractType].rate;
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 合同类型选择
                    Column() {
                        Text('合同类型')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        List() {
                            ForEach(this.taxRates, (item: StampTaxRate, index: number) => {
                                ListItem() {
                                    Row() {
                                        Column() {
                                            Text(item.name)
                                                .fontSize(14)
                                                .fontColor($r('app.color.text_primary'))
                                            Text(`税率 ${item.rateText}`)
                                                .fontSize(12)
                                                .fontColor($r('app.color.text_tertiary'))
                                                .margin({ top: 2 })
                                        }
                                            .alignItems(HorizontalAlign.Start)
                                            .layoutWeight(1)

                                        Radio({ value: item.name, group: 'contract' })
                                            .checked(this.contractType === index)
                                            .onChange((isChecked: boolean) => {
                                                if (isChecked) this.contractType = index;
                                            })
                                    }
                                        .width('100%')
                                        .padding({ top: 10, bottom: 10 })
                                }
                            })
                        }
                            .width('100%')
                            .height(280)
                    }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))

                    // 输入区域
                    Column() {
                        AmountInput({
                            label: '合同金额（元）',
                            placeholder: '请输入合同金额',
                            value: this.amount,
                            onChange: (val: string) => {
                                this.amount = val;
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
                        .fontColor($r('app.color.bg_card'))
                        .fontSize(16)
                        .width('80%')
                        .constraintSize({ maxWidth: 320 })
                        .height(48)
                        .borderRadius(8)
                        .margin({ top: 16 })
                        .alignSelf(ItemAlign.Center)
                        .onClick(() => {
                            this.calculate();
                            // 关闭键盘
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

                            Row() {
                                Text('合同金额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${parseFloat(this.amount || '0').toFixed(2)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                            }
                                .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('应缴印花税')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${this.tax.toFixed(2)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_red'))
                            }
                                .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('合同类型')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`${this.taxRates[this.contractType].name} · ${this.taxRates[this.contractType].rateText}`)
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                            }
                                .width('100%')
                        }
                            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                    }
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
            }
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
            .title('印花税计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

