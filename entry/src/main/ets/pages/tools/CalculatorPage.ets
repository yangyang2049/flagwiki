import vibrator from '@ohos.vibrator';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { NumberFormatter, NumberSeparator } from '../../utils/numberFormatter';

@Entry
@Component
    struct CalculatorPage {
    @State display: string = '0';
    @State currentValue: number = 0;
    @State previousValue: number = 0;
    @State operation: string = '';
    @State shouldResetDisplay: boolean = false;
    @State history: string[] = [];
    @State vibrationEnabled: boolean = true;
    @State showUpperCaseDialog: boolean = false;
    @State upperCaseText: string = '';

    private readonly digits: string[] = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];
    private readonly units: string[] = ['', '拾', '佰', '仟'];
    private readonly bigUnits: string[] = ['', '万', '亿'];

    aboutToAppear(): void {
        try {
            promptAction.showToast({
                message: '点击结果可复制',
                duration: 2000,
                bottom: 100
            });
        } catch (err) {
            console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
        }
    }

    private triggerVibration(): void {
        if (!this.vibrationEnabled) {
            return;
        }
        try {
            // 使用预设的触摸反馈效果
            vibrator.startVibration({
                type: 'preset',
                effectId: 'haptic.clock.timer',
                count: 1
            }, {
                usage: 'touch'
            }).then(() => {
                console.info('Vibration started successfully');
            }).catch((error: Error) => {
                console.error(`Failed to start vibration: ${error.message}`);
            });
        } catch (err) {
            console.error(`Vibration error: ${err instanceof Error ? err.message : String(err)}`);
        }
    }

    private handleNumber(num: string): void {
        this.triggerVibration();
        if (this.shouldResetDisplay) {
            this.display = num;
            this.shouldResetDisplay = false;
        } else {
            if (this.display === '0') {
                this.display = num;
            } else {
                this.display += num;
            }
        }
        this.currentValue = parseFloat(this.display);
    }

    private handleOperation(op: string): void {
        if (this.operation !== '' && !this.shouldResetDisplay) {
            this.calculate();
        }
        this.previousValue = this.currentValue;
        this.operation = op;
        this.shouldResetDisplay = true;
        this.triggerVibration();
        // 更新历史记录：显示 "数字 操作符"
        this.addHistory(`${this.formatResult(this.previousValue)} ${op}`);
    }

    private calculate(): void {
        this.triggerVibration();
        if (this.operation === '') {
            return;
        }

        let result: number = 0;
        switch (this.operation) {
            case '+':
                result = this.previousValue + this.currentValue;
                break;
            case '-':
                result = this.previousValue - this.currentValue;
                break;
            case '×':
                result = this.previousValue * this.currentValue;
                break;
            case '÷':
                if (this.currentValue === 0) {
                    this.display = '错误';
                    this.clear();
                    return;
                }
                result = this.previousValue / this.currentValue;
                break;
        }

        // 保存当前显示值（第二个操作数）用于历史记录
        const secondOperand = this.currentValue;
        this.currentValue = result;
        this.display = this.formatResult(result);
        // 更新历史记录：显示完整的计算过程 "数字1 操作符 数字2 ="
        this.addHistory(`${this.formatResult(this.previousValue)} ${this.operation} ${this.formatResult(secondOperand)} =`);
        this.operation = '';
        this.shouldResetDisplay = true;
    }

    private formatResult(num: number): string {
        // 如果是整数，不显示小数点
        if (num % 1 === 0) {
            return num.toString();
        }
        // 最多保留10位小数，去除末尾的0
        return num.toFixed(10).replace(/\.?0+$/, '');
    }

    private addHistory(record: string): void {
        this.history.push(record);
        // 保持最多3条历史记录
        if (this.history.length > 3) {
            this.history.shift();
        }
    }

    private getFormattedDisplay(): string {
        const num = parseFloat(this.display);
        if (isNaN(num)) {
            return this.display;
        }
        return NumberFormatter.formatNumber(num, NumberSeparator.THOUSAND);
    }

    private clear(): void {
        this.triggerVibration();
        this.display = '0';
        this.currentValue = 0;
        this.previousValue = 0;
        this.operation = '';
        this.shouldResetDisplay = false;
        this.history = [];
    }

    private handleDelete(): void {
        this.triggerVibration();
        if (this.display.length > 1) {
            this.display = this.display.slice(0, -1);
            this.currentValue = parseFloat(this.display) || 0;
        } else {
            this.display = '0';
            this.currentValue = 0;
        }
    }

    private handleDecimal(): void {
        this.triggerVibration();
        if (this.shouldResetDisplay) {
            this.display = '0.';
            this.shouldResetDisplay = false;
        } else if (!this.display.includes('.')) {
            this.display += '.';
        }
        this.currentValue = parseFloat(this.display) || 0;
    }

    private handlePercent(): void {
        this.triggerVibration();
        this.currentValue = this.currentValue / 100;
        this.display = this.formatResult(this.currentValue);
    }

    private handleToggleSign(): void {
        this.triggerVibration();
        this.currentValue = -this.currentValue;
        this.display = this.formatResult(this.currentValue);
    }

    private convertToUpperCase(amount: number): string {
        if (amount === 0) {
            return '零元整';
        }

        const absAmount = Math.abs(amount);
        const yuan = Math.floor(absAmount);
        const jiao = Math.floor((absAmount - yuan) * 10);
        const fen = Math.round((absAmount - yuan - jiao / 10) * 100);

        let result = amount < 0 ? '负' : '';

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

    private showUpperCase(): void {
        if (this.display === '错误' || this.display === '0') {
            try {
                promptAction.showToast({
                    message: '请先输入有效数字',
                    duration: 2000
                });
            } catch (err) {
                console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
            }
            return;
        }

        const num = parseFloat(this.display);
        if (isNaN(num)) {
            return;
        }

        this.upperCaseText = this.convertToUpperCase(num);
        this.showUpperCaseDialog = true;
    }

    private async copyUpperCase(): Promise<void> {
        try {
            const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
            const pasteData: pasteboard.PasteData = pasteboard.createPlainTextData(this.upperCaseText);
            await systemPasteboard.setData(pasteData);
            this.showUpperCaseDialog = false;
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
            Column() {
                // 大写转换对话框
                if (this.showUpperCaseDialog) {
                    Column() {
                        Column() {
                            Text('数字大写')
                                .fontSize(18)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .margin({ bottom: 16 })

                            Scroll() {
                                Column() {
                                    Text('数字')
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_secondary'))
                                        .alignSelf(ItemAlign.Start)
                                        .margin({ bottom: 8 })
                                    Text(this.getFormattedDisplay())
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.text_primary'))
                                        .alignSelf(ItemAlign.Start)
                                        .margin({ bottom: 16 })
                                        .maxLines(3)
                                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                                        .copyOption(CopyOptions.LocalDevice)

                                    Text('大写')
                                        .fontSize(14)
                                        .fontColor($r('app.color.text_secondary'))
                                        .alignSelf(ItemAlign.Start)
                                        .margin({ bottom: 8 })
                                    Text(this.upperCaseText)
                                        .fontSize(18)
                                        .fontColor($r('app.color.button_primary'))
                                        .alignSelf(ItemAlign.Start)
                                        .lineHeight(28)
                                        .copyOption(CopyOptions.LocalDevice)
                                }
                                .width('100%')
                            }
                            .scrollable(ScrollDirection.Vertical)
                                .scrollBar(BarState.Auto)
                                .edgeEffect(EdgeEffect.Spring)
                                .width('100%')
                                .constraintSize({ maxHeight: 300 })
                                .margin({ bottom: 24 })

                            Row() {
                                Button('关闭')
                                    .type(ButtonType.Normal)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_secondary'))
                                    .backgroundColor($r('app.color.bg_secondary'))
                                    .height(44)
                                    .layoutWeight(1)
                                    .borderRadius(8)
                                    .onClick(() => {
                                        this.showUpperCaseDialog = false;
                                    })

                                Button('复制')
                                    .type(ButtonType.Normal)
                                    .fontSize(16)
                                    .fontColor($r('app.color.text_white'))
                                    .backgroundColor($r('app.color.button_primary'))
                                    .height(44)
                                    .layoutWeight(1)
                                    .borderRadius(8)
                                    .margin({ left: 12 })
                                    .onClick(() => {
                                        this.copyUpperCase();
                                    })
                            }
                            .width('100%')
                        }
                        .width('85%')
                            .constraintSize({ maxWidth: 400 })
                            .padding(24)
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
                        .backgroundColor('rgba(0, 0, 0, 0.5)')
                        .justifyContent(FlexAlign.Center)
                        .onClick(() => {
                            this.showUpperCaseDialog = false;
                        })
                }

                Column() {
                    // 显示屏
                    Column() {
                        // 历史记录（最多3行）
                        if (this.history.length > 0) {
                            Column() {
                                ForEach(this.history, (item: string, index: number) => {
                                    Text(item)
                                        .fontSize(18)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .textAlign(TextAlign.End)
                                        .maxLines(1)
                                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                                        .margin({ bottom: index < this.history.length - 1 ? 4 : 8 })
                                })
                            }
                                .width('100%')
                                .alignItems(HorizontalAlign.End)
                        }
                        // 当前显示
                        Text(this.display)
                            .fontSize(48)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .textAlign(TextAlign.End)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                        .width('100%')
                        .height(120)
                        .padding({ left: 20, right: 20 })
                        .justifyContent(FlexAlign.End)
                        .alignItems(HorizontalAlign.End)
                        .onClick(() => {
                            if (this.display !== '错误') {
                                this.copyToClipboard(this.display);
                            }
                        })

                    // 按钮区域
                    Column() {
                        // 第一行：%、+/-、C、删除
                        Row() {
                            this.CalcButton('%', $r('app.color.bg_secondary'), $r('app.color.text_primary'), true, () => { this.handlePercent(); })
                            this.CalcButton('+/-', $r('app.color.bg_secondary'), $r('app.color.text_primary'), true, () => { this.handleToggleSign(); })
                            this.CalcButton('C', $r('app.color.bg_secondary'), $r('app.color.text_primary'), true, () => { this.clear(); })
                            this.CalcButton('⌫', $r('app.color.bg_secondary'), $r('app.color.text_primary'), true, () => { this.handleDelete(); })
                        }
                            .width('100%')
                            .height(72)
                            .justifyContent(FlexAlign.SpaceBetween)

                        // 第二行：7、8、9、除
                        Row() {
                            this.CalcButton('7', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('7'); })
                            this.CalcButton('8', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('8'); })
                            this.CalcButton('9', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('9'); })
                            this.CalcButton('÷', $r('app.color.button_primary'), $r('app.color.white'), false, () => { this.handleOperation('÷'); })
                        }
                            .width('100%')
                            .height(72)
                            .justifyContent(FlexAlign.SpaceBetween)
                            .margin({ top: 12 })

                        // 第三行：4、5、6、乘
                        Row() {
                            this.CalcButton('4', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('4'); })
                            this.CalcButton('5', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('5'); })
                            this.CalcButton('6', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('6'); })
                            this.CalcButton('×', $r('app.color.button_primary'), $r('app.color.white'), false, () => { this.handleOperation('×'); })
                        }
                            .width('100%')
                            .height(72)
                            .justifyContent(FlexAlign.SpaceBetween)
                            .margin({ top: 12 })

                        // 第四行：1、2、3、减
                        Row() {
                            this.CalcButton('1', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('1'); })
                            this.CalcButton('2', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('2'); })
                            this.CalcButton('3', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('3'); })
                            this.CalcButton('-', $r('app.color.button_primary'), $r('app.color.white'), false, () => { this.handleOperation('-'); })
                        }
                            .width('100%')
                            .height(72)
                            .justifyContent(FlexAlign.SpaceBetween)
                            .margin({ top: 12 })

                        // 第五行：小数点、0、等号、加
                        Row() {
                            this.CalcButton('.', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleDecimal(); })
                            this.CalcButton('0', $r('app.color.white'), $r('app.color.text_primary'), false, () => { this.handleNumber('0'); })
                            this.CalcButton('=', $r('app.color.button_primary'), $r('app.color.white'), false, () => { this.calculate(); })
                            this.CalcButton('+', $r('app.color.button_primary'), $r('app.color.white'), false, () => { this.handleOperation('+'); })
                        }
                            .width('100%')
                            .height(72)
                            .justifyContent(FlexAlign.SpaceBetween)
                            .margin({ top: 12 })
                    }
                        .width('100%')
                        .padding(16)
                }
                    .width('100%')
                    .constraintSize({ maxWidth: 400 })
                    .alignSelf(ItemAlign.Center)
            }
                .width('100%')
                .height('100%')
                .justifyContent(FlexAlign.Start)
                .backgroundColor($r('app.color.bg_page'))
        }
            .title('计算器')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
            .menus(this.MenuBuilder)
    }

    onBackPress(): boolean {
        router.back();
        return true;
    }

    @Builder
    MenuBuilder() {
        Row() {
            // 大写转换按钮
            Text('大')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.button_primary'))
                .width(24)
                .height(24)
                .textAlign(TextAlign.Center)
                .margin({ right: 16 })
                .onClick(() => {
                    this.showUpperCase();
                })

            // 振动按钮
            Image(this.vibrationEnabled ? $r('app.media.icon_vibration') : $r('app.media.icon_vibration_off'))
                .width(24)
                .height(24)
                .onClick(() => {
                    this.vibrationEnabled = !this.vibrationEnabled;
                    try {
                        promptAction.showToast({
                            message: this.vibrationEnabled ? '震动已开启' : '震动已关闭',
                            duration: 2000
                        });
                    } catch (err) {
                        console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
                    }
                })
        }
            .height('100%')
            .justifyContent(FlexAlign.End)
            .alignItems(VerticalAlign.Center)
            .padding({ right: 16 })
    }

    @Builder
    CalcButton(text: string, bgColor: ResourceColor, textColor: ResourceColor, showBorder: boolean, onClick: () => void) {
        Button(text)
            .fontSize(text.length > 1 ? 20 : 24)
            .fontWeight(FontWeight.Medium)
            .fontColor(textColor)
            .backgroundColor(bgColor)
            .borderRadius(8)
            .layoutWeight(1)
            .height('100%')
            .margin({ left: 6, right: 6 })
            .border(showBorder ? { width: 1, color: $r('app.color.gray_border') } : undefined)
            .shadow({
                radius: 2,
                color: $r('app.color.shadow'),
                offsetX: 0,
                offsetY: 1
            })
            .onClick(onClick)
    }
}
