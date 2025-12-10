/**
 * 国徽工具类
 * 用于获取预下载到media文件夹的国徽资源
 */

import { Country, getCountryByCode } from './countryData';

/**
 * 获取国徽图片资源
 * @param countryCode 国家代码
 * @returns 国徽资源，如果不存在则返回null
 */
export function getCoatOfArmsImageSource(countryCode: string): Resource | null {
  const lowerCode = countryCode.toLowerCase();
  try {
    // 尝试从media文件夹加载国徽
    // 资源名称格式: coat_of_arms_xx (如 coat_of_arms_cn)
    const resourceName = `app.media.coat_of_arms_${lowerCode}`;
    return $r(resourceName);
  } catch (err) {
    // 资源不存在，返回null
    return null;
  }
}

/**
 * 检查国徽是否存在
 * @param countryCode 国家代码
 * @returns 是否存在国徽资源
 */
export function hasCoatOfArms(countryCode: string): boolean {
  const resource = getCoatOfArmsImageSource(countryCode);
  return resource !== null;
}
