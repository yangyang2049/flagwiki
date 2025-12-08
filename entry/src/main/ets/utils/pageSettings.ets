import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { NumberSeparator } from './numberFormatter';

/**
 * 页面设置工具类
 * 用于管理每个页面的分位设置
 */
export class PageSettings {
  private static prefs: preferences.Preferences | null = null;
  private static context: common.UIAbilityContext | null = null;

  /**
   * 初始化设置（在页面aboutToAppear中调用）
   */
  static async init(context: common.UIAbilityContext): Promise<void> {
    try {
      PageSettings.context = context;
      PageSettings.prefs = await preferences.getPreferences(context, 'page_settings');
    } catch (err) {
      console.error(`Failed to init page settings: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 获取页面的分位设置
   * @param pageName 页面名称（如 'SalaryTaxPage'）
   * @returns 分位设置，如果没有则返回null（使用全局设置）
   */
  static async getPageSeparator(pageName: string): Promise<NumberSeparator | null> {
    if (!PageSettings.prefs) return null;
    try {
      const value = await PageSettings.prefs.get(`separator_${pageName}`, null);
      if (value === null) {
        return null;
      }
      return Number(value);
    } catch (err) {
      console.error(`Failed to get page separator: ${JSON.stringify(err)}`);
      return null;
    }
  }

  /**
   * 保存页面的分位设置
   * @param pageName 页面名称
   * @param separator 分位设置，如果为null则删除页面设置（使用全局设置）
   */
  static async savePageSeparator(pageName: string, separator: NumberSeparator | null): Promise<void> {
    if (!PageSettings.prefs) return;
    try {
      const key = `separator_${pageName}`;
      if (separator === null) {
        // 删除页面设置，使用全局设置
        await PageSettings.prefs.delete(key);
      } else {
        await PageSettings.prefs.put(key, separator);
      }
      await PageSettings.prefs.flush();
    } catch (err) {
      console.error(`Failed to save page separator: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 获取全局分位设置
   */
  static async getGlobalSeparator(): Promise<NumberSeparator> {
    if (!PageSettings.context) return NumberSeparator.THOUSAND;
    try {
      const prefs = await preferences.getPreferences(PageSettings.context, 'app_settings');
      const value: number = await prefs.get('numberSeparator', NumberSeparator.THOUSAND) as number;
      return value as NumberSeparator;
    } catch (err) {
      console.error(`Failed to get global separator: ${JSON.stringify(err)}`);
      return NumberSeparator.THOUSAND;
    }
  }

  /**
   * 获取有效的分位设置（优先使用页面设置，否则使用全局设置）
   * @param pageName 页面名称
   */
  static async getEffectiveSeparator(pageName: string): Promise<NumberSeparator> {
    const pageSeparator = await PageSettings.getPageSeparator(pageName);
    if (pageSeparator !== null) {
      return pageSeparator;
    }
    return await PageSettings.getGlobalSeparator();
  }
}

