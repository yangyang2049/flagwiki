// 假旗找茬关卡配置

export type FakeType = 'wrongFlag' | 'flipX' | 'flipY';

export interface FakeFlagQuestion {
  countryCodes: string[];      // 4个国家代码
  fakeCountryCode: string;     // 假旗对应的国家
  fakeFlagAssetPath: string;   // 假旗使用的资源（如果是wrongFlag则是另一个国家代码）
  fakeType: FakeType;          // 假旗类型
}

export interface FakeFlagLevel {
  id: number;
  name: string;
  questions: FakeFlagQuestion[];
  lives: number;
}

// 关卡数据 - 10关
export const FakeFlagLevels: FakeFlagLevel[] = [
  {
    id: 1,
    name: '入门',
    questions: [
      { countryCodes: ['fr', 'de', 'it', 'es'], fakeCountryCode: 'fr', fakeFlagAssetPath: 'nl', fakeType: 'wrongFlag' },
      { countryCodes: ['jp', 'kr', 'cn', 'vn'], fakeCountryCode: 'kr', fakeFlagAssetPath: 'kr', fakeType: 'flipX' },
      { countryCodes: ['gb', 'us', 'ca', 'au'], fakeCountryCode: 'au', fakeFlagAssetPath: 'nz', fakeType: 'wrongFlag' },
      { countryCodes: ['br', 'ar', 'mx', 'cl'], fakeCountryCode: 'cl', fakeFlagAssetPath: 'pa', fakeType: 'wrongFlag' },
      { countryCodes: ['in', 'pk', 'bd', 'np'], fakeCountryCode: 'in', fakeFlagAssetPath: 'in', fakeType: 'flipY' }
    ],
    lives: 3
  },
  {
    id: 2,
    name: '初级',
    questions: [
      { countryCodes: ['se', 'no', 'dk', 'fi'], fakeCountryCode: 'no', fakeFlagAssetPath: 'is', fakeType: 'wrongFlag' },
      { countryCodes: ['ae', 'kw', 'jo', 'sd'], fakeCountryCode: 'jo', fakeFlagAssetPath: 'ps', fakeType: 'wrongFlag' },
      { countryCodes: ['sy', 'eg', 'ye', 'iq'], fakeCountryCode: 'iq', fakeFlagAssetPath: 'iq', fakeType: 'flipX' },
      { countryCodes: ['sg', 'id', 'mc', 'pl'], fakeCountryCode: 'mc', fakeFlagAssetPath: 'mc', fakeType: 'flipY' },
      { countryCodes: ['lb', 'pe', 'at', 'ca'], fakeCountryCode: 'lb', fakeFlagAssetPath: 'lb', fakeType: 'flipX' }
    ],
    lives: 3
  },
  {
    id: 3,
    name: '进阶',
    questions: [
      { countryCodes: ['ae', 'qa', 'om', 'sa'], fakeCountryCode: 'qa', fakeFlagAssetPath: 'bh', fakeType: 'wrongFlag' },
      { countryCodes: ['za', 'zw', 'ls', 'sz'], fakeCountryCode: 'sz', fakeFlagAssetPath: 'sz', fakeType: 'flipX' },
      { countryCodes: ['de', 'be', 'ci', 'ie'], fakeCountryCode: 'be', fakeFlagAssetPath: 'be', fakeType: 'flipX' },
      { countryCodes: ['ro', 'td', 'md', 'ad'], fakeCountryCode: 'md', fakeFlagAssetPath: 'md', fakeType: 'flipX' },
      { countryCodes: ['mr', 'mv', 'mg', 'ml'], fakeCountryCode: 'mv', fakeFlagAssetPath: 'mv', fakeType: 'flipX' }
    ],
    lives: 3
  },
  {
    id: 4,
    name: '中级',
    questions: [
      { countryCodes: ['ma', 'dz', 'tn', 'ly'], fakeCountryCode: 'ma', fakeFlagAssetPath: 'so', fakeType: 'wrongFlag' },
      { countryCodes: ['ke', 'tz', 'ug', 'rw'], fakeCountryCode: 'rw', fakeFlagAssetPath: 'rw', fakeType: 'flipX' },
      { countryCodes: ['pt', 'fr', 'it', 'gb'], fakeCountryCode: 'gb', fakeFlagAssetPath: 'gb', fakeType: 'flipY' },
      { countryCodes: ['sn', 'ml', 'gn', 'cm'], fakeCountryCode: 'cm', fakeFlagAssetPath: 'cm', fakeType: 'flipX' },
      { countryCodes: ['pl', 'ua', 'by', 'ro'], fakeCountryCode: 'ua', fakeFlagAssetPath: 'ua', fakeType: 'flipY' }
    ],
    lives: 3
  },
  {
    id: 5,
    name: '高级',
    questions: [
      { countryCodes: ['tt', 'kn', 'tz', 'cd'], fakeCountryCode: 'tt', fakeFlagAssetPath: 'tt', fakeType: 'flipX' },
      { countryCodes: ['kg', 'mz', 'np', 'va'], fakeCountryCode: 'va', fakeFlagAssetPath: 'va', fakeType: 'flipX' },
      { countryCodes: ['ir', 'mx', 'it', 'bg'], fakeCountryCode: 'bg', fakeFlagAssetPath: 'bg', fakeType: 'flipY' },
      { countryCodes: ['tj', 'in', 'ne', 'hu'], fakeCountryCode: 'hu', fakeFlagAssetPath: 'hu', fakeType: 'flipY' },
      { countryCodes: ['ke', 'tz', 'ug', 'rw'], fakeCountryCode: 'ke', fakeFlagAssetPath: 'et', fakeType: 'wrongFlag' }
    ],
    lives: 3
  },
  {
    id: 6,
    name: '专家',
    questions: [
      { countryCodes: ['ee', 'gm', 'bw', 'fi'], fakeCountryCode: 'ee', fakeFlagAssetPath: 'ee', fakeType: 'flipY' },
      { countryCodes: ['mz', 'na', 'bw', 'zw'], fakeCountryCode: 'mz', fakeFlagAssetPath: 'ao', fakeType: 'wrongFlag' },
      { countryCodes: ['th', 'vn', 'id', 'ph'], fakeCountryCode: 'th', fakeFlagAssetPath: 'my', fakeType: 'wrongFlag' },
      { countryCodes: ['ie', 'ci', 'mx', 'it'], fakeCountryCode: 'ie', fakeFlagAssetPath: 'ie', fakeType: 'flipX' },
      { countryCodes: ['sb', 'vu', 'fj', 'pg'], fakeCountryCode: 'vu', fakeFlagAssetPath: 'vu', fakeType: 'flipY' }
    ],
    lives: 3
  },
  {
    id: 7,
    name: '大师',
    questions: [
      { countryCodes: ['jm', 'bb', 'tt', 'gd'], fakeCountryCode: 'jm', fakeFlagAssetPath: 'ht', fakeType: 'wrongFlag' },
      { countryCodes: ['dj', 'ly', 'so', 'er'], fakeCountryCode: 'dj', fakeFlagAssetPath: 'dj', fakeType: 'flipY' },
      { countryCodes: ['ws', 'to', 'tv', 'fj'], fakeCountryCode: 'to', fakeFlagAssetPath: 'to', fakeType: 'flipX' },
      { countryCodes: ['za', 'bw', 'zw', 'ls'], fakeCountryCode: 'za', fakeFlagAssetPath: 'za', fakeType: 'flipY' },
      { countryCodes: ['gq', 'st', 'cv', 'ao'], fakeCountryCode: 'st', fakeFlagAssetPath: 'st', fakeType: 'flipY' }
    ],
    lives: 3
  },
  {
    id: 8,
    name: '精英',
    questions: [
      { countryCodes: ['kz', 'uz', 'tm', 'tj'], fakeCountryCode: 'kz', fakeFlagAssetPath: 'kg', fakeType: 'wrongFlag' },
      { countryCodes: ['fm', 'pw', 'mh', 'ki'], fakeCountryCode: 'fm', fakeFlagAssetPath: 'to', fakeType: 'wrongFlag' },
      { countryCodes: ['lc', 'gy', 'kg', 'fj'], fakeCountryCode: 'lc', fakeFlagAssetPath: 'sm', fakeType: 'wrongFlag' },
      { countryCodes: ['cv', 'nr', 'mh', 'tv'], fakeCountryCode: 'nr', fakeFlagAssetPath: 'nr', fakeType: 'flipY' },
      { countryCodes: ['sn', 'cm', 'gh', 'bf'], fakeCountryCode: 'bf', fakeFlagAssetPath: 'gw', fakeType: 'wrongFlag' }
    ],
    lives: 3
  },
  {
    id: 9,
    name: '学者',
    questions: [
      { countryCodes: ['pt', 'br', 'ao', 'cv'], fakeCountryCode: 'pt', fakeFlagAssetPath: 'pt', fakeType: 'flipY' },
      { countryCodes: ['dm', 'gd', 'vc', 'kn'], fakeCountryCode: 'dm', fakeFlagAssetPath: 'dm', fakeType: 'flipX' },
      { countryCodes: ['ag', 'gd', 'lc', 'vc'], fakeCountryCode: 'vc', fakeFlagAssetPath: 'vc', fakeType: 'flipX' },
      { countryCodes: ['om', 'ae', 'kw', 'qa'], fakeCountryCode: 'om', fakeFlagAssetPath: 'ir', fakeType: 'wrongFlag' },
      { countryCodes: ['tz', 'fi', 'mx', 'th'], fakeCountryCode: 'tz', fakeFlagAssetPath: 'tz', fakeType: 'flipY' }
    ],
    lives: 3
  },
  {
    id: 10,
    name: '博士',
    questions: [
      { countryCodes: ['ye', 'ng', 'ru', 'vn'], fakeCountryCode: 'ye', fakeFlagAssetPath: 'ye', fakeType: 'flipY' },
      { countryCodes: ['mu', 'sc', 'km', 'mg'], fakeCountryCode: 'mu', fakeFlagAssetPath: 'ga', fakeType: 'wrongFlag' },
      { countryCodes: ['al', 'me', 'mk', 'rs'], fakeCountryCode: 'al', fakeFlagAssetPath: 'al', fakeType: 'flipX' },
      { countryCodes: ['bs', 'bb', 'cu', 'ht'], fakeCountryCode: 'bs', fakeFlagAssetPath: 'bs', fakeType: 'flipY' },
      { countryCodes: ['nz', 'ma', 'cl', 'kr'], fakeCountryCode: 'nz', fakeFlagAssetPath: 'au', fakeType: 'wrongFlag' }
    ],
    lives: 3
  }
];

// 获取关卡
export function getFakeFlagLevel(levelId: number): FakeFlagLevel | undefined {
  return FakeFlagLevels.find(level => level.id === levelId);
}

// 获取所有关卡
export function getAllFakeFlagLevels(): FakeFlagLevel[] {
  return FakeFlagLevels;
}

