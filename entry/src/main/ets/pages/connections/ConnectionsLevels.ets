// Connections 游戏关卡配置

import { common } from '@kit.AbilityKit';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

export interface FlagTile {
  countryCode: string;
}

export interface FlagGroup {
  countryCodes: string[];
  theme: string;
  isSolved: boolean;
  solvedAt?: number; // 解决时间戳
}

export interface ConnectionsLevel {
  id: number;
  name: string;
  flags: FlagTile[];
  groups: FlagGroup[];
}

// 主题名称映射（中文）
const ThemeNamesCN: Record<string, string> = {
  'Asia': '亚洲',
  'Europe': '欧洲',
  'Americas': '美洲',
  'Africa': '非洲',
  'Red Flags': '红色旗帜',
  'Green Flags': '绿色旗帜',
  'Blue Flags': '蓝色旗帜',
  'Yellow Flags': '黄色旗帜',
  'Anglo-Saxon Flags': '盎格鲁-撒克逊旗帜',
  'Slavic Flags': '斯拉夫旗帜',
  'Nordic Flags': '北欧旗帜',
  'Arab Flags': '阿拉伯旗帜',
  'East Asia': '东亚',
  'South Asia': '南亚',
  'West Asia': '西亚',
  'Southeast Asia': '东南亚',
  'North Africa': '北非',
  'East Africa': '东非',
  'South Africa': '南非',
  'West Africa': '西非',
  'North Europe': '北欧',
  'East Europe': '东欧',
  'West Europe': '西欧',
  'South Europe': '南欧',
  'Socialism Countries': '社会主义国家',
  'Sun': '太阳',
  'Crescent and Star': '新月和星星',
  'Animal': '动物',
  'Pan-African Colors': '泛非颜色',
  'Island Countries': '岛国',
  'Landlocked Countries': '内陆国家',
  'Biggest Countries': '最大国家',
  'Flags with Many Stripes': '多条纹旗帜',
  'Two-Color Flags': '双色旗帜',
  'Flags with Weapons': '带武器旗帜',
  'Tiny Countries': '小国',
  'Flags with Stars': '带星星旗帜',
  'Flags with Trees or Plants': '带树木或植物旗帜',
  'Flags with Crowns': '带王冠旗帜',
  'Flags with the Southern Cross': '带南十字星旗帜',
  'Non-Rectangular Flags': '非矩形旗帜',
  'Horizontal Tribands': '水平三色旗',
  'Vertical Tribands': '垂直三色旗',
  'Diagonal Stripes': '对角条纹',
  'Nile River Countries': '尼罗河国家',
  'Amazon River Countries': '亚马逊河国家',
  'Mekong River Countries': '湄公河国家',
  'Danube River Countries': '多瑙河国家'
};

// 主题名称映射（英文）
const ThemeNamesEN: Record<string, string> = {
  'Asia': 'Asia',
  'Europe': 'Europe',
  'Americas': 'Americas',
  'Africa': 'Africa',
  'Red Flags': 'Red Flags',
  'Green Flags': 'Green Flags',
  'Blue Flags': 'Blue Flags',
  'Yellow Flags': 'Yellow Flags',
  'Anglo-Saxon Flags': 'Anglo-Saxon Flags',
  'Slavic Flags': 'Slavic Flags',
  'Nordic Flags': 'Nordic Flags',
  'Arab Flags': 'Arab Flags',
  'East Asia': 'East Asia',
  'South Asia': 'South Asia',
  'West Asia': 'West Asia',
  'Southeast Asia': 'Southeast Asia',
  'North Africa': 'North Africa',
  'East Africa': 'East Africa',
  'South Africa': 'South Africa',
  'West Africa': 'West Africa',
  'North Europe': 'North Europe',
  'East Europe': 'East Europe',
  'West Europe': 'West Europe',
  'South Europe': 'South Europe',
  'Socialism Countries': 'Socialism Countries',
  'Sun': 'Sun',
  'Crescent and Star': 'Crescent and Star',
  'Animal': 'Animal',
  'Pan-African Colors': 'Pan-African Colors',
  'Island Countries': 'Island Countries',
  'Landlocked Countries': 'Landlocked Countries',
  'Biggest Countries': 'Biggest Countries',
  'Flags with Many Stripes': 'Flags with Many Stripes',
  'Two-Color Flags': 'Two-Color Flags',
  'Flags with Weapons': 'Flags with Weapons',
  'Tiny Countries': 'Tiny Countries',
  'Flags with Stars': 'Flags with Stars',
  'Flags with Trees or Plants': 'Flags with Trees or Plants',
  'Flags with Crowns': 'Flags with Crowns',
  'Flags with the Southern Cross': 'Flags with the Southern Cross',
  'Non-Rectangular Flags': 'Non-Rectangular Flags',
  'Horizontal Tribands': 'Horizontal Tribands',
  'Vertical Tribands': 'Vertical Tribands',
  'Diagonal Stripes': 'Diagonal Stripes',
  'Nile River Countries': 'Nile River Countries',
  'Amazon River Countries': 'Amazon River Countries',
  'Mekong River Countries': 'Mekong River Countries',
  'Danube River Countries': 'Danube River Countries'
};

// 主题名到本地化资源键的映射（英文）
const ThemeResourceKeys: Record<string, string> = {
  'Asia': 'app.string.connectionsAsia',
  'Europe': 'app.string.connectionsEurope',
  'Americas': 'app.string.connectionsAmericas',
  'Africa': 'app.string.connectionsAfrica',
  'Red Flags': 'app.string.connectionsRedFlags',
  'Green Flags': 'app.string.connectionsGreenFlags',
  'Blue Flags': 'app.string.connectionsBlueFlags',
  'Yellow Flags': 'app.string.connectionsYellowFlags',
  'Anglo-Saxon Flags': 'app.string.connectionsAngloSaxonFlags',
  'Slavic Flags': 'app.string.connectionsSlavicFlags',
  'Nordic Flags': 'app.string.connectionsNordicFlags',
  'Arab Flags': 'app.string.connectionsArabFlags',
  'East Asia': 'app.string.connectionsEastAsia',
  'South Asia': 'app.string.connectionsSouthAsia',
  'West Asia': 'app.string.connectionsWestAsia',
  'Southeast Asia': 'app.string.connectionsSoutheastAsia',
  'North Africa': 'app.string.connectionsNorthAfrica',
  'East Africa': 'app.string.connectionsEastAfrica',
  'South Africa': 'app.string.connectionsSouthAfrica',
  'West Africa': 'app.string.connectionsWestAfrica',
  'North Europe': 'app.string.connectionsNorthEurope',
  'East Europe': 'app.string.connectionsEastEurope',
  'West Europe': 'app.string.connectionsWestEurope',
  'South Europe': 'app.string.connectionsSouthEurope',
  'Socialism Countries': 'app.string.connectionsSocialismCountries',
  'Sun': 'app.string.connectionsSun',
  'Crescent and Star': 'app.string.connectionsCrescentAndStar',
  'Animal': 'app.string.connectionsAnimal',
  'Pan-African Colors': 'app.string.connectionsPanAfricanColors',
  'Island Countries': 'app.string.connectionsIslandCountries',
  'Landlocked Countries': 'app.string.connectionsLandlockedCountries',
  'Biggest Countries': 'app.string.connectionsBiggestCountries',
  'Flags with Many Stripes': 'app.string.connectionsFlagsWithManyStripes',
  'Two-Color Flags': 'app.string.connectionsTwoColorFlags',
  'Flags with Weapons': 'app.string.connectionsFlagsWithWeapons',
  'Tiny Countries': 'app.string.connectionsTinyCountries',
  'Flags with Stars': 'app.string.connectionsFlagsWithStars',
  'Flags with Trees or Plants': 'app.string.connectionsFlagsWithTreesOrPlants',
  'Flags with Crowns': 'app.string.connectionsFlagsWithCrowns',
  'Flags with the Southern Cross': 'app.string.connectionsFlagsWithSouthernCross',
  'Non-Rectangular Flags': 'app.string.connectionsNonRectangularFlags',
  'Horizontal Tribands': 'app.string.connectionsHorizontalTribands',
  'Vertical Tribands': 'app.string.connectionsVerticalTribands',
  'Diagonal Stripes': 'app.string.connectionsDiagonalStripes',
  'Nile River Countries': 'app.string.connectionsNileRiverCountries',
  'Amazon River Countries': 'app.string.connectionsAmazonRiverCountries',
  'Mekong River Countries': 'app.string.connectionsMekongRiverCountries',
  'Danube River Countries': 'app.string.connectionsDanubeRiverCountries'
};

// 获取本地化的主题名
export function getLocalizedTheme(theme: string, context?: common.UIAbilityContext): string {
  try {
    // 从 AppStorage 获取当前语言设置
    const currentLanguage = AppStorage.get<string>('currentLanguage') ?? 'zh';
    const isEnglish = LocalizationUtil.isEnglish(currentLanguage);

    if (isEnglish) {
      // 英文环境，返回英文映射
      return ThemeNamesEN[theme] || theme;
    } else {
      // 中文环境，返回中文映射
      return ThemeNamesCN[theme] || theme;
    }
  } catch (e) {
    console.error('Failed to get localized theme:', e);
    // 出错时返回中文映射
    return ThemeNamesCN[theme] || theme;
  }
}

// 关卡数据 - 15关
export const ConnectionsLevels: ConnectionsLevel[] = [
  {
    id: 1,
    name: '旗帜符号',
    flags: [
      { countryCode: 'CN' }, { countryCode: 'VN' }, { countryCode: 'CU' }, { countryCode: 'KP' },
      { countryCode: 'JP' }, { countryCode: 'PW' }, { countryCode: 'BD' }, { countryCode: 'MK' },
      { countryCode: 'TR' }, { countryCode: 'TN' }, { countryCode: 'DZ' }, { countryCode: 'MR' },
      { countryCode: 'LK' }, { countryCode: 'UG' }, { countryCode: 'ZM' }, { countryCode: 'PG' }
    ],
    groups: [
      { countryCodes: ['CN', 'VN', 'CU', 'KP'], theme: 'Socialism Countries', isSolved: false },
      { countryCodes: ['JP', 'PW', 'BD', 'MK'], theme: 'Sun', isSolved: false },
      { countryCodes: ['TR', 'TN', 'DZ', 'MR'], theme: 'Crescent and Star', isSolved: false },
      { countryCodes: ['LK', 'UG', 'ZM', 'PG'], theme: 'Animal', isSolved: false }
    ]
  },
  {
    id: 2,
    name: '热门国家 I',
    flags: [
      { countryCode: 'IN' }, { countryCode: 'ID' }, { countryCode: 'SA' }, { countryCode: 'TH' },
      { countryCode: 'FR' }, { countryCode: 'DE' }, { countryCode: 'IT' }, { countryCode: 'GB' },
      { countryCode: 'US' }, { countryCode: 'BR' }, { countryCode: 'MX' }, { countryCode: 'AR' },
      { countryCode: 'EG' }, { countryCode: 'NG' }, { countryCode: 'ZA' }, { countryCode: 'KE' }
    ],
    groups: [
      { countryCodes: ['IN', 'ID', 'SA', 'TH'], theme: 'Asia', isSolved: false },
      { countryCodes: ['FR', 'DE', 'IT', 'GB'], theme: 'Europe', isSolved: false },
      { countryCodes: ['US', 'BR', 'MX', 'AR'], theme: 'Americas', isSolved: false },
      { countryCodes: ['EG', 'NG', 'ZA', 'KE'], theme: 'Africa', isSolved: false }
    ]
  },
  {
    id: 3,
    name: '热门国家 II',
    flags: [
      { countryCode: 'KR' }, { countryCode: 'IR' }, { countryCode: 'PH' }, { countryCode: 'MY' },
      { countryCode: 'ES' }, { countryCode: 'NL' }, { countryCode: 'SE' }, { countryCode: 'CH' },
      { countryCode: 'CA' }, { countryCode: 'CO' }, { countryCode: 'CL' }, { countryCode: 'PE' },
      { countryCode: 'ET' }, { countryCode: 'GH' }, { countryCode: 'MA' }, { countryCode: 'TZ' }
    ],
    groups: [
      { countryCodes: ['KR', 'IR', 'PH', 'MY'], theme: 'Asia', isSolved: false },
      { countryCodes: ['ES', 'NL', 'SE', 'CH'], theme: 'Europe', isSolved: false },
      { countryCodes: ['CA', 'CO', 'CL', 'PE'], theme: 'Americas', isSolved: false },
      { countryCodes: ['ET', 'GH', 'MA', 'TZ'], theme: 'Africa', isSolved: false }
    ]
  },
  {
    id: 4,
    name: '热门国家 III',
    flags: [
      { countryCode: 'PK' }, { countryCode: 'IQ' }, { countryCode: 'SY' }, { countryCode: 'AF' },
      { countryCode: 'PL' }, { countryCode: 'NO' }, { countryCode: 'PT' }, { countryCode: 'BE' },
      { countryCode: 'VE' }, { countryCode: 'EC' }, { countryCode: 'BO' }, { countryCode: 'UY' },
      { countryCode: 'SD' }, { countryCode: 'SN' }, { countryCode: 'AO' }, { countryCode: 'CI' }
    ],
    groups: [
      { countryCodes: ['PK', 'IQ', 'SY', 'AF'], theme: 'Asia', isSolved: false },
      { countryCodes: ['PL', 'NO', 'PT', 'BE'], theme: 'Europe', isSolved: false },
      { countryCodes: ['VE', 'EC', 'BO', 'UY'], theme: 'Americas', isSolved: false },
      { countryCodes: ['SD', 'SN', 'AO', 'CI'], theme: 'Africa', isSolved: false }
    ]
  },
  {
    id: 5,
    name: '颜色分组',
    flags: [
      { countryCode: 'CN' }, { countryCode: 'DK' }, { countryCode: 'VN' }, { countryCode: 'TR' },
      { countryCode: 'SA' }, { countryCode: 'BR' }, { countryCode: 'BD' }, { countryCode: 'PK' },
      { countryCode: 'FM' }, { countryCode: 'HN' }, { countryCode: 'SO' }, { countryCode: 'AR' },
      { countryCode: 'VA' }, { countryCode: 'BN' }, { countryCode: 'ES' }, { countryCode: 'UA' }
    ],
    groups: [
      { countryCodes: ['CN', 'DK', 'VN', 'TR'], theme: 'Red Flags', isSolved: false },
      { countryCodes: ['SA', 'BR', 'BD', 'PK'], theme: 'Green Flags', isSolved: false },
      { countryCodes: ['FM', 'HN', 'SO', 'AR'], theme: 'Blue Flags', isSolved: false },
      { countryCodes: ['VA', 'BN', 'ES', 'UA'], theme: 'Yellow Flags', isSolved: false }
    ]
  },
  {
    id: 6,
    name: '文化分组',
    flags: [
      { countryCode: 'US' }, { countryCode: 'GB' }, { countryCode: 'CA' }, { countryCode: 'AU' },
      { countryCode: 'RU' }, { countryCode: 'PL' }, { countryCode: 'CZ' }, { countryCode: 'SK' },
      { countryCode: 'SE' }, { countryCode: 'NO' }, { countryCode: 'DK' }, { countryCode: 'FI' },
      { countryCode: 'SA' }, { countryCode: 'EG' }, { countryCode: 'AE' }, { countryCode: 'JO' }
    ],
    groups: [
      { countryCodes: ['US', 'GB', 'CA', 'AU'], theme: 'Anglo-Saxon Flags', isSolved: false },
      { countryCodes: ['RU', 'PL', 'CZ', 'SK'], theme: 'Slavic Flags', isSolved: false },
      { countryCodes: ['SE', 'NO', 'DK', 'FI'], theme: 'Nordic Flags', isSolved: false },
      { countryCodes: ['SA', 'EG', 'AE', 'JO'], theme: 'Arab Flags', isSolved: false }
    ]
  },
  {
    id: 7,
    name: '亚洲地区',
    flags: [
      { countryCode: 'CN' }, { countryCode: 'JP' }, { countryCode: 'KR' }, { countryCode: 'MN' },
      { countryCode: 'IN' }, { countryCode: 'PK' }, { countryCode: 'BD' }, { countryCode: 'LK' },
      { countryCode: 'SA' }, { countryCode: 'IR' }, { countryCode: 'TR' }, { countryCode: 'AE' },
      { countryCode: 'TH' }, { countryCode: 'VN' }, { countryCode: 'MY' }, { countryCode: 'SG' }
    ],
    groups: [
      { countryCodes: ['CN', 'JP', 'KR', 'MN'], theme: 'East Asia', isSolved: false },
      { countryCodes: ['IN', 'PK', 'BD', 'LK'], theme: 'South Asia', isSolved: false },
      { countryCodes: ['SA', 'IR', 'TR', 'AE'], theme: 'West Asia', isSolved: false },
      { countryCodes: ['TH', 'VN', 'MY', 'SG'], theme: 'Southeast Asia', isSolved: false }
    ]
  },
  {
    id: 8,
    name: '非洲地区',
    flags: [
      { countryCode: 'EG' }, { countryCode: 'MA' }, { countryCode: 'DZ' }, { countryCode: 'TN' },
      { countryCode: 'KE' }, { countryCode: 'ET' }, { countryCode: 'TZ' }, { countryCode: 'UG' },
      { countryCode: 'ZA' }, { countryCode: 'ZW' }, { countryCode: 'BW' }, { countryCode: 'NA' },
      { countryCode: 'NG' }, { countryCode: 'GH' }, { countryCode: 'CI' }, { countryCode: 'SN' }
    ],
    groups: [
      { countryCodes: ['EG', 'MA', 'DZ', 'TN'], theme: 'North Africa', isSolved: false },
      { countryCodes: ['KE', 'ET', 'TZ', 'UG'], theme: 'East Africa', isSolved: false },
      { countryCodes: ['ZA', 'ZW', 'BW', 'NA'], theme: 'South Africa', isSolved: false },
      { countryCodes: ['NG', 'GH', 'CI', 'SN'], theme: 'West Africa', isSolved: false }
    ]
  },
  {
    id: 9,
    name: '欧洲地区',
    flags: [
      { countryCode: 'SE' }, { countryCode: 'NO' }, { countryCode: 'DK' }, { countryCode: 'FI' },
      { countryCode: 'RU' }, { countryCode: 'PL' }, { countryCode: 'CZ' }, { countryCode: 'SK' },
      { countryCode: 'DE' }, { countryCode: 'FR' }, { countryCode: 'NL' }, { countryCode: 'BE' },
      { countryCode: 'IT' }, { countryCode: 'ES' }, { countryCode: 'PT' }, { countryCode: 'GR' }
    ],
    groups: [
      { countryCodes: ['SE', 'NO', 'DK', 'FI'], theme: 'North Europe', isSolved: false },
      { countryCodes: ['RU', 'PL', 'CZ', 'SK'], theme: 'East Europe', isSolved: false },
      { countryCodes: ['DE', 'FR', 'NL', 'BE'], theme: 'West Europe', isSolved: false },
      { countryCodes: ['IT', 'ES', 'PT', 'GR'], theme: 'South Europe', isSolved: false }
    ]
  },
  {
    id: 10,
    name: '隐藏宝石',
    flags: [
      { countryCode: 'JO' }, { countryCode: 'NP' }, { countryCode: 'QA' }, { countryCode: 'AM' },
      { countryCode: 'SK' }, { countryCode: 'LT' }, { countryCode: 'SI' }, { countryCode: 'LV' },
      { countryCode: 'GT' }, { countryCode: 'DO' }, { countryCode: 'CR' }, { countryCode: 'HN' },
      { countryCode: 'BF' }, { countryCode: 'NE' }, { countryCode: 'MW' }, { countryCode: 'RW' }
    ],
    groups: [
      { countryCodes: ['JO', 'NP', 'QA', 'AM'], theme: 'Asia', isSolved: false },
      { countryCodes: ['SK', 'LT', 'SI', 'LV'], theme: 'Europe', isSolved: false },
      { countryCodes: ['GT', 'DO', 'CR', 'HN'], theme: 'Americas', isSolved: false },
      { countryCodes: ['BF', 'NE', 'MW', 'RW'], theme: 'Africa', isSolved: false }
    ]
  },
  {
    id: 11,
    name: '地理特征',
    flags: [
      { countryCode: 'GH' }, { countryCode: 'SN' }, { countryCode: 'CM' }, { countryCode: 'GN' },
      { countryCode: 'MG' }, { countryCode: 'IS' }, { countryCode: 'NZ' }, { countryCode: 'CY' },
      { countryCode: 'AT' }, { countryCode: 'LU' }, { countryCode: 'BT' }, { countryCode: 'NE' },
      { countryCode: 'RU' }, { countryCode: 'CA' }, { countryCode: 'CN' }, { countryCode: 'US' }
    ],
    groups: [
      { countryCodes: ['GH', 'SN', 'CM', 'GN'], theme: 'Pan-African Colors', isSolved: false },
      { countryCodes: ['MG', 'IS', 'NZ', 'CY'], theme: 'Island Countries', isSolved: false },
      { countryCodes: ['AT', 'LU', 'BT', 'NE'], theme: 'Landlocked Countries', isSolved: false },
      { countryCodes: ['RU', 'CA', 'CN', 'US'], theme: 'Biggest Countries', isSolved: false }
    ]
  },
  {
    id: 12,
    name: '特殊特征',
    flags: [
      { countryCode: 'US' }, { countryCode: 'LR' }, { countryCode: 'MY' }, { countryCode: 'GR' },
      { countryCode: 'JP' }, { countryCode: 'UA' }, { countryCode: 'DK' }, { countryCode: 'TR' },
      { countryCode: 'SA' }, { countryCode: 'MZ' }, { countryCode: 'KE' }, { countryCode: 'OM' },
      { countryCode: 'VA' }, { countryCode: 'AD' }, { countryCode: 'SM' }, { countryCode: 'LI' }
    ],
    groups: [
      { countryCodes: ['US', 'LR', 'MY', 'GR'], theme: 'Flags with Many Stripes', isSolved: false },
      { countryCodes: ['JP', 'UA', 'DK', 'TR'], theme: 'Two-Color Flags', isSolved: false },
      { countryCodes: ['SA', 'MZ', 'KE', 'OM'], theme: 'Flags with Weapons', isSolved: false },
      { countryCodes: ['VA', 'AD', 'SM', 'LI'], theme: 'Tiny Countries', isSolved: false }
    ]
  },
  {
    id: 13,
    name: '标志性符号',
    flags: [
      { countryCode: 'CL' }, { countryCode: 'SO' }, { countryCode: 'VN' }, { countryCode: 'PA' },
      { countryCode: 'LB' }, { countryCode: 'GQ' }, { countryCode: 'CY' }, { countryCode: 'CA' },
      { countryCode: 'LI' }, { countryCode: 'TJ' }, { countryCode: 'RS' }, { countryCode: 'AD' },
      { countryCode: 'AU' }, { countryCode: 'NZ' }, { countryCode: 'WS' }, { countryCode: 'PG' }
    ],
    groups: [
      { countryCodes: ['CL', 'SO', 'VN', 'PA'], theme: 'Flags with Stars', isSolved: false },
      { countryCodes: ['LB', 'GQ', 'CY', 'CA'], theme: 'Flags with Trees or Plants', isSolved: false },
      { countryCodes: ['LI', 'TJ', 'RS', 'AD'], theme: 'Flags with Crowns', isSolved: false },
      { countryCodes: ['AU', 'NZ', 'WS', 'PG'], theme: 'Flags with the Southern Cross', isSolved: false }
    ]
  },
  {
    id: 14,
    name: '旗帜设计',
    flags: [
      { countryCode: 'VA' }, { countryCode: 'NP' }, { countryCode: 'CH' }, { countryCode: 'BE' },
      { countryCode: 'DE' }, { countryCode: 'HU' }, { countryCode: 'EE' }, { countryCode: 'GA' },
      { countryCode: 'FR' }, { countryCode: 'IT' }, { countryCode: 'IE' }, { countryCode: 'RO' },
      { countryCode: 'TT' }, { countryCode: 'NA' }, { countryCode: 'CD' }, { countryCode: 'TZ' }
    ],
    groups: [
      { countryCodes: ['VA', 'NP', 'CH', 'BE'], theme: 'Non-Rectangular Flags', isSolved: false },
      { countryCodes: ['DE', 'HU', 'EE', 'GA'], theme: 'Horizontal Tribands', isSolved: false },
      { countryCodes: ['FR', 'IT', 'IE', 'RO'], theme: 'Vertical Tribands', isSolved: false },
      { countryCodes: ['TT', 'NA', 'CD', 'TZ'], theme: 'Diagonal Stripes', isSolved: false }
    ]
  },
  {
    id: 15,
    name: '河流国家',
    flags: [
      { countryCode: 'EG' }, { countryCode: 'SD' }, { countryCode: 'ET' }, { countryCode: 'UG' },
      { countryCode: 'BR' }, { countryCode: 'PE' }, { countryCode: 'CO' }, { countryCode: 'EC' },
      { countryCode: 'VN' }, { countryCode: 'KH' }, { countryCode: 'LA' }, { countryCode: 'TH' },
      { countryCode: 'DE' }, { countryCode: 'AT' }, { countryCode: 'HU' }, { countryCode: 'RO' }
    ],
    groups: [
      { countryCodes: ['EG', 'SD', 'ET', 'UG'], theme: 'Nile River Countries', isSolved: false },
      { countryCodes: ['BR', 'PE', 'CO', 'EC'], theme: 'Amazon River Countries', isSolved: false },
      { countryCodes: ['VN', 'KH', 'LA', 'TH'], theme: 'Mekong River Countries', isSolved: false },
      { countryCodes: ['DE', 'AT', 'HU', 'RO'], theme: 'Danube River Countries', isSolved: false }
    ]
  }
];

// 根据关卡 ID 获取关卡数据
export function getConnectionsLevel(levelId: number): ConnectionsLevel | undefined {
  return ConnectionsLevels.find(level => level.id === levelId);
}

// 获取总关卡数
export function getTotalConnectionsLevels(): number {
  return ConnectionsLevels.length;
}





