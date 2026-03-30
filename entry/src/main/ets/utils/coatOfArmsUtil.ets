/**
 * 国徽工具类（国徽资源在动态模块 coatofarms 中）
 */

import { getCoatOfArmsImageResourceFromModule } from './RegionAssetsUtil';

/**
 * 获取国徽图片资源
 * @param countryCode 国家代码
 * @returns 国徽资源，如果不存在则返回null
 */
export function getCoatOfArmsImageSource(countryCode: string): Resource | null {
  return getCoatOfArmsImageResourceFromModule(countryCode);
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
