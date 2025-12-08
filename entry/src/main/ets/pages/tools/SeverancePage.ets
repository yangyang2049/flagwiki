import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct SeverancePage {
    @State avgSalary: string = '';
    @State workYears: string = '';
    @State workMonths: string = '0';
    @State compensationType: number = 0; // 0:N 1:N+1 2:2N
    @State compensation: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private validateInputs(): boolean {
        if (!this.avgSalary || this.avgSalary.trim() === '') {
            this.errorMessage = '请输入月平均工资';
            return false;
        }
        if (!this.workYears || this.workYears.trim() === '') {
            this.errorMessage = '请输入工作年数';
            return false;
        }
        const salary = parseFloat(this.avgSalary);
        const years = parseInt(this.workYears);
        const months = parseInt(this.workMonths) || 0;
        if (isNaN(salary) || salary <= 0) {
            this.errorMessage = '月平均工资必须大于0';
            return false;
        }
        if (isNaN(years) || years < 0) {
            this.errorMessage = '工作年数不能为负数';
            return false;
        }
        if (isNaN(months) || months < 0 || months >= 12) {
            this.errorMessage = '剩余月数应在0-11之间';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const salary = parseFloat(this.avgSalary);
        const years = parseInt(this.workYears);
        const months = parseInt(this.workMonths) || 0;

        // 计算N (工作年限对应的月数)
        let n = years;
        if (months >= 6) {
            n += 1;
        } else if (months > 0) {
            n += 0.5;
        }

        if (this.compensationType === 0) {
            this.compensation = salary * n;
        } else if (this.compensationType === 1) {
            this.compensation = salary * (n + 1);
        } else {
            this.compensation = salary * n * 2;
        }

        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        Text('补偿标准')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Row() {
                            this.TypeButton('N', 0)
                            this.TypeButton('N+1', 1)
                            this.TypeButton('2N', 2)
                        }
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 0, left: 16, right: 16 })

                    Column() {
                        AmountInput({
                            label: '月平均工资（元）',
                            placeholder: '请输入',
                            value: this.avgSalary,
                            onChange: (val: string) => {
                                this.avgSalary = val;
                            }
                        })
                        .margin({ bottom: 16 })
                        this.InputField('工作年数', this.workYears, (v: string) => { this.workYears = v; })
                        this.InputField('剩余月数', this.workMonths, (v: string) => { this.workMonths = v; })

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
                        .borderRadius(0)
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
                            Text('经济补偿金')
                                .fontSize(14)
                                .fontColor($r('app.color.text_tertiary'))
                            Text(`¥${this.compensation.toFixed(2)}`)
                                .fontSize(32)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                                .margin({ top: 8 })
                        }
            .width('100%')
                            .padding(24)
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ top: 16, left: 16, right: 16 })
                    }

                    Column() {
                        Text('补偿标准说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('N：协商解除、经济性裁员等')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('N+1：无过错辞退未提前30天通知')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('2N：违法解除劳动合同')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('• 工作满1年按1个月计算')
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                            .margin({ bottom: 2 })
                        Text('• 6个月以上不满1年按1个月计算')
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                            .margin({ bottom: 2 })
                        Text('• 不满6个月按0.5个月计算')
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .layoutWeight(1)
                .scrollBar(BarState.Off)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('离职补偿金')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    TypeButton(text: string, type: number) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(this.compensationType === type ? $r('app.color.text_white') : $r('app.color.text_secondary'))
            .backgroundColor(this.compensationType === type ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
            .onClick(() => { this.compensationType = type; })
    }

    @Builder
    InputField(label: string, value: string, onChange: (v: string) => void) {
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
                .onChange((newValue: string) => {
                    // 工作年限用数字验证，允许小数（如1.5年）
                    const validatedValue = InputValidator.validateNumberInput(newValue);
                    onChange(validatedValue);
                })
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }
}

