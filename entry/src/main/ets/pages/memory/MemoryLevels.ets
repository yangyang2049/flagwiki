// 国旗记忆翻牌关卡配置

export interface MemoryLevel {
  id: number;
  name: string;
  pairs: number;        // 配对数量
  columns: number;      // 列数 (2-4)
  countries: string[];  // 国家代码列表
  timeLimit: number;    // 时间限制(秒)，0表示无限制
}

// 关卡数据 - 10关
// 布局规则：pairs * 2 = 总卡片数，需要能被 columns 整除形成整齐网格
export const MemoryLevels: MemoryLevel[] = [
  {
    id: 1,
    name: '入门',
    pairs: 4,
    columns: 2,  // 8张卡片 = 2列 x 4行
    countries: ['cn', 'us', 'jp', 'gb'],
    timeLimit: 0
  },
  {
    id: 2,
    name: '初级',
    pairs: 6,
    columns: 3,  // 12张卡片 = 3列 x 4行
    countries: ['cn', 'us', 'jp', 'gb', 'fr', 'de'],
    timeLimit: 0
  },
  {
    id: 3,
    name: '进阶',
    pairs: 8,
    columns: 4,  // 16张卡片 = 4列 x 4行
    countries: ['cn', 'us', 'jp', 'gb', 'fr', 'de', 'kr', 'ru'],
    timeLimit: 0
  },
  {
    id: 4,
    name: '中级',
    pairs: 8,
    columns: 4,  // 16张卡片 = 4列 x 4行
    countries: ['br', 'au', 'ca', 'it', 'es', 'in', 'mx', 'ar'],
    timeLimit: 120
  },
  {
    id: 5,
    name: '高级',
    pairs: 10,
    columns: 4,  // 20张卡片 = 4列 x 5行
    countries: ['nl', 'be', 'ch', 'se', 'no', 'dk', 'fi', 'pl', 'at', 'gr'],
    timeLimit: 120
  },
  {
    id: 6,
    name: '专家',
    pairs: 10,
    columns: 4,  // 20张卡片 = 4列 x 5行
    countries: ['pt', 'ie', 'nz', 'sg', 'my', 'id', 'ph', 'tr', 'sa', 'ae'],
    timeLimit: 100
  },
  {
    id: 7,
    name: '大师',
    pairs: 12,
    columns: 4,  // 24张卡片 = 4列 x 6行
    countries: ['cz', 'hu', 'ro', 'ua', 'il', 'ng', 'ke', 'ma', 'cl', 'co', 'pe', 've'],
    timeLimit: 100
  },
  {
    id: 8,
    name: '精英',
    pairs: 12,
    columns: 4,  // 24张卡片 = 4列 x 6行
    countries: ['hr', 'rs', 'bg', 'sk', 'lt', 'lv', 'ee', 'by', 'ge', 'am', 'kz', 'uz'],
    timeLimit: 90
  },
  {
    id: 9,
    name: '学者',
    pairs: 15,
    columns: 5,  // 30张卡片 = 5列 x 6行
    countries: ['np', 'lk', 'mm', 'kh', 'la', 'mn', 'ec', 'bo', 'py', 'uy', 'gy', 'sr', 'gt', 'hn', 'sv'],
    timeLimit: 90
  },
  {
    id: 10,
    name: '博士',
    pairs: 18,
    columns: 6,  // 36张卡片 = 6列 x 6行
    countries: ['fj', 'pg', 'sb', 'vu', 'ws', 'to', 'ki', 'fm', 'mh', 'pw', 'nr', 'tv', 'mv', 'bn', 'tl', 'bt', 'li', 'mc'],
    timeLimit: 120
  }
];

// 获取关卡
export function getMemoryLevel(levelId: number): MemoryLevel | undefined {
  return MemoryLevels.find(level => level.id === levelId);
}

// 获取所有关卡
export function getAllMemoryLevels(): MemoryLevel[] {
  return MemoryLevels;
}

