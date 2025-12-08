import common from '@ohos.app.ability.common';
import { NumberSeparator, NumberFormatter } from '../../utils/numberFormatter';
import { PageSettings } from '../../utils/pageSettings';
import { PageSeparatorSettings } from '../../components/PageSeparatorSettings';
import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
    struct BonusTaxPage {
    @State bonus: string = '';
    @State calcMethod: number = 0; // 0: 单独计税, 1: 合并计税
    @State annualSalary: string = '';
    @State tax: number = 0;
    @State afterTax: number = 0;
    @State showResult: boolean = false;
    @State numberSeparator: NumberSeparator = NumberSeparator.THOUSAND;
    @State showSettingsDialog: boolean = false;
    private context = getContext(this) as common.UIAbilityContext;
    private pageName: string = 'BonusTaxPage';

    async aboutToAppear() {
        await PageSettings.init(this.context);
        this.numberSeparator = await PageSettings.getEffectiveSeparator(this.pageName);
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

    private taxBrackets: number[][] = [
        [0, 3000, 0.03, 0],
        [3000, 12000, 0.10, 210],
        [12000, 25000, 0.20, 1410],
        [25000, 35000, 0.25, 2660],
        [35000, 55000, 0.30, 4410],
        [55000, 80000, 0.35, 7160],
        [80000, Infinity, 0.45, 15160]
    ];

    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.bonus || this.bonus.trim() === '') {
            this.errorMessage = '请输入年终奖金额';
            return false;
        }
        const bonusNum = parseFloat(this.bonus);
        if (isNaN(bonusNum) || bonusNum <= 0) {
            this.errorMessage = '年终奖金额必须大于0';
            return false;
        }
        if (this.calcMethod === 1) {
            if (!this.annualSalary || this.annualSalary.trim() === '') {
                this.errorMessage = '合并计税需要输入年度工资收入';
                return false;
            }
            const annualNum = parseFloat(this.annualSalary);
            if (isNaN(annualNum) || annualNum < 0) {
                this.errorMessage = '年度工资收入不能为负数';
                return false;
            }
        }
        this.errorMessage = '';
        return true;
    }

    /**
     * 计算年度综合所得应纳税额
     * @param taxableIncome 年度应纳税所得额（已减除费用）
     * @returns 应纳税额
     */
    private calculateAnnualTax(taxableIncome: number): number {
        if (taxableIncome <= 0) {
            return 0;
        }

        const annualBrackets: number[][] = [
            [0, 36000, 0.03, 0],
            [36000, 144000, 0.10, 2520],
            [144000, 300000, 0.20, 16920],
            [300000, 420000, 0.25, 31920],
            [420000, 660000, 0.30, 52920],
            [660000, 960000, 0.35, 85920],
            [960000, Infinity, 0.45, 181920]
        ];

        for (let bracket of annualBrackets) {
            if (taxableIncome > bracket[0] && taxableIncome <= bracket[1]) {
                return taxableIncome * bracket[2] - bracket[3];
            }
        }

        // 最高档
        const highestBracket = annualBrackets[annualBrackets.length - 1];
        return taxableIncome * highestBracket[2] - highestBracket[3];
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const bonusNum = parseFloat(this.bonus);

        if (this.calcMethod === 0) {
            // 单独计税
            const monthlyBonus = bonusNum / 12;
            let rate = 0;
            let deduction = 0;

            for (let bracket of this.taxBrackets) {
                if (monthlyBonus > bracket[0] && monthlyBonus <= bracket[1]) {
                    rate = bracket[2];
                    deduction = bracket[3];
                    break;
                }
                if (monthlyBonus > bracket[1]) {
                    rate = bracket[2];
                    deduction = bracket[3];
                }
            }

            this.tax = bonusNum * rate - deduction;
        } else {
            // 合并计税（正确算法）
            // 年终奖税额 = 计算(工资+年终奖-起征点) - 计算(工资-起征点)
            const annualNum = parseFloat(this.annualSalary) || 0;
            const threshold = 60000; // 年度起征点
            
            // 计算工资+年终奖的应纳税额
            const totalTaxableIncome = Math.max(0, annualNum + bonusNum - threshold);
            const totalTax = this.calculateAnnualTax(totalTaxableIncome);
            
            // 计算仅工资的应纳税额
            const salaryTaxableIncome = Math.max(0, annualNum - threshold);
            const salaryTax = this.calculateAnnualTax(salaryTaxableIncome);
            
            // 年终奖应纳税额 = 两者之差
            this.tax = totalTax - salaryTax;
        }

        this.tax = Math.max(0, this.tax);
        this.afterTax = bonusNum - this.tax;
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

                    // 计税方式选择
                    Column() {
                        Row() {
                            this.MethodButton('单独计税', 0)
                            this.MethodButton('合并计税', 1)
                        }
            .width('100%')
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 输入区域
                    Column() {
                        AmountInput({
                            label: '年终奖金额（元）',
                            placeholder: '请输入年终奖金额',
                            value: this.bonus,
                            onChange: (val: string) => {
                                this.bonus = val;
                            }
                        })
                            .margin({ bottom: 16 })

                        if (this.calcMethod === 1) {
                            AmountInput({
                                label: '年度工资收入（元）',
                                placeholder: '请输入年度工资总额',
                                value: this.annualSalary,
                                onChange: (val: string) => {
                                    this.annualSalary = val;
                                }
                            })
                                .margin({ top: 16 })
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
                        .margin({ top: 16, left: 16, right: 16 })

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
                        .margin({ top: 16, left: 16, right: 16 })
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

                            Row() {
                                Text('年终奖金额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${NumberFormatter.formatCurrency(parseFloat(this.bonus || '0'), this.numberSeparator)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.text_primary'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('应缴个税')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${NumberFormatter.formatCurrency(this.tax, this.numberSeparator)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_red'))
                            }
              .width('100%')

                            Divider().color($r('app.color.gray_very_light')).margin({ top: 12, bottom: 12 })

                            Row() {
                                Text('税后到手')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                Blank()
                                Text(`¥${NumberFormatter.formatCurrency(this.afterTax, this.numberSeparator)}`)
                                    .fontSize(16)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.button_primary'))
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
                        Text('计税方式说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })

                        Text('单独计税：年终奖÷12确定税率，适用于年薪较高者')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                            .alignSelf(ItemAlign.Start)
                            .textAlign(TextAlign.Start)

                        Text('合并计税：年终奖并入综合所得计税，适用于年薪较低者')
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
    .title('个税计算器（年终奖）')
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

    @Builder
    MethodButton(text: string, index: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.calcMethod === index ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.calcMethod === index ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.calcMethod = index; })
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
}

