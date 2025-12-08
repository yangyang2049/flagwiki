// 专题数据配置

export interface TopicItem {
  id: string;
  name: string;
  description: string;
  emoji: string;
  countryCodes: string[];
}

export const topics: TopicItem[] = [
  {
    id: 'nordic',
    name: '北欧旗帜',
    description: '以北欧十字为特征的斯堪的纳维亚国家旗帜',
    emoji: '🇩🇰',
    countryCodes: ['dk', 'se', 'no', 'fi', 'is', 'fo', 'ax']
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
    id: 'animals',
    name: '国旗上的动物',
    description: '国旗上绘有动物图案的国家',
    emoji: '🦁',
    countryCodes: ['al', 'bt', 'mx', 'lk', 'pg', 'zm', 'zw', 'ug', 'ec', 'bo', 'py', 'pe', 'es', 'kz']
  },
  {
    id: 'international',
    name: '国际组织',
    description: '主要国际组织的旗帜',
    emoji: '🌐',
    countryCodes: ['un', 'eu', 'olympic', 'nato', 'asean', 'au_org', 'arab_league', 'red_cross']
  }
];

export function getTopicById(id: string): TopicItem | undefined {
  return topics.find(t => t.id === id);
}

export function getAllTopics(): TopicItem[] {
  return topics;
}

