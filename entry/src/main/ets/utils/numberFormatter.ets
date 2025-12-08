/**
 * 数字格式化工具
 */

export enum NumberSeparator {
  NONE = 0,      // 不分位
  HUNDRED = 1,   // 百分位（每2位）
  THOUSAND = 2,  // 千分位（每3位）
  TEN_THOUSAND = 3 // 万分位（每4位）
}

export class NumberFormatter {
  /**
   * 格式化数字，根据分位方式添加分隔符
   * @param num 数字
   * @param separator 分位方式
   * @returns 格式化后的字符串
   */
  static formatNumber(num: number, separator: NumberSeparator = NumberSeparator.THOUSAND): string {
    if (isNaN(num) || !isFinite(num)) {
      return '0';
    }

    // 处理小数部分
    const numStr = num.toString();
    const parts = numStr.split('.');
    const integerPart = parts[0];
    const decimalPart = parts[1] || '';

    // 格式化整数部分
    let formattedInteger = '';
    if (separator === NumberSeparator.NONE) {
      formattedInteger = integerPart;
    } else {
      const step = separator === NumberSeparator.HUNDRED ? 2 :
                   separator === NumberSeparator.THOUSAND ? 3 : 4;
      
      let count = 0;
      for (let i = integerPart.length - 1; i >= 0; i--) {
        if (count > 0 && count % step === 0) {
          formattedInteger = ',' + formattedInteger;
        }
        formattedInteger = integerPart[i] + formattedInteger;
        count++;
      }
    }

    // 组合结果
    if (decimalPart) {
      return formattedInteger + '.' + decimalPart;
    }
    return formattedInteger;
  }

  /**
   * 格式化金额（保留2位小数）
   * @param num 数字
   * @param separator 分位方式
   * @returns 格式化后的金额字符串
   */
  static formatCurrency(num: number, separator: NumberSeparator = NumberSeparator.THOUSAND): string {
    const formatted = NumberFormatter.formatNumber(num, separator);
    const parts = formatted.split('.');
    if (parts.length === 1) {
      return formatted + '.00';
    } else if (parts[1].length === 1) {
      return formatted + '0';
    } else if (parts[1].length > 2) {
      return parts[0] + '.' + parts[1].substring(0, 2);
    }
    return formatted;
  }

  /**
   * 移除格式化字符串中的分隔符
   * @param formattedStr 格式化后的字符串
   * @returns 纯数字字符串
   */
  static removeSeparators(formattedStr: string): string {
    if (!formattedStr) return '';
    return formattedStr.replace(/,/g, '');
  }
}

