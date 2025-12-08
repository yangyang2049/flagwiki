import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';

export interface InvoiceInfo {
  companyName: string;
  taxNumber: string;
  address: string;
  phone: string;
  bankName: string;
  bankAccount: string;
}

/**
 * 保存开票信息
 */
export async function saveInvoiceInfo(context: common.UIAbilityContext, info: InvoiceInfo): Promise<void> {
  try {
    const prefs = await preferences.getPreferences(context, 'app_settings');
    await prefs.put('invoiceInfo', JSON.stringify(info));
    await prefs.flush();
  } catch (err) {
    console.error(`Failed to save invoice info: ${JSON.stringify(err)}`);
  }
}

/**
 * 获取开票信息
 */
export async function getInvoiceInfo(context: common.UIAbilityContext): Promise<InvoiceInfo | null> {
  try {
    const prefs = await preferences.getPreferences(context, 'app_settings');
    const infoJson: string = await prefs.get('invoiceInfo', '') as string;
    if (infoJson && infoJson !== '') {
      return JSON.parse(infoJson) as InvoiceInfo;
    }
    return null;
  } catch (err) {
    console.error(`Failed to get invoice info: ${JSON.stringify(err)}`);
    return null;
  }
}

/**
 * 检查是否已填写开票信息
 */
export async function isInvoiceInfoFilled(context: common.UIAbilityContext): Promise<boolean> {
  try {
    const info = await getInvoiceInfo(context);
    if (!info) {
      return false;
    }
    // 检查是否至少有一个字段有内容
    return [
      info.companyName,
      info.taxNumber,
      info.address,
      info.phone,
      info.bankName,
      info.bankAccount
    ].some(value => value && value.trim() !== '');
  } catch (err) {
    console.error(`Failed to check invoice info filled: ${JSON.stringify(err)}`);
    return false;
  }
}

/**
 * 删除开票信息
 */
export async function deleteInvoiceInfo(context: common.UIAbilityContext): Promise<void> {
  try {
    const prefs = await preferences.getPreferences(context, 'app_settings');
    await prefs.delete('invoiceInfo');
    await prefs.flush();
  } catch (err) {
    console.error(`Failed to delete invoice info: ${JSON.stringify(err)}`);
  }
}

/**
 * 格式化开票信息用于显示
 */
export function formatInvoiceInfoForDisplay(info: InvoiceInfo): string {
  const parts: string[] = [];
  if (info.companyName && info.companyName.trim() !== '') {
    parts.push(`公司名称：${info.companyName}`);
  }
  if (info.taxNumber && info.taxNumber.trim() !== '') {
    parts.push(`纳税人识别号：${info.taxNumber}`);
  }
  if (info.address && info.address.trim() !== '') {
    parts.push(`注册地址：${info.address}`);
  }
  if (info.phone && info.phone.trim() !== '') {
    parts.push(`注册电话：${info.phone}`);
  }
  if (info.bankName && info.bankName.trim() !== '') {
    parts.push(`开户行：${info.bankName}`);
  }
  if (info.bankAccount && info.bankAccount.trim() !== '') {
    parts.push(`银行账号：${info.bankAccount}`);
  }
  return parts.join('\n');
}
