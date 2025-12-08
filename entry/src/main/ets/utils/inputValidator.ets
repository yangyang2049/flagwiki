/**
 * 输入验证工具类
 * 提供各种输入验证方法
 */
export class InputValidator {
    /**
     * 验证并过滤数字输入（允许小数点）
     * @param value 输入值
     * @returns 过滤后的值
     */
    static validateNumberInput(value: string): string {
        // 只允许数字和小数点
        let filteredValue = value.replace(/[^0-9.]/g, '');

        // 确保只有一个小数点
        const parts = filteredValue.split('.');
        if (parts.length > 2) {
            filteredValue = parts[0] + '.' + parts.slice(1).join('');
        }

        // 不允许以多个0开头（除非是0.xxx的形式）
        if (filteredValue.length > 1 && filteredValue[0] === '0' && filteredValue[1] !== '.') {
            filteredValue = filteredValue.replace(/^0+/, '0');
        }

        return filteredValue;
    }

    /**
     * 验证并过滤整数输入（不允许小数点）
     * @param value 输入值
     * @param allowEmpty 是否允许空值，默认为true
     * @returns 过滤后的值
     */
    static validateIntegerInput(value: string, allowEmpty: boolean = true): string {
        // 只允许数字
        let filteredValue = value.replace(/[^0-9]/g, '');

        // 如果允许空值且输入为空，直接返回空字符串
        if (allowEmpty && filteredValue === '') {
            return '';
        }

        // 移除前导零
        if (filteredValue.length > 1 && filteredValue[0] === '0') {
            filteredValue = filteredValue.replace(/^0+/, '');
        }

        // 如果为空（且不允许空值），返回0
        if (filteredValue === '') {
            filteredValue = '0';
        }

        return filteredValue;
    }

    /**
     * 验证并过滤百分比输入（0-100，允许小数）
     * @param value 输入值
     * @returns 过滤后的值
     */
    static validatePercentageInput(value: string): string {
        let filteredValue = InputValidator.validateNumberInput(value);

        // 限制在0-100之间
        const numValue = parseFloat(filteredValue);
        if (!isNaN(numValue) && numValue > 100) {
            filteredValue = '100';
        }

        return filteredValue;
    }

    /**
     * 验证银行账号（只允许数字）
     * @param value 输入值
     * @returns 过滤后的值
     */
    static validateBankAccount(value: string): string {
        return value.replace(/[^0-9]/g, '');
    }

    /**
     * 验证电话号码（允许数字、空格、横线、括号）
     * @param value 输入值
     * @returns 过滤后的值
     */
    static validatePhone(value: string): string {
        return value.replace(/[^0-9\s\-()]/g, '');
    }
}

