import common from '@ohos.app.ability.common';
import { NumberSeparator, NumberFormatter } from '../../utils/numberFormatter';
import { PageSettings } from '../../utils/pageSettings';
import { PageSeparatorSettings } from '../../components/PageSeparatorSettings';
import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';
import { preferences } from '@kit.ArkData';
import { getMaxBaseByCity } from '../../utils/cityData';
import router from '@ohos.router';
import { KnowledgeData } from '../../utils/knowledgeData';

@Entry
@Component
    struct SalaryTaxPage {
    @State salary: string = '';
    @State socialInsuranceBase: string = '';
    @State housingFundBase: string = '';
    @State housingFundRate: string = '12'; // 公积金缴费比例（%）
    @State specialDeduction: string = '';
    @State currentMonth: string = '1'; // 当前月份（1-12）
    @State taxableIncome: number = 0;
    @State tax: number = 0;
    @State afterTax: number = 0;
    @State showResult: boolean = false;
    @State numberSeparator: NumberSeparator = NumberSeparator.THOUSAND;
    @State showSettingsDialog: boolean = false;
    @State showInsuranceDetail: boolean = false;
    @State pensionAmount: number = 0;
    @State medicalAmount: number = 0;
    @State unemploymentAmount: number = 0;
    @State housingFundAmount: number = 0;
    @State insuranceTotal: number = 0;
    private context = getContext(this) as common.UIAbilityContext;
    private pageName: string = 'SalaryTaxPage';
    private maxSocialInsuranceBase: number = 35811; // 默认北京（2025年数据）
    private maxHousingFundBase: number = 35811; // 默认北京（2025年数据）
    @State currentCity: string = '北京';
    private prefs: preferences.Preferences | null = null;

    async aboutToAppear() {
        await PageSettings.init(this.context);
        this.numberSeparator = await PageSettings.getEffectiveSeparator(this.pageName);
        await this.loadCityMaxBase();
    }

    private async onSeparatorChange(separator: NumberSeparator) {
        this.numberSeparator = separator;
    }

    private appendZeros(value: string, count: number): string {
        if (!value || value.trim() === '') {
            return '0'.repeat(count);
        }
        const cleanValue = NumberFormatter.removeSeparators(value);
        return cleanValue + '0'.repeat(count);
    }

    /**
     * 将基数按上限截断（支持粘贴超额场景）
     */
    private clampBase(value: string, max: number): string {
        const num = parseFloat(value);
        if (isNaN(num)) {
            return value;
        }
        if (num < 0) {
            return '0';
        }
        if (num > max) {
            return max.toString();
        }
        return value;
    }

    // 单月预扣口径的税率表（由年度综合所得表除以12得到）
    private monthlyTaxBrackets: number[][] = [
        [0, 3000, 0.03, 0],
        [3000, 12000, 0.10, 210],      // 2520 / 12
        [12000, 25000, 0.20, 1410],    // 16920 / 12
        [25000, 35000, 0.25, 2660],    // 31920 / 12
        [35000, 55000, 0.30, 4410],    // 52920 / 12
        [55000, 80000, 0.35, 7160],    // 85920 / 12
        [80000, Infinity, 0.45, 15160] // 181920 / 12
    ];

    @State errorMessage: string = '';

    private async loadCityMaxBase(): Promise<void> {
        try {
            this.prefs = await preferences.getPreferences(this.context, 'app_settings');
            const savedCity: string = await this.prefs.get('selectedCity', '北京') as string;
            // 新版城市编辑页面使用的持久化字段
            const savedCurrentMaxBase: string = await this.prefs.get('currentCityMaxBase', '') as string;
            // 兼容旧版本的标记与字段
            const isOtherCity: boolean = await this.prefs.get('isOtherCity', false) as boolean;
            const legacyCustomBase: string = await this.prefs.get('customCityMaxBase', '') as string;

            // 更新当前城市显示
            this.currentCity = savedCity;

            let resolvedMaxBase: number | null = null;

            // 1) 优先使用新版保存的数值
            if (savedCurrentMaxBase && savedCurrentMaxBase.trim() !== '') {
                const parsed = parseFloat(savedCurrentMaxBase);
                if (!isNaN(parsed) && parsed > 0) {
                    resolvedMaxBase = parsed;
                }
            }

            // 2) 兼容旧字段：自定义城市
            if (resolvedMaxBase === null && isOtherCity) {
                const parsed = legacyCustomBase ? parseFloat(legacyCustomBase) : NaN;
                if (!isNaN(parsed) && parsed > 0) {
                    resolvedMaxBase = parsed;
                }
            }

            const cityMaxBase = getMaxBaseByCity(savedCity);
            const isKnownCity = cityMaxBase !== null;

            // 3) 使用预设城市数据（已知城市）
            if (resolvedMaxBase === null && isKnownCity) {
                resolvedMaxBase = cityMaxBase as number;
            }

            // 4) 自定义城市但未保存上限时，尝试兼容旧字段
            if (resolvedMaxBase === null && !isKnownCity) {
                const legacyParsed = legacyCustomBase ? parseFloat(legacyCustomBase) : NaN;
                if (!isNaN(legacyParsed) && legacyParsed > 0) {
                    resolvedMaxBase = legacyParsed;
                }
            }

            // 5) 兜底默认值（北京口径）
            if (resolvedMaxBase === null) {
                resolvedMaxBase = 35811;
            }

            this.maxSocialInsuranceBase = resolvedMaxBase;
            this.maxHousingFundBase = resolvedMaxBase;
        } catch (err) {
            console.error(`Failed to load city max base: ${JSON.stringify(err)}`);
            this.maxSocialInsuranceBase = 35811;
            this.maxHousingFundBase = 35811;
            this.currentCity = '北京';
        }
    }

    private validateInputs(): boolean {
        if (!this.salary || this.salary.trim() === '') {
            this.errorMessage = '请输入税前月薪';
            return false;
        }
        const salaryNum = parseFloat(this.salary);
        if (isNaN(salaryNum) || salaryNum <= 0) {
            this.errorMessage = '税前月薪必须大于0';
            return false;
        }

        // 校验社保缴费基数
        const socialInsuranceBaseNum = parseFloat(this.socialInsuranceBase) || 0;
        if (socialInsuranceBaseNum < 0) {
            this.errorMessage = '社保缴费基数不能为负数';
            return false;
        }
        if (socialInsuranceBaseNum > this.maxSocialInsuranceBase) {
            this.errorMessage = `社保缴费基数超过上限${this.maxSocialInsuranceBase}元`;
            return false;
        }

        // 校验公积金缴费基数
        const housingFundBaseNum = parseFloat(this.housingFundBase) || 0;
        if (housingFundBaseNum < 0) {
            this.errorMessage = '公积金缴费基数不能为负数';
            return false;
        }
        if (housingFundBaseNum > this.maxHousingFundBase) {
            this.errorMessage = `公积金缴费基数超过上限${this.maxHousingFundBase}元`;
            return false;
        }

        // 校验公积金比例（5%-40%）
        const housingFundRateNum = parseFloat(this.housingFundRate);
        if (isNaN(housingFundRateNum)) {
            this.errorMessage = '请输入公积金缴费比例';
            return false;
        }
        if (housingFundRateNum < 5 || housingFundRateNum > 40) {
            this.errorMessage = '公积金缴费比例需在5%-40%之间';
            return false;
        }

        // 校验专项附加扣除不能为负
        const specialNum = parseFloat(this.specialDeduction) || 0;
        if (specialNum < 0) {
            this.errorMessage = '专项附加扣除不能为负数';
            return false;
        }
        if (specialNum > 96000) {
            this.errorMessage = '专项附加扣除年度上限为96000元（月均8000元），请检查输入';
            return false;
        }

        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const salaryNum = parseFloat(this.salary);
        const socialInsuranceBaseNum = parseFloat(this.socialInsuranceBase) || 0;
        const housingFundBaseNum = parseFloat(this.housingFundBase) || 0;
        const housingFundRateNum = parseFloat(this.housingFundRate) || 12;
        const month = parseInt(this.currentMonth) || 1;

        // 根据基数和费率计算五险一金个人部分
        // 社保个人部分：养老保险8% + 医疗保险2%+3元 + 失业保险0.5%
        // 公积金个人部分：使用用户输入的比例
        // 明细：养老8%，医疗2%+3元，失业0.5%，公积金按用户设置
        const pension = socialInsuranceBaseNum * 0.08;
        const medicalFixed: number = 3;
        const medical = socialInsuranceBaseNum * 0.02 + medicalFixed;
        const unemployment = socialInsuranceBaseNum * 0.005;
        const housingFundPersonal = housingFundBaseNum * (housingFundRateNum / 100);
        const insuranceNum = pension + medical + unemployment + housingFundPersonal;
        this.pensionAmount = pension;
        this.medicalAmount = medical;
        this.unemploymentAmount = unemployment;
        this.housingFundAmount = housingFundPersonal;
        this.insuranceTotal = insuranceNum;

        const specialNum = parseFloat(this.specialDeduction) || 0;
        const threshold = 5000; // 起征点 5000元/月

        // 计算当月应纳税所得额
        const monthlyTaxableIncome = Math.max(0, salaryNum - insuranceNum - specialNum - threshold);
        this.taxableIncome = monthlyTaxableIncome;

        // 使用单月预扣法（非累计）
        const monthlyTax = this.calculateMonthlyTax(monthlyTaxableIncome);
        this.tax = monthlyTax;
        this.afterTax = salaryNum - insuranceNum - monthlyTax;
        this.showResult = true;
    }

    /**
     * 单月预扣：按月度税率表计算税额
     */
    private calculateMonthlyTax(taxableIncome: number): number {
        if (taxableIncome <= 0) {
            return 0;
        }
        for (let bracket of this.monthlyTaxBrackets) {
            const lower = bracket[0];
            const upper = bracket[1];
            const rate = bracket[2];
            const quick = bracket[3];
            if (taxableIncome > lower && taxableIncome <= upper) {
                return Math.max(0, taxableIncome * rate - quick);
            }
            if (upper === Infinity && taxableIncome > lower) {
                return Math.max(0, taxableIncome * rate - quick);
            }
        }
        return 0;
    }

    private reset(): void {
        this.salary = '';
        this.socialInsuranceBase = '';
        this.housingFundBase = '';
        this.housingFundRate = '12';
        this.specialDeduction = '';
        this.currentMonth = '1';
        this.taxableIncome = 0;
        this.tax = 0;
        this.afterTax = 0;
        this.showResult = false;
        this.errorMessage = '';
        this.showInsuranceDetail = false;
        this.pensionAmount = 0;
        this.medicalAmount = 0;
        this.unemploymentAmount = 0;
        this.housingFundAmount = 0;
        this.insuranceTotal = 0;
    }

    build() {
        Stack() {
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

                        // 输入区域
                        Column() {
                            // 税前月薪
                            AmountInput({
                                label: '税前月薪（元）',
                                placeholder: '请输入',
                                value: this.salary,
                                onChange: (val: string) => {
                                    this.salary = val;
                                    // 一直同步到社保和公积金缴费基数，并按上限截断
                                    this.socialInsuranceBase = this.clampBase(val, this.maxSocialInsuranceBase);
                                    this.housingFundBase = this.clampBase(val, this.maxHousingFundBase);
                                }
                            })
                                .margin({ bottom: 16 })

                            // 社保缴费基数
                            AmountInput({
                                label: '社保缴费基数（元）',
                                placeholder: '请输入社保缴费基数',
                                value: this.socialInsuranceBase,
                                onChange: (val: string) => {
                                    this.socialInsuranceBase = this.clampBase(val, this.maxSocialInsuranceBase);
                                }
                            })
                                .margin({ bottom: 16 })

                            // 公积金缴费基数
                            AmountInput({
                                label: '公积金缴费基数（元）',
                                placeholder: '请输入公积金缴费基数',
                                value: this.housingFundBase,
                                onChange: (val: string) => {
                                    this.housingFundBase = this.clampBase(val, this.maxHousingFundBase);
                                }
                            })
                                .margin({ bottom: 16 })

                            // 公积金缴费比例
                            Column() {
                                Text('公积金缴费比例（%）')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                    .alignSelf(ItemAlign.Start)
                                    .margin({ bottom: 8 })
                                TextInput({ text: this.housingFundRate, placeholder: '5-40' })
                                    .type(InputType.Number)
                                    .height(48)
                                    .backgroundColor($r('app.color.bg_secondary'))
                                    .borderRadius(8)
                                    .onChange((val: string) => {
                                        let filtered = val.replace(/[^\d]/g, '');
                                        this.housingFundRate = filtered;
                                    })
                                    .maxLength(3)

                                // 高比例提示
                                if (this.housingFundRate && parseInt(this.housingFundRate) > 12) {
                                    Text(`公积金比例 ${this.housingFundRate}% 较高，请确认是否正确`)
                                        .fontSize(12)
                                        .fontColor($r('app.color.color_orange'))
                                        .margin({ top: 4 })
                                        .alignSelf(ItemAlign.Start)
                                }
                            }
                        .width('100%')
                                .margin({ bottom: 16 })

                            // 专项附加扣除
                            Row() {
                                Row() {
                                    Text('专项附加扣除（元）')
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_secondary'))
                                    Text('?')
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.button_primary'))
                                        .width(20)
                                        .height(20)
                                        .textAlign(TextAlign.Center)
                                        .borderRadius(10)
                                        .backgroundColor($r('app.color.bg_blue_light'))
                                        .margin({ left: 8 })
                                        .onClick(() => {
                                            const knowledgeItem = KnowledgeData.getKnowledgeByTitle('个人所得税专项附加扣除');
                                            if (knowledgeItem) {
                                                router.pushUrl({
                                                    url: 'pages/knowledge/KnowledgeDetailPage',
                                                    params: {
                                                        title: knowledgeItem.title,
                                                        category: knowledgeItem.category,
                                                        content: knowledgeItem.content
                                                    }
                                                }, router.RouterMode.Standard).catch((err: Error) => {
                                                    console.error(`Failed to push url. Code: ${err.message}`);
                                                });
                                            }
                                        })
                                }
                            .alignItems(VerticalAlign.Center)
                            }
                        .width('100%')
                                .margin({ bottom: 8 })
                                .alignItems(VerticalAlign.Center)

                            AmountInput({
                                label: '',
                                placeholder: '请输入',
                                value: this.specialDeduction,
                                onChange: (val: string) => {
                                    this.specialDeduction = val;
                                }
                            })
                                .margin({ bottom: 16 })

                            Text(`当前城市：${this.currentCity}（${this.maxHousingFundBase}元/月）`)
                                .fontSize(12)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ top: 12 })
                                .alignSelf(ItemAlign.Start)
                            Text('起征点：5000元/月')
                                .fontSize(12)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ top: 12 })
                                .alignSelf(ItemAlign.Start)
                            Text('* 本计算采用单月预扣估算，未使用累计预扣法')
                                .fontSize(11)
                                .fontColor($r('app.color.color_orange'))
                                .margin({ top: 8 })
                                .alignSelf(ItemAlign.Start)

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

                        // 结果展示
                        if (this.showResult) {
                            Column() {
                                Row() {
                                    Text('计算结果')
                                        .fontSize(17)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.text_primary'))
                                    Blank()
                                }
                            .width('100%')
                                    .margin({ bottom: 16 })

                                this.ResultRow('应纳税所得额', `¥${NumberFormatter.formatCurrency(this.taxableIncome, this.numberSeparator)}`)
                                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                                // 五险一金（带明细按钮）
                                Row() {
                                    Text('五险一金')
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_secondary'))
                                    Button('明细')
                                        .type(ButtonType.Normal)
                                        .fontSize(12)
                                        .height(28)
                                        .padding({ left: 12, right: 12 })
                                        .backgroundColor($r('app.color.bg_blue_light'))
                                        .fontColor($r('app.color.button_primary'))
                                        .margin({ left: 8 })
                                        .onClick(() => {
                                            this.showInsuranceDetail = true;
                                        })
                                    Blank()
                                    Text(`¥${NumberFormatter.formatCurrency(this.insuranceTotal, this.numberSeparator)}`)
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.text_secondary'))
                                }
                            .width('100%')

                                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                                this.ResultRow('税后收入', `¥${NumberFormatter.formatCurrency(this.afterTax, this.numberSeparator)}`, $r('app.color.button_primary'))
                                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                                this.ResultRow('应缴个税', `¥${NumberFormatter.formatCurrency(this.tax, this.numberSeparator)}`, $r('app.color.color_red'))
                            }
            .width('100%')
                                .padding(20)
                                .backgroundColor($r('app.color.bg_card'))
                                .margin({ top: 16, left: 16, right: 16 })
                        }

                        // 按钮
                        Row() {
                            Button('重置')
                                .type(ButtonType.Normal)
                                .backgroundColor($r('app.color.white'))
                                .fontColor($r('app.color.button_primary'))
                                .fontSize(16)
                                .height(48)
                                .layoutWeight(1)
                                .borderRadius(8)
                                .onClick(() => this.reset())

                            Button('计算')
                                .type(ButtonType.Normal)
                                .backgroundColor($r('app.color.button_primary'))
                                .fontColor($r('app.color.text_white'))
                                .fontSize(16)
                                .height(48)
                                .layoutWeight(1)
                                .borderRadius(8)
                                .margin({ left: 12 })
                                .onClick(() => {
                                    this.calculate();
                                    inputMethod.getController().stopInputSession();
                                })
                        }
                    .width('100%')
                            .padding({ left: 16, right: 16 })
                            .margin({ top: 16 })

                        // 税率表说明
                        Column() {
                            Text('个税税率表（综合所得）')
                                .fontSize(15)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 12 })

                            // 表格标题行
                            Row() {
                                Text('应纳税所得额')
                                    .fontSize(12)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                    .layoutWeight(1)
                                Text('税率')
                                    .fontSize(12)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                    .width(50)
                                    .textAlign(TextAlign.Center)
                                Text('速算扣除数')
                                    .fontSize(12)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                                    .width(60)
                                    .textAlign(TextAlign.End)
                            }
                        .width('100%')
                                .padding({ top: 8, bottom: 8 })
                                .backgroundColor($r('app.color.bg_secondary'))
                                .borderRadius(4)
                                .margin({ bottom: 8 })

                            this.TaxBracketRow('不超过36,000', '3%', '0')
                            this.TaxBracketRow('36,000-144,000', '10%', '2,520')
                            this.TaxBracketRow('144,000-300,000', '20%', '16,920')
                            this.TaxBracketRow('300,000-420,000', '25%', '31,920')
                            this.TaxBracketRow('420,000-660,000', '30%', '52,920')
                            this.TaxBracketRow('660,000-960,000', '35%', '85,920')
                            this.TaxBracketRow('超过960,000', '45%', '181,920')
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
        .title('个税计算器（工资）')
                .titleMode(NavigationTitleMode.Mini)
                .hideBackButton(false)
                .backgroundColor($r('app.color.bg_page'))

            // 五险一金明细对话框
            if (this.showInsuranceDetail) {
                this.InsuranceDetailDialog()
            }
        }
        .width('100%')
            .height('100%')
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

    @Builder
    InputField(label: string, value: string, onChange: (val: string) => void, onQuickInput?: (count: number) => void) {
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
                .onChange((val: string) => {
                    const validatedValue = InputValidator.validateNumberInput(val);
                    onChange(validatedValue);
                })
                .maxLength(20)

            // 快捷输入按钮
            if (onQuickInput) {
                Row() {
                    this.QuickInputButton('00', () => {
                        onQuickInput(2);
                    })
                    this.QuickInputButton('000', () => {
                        onQuickInput(3);
                    })
                    this.QuickInputButton('0000', () => {
                        onQuickInput(4);
                    })
                }
                .width('100%')
                    .margin({ top: 8 })
                    .justifyContent(FlexAlign.SpaceBetween)
            }
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }

    @Builder
    QuickInputButton(text: string, onClick: () => void) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(13)
            .height(32)
            .borderRadius(6)
            .layoutWeight(1)
            .margin({ left: 4, right: 4 })
            .onClick(onClick)
    }

    @Builder
    ResultRow(label: string, value: string, valueColor: ResourceColor = $r('app.color.text_primary')) {
        Row() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(value)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(valueColor)
        }
    .width('100%')
    }

    @Builder
    TaxBracketRow(range: string, rate: string, deduction: string) {
        Row() {
            Text(range)
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .layoutWeight(1)
            Text(rate)
                .fontSize(12)
                .fontColor($r('app.color.button_primary'))
                .width(50)
                .textAlign(TextAlign.Center)
            Text(deduction)
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
        }
    .width('100%')
            .padding({ top: 8, bottom: 8 })
    }

    @Builder
    InsuranceDetailDialog() {
        Stack({ alignContent: Alignment.Center }) {
            // 遮罩层
            Column()
                .width('100%')
                .height('100%')
                .backgroundColor('rgba(0, 0, 0, 0.5)')
                .onClick(() => {
                    this.showInsuranceDetail = false;
                })

            // 对话框
            Column() {
                Text('五险一金明细（个人）')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ bottom: 16 })
                    .alignSelf(ItemAlign.Start)

                this.InsuranceRow('养老保险', this.pensionAmount, '8.00%')
                this.InsuranceRow('医疗保险', this.medicalAmount, '2.00% + 3元')
                this.InsuranceRow('失业保险', this.unemploymentAmount, '0.50%')
                this.InsuranceRow('住房公积金', this.housingFundAmount, `${this.housingFundRate}%`)
                Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })
                this.InsuranceRow('合计', this.insuranceTotal, '', true)

                Button('关闭')
                    .type(ButtonType.Normal)
                    .backgroundColor($r('app.color.button_primary'))
                    .fontColor($r('app.color.text_white'))
                    .fontSize(16)
                    .width('100%')
                    .height(44)
                    .borderRadius(8)
                    .margin({ top: 16 })
                    .onClick(() => {
                        this.showInsuranceDetail = false;
                    })
            }
            .width('85%')
                .constraintSize({ maxWidth: 420 })
                .padding({ left: 20, right: 20, top: 20, bottom: 20 })
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(16)
                .shadow({
                    radius: 20,
                    color: $r('app.color.shadow'),
                    offsetX: 0,
                    offsetY: 4
                })
        }
        .width('100%')
            .height('100%')
    }

    @Builder
    InsuranceRow(label: string, amount: number, rateText: string, isTotal: boolean = false) {
        Row() {
            Text(label)
                .fontSize(isTotal ? 15 : 14)
                .fontWeight(isTotal ? FontWeight.Bold : FontWeight.Normal)
                .fontColor($r('app.color.text_primary'))
            if (rateText) {
                Text(rateText)
                    .fontSize(13)
                    .fontColor($r('app.color.text_secondary'))
                    .margin({ left: 8 })
            }
            Blank()
            Text(`¥${NumberFormatter.formatCurrency(amount, this.numberSeparator)}`)
                .fontSize(isTotal ? 16 : 14)
                .fontWeight(isTotal ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(isTotal ? $r('app.color.button_primary') : $r('app.color.text_primary'))
        }
        .width('100%')
            .padding({ top: 6, bottom: 6 })
    }
}
