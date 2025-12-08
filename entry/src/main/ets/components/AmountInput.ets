import { NumberFormatter } from '../utils/numberFormatter';
import { InputValidator } from '../utils/inputValidator';

/**
 * 金额输入组件
 * 包含输入框和快捷输入按钮（00, 000, 0000）
 * 使用 Row 布局，左侧为输入框，右侧为按钮组
 */
@Component
export struct AmountInput {
    @Prop value: string = '';
    @Prop label: string = '';
    @Prop placeholder: string = '请输入';
    onChange?: (value: string) => void;

    private appendZeros(count: number): void {
        const newValue = this.getAppendedValue(count);
        this.onChange?.(newValue);
    }

    private getAppendedValue(count: number): string {
        if (!this.value || this.value.trim() === '') {
            return '0'.repeat(count);
        }
        const cleanValue = NumberFormatter.removeSeparators(this.value);
        return cleanValue + '0'.repeat(count);
    }

    private handleInputChange(val: string): void {
        // 使用统一的输入验证工具
        const filteredValue = InputValidator.validateNumberInput(val);
        this.onChange?.(filteredValue);
    }

    build() {
        Column() {
            if (this.label) {
                Text(this.label)
                    .fontSize(14)
                    .fontColor($r('app.color.text_secondary'))
                    .margin({ bottom: 8 })
                    .alignSelf(ItemAlign.Start)
            }

            Row() {
                TextInput({ text: this.value, placeholder: this.placeholder })
                    .type(InputType.Number)
                    .height(48)
                    .backgroundColor($r('app.color.bg_secondary'))
                    .borderRadius(8)
                    .layoutWeight(1)
                    .onChange((val: string) => {
                        this.handleInputChange(val);
                    })
                    .maxLength(20)

                // 按钮组 - 位于右侧
                Row() {
                    this.QuickInputButton('00', () => {
                        this.appendZeros(2);
                    })
                    this.QuickInputButton('000', () => {
                        this.appendZeros(3);
                    })
                    this.QuickInputButton('0000', () => {
                        this.appendZeros(4);
                    })
                }
                .height(32)
                    .alignItems(VerticalAlign.Center)
                    .margin({ left: 8 })
            }
            .width('100%')
                .height(48)
                .alignItems(VerticalAlign.Center)
        }
    .width('100%')
            .alignItems(HorizontalAlign.Start)
    }

    @Builder
    QuickInputButton(text: string, onClick: () => void) {
        Button(text)
            .type(ButtonType.Normal)
            .fontSize(13)
            .fontColor($r('app.color.button_primary'))
            .backgroundColor($r('app.color.bg_blue_light'))
            .height(32)
            .borderRadius(6)
            .padding({ left: 8, right: 8 })
            .margin({ left: 4, right: 4 })
            .onClick(onClick)
    }
}

