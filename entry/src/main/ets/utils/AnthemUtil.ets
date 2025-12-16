import { Country, getCountriesByContinent } from './countryData';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// 缓存有国歌的国家代码列表（在首次加载时生成）
let countriesWithAnthemCache: string[] | null = null;

/**
 * 初始化有国歌的国家列表缓存
 * @param context UIAbilityContext
 */
export async function initAnthemCache(context: common.UIAbilityContext): Promise<void> {
  if (countriesWithAnthemCache !== null) {
    return;
  }
  
  try {
    const allCountries = getCountriesByContinent('World');
    const countriesWithAnthem: string[] = [];
    
    for (const country of allCountries) {
      const anthemPath = `anthems/anthem_${country.code.toLowerCase()}.ogg`;
      try {
        await context.resourceManager.getRawFd(anthemPath);
        // 统一使用小写存储，确保一致性
        countriesWithAnthem.push(country.code.toLowerCase());
      } catch {
        // 文件不存在，跳过
      }
    }
    
    countriesWithAnthemCache = countriesWithAnthem;
    hilog.info(DOMAIN, 'AnthemUtil', `Initialized anthem cache: ${countriesWithAnthem.length} countries with anthems`);
  } catch (error) {
    const err = error as Error;
    hilog.error(DOMAIN, 'AnthemUtil', `Failed to init anthem cache: ${err.message}`);
    countriesWithAnthemCache = [];
  }
}

/**
 * 获取有国歌的国家列表
 */
export function getCountriesWithAnthem(): Country[] {
  const allCountries = getCountriesByContinent('World');
  if (countriesWithAnthemCache === null) {
    // 如果缓存未初始化，返回所有国家（会在页面加载时过滤）
    return allCountries;
  }
  return allCountries.filter((country: Country) => {
    return countriesWithAnthemCache !== null && countriesWithAnthemCache.includes(country.code.toLowerCase());
  });
}

/**
 * 检查国家是否有国歌文件
 */
export function hasAnthemFile(countryCode: string): boolean {
  if (countriesWithAnthemCache === null) {
    // 如果缓存未初始化，返回true（会在页面加载时检查）
    return true;
  }
  return countriesWithAnthemCache.includes(countryCode.toLowerCase());
}

/**
 * 获取国歌文件路径（用于rawfile）
 */
export function getAnthemFilePath(countryCode: string): string {
  return `anthems/anthem_${countryCode.toLowerCase()}.ogg`;
}

