import { inputMethod } from '@kit.IMEKit';
import { AmountInput } from '../../components/AmountInput';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { getMaxBaseByCity } from '../../utils/cityData';

interface PersonalCompanyRate {
    personal: number;
    company: number;
}

interface CompanyOnlyRate {
    company: number;
}

interface InsuranceRates {
    pension: PersonalCompanyRate;
    medical: PersonalCompanyRate;
    unemployment: PersonalCompanyRate;
    injury: CompanyOnlyRate;
    maternity: CompanyOnlyRate;
    housing: PersonalCompanyRate;
}


@Entry
@Component
    struct InsurancePage {
    @State salary: string = '';
    @State socialInsuranceBase: string = '';
    @State housingFundBase: string = '';
    @State housingFundRate: string = '12'; // 公积金缴费比例（%）
    @State city: string = '北京';
    @State customCityMaxBase: string = '';
    @State pensionPersonal: number = 0;
    @State medicalPersonal: number = 0;
    @State unemploymentPersonal: number = 0;
    @State housingFund: number = 0;
    @State totalPersonal: number = 0;
    @State pensionCompany: number = 0;
    @State medicalCompany: number = 0;
    @State unemploymentCompany: number = 0;
    @State injuryCompany: number = 0;
    @State maternityCompany: number = 0;
    @State housingFundCompany: number = 0;
    @State totalCompany: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';
    @State warningMessage: string = '';
    private prefs: preferences.Preferences | null = null;
    private context = getContext(this) as common.UIAbilityContext;
    private maxBase: number = 35811; // 默认北京（2025年数据）

    // 北京社保比例（简化）
    private rates: InsuranceRates = {
        pension: { personal: 0.08, company: 0.16 },
        medical: { personal: 0.02, company: 0.10 },
        unemployment: { personal: 0.005, company: 0.005 },
        injury: { company: 0.004 },
        maternity: { company: 0.008 },
        housing: { personal: 0.12, company: 0.12 }
    };

    async aboutToAppear() {
        await this.loadCityMaxBase();
    }

    private getCityDisplayText(): string {
        if (this.customCityMaxBase) {
            return `当前城市：${this.city}（${this.customCityMaxBase}元/月）`;
        }
        return `当前城市：${this.city}`;
    }

    private async loadCityMaxBase(): Promise<void> {
        try {
            this.prefs = await preferences.getPreferences(this.context, 'app_settings');
            const savedCity: string = await this.prefs.get('selectedCity', '北京') as string;
            const savedMaxBase: string = await this.prefs.get('currentCityMaxBase', '') as string;

            // 更新当前城市显示
            this.city = savedCity;
            this.customCityMaxBase = savedMaxBase;

            // 兼容旧版本的标记与字段
            const isOtherCity: boolean = await this.prefs.get('isOtherCity', false) as boolean;
            const legacyCustomBase: string = await this.prefs.get('customCityMaxBase', '') as string;

            let resolvedMaxBase: number | null = null;

            // 1) 优先使用新版保存的数值
            if (savedMaxBase && savedMaxBase.trim() !== '') {
                const parsed = parseFloat(savedMaxBase);
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

            // 4) 自定义城市但未保存上限时，使用默认值
            if (resolvedMaxBase === null) {
                resolvedMaxBase = 35811;
            }

            this.maxBase = resolvedMaxBase;
        } catch (err) {
            console.error(`Failed to load city max base: ${JSON.stringify(err)}`);
            this.maxBase = 35811; // 默认值（北京2025年）
            this.city = '北京';
            this.customCityMaxBase = '';
        }
    }

    private validateInputs(): boolean {
        if (!this.socialInsuranceBase || this.socialInsuranceBase.trim() === '') {
            this.errorMessage = '请输入社保缴费基数';
            this.warningMessage = '';
            return false;
        }
        if (!this.housingFundBase || this.housingFundBase.trim() === '') {
            this.errorMessage = '请输入公积金缴费基数';
            this.warningMessage = '';
            return false;
        }
        const socialBase = parseFloat(this.socialInsuranceBase);
        const fundBase = parseFloat(this.housingFundBase);
        const fundRateNum = parseFloat(this.housingFundRate);
        if (isNaN(socialBase) || socialBase <= 0) {
            this.errorMessage = '社保缴费基数必须大于0';
            this.warningMessage = '';
            return false;
        }
        if (isNaN(fundBase) || fundBase <= 0) {
            this.errorMessage = '公积金缴费基数必须大于0';
            this.warningMessage = '';
            return false;
        }
        if (isNaN(fundRateNum)) {
            this.errorMessage = '请输入公积金缴费比例';
            this.warningMessage = '';
            return false;
        }
        if (fundRateNum < 5 || fundRateNum > 40) {
            this.errorMessage = '公积金缴费比例需在5%-40%之间';
            this.warningMessage = '';
            return false;
        }

        // 检查是否超过封顶值
        const warnings: string[] = [];
        if (socialBase > this.maxBase) {
            warnings.push(`社保基数超过上限${this.maxBase}元，将按上限计算`);
        }
        if (fundBase > this.maxBase) {
            warnings.push(`公积金基数超过上限${this.maxBase}元，将按上限计算`);
        }
        this.warningMessage = warnings.join('；');

        this.errorMessage = '';
        return true;
    }

    /**
     * 将输入按封顶值截断，保持与工资页一致的粘贴/超额处理
     */
    private clampBase(value: string): string {
        const num = parseFloat(value);
        if (isNaN(num)) {
            return value;
        }
        if (num < 0) {
            return '0';
        }
        if (num > this.maxBase) {
            return this.maxBase.toString();
        }
        return value;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        let socialBase = parseFloat(this.socialInsuranceBase);
        let fundBase = parseFloat(this.housingFundBase);
        const fundRate = parseFloat(this.housingFundRate) / 100 || 0.12;

        // 应用封顶限制：如果超过上限，按上限计算
        if (socialBase > this.maxBase) {
            socialBase = this.maxBase;
        }
        if (fundBase > this.maxBase) {
            fundBase = this.maxBase;
        }

        // 使用社保基数计算社保部分
        this.pensionPersonal = socialBase * this.rates.pension.personal;
        this.medicalPersonal = socialBase * this.rates.medical.personal + 3; // 3元大病
        this.unemploymentPersonal = socialBase * this.rates.unemployment.personal;

        this.pensionCompany = socialBase * this.rates.pension.company;
        this.medicalCompany = socialBase * this.rates.medical.company;
        this.unemploymentCompany = socialBase * this.rates.unemployment.company;
        this.injuryCompany = socialBase * this.rates.injury.company;
        this.maternityCompany = socialBase * this.rates.maternity.company;

        // 使用公积金基数和用户设置的比例计算公积金部分
        this.housingFund = fundBase * fundRate;
        this.housingFundCompany = fundBase * fundRate;

        this.totalPersonal = this.pensionPersonal + this.medicalPersonal +
            this.unemploymentPersonal + this.housingFund;
        this.totalCompany = this.pensionCompany + this.medicalCompany +
            this.unemploymentCompany + this.injuryCompany +
            this.maternityCompany + this.housingFundCompany;

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 输入区域
                    Column() {
                        AmountInput({
                            label: '税前工资（元）',
                            value: this.salary,
                            placeholder: '请输入',
                            onChange: (val: string) => {
                                this.salary = val;
                                // 同步到社保、公积金基数，并按上限截断
                                const clamped = this.clampBase(val);
                                this.socialInsuranceBase = clamped;
                                this.housingFundBase = clamped;
                            }
                        })
                            .margin({ bottom: 16 })

                        AmountInput({
                            label: '社保缴费基数（元）',
                            value: this.socialInsuranceBase,
                            placeholder: '请输入',
                            onChange: (val: string) => {
                                this.socialInsuranceBase = this.clampBase(val);
                            }
                        })

                        AmountInput({
                            label: '公积金缴费基数（元）',
                            value: this.housingFundBase,
                            placeholder: '请输入',
                            onChange: (val: string) => {
                                this.housingFundBase = this.clampBase(val);
                            }
                        })
                            .margin({ top: 16 })
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
                                    // 仅过滤数字，范围校验放在提交时
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
                            .alignItems(HorizontalAlign.Start)
                            .margin({ top: 16 })

                        Text(this.getCityDisplayText())
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                            .margin({ top: 12 })
                            .alignSelf(ItemAlign.Start)

                        if (this.warningMessage) {
                            Text(this.warningMessage)
                                .fontSize(12)
                                .fontColor($r('app.color.color_orange'))
                                .margin({ top: 8 })
                                .alignSelf(ItemAlign.Start)
                        }

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
                        // 概览
                        Column() {
                            Text('工资与基数')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.ResultRow('税前工资', parseFloat(this.socialInsuranceBase || '0'), false, $r('app.color.text_primary'))
                            this.ResultRow('社保缴费基数', parseFloat(this.socialInsuranceBase || '0'), false, $r('app.color.button_primary'))
                            this.ResultRow('公积金缴费基数', parseFloat(this.housingFundBase || '0'), false, $r('app.color.button_primary'))
                        }
                        .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })

                        // 个人缴纳
                        Column() {
                            Text('个人缴纳')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.ResultRow('养老保险', this.pensionPersonal, false, $r('app.color.button_primary'), '8%')
                            this.ResultRow('医疗保险', this.medicalPersonal, false, $r('app.color.button_primary'), '2% + 3元')
                            this.ResultRow('失业保险', this.unemploymentPersonal, false, $r('app.color.button_primary'), '0.5%')
                            this.ResultRow('住房公积金', this.housingFund, false, $r('app.color.button_primary'), `${this.housingFundRate}%`)
                            Divider().color($r('app.color.button_primary')).margin({ top: 12, bottom: 12 })
                            this.ResultRow('合计', this.totalPersonal, true)
                        }
            .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })

                        // 公司缴纳
                        Column() {
                            Text('公司缴纳')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 16 })

                            this.ResultRow('养老保险', this.pensionCompany, false, $r('app.color.color_green'), '16%')
                            this.ResultRow('医疗保险', this.medicalCompany, false, $r('app.color.color_green'), '10%')
                            this.ResultRow('失业保险', this.unemploymentCompany, false, $r('app.color.color_green'), '0.5%')
                            this.ResultRow('工伤保险', this.injuryCompany, false, $r('app.color.color_green'), '0.4%')
                            this.ResultRow('生育保险', this.maternityCompany, false, $r('app.color.color_green'), '0.8%')
                            this.ResultRow('住房公积金', this.housingFundCompany, false, $r('app.color.color_green'), `${this.housingFundRate}%`)
                            Divider().color($r('app.color.color_green')).margin({ top: 12, bottom: 12 })
                            this.ResultRow('合计', this.totalCompany, true, $r('app.color.color_green'))
                        }
                        .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                    }

                    // 说明
                    Column() {
                        Text('五险一金说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Text('• 以上计算基于所选地区标准比例，实际比例可能存在差异，请核实')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)

                        Text('• 社保和公积金缴费基数可以不同，请根据实际情况填写')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)

                        Text('• 公积金缴费比例可在5%-40%之间调整，个人和公司比例相同')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)

                        Text('• 具体比例和基数请以当地社保部门规定为准')
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
        .title('五险一金计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    ResultRow(label: string, value: number, isTotal: boolean = false, color: ResourceColor = $r('app.color.button_primary'), rateText: string = '') {
        Row() {
            Text(label)
                .fontSize(isTotal ? 15 : 14)
                .fontWeight(isTotal ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(isTotal ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
            if (rateText) {
                Text(rateText)
                    .fontSize(13)
                    .fontColor($r('app.color.text_secondary'))
                    .margin({ left: 8 })
            }
            Blank()
            Text(`¥${value.toFixed(2)}`)
                .fontSize(isTotal ? 16 : 14)
                .fontWeight(isTotal ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(isTotal ? color : $r('app.color.text_primary'))
        }
    .width('100%')
            .padding({ top: 6, bottom: 6 })
    }
}

