/**
 * 涂鸦游戏数据
 * 包含国旗颜色信息和关卡配置
 */

// 国旗涂鸦信息
export interface FlagPaintInfo {
  cca2: string;           // 国家代码
  colors: string[];       // 正确颜色序列（十六进制）
  aspectRatio: number;    // 宽高比
}

// 涂鸦游戏关卡
export interface PaintLevel {
  level: number;
  flags: string[];
}

// 国家/地区分类配置
export interface PaintCategory {
  id: string;
  name: string;
  emoji: string;
  description: string;
  levels: PaintLevel[];
}

// 世界国旗涂鸦关卡配置
export const worldPaintLevels: PaintLevel[] = [
  { level: 1, flags: ['fr', 'de', 'it'] },
  { level: 2, flags: ['cn', 'jp', 'kr'] },
  { level: 3, flags: ['us', 'ca', 'mx'] },
  { level: 4, flags: ['br', 'ar', 'co'] },
  { level: 5, flags: ['gb', 'au', 'nz'] },
  { level: 6, flags: ['eg', 'ng', 'za'] },
  { level: 7, flags: ['in', 'ir', 'tr'] },
  { level: 8, flags: ['ru', 'se', 'pl'] },
  { level: 9, flags: ['sa', 'id', 'my'] },
  { level: 10, flags: ['es', 'pt', 'gr'] },
  { level: 11, flags: ['th', 'vn', 'sg'] },
  { level: 12, flags: ['be', 'nl', 'ie'] },
  { level: 13, flags: ['et', 'ke', 'tz'] },
  { level: 14, flags: ['ae', 'om', 'ye'] },
  { level: 15, flags: ['cu', 'cl', 've'] },
  { level: 16, flags: ['ch', 'at', 'cz'] },
  { level: 17, flags: ['ma', 'tn', 'dz'] },
  { level: 18, flags: ['pk', 'bd', 'lk'] },
  { level: 19, flags: ['jm', 'pe', 'pa'] },
  { level: 20, flags: ['mg', 'so', 'mz'] },
];

// 美国州旗涂鸦关卡（按受欢迎程度排列）
export const usPaintLevels: PaintLevel[] = [
  { level: 1, flags: ['california', 'texas', 'new_york'] },
  { level: 2, flags: ['florida', 'alaska', 'hawaii'] },
  { level: 3, flags: ['district_of_columbia', 'massachusetts', 'pennsylvania'] },
  { level: 4, flags: ['illinois', 'ohio', 'michigan'] },
  { level: 5, flags: ['georgia', 'north_carolina', 'virginia'] },
  { level: 6, flags: ['washington', 'colorado', 'arizona'] },
  { level: 7, flags: ['tennessee', 'indiana', 'missouri'] },
  { level: 8, flags: ['maryland', 'wisconsin', 'minnesota'] },
  { level: 9, flags: ['louisiana', 'alabama', 'kentucky'] },
  { level: 10, flags: ['south_carolina', 'oregon', 'oklahoma'] },
  { level: 11, flags: ['connecticut', 'utah', 'iowa'] },
  { level: 12, flags: ['arkansas', 'mississippi', 'kansas'] },
  { level: 13, flags: ['nevada', 'new_mexico', 'nebraska'] },
  { level: 14, flags: ['west_virginia', 'maine', 'new_hampshire'] },
  { level: 15, flags: ['rhode_island', 'delaware', 'montana'] },
  { level: 16, flags: ['south_dakota', 'north_dakota', 'wyoming'] },
  { level: 17, flags: ['vermont', 'idaho', 'new_jersey'] },
];

// 涂鸦分类列表
export const paintCategories: PaintCategory[] = [
  {
    id: 'world',
    name: '世界',
    emoji: '🌍',
    description: '世界各国国旗涂鸦',
    levels: worldPaintLevels
  },
  {
    id: 'us',
    name: '美国',
    emoji: '🇺🇸',
    description: '美国各州州旗涂鸦',
    levels: usPaintLevels
  }
];

// 国旗颜色配置（十六进制，不带#）
export const flagsColorMap: Record<string, FlagPaintInfo> = {
  // 世界国旗
  'fr': { cca2: 'fr', colors: ['002395', 'FFFFFF', 'ED2939'], aspectRatio: 1.5 },
  'de': { cca2: 'de', colors: ['000000', 'DD0000', 'FFCE00'], aspectRatio: 1.5 },
  'it': { cca2: 'it', colors: ['009246', 'FFFFFF', 'CE2B37'], aspectRatio: 1.5 },
  'cn': { cca2: 'cn', colors: ['DE2910', 'FFDE00'], aspectRatio: 1.5 },
  'jp': { cca2: 'jp', colors: ['FFFFFF', 'BC002D'], aspectRatio: 1.5 },
  'kr': { cca2: 'kr', colors: ['FFFFFF', '000000', 'CD2E3A', '0047A0'], aspectRatio: 1.5 },
  'us': { cca2: 'us', colors: ['B22234', 'FFFFFF', '3C3B6E'], aspectRatio: 1.9 },
  'ca': { cca2: 'ca', colors: ['FF0000', 'FFFFFF', 'FF0000', 'FF0000'], aspectRatio: 2 },
  'mx': { cca2: 'mx', colors: ['006847', 'FFFFFF', 'CE1126'], aspectRatio: 1.75 },
  'br': { cca2: 'br', colors: ['009B3A', 'FEDF00', '002776'], aspectRatio: 2 },
  'ar': { cca2: 'ar', colors: ['74ACDF', 'FFFFFF', '74ACDF'], aspectRatio: 2 },
  'co': { cca2: 'co', colors: ['FCD116', '003893', 'CE1126'], aspectRatio: 2 },
  'gb': { cca2: 'gb', colors: ['012169', 'FFFFFF', 'C8102E', 'FFFFFF', 'C8102E'], aspectRatio: 2 },
  'au': { cca2: 'au', colors: ['012169', 'FFFFFF'], aspectRatio: 2 },
  'nz': { cca2: 'nz', colors: ['012169', 'C8102E'], aspectRatio: 2 },
  'eg': { cca2: 'eg', colors: ['CE1126', 'FFFFFF', '000000'], aspectRatio: 1.5 },
  'ng': { cca2: 'ng', colors: ['008751', 'FFFFFF', '008751'], aspectRatio: 2 },
  'za': { cca2: 'za', colors: ['E03C31', '001489', 'FFFFFF', '000000', '007749', 'FFB81C'], aspectRatio: 2 },
  'in': { cca2: 'in', colors: ['FF671F', 'FFFFFF', '046A38'], aspectRatio: 2 },
  'ir': { cca2: 'ir', colors: ['239F40', 'FFFFFF', 'DA0000'], aspectRatio: 2 },
  'tr': { cca2: 'tr', colors: ['E30A17', 'FFFFFF'], aspectRatio: 2 },
  'ru': { cca2: 'ru', colors: ['FFFFFF', '0039A6', 'D52B1E'], aspectRatio: 2 },
  'se': { cca2: 'se', colors: ['006AA7', 'FECC00'], aspectRatio: 2 },
  'pl': { cca2: 'pl', colors: ['FFFFFF', 'DC143C'], aspectRatio: 2 },
  'sa': { cca2: 'sa', colors: ['006C35', 'FFFFFF'], aspectRatio: 2 },
  'id': { cca2: 'id', colors: ['FF0000', 'FFFFFF'], aspectRatio: 2 },
  'my': { cca2: 'my', colors: ['FFFFFF', 'CC0000', '000066', 'FFCC00'], aspectRatio: 2 },
  'es': { cca2: 'es', colors: ['C60B1E', 'FFC400'], aspectRatio: 2 },
  'pt': { cca2: 'pt', colors: ['006600', 'FF0000'], aspectRatio: 2 },
  'gr': { cca2: 'gr', colors: ['0D5EAF', 'FFFFFF'], aspectRatio: 2 },
  'th': { cca2: 'th', colors: ['A51931', 'F4F5F8', '2D2A4A'], aspectRatio: 2 },
  'vn': { cca2: 'vn', colors: ['DA251D', 'FFFF00'], aspectRatio: 2 },
  'sg': { cca2: 'sg', colors: ['FFFFFF', 'ED2939', 'FFFFFF'], aspectRatio: 2 },
  'be': { cca2: 'be', colors: ['ED2939', 'FAE042', '000000'], aspectRatio: 2 },
  'nl': { cca2: 'nl', colors: ['21468B', 'FFFFFF', 'AE1C28'], aspectRatio: 2 },
  'ie': { cca2: 'ie', colors: ['169B62', 'FFFFFF', 'FF883E'], aspectRatio: 2 },
  'et': { cca2: 'et', colors: ['078930', 'FCDD09', 'DA121A', '0F47AF'], aspectRatio: 2 },
  'ke': { cca2: 'ke', colors: ['000000', 'BB0000', '006600'], aspectRatio: 2 },
  'tz': { cca2: 'tz', colors: ['1EB53A', '00A3DD', 'FCD116', '000000'], aspectRatio: 2 },
  'ae': { cca2: 'ae', colors: ['FF0000', '000000', 'FFFFFF', '00732F'], aspectRatio: 2 },
  'om': { cca2: 'om', colors: ['DB161B', 'FFFFFF', '008000'], aspectRatio: 2 },
  'ye': { cca2: 'ye', colors: ['CE1126', 'FFFFFF', '000000'], aspectRatio: 2 },
  'cu': { cca2: 'cu', colors: ['002A8F', 'FFFFFF', 'CF142B', 'FFFFFF'], aspectRatio: 2 },
  'cl': { cca2: 'cl', colors: ['0039A6', 'FFFFFF', 'D52B1E', 'FFFFFF'], aspectRatio: 2 },
  've': { cca2: 've', colors: ['FFCC00', '00247D', 'CF142B'], aspectRatio: 2 },
  'ch': { cca2: 'ch', colors: ['FF0000', 'FFFFFF'], aspectRatio: 1 },
  'at': { cca2: 'at', colors: ['ED2939', 'FFFFFF', 'ED2939'], aspectRatio: 2 },
  'cz': { cca2: 'cz', colors: ['D7141A', 'FFFFFF', '11457E'], aspectRatio: 2 },
  'ma': { cca2: 'ma', colors: ['C1272D', '006233'], aspectRatio: 2 },
  'tn': { cca2: 'tn', colors: ['E70013', 'FFFFFF', 'E70013'], aspectRatio: 2 },
  'dz': { cca2: 'dz', colors: ['006233', 'FFFFFF', 'D21034'], aspectRatio: 2 },
  'pk': { cca2: 'pk', colors: ['FFFFFF', '01411C', 'FFFFFF'], aspectRatio: 2 },
  'bd': { cca2: 'bd', colors: ['006A4E', 'F42A41'], aspectRatio: 2 },
  'lk': { cca2: 'lk', colors: ['FFBE29', '00534E', 'EB7400', '8D153A'], aspectRatio: 2 },
  'jm': { cca2: 'jm', colors: ['009B3A', '000000', 'FED100'], aspectRatio: 2 },
  'pe': { cca2: 'pe', colors: ['D91023', 'FFFFFF', 'D91023'], aspectRatio: 2 },
  'pa': { cca2: 'pa', colors: ['FFFFFF', 'DA121A', '072357', 'FFFFFF', '072357', 'DA121A'], aspectRatio: 2 },
  'mg': { cca2: 'mg', colors: ['FFFFFF', 'FC3D32', '007E3A'], aspectRatio: 2 },
  'so': { cca2: 'so', colors: ['4189DD', 'FFFFFF'], aspectRatio: 2 },
  'mz': { cca2: 'mz', colors: ['007168', '000000', 'FCE100', 'D21034'], aspectRatio: 2 },

  // 美国州旗
  'alabama': { cca2: 'alabama', colors: ['FFFFFF', 'B10021'], aspectRatio: 1.6 },
  'alaska': { cca2: 'alaska', colors: ['0F204B', 'FFB612'], aspectRatio: 1.6 },
  'arizona': { cca2: 'arizona', colors: ['002868', 'BB133E', 'FED700', 'CE5C17'], aspectRatio: 1.6 },
  'arkansas': { cca2: 'arkansas', colors: ['BF0A30', '002868', 'FFFFFF'], aspectRatio: 1.6 },
  'california': { cca2: 'california', colors: ['FFFFFF', 'B71234'], aspectRatio: 1.6 },
  'colorado': { cca2: 'colorado', colors: ['002868', 'FFFFFF', 'BF0A30', 'FFD700'], aspectRatio: 1.6 },
  'connecticut': { cca2: 'connecticut', colors: ['0D2897'], aspectRatio: 1.6 },
  'delaware': { cca2: 'delaware', colors: ['669CA4', 'C7A97F'], aspectRatio: 1.6 },
  'district_of_columbia': { cca2: 'district_of_columbia', colors: ['FFFFFF', 'E81B39'], aspectRatio: 1.6 },
  'florida': { cca2: 'florida', colors: ['FFFFFF', 'A80534'], aspectRatio: 1.6 },
  'georgia': { cca2: 'georgia', colors: ['B50027', 'FFFFFF', '002D56'], aspectRatio: 1.6 },
  'hawaii': { cca2: 'hawaii', colors: ['FFFFFF', 'C8102E', '012169'], aspectRatio: 1.6 },
  'idaho': { cca2: 'idaho', colors: ['003776'], aspectRatio: 1.6 },
  'illinois': { cca2: 'illinois', colors: ['FFFFFF'], aspectRatio: 1.6 },
  'indiana': { cca2: 'indiana', colors: ['000F5D', 'FFB900'], aspectRatio: 1.6 },
  'iowa': { cca2: 'iowa', colors: ['002868', 'FFFFFF', 'BF0A30'], aspectRatio: 1.6 },
  'kansas': { cca2: 'kansas', colors: ['002F6C'], aspectRatio: 1.6 },
  'kentucky': { cca2: 'kentucky', colors: ['003F87'], aspectRatio: 1.6 },
  'louisiana': { cca2: 'louisiana', colors: ['002F6C'], aspectRatio: 1.6 },
  'maine': { cca2: 'maine', colors: ['003F87'], aspectRatio: 1.6 },
  'maryland': { cca2: 'maryland', colors: ['9D2235', 'FFD200', '000000', 'FFFFFF'], aspectRatio: 1.6 },
  'massachusetts': { cca2: 'massachusetts', colors: ['FFFFFF'], aspectRatio: 1.6 },
  'michigan': { cca2: 'michigan', colors: ['00287D'], aspectRatio: 1.6 },
  'minnesota': { cca2: 'minnesota', colors: ['001F5B'], aspectRatio: 1.6 },
  'mississippi': { cca2: 'mississippi', colors: ['BF0A30', 'FFFFFF', '002868'], aspectRatio: 1.6 },
  'missouri': { cca2: 'missouri', colors: ['C8102E', 'FFFFFF', '003087'], aspectRatio: 1.6 },
  'montana': { cca2: 'montana', colors: ['003876'], aspectRatio: 1.6 },
  'nebraska': { cca2: 'nebraska', colors: ['002F6C'], aspectRatio: 1.6 },
  'nevada': { cca2: 'nevada', colors: ['003F87'], aspectRatio: 1.6 },
  'new_hampshire': { cca2: 'new_hampshire', colors: ['002F6C'], aspectRatio: 1.6 },
  'new_jersey': { cca2: 'new_jersey', colors: ['E4B872'], aspectRatio: 1.6 },
  'new_mexico': { cca2: 'new_mexico', colors: ['FFD700', 'BF0A30'], aspectRatio: 1.6 },
  'new_york': { cca2: 'new_york', colors: ['002D72'], aspectRatio: 1.6 },
  'north_carolina': { cca2: 'north_carolina', colors: ['002F65', 'BF0A30', 'FFFFFF'], aspectRatio: 1.6 },
  'north_dakota': { cca2: 'north_dakota', colors: ['002F6C'], aspectRatio: 1.6 },
  'ohio': { cca2: 'ohio', colors: ['BF0A30', 'FFFFFF', '002868'], aspectRatio: 1.6 },
  'oklahoma': { cca2: 'oklahoma', colors: ['007CB0'], aspectRatio: 1.6 },
  'oregon': { cca2: 'oregon', colors: ['002F6C'], aspectRatio: 1.6 },
  'pennsylvania': { cca2: 'pennsylvania', colors: ['002F6C'], aspectRatio: 1.6 },
  'rhode_island': { cca2: 'rhode_island', colors: ['FFFFFF'], aspectRatio: 1.6 },
  'south_carolina': { cca2: 'south_carolina', colors: ['003876', 'FFFFFF'], aspectRatio: 1.6 },
  'south_dakota': { cca2: 'south_dakota', colors: ['0047AB'], aspectRatio: 1.6 },
  'tennessee': { cca2: 'tennessee', colors: ['CC0000', 'FFFFFF', '002D62'], aspectRatio: 1.6 },
  'texas': { cca2: 'texas', colors: ['002868', 'FFFFFF', 'BF0A30'], aspectRatio: 1.6 },
  'utah': { cca2: 'utah', colors: ['002F6C'], aspectRatio: 1.6 },
  'vermont': { cca2: 'vermont', colors: ['003366'], aspectRatio: 1.6 },
  'virginia': { cca2: 'virginia', colors: ['012169', 'FFFFFF'], aspectRatio: 1.6 },
  'washington': { cca2: 'washington', colors: ['008457', 'FFD520', '34C2DE'], aspectRatio: 1.6 },
  'west_virginia': { cca2: 'west_virginia', colors: ['0A3161', 'FFFFFF'], aspectRatio: 1.6 },
  'wisconsin': { cca2: 'wisconsin', colors: ['002986', 'FFFFFF'], aspectRatio: 1.6 },
  'wyoming': { cca2: 'wyoming', colors: ['BF0A30', 'FFFFFF', '002868'], aspectRatio: 1.6 },
};

// 获取分类的关卡数据
export function getPaintCategory(categoryId: string): PaintCategory | undefined {
  return paintCategories.find(cat => cat.id === categoryId);
}

// 获取指定关卡
export function getPaintLevel(categoryId: string, levelNumber: number): PaintLevel | undefined {
  const category = getPaintCategory(categoryId);
  if (!category) return undefined;
  return category.levels.find(l => l.level === levelNumber);
}

// 获取国旗颜色信息
export function getFlagPaintInfo(code: string): FlagPaintInfo | undefined {
  return flagsColorMap[code.toLowerCase()];
}

// 获取分类的总关卡数
export function getTotalLevels(categoryId: string): number {
  const category = getPaintCategory(categoryId);
  return category ? category.levels.length : 0;
}
