/**
 * 国徽工具类
 * 用于获取rawfile目录中的国徽资源
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
    // 从rawfile/coat_of_arms目录加载PNG格式的国徽
    // 文件路径格式: coat_of_arms/coat_of_arms_xx.png (如 coat_of_arms/coat_of_arms_cn.png)
    const filePath = `coat_of_arms/coat_of_arms_${lowerCode}.png`;
    return $rawfile(filePath) as Resource;
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
