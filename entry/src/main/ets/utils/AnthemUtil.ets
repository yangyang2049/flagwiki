import { Country, getCountriesByContinent } from './countryData';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// 静态列表：实际存在国歌文件的国家代码（作为备份）
const COUNTRIES_WITH_ANTHEM_STATIC: string[] = [
  'ad', 'ae', 'af', 'ag', 'al', 'am', 'ao', 'ar', 'at', 'au', 'az',
  'ba', 'bb', 'bd', 'be', 'bf', 'bg', 'bh', 'bi', 'bj', 'bn', 'bo', 'br', 'bs', 'bw', 'by', 'bz',
  'ca', 'cf', 'cg', 'ch', 'ci', 'cl', 'cm', 'cn', 'co', 'cr', 'cu', 'cv', 'cy', 'cz',
  'de', 'dj', 'dk', 'dm', 'do', 'dz',
  'ec', 'ee', 'eg', 'er', 'es', 'et',
  'fi', 'fj', 'fm', 'fr',
  'gb', 'gd', 'ge', 'gh', 'gm', 'gn', 'gq', 'gr', 'gt', 'gy',
  'hn', 'hr', 'ht', 'hu',
  'id', 'ie', 'il', 'in', 'iq', 'ir', 'is', 'it',
  'jm', 'jo', 'jp',
  'ke', 'kg', 'kh', 'ki', 'km', 'kn', 'kp', 'kr', 'kw', 'kz',
  'la', 'lb', 'lc', 'li', 'lk', 'lr', 'ls', 'lt', 'lu', 'lv', 'ly',
  'ma', 'mc', 'md', 'me', 'mg', 'mh', 'mk', 'ml', 'mm', 'mn', 'mr', 'mt', 'mu', 'mv', 'mw', 'mx', 'my', 'mz',
  'na', 'ne', 'ng', 'ni', 'nl', 'no', 'np', 'nr', 'nz',
  'pa', 'pe', 'pg', 'ph', 'pk', 'pl', 'ps', 'pt', 'pw', 'py',
  'qa',
  'ro', 'rs', 'ru', 'rw',
  'sa', 'sb', 'sc', 'sd', 'se', 'sg', 'si', 'sk', 'sl', 'sm', 'sn', 'so', 'sr', 'ss', 'st', 'sv', 'sy', 'sz',
  'td', 'th', 'tj', 'tm', 'tn', 'to', 'tr', 'tt', 'tv', 'tz',
  'ua', 'ug', 'us', 'uy', 'uz',
  'va', 'vc', 've', 'vn', 'vu',
  'ws',
  'ye',
  'za', 'zm', 'zw'
];

// 缓存有国歌的国家代码列表（在首次加载时生成）
let countriesWithAnthemCache: string[] | null = null;

/**
 * 初始化有国歌的国家列表缓存
 * 直接使用静态列表，确保一致性
 * @param context UIAbilityContext
 */
export async function initAnthemCache(context: common.UIAbilityContext): Promise<void> {
  // 直接使用静态列表，避免运行时检查导致的不一致
  countriesWithAnthemCache = COUNTRIES_WITH_ANTHEM_STATIC;
  hilog.info(DOMAIN, 'AnthemUtil', `Initialized anthem cache: ${COUNTRIES_WITH_ANTHEM_STATIC.length} countries with anthems`);
}

/**
 * 获取有国歌的国家列表
 */
export function getCountriesWithAnthem(): Country[] {
  const allCountries = getCountriesByContinent('World');
  const anthemList = countriesWithAnthemCache !== null ? countriesWithAnthemCache : COUNTRIES_WITH_ANTHEM_STATIC;
  return allCountries.filter((country: Country) => {
    return anthemList.includes(country.code.toLowerCase());
  });
}

/**
 * 检查国家是否有国歌文件
 */
export function hasAnthemFile(countryCode: string): boolean {
  const lowerCode = countryCode.toLowerCase();
  if (countriesWithAnthemCache !== null) {
    return countriesWithAnthemCache.includes(lowerCode);
  }
  // 如果缓存未初始化，使用静态列表
  return COUNTRIES_WITH_ANTHEM_STATIC.includes(lowerCode);
}

/**
 * 获取国歌文件路径（用于rawfile）
 */
export function getAnthemFilePath(countryCode: string): string {
  return `anthems/anthem_${countryCode.toLowerCase()}.ogg`;
}



