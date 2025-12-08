// 猜猜关卡配置

export interface QuizLevel {
  id: number;
  name: string;
  countries: string[];  // 国家代码列表
  lives: number;
}

// 关卡数据 - 10关覆盖195个国家，前9关20个，最后一关15个
export const QuizLevels: QuizLevel[] = [
  {
    id: 1,
    name: '入门',
    countries: ['cn', 'us', 'jp', 'gb', 'fr', 'de', 'kr', 'ru', 'br', 'au', 'ca', 'it', 'es', 'in', 'mx', 'ar', 'za', 'eg', 'th', 'vn'],
    lives: 5
  },
  {
    id: 2,
    name: '初级',
    countries: ['nl', 'be', 'ch', 'se', 'no', 'dk', 'fi', 'pl', 'at', 'gr', 'pt', 'ie', 'nz', 'sg', 'my', 'id', 'ph', 'tr', 'sa', 'ae'],
    lives: 5
  },
  {
    id: 3,
    name: '进阶',
    countries: ['cz', 'hu', 'ro', 'ua', 'il', 'ng', 'ke', 'ma', 'cl', 'co', 'pe', 've', 'cu', 'pk', 'bd', 'ir', 'iq', 'qa', 'kw', 'jo'],
    lives: 4
  },
  {
    id: 4,
    name: '中级',
    countries: ['hr', 'rs', 'bg', 'sk', 'lt', 'lv', 'ee', 'by', 'ge', 'am', 'kz', 'uz', 'np', 'lk', 'mm', 'kh', 'la', 'mn', 'ec', 'bo'],
    lives: 4
  },
  {
    id: 5,
    name: '高级',
    countries: ['is', 'lu', 'mt', 'cy', 'si', 'ba', 'me', 'mk', 'al', 'md', 'az', 'tm', 'kg', 'tj', 'af', 'sy', 'lb', 'ye', 'om', 'bh'],
    lives: 3
  },
  {
    id: 6,
    name: '专家',
    countries: ['py', 'uy', 'gy', 'sr', 'gt', 'hn', 'sv', 'ni', 'cr', 'pa', 'bz', 'ht', 'do', 'jm', 'tt', 'bb', 'bs', 'et', 'gh', 'tz'],
    lives: 3
  },
  {
    id: 7,
    name: '大师',
    countries: ['ug', 'dz', 'tn', 'ly', 'sd', 'ss', 'ao', 'mz', 'zw', 'zm', 'bw', 'na', 'sn', 'ci', 'cm', 'cd', 'cg', 'rw', 'mg', 'mu'],
    lives: 3
  },
  {
    id: 8,
    name: '精英',
    countries: ['ml', 'bf', 'ne', 'td', 'mr', 'gm', 'gn', 'gw', 'sl', 'lr', 'tg', 'bj', 'ga', 'gq', 'cf', 'bi', 'er', 'dj', 'so', 'km'],
    lives: 3
  },
  {
    id: 9,
    name: '学者',
    countries: ['cv', 'st', 'mw', 'ls', 'sz', 'sc', 'fj', 'pg', 'sb', 'vu', 'ws', 'to', 'ki', 'fm', 'mh', 'pw', 'nr', 'tv', 'kp', 'bt'],
    lives: 3
  },
  {
    id: 10,
    name: '博士',
    countries: ['mv', 'bn', 'tl', 'ps', 'li', 'mc', 'sm', 'va', 'ad', 'dm', 'gd', 'lc', 'vc', 'kn', 'ag'],
    lives: 3
  }
];

// 获取关卡
export function getQuizLevel(levelId: number): QuizLevel | undefined {
  return QuizLevels.find(level => level.id === levelId);
}

// 获取所有关卡
export function getAllQuizLevels(): QuizLevel[] {
  return QuizLevels;
}
