// 专题数据配置

export interface TopicItem {
  id: string;
  name: string;
  description: string;
  emoji: string;
  countryCodes: string[];
}

export const topics: TopicItem[] = [
  // 文字类专题（排在前面）
  {
    id: 'vexillology',
    name: '旗帜学',
    description: '旗帜学（国旗学）的基础知识、研究方法和历史演变',
    emoji: '📚',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'etiquette',
    name: '国旗礼仪',
    description: '国旗在国际场合的使用规范和礼仪知识',
    emoji: '🎖️',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'manufacturing',
    name: '国旗制作',
    description: '国旗制作的流程、材料、工厂和质量标准',
    emoji: '🏭',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'flag-history',
    name: '五星红旗历史',
    description: '五星红旗的设计背景、历史演变、法律地位和文化意义',
    emoji: '🇨🇳',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'similar-flags',
    name: '相似旗',
    description: '一些国家的国旗相似度较高，仅在比例、颜色深度或细节上有所不同',
    emoji: '🔀',
    countryCodes: ['mc', 'id', 'nl', 'lu', 'ro', 'td', 'cn', 'vn', 'ke', 'ss', 'ad', 'md', 'ir', 'tj', 'ie', 'ci'] // 摩纳哥、印尼、荷兰、卢森堡、罗马尼亚、乍得、中国、越南、肯尼亚、南苏丹、安道尔、摩尔多瓦、伊朗、塔吉克斯坦、爱尔兰、科特迪瓦
  },
  {
    id: 'international',
    name: '国际组织',
    description: '主要国际组织的旗帜',
    emoji: '🌐',
    countryCodes: ['un', 'eu', 'olympic', 'nato', 'asean', 'au_org', 'arab_league', 'red_cross', 'fiav']
  },
  // 其他专题
  {
    id: 'nordic',
    name: '北欧旗帜',
    description: '以北欧十字为特征的斯堪的纳维亚国家旗帜',
    emoji: '🇩🇰',
    countryCodes: ['dk', 'se', 'no', 'fi', 'is']
  },
  {
    id: 'tricolor',
    name: '三色旗',
    description: '由三种颜色条纹组成的经典国旗设计',
    emoji: '🇫🇷',
    countryCodes: ['fr', 'it', 'de', 'be', 'nl', 'ie', 'ru', 'hu', 'ro', 'bg', 'lt', 'ee', 'lv', 'at', 'lu', 'mc', 'ml', 'td', 'ci', 'gn', 'ng', 'cm', 'sn', 'ne']
  },
  {
    id: 'pan-arab',
    name: '泛阿拉伯旗帜',
    description: '采用红、白、黑、绿泛阿拉伯色彩的国旗',
    emoji: '🇵🇸',
    countryCodes: ['jo', 'ps', 'ae', 'kw', 'sd', 'sy', 'iq', 'ye', 'eg', 'ly']
  },
  {
    id: 'pan-african',
    name: '泛非洲旗帜',
    description: '采用红、黄、绿泛非洲色彩的国旗',
    emoji: '🌍',
    countryCodes: ['et', 'gh', 'gn', 'ml', 'sn', 'bf', 'bj', 'tg', 'cm', 'cg', 'cf', 'rw', 'zm', 'zw', 'mz', 'ke', 'tz', 'ug']
  },
  {
    id: 'sun',
    name: '太阳旗',
    description: '国旗上绘有太阳图案的国家',
    emoji: '☀️',
    countryCodes: ['jp', 'bd', 'pw', 'ki', 'kz', 'kg', 'mw', 'na', 'ar', 'ag']
  },
  {
    id: 'crescent-moon',
    name: '星月旗',
    description: '国旗上绘有星月标志的国家',
    emoji: '🌙',
    countryCodes: ['tr', 'pk', 'my', 'sg', 'dz', 'tn', 'mr', 'az', 'km', 'mv', 'ly', 'uz']
  },
  {
    id: 'blue-ensign',
    name: '蓝船旗',
    description: '来自英国的民用船旗蓝船旗，米字旗代表前英国殖民地，象征为英联邦成员',
    emoji: '🚢',
    countryCodes: ['au', 'nz', 'fj', 'tv'] // 澳大利亚、新西兰、斐济、图瓦卢
  },
  {
    id: 'pan-slavic',
    name: '泛斯拉夫旗',
    description: '采用红、白、蓝泛斯拉夫色彩的国旗，代表斯拉夫民族的团结',
    emoji: '🇷🇺',
    countryCodes: ['ru', 'rs', 'sk', 'si', 'hr', 'cz'] // 俄罗斯、塞尔维亚、斯洛伐克、斯洛文尼亚、克罗地亚、捷克
  },
  {
    id: 'central-america',
    name: '泛中美洲联邦色旗',
    description: '中美洲联邦国旗，蓝色代表加勒比海和太平洋，白色代表和平，很多前中美洲联邦共和国的成员国采用',
    emoji: '🇬🇹',
    countryCodes: ['sv', 'hn', 'ni'] // 萨尔瓦多、洪都拉斯、尼加拉瓜
  },
  {
    id: 'miranda',
    name: '泛米兰达色旗',
    description: '该旗为弗朗西斯科·德·米兰达于南美独立运动所用的旗帜，其中红色是南美洲，黄色是西班牙，蓝色是海。后为前大哥伦比亚共和国的会员国采用',
    emoji: '🇨🇴',
    countryCodes: ['co', 've', 'ec'] // 哥伦比亚、委内瑞拉、厄瓜多尔
  },
  {
    id: 'animals',
    name: '国旗上的动物',
    description: '国旗上绘有动物图案的国家',
    emoji: '🦁',
    countryCodes: ['al', 'bt', 'lk', 'pg', 'zm', 'zw', 'ug', 'ec', 'es', 'kz', 'mx', 'rs', 'me', 'eg']
  }
];

export function getTopicById(id: string): TopicItem | undefined {
  return topics.find(t => t.id === id);
}

export function getAllTopics(): TopicItem[] {
  return topics;
}

