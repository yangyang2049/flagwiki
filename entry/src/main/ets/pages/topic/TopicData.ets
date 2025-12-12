// 专题数据配置

export interface TopicItem {
  id: string;
  name: string;          // 中文名称
  nameEN: string;        // 英文名称
  description: string;   // 中文描述
  descriptionEN: string; // 英文描述
  emoji: string;
  countryCodes: string[];
}

export const topics: TopicItem[] = [
  // 文字类专题（排在前面）
  {
    id: 'vexillology',
    name: '旗帜学',
    nameEN: 'Vexillology',
    description: '旗帜学（国旗学）的基础知识、研究方法和历史演变',
    descriptionEN: 'Basic knowledge, research methods, and historical evolution of vexillology (flag studies)',
    emoji: '📚',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'etiquette',
    name: '国旗礼仪',
    nameEN: 'Flag Etiquette',
    description: '国旗在国际场合的使用规范和礼仪知识',
    descriptionEN: 'Usage standards and etiquette knowledge of national flags in international occasions',
    emoji: '🎖️',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'manufacturing',
    name: '国旗制作',
    nameEN: 'Flag Manufacturing',
    description: '国旗制作的流程、材料、工厂和质量标准',
    descriptionEN: 'Processes, materials, factories, and quality standards for flag manufacturing',
    emoji: '🏭',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'flag-history',
    name: '五星红旗历史',
    nameEN: 'Five-Star Red Flag History',
    description: '五星红旗的设计背景、历史演变、法律地位和文化意义',
    descriptionEN: 'Design background, historical evolution, legal status, and cultural significance of the Five-Star Red Flag',
    emoji: '🇨🇳',
    countryCodes: [] // 空数组表示这是知识性专题
  },
  {
    id: 'similar-flags',
    name: '相似旗',
    nameEN: 'Similar Flags',
    description: '一些国家的国旗相似度较高，仅在比例、颜色深度或细节上有所不同',
    descriptionEN: 'Some countries have flags with high similarity, differing only in proportion, color depth, or details',
    emoji: '🔀',
    countryCodes: ['mc', 'id', 'nl', 'lu', 'ro', 'td', 'cn', 'vn', 'ke', 'ss', 'ad', 'md', 'ir', 'tj', 'ie', 'ci'] // 摩纳哥、印尼、荷兰、卢森堡、罗马尼亚、乍得、中国、越南、肯尼亚、南苏丹、安道尔、摩尔多瓦、伊朗、塔吉克斯坦、爱尔兰、科特迪瓦
  },
  {
    id: 'international',
    name: '国际组织',
    nameEN: 'International Organizations',
    description: '主要国际组织的旗帜',
    descriptionEN: 'Flags of major international organizations',
    emoji: '🌐',
    countryCodes: ['un', 'eu', 'olympic', 'nato', 'asean', 'au_org', 'arab_league', 'red_cross', 'fiav']
  },
  // 其他专题
  {
    id: 'nordic',
    name: '北欧旗帜',
    nameEN: 'Nordic Flags',
    description: '以北欧十字为特征的斯堪的纳维亚国家旗帜',
    descriptionEN: 'Scandinavian national flags featuring the Nordic cross',
    emoji: '🇩🇰',
    countryCodes: ['dk', 'se', 'no', 'fi', 'is']
  },
  {
    id: 'tricolor',
    name: '三色旗',
    nameEN: 'Tricolor Flags',
    description: '由三种颜色条纹组成的经典国旗设计',
    descriptionEN: 'Classic national flag design with three colored stripes',
    emoji: '🇫🇷',
    countryCodes: ['fr', 'it', 'de', 'be', 'nl', 'ie', 'ru', 'hu', 'ro', 'bg', 'lt', 'ee', 'lv', 'at', 'lu', 'mc', 'ml', 'td', 'ci', 'gn', 'ng', 'cm', 'sn', 'ne']
  },
  {
    id: 'pan-arab',
    name: '泛阿拉伯旗帜',
    nameEN: 'Pan-Arab Flags',
    description: '采用红、白、黑、绿泛阿拉伯色彩的国旗',
    descriptionEN: 'National flags using pan-Arab colors: red, white, black, and green',
    emoji: '🇵🇸',
    countryCodes: ['jo', 'ps', 'ae', 'kw', 'sd', 'sy', 'iq', 'ye', 'eg', 'ly']
  },
  {
    id: 'pan-african',
    name: '泛非洲旗帜',
    nameEN: 'Pan-African Flags',
    description: '采用红、黄、绿泛非洲色彩的国旗',
    descriptionEN: 'National flags using pan-African colors: red, yellow, and green',
    emoji: '🌍',
    countryCodes: ['et', 'gh', 'gn', 'ml', 'sn', 'bf', 'bj', 'tg', 'cm', 'cg', 'cf', 'rw', 'zm', 'zw', 'mz', 'ke', 'tz', 'ug']
  },
  {
    id: 'sun',
    name: '太阳旗',
    nameEN: 'Sun Flags',
    description: '国旗上绘有太阳图案的国家',
    descriptionEN: 'Countries with sun symbols on their flags',
    emoji: '☀️',
    countryCodes: ['jp', 'bd', 'pw', 'ki', 'kz', 'kg', 'mw', 'na', 'ar', 'ag']
  },
  {
    id: 'crescent-moon',
    name: '星月旗',
    nameEN: 'Crescent and Star Flags',
    description: '国旗上绘有星月标志的国家',
    descriptionEN: 'Countries with crescent and star symbols on their flags',
    emoji: '🌙',
    countryCodes: ['tr', 'pk', 'my', 'sg', 'dz', 'tn', 'mr', 'az', 'km', 'mv', 'ly', 'uz']
  },
  {
    id: 'blue-ensign',
    name: '蓝船旗',
    nameEN: 'Blue Ensign',
    description: '来自英国的民用船旗蓝船旗，米字旗代表前英国殖民地，象征为英联邦成员',
    descriptionEN: 'Derived from the British Blue Ensign, the Union Jack represents former British colonies, symbolizing Commonwealth membership',
    emoji: '🚢',
    countryCodes: ['au', 'nz', 'fj', 'tv'] // 澳大利亚、新西兰、斐济、图瓦卢
  },
  {
    id: 'pan-slavic',
    name: '泛斯拉夫旗',
    nameEN: 'Pan-Slavic Flags',
    description: '采用红、白、蓝泛斯拉夫色彩的国旗，代表斯拉夫民族的团结',
    descriptionEN: 'National flags using pan-Slavic colors: red, white, and blue, representing Slavic unity',
    emoji: '🇷🇺',
    countryCodes: ['ru', 'rs', 'sk', 'si', 'hr', 'cz'] // 俄罗斯、塞尔维亚、斯洛伐克、斯洛文尼亚、克罗地亚、捷克
  },
  {
    id: 'central-america',
    name: '泛中美洲联邦色旗',
    nameEN: 'Central American Federation Colors',
    description: '中美洲联邦国旗，蓝色代表加勒比海和太平洋，白色代表和平，很多前中美洲联邦共和国的成员国采用',
    descriptionEN: 'Central American Federation flag, with blue representing the Caribbean and Pacific, white representing peace, adopted by many former member states of the Central American Republic',
    emoji: '🇬🇹',
    countryCodes: ['sv', 'hn', 'ni'] // 萨尔瓦多、洪都拉斯、尼加拉瓜
  },
  {
    id: 'miranda',
    name: '泛米兰达色旗',
    nameEN: 'Miranda Colors',
    description: '该旗为弗朗西斯科·德·米兰达于南美独立运动所用的旗帜，其中红色是南美洲，黄色是西班牙，蓝色是海。后为前大哥伦比亚共和国的会员国采用',
    descriptionEN: 'Flag used by Francisco de Miranda during the South American independence movement, with red representing South America, yellow representing Spain, and blue representing the sea. Later adopted by former member states of Gran Colombia',
    emoji: '🇨🇴',
    countryCodes: ['co', 've', 'ec'] // 哥伦比亚、委内瑞拉、厄瓜多尔
  },
  {
    id: 'animals',
    name: '国旗上的动物',
    nameEN: 'Animals on Flags',
    description: '国旗上绘有动物图案的国家',
    descriptionEN: 'Countries with animal symbols on their flags',
    emoji: '🦁',
    countryCodes: ['al', 'bt', 'lk', 'pg', 'zm', 'zw', 'ug', 'ec', 'es', 'kz', 'mx', 'rs', 'me', 'eg']
  }
];

export function getTopicById(id: string): TopicItem | undefined {
  return topics.find(t => t.id === id);
}

export function getAllTopics(language?: string): TopicItem[] {
  // 在英文环境下，过滤掉五星红旗历史专题
  if (language === 'en' || (language && language.startsWith('en-'))) {
    return topics.filter(topic => topic.id !== 'flag-history');
  }
  return topics;
}

// 本地化工具函数：根据语言获取专题名称
export function getLocalizedTopicName(topic: TopicItem, language: string): string {
  // 五星红旗历史专题始终显示中文
  if (topic.id === 'flag-history') {
    return topic.name;
  }
  
  if (!language) {
    return topic.name;
  }
  if (language === 'en') {
    return topic.nameEN;
  }
  // 检查是否以 'en-' 开头
  if (language.length > 3 && language.substring(0, 3) === 'en-') {
    return topic.nameEN;
  }
  return topic.name;
}

// 本地化工具函数：根据语言获取专题描述
export function getLocalizedTopicDescription(topic: TopicItem, language: string): string {
  // 五星红旗历史专题始终显示中文
  if (topic.id === 'flag-history') {
    return topic.description;
  }
  
  if (!language) {
    return topic.description;
  }
  if (language === 'en') {
    return topic.descriptionEN;
  }
  // 检查是否以 'en-' 开头
  if (language.length > 3 && language.substring(0, 3) === 'en-') {
    return topic.descriptionEN;
  }
  return topic.description;
}

