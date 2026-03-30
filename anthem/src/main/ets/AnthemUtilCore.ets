import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

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

let countriesWithAnthemCache: Set<string> = new Set<string>();

const INIT_ANTHEM_CACHE_MAX_ATTEMPTS = 8;
const INIT_ANTHEM_CACHE_RETRY_DELAY_MS = 450;

async function sleepMs(ms: number): Promise<void> {
  return new Promise<void>((resolve: () => void) => setTimeout(resolve, ms));
}

async function initAnthemCacheOnce(context: common.UIAbilityContext): Promise<boolean> {
  try {
    const resourceManager = context.createModuleContext('anthem').resourceManager;
    const availableCountries = await Promise.all(COUNTRIES_WITH_ANTHEM_STATIC.map(async (countryCode) => {
      try {
        const anthemPath = getAnthemFilePath(countryCode);
        const rawFile = await resourceManager.getRawFd(anthemPath);
        return rawFile ? countryCode : null;
      } catch (_e) {
        return null;
      }
    }));
    const verifiedCountries: string[] = [];
    for (const countryCode of availableCountries) {
      if (countryCode !== null) {
        verifiedCountries.push(countryCode);
      }
    }
    countriesWithAnthemCache = new Set<string>(verifiedCountries);
    hilog.info(DOMAIN, 'AnthemUtilCore', `Anthem cache pass: ${countriesWithAnthemCache.size} files visible`);
    return countriesWithAnthemCache.size > 0;
  } catch (e) {
    countriesWithAnthemCache = new Set<string>();
    hilog.warn(DOMAIN, 'AnthemUtilCore', `createModuleContext(anthem) or scan failed: ${JSON.stringify(e)}`);
    return false;
  }
}

/**
 * 动态模块刚安装完成时，createModuleContext / 资源可能短暂不可用，需重试以免列表为空（「暂无国歌」）。
 */
export async function initAnthemCache(context: common.UIAbilityContext): Promise<void> {
  for (let attempt = 0; attempt < INIT_ANTHEM_CACHE_MAX_ATTEMPTS; attempt++) {
    if (attempt > 0) {
      await sleepMs(INIT_ANTHEM_CACHE_RETRY_DELAY_MS);
    }
    const ok = await initAnthemCacheOnce(context);
    if (ok) {
      return;
    }
  }
  hilog.error(DOMAIN, 'AnthemUtilCore', 'initAnthemCache exhausted retries, cache still empty');
}

export function hasAnthemFile(countryCode: string): boolean {
  return countriesWithAnthemCache.has(countryCode.toLowerCase());
}

export function getAnthemFilePath(countryCode: string): string {
  return `anthems/anthem_${countryCode.toLowerCase()}.ogg`;
}
