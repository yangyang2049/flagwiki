// 输入游戏关卡配置 - 39关，共195个国家
export const inputGameLevels: string[][] = [
  ['us', 'cn', 'jp', 'de', 'fr'], // Level 1
  ['gb', 'in', 'it', 'ru', 'ca'], // Level 2
  ['kr', 'es', 'br', 'mx', 'au'], // Level 3
  ['pl', 'nl', 'tr', 'id', 'hu'], // Level 4
  ['se', 'ch', 'at', 'ro', 'za'], // Level 5
  ['ua', 'ir', 'th', 'no', 'ar'], // Level 6
  ['sa', 'dk', 'eg', 'be', 'ng'], // Level 7
  ['gr', 'fi', 'cz', 'bg', 'cu'], // Level 8
  ['ke', 'kz', 'et', 'co', 'ph'], // Level 9
  ['by', 'ma', 'uz', 'nz', 'hr'], // Level 10
  ['my', 'vn', 'pt', 'ie', 'sk'], // Level 11
  ['il', 'ae', 'az', 'cl', 'sg'], // Level 12
  ['jm', 'tn', 'ge', 'dz', 'ug'], // Level 13
  ['do', 'qa', 'si', 'pe', 'lt'], // Level 14
  ['rs', 'lv', 'ee', 'am', 'zw'], // Level 15
  ['pk', 'gh', 'kg', 'ec', 'cm'], // Level 16
  ['mn', 'bd', 'kw', 'uy', 'jo'], // Level 17
  ['mz', 'kh', 'mm', 'lk', 'cr'], // Level 18
  ['zm', 'tj', 'lb', 'bs', 'bh'], // Level 19
  ['pa', 'kp', 'gt', 'ht', 'np'], // Level 20
  ['sd', 'na', 'mw', 'ne', 'is'], // Level 21
  ['py', 'rw', 'hn', 'ao', 'mg'], // Level 22
  ['sv', 'iq', 'om', 'sn', 'al'], // Level 23
  ['ml', 've', 'ni', 'fj', 'bf'], // Level 24
  ['bj', 'bi', 'va', 'bw', 'tg'], // Level 25
  ['lu', 'mk', 'td', 'pg', 'ls'], // Level 26
  ['gm', 'cy', 'sl', 'mu', 'gn'], // Level 27
  ['sz', 'cf', 'ci', 'tz', 'ye'], // Level 28
  ['mt', 'me', 'sy', 'cd', 'bz'], // Level 29
  ['mv', 'af', 'tt', 'ps', 'gd'], // Level 30
  ['gy', 'dj', 'ad', 'bb', 'bt'], // Level 31
  ['sr', 'gw', 'sm', 'ly', 'li'], // Level 32
  ['lc', 'md', 'vu', 'so', 'mc'], // Level 33
  ['km', 'ss', 'bo', 'sb', 'ws'], // Level 34
  ['sc', 'la', 'cg', 'tm', 'dm'], // Level 35
  ['lr', 'mr', 'er', 'ba', 'to'], // Level 36
  ['ga', 'gq', 'ki', 'pw', 'cv'], // Level 37
  ['bn', 'st', 'mh', 'vc', 'fm'], // Level 38
  ['ag', 'nr', 'kn', 'tl', 'tv'], // Level 39
];

export interface InputGameLevel {
  id: number;
  name: string;
  countries: string[];
  lives: number;
}

export function getInputGameLevel(levelId: number): InputGameLevel | undefined {
  if (levelId < 1 || levelId > inputGameLevels.length) {
    return undefined;
  }
  return {
    id: levelId,
    name: `第 ${levelId} 关`,
    countries: inputGameLevels[levelId - 1],
    lives: 3
  };
}

export function getTotalInputLevels(): number {
  return inputGameLevels.length;
}
