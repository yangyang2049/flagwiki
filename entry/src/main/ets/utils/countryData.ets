// 国家数据模型
export interface Country {
    code: string;        // 两字母国家代码 (如 cn, us)
    name: string;        // 英文名称
    nameCN: string;      // 中文名称
    capital: string;     // 首都
    capitalCN: string;  // 首都中文
    region: string;      // 地区 (Asia, Europe, Africa, Americas, Oceania)
    population: number;  // 人口
    area: number;        // 面积 (平方公里)
}

// 国际组织数据模型
export interface InternationalOrg {
    code: string;        // 组织代码
    name: string;        // 英文名称
    nameCN: string;      // 中文名称
    headquarters: string; // 总部
    headquartersCN: string; // 总部中文
    region: string;      // 地区（英文标准值，如 'Global', 'Europe'）
    orgType: string;      // 组织类型
    orgTypeCN: string;   // 组织类型中文
    population: number;  // 覆盖人口
    website?: string;    // 网站（可选，不可点击的文本）
    description?: string; // 简介中文（可选）
    descriptionEN?: string; // 简介英文（可选）
}

// 国旗设计数据模型
export interface FlagDesign {
    cca2: string;        // 两字母国家代码
    design: string;      // 英文设计描述
    designCN: string;    // 中文设计描述
    proportion: string;  // 比例
    adopted: string;     // 采用日期
}

// 按洲分类
export type Continent = 'World' | 'Asia' | 'Europe' | 'Africa' | 'Americas' | 'Oceania';

// 洲名称映射（中文）
export const ContinentNames: Record<Continent, string> = {
  'World': '世界',
  'Asia': '亚洲',
  'Europe': '欧洲',
  'Africa': '非洲',
  'Americas': '美洲',
  'Oceania': '大洋洲'
};

// 洲名称映射（英文）
export const ContinentNamesEN: Record<Continent, string> = {
  'World': 'World',
  'Asia': 'Asia',
  'Europe': 'Europe',
  'Africa': 'Africa',
  'Americas': 'Americas',
  'Oceania': 'Oceania'
};

// 完整的国家数据列表
export const Countries: Country[] = [
    // 亚洲
    { code: 'cn', name: 'China', nameCN: '中国', capital: 'Beijing', capitalCN: '北京', region: 'Asia', population: 1411778724, area: 9596961 },
    { code: 'jp', name: 'Japan', nameCN: '日本', capital: 'Tokyo', capitalCN: '东京', region: 'Asia', population: 125836021, area: 377975 },
    { code: 'kr', name: 'South Korea', nameCN: '韩国', capital: 'Seoul', capitalCN: '首尔', region: 'Asia', population: 51780579, area: 100210 },
    { code: 'kp', name: 'North Korea', nameCN: '朝鲜', capital: 'Pyongyang', capitalCN: '平壤', region: 'Asia', population: 25778816, area: 120538 },
    { code: 'in', name: 'India', nameCN: '印度', capital: 'New Delhi', capitalCN: '新德里', region: 'Asia', population: 1380004385, area: 3287263 },
    { code: 'id', name: 'Indonesia', nameCN: '印度尼西亚', capital: 'Jakarta', capitalCN: '雅加达', region: 'Asia', population: 273523615, area: 1904569 },
    { code: 'th', name: 'Thailand', nameCN: '泰国', capital: 'Bangkok', capitalCN: '曼谷', region: 'Asia', population: 69799978, area: 513120 },
    { code: 'vn', name: 'Vietnam', nameCN: '越南', capital: 'Hanoi', capitalCN: '河内', region: 'Asia', population: 97338579, area: 331212 },
    { code: 'my', name: 'Malaysia', nameCN: '马来西亚', capital: 'Kuala Lumpur', capitalCN: '吉隆坡', region: 'Asia', population: 32365999, area: 330803 },
    { code: 'sg', name: 'Singapore', nameCN: '新加坡', capital: 'Singapore', capitalCN: '新加坡', region: 'Asia', population: 5850342, area: 710 },
    { code: 'ph', name: 'Philippines', nameCN: '菲律宾', capital: 'Manila', capitalCN: '马尼拉', region: 'Asia', population: 109581078, area: 300000 },
    { code: 'mm', name: 'Myanmar', nameCN: '缅甸', capital: 'Naypyidaw', capitalCN: '内比都', region: 'Asia', population: 54409800, area: 676578 },
    { code: 'kh', name: 'Cambodia', nameCN: '柬埔寨', capital: 'Phnom Penh', capitalCN: '金边', region: 'Asia', population: 16718965, area: 181035 },
    { code: 'la', name: 'Laos', nameCN: '老挝', capital: 'Vientiane', capitalCN: '万象', region: 'Asia', population: 7275560, area: 236800 },
    { code: 'bn', name: 'Brunei', nameCN: '文莱', capital: 'Bandar Seri Begawan', capitalCN: '斯里巴加湾', region: 'Asia', population: 437479, area: 5765 },
    { code: 'tl', name: 'Timor-Leste', nameCN: '东帝汶', capital: 'Dili', capitalCN: '帝力', region: 'Asia', population: 1318445, area: 14874 },
    { code: 'pk', name: 'Pakistan', nameCN: '巴基斯坦', capital: 'Islamabad', capitalCN: '伊斯兰堡', region: 'Asia', population: 220892340, area: 881913 },
    { code: 'bd', name: 'Bangladesh', nameCN: '孟加拉国', capital: 'Dhaka', capitalCN: '达卡', region: 'Asia', population: 164689383, area: 147570 },
    { code: 'lk', name: 'Sri Lanka', nameCN: '斯里兰卡', capital: 'Colombo', capitalCN: '科伦坡', region: 'Asia', population: 21919000, area: 65610 },
    { code: 'np', name: 'Nepal', nameCN: '尼泊尔', capital: 'Kathmandu', capitalCN: '加德满都', region: 'Asia', population: 29136808, area: 147181 },
    { code: 'bt', name: 'Bhutan', nameCN: '不丹', capital: 'Thimphu', capitalCN: '廷布', region: 'Asia', population: 771608, area: 38394 },
    { code: 'mv', name: 'Maldives', nameCN: '马尔代夫', capital: 'Malé', capitalCN: '马累', region: 'Asia', population: 540544, area: 298 },
    { code: 'af', name: 'Afghanistan', nameCN: '阿富汗', capital: 'Kabul', capitalCN: '喀布尔', region: 'Asia', population: 38928346, area: 652230 },
    { code: 'ir', name: 'Iran', nameCN: '伊朗', capital: 'Tehran', capitalCN: '德黑兰', region: 'Asia', population: 83992949, area: 1648195 },
    { code: 'iq', name: 'Iraq', nameCN: '伊拉克', capital: 'Baghdad', capitalCN: '巴格达', region: 'Asia', population: 40222493, area: 438317 },
    { code: 'sa', name: 'Saudi Arabia', nameCN: '沙特阿拉伯', capital: 'Riyadh', capitalCN: '利雅得', region: 'Asia', population: 34813871, area: 2149690 },
    { code: 'ae', name: 'United Arab Emirates', nameCN: '阿联酋', capital: 'Abu Dhabi', capitalCN: '阿布扎比', region: 'Asia', population: 9890402, area: 83600 },
    { code: 'qa', name: 'Qatar', nameCN: '卡塔尔', capital: 'Doha', capitalCN: '多哈', region: 'Asia', population: 2881053, area: 11586 },
    { code: 'kw', name: 'Kuwait', nameCN: '科威特', capital: 'Kuwait City', capitalCN: '科威特城', region: 'Asia', population: 4270571, area: 17818 },
    { code: 'bh', name: 'Bahrain', nameCN: '巴林', capital: 'Manama', capitalCN: '麦纳麦', region: 'Asia', population: 1701575, area: 778 },
    { code: 'om', name: 'Oman', nameCN: '阿曼', capital: 'Muscat', capitalCN: '马斯喀特', region: 'Asia', population: 5106626, area: 309500 },
    { code: 'ye', name: 'Yemen', nameCN: '也门', capital: "Sana'a", capitalCN: '萨那', region: 'Asia', population: 29825964, area: 527968 },
    { code: 'jo', name: 'Jordan', nameCN: '约旦', capital: 'Amman', capitalCN: '安曼', region: 'Asia', population: 10203134, area: 89342 },
    { code: 'lb', name: 'Lebanon', nameCN: '黎巴嫩', capital: 'Beirut', capitalCN: '贝鲁特', region: 'Asia', population: 6825445, area: 10452 },
    { code: 'sy', name: 'Syria', nameCN: '叙利亚', capital: 'Damascus', capitalCN: '大马士革', region: 'Asia', population: 17500658, area: 185180 },
    { code: 'il', name: 'Israel', nameCN: '以色列', capital: 'Jerusalem', capitalCN: '耶路撒冷', region: 'Asia', population: 8655535, area: 20770 },
    { code: 'ps', name: 'Palestine', nameCN: '巴勒斯坦', capital: 'Ramallah', capitalCN: '拉姆安拉', region: 'Asia', population: 5101414, area: 6220 },
    { code: 'tr', name: 'Turkey', nameCN: '土耳其', capital: 'Ankara', capitalCN: '安卡拉', region: 'Asia', population: 84339067, area: 783562 },
    { code: 'ge', name: 'Georgia', nameCN: '格鲁吉亚', capital: 'Tbilisi', capitalCN: '第比利斯', region: 'Asia', population: 3989167, area: 69700 },
    { code: 'am', name: 'Armenia', nameCN: '亚美尼亚', capital: 'Yerevan', capitalCN: '埃里温', region: 'Asia', population: 2963243, area: 29743 },
    { code: 'az', name: 'Azerbaijan', nameCN: '阿塞拜疆', capital: 'Baku', capitalCN: '巴库', region: 'Asia', population: 10139177, area: 86600 },
    { code: 'kz', name: 'Kazakhstan', nameCN: '哈萨克斯坦', capital: 'Nur-Sultan', capitalCN: '努尔苏丹', region: 'Asia', population: 18776707, area: 2724900 },
    { code: 'uz', name: 'Uzbekistan', nameCN: '乌兹别克斯坦', capital: 'Tashkent', capitalCN: '塔什干', region: 'Asia', population: 33469203, area: 448978 },
    { code: 'tm', name: 'Turkmenistan', nameCN: '土库曼斯坦', capital: 'Ashgabat', capitalCN: '阿什哈巴德', region: 'Asia', population: 6031200, area: 491210 },
    { code: 'kg', name: 'Kyrgyzstan', nameCN: '吉尔吉斯斯坦', capital: 'Bishkek', capitalCN: '比什凯克', region: 'Asia', population: 6524195, area: 199951 },
    { code: 'tj', name: 'Tajikistan', nameCN: '塔吉克斯坦', capital: 'Dushanbe', capitalCN: '杜尚别', region: 'Asia', population: 9537645, area: 143100 },
    { code: 'mn', name: 'Mongolia', nameCN: '蒙古', capital: 'Ulaanbaatar', capitalCN: '乌兰巴托', region: 'Asia', population: 3278290, area: 1564116 },

    // 欧洲
    { code: 'gb', name: 'United Kingdom', nameCN: '英国', capital: 'London', capitalCN: '伦敦', region: 'Europe', population: 67886011, area: 242495 },
    { code: 'fr', name: 'France', nameCN: '法国', capital: 'Paris', capitalCN: '巴黎', region: 'Europe', population: 65273511, area: 643801 },
    { code: 'de', name: 'Germany', nameCN: '德国', capital: 'Berlin', capitalCN: '柏林', region: 'Europe', population: 83783942, area: 357114 },
    { code: 'it', name: 'Italy', nameCN: '意大利', capital: 'Rome', capitalCN: '罗马', region: 'Europe', population: 60461826, area: 301340 },
    { code: 'es', name: 'Spain', nameCN: '西班牙', capital: 'Madrid', capitalCN: '马德里', region: 'Europe', population: 46754778, area: 505992 },
    { code: 'pt', name: 'Portugal', nameCN: '葡萄牙', capital: 'Lisbon', capitalCN: '里斯本', region: 'Europe', population: 10196709, area: 92090 },
    { code: 'nl', name: 'Netherlands', nameCN: '荷兰', capital: 'Amsterdam', capitalCN: '阿姆斯特丹', region: 'Europe', population: 17134872, area: 41850 },
    { code: 'be', name: 'Belgium', nameCN: '比利时', capital: 'Brussels', capitalCN: '布鲁塞尔', region: 'Europe', population: 11589623, area: 30528 },
    { code: 'ch', name: 'Switzerland', nameCN: '瑞士', capital: 'Bern', capitalCN: '伯尔尼', region: 'Europe', population: 8654622, area: 41284 },
    { code: 'at', name: 'Austria', nameCN: '奥地利', capital: 'Vienna', capitalCN: '维也纳', region: 'Europe', population: 9006398, area: 83871 },
    { code: 'se', name: 'Sweden', nameCN: '瑞典', capital: 'Stockholm', capitalCN: '斯德哥尔摩', region: 'Europe', population: 10099265, area: 450295 },
    { code: 'no', name: 'Norway', nameCN: '挪威', capital: 'Oslo', capitalCN: '奥斯陆', region: 'Europe', population: 5421241, area: 323802 },
    { code: 'dk', name: 'Denmark', nameCN: '丹麦', capital: 'Copenhagen', capitalCN: '哥本哈根', region: 'Europe', population: 5792202, area: 43094 },
    { code: 'fi', name: 'Finland', nameCN: '芬兰', capital: 'Helsinki', capitalCN: '赫尔辛基', region: 'Europe', population: 5540720, area: 338424 },
    { code: 'is', name: 'Iceland', nameCN: '冰岛', capital: 'Reykjavik', capitalCN: '雷克雅未克', region: 'Europe', population: 341243, area: 103000 },
    { code: 'ie', name: 'Ireland', nameCN: '爱尔兰', capital: 'Dublin', capitalCN: '都柏林', region: 'Europe', population: 4937786, area: 70273 },
    { code: 'pl', name: 'Poland', nameCN: '波兰', capital: 'Warsaw', capitalCN: '华沙', region: 'Europe', population: 37846611, area: 312679 },
    { code: 'cz', name: 'Czech Republic', nameCN: '捷克', capital: 'Prague', capitalCN: '布拉格', region: 'Europe', population: 10708981, area: 78865 },
    { code: 'sk', name: 'Slovakia', nameCN: '斯洛伐克', capital: 'Bratislava', capitalCN: '布拉迪斯拉发', region: 'Europe', population: 5459642, area: 49035 },
    { code: 'hu', name: 'Hungary', nameCN: '匈牙利', capital: 'Budapest', capitalCN: '布达佩斯', region: 'Europe', population: 9660351, area: 93028 },
    { code: 'ro', name: 'Romania', nameCN: '罗马尼亚', capital: 'Bucharest', capitalCN: '布加勒斯特', region: 'Europe', population: 19237691, area: 238391 },
    { code: 'bg', name: 'Bulgaria', nameCN: '保加利亚', capital: 'Sofia', capitalCN: '索菲亚', region: 'Europe', population: 6948445, area: 110879 },
    { code: 'gr', name: 'Greece', nameCN: '希腊', capital: 'Athens', capitalCN: '雅典', region: 'Europe', population: 10423054, area: 131990 },
    { code: 'hr', name: 'Croatia', nameCN: '克罗地亚', capital: 'Zagreb', capitalCN: '萨格勒布', region: 'Europe', population: 4105267, area: 56594 },
    { code: 'si', name: 'Slovenia', nameCN: '斯洛文尼亚', capital: 'Ljubljana', capitalCN: '卢布尔雅那', region: 'Europe', population: 2078938, area: 20273 },
    { code: 'rs', name: 'Serbia', nameCN: '塞尔维亚', capital: 'Belgrade', capitalCN: '贝尔格莱德', region: 'Europe', population: 6982084, area: 88361 },
    { code: 'ba', name: 'Bosnia and Herzegovina', nameCN: '波黑', capital: 'Sarajevo', capitalCN: '萨拉热窝', region: 'Europe', population: 3280819, area: 51209 },
    { code: 'me', name: 'Montenegro', nameCN: '黑山', capital: 'Podgorica', capitalCN: '波德戈里察', region: 'Europe', population: 628066, area: 13812 },
    { code: 'mk', name: 'North Macedonia', nameCN: '北马其顿', capital: 'Skopje', capitalCN: '斯科普里', region: 'Europe', population: 2083374, area: 25713 },
    { code: 'al', name: 'Albania', nameCN: '阿尔巴尼亚', capital: 'Tirana', capitalCN: '地拉那', region: 'Europe', population: 2877797, area: 28748 },
    { code: 'ua', name: 'Ukraine', nameCN: '乌克兰', capital: 'Kyiv', capitalCN: '基辅', region: 'Europe', population: 43733762, area: 603500 },
    { code: 'by', name: 'Belarus', nameCN: '白俄罗斯', capital: 'Minsk', capitalCN: '明斯克', region: 'Europe', population: 9449323, area: 207600 },
    { code: 'md', name: 'Moldova', nameCN: '摩尔多瓦', capital: 'Chișinău', capitalCN: '基希讷乌', region: 'Europe', population: 2657637, area: 33846 },
    { code: 'lt', name: 'Lithuania', nameCN: '立陶宛', capital: 'Vilnius', capitalCN: '维尔纽斯', region: 'Europe', population: 2722289, area: 65300 },
    { code: 'lv', name: 'Latvia', nameCN: '拉脱维亚', capital: 'Riga', capitalCN: '里加', region: 'Europe', population: 1886198, area: 64559 },
    { code: 'ee', name: 'Estonia', nameCN: '爱沙尼亚', capital: 'Tallinn', capitalCN: '塔林', region: 'Europe', population: 1326535, area: 45228 },
    { code: 'ru', name: 'Russia', nameCN: '俄罗斯', capital: 'Moscow', capitalCN: '莫斯科', region: 'Europe', population: 145934462, area: 17098242 },
    { code: 'lu', name: 'Luxembourg', nameCN: '卢森堡', capital: 'Luxembourg', capitalCN: '卢森堡', region: 'Europe', population: 625978, area: 2586 },
    { code: 'mt', name: 'Malta', nameCN: '马耳他', capital: 'Valletta', capitalCN: '瓦莱塔', region: 'Europe', population: 441543, area: 316 },
    { code: 'cy', name: 'Cyprus', nameCN: '塞浦路斯', capital: 'Nicosia', capitalCN: '尼科西亚', region: 'Europe', population: 1207359, area: 9251 },
    { code: 'li', name: 'Liechtenstein', nameCN: '列支敦士登', capital: 'Vaduz', capitalCN: '瓦杜兹', region: 'Europe', population: 38128, area: 160 },
    { code: 'mc', name: 'Monaco', nameCN: '摩纳哥', capital: 'Monaco', capitalCN: '摩纳哥', region: 'Europe', population: 39242, area: 2 },
    { code: 'sm', name: 'San Marino', nameCN: '圣马力诺', capital: 'San Marino', capitalCN: '圣马力诺', region: 'Europe', population: 33931, area: 61 },
    { code: 'va', name: 'Vatican City', nameCN: '梵蒂冈', capital: 'Vatican City', capitalCN: '梵蒂冈', region: 'Europe', population: 801, area: 0.44 },
    { code: 'ad', name: 'Andorra', nameCN: '安道尔', capital: 'Andorra la Vella', capitalCN: '安道尔城', region: 'Europe', population: 77265, area: 468 },

    // 非洲
    { code: 'eg', name: 'Egypt', nameCN: '埃及', capital: 'Cairo', capitalCN: '开罗', region: 'Africa', population: 102334404, area: 1001450 },
    { code: 'za', name: 'South Africa', nameCN: '南非', capital: 'Pretoria', capitalCN: '比勒陀利亚', region: 'Africa', population: 59308690, area: 1221037 },
    { code: 'ng', name: 'Nigeria', nameCN: '尼日利亚', capital: 'Abuja', capitalCN: '阿布贾', region: 'Africa', population: 206139589, area: 923768 },
    { code: 'ke', name: 'Kenya', nameCN: '肯尼亚', capital: 'Nairobi', capitalCN: '内罗毕', region: 'Africa', population: 53771296, area: 580367 },
    { code: 'et', name: 'Ethiopia', nameCN: '埃塞俄比亚', capital: 'Addis Ababa', capitalCN: '亚的斯亚贝巴', region: 'Africa', population: 114963588, area: 1104300 },
    { code: 'gh', name: 'Ghana', nameCN: '加纳', capital: 'Accra', capitalCN: '阿克拉', region: 'Africa', population: 31072940, area: 238533 },
    { code: 'tz', name: 'Tanzania', nameCN: '坦桑尼亚', capital: 'Dodoma', capitalCN: '多多马', region: 'Africa', population: 59734218, area: 945087 },
    { code: 'ug', name: 'Uganda', nameCN: '乌干达', capital: 'Kampala', capitalCN: '坎帕拉', region: 'Africa', population: 45741007, area: 241550 },
    { code: 'dz', name: 'Algeria', nameCN: '阿尔及利亚', capital: 'Algiers', capitalCN: '阿尔及尔', region: 'Africa', population: 43851044, area: 2381741 },
    { code: 'ma', name: 'Morocco', nameCN: '摩洛哥', capital: 'Rabat', capitalCN: '拉巴特', region: 'Africa', population: 36910560, area: 446550 },
    { code: 'tn', name: 'Tunisia', nameCN: '突尼斯', capital: 'Tunis', capitalCN: '突尼斯', region: 'Africa', population: 11818619, area: 163610 },
    { code: 'ly', name: 'Libya', nameCN: '利比亚', capital: 'Tripoli', capitalCN: '的黎波里', region: 'Africa', population: 6871292, area: 1759540 },
    { code: 'sd', name: 'Sudan', nameCN: '苏丹', capital: 'Khartoum', capitalCN: '喀土穆', region: 'Africa', population: 43849260, area: 1886068 },
    { code: 'ss', name: 'South Sudan', nameCN: '南苏丹', capital: 'Juba', capitalCN: '朱巴', region: 'Africa', population: 11193725, area: 619745 },
    { code: 'ao', name: 'Angola', nameCN: '安哥拉', capital: 'Luanda', capitalCN: '罗安达', region: 'Africa', population: 32866272, area: 1246700 },
    { code: 'mz', name: 'Mozambique', nameCN: '莫桑比克', capital: 'Maputo', capitalCN: '马普托', region: 'Africa', population: 31255435, area: 801590 },
    { code: 'zw', name: 'Zimbabwe', nameCN: '津巴布韦', capital: 'Harare', capitalCN: '哈拉雷', region: 'Africa', population: 14862924, area: 390757 },
    { code: 'zm', name: 'Zambia', nameCN: '赞比亚', capital: 'Lusaka', capitalCN: '卢萨卡', region: 'Africa', population: 18383955, area: 752612 },
    { code: 'bw', name: 'Botswana', nameCN: '博茨瓦纳', capital: 'Gaborone', capitalCN: '哈博罗内', region: 'Africa', population: 2351627, area: 581730 },
    { code: 'na', name: 'Namibia', nameCN: '纳米比亚', capital: 'Windhoek', capitalCN: '温得和克', region: 'Africa', population: 2540905, area: 825615 },
    { code: 'sn', name: 'Senegal', nameCN: '塞内加尔', capital: 'Dakar', capitalCN: '达喀尔', region: 'Africa', population: 16743927, area: 196722 },
    { code: 'ci', name: "Côte d'Ivoire", nameCN: '科特迪瓦', capital: 'Yamoussoukro', capitalCN: '亚穆苏克罗', region: 'Africa', population: 26378274, area: 322463 },
    { code: 'cm', name: 'Cameroon', nameCN: '喀麦隆', capital: 'Yaoundé', capitalCN: '雅温得', region: 'Africa', population: 26545863, area: 475442 },
    { code: 'cd', name: 'Democratic Republic of the Congo', nameCN: '刚果(金)', capital: 'Kinshasa', capitalCN: '金沙萨', region: 'Africa', population: 89561403, area: 2344858 },
    { code: 'cg', name: 'Republic of the Congo', nameCN: '刚果(布)', capital: 'Brazzaville', capitalCN: '布拉柴维尔', region: 'Africa', population: 5518087, area: 342000 },
    { code: 'rw', name: 'Rwanda', nameCN: '卢旺达', capital: 'Kigali', capitalCN: '基加利', region: 'Africa', population: 12952218, area: 26338 },
    { code: 'mg', name: 'Madagascar', nameCN: '马达加斯加', capital: 'Antananarivo', capitalCN: '塔那那利佛', region: 'Africa', population: 27691018, area: 587041 },
    { code: 'mu', name: 'Mauritius', nameCN: '毛里求斯', capital: 'Port Louis', capitalCN: '路易港', region: 'Africa', population: 1271768, area: 2040 },
    { code: 'sc', name: 'Seychelles', nameCN: '塞舌尔', capital: 'Victoria', capitalCN: '维多利亚', region: 'Africa', population: 98347, area: 459 },
    { code: 'ml', name: 'Mali', nameCN: '马里', capital: 'Bamako', capitalCN: '巴马科', region: 'Africa', population: 20250833, area: 1240192 },
    { code: 'bf', name: 'Burkina Faso', nameCN: '布基纳法索', capital: 'Ouagadougou', capitalCN: '瓦加杜古', region: 'Africa', population: 20903273, area: 272967 },
    { code: 'ne', name: 'Niger', nameCN: '尼日尔', capital: 'Niamey', capitalCN: '尼亚美', region: 'Africa', population: 24206644, area: 1267000 },
    { code: 'td', name: 'Chad', nameCN: '乍得', capital: "N'Djamena", capitalCN: '恩贾梅纳', region: 'Africa', population: 16425864, area: 1284000 },
    { code: 'mr', name: 'Mauritania', nameCN: '毛里塔尼亚', capital: 'Nouakchott', capitalCN: '努瓦克肖特', region: 'Africa', population: 4649658, area: 1030700 },
    { code: 'gm', name: 'Gambia', nameCN: '冈比亚', capital: 'Banjul', capitalCN: '班珠尔', region: 'Africa', population: 2416668, area: 10689 },
    { code: 'gn', name: 'Guinea', nameCN: '几内亚', capital: 'Conakry', capitalCN: '科纳克里', region: 'Africa', population: 13132795, area: 245857 },
    { code: 'gw', name: 'Guinea-Bissau', nameCN: '几内亚比绍', capital: 'Bissau', capitalCN: '比绍', region: 'Africa', population: 1968001, area: 36125 },
    { code: 'sl', name: 'Sierra Leone', nameCN: '塞拉利昂', capital: 'Freetown', capitalCN: '弗里敦', region: 'Africa', population: 7976983, area: 71740 },
    { code: 'lr', name: 'Liberia', nameCN: '利比里亚', capital: 'Monrovia', capitalCN: '蒙罗维亚', region: 'Africa', population: 5057681, area: 111369 },
    { code: 'tg', name: 'Togo', nameCN: '多哥', capital: 'Lomé', capitalCN: '洛美', region: 'Africa', population: 8278724, area: 56785 },
    { code: 'bj', name: 'Benin', nameCN: '贝宁', capital: 'Porto-Novo', capitalCN: '波多诺伏', region: 'Africa', population: 12123200, area: 114763 },
    { code: 'ga', name: 'Gabon', nameCN: '加蓬', capital: 'Libreville', capitalCN: '利伯维尔', region: 'Africa', population: 2225734, area: 267668 },
    { code: 'gq', name: 'Equatorial Guinea', nameCN: '赤道几内亚', capital: 'Malabo', capitalCN: '马拉博', region: 'Africa', population: 1402985, area: 28051 },
    { code: 'cf', name: 'Central African Republic', nameCN: '中非', capital: 'Bangui', capitalCN: '班吉', region: 'Africa', population: 4829767, area: 622984 },
    { code: 'bi', name: 'Burundi', nameCN: '布隆迪', capital: 'Gitega', capitalCN: '基特加', region: 'Africa', population: 11890784, area: 27834 },
    { code: 'er', name: 'Eritrea', nameCN: '厄立特里亚', capital: 'Asmara', capitalCN: '阿斯马拉', region: 'Africa', population: 3546421, area: 117600 },
    { code: 'dj', name: 'Djibouti', nameCN: '吉布提', capital: 'Djibouti', capitalCN: '吉布提', region: 'Africa', population: 988000, area: 23200 },
    { code: 'so', name: 'Somalia', nameCN: '索马里', capital: 'Mogadishu', capitalCN: '摩加迪沙', region: 'Africa', population: 15893222, area: 637657 },
    { code: 'km', name: 'Comoros', nameCN: '科摩罗', capital: 'Moroni', capitalCN: '莫罗尼', region: 'Africa', population: 869601, area: 1862 },
    { code: 'cv', name: 'Cape Verde', nameCN: '佛得角', capital: 'Praia', capitalCN: '普拉亚', region: 'Africa', population: 555987, area: 4033 },
    { code: 'st', name: 'São Tomé and Príncipe', nameCN: '圣多美和普林西比', capital: 'São Tomé', capitalCN: '圣多美', region: 'Africa', population: 219159, area: 964 },
    { code: 'mw', name: 'Malawi', nameCN: '马拉维', capital: 'Lilongwe', capitalCN: '利隆圭', region: 'Africa', population: 19129952, area: 118484 },
    { code: 'ls', name: 'Lesotho', nameCN: '莱索托', capital: 'Maseru', capitalCN: '马塞卢', region: 'Africa', population: 2142249, area: 30355 },
    { code: 'sz', name: 'Eswatini', nameCN: '斯威士兰', capital: 'Mbabane', capitalCN: '姆巴巴内', region: 'Africa', population: 1160164, area: 17364 },

    // 美洲
    { code: 'us', name: 'United States', nameCN: '美国', capital: 'Washington D.C.', capitalCN: '华盛顿', region: 'Americas', population: 331002651, area: 9833517 },
    { code: 'ca', name: 'Canada', nameCN: '加拿大', capital: 'Ottawa', capitalCN: '渥太华', region: 'Americas', population: 37742154, area: 9984670 },
    { code: 'mx', name: 'Mexico', nameCN: '墨西哥', capital: 'Mexico City', capitalCN: '墨西哥城', region: 'Americas', population: 128932753, area: 1964375 },
    { code: 'br', name: 'Brazil', nameCN: '巴西', capital: 'Brasília', capitalCN: '巴西利亚', region: 'Americas', population: 212559417, area: 8515767 },
    { code: 'ar', name: 'Argentina', nameCN: '阿根廷', capital: 'Buenos Aires', capitalCN: '布宜诺斯艾利斯', region: 'Americas', population: 45195774, area: 2780400 },
    { code: 'cl', name: 'Chile', nameCN: '智利', capital: 'Santiago', capitalCN: '圣地亚哥', region: 'Americas', population: 19116201, area: 756102 },
    { code: 'co', name: 'Colombia', nameCN: '哥伦比亚', capital: 'Bogotá', capitalCN: '波哥大', region: 'Americas', population: 50882891, area: 1141748 },
    { code: 'pe', name: 'Peru', nameCN: '秘鲁', capital: 'Lima', capitalCN: '利马', region: 'Americas', population: 32971854, area: 1285216 },
    { code: 've', name: 'Venezuela', nameCN: '委内瑞拉', capital: 'Caracas', capitalCN: '加拉加斯', region: 'Americas', population: 28435940, area: 916445 },
    { code: 'ec', name: 'Ecuador', nameCN: '厄瓜多尔', capital: 'Quito', capitalCN: '基多', region: 'Americas', population: 17643054, area: 283561 },
    { code: 'bo', name: 'Bolivia', nameCN: '玻利维亚', capital: 'Sucre', capitalCN: '苏克雷', region: 'Americas', population: 11673021, area: 1098581 },
    { code: 'py', name: 'Paraguay', nameCN: '巴拉圭', capital: 'Asunción', capitalCN: '亚松森', region: 'Americas', population: 7132538, area: 406752 },
    { code: 'uy', name: 'Uruguay', nameCN: '乌拉圭', capital: 'Montevideo', capitalCN: '蒙得维的亚', region: 'Americas', population: 3473730, area: 176215 },
    { code: 'gy', name: 'Guyana', nameCN: '圭亚那', capital: 'Georgetown', capitalCN: '乔治敦', region: 'Americas', population: 786552, area: 214969 },
    { code: 'sr', name: 'Suriname', nameCN: '苏里南', capital: 'Paramaribo', capitalCN: '帕拉马里博', region: 'Americas', population: 586632, area: 163820 },
    { code: 'gt', name: 'Guatemala', nameCN: '危地马拉', capital: 'Guatemala City', capitalCN: '危地马拉城', region: 'Americas', population: 17915568, area: 108889 },
    { code: 'hn', name: 'Honduras', nameCN: '洪都拉斯', capital: 'Tegucigalpa', capitalCN: '特古西加尔巴', region: 'Americas', population: 9904607, area: 112492 },
    { code: 'sv', name: 'El Salvador', nameCN: '萨尔瓦多', capital: 'San Salvador', capitalCN: '圣萨尔瓦多', region: 'Americas', population: 6486205, area: 21041 },
    { code: 'ni', name: 'Nicaragua', nameCN: '尼加拉瓜', capital: 'Managua', capitalCN: '马那瓜', region: 'Americas', population: 6624554, area: 130373 },
    { code: 'cr', name: 'Costa Rica', nameCN: '哥斯达黎加', capital: 'San José', capitalCN: '圣何塞', region: 'Americas', population: 5094118, area: 51100 },
    { code: 'pa', name: 'Panama', nameCN: '巴拿马', capital: 'Panama City', capitalCN: '巴拿马城', region: 'Americas', population: 4314767, area: 75417 },
    { code: 'bz', name: 'Belize', nameCN: '伯利兹', capital: 'Belmopan', capitalCN: '贝尔莫潘', region: 'Americas', population: 397628, area: 22966 },
    { code: 'cu', name: 'Cuba', nameCN: '古巴', capital: 'Havana', capitalCN: '哈瓦那', region: 'Americas', population: 11326616, area: 109884 },
    { code: 'ht', name: 'Haiti', nameCN: '海地', capital: 'Port-au-Prince', capitalCN: '太子港', region: 'Americas', population: 11402528, area: 27750 },
    { code: 'do', name: 'Dominican Republic', nameCN: '多米尼加', capital: 'Santo Domingo', capitalCN: '圣多明各', region: 'Americas', population: 10847910, area: 48671 },
    { code: 'jm', name: 'Jamaica', nameCN: '牙买加', capital: 'Kingston', capitalCN: '金斯敦', region: 'Americas', population: 2961167, area: 10991 },
    { code: 'tt', name: 'Trinidad and Tobago', nameCN: '特立尼达和多巴哥', capital: 'Port of Spain', capitalCN: '西班牙港', region: 'Americas', population: 1399488, area: 5130 },
    { code: 'bb', name: 'Barbados', nameCN: '巴巴多斯', capital: 'Bridgetown', capitalCN: '布里奇敦', region: 'Americas', population: 287375, area: 430 },
    { code: 'bs', name: 'Bahamas', nameCN: '巴哈马', capital: 'Nassau', capitalCN: '拿骚', region: 'Americas', population: 393244, area: 13943 },
    { code: 'dm', name: 'Dominica', nameCN: '多米尼克', capital: 'Roseau', capitalCN: '罗索', region: 'Americas', population: 71986, area: 751 },
    { code: 'gd', name: 'Grenada', nameCN: '格林纳达', capital: "St. George's", capitalCN: '圣乔治', region: 'Americas', population: 112523, area: 344 },
    { code: 'lc', name: 'Saint Lucia', nameCN: '圣卢西亚', capital: 'Castries', capitalCN: '卡斯特里', region: 'Americas', population: 183627, area: 616 },
    { code: 'vc', name: 'Saint Vincent and the Grenadines', nameCN: '圣文森特和格林纳丁斯', capital: 'Kingstown', capitalCN: '金斯敦', region: 'Americas', population: 110940, area: 389 },
    { code: 'kn', name: 'Saint Kitts and Nevis', nameCN: '圣基茨和尼维斯', capital: 'Basseterre', capitalCN: '巴斯特尔', region: 'Americas', population: 53199, area: 261 },
    { code: 'ag', name: 'Antigua and Barbuda', nameCN: '安提瓜和巴布达', capital: "St. John's", capitalCN: '圣约翰', region: 'Americas', population: 97929, area: 442 },

    // 大洋洲
    { code: 'au', name: 'Australia', nameCN: '澳大利亚', capital: 'Canberra', capitalCN: '堪培拉', region: 'Oceania', population: 25499884, area: 7692024 },
    { code: 'nz', name: 'New Zealand', nameCN: '新西兰', capital: 'Wellington', capitalCN: '惠灵顿', region: 'Oceania', population: 4822233, area: 270467 },
    { code: 'fj', name: 'Fiji', nameCN: '斐济', capital: 'Suva', capitalCN: '苏瓦', region: 'Oceania', population: 896445, area: 18272 },
    { code: 'pg', name: 'Papua New Guinea', nameCN: '巴布亚新几内亚', capital: 'Port Moresby', capitalCN: '莫尔斯比港', region: 'Oceania', population: 8947024, area: 462840 },
    { code: 'sb', name: 'Solomon Islands', nameCN: '所罗门群岛', capital: 'Honiara', capitalCN: '霍尼亚拉', region: 'Oceania', population: 686884, area: 28896 },
    { code: 'vu', name: 'Vanuatu', nameCN: '瓦努阿图', capital: 'Port Vila', capitalCN: '维拉港', region: 'Oceania', population: 307145, area: 12189 },
    { code: 'ws', name: 'Samoa', nameCN: '萨摩亚', capital: 'Apia', capitalCN: '阿皮亚', region: 'Oceania', population: 198414, area: 2842 },
    { code: 'to', name: 'Tonga', nameCN: '汤加', capital: "Nuku'alofa", capitalCN: '努库阿洛法', region: 'Oceania', population: 105695, area: 747 },
    { code: 'ki', name: 'Kiribati', nameCN: '基里巴斯', capital: 'Tarawa', capitalCN: '塔拉瓦', region: 'Oceania', population: 119449, area: 811 },
    { code: 'fm', name: 'Micronesia', nameCN: '密克罗尼西亚', capital: 'Palikir', capitalCN: '帕利基尔', region: 'Oceania', population: 548914, area: 702 },
    { code: 'mh', name: 'Marshall Islands', nameCN: '马绍尔群岛', capital: 'Majuro', capitalCN: '马朱罗', region: 'Oceania', population: 59190, area: 181 },
    { code: 'pw', name: 'Palau', nameCN: '帕劳', capital: 'Ngerulmud', capitalCN: '梅莱凯奥克', region: 'Oceania', population: 18094, area: 459 },
    { code: 'nr', name: 'Nauru', nameCN: '瑙鲁', capital: 'Yaren', capitalCN: '亚伦', region: 'Oceania', population: 10824, area: 21 },
    { code: 'tv', name: 'Tuvalu', nameCN: '图瓦卢', capital: 'Funafuti', capitalCN: '富纳富提', region: 'Oceania', population: 11792, area: 26 }
];

// 根据洲筛选国家
export function getCountriesByContinent(continent: Continent): Country[] {
    if (continent === 'World') {
        return Countries;
    }
    return Countries.filter(country => country.region === continent);
}

// 国家数据 Map 缓存（优化查找性能，从 O(n) 到 O(1)）
let countryMapCache: Map<string, Country> | null = null;

// 初始化国家数据 Map 缓存
function initCountryMapCache(): void {
    if (countryMapCache === null) {
        countryMapCache = new Map();
        for (const country of Countries) {
            countryMapCache.set(country.code.toLowerCase(), country);
        }
    }
}

// 根据国家代码获取国家（使用 Map 缓存优化性能）
export function getCountryByCode(code: string): Country | undefined {
    initCountryMapCache();
    return countryMapCache?.get(code.toLowerCase());
}

// 本地化工具函数：根据语言获取国家名称
export function getLocalizedCountryName(country: Country, language: string): string {
    if (language === 'en' || language.startsWith('en-')) {
        return country.name;
    }
    return country.nameCN;
}

// 本地化工具函数：根据语言获取首都名称
export function getLocalizedCapital(country: Country, language: string): string {
    if (language === 'en' || language.startsWith('en-')) {
        return country.capital;
    }
    return country.capitalCN;
}

// 本地化工具函数：根据语言获取标志设计描述
export function getLocalizedFlagDesign(flagDesign: FlagDesign | undefined, language: string): string {
    if (!flagDesign) {
        return '';
    }
    if (language === 'en' || language.startsWith('en-')) {
        return flagDesign.design;
    }
    return flagDesign.designCN;
}

// 本地化工具函数：根据语言获取国际组织名称
export function getLocalizedOrgName(org: InternationalOrg, language: string): string {
    if (language === 'en' || language.startsWith('en-')) {
        return org.name;
    }
    return org.nameCN;
}

// 本地化工具函数：根据语言获取国际组织总部名称
export function getLocalizedOrgHeadquarters(org: InternationalOrg, language: string): string {
    if (language === 'en' || language.startsWith('en-')) {
        return org.headquarters;
    }
    return org.headquartersCN;
}

// 本地化工具函数：根据语言获取区域名称
export function getLocalizedRegionName(region: string, language: string): string {
    const continent = region as Continent;
    if (language === 'en' || language.startsWith('en-')) {
        return ContinentNamesEN[continent] || region;
    }
    return ContinentNames[continent] || region;
}

// 获取所有洲
export function getAllContinents(): Continent[] {
    return ['World', 'Asia', 'Europe', 'Africa', 'Americas', 'Oceania'];
}

// 国旗设计数据
export const FlagDesigns: Record<string, FlagDesign> = {
    'af': { cca2: 'af', design: 'The Shahadain black on a white field in the calligraphic Thuluth script', designCN: '白色背景上的黑色书法文字"沙哈达"。', proportion: '1:2', adopted: '2021-08-15' },
    'al': { cca2: 'al', design: 'A red field with a black two-headed eagle in the center.', designCN: '红色背景中央有一只黑色的双头鹰。', proportion: '5:7', adopted: '2002-07-22' },
    'dz': { cca2: 'dz', design: 'A vertical bicolor of green and white, with the red crescent encircling the red five-pointed star centered along the dividing line.', designCN: '绿色和白色的竖直双色旗，中间有一个包围着红色五角星的红色新月。', proportion: '2:3', adopted: '1962-07-03' },
    'ad': { cca2: 'ad', design: 'A vertical tricolour of blue, yellow and red with the National Coat of arms centerd on the yellow band.', designCN: '蓝色、黄色和红色的竖直三色旗，黄色条纹上有国家徽章。', proportion: '7:10', adopted: '1993' },
    'ao': { cca2: 'ao', design: 'A horizontal bicolour of red and black, with a yellow half gear wheel crossed by a machete and crowned with a star in the center.', designCN: '红色和黑色的水平双色旗，中间有一个黄色的齿轮半轮和一把斧头，上方有一颗星。', proportion: '2:3', adopted: '1975-11-11' },
    'ag': { cca2: 'ag', design: 'A horizontal tri-colour of black, blue (half-width), and white, with two red right scalene triangles on opposite sides. On the black band is a yellow half-sun with nine rays', designCN: '黑色、蓝色（半宽）和白色的水平三色旗，左右两侧为红色直角三角形。黑色条纹上有一个黄色的半太阳，带有九条光芒。', proportion: '2:3', adopted: '1967-02-27' },
    'ar': { cca2: 'ar', design: 'A horizontal tricolour of sky blue (top and bottom) and white, with a yellow Sun of May in the center.', designCN: '天蓝色（上下）和白色的水平三色旗，中央有一个五月的太阳。', proportion: '9:14', adopted: '1818-02-25' },
    'am': { cca2: 'am', design: 'A horizontal tricolour of red, blue and orange.', designCN: '红色、蓝色和橙色的水平三色旗。', proportion: '1:2', adopted: '1990-08-24' },
    'au': { cca2: 'au', design: 'Blue with the Union Flag in the canton, a large seven-pointed star below it, and the five stars of the Southern Cross on the fly side.', designCN: '蓝色旗帜，左下角有英联邦星，下方右侧有南十字星的五颗星。', proportion: '1:2', adopted: '1954-04-14' },
    'at': { cca2: 'at', design: 'A horizontal tricolour of red (top and bottom) and white.', designCN: '红色（上下）和白色的水平三色旗。', proportion: '2:3', adopted: '1945-05-01' },
    'az': { cca2: 'az', design: 'A horizontal tricolour of bright blue, red and green, with a white crescent and an eight-pointed star on the red band.', designCN: '亮蓝色、红色和绿色的水平三色旗，红色条纹上有一个白色新月和八角星。', proportion: '1:2', adopted: '1991-02-05' },
    'bs': { cca2: 'bs', design: 'A horizontal tricolour of aquamarine (top and bottom) and gold, with a black inverted triangle on the left.', designCN: '浅蓝色（上下）和金色的水平三色旗，左侧有一个黑色的倒三角。', proportion: '1:2', adopted: '1973-07-10' },
    'bh': { cca2: 'bh', design: 'A white area to the left and a red area to the right, with five white triangles forming a serrated edge between them.', designCN: '左侧为白色区域，右侧为红色区域，二者之间有五个白色三角形成的锯齿形图案。', proportion: '3:5', adopted: '2002-02-14' },
    'bd': { cca2: 'bd', design: 'A red disc slightly offset towards the hoist on a dark green field.', designCN: '一个略微偏左的红色圆盘位于深绿色旗帜上。', proportion: '3:5', adopted: '1972-01-17' },
    'bb': { cca2: 'bb', design: 'A vertical tricolour of ultramarine (left and right) and gold, with a black trident head in the center of the gold band.', designCN: '海蓝色（左右）和金色的垂直三色旗，金色条纹中央有一个黑色三叉戟。', proportion: '2:3', adopted: '1966-11-30' },
    'by': { cca2: 'by', design: 'A horizontal bicolour of red and green, with a white vertical stripe on the left with red decorative pattern.', designCN: '红色和绿色的水平双色旗，左侧有一个带红色装饰图案的白色竖条。', proportion: '1:2', adopted: '2012-02-10' },
    'be': { cca2: 'be', design: 'A vertical tricolour of black, yellow and red.', designCN: '黑色、黄色和红色的垂直三色旗。', proportion: '13:15', adopted: '1831-01-23' },
    'bz': { cca2: 'bz', design: 'A dark blue field with red stripes on the top and bottom edges, and a white circle with the national coat of arms in the center.', designCN: '深蓝色旗帜，上下边缘有红色条纹，中央为白色圆盘，内有国家徽章。', proportion: '3:5', adopted: '1981-09-21' },
    'bj': { cca2: 'bj', design: 'A horizontal bicolour of yellow and red, with a green vertical stripe on the left.', designCN: '黄色和红色的水平双色旗，左侧有绿色竖条。', proportion: '2:3', adopted: '1990-08-01' },
    'bt': { cca2: 'bt', design: 'Diagonally divided from the lower hoist-side corner, with the upper triangle yellow and the lower triangle orange, featuring a white dragon in the center.', designCN: '从左下角对角分割，上三角形为黄色，下三角形为橙色，中央有一条白色的龙。', proportion: '2:3', adopted: '1969' },
    'bo': { cca2: 'bo', design: 'A horizontal tricolour of red, yellow and green.', designCN: '红色、黄色和绿色的水平三色旗。', proportion: '15:22', adopted: '1851-10-31' },
    'ba': { cca2: 'ba', design: 'A blue field with a yellow right triangle and seven full and two half white five-pointed stars.', designCN: '蓝色旗帜，有一个黄色直角三角形和七颗完整及两颗一半的白色五角星。', proportion: '1:2', adopted: '1998-02-04' },
    'bw': { cca2: 'bw', design: 'A light blue field with a black horizontal stripe with white edges in the center.', designCN: '浅蓝色旗帜，中央有一条带白色边缘的黑色水平条纹。', proportion: '2:3', adopted: '1966-09-30' },
    'br': { cca2: 'br', design: 'A green field with a large yellow diamond in the center, containing a dark blue globe with 27 white stars and a curved white band with the national motto.', designCN: '绿色旗帜中央有一个大黄色菱形，内有深蓝色地球仪，上有27颗白星和一条弯曲的白色绶带，上书国家格言。', proportion: '7:10', adopted: '1992-05-11' },
    'bn': { cca2: 'bn', design: 'A yellow field with two diagonal stripes of white and black, and the national emblem in the center.', designCN: '黄色旗帜，有白色和黑色两条对角线条纹，中央是国家徽章。', proportion: '1:2', adopted: '1959-09-29' },
    'bg': { cca2: 'bg', design: 'A horizontal tricolour of white, green and red.', designCN: '白色、绿色和红色的水平三色旗。', proportion: '3:5', adopted: '1991-11-22' },
    'bf': { cca2: 'bf', design: 'A horizontal bicolour of red and green, with a yellow five-pointed star in the center.', designCN: '红色和绿色的水平双色旗，中央有一颗黄色五角星。', proportion: '2:3', adopted: '1984-08-04' },
    'bi': { cca2: 'bi', design: 'A white saltire dividing the field into alternating red and green areas, with a white circle in the center containing three red six-pointed stars.', designCN: '白色的X形条纹将旗帜分成红绿相间的区域，中央白色圆圈内有三颗红色六角星。', proportion: '3:5', adopted: '1967-06-28' },
    'cv': { cca2: 'cv', design: 'A blue field with three horizontal stripes of white, red and white, and a circle of ten yellow five-pointed stars.', designCN: '蓝色旗帜，有白色、红色和白色三条水平条纹，以及十颗黄色五角星组成的圆圈。', proportion: '10:17', adopted: '1992-09-22' },
    'kh': { cca2: 'kh', design: 'A horizontal tricolour of blue, red (double width) and blue, with a white depiction of Angkor Wat in the center.', designCN: '蓝色、红色（双倍宽）和蓝色的水平三色旗，中央有白色的吴哥窟图案。', proportion: '16:25', adopted: '1993-06-24' },
    'cm': { cca2: 'cm', design: 'A vertical tricolour of green, red and yellow, with a yellow five-pointed star in the center.', designCN: '绿色、红色和黄色的垂直三色旗，中央有一颗黄色五角星。', proportion: '2:3', adopted: '1975-05-20' },
    'ca': { cca2: 'ca', design: 'A vertical tricolour of red, white (double width) and red, with a red maple leaf in the center.', designCN: '红色、白色（双倍宽）和红色的垂直三色旗，中央有一片红色枫叶。', proportion: '1:2', adopted: '1965-02-15' },
    'cf': { cca2: 'cf', design: 'Four horizontal stripes of blue, white, green and yellow, with a vertical red stripe in the center and a yellow five-pointed star in the upper left.', designCN: '蓝色、白色、绿色和黄色四条水平条纹，中央有红色垂直条纹，左上角有黄色五角星。', proportion: '3:5', adopted: '1958-12-01' },
    'td': { cca2: 'td', design: 'A vertical tricolour of blue, yellow and red.', designCN: '蓝色、黄色和红色的垂直三色旗。', proportion: '2:3', adopted: '1959-11-06' },
    'cl': { cca2: 'cl', design: 'A horizontal bicolour of white and red, with a blue square in the upper left corner containing a white five-pointed star.', designCN: '白色和红色的水平双色旗，左上角蓝色方块内有一颗白色五角星。', proportion: '2:3', adopted: '1817-10-18' },
    'cn': { cca2: 'cn', design: 'A large golden star within an arc of four smaller golden stars, in the canton, on a field of Chinese red.', designCN: '红色旗帜，左上角有一颗大金色星星和四颗小金色星星。', proportion: '2:3', adopted: '1949-10-01' },
    'co': { cca2: 'co', design: 'A horizontal tricolour of yellow (double width), blue and red.', designCN: '黄色（双倍宽）、蓝色和红色的水平三色旗。', proportion: '2:3', adopted: '1861-11-26' },
    'km': { cca2: 'km', design: 'Four horizontal stripes of yellow, white, red and blue, with a green triangle on the left containing a white crescent and four white stars.', designCN: '黄色、白色、红色和蓝色四条水平条纹，左侧绿色三角形内有白色新月和四颗白色星星。', proportion: '3:5', adopted: '2001-12-23' },
    'cg': { cca2: 'cg', design: 'A diagonal tricolour of green, yellow and red.', designCN: '绿色、黄色和红色的对角三色旗。', proportion: '2:3', adopted: '1991-06-10' },
    'cd': { cca2: 'cd', design: 'A sky blue field with a yellow star in the upper left corner and a diagonal red stripe with yellow edges.', designCN: '天蓝色旗帜，左上角有黄色星星，有一条带黄色边缘的红色对角条纹。', proportion: '3:4', adopted: '2006-02-18' },
    'cr': { cca2: 'cr', design: 'A horizontal tricolour of blue, white, red (double width), white and blue.', designCN: '蓝色、白色、红色（双倍宽）、白色和蓝色的水平五条纹旗。', proportion: '3:5', adopted: '1906-11-27' },
    'ci': { cca2: 'ci', design: 'A vertical tricolour of orange, white and green.', designCN: '橙色、白色和绿色的垂直三色旗。', proportion: '2:3', adopted: '1959-12-03' },
    'hr': { cca2: 'hr', design: 'A horizontal tricolour of red, white and blue, with the national coat of arms in the center.', designCN: '红色、白色和蓝色的水平三色旗，中央有国家徽章。', proportion: '1:2', adopted: '1990-12-21' },
    'cu': { cca2: 'cu', design: 'Five horizontal stripes of blue and white, with a red triangle on the left containing a white five-pointed star.', designCN: '蓝色和白色五条水平条纹，左侧红色三角形内有一颗白色五角星。', proportion: '1:2', adopted: '1902-05-20' },
    'cy': { cca2: 'cy', design: 'A white field with a copper-colored silhouette of the island above two crossed olive branches.', designCN: '白色旗帜，上有铜色的岛屿轮廓和下方交叉的两枝橄榄枝。', proportion: '3:5', adopted: '2006-04-20' },
    'cz': { cca2: 'cz', design: 'A horizontal bicolour of white and red, with a blue triangle on the left.', designCN: '白色和红色的水平双色旗，左侧有蓝色三角形。', proportion: '2:3', adopted: '1920-03-30' },
    'dk': { cca2: 'dk', design: 'A red field with a white Scandinavian cross.', designCN: '红色旗帜上有白色的斯堪的纳维亚十字。', proportion: '28:37', adopted: '1625' },
    'dj': { cca2: 'dj', design: 'A horizontal bicolour of light blue and green, with a white triangle on the left containing a red star.', designCN: '浅蓝色和绿色的水平双色旗，左侧白色三角形内有一颗红色星星。', proportion: '2:3', adopted: '1977-06-27' },
    'dm': { cca2: 'dm', design: 'A green field with a cross of yellow, black and white stripes, and a red disc in the center containing a sisserou parrot.', designCN: '绿色旗帜上有黄色、黑色和白色条纹组成的十字，中央红色圆盘内有一只帝王亚马逊鹦鹉。', proportion: '1:2', adopted: '1990-11-03' },
    'do': { cca2: 'do', design: 'A white cross dividing the field into blue (top left and bottom right) and red (top right and bottom left) rectangles, with the national coat of arms in the center.', designCN: '白色十字将旗帜分成蓝色（左上和右下）和红色（右上和左下）四个矩形，中央有国家徽章。', proportion: '5:8', adopted: '1908-09-06' },
    'ec': { cca2: 'ec', design: 'A horizontal tricolour of yellow (double width), blue and red, with the national coat of arms in the center.', designCN: '黄色（双倍宽）、蓝色和红色的水平三色旗，中央有国家徽章。', proportion: '2:3', adopted: '1860-09-26' },
    'eg': { cca2: 'eg', design: 'A horizontal tricolour of red, white and black, with the Egyptian eagle of Saladin in the center.', designCN: '红色、白色和黑色的水平三色旗，中央有萨拉丁之鹰图案。', proportion: '2:3', adopted: '1984-10-04' },
    'sv': { cca2: 'sv', design: 'A horizontal tricolour of cobalt blue, white and cobalt blue, with the national coat of arms in the center.', designCN: '钴蓝色、白色和钴蓝色的水平三色旗，中央有国家徽章。', proportion: '189:335', adopted: '1912-05-27' },
    'gq': { cca2: 'gq', design: 'A horizontal tricolour of green, white and red, with a blue triangle on the left and the national coat of arms in the center.', designCN: '绿色、白色和红色的水平三色旗，左侧有蓝色三角形，中央有国家徽章。', proportion: '2:3', adopted: '1979-08-21' },
    'er': { cca2: 'er', design: 'A green triangle on top, a blue triangle at the bottom, and a red triangle on the left, with a yellow olive wreath in the center.', designCN: '上方绿色三角形，下方蓝色三角形，左侧红色三角形，中央有黄色橄榄花环。', proportion: '1:2', adopted: '1995-12-05' },
    'ee': { cca2: 'ee', design: 'A horizontal tricolour of blue, black and white.', designCN: '蓝色、黑色和白色的水平三色旗。', proportion: '7:11', adopted: '1990-08-07' },
    'sz': { cca2: 'sz', design: 'A horizontal tricolour of blue, yellow, crimson (triple width), yellow and blue, with a Nguni shield and spears in the center.', designCN: '蓝色、黄色、深红色（三倍宽）、黄色和蓝色的水平条纹旗，中央有恩古尼盾牌和长矛。', proportion: '2:3', adopted: '1968-10-30' },
    'et': { cca2: 'et', design: 'A horizontal tricolour of green, yellow and red, with the national emblem in the center on a blue disc.', designCN: '绿色、黄色和红色的水平三色旗，中央蓝色圆盘上有国家徽章。', proportion: '1:2', adopted: '1996-10-31' },
    'fj': { cca2: 'fj', design: 'A light blue field with the Union Jack in the canton and the shield from the national coat of arms on the fly side.', designCN: '浅蓝色旗帜，左上角有英国国旗，右侧有国家徽章的盾牌。', proportion: '1:2', adopted: '1970-10-10' },
    'fi': { cca2: 'fi', design: 'A white field with a blue Nordic cross.', designCN: '白色旗帜上有蓝色的北欧十字。', proportion: '11:18', adopted: '1918-05-29' },
    'fr': { cca2: 'fr', design: 'A vertical tricolour of blue, white and red.', designCN: '蓝色、白色和红色的垂直三色旗。', proportion: '2:3', adopted: '1794-02-15' },
    'ga': { cca2: 'ga', design: 'A horizontal tricolour of green, yellow and blue.', designCN: '绿色、黄色和蓝色的水平三色旗。', proportion: '3:4', adopted: '1960-08-09' },
    'gm': { cca2: 'gm', design: 'A horizontal tricolour of red, blue and green, separated by narrow white stripes.', designCN: '红色、蓝色和绿色的水平三色旗，由细白色条纹分隔。', proportion: '2:3', adopted: '1965-02-18' },
    'ge': { cca2: 'ge', design: 'A white field with a red cross and four small red crosses in each quadrant.', designCN: '白色旗帜上有一个红色大十字和四个小红十字分布在四个象限。', proportion: '2:3', adopted: '2004-01-14' },
    'de': { cca2: 'de', design: 'A horizontal tricolour of black, red and gold.', designCN: '黑色、红色和金色的水平三色旗。', proportion: '3:5', adopted: '1949-05-23' },
    'gh': { cca2: 'gh', design: 'A horizontal tricolour of red, gold and green, with a black five-pointed star in the center.', designCN: '红色、金色和绿色的水平三色旗，中央有一颗黑色五角星。', proportion: '2:3', adopted: '1966-02-28' },
    'gr': { cca2: 'gr', design: 'Nine horizontal stripes of blue and white, with a blue canton containing a white cross.', designCN: '蓝色和白色九条水平条纹，左上角蓝色方块内有白色十字。', proportion: '2:3', adopted: '1978-12-22' },
    'gd': { cca2: 'gd', design: 'A red border with six yellow stars, a yellow and green diagonal cross, and a red disc with a yellow star in the center.', designCN: '红色边框内有六颗黄色星星，黄色和绿色对角十字，中央红色圆盘内有一颗黄色星星。', proportion: '3:5', adopted: '1974-02-07' },
    'gt': { cca2: 'gt', design: 'A vertical tricolour of sky blue, white and sky blue, with the national coat of arms in the center.', designCN: '天蓝色、白色和天蓝色的垂直三色旗，中央有国家徽章。', proportion: '5:8', adopted: '1871-08-17' },
    'gn': { cca2: 'gn', design: 'A vertical tricolour of red, yellow and green.', designCN: '红色、黄色和绿色的垂直三色旗。', proportion: '2:3', adopted: '1958-11-10' },
    'gw': { cca2: 'gw', design: 'A horizontal bicolour of yellow and green, with a red vertical stripe on the left containing a black five-pointed star.', designCN: '黄色和绿色的水平双色旗，左侧红色垂直条纹内有一颗黑色五角星。', proportion: '1:2', adopted: '1973-09-24' },
    'gy': { cca2: 'gy', design: 'A green field with a golden arrow and a red triangle with black edges.', designCN: '绿色旗帜上有金色箭头和带黑色边缘的红色三角形。', proportion: '3:5', adopted: '1966-05-26' },
    'ht': { cca2: 'ht', design: 'A horizontal bicolour of blue and red, with the national coat of arms in the center on a white rectangle.', designCN: '蓝色和红色的水平双色旗，中央白色矩形上有国家徽章。', proportion: '3:5', adopted: '1986-02-25' },
    'hn': { cca2: 'hn', design: 'A horizontal tricolour of blue, white and blue, with five blue stars in the center.', designCN: '蓝色、白色和蓝色的水平三色旗，中央有五颗蓝色星星。', proportion: '1:2', adopted: '1949-01-18' },
    'hu': { cca2: 'hu', design: 'A horizontal tricolour of red, white and green.', designCN: '红色、白色和绿色的水平三色旗。', proportion: '1:2', adopted: '1957-10-01' },
    'is': { cca2: 'is', design: 'A blue field with a red Nordic cross with white edges.', designCN: '蓝色旗帜上有带白色边缘的红色北欧十字。', proportion: '18:25', adopted: '1944-06-17' },
    'in': { cca2: 'in', design: 'A horizontal tricolour of saffron, white and green, with a blue Ashoka Chakra in the center.', designCN: '藏红色、白色和绿色的水平三色旗，中央有蓝色的阿育王法轮。', proportion: '2:3', adopted: '1947-07-22' },
    'id': { cca2: 'id', design: 'A horizontal bicolour of red and white.', designCN: '红色和白色的水平双色旗。', proportion: '2:3', adopted: '1945-08-17' },
    'ir': { cca2: 'ir', design: 'A horizontal tricolour of green, white and red, with the national emblem in the center and stylized text on the borders.', designCN: '绿色、白色和红色的水平三色旗，中央有国家徽章，边缘有程式化文字。', proportion: '4:7', adopted: '1980-07-29' },
    'iq': { cca2: 'iq', design: 'A horizontal tricolour of red, white and black, with the Takbir in green Kufic script in the center.', designCN: '红色、白色和黑色的水平三色旗，中央有绿色库法体书写的"真主至大"。', proportion: '2:3', adopted: '2008-01-22' },
    'ie': { cca2: 'ie', design: 'A vertical tricolour of green, white and orange.', designCN: '绿色、白色和橙色的垂直三色旗。', proportion: '1:2', adopted: '1919-01-21' },
    'il': { cca2: 'il', design: 'A white field with two horizontal blue stripes and a blue Star of David in the center.', designCN: '白色旗帜上有两条蓝色水平条纹，中央有蓝色大卫之星。', proportion: '8:11', adopted: '1948-10-28' },
    'it': { cca2: 'it', design: 'A vertical tricolour of green, white and red.', designCN: '绿色、白色和红色的垂直三色旗。', proportion: '2:3', adopted: '1948-01-01' },
    'jm': { cca2: 'jm', design: 'A gold saltire dividing the field into green (top and bottom) and black (left and right) triangles.', designCN: '金色的X形条纹将旗帜分成绿色（上下）和黑色（左右）三角形。', proportion: '1:2', adopted: '1962-08-06' },
    'jp': { cca2: 'jp', design: 'A white field with a crimson disc in the center.', designCN: '白色旗帜中央有一个深红色圆盘。', proportion: '2:3', adopted: '1999-08-13' },
    'jo': { cca2: 'jo', design: 'A horizontal tricolour of black, white and green, with a red triangle on the left containing a white seven-pointed star.', designCN: '黑色、白色和绿色的水平三色旗，左侧红色三角形内有一颗白色七角星。', proportion: '1:2', adopted: '1928-04-16' },
    'kz': { cca2: 'kz', design: 'A sky blue field with a golden sun and soaring eagle in the center, and a national ornamental pattern on the left.', designCN: '天蓝色旗帜，中央有金色太阳和翱翔的雄鹰，左侧有民族装饰图案。', proportion: '1:2', adopted: '1992-06-04' },
    'ke': { cca2: 'ke', design: 'A horizontal tricolour of black, red and green, separated by white stripes, with a Maasai shield and spears in the center.', designCN: '黑色、红色和绿色的水平三色旗，由白色条纹分隔，中央有马赛盾牌和长矛。', proportion: '2:3', adopted: '1963-12-12' },
    'ki': { cca2: 'ki', design: 'A red field with six white wavy lines at the bottom and a golden frigate bird flying over a rising sun.', designCN: '红色旗帜，底部有六条白色波浪线，上方有一只金色军舰鸟飞越升起的太阳。', proportion: '1:2', adopted: '1979-07-12' },
    'kp': { cca2: 'kp', design: 'A horizontal tricolour of blue, red (with white edges) and blue, with a red star on a white disc on the left.', designCN: '蓝色、红色（带白色边缘）和蓝色的水平三色旗，左侧白色圆盘上有一颗红色星星。', proportion: '1:2', adopted: '1948-09-08' },
    'kr': { cca2: 'kr', design: 'A white field with a red and blue taegeuk in the center and four black trigrams in the corners.', designCN: '白色旗帜，中央有红蓝太极图，四角有四个黑色的卦象。', proportion: '2:3', adopted: '1949-10-15' },
    'kw': { cca2: 'kw', design: 'A horizontal tricolour of green, white and red, with a black trapezoid on the left.', designCN: '绿色、白色和红色的水平三色旗，左侧有黑色梯形。', proportion: '1:2', adopted: '1961-09-07' },
    'kg': { cca2: 'kg', design: 'A red field with a yellow sun with 40 rays and a yurt in the center.', designCN: '红色旗帜，中央有带40条光芒的黄色太阳和一个毡房。', proportion: '3:5', adopted: '1992-03-03' },
    'la': { cca2: 'la', design: 'A horizontal tricolour of red, blue (double width) and red, with a white disc in the center.', designCN: '红色、蓝色（双倍宽）和红色的水平三色旗，中央有白色圆盘。', proportion: '2:3', adopted: '1975-12-02' },
    'lv': { cca2: 'lv', design: 'A carmine field with a narrow white stripe through the center.', designCN: '深红色旗帜，中央有一条细白色条纹。', proportion: '1:2', adopted: '1990-02-27' },
    'lb': { cca2: 'lb', design: 'A horizontal tricolour of red, white (double width) and red, with a green cedar in the center.', designCN: '红色、白色（双倍宽）和红色的水平三色旗，中央有绿色雪松。', proportion: '2:3', adopted: '1943-12-07' },
    'ls': { cca2: 'ls', design: 'A horizontal tricolour of blue, white and green, with a black mokorotlo (Basotho hat) in the center.', designCN: '蓝色、白色和绿色的水平三色旗，中央有黑色的巴索托帽。', proportion: '2:3', adopted: '2006-10-04' },
    'lr': { cca2: 'lr', design: 'Eleven horizontal stripes of red and white, with a blue canton containing a white five-pointed star.', designCN: '红色和白色十一条水平条纹，左上角蓝色方块内有一颗白色五角星。', proportion: '10:19', adopted: '1847-08-24' },
    'ly': { cca2: 'ly', design: 'A horizontal tricolour of red, black (double width) and green, with a white crescent and star in the center.', designCN: '红色、黑色（双倍宽）和绿色的水平三色旗，中央有白色新月和星星。', proportion: '1:2', adopted: '2011-08-03' },
    'li': { cca2: 'li', design: 'A horizontal bicolour of blue and red, with a golden crown in the upper left corner.', designCN: '蓝色和红色的水平双色旗，左上角有金色王冠。', proportion: '3:5', adopted: '1937-06-24' },
    'lt': { cca2: 'lt', design: 'A horizontal tricolour of yellow, green and red.', designCN: '黄色、绿色和红色的水平三色旗。', proportion: '3:5', adopted: '1989-03-20' },
    'lu': { cca2: 'lu', design: 'A horizontal tricolour of red, white and light blue.', designCN: '红色、白色和浅蓝色的水平三色旗。', proportion: '3:5', adopted: '1993-06-23' },
    'mg': { cca2: 'mg', design: 'A white vertical stripe on the left with horizontal stripes of red and green on the right.', designCN: '左侧白色垂直条纹，右侧红色和绿色水平条纹。', proportion: '2:3', adopted: '1958-10-14' },
    'mw': { cca2: 'mw', design: 'A horizontal tricolour of black, red and green, with a red rising sun in the center of the black stripe.', designCN: '黑色、红色和绿色的水平三色旗，黑色条纹中央有红色升起的太阳。', proportion: '2:3', adopted: '2012-07-06' },
    'my': { cca2: 'my', design: 'Fourteen horizontal stripes of red and white, with a blue canton containing a yellow crescent and a fourteen-pointed star.', designCN: '红色和白色十四条水平条纹，左上角蓝色方块内有黄色新月和十四角星。', proportion: '1:2', adopted: '1963-09-16' },
    'mv': { cca2: 'mv', design: 'A red field with a green rectangle in the center containing a white crescent.', designCN: '红色旗帜，中央绿色矩形内有白色新月。', proportion: '2:3', adopted: '1965-07-25' },
    'ml': { cca2: 'ml', design: 'A vertical tricolour of green, yellow and red.', designCN: '绿色、黄色和红色的垂直三色旗。', proportion: '2:3', adopted: '1961-03-01' },
    'mt': { cca2: 'mt', design: 'A vertical bicolour of white and red, with a representation of the George Cross in the upper left corner.', designCN: '白色和红色的垂直双色旗，左上角有乔治十字勋章。', proportion: '2:3', adopted: '1964-09-21' },
    'mh': { cca2: 'mh', design: 'A blue field with two diagonal stripes of orange and white, and a white four-pointed star in the upper left.', designCN: '蓝色旗帜，有橙色和白色两条对角条纹，左上角有白色四角星。', proportion: '10:19', adopted: '1979-05-01' },
    'mr': { cca2: 'mr', design: 'A green field with a gold crescent and star in the center, and red stripes on the top and bottom.', designCN: '绿色旗帜，中央有金色新月和星星，上下有红色条纹。', proportion: '2:3', adopted: '2017-08-15' },
    'mu': { cca2: 'mu', design: 'A horizontal quadricolour of red, blue, yellow and green.', designCN: '红色、蓝色、黄色和绿色的水平四色旗。', proportion: '2:3', adopted: '1968-03-12' },
    'mx': { cca2: 'mx', design: 'A vertical tricolour of green, white and red, with the national coat of arms in the center.', designCN: '绿色、白色和红色的垂直三色旗，中央有国家徽章。', proportion: '4:7', adopted: '1968-09-16' },
    'fm': { cca2: 'fm', design: 'A light blue field with four white five-pointed stars arranged in a diamond pattern.', designCN: '浅蓝色旗帜，四颗白色五角星呈菱形排列。', proportion: '10:19', adopted: '1978-11-30' },
    'md': { cca2: 'md', design: 'A vertical tricolour of blue, yellow and red, with the national coat of arms in the center.', designCN: '蓝色、黄色和红色的垂直三色旗，中央有国家徽章。', proportion: '1:2', adopted: '1990-11-06' },
    'mc': { cca2: 'mc', design: 'A horizontal bicolour of red and white.', designCN: '红色和白色的水平双色旗。', proportion: '4:5', adopted: '1881-04-04' },
    'mn': { cca2: 'mn', design: 'A vertical tricolour of red, blue and red, with the Soyombo symbol in the left red stripe.', designCN: '红色、蓝色和红色的垂直三色旗，左侧红色条纹内有索永布符号。', proportion: '1:2', adopted: '2011-07-08' },
    'me': { cca2: 'me', design: 'A red field with a golden border and the national coat of arms in the center.', designCN: '红色旗帜，有金色边框，中央有国家徽章。', proportion: '1:2', adopted: '2004-07-12' },
    'ma': { cca2: 'ma', design: 'A red field with a green pentagram (five-pointed star) in the center.', designCN: '红色旗帜，中央有绿色五角星。', proportion: '2:3', adopted: '1915-11-17' },
    'mz': { cca2: 'mz', design: 'A horizontal tricolour of green, black and yellow, with a red triangle on the left containing the national emblem.', designCN: '绿色、黑色和黄色的水平三色旗，左侧红色三角形内有国家徽章。', proportion: '2:3', adopted: '1983-05-01' },
    'mm': { cca2: 'mm', design: 'A horizontal tricolour of yellow, green and red, with a large white five-pointed star in the center.', designCN: '黄色、绿色和红色的水平三色旗，中央有一颗大白色五角星。', proportion: '2:3', adopted: '2010-10-21' },
    'na': { cca2: 'na', design: 'A diagonal bicolour of blue and green, separated by a red stripe with white edges, and a gold sun in the upper left.', designCN: '蓝色和绿色对角双色旗，由带白色边缘的红色条纹分隔，左上角有金色太阳。', proportion: '2:3', adopted: '1990-03-21' },
    'nr': { cca2: 'nr', design: 'A blue field with a thin yellow stripe through the center and a white twelve-pointed star below.', designCN: '蓝色旗帜，中央有一条细黄色条纹，下方有一颗白色十二角星。', proportion: '1:2', adopted: '1968-01-31' },
    'np': { cca2: 'np', design: 'Two stacked triangular pennants, crimson with a blue border, featuring the sun and moon.', designCN: '两个堆叠的三角形旗，深红色带蓝色边框，上有太阳和月亮图案。', proportion: '5:4', adopted: '1962-12-16' },
    'nl': { cca2: 'nl', design: 'A horizontal tricolour of red, white and blue.', designCN: '红色、白色和蓝色的水平三色旗。', proportion: '2:3', adopted: '1937-02-19' },
    'nz': { cca2: 'nz', design: 'A blue field with the Union Jack in the canton and four red stars with white borders on the right.', designCN: '蓝色旗帜，左上角有英国国旗，右侧有四颗带白色边框的红色星星。', proportion: '1:2', adopted: '1902-06-12' },
    'ni': { cca2: 'ni', design: 'A horizontal tricolour of blue, white and blue, with the national coat of arms in the center.', designCN: '蓝色、白色和蓝色的水平三色旗，中央有国家徽章。', proportion: '3:5', adopted: '1971-08-27' },
    'ne': { cca2: 'ne', design: 'A horizontal tricolour of orange, white and green, with an orange circle in the center.', designCN: '橙色、白色和绿色的水平三色旗，中央有橙色圆圈。', proportion: '6:7', adopted: '1959-11-23' },
    'ng': { cca2: 'ng', design: 'A vertical tricolour of green, white and green.', designCN: '绿色、白色和绿色的垂直三色旗。', proportion: '1:2', adopted: '1960-10-01' },
    'mk': { cca2: 'mk', design: 'A red field with a stylized yellow sun with eight rays extending to the edges.', designCN: '红色旗帜，有程式化的黄色太阳和八条延伸到边缘的光芒。', proportion: '1:2', adopted: '1995-10-05' },
    'no': { cca2: 'no', design: 'A red field with a blue Nordic cross with white edges.', designCN: '红色旗帜上有带白色边缘的蓝色北欧十字。', proportion: '8:11', adopted: '1821-07-17' },
    'om': { cca2: 'om', design: 'Three horizontal stripes of white, red and green, with a red vertical stripe on the left containing the national emblem.', designCN: '白色、红色和绿色三条水平条纹，左侧红色垂直条纹内有国家徽章。', proportion: '1:2', adopted: '1995-04-25' },
    'pk': { cca2: 'pk', design: 'A dark green field with a white vertical stripe on the left and a white crescent and five-pointed star in the center.', designCN: '深绿色旗帜，左侧有白色垂直条纹，中央有白色新月和五角星。', proportion: '2:3', adopted: '1947-08-11' },
    'pw': { cca2: 'pw', design: 'A light blue field with a large yellow disc slightly off-center towards the hoist.', designCN: '浅蓝色旗帜，中央略偏左有一个大黄色圆盘。', proportion: '5:8', adopted: '1981-01-01' },
    'ps': { cca2: 'ps', design: 'A horizontal tricolour of black, white and green, with a red triangle on the left.', designCN: '黑色、白色和绿色的水平三色旗，左侧有红色三角形。', proportion: '1:2', adopted: '1988-11-15' },
    'pa': { cca2: 'pa', design: 'A quartered field of white and red with blue and red stars.', designCN: '白色和红色四分旗，有蓝色和红色星星。', proportion: '2:3', adopted: '1925-03-25' },
    'pg': { cca2: 'pg', design: 'A diagonal bicolour of red and black, with a yellow bird-of-paradise and the Southern Cross.', designCN: '红色和黑色对角双色旗，有黄色天堂鸟和南十字星。', proportion: '3:4', adopted: '1971-07-01' },
    'py': { cca2: 'py', design: 'A horizontal tricolour of red, white and blue, with the national coat of arms on the front and the treasury seal on the back.', designCN: '红色、白色和蓝色的水平三色旗，正面有国家徽章，背面有财政部印章。', proportion: '3:5', adopted: '2013-07-15' },
    'pe': { cca2: 'pe', design: 'A vertical tricolour of red, white and red.', designCN: '红色、白色和红色的垂直三色旗。', proportion: '2:3', adopted: '1825-02-25' },
    'ph': { cca2: 'ph', design: 'A horizontal bicolour of blue and red, with a white triangle on the left containing a golden sun and three stars.', designCN: '蓝色和红色的水平双色旗，左侧白色三角形内有金色太阳和三颗星星。', proportion: '1:2', adopted: '1998-02-12' },
    'pl': { cca2: 'pl', design: 'A horizontal bicolour of white and red.', designCN: '白色和红色的水平双色旗。', proportion: '5:8', adopted: '1919-08-01' },
    'pt': { cca2: 'pt', design: 'A vertical bicolour of green and red, with the national coat of arms centered on the dividing line.', designCN: '绿色和红色的垂直双色旗，国家徽章位于分界线上。', proportion: '2:3', adopted: '1911-06-30' },
    'qa': { cca2: 'qa', design: 'A maroon field with a white serrated band on the left.', designCN: '栗色旗帜，左侧有白色锯齿形边带。', proportion: '11:28', adopted: '1971-07-09' },
    'ro': { cca2: 'ro', design: 'A vertical tricolour of blue, yellow and red.', designCN: '蓝色、黄色和红色的垂直三色旗。', proportion: '2:3', adopted: '1989-12-27' },
    'ru': { cca2: 'ru', design: 'A horizontal tricolour of white, blue and red.', designCN: '白色、蓝色和红色的水平三色旗。', proportion: '2:3', adopted: '1993-12-11' },
    'rw': { cca2: 'rw', design: 'A horizontal tricolour of sky blue (double width), yellow and green, with a yellow sun in the upper right.', designCN: '天蓝色（双倍宽）、黄色和绿色的水平三色旗，右上角有黄色太阳。', proportion: '2:3', adopted: '2001-10-25' },
    'kn': { cca2: 'kn', design: 'A diagonal bicolour of green and red, separated by a black stripe with yellow edges, and two white stars.', designCN: '绿色和红色对角双色旗，由带黄色边缘的黑色条纹分隔，有两颗白色星星。', proportion: '2:3', adopted: '1983-09-19' },
    'lc': { cca2: 'lc', design: 'A cerulean blue field with a golden triangle behind a black arrowhead.', designCN: '天蓝色旗帜，黑色箭头后面有金色三角形。', proportion: '1:2', adopted: '2002-02-22' },
    'vc': { cca2: 'vc', design: 'A vertical tricolour of blue, gold and green, with three green diamonds in the center.', designCN: '蓝色、金色和绿色的垂直三色旗，中央有三颗绿色菱形。', proportion: '2:3', adopted: '1985-10-21' },
    'ws': { cca2: 'ws', design: 'A red field with a blue canton containing the Southern Cross.', designCN: '红色旗帜，左上角蓝色方块内有南十字星。', proportion: '1:2', adopted: '1949-02-24' },
    'sm': { cca2: 'sm', design: 'A horizontal bicolour of white and light blue, with the national coat of arms in the center.', designCN: '白色和浅蓝色的水平双色旗，中央有国家徽章。', proportion: '3:4', adopted: '2011-07-22' },
    'st': { cca2: 'st', design: 'A horizontal tricolour of green, yellow (double width) and green, with a red triangle on the left and two black stars.', designCN: '绿色、黄色（双倍宽）和绿色的水平三色旗，左侧有红色三角形和两颗黑色星星。', proportion: '1:2', adopted: '1975-11-05' },
    'sa': { cca2: 'sa', design: 'A green field with the shahada in white Thuluth script and a white sword below.', designCN: '绿色旗帜，有白色苏鲁特体书写的清真言和下方的白色剑。', proportion: '2:3', adopted: '1973-03-15' },
    'sn': { cca2: 'sn', design: 'A vertical tricolour of green, yellow and red, with a green five-pointed star in the center.', designCN: '绿色、黄色和红色的垂直三色旗，中央有绿色五角星。', proportion: '2:3', adopted: '1960-08-20' },
    'rs': { cca2: 'rs', design: 'A horizontal tricolour of red, blue and white, with the national coat of arms off-center to the left.', designCN: '红色、蓝色和白色的水平三色旗，国家徽章位于偏左位置。', proportion: '2:3', adopted: '2010-11-11' },
    'sc': { cca2: 'sc', design: 'Five oblique bands of blue, yellow, red, white and green radiating from the bottom left corner.', designCN: '蓝色、黄色、红色、白色和绿色五条斜带从左下角辐射出来。', proportion: '1:2', adopted: '1996-06-18' },
    'sl': { cca2: 'sl', design: 'A horizontal tricolour of green, white and blue.', designCN: '绿色、白色和蓝色的水平三色旗。', proportion: '2:3', adopted: '1961-04-27' },
    'sg': { cca2: 'sg', design: 'A horizontal bicolour of red and white, with a white crescent and five stars in the upper left.', designCN: '红色和白色的水平双色旗，左上角有白色新月和五颗星星。', proportion: '2:3', adopted: '1959-12-03' },
    'sk': { cca2: 'sk', design: 'A horizontal tricolour of white, blue and red, with the national coat of arms off-center to the left.', designCN: '白色、蓝色和红色的水平三色旗，国家徽章位于偏左位置。', proportion: '2:3', adopted: '1992-09-01' },
    'si': { cca2: 'si', design: 'A horizontal tricolour of white, blue and red, with the national coat of arms in the upper left.', designCN: '白色、蓝色和红色的水平三色旗，左上角有国家徽章。', proportion: '1:2', adopted: '1991-06-25' },
    'sb': { cca2: 'sb', design: 'A diagonal bicolour of blue and green, separated by a thin yellow stripe, with five white stars in the upper left.', designCN: '蓝色和绿色对角双色旗，由细黄色条纹分隔，左上角有五颗白色星星。', proportion: '1:2', adopted: '1977-11-18' },
    'so': { cca2: 'so', design: 'A light blue field with a white five-pointed star in the center.', designCN: '浅蓝色旗帜，中央有一颗白色五角星。', proportion: '2:3', adopted: '2012-08-21' },
    'za': { cca2: 'za', design: 'A horizontal Y-shape of green with white and gold borders, separating red and blue sections with a black triangle on the left.', designCN: '绿色Y形条纹带白色和金色边框，分隔红色和蓝色区域，左侧有黑色三角形。', proportion: '2:3', adopted: '1994-04-27' },
    'ss': { cca2: 'ss', design: 'A horizontal tricolour of black, red and green, separated by white stripes, with a blue triangle on the left containing a yellow star.', designCN: '黑色、红色和绿色的水平三色旗，由白色条纹分隔，左侧蓝色三角形内有黄色星星。', proportion: '1:2', adopted: '2011-07-09' },
    'es': { cca2: 'es', design: 'A horizontal tricolour of red, yellow (double width) and red, with the national coat of arms off-center to the left.', designCN: '红色、黄色（双倍宽）和红色的水平三色旗，国家徽章位于偏左位置。', proportion: '2:3', adopted: '1981-12-19' },
    'lk': { cca2: 'lk', design: 'A gold lion holding a sword on a maroon field, with green and orange vertical stripes on the left.', designCN: '栗色旗帜上有一只握剑的金色狮子，左侧有绿色和橙色垂直条纹。', proportion: '1:2', adopted: '1972-05-22' },
    'sd': { cca2: 'sd', design: 'A horizontal tricolour of red, white and black, with a green triangle on the left.', designCN: '红色、白色和黑色的水平三色旗，左侧有绿色三角形。', proportion: '1:2', adopted: '1970-05-20' },
    'sr': { cca2: 'sr', design: 'A horizontal tricolour of green, white, red (double width), white and green, with a yellow star in the center.', designCN: '绿色、白色、红色（双倍宽）、白色和绿色的水平条纹旗，中央有黄色星星。', proportion: '2:3', adopted: '1975-11-25' },
    'se': { cca2: 'se', design: 'A blue field with a golden Nordic cross.', designCN: '蓝色旗帜上有金色的北欧十字。', proportion: '5:8', adopted: '1906-06-22' },
    'ch': { cca2: 'ch', design: 'A red square with a white Greek cross in the center.', designCN: '红色正方形，中央有白色希腊十字。', proportion: '1:1', adopted: '1841-01-01' },
    'sy': { cca2: 'sy', design: 'A horizontal tricolour of red, white and black, with two green five-pointed stars in the center.', designCN: '红色、白色和黑色的水平三色旗，中央有两颗绿色五角星。', proportion: '2:3', adopted: '1980-03-29' },
    'tj': { cca2: 'tj', design: 'A horizontal tricolour of red, white (1.5 times the width) and green, with a gold crown and seven stars in the center.', designCN: '红色、白色（1.5倍宽）和绿色的水平三色旗，中央有金色王冠和七颗星星。', proportion: '1:2', adopted: '1992-11-24' },
    'tz': { cca2: 'tz', design: 'A diagonal bicolour of green and blue, separated by a black stripe with yellow edges.', designCN: '绿色和蓝色对角双色旗，由带黄色边缘的黑色条纹分隔。', proportion: '2:3', adopted: '1964-06-30' },
    'th': { cca2: 'th', design: 'A horizontal tricolour of red, white, blue (double width), white and red.', designCN: '红色、白色、蓝色（双倍宽）、白色和红色的水平条纹旗。', proportion: '2:3', adopted: '1917-09-28' },
    'tl': { cca2: 'tl', design: 'A red field with black and yellow triangles on the left and a white star in the black triangle.', designCN: '红色旗帜，左侧有黑色和黄色三角形，黑色三角形内有白色星星。', proportion: '1:2', adopted: '2002-05-20' },
    'tg': { cca2: 'tg', design: 'Five horizontal stripes of green and yellow, with a red canton containing a white five-pointed star.', designCN: '绿色和黄色五条水平条纹，左上角红色方块内有白色五角星。', proportion: '3:5', adopted: '1960-04-27' },
    'to': { cca2: 'to', design: 'A red field with a white canton containing a red Greek cross.', designCN: '红色旗帜，左上角白色方块内有红色希腊十字。', proportion: '1:2', adopted: '1875-11-04' },
    'tt': { cca2: 'tt', design: 'A red field with a white-edged black diagonal stripe from the upper left to the lower right.', designCN: '红色旗帜，有一条带白色边缘的黑色对角条纹从左上到右下。', proportion: '3:5', adopted: '1962-08-31' },
    'tn': { cca2: 'tn', design: 'A red field with a white disc in the center containing a red crescent and five-pointed star.', designCN: '红色旗帜，中央白色圆盘内有红色新月和五角星。', proportion: '2:3', adopted: '1999-07-03' },
    'tr': { cca2: 'tr', design: 'A red field with a white crescent and five-pointed star slightly off-center to the left.', designCN: '红色旗帜，略偏左有白色新月和五角星。', proportion: '2:3', adopted: '1936-05-29' },
    'tm': { cca2: 'tm', design: 'A green field with a vertical stripe of carpet patterns on the left and a white crescent with five stars in the center.', designCN: '绿色旗帜，左侧有地毯图案的垂直条纹，中央有白色新月和五颗星星。', proportion: '2:3', adopted: '2001-01-24' },
    'tv': { cca2: 'tv', design: 'A light blue field with the Union Jack in the canton and nine yellow stars representing the islands.', designCN: '浅蓝色旗帜，左上角有英国国旗，九颗黄色星星代表各岛屿。', proportion: '1:2', adopted: '1997-04-11' },
    'ug': { cca2: 'ug', design: 'Six horizontal stripes of black, yellow and red, with a white disc in the center containing a grey crowned crane.', designCN: '黑色、黄色和红色六条水平条纹，中央白色圆盘内有灰色冠鹤。', proportion: '2:3', adopted: '1962-10-09' },
    'ua': { cca2: 'ua', design: 'A horizontal bicolour of blue and yellow.', designCN: '蓝色和黄色的水平双色旗。', proportion: '2:3', adopted: '1992-01-28' },
    'ae': { cca2: 'ae', design: 'A horizontal tricolour of green, white and black, with a vertical red stripe on the left.', designCN: '绿色、白色和黑色的水平三色旗，左侧有红色垂直条纹。', proportion: '1:2', adopted: '1971-12-02' },
    'gb': { cca2: 'gb', design: 'The Union Jack: a combination of the flags of England, Scotland, and Northern Ireland.', designCN: '米字旗：英格兰、苏格兰和北爱尔兰旗帜的组合。', proportion: '1:2', adopted: '1801-01-01' },
    'us': { cca2: 'us', design: 'Thirteen horizontal stripes of red and white, with a blue canton containing fifty white five-pointed stars.', designCN: '红色和白色十三条水平条纹，左上角蓝色方块内有五十颗白色五角星。', proportion: '10:19', adopted: '1960-07-04' },
    'uy': { cca2: 'uy', design: 'Nine horizontal stripes of white and blue, with a white canton containing a golden Sun of May.', designCN: '白色和蓝色九条水平条纹，左上角白色方块内有金色五月太阳。', proportion: '2:3', adopted: '1830-07-11' },
    'uz': { cca2: 'uz', design: 'A horizontal tricolour of blue, white and green, separated by thin red stripes, with a white crescent and twelve stars in the upper left.', designCN: '蓝色、白色和绿色的水平三色旗，由细红色条纹分隔，左上角有白色新月和十二颗星星。', proportion: '1:2', adopted: '1991-11-18' },
    'vu': { cca2: 'vu', design: 'A horizontal bicolour of red and green, with a black triangle on the left containing a yellow Y-shape and a boar tusk emblem.', designCN: '红色和绿色的水平双色旗，左侧黑色三角形内有黄色Y形和野猪獠牙徽章。', proportion: '3:5', adopted: '1980-02-13' },
    'va': { cca2: 'va', design: 'A vertical bicolour of gold and white, with the papal coat of arms on the white half.', designCN: '金色和白色的垂直双色旗，白色部分有教皇徽章。', proportion: '1:1', adopted: '1929-06-07' },
    've': { cca2: 've', design: 'A horizontal tricolour of yellow, blue and red, with eight white stars arranged in an arc on the blue stripe.', designCN: '黄色、蓝色和红色的水平三色旗，蓝色条纹上有八颗白色星星呈弧形排列。', proportion: '2:3', adopted: '2006-03-12' },
    'vn': { cca2: 'vn', design: 'A red field with a large yellow five-pointed star in the center.', designCN: '红色旗帜，中央有一颗大黄色五角星。', proportion: '2:3', adopted: '1955-11-30' },
    'ye': { cca2: 'ye', design: 'A horizontal tricolour of red, white and black.', designCN: '红色、白色和黑色的水平三色旗。', proportion: '2:3', adopted: '1990-05-22' },
    'zm': { cca2: 'zm', design: 'A green field with a red, black and orange vertical stripe on the right and an orange eagle above.', designCN: '绿色旗帜，右侧有红色、黑色和橙色垂直条纹，上方有橙色鹰。', proportion: '2:3', adopted: '1996-01-01' },
    'zw': { cca2: 'zw', design: 'Seven horizontal stripes of green, gold, red, black, red, gold and green, with a white triangle on the left containing a red star and the Zimbabwe Bird.', designCN: '绿色、金色、红色、黑色、红色、金色和绿色七条水平条纹，左侧白色三角形内有红色星星和津巴布韦鸟。', proportion: '1:2', adopted: '1980-04-18' }
};

// 根据国家代码获取国旗设计信息
export function getFlagDesign(code: string): FlagDesign | undefined {
    return FlagDesigns[code.toLowerCase()];
}

// 国际组织代码列表
const INTERNATIONAL_ORGS = ['un', 'eu', 'olympic', 'nato', 'asean', 'au_org', 'arab_league', 'red_cross', 'fiav'];

// 使用PNG格式的国家代码列表（目前为空，所有国家都使用SVG）
const PNG_FLAG_COUNTRIES: string[] = [];

// 根据国家代码获取旗帜图片资源
export function getFlagImageSource(code: string): Resource | string {
    const lowerCode = code.toLowerCase();
    if (INTERNATIONAL_ORGS.includes(lowerCode)) {
        // 国际组织使用PNG图片
        return $r(`app.media.flag_${lowerCode}`);
    } else if (PNG_FLAG_COUNTRIES.includes(lowerCode)) {
        // 指定国家使用PNG图片
        return $r(`app.media.flag_${lowerCode}`);
    } else {
        // 普通国家使用SVG图片
        return $rawfile(`flags/${lowerCode}.svg`);
    }
}

// 国际组织数据列表
export const InternationalOrgs: InternationalOrg[] = [
    {
        code: 'un',
        name: 'United Nations',
        nameCN: '联合国',
        headquarters: 'New York',
        headquartersCN: '纽约',
        region: 'World',
        orgType: 'Intergovernmental Organization',
        orgTypeCN: '政府间组织',
        population: 8000000000,  // 约80亿人
        website: 'https://www.un.org',
        description: '联合国是第二次世界大战后成立的国际组织，致力于维护国际和平与安全、促进国际合作、发展国际法、保护人权。成立于1945年，现有193个会员国。',
        descriptionEN: 'The United Nations is an international organization established after World War II, dedicated to maintaining international peace and security, promoting international cooperation, developing international law, and protecting human rights. Founded in 1945, it currently has 193 member states.'
    },
    {
        code: 'eu',
        name: 'European Union',
        nameCN: '欧盟',
        headquarters: 'Brussels',
        headquartersCN: '布鲁塞尔',
        region: 'Europe',
        orgType: 'Supranational Union',
        orgTypeCN: '超国家联盟',
        population: 447000000,  // 约4.47亿人
        website: 'https://european-union.europa.eu',
        description: '欧盟是由27个欧洲国家组成的政治经济联盟，致力于促进成员国之间的和平、价值观和人民福祉。成立于1993年，拥有统一的货币欧元和共同市场。',
        descriptionEN: 'The European Union is a political and economic union of 27 European countries, dedicated to promoting peace, values, and the well-being of its citizens among member states. Founded in 1993, it features a unified currency (the Euro) and a common market.'
    },
    {
        code: 'olympic',
        name: 'Olympic Games',
        nameCN: '奥林匹克',
        headquarters: 'Lausanne',
        headquartersCN: '洛桑',
        region: 'World',
        orgType: 'Sports Organization',
        orgTypeCN: '体育组织',
        population: 8000000000,  // 全球人口
        website: 'https://olympics.com',
        description: '国际奥林匹克委员会是负责组织和管理奥林匹克运动会的国际组织。成立于1894年，每四年举办一次夏季和冬季奥运会，旨在通过体育促进世界和平与友谊。',
        descriptionEN: 'The International Olympic Committee is the international organization responsible for organizing and managing the Olympic Games. Founded in 1894, it hosts the Summer and Winter Olympics every four years, aiming to promote world peace and friendship through sports.'
    },
    {
        code: 'nato',
        name: 'NATO',
        nameCN: '北约',
        headquarters: 'Brussels',
        headquartersCN: '布鲁塞尔',
        region: 'Europe',
        orgType: 'Military Alliance',
        orgTypeCN: '军事联盟',
        population: 950000000,  // 约9.5亿人
        website: 'https://www.nato.int',
        description: '北大西洋公约组织是北美和欧洲国家组成的军事联盟，成立于1949年。旨在通过政治和军事手段保障成员国的自由和安全，实行集体防御原则。',
        descriptionEN: 'The North Atlantic Treaty Organization is a military alliance of North American and European countries, founded in 1949. It aims to safeguard the freedom and security of its member states through political and military means, implementing the principle of collective defense.'
    },
    {
        code: 'asean',
        name: 'ASEAN',
        nameCN: '东盟',
        headquarters: 'Jakarta',
        headquartersCN: '雅加达',
        region: 'Asia',
        orgType: 'Regional Organization',
        orgTypeCN: '区域组织',
        population: 680000000,  // 约6.8亿人
        website: 'https://asean.org',
        description: '东南亚国家联盟是东南亚10个国家组成的区域组织，成立于1967年。致力于促进区域经济合作、政治安全合作和社会文化合作，维护地区和平与稳定。',
        descriptionEN: 'The Association of Southeast Asian Nations is a regional organization comprising 10 Southeast Asian countries, established in 1967. It is dedicated to promoting regional economic cooperation, political and security cooperation, and socio-cultural cooperation, maintaining regional peace and stability.'
    },
    {
        code: 'au_org',
        name: 'African Union',
        nameCN: '非盟',
        headquarters: 'Addis Ababa',
        headquartersCN: '亚的斯亚贝巴',
        region: 'Africa',
        orgType: 'Regional Organization',
        orgTypeCN: '区域组织',
        population: 1400000000,  // 约14亿人
        website: 'https://au.int',
        description: '非洲联盟是非洲55个成员国组成的区域组织，成立于2002年，前身是非洲统一组织。致力于促进非洲的团结、和平、安全与发展，推动非洲一体化进程。',
        descriptionEN: 'The African Union is a regional organization of 55 African member states, founded in 2002, succeeding the Organization of African Unity. It is dedicated to promoting African unity, peace, security, and development, advancing the African integration process.'
    },
    {
        code: 'arab_league',
        name: 'Arab League',
        nameCN: '阿盟',
        headquarters: 'Cairo',
        headquartersCN: '开罗',
        region: 'Africa',
        orgType: 'Regional Organization',
        orgTypeCN: '区域组织',
        population: 450000000,  // 约4.5亿人
        website: 'https://www.lasportal.org',
        description: '阿拉伯国家联盟是22个阿拉伯国家组成的区域组织，成立于1945年。旨在加强阿拉伯国家之间的合作，协调成员国的政策和活动，维护阿拉伯世界的共同利益。',
        descriptionEN: 'The Arab League is a regional organization of 22 Arab countries, founded in 1945. It aims to strengthen cooperation among Arab states, coordinate member state policies and activities, and safeguard the common interests of the Arab world.'
    },
    {
        code: 'red_cross',
        name: 'Red Cross',
        nameCN: '红十字会',
        headquarters: 'Geneva',
        headquartersCN: '日内瓦',
        region: 'World',
        orgType: 'Humanitarian Organization',
        orgTypeCN: '人道主义组织',
        population: 8000000000,  // 全球人口
        website: 'https://www.icrc.org',
        description: '国际红十字与红新月运动是全球最大的人道主义网络，由国际红十字委员会、红十字会与红新月会国际联合会以及各国红会组成。致力于在武装冲突和自然灾害中保护生命和尊严。',
        descriptionEN: 'The International Red Cross and Red Crescent Movement is the world\'s largest humanitarian network, consisting of the International Committee of the Red Cross, the International Federation of Red Cross and Red Crescent Societies, and national societies. It is dedicated to protecting life and dignity in armed conflicts and natural disasters.'
    },
    {
        code: 'fiav',
        name: 'Fédération internationale des associations vexillologiques',
        nameCN: '旗帜学协会国际联盟',
        headquarters: 'Houston / London',
        headquartersCN: '休斯顿 / 伦敦',
        region: 'World',
        orgType: 'International Association',
        orgTypeCN: '国际协会',
        population: 0,  // 成员协会及组织
        website: 'http://www.fiav.org',
        description: '旗帜学协会国际联盟是致力于旗帜学研究与推广的国际组织，成立于1969年，由惠特尼·史密斯创立。拥有55个成员协会及组织，促进全球旗帜学知识的交流与发展。协会旗帜图案为一个接绳结。',
        descriptionEN: 'The International Federation of Vexillological Associations is an international organization dedicated to the study and promotion of vexillology, founded in 1969 by Whitney Smith. With 55 member associations and organizations, it promotes the exchange and development of vexillological knowledge worldwide. The association flag features a knot.'
    }
];

// 国际组织数据 Map 缓存（优化查找性能，从 O(n) 到 O(1)）
let internationalOrgMapCache: Map<string, InternationalOrg> | null = null;

// 初始化国际组织数据 Map 缓存
function initInternationalOrgMapCache(): void {
    if (internationalOrgMapCache === null) {
        internationalOrgMapCache = new Map();
        for (const org of InternationalOrgs) {
            internationalOrgMapCache.set(org.code.toLowerCase(), org);
        }
    }
}

// 根据代码获取国际组织（使用 Map 缓存优化性能）
export function getInternationalOrgByCode(code: string): InternationalOrg | undefined {
    initInternationalOrgMapCache();
    return internationalOrgMapCache?.get(code.toLowerCase());
}

// 判断是否为国际组织
export function isInternationalOrg(code: string): boolean {
    return INTERNATIONAL_ORGS.includes(code.toLowerCase());
}

