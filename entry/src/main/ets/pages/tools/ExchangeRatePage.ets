import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

interface CurrencyRate {
    code: string;
    name: string;
    rate: number;
}

@Entry
@Component
    struct ExchangeRatePage {
    @State amount: string = '100';
    @State fromCurrency: number = 0;
    @State toCurrency: number = 1;
    @State result: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';
    @State lastUpdateTime: string = '';

    private currencies: CurrencyRate[] = [
        { code: 'CNY', name: '人民币', rate: 1 },
        { code: 'USD', name: '美元', rate: 7.24 },
        { code: 'EUR', name: '欧元', rate: 7.85 },
        { code: 'GBP', name: '英镑', rate: 9.15 },
        { code: 'JPY', name: '日元', rate: 0.048 },
        { code: 'HKD', name: '港币', rate: 0.93 },
        { code: 'KRW', name: '韩元', rate: 0.0052 }
    ];

    aboutToAppear(): void {
        // 初始化时间戳
        const now = new Date();
        this.lastUpdateTime = `${now.getMonth() + 1}-${now.getDate()} ${now.getHours()}:${String(now.getMinutes()).padStart(2, '0')}`;
    }

    private getToCurrencies(): CurrencyRate[] {
        const cny = this.currencies[0];
        const others = this.currencies.slice(1);
        return [...others, cny];
    }

    private getOriginalIndex(currency: CurrencyRate): number {
        return currency.code === 'CNY' ? 0 : this.currencies.findIndex((c: CurrencyRate) => c.code === currency.code);
    }

    @Builder
    ToCurrencyButton(currency: CurrencyRate) {
        Button(`${currency.code}`)
            .type(ButtonType.Normal)
            .fontSize(13)
            .height(36)
            .borderRadius(16)
            .onClick(() => { this.toCurrency = this.getOriginalIndex(currency); })
    }

    private validateAmount(): boolean {
        if (!this.amount || this.amount.trim() === '') {
            this.errorMessage = '请输入金额';
            return false;
        }
        
        const amt = parseFloat(this.amount);
        if (isNaN(amt)) {
            this.errorMessage = '请输入有效的数字';
            return false;
        }
        
        if (amt < 0) {
            this.errorMessage = '金额不能为负数';
            return false;
        }
        
        // 限制最大值，避免极端值
        if (amt > 1e15) {
            this.errorMessage = '金额过大，请输入小于 1,000,000,000,000,000 的数值';
            return false;
        }
        
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateAmount()) {
            this.showResult = false;
            return;
        }

        const amt = parseFloat(this.amount);
        const fromRate = this.currencies[this.fromCurrency].rate;
        const toRate = this.currencies[this.toCurrency].rate;

        // 校验汇率有效性
        if (fromRate <= 0 || toRate <= 0) {
            this.errorMessage = '汇率数据异常，请刷新汇率';
            this.showResult = false;
            return;
        }

        // 先转换为人民币，再转换为目标货币
        const cnyAmount = amt * fromRate;
        this.result = cnyAmount / toRate;
        
        // 检查结果是否有效
        if (!isFinite(this.result) || isNaN(this.result)) {
            this.errorMessage = '计算结果异常，请检查输入';
            this.showResult = false;
            return;
        }
        
        this.showResult = true;
        this.errorMessage = '';
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        AmountInput({
                            label: '金额',
                            placeholder: '请输入金额',
                            value: this.amount,
                            onChange: (val: string) => {
                                this.amount = val;
                                this.showResult = false;
                                this.errorMessage = '';
                            }
                        })
                        
                        if (this.errorMessage) {
                            Text(this.errorMessage)
                                .fontSize(12)
                                .fontColor($r('app.color.color_red'))
                                .alignSelf(ItemAlign.Start)
                        }
                    }
                    .width('100%')
                    .padding(20)
                    .backgroundColor($r('app.color.bg_card'))

                    // 结果展示
                    if (this.showResult) {
                        Column() {
                            Row() {
                                Text(`${this.amount} ${this.currencies[this.fromCurrency].code}`)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_secondary'))
                                Text(' = ')
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_secondary'))
                            }
                            Text(`${this.result.toFixed(2)} ${this.currencies[this.toCurrency].code}`)
                                .fontSize(28)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                        }
                        .width('100%')
                        .padding(24)
                        .backgroundColor($r('app.color.bg_card'))
                    }

                    Column() {
                        Row() {
                            Text('从')
                                .fontSize(14)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(1)
                            Button() {
                                Image($r('app.media.icon_arrow_right'))
                                    .width(20)
                                    .height(20)
                            }
                                .type(ButtonType.Normal)
                                .backgroundColor(Color.Transparent)
                                .width(40)
                                .height(40)
                                .onClick(() => {
                                    const temp = this.fromCurrency;
                                    this.fromCurrency = this.toCurrency;
                                    this.toCurrency = temp;
                                })
                            Text('到')
                                .fontSize(14)
                                .fontColor($r('app.color.text_secondary'))
                                .layoutWeight(1)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.SpaceBetween)
                        .alignItems(VerticalAlign.Center)

                        Flex({ wrap: FlexWrap.Wrap }) {
                            ForEach(this.currencies, (currency: CurrencyRate, index: number) => {
                                Button(`${currency.code}`)
                                    .type(ButtonType.Normal)
                                    .fontSize(13)
                                    .height(36)
                                    .borderRadius(16)
                                    .onClick(() => { this.fromCurrency = index; })
                            })
                        }

                        Flex({ wrap: FlexWrap.Wrap }) {
                            ForEach(this.getToCurrencies(), (currency: CurrencyRate, index: number) => {
                                this.ToCurrencyButton(currency)
                            })
                        }
                    }
                    .width('100%')
                    .padding(20)
                    .backgroundColor($r('app.color.bg_card'))

                    Button('换算')
                        .type(ButtonType.Normal)
                        .fontSize(16)
                        .width('80%')
                        .constraintSize({ maxWidth: 320 })
                        .height(48)
                        .borderRadius(8)
                        .onClick(() => {
                            this.calculate();
                            inputMethod.getController().stopInputSession();
                        })

                    Column() {
                        Row() {
                            Text('参考汇率（仅供参考）')
                                .fontSize(15)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .layoutWeight(1)
                            if (this.lastUpdateTime) {
                                Text(this.lastUpdateTime)
                                    .fontSize(11)
                                    .fontColor($r('app.color.text_tertiary'))
                            }
                        }
                            .width('100%')

                        ForEach(this.currencies.slice(1), (currency: CurrencyRate) => {
                            Row() {
                                Text(`1 ${currency.code}`)
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`= ${currency.rate.toFixed(4)} CNY`)
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')
                                .padding({ top: 6, bottom: 6 })
                        })

                        Row() {
                            Text('* 汇率为静态参考值，请以实时汇率为准')
                                .fontSize(11)
                                .fontColor($r('app.color.color_orange'))
                            Blank()
                            Button('刷新')
                                .type(ButtonType.Normal)
                                .fontSize(12)
                                .fontColor($r('app.color.button_primary'))
                                .backgroundColor(Color.Transparent)
                                .height(28)
                                .onClick(() => {
                                    // 刷新汇率时间戳（实际应用中应调用API获取最新汇率）
                                    const now = new Date();
                                    this.lastUpdateTime = `${now.getMonth() + 1}-${now.getDate()} ${now.getHours()}:${String(now.getMinutes()).padStart(2, '0')}`;
                                })
                        }
                            .width('100%')
                    }
                    .width('100%')
                    .padding(20)
                    .backgroundColor($r('app.color.bg_card'))
                    .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
            }
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('汇率换算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

