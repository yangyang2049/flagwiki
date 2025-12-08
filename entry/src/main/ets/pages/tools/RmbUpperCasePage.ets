import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { AmountInput } from '../../components/AmountInput';

@Entry
@Component
    struct RmbUpperCasePage {
    @State amount: string = '';
    @State upperCase: string = '';
    @State showResult: boolean = false;
    @State errorMessage: string = '';

    private readonly digits: string[] = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];
    private readonly units: string[] = ['', '拾', '佰', '仟'];
    private readonly bigUnits: string[] = ['', '万', '亿'];

    private convertToUpperCase(amount: number): string {
        if (amount === 0) {
            return '零元整';
        }

        const yuan = Math.floor(amount);
        const jiao = Math.floor((amount - yuan) * 10);
        const fen = Math.round((amount - yuan - jiao / 10) * 100);

        let result = '';

        // 处理整数部分
        if (yuan > 0) {
            result += this.convertInteger(yuan) + '元';
        } else {
            result += '零元';
        }

        // 处理角分
        if (jiao > 0 && fen > 0) {
            result += this.digits[jiao] + '角' + this.digits[fen] + '分';
        } else if (jiao > 0) {
            result += this.digits[jiao] + '角整';
        } else if (fen > 0) {
            result += this.digits[fen] + '分';
        } else {
            result += '整';
        }

        return result;
    }

    private convertInteger(num: number): string {
        if (num === 0) {
            return '零';
        }

        const numStr = num.toString();
        const len = numStr.length;
        let result = '';

        for (let i = 0; i < len; i++) {
            const digit = parseInt(numStr[i]);
            const pos = len - i - 1;
            const unitPos = pos % 4;
            const bigUnitPos = Math.floor(pos / 4);

            if (digit !== 0) {
                if (i > 0 && numStr[i - 1] === '0') {
                    result += '零';
                }
                result += this.digits[digit] + this.units[unitPos];
            }

            if (unitPos === 0 && bigUnitPos > 0) {
                const section = Math.floor(num / Math.pow(10000, bigUnitPos)) % 10000;
                if (section > 0) {
                    result += this.bigUnits[bigUnitPos];
                }
            }
        }

        return result;
    }

    private validateInput(): boolean {
        if (!this.amount || this.amount.trim() === '') {
            this.errorMessage = '请输入金额';
            return false;
        }
        const num = parseFloat(this.amount);
        if (isNaN(num)) {
            this.errorMessage = '请输入有效的数字';
            return false;
        }
        if (num < 0) {
            this.errorMessage = '金额不能为负数';
            return false;
        }
        if (num > 999999999999.99) {
            this.errorMessage = '金额超出范围（最大999,999,999,999.99）';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

    private convert(): void {
        if (!this.validateInput()) {
            return;
        }

        const num = parseFloat(this.amount);
        this.upperCase = this.convertToUpperCase(num);
        this.showResult = true;
    }

    private async copyToClipboard(text: string): Promise<void> {
        try {
            const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
            const pasteData: pasteboard.PasteData = pasteboard.createPlainTextData(text);
            await systemPasteboard.setData(pasteData);
            try {
                promptAction.showToast({
                    message: '已复制到剪贴板',
                    duration: 2000
                });
            } catch (toastErr) {
                console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
            }
        } catch (err) {
            const error = err as Error;
            console.error(`Failed to copy to clipboard: ${error.message}`);
            try {
                promptAction.showToast({
                    message: '复制失败',
                    duration: 2000
                });
            } catch (toastErr) {
                console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
            }
        }
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    Column() {
                        AmountInput({
                            label: '输入金额（元）',
                            placeholder: '请输入金额，如：1234.56',
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
                        .borderRadius(0)
                        .margin({ top: 0, left: 16, right: 16 })

                    Button('转换')
                        .type(ButtonType.Normal)
                        .fontSize(16)
                        .width('80%')
                        .constraintSize({ maxWidth: 320 })
                        .height(48)
                        .borderRadius(8)
                        .margin({ top: 16, left: 16, right: 16 })
                        .onClick(() => this.convert())

                    if (this.showResult) {
                        Column() {
                            Row() {
                                Text('大写金额')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_tertiary'))
                                    .layoutWeight(1)

                                Image($r('app.media.icon_copy'))
                                    .width(20)
                                    .height(20)
                                    .onClick(() => {
                                        this.copyToClipboard(this.upperCase);
                                    })
                            }
                            .width('100%')
                            .margin({ bottom: 12 })
                            .alignItems(VerticalAlign.Center)

                            Text(this.upperCase)
                                .fontSize(20)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                                .width('100%')
                                .lineHeight(32)
                                .copyOption(CopyOptions.LocalDevice)
                        }
                        .width('100%')
                            .padding(20)
                            .backgroundColor($r('app.color.bg_card'))
                            .borderRadius(0)
                            .margin({ top: 16, left: 16, right: 16 })
                            .alignItems(HorizontalAlign.Start)
                    }

                    Column() {
                        Text('使用说明')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 支持最大金额：999,999,999,999.99元')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 自动处理零的读法，如：1001.00 → 壹仟零壹元整')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 适用于发票、合同等正式文档')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .borderRadius(0)
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('人民币大写转换')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

