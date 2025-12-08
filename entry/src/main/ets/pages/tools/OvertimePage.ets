import { inputMethod } from '@kit.IMEKit';
import { AmountInput } from '../../components/AmountInput';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
    struct OvertimePage {
    @State baseSalary: string = '';
    @State workDays: string = '21.75';
    @State hours: string = '';
    @State overtimeType: number = 0; // 0:工作日 1:休息日 2:法定节假日
    @State overtimePay: number = 0;
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private rates: number[] = [1.5, 2, 3];
    private typeLabels: string[] = ['工作日(1.5倍)', '休息日(2倍)', '法定节假日(3倍)'];

    private validateInputs(): boolean {
        if (!this.baseSalary || this.baseSalary.trim() === '') {
            this.errorMessage = '请输入月工资';
            return false;
        }
        if (!this.hours || this.hours.trim() === '') {
            this.errorMessage = '请输入加班小时数';
            return false;
        }
        const salary = parseFloat(this.baseSalary);
        const days = parseFloat(this.workDays) || 21.75;
        const hrs = parseFloat(this.hours);
        if (isNaN(salary) || salary <= 0) {
            this.errorMessage = '月工资必须大于0';
            return false;
        }
        if (isNaN(days) || days <= 0) {
            this.errorMessage = '月计薪天数必须大于0';
            return false;
        }
        if (isNaN(hrs) || hrs <= 0) {
            this.errorMessage = '加班小时数必须大于0';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private calculate(): void {
        if (!this.validateInputs()) {
            return;
        }

        const salary = parseFloat(this.baseSalary);
        const days = parseFloat(this.workDays) || 21.75;
        const hrs = parseFloat(this.hours);

        const hourlyRate = salary / days / 8;
        this.overtimePay = hourlyRate * hrs * this.rates[this.overtimeType];
        this.showResult = true;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        Text('加班类型')
                            .fontSize(14)
                            .fontColor($r('app.color.text_secondary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Column() {
                            ForEach(this.typeLabels, (label: string, index: number) => {
                                Row() {
                                    Radio({ value: label, group: 'overtime' })
                                        .checked(this.overtimeType === index)
                                        .onChange((isChecked: boolean) => {
                                            if (isChecked) this.overtimeType = index;
                                        })
                                    Text(label)
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_dark'))
                                        .margin({ left: 8 })
                                }
                .width('100%')
                                    .padding({ top: 8, bottom: 8 })
                            })
                        }
                    }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    Column() {
                        AmountInput({
                            label: '月工资（元）',
                            placeholder: '请输入月工资',
                            value: this.baseSalary,
                            onChange: (val: string) => {
                                this.baseSalary = val;
                            }
                        })
                        .margin({ bottom: 16 })
                        
                        Row() {
                            Column() {
                                Text('加班小时数')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 8 })
                                TextInput({ text: this.hours, placeholder: '请输入' })
                                    .type(InputType.Normal)
                                    .height(48)
                                    .backgroundColor($r('app.color.bg_secondary'))
                                    .borderRadius(8)
                                    .onChange((v: string) => { 
                                        this.hours = InputValidator.validateNumberInput(v); 
                                    })
                            }
                                .width('48%')
                                .alignItems(HorizontalAlign.Start)
                            
                            Column() {
                                Text('月计薪天数')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ bottom: 8 })
                                TextInput({ text: this.workDays, placeholder: '21.75' })
                                    .type(InputType.Normal)
                                    .height(48)
                                    .backgroundColor($r('app.color.bg_secondary'))
                                    .borderRadius(8)
                                    .onChange((v: string) => { 
                                        // 使用 validateNumberInput 允许小数输入
                                        this.workDays = InputValidator.validateNumberInput(v); 
                                    })
                            }
                                .width('48%')
                                .alignItems(HorizontalAlign.Start)
                        }
                            .width('100%')
                            .justifyContent(FlexAlign.SpaceBetween)
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
                            Text('加班费')
                                .fontSize(14)
                                .fontColor($r('app.color.text_tertiary'))
                            Text(`¥${this.overtimePay.toFixed(2)}`)
                                .fontSize(32)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                                .margin({ top: 8 })
                            Text(`${this.typeLabels[this.overtimeType]}`)
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ top: 8 })
                        }
            .width('100%')
                            .padding(24)
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
                        Text('小时工资 = 月工资 ÷ 月计薪天数 ÷ 8')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('加班费 = 小时工资 × 加班时数 × 倍数')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 月计薪天数默认21.75天，可根据实际情况修改')
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
    .title('加班费计算')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    InputField(label: string, value: string, onChange: (v: string) => void, placeholder: string = '请输入', inputType: InputType = InputType.Number) {
        Column() {
            Text(label)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ bottom: 8 })
            TextInput({ text: value, placeholder: placeholder })
                .type(inputType)
                .height(48)
                .backgroundColor($r('app.color.bg_secondary'))
                .borderRadius(8)
                .onChange(onChange)
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 16 })
    }
}

