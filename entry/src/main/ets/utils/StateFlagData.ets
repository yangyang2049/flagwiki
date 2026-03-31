// 各国州旗数据

// 州/县/省数据模型
export interface StateInfo {
  code: string;        // 州代码（用于文件名）
  name: string;        // 英文名称
  nameCN: string;      // 中文名称
  capital: string;     // 首府英文
  capitalCN: string;   // 首府中文
  region: string;      // 地区英文
  regionCN: string;    // 地区中文
}

// 国家州旗数据模型
export interface CountryStateData {
  countryCode: string;     // 国家代码
  countryName: string;     // 国家英文名
  countryNameCN: string;   // 国家中文名
  countryEmoji: string;    // 国家emoji
  stateLabel: string;      // 州的称呼（州、县、省等）
  states: StateInfo[];     // 州列表
}

// 澳大利亚州数据
const australiaStates: StateInfo[] = [
  { code: 'New South Wales', name: 'New South Wales', nameCN: '新南威尔士州', capital: 'Sydney', capitalCN: '悉尼', region: 'Southeast', regionCN: '东南部' },
  { code: 'Victoria', name: 'Victoria', nameCN: '维多利亚州', capital: 'Melbourne', capitalCN: '墨尔本', region: 'Southeast', regionCN: '东南部' },
  { code: 'Queensland', name: 'Queensland', nameCN: '昆士兰州', capital: 'Brisbane', capitalCN: '布里斯班', region: 'Northeast', regionCN: '东北部' },
  { code: 'Western Australia', name: 'Western Australia', nameCN: '西澳大利亚州', capital: 'Perth', capitalCN: '珀斯', region: 'West', regionCN: '西部' },
  { code: 'South Australia', name: 'South Australia', nameCN: '南澳大利亚州', capital: 'Adelaide', capitalCN: '阿德莱德', region: 'Central South', regionCN: '中南部' },
  { code: 'Tasmania', name: 'Tasmania', nameCN: '塔斯马尼亚州', capital: 'Hobart', capitalCN: '霍巴特', region: 'South', regionCN: '南部' },
  { code: 'Northern Territory', name: 'Northern Territory', nameCN: '北领地', capital: 'Darwin', capitalCN: '达尔文', region: 'North', regionCN: '北部' },
  { code: 'Australian Capital Territory', name: 'Australian Capital Territory', nameCN: '首都领地', capital: 'Canberra', capitalCN: '堪培拉', region: 'Southeast', regionCN: '东南部' },
  { code: 'Norfolk Island', name: 'Norfolk Island', nameCN: '诺福克岛', capital: 'Kingston', capitalCN: '金斯敦', region: 'External', regionCN: '外部领地' }
];

// 巴西州数据
const brazilStates: StateInfo[] = [
  { code: 'Acre', name: 'Acre', nameCN: '阿克里', capital: 'Rio Branco', capitalCN: '里奥布朗库', region: 'North', regionCN: '北部' },
  { code: 'Alagoas', name: 'Alagoas', nameCN: '阿拉戈斯', capital: 'Maceió', capitalCN: '马塞约', region: 'Northeast', regionCN: '东北部' },
  { code: 'Amapá', name: 'Amapá', nameCN: '阿马帕', capital: 'Macapá', capitalCN: '马卡帕', region: 'North', regionCN: '北部' },
  { code: 'Amazonas', name: 'Amazonas', nameCN: '亚马逊', capital: 'Manaus', capitalCN: '马瑙斯', region: 'North', regionCN: '北部' },
  { code: 'Bahia', name: 'Bahia', nameCN: '巴伊亚', capital: 'Salvador', capitalCN: '萨尔瓦多', region: 'Northeast', regionCN: '东北部' },
  { code: 'Ceará', name: 'Ceará', nameCN: '塞阿拉', capital: 'Fortaleza', capitalCN: '福塔雷萨', region: 'Northeast', regionCN: '东北部' },
  { code: 'Distrito Federal', name: 'Distrito Federal', nameCN: '联邦区', capital: 'Brasília', capitalCN: '巴西利亚', region: 'Central-West', regionCN: '中西部' },
  { code: 'Espírito Santo', name: 'Espírito Santo', nameCN: '圣埃斯皮里图', capital: 'Vitória', capitalCN: '维多利亚', region: 'Southeast', regionCN: '东南部' },
  { code: 'Goiás', name: 'Goiás', nameCN: '戈亚斯', capital: 'Goiânia', capitalCN: '戈亚尼亚', region: 'Central-West', regionCN: '中西部' },
  { code: 'Maranhão', name: 'Maranhão', nameCN: '马拉尼昂', capital: 'São Luís', capitalCN: '圣路易斯', region: 'Northeast', regionCN: '东北部' },
  { code: 'Mato Grosso', name: 'Mato Grosso', nameCN: '马托格罗索', capital: 'Cuiabá', capitalCN: '库亚巴', region: 'Central-West', regionCN: '中西部' },
  { code: 'Mato Grosso do Sul', name: 'Mato Grosso do Sul', nameCN: '南马托格罗索', capital: 'Campo Grande', capitalCN: '大坎普', region: 'Central-West', regionCN: '中西部' },
  { code: 'Minas Gerais', name: 'Minas Gerais', nameCN: '米纳斯吉拉斯', capital: 'Belo Horizonte', capitalCN: '贝洛奥里藏特', region: 'Southeast', regionCN: '东南部' },
  { code: 'Pará', name: 'Pará', nameCN: '帕拉', capital: 'Belém', capitalCN: '贝伦', region: 'North', regionCN: '北部' },
  { code: 'Paraíba', name: 'Paraíba', nameCN: '帕拉伊巴', capital: 'João Pessoa', capitalCN: '若昂佩索阿', region: 'Northeast', regionCN: '东北部' },
  { code: 'Paraná', name: 'Paraná', nameCN: '巴拉那', capital: 'Curitiba', capitalCN: '库里蒂巴', region: 'South', regionCN: '南部' },
  { code: 'Pernambuco', name: 'Pernambuco', nameCN: '伯南布哥', capital: 'Recife', capitalCN: '累西腓', region: 'Northeast', regionCN: '东北部' },
  { code: 'Piauí', name: 'Piauí', nameCN: '皮奥伊', capital: 'Teresina', capitalCN: '特雷西纳', region: 'Northeast', regionCN: '东北部' },
  { code: 'Rio de Janeiro', name: 'Rio de Janeiro', nameCN: '里约热内卢', capital: 'Rio de Janeiro', capitalCN: '里约热内卢', region: 'Southeast', regionCN: '东南部' },
  { code: 'Rio Grande do Norte', name: 'Rio Grande do Norte', nameCN: '北里奥格兰德', capital: 'Natal', capitalCN: '纳塔尔', region: 'Northeast', regionCN: '东北部' },
  { code: 'Rio Grande do Sul', name: 'Rio Grande do Sul', nameCN: '南里奥格兰德', capital: 'Porto Alegre', capitalCN: '阿雷格里港', region: 'South', regionCN: '南部' },
  { code: 'Rondônia', name: 'Rondônia', nameCN: '朗多尼亚', capital: 'Porto Velho', capitalCN: '韦柳港', region: 'North', regionCN: '北部' },
  { code: 'Roraima', name: 'Roraima', nameCN: '罗赖马', capital: 'Boa Vista', capitalCN: '博阿维斯塔', region: 'North', regionCN: '北部' },
  { code: 'Santa Catarina', name: 'Santa Catarina', nameCN: '圣卡塔琳娜', capital: 'Florianópolis', capitalCN: '弗洛里亚诺波利斯', region: 'South', regionCN: '南部' },
  { code: 'São Paulo', name: 'São Paulo', nameCN: '圣保罗', capital: 'São Paulo', capitalCN: '圣保罗', region: 'Southeast', regionCN: '东南部' },
  { code: 'Sergipe', name: 'Sergipe', nameCN: '塞尔希培', capital: 'Aracaju', capitalCN: '阿拉卡茹', region: 'Northeast', regionCN: '东北部' },
  { code: 'Tocantins', name: 'Tocantins', nameCN: '托坎廷斯', capital: 'Palmas', capitalCN: '帕尔马斯', region: 'North', regionCN: '北部' }
];

// 加拿大省数据
const canadaStates: StateInfo[] = [
  { code: 'Alberta', name: 'Alberta', nameCN: '阿尔伯塔省', capital: 'Edmonton', capitalCN: '埃德蒙顿', region: 'Western', regionCN: '西部' },
  { code: 'British Columbia', name: 'British Columbia', nameCN: '不列颠哥伦比亚省', capital: 'Victoria', capitalCN: '维多利亚', region: 'Western', regionCN: '西部' },
  { code: 'Manitoba', name: 'Manitoba', nameCN: '马尼托巴省', capital: 'Winnipeg', capitalCN: '温尼伯', region: 'Central', regionCN: '中部' },
  { code: 'New Brunswick', name: 'New Brunswick', nameCN: '新不伦瑞克省', capital: 'Fredericton', capitalCN: '弗雷德里克顿', region: 'Atlantic', regionCN: '大西洋' },
  { code: 'Newfoundland and Labrador', name: 'Newfoundland and Labrador', nameCN: '纽芬兰与拉布拉多省', capital: "St. John's", capitalCN: '圣约翰斯', region: 'Atlantic', regionCN: '大西洋' },
  { code: 'Northwest Territories', name: 'Northwest Territories', nameCN: '西北地区', capital: 'Yellowknife', capitalCN: '黄刀镇', region: 'Northern', regionCN: '北部' },
  { code: 'Nova Scotia', name: 'Nova Scotia', nameCN: '新斯科舍省', capital: 'Halifax', capitalCN: '哈利法克斯', region: 'Atlantic', regionCN: '大西洋' },
  { code: 'Nunavut', name: 'Nunavut', nameCN: '努纳武特', capital: 'Iqaluit', capitalCN: '伊魁特', region: 'Northern', regionCN: '北部' },
  { code: 'Ontario', name: 'Ontario', nameCN: '安大略省', capital: 'Toronto', capitalCN: '多伦多', region: 'Central', regionCN: '中部' },
  { code: 'Prince Edward Island', name: 'Prince Edward Island', nameCN: '爱德华王子岛省', capital: 'Charlottetown', capitalCN: '夏洛特敦', region: 'Atlantic', regionCN: '大西洋' },
  { code: 'Quebec', name: 'Quebec', nameCN: '魁北克省', capital: 'Quebec City', capitalCN: '魁北克城', region: 'Eastern', regionCN: '东部' },
  { code: 'Saskatchewan', name: 'Saskatchewan', nameCN: '萨斯喀彻温省', capital: 'Regina', capitalCN: '里贾纳', region: 'Central', regionCN: '中部' },
  { code: 'Yukon', name: 'Yukon', nameCN: '育空地区', capital: 'Whitehorse', capitalCN: '怀特霍斯', region: 'Northern', regionCN: '北部' }
];

// 韩国行政区数据
const koreaStates: StateInfo[] = [
  { code: 'Seoul', name: 'Seoul', nameCN: '首尔特别市', capital: 'Seoul', capitalCN: '首尔', region: 'Capital Area', regionCN: '首都圈' },
  { code: 'Sejong', name: 'Sejong', nameCN: '世宗特别自治市', capital: 'Sejong', capitalCN: '世宗', region: 'Hoseo', regionCN: '湖西' },
  { code: 'Busan', name: 'Busan', nameCN: '釜山广域市', capital: 'Busan', capitalCN: '釜山', region: 'Yeongnam', regionCN: '岭南' },
  { code: 'Daegu', name: 'Daegu', nameCN: '大邱广域市', capital: 'Daegu', capitalCN: '大邱', region: 'Yeongnam', regionCN: '岭南' },
  { code: 'Incheon', name: 'Incheon', nameCN: '仁川广域市', capital: 'Incheon', capitalCN: '仁川', region: 'Capital Area', regionCN: '首都圈' },
  { code: 'Gwangju', name: 'Gwangju', nameCN: '光州广域市', capital: 'Gwangju', capitalCN: '光州', region: 'Honam', regionCN: '湖南' },
  { code: 'Daejeon', name: 'Daejeon', nameCN: '大田广域市', capital: 'Daejeon', capitalCN: '大田', region: 'Hoseo', regionCN: '湖西' },
  { code: 'Ulsan', name: 'Ulsan', nameCN: '蔚山广域市', capital: 'Ulsan', capitalCN: '蔚山', region: 'Yeongnam', regionCN: '岭南' },
  { code: 'Gyeonggi', name: 'Gyeonggi', nameCN: '京畿道', capital: 'Suwon', capitalCN: '水原', region: 'Capital Area', regionCN: '首都圈' },
  { code: 'Gangwon', name: 'Gangwon', nameCN: '江原道', capital: 'Chuncheon', capitalCN: '春川', region: 'Gwandong', regionCN: '关东' },
  { code: 'North Chungcheong', name: 'North Chungcheong', nameCN: '忠清北道', capital: 'Cheongju', capitalCN: '清州', region: 'Hoseo', regionCN: '湖西' },
  { code: 'South Chungcheong', name: 'South Chungcheong', nameCN: '忠清南道', capital: 'Hongseong', capitalCN: '洪城', region: 'Hoseo', regionCN: '湖西' },
  { code: 'North Jeolla', name: 'North Jeolla', nameCN: '全罗北道', capital: 'Jeonju', capitalCN: '全州', region: 'Honam', regionCN: '湖南' },
  { code: 'South Jeolla', name: 'South Jeolla', nameCN: '全罗南道', capital: 'Muan', capitalCN: '务安', region: 'Honam', regionCN: '湖南' },
  { code: 'North Gyeongsang', name: 'North Gyeongsang', nameCN: '庆尚北道', capital: 'Andong', capitalCN: '安东', region: 'Yeongnam', regionCN: '岭南' },
  { code: 'South Gyeongsang', name: 'South Gyeongsang', nameCN: '庆尚南道', capital: 'Changwon', capitalCN: '昌原', region: 'Yeongnam', regionCN: '岭南' },
  { code: 'Jeju', name: 'Jeju', nameCN: '济州特别自治道', capital: 'Jeju City', capitalCN: '济州市', region: 'Jeju', regionCN: '济州' }
];

// 日本都道府县数据
const japanStates: StateInfo[] = [
  { code: 'Hokkaido', name: 'Hokkaido', nameCN: '北海道', capital: 'Sapporo', capitalCN: '札幌', region: 'Hokkaido', regionCN: '北海道' },
  { code: 'Aomori', name: 'Aomori', nameCN: '青森县', capital: 'Aomori', capitalCN: '青森', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Iwate', name: 'Iwate', nameCN: '岩手县', capital: 'Morioka', capitalCN: '盛冈', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Miyagi', name: 'Miyagi', nameCN: '宫城县', capital: 'Sendai', capitalCN: '仙台', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Akita', name: 'Akita', nameCN: '秋田县', capital: 'Akita', capitalCN: '秋田', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Yamagata', name: 'Yamagata', nameCN: '山形县', capital: 'Yamagata', capitalCN: '山形', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Fukushima', name: 'Fukushima', nameCN: '福岛县', capital: 'Fukushima', capitalCN: '福岛', region: 'Tōhoku', regionCN: '东北' },
  { code: 'Ibaraki', name: 'Ibaraki', nameCN: '茨城县', capital: 'Mito', capitalCN: '水户', region: 'Kantō', regionCN: '关东' },
  { code: 'Tochigi', name: 'Tochigi', nameCN: '栃木县', capital: 'Utsunomiya', capitalCN: '宇都宫', region: 'Kantō', regionCN: '关东' },
  { code: 'Gunma', name: 'Gunma', nameCN: '群马县', capital: 'Maebashi', capitalCN: '前桥', region: 'Kantō', regionCN: '关东' },
  { code: 'Saitama', name: 'Saitama', nameCN: '埼玉县', capital: 'Saitama', capitalCN: '埼玉', region: 'Kantō', regionCN: '关东' },
  { code: 'Chiba', name: 'Chiba', nameCN: '千叶县', capital: 'Chiba', capitalCN: '千叶', region: 'Kantō', regionCN: '关东' },
  { code: 'Tokyo', name: 'Tokyo', nameCN: '东京都', capital: 'Tokyo', capitalCN: '东京', region: 'Kantō', regionCN: '关东' },
  { code: 'Kanagawa', name: 'Kanagawa', nameCN: '神奈川县', capital: 'Yokohama', capitalCN: '横滨', region: 'Kantō', regionCN: '关东' },
  { code: 'Niigata', name: 'Niigata', nameCN: '新潟县', capital: 'Niigata', capitalCN: '新潟', region: 'Chūbu', regionCN: '中部' },
  { code: 'Toyama', name: 'Toyama', nameCN: '富山县', capital: 'Toyama', capitalCN: '富山', region: 'Chūbu', regionCN: '中部' },
  { code: 'Ishikawa', name: 'Ishikawa', nameCN: '石川县', capital: 'Kanazawa', capitalCN: '金泽', region: 'Chūbu', regionCN: '中部' },
  { code: 'Fukui', name: 'Fukui', nameCN: '福井县', capital: 'Fukui', capitalCN: '福井', region: 'Chūbu', regionCN: '中部' },
  { code: 'Yamanashi', name: 'Yamanashi', nameCN: '山梨县', capital: 'Kōfu', capitalCN: '甲府', region: 'Chūbu', regionCN: '中部' },
  { code: 'Nagano', name: 'Nagano', nameCN: '长野县', capital: 'Nagano', capitalCN: '长野', region: 'Chūbu', regionCN: '中部' },
  { code: 'Gifu', name: 'Gifu', nameCN: '岐阜县', capital: 'Gifu', capitalCN: '岐阜', region: 'Chūbu', regionCN: '中部' },
  { code: 'Shizuoka', name: 'Shizuoka', nameCN: '静冈县', capital: 'Shizuoka', capitalCN: '静冈', region: 'Chūbu', regionCN: '中部' },
  { code: 'Aichi', name: 'Aichi', nameCN: '爱知县', capital: 'Nagoya', capitalCN: '名古屋', region: 'Chūbu', regionCN: '中部' },
  { code: 'Mie', name: 'Mie', nameCN: '三重县', capital: 'Tsu', capitalCN: '津', region: 'Kansai', regionCN: '关西' },
  { code: 'Shiga', name: 'Shiga', nameCN: '滋贺县', capital: 'Ōtsu', capitalCN: '大津', region: 'Kansai', regionCN: '关西' },
  { code: 'Kyoto', name: 'Kyoto', nameCN: '京都府', capital: 'Kyoto', capitalCN: '京都', region: 'Kansai', regionCN: '关西' },
  { code: 'Osaka', name: 'Osaka', nameCN: '大阪府', capital: 'Osaka', capitalCN: '大阪', region: 'Kansai', regionCN: '关西' },
  { code: 'Hyogo', name: 'Hyogo', nameCN: '兵库县', capital: 'Kōbe', capitalCN: '神户', region: 'Kansai', regionCN: '关西' },
  { code: 'Nara', name: 'Nara', nameCN: '奈良县', capital: 'Nara', capitalCN: '奈良', region: 'Kansai', regionCN: '关西' },
  { code: 'Wakayama', name: 'Wakayama', nameCN: '和歌山县', capital: 'Wakayama', capitalCN: '和歌山', region: 'Kansai', regionCN: '关西' },
  { code: 'Tottori', name: 'Tottori', nameCN: '鸟取县', capital: 'Tottori', capitalCN: '鸟取', region: 'Chūgoku', regionCN: '中国' },
  { code: 'Shimane', name: 'Shimane', nameCN: '岛根县', capital: 'Matsue', capitalCN: '松江', region: 'Chūgoku', regionCN: '中国' },
  { code: 'Okayama', name: 'Okayama', nameCN: '冈山县', capital: 'Okayama', capitalCN: '冈山', region: 'Chūgoku', regionCN: '中国' },
  { code: 'Hiroshima', name: 'Hiroshima', nameCN: '广岛县', capital: 'Hiroshima', capitalCN: '广岛', region: 'Chūgoku', regionCN: '中国' },
  { code: 'Yamaguchi', name: 'Yamaguchi', nameCN: '山口县', capital: 'Yamaguchi', capitalCN: '山口', region: 'Chūgoku', regionCN: '中国' },
  { code: 'Tokushima', name: 'Tokushima', nameCN: '德岛县', capital: 'Tokushima', capitalCN: '德岛', region: 'Shikoku', regionCN: '四国' },
  { code: 'Kagawa', name: 'Kagawa', nameCN: '香川县', capital: 'Takamatsu', capitalCN: '高松', region: 'Shikoku', regionCN: '四国' },
  { code: 'Ehime', name: 'Ehime', nameCN: '爱媛县', capital: 'Matsuyama', capitalCN: '松山', region: 'Shikoku', regionCN: '四国' },
  { code: 'Kochi', name: 'Kochi', nameCN: '高知县', capital: 'Kōchi', capitalCN: '高知', region: 'Shikoku', regionCN: '四国' },
  { code: 'Fukuoka', name: 'Fukuoka', nameCN: '福冈县', capital: 'Fukuoka', capitalCN: '福冈', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Saga', name: 'Saga', nameCN: '佐贺县', capital: 'Saga', capitalCN: '佐贺', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Nagasaki', name: 'Nagasaki', nameCN: '长崎县', capital: 'Nagasaki', capitalCN: '长崎', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Kumamoto', name: 'Kumamoto', nameCN: '熊本县', capital: 'Kumamoto', capitalCN: '熊本', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Oita', name: 'Oita', nameCN: '大分县', capital: 'Ōita', capitalCN: '大分', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Miyazaki', name: 'Miyazaki', nameCN: '宫崎县', capital: 'Miyazaki', capitalCN: '宫崎', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Kagoshima', name: 'Kagoshima', nameCN: '鹿儿岛县', capital: 'Kagoshima', capitalCN: '鹿儿岛', region: 'Kyūshū', regionCN: '九州' },
  { code: 'Okinawa', name: 'Okinawa', nameCN: '冲绳县', capital: 'Naha', capitalCN: '那霸', region: 'Kyūshū', regionCN: '九州' }
];

// 美国各州数据
const usStates: StateInfo[] = [
  { code: 'Alabama', name: 'Alabama', nameCN: '阿拉巴马州', capital: 'Montgomery', capitalCN: '蒙哥马利', region: 'South', regionCN: '南部' },
  { code: 'Alaska', name: 'Alaska', nameCN: '阿拉斯加州', capital: 'Juneau', capitalCN: '朱诺', region: 'West', regionCN: '西部' },
  { code: 'Arizona', name: 'Arizona', nameCN: '亚利桑那州', capital: 'Phoenix', capitalCN: '凤凰城', region: 'West', regionCN: '西部' },
  { code: 'Arkansas', name: 'Arkansas', nameCN: '阿肯色州', capital: 'Little Rock', capitalCN: '小石城', region: 'South', regionCN: '南部' },
  { code: 'California', name: 'California', nameCN: '加利福尼亚州', capital: 'Sacramento', capitalCN: '萨克拉门托', region: 'West', regionCN: '西部' },
  { code: 'Colorado', name: 'Colorado', nameCN: '科罗拉多州', capital: 'Denver', capitalCN: '丹佛', region: 'West', regionCN: '西部' },
  { code: 'Connecticut', name: 'Connecticut', nameCN: '康涅狄格州', capital: 'Hartford', capitalCN: '哈特福德', region: 'Northeast', regionCN: '东北部' },
  { code: 'Delaware', name: 'Delaware', nameCN: '特拉华州', capital: 'Dover', capitalCN: '多佛', region: 'South', regionCN: '南部' },
  { code: 'Florida', name: 'Florida', nameCN: '佛罗里达州', capital: 'Tallahassee', capitalCN: '塔拉哈西', region: 'South', regionCN: '南部' },
  { code: 'Georgia', name: 'Georgia', nameCN: '佐治亚州', capital: 'Atlanta', capitalCN: '亚特兰大', region: 'South', regionCN: '南部' },
  { code: 'Hawaii', name: 'Hawaii', nameCN: '夏威夷州', capital: 'Honolulu', capitalCN: '檀香山', region: 'West', regionCN: '西部' },
  { code: 'Idaho', name: 'Idaho', nameCN: '爱达荷州', capital: 'Boise', capitalCN: '博伊西', region: 'West', regionCN: '西部' },
  { code: 'Illinois', name: 'Illinois', nameCN: '伊利诺伊州', capital: 'Springfield', capitalCN: '斯普林菲尔德', region: 'Midwest', regionCN: '中西部' },
  { code: 'Indiana', name: 'Indiana', nameCN: '印第安纳州', capital: 'Indianapolis', capitalCN: '印第安纳波利斯', region: 'Midwest', regionCN: '中西部' },
  { code: 'Iowa', name: 'Iowa', nameCN: '艾奥瓦州', capital: 'Des Moines', capitalCN: '得梅因', region: 'Midwest', regionCN: '中西部' },
  { code: 'Kansas', name: 'Kansas', nameCN: '堪萨斯州', capital: 'Topeka', capitalCN: '托皮卡', region: 'Midwest', regionCN: '中西部' },
  { code: 'Kentucky', name: 'Kentucky', nameCN: '肯塔基州', capital: 'Frankfort', capitalCN: '法兰克福', region: 'South', regionCN: '南部' },
  { code: 'Louisiana', name: 'Louisiana', nameCN: '路易斯安那州', capital: 'Baton Rouge', capitalCN: '巴吞鲁日', region: 'South', regionCN: '南部' },
  { code: 'Maine', name: 'Maine', nameCN: '缅因州', capital: 'Augusta', capitalCN: '奥古斯塔', region: 'Northeast', regionCN: '东北部' },
  { code: 'Maryland', name: 'Maryland', nameCN: '马里兰州', capital: 'Annapolis', capitalCN: '安纳波利斯', region: 'South', regionCN: '南部' },
  { code: 'Massachusetts', name: 'Massachusetts', nameCN: '马萨诸塞州', capital: 'Boston', capitalCN: '波士顿', region: 'Northeast', regionCN: '东北部' },
  { code: 'Michigan', name: 'Michigan', nameCN: '密歇根州', capital: 'Lansing', capitalCN: '兰辛', region: 'Midwest', regionCN: '中西部' },
  { code: 'Minnesota', name: 'Minnesota', nameCN: '明尼苏达州', capital: 'Saint Paul', capitalCN: '圣保罗', region: 'Midwest', regionCN: '中西部' },
  { code: 'Mississippi', name: 'Mississippi', nameCN: '密西西比州', capital: 'Jackson', capitalCN: '杰克逊', region: 'South', regionCN: '南部' },
  { code: 'Missouri', name: 'Missouri', nameCN: '密苏里州', capital: 'Jefferson City', capitalCN: '杰斐逊城', region: 'Midwest', regionCN: '中西部' },
  { code: 'Montana', name: 'Montana', nameCN: '蒙大拿州', capital: 'Helena', capitalCN: '海伦娜', region: 'West', regionCN: '西部' },
  { code: 'Nebraska', name: 'Nebraska', nameCN: '内布拉斯加州', capital: 'Lincoln', capitalCN: '林肯', region: 'Midwest', regionCN: '中西部' },
  { code: 'Nevada', name: 'Nevada', nameCN: '内华达州', capital: 'Carson City', capitalCN: '卡森城', region: 'West', regionCN: '西部' },
  { code: 'New Hampshire', name: 'New Hampshire', nameCN: '新罕布什尔州', capital: 'Concord', capitalCN: '康科德', region: 'Northeast', regionCN: '东北部' },
  { code: 'New Jersey', name: 'New Jersey', nameCN: '新泽西州', capital: 'Trenton', capitalCN: '特伦顿', region: 'Northeast', regionCN: '东北部' },
  { code: 'New Mexico', name: 'New Mexico', nameCN: '新墨西哥州', capital: 'Santa Fe', capitalCN: '圣菲', region: 'West', regionCN: '西部' },
  { code: 'New York', name: 'New York', nameCN: '纽约州', capital: 'Albany', capitalCN: '奥尔巴尼', region: 'Northeast', regionCN: '东北部' },
  { code: 'North Carolina', name: 'North Carolina', nameCN: '北卡罗来纳州', capital: 'Raleigh', capitalCN: '罗利', region: 'South', regionCN: '南部' },
  { code: 'North Dakota', name: 'North Dakota', nameCN: '北达科他州', capital: 'Bismarck', capitalCN: '俾斯麦', region: 'Midwest', regionCN: '中西部' },
  { code: 'Ohio', name: 'Ohio', nameCN: '俄亥俄州', capital: 'Columbus', capitalCN: '哥伦布', region: 'Midwest', regionCN: '中西部' },
  { code: 'Oklahoma', name: 'Oklahoma', nameCN: '俄克拉荷马州', capital: 'Oklahoma City', capitalCN: '俄克拉荷马城', region: 'South', regionCN: '南部' },
  { code: 'Oregon', name: 'Oregon', nameCN: '俄勒冈州', capital: 'Salem', capitalCN: '塞勒姆', region: 'West', regionCN: '西部' },
  { code: 'Pennsylvania', name: 'Pennsylvania', nameCN: '宾夕法尼亚州', capital: 'Harrisburg', capitalCN: '哈里斯堡', region: 'Northeast', regionCN: '东北部' },
  { code: 'Rhode Island', name: 'Rhode Island', nameCN: '罗德岛州', capital: 'Providence', capitalCN: '普罗维登斯', region: 'Northeast', regionCN: '东北部' },
  { code: 'South Carolina', name: 'South Carolina', nameCN: '南卡罗来纳州', capital: 'Columbia', capitalCN: '哥伦比亚', region: 'South', regionCN: '南部' },
  { code: 'South Dakota', name: 'South Dakota', nameCN: '南达科他州', capital: 'Pierre', capitalCN: '皮尔', region: 'Midwest', regionCN: '中西部' },
  { code: 'Tennessee', name: 'Tennessee', nameCN: '田纳西州', capital: 'Nashville', capitalCN: '纳什维尔', region: 'South', regionCN: '南部' },
  { code: 'Texas', name: 'Texas', nameCN: '德克萨斯州', capital: 'Austin', capitalCN: '奥斯汀', region: 'South', regionCN: '南部' },
  { code: 'Utah', name: 'Utah', nameCN: '犹他州', capital: 'Salt Lake City', capitalCN: '盐湖城', region: 'West', regionCN: '西部' },
  { code: 'Vermont', name: 'Vermont', nameCN: '佛蒙特州', capital: 'Montpelier', capitalCN: '蒙彼利埃', region: 'Northeast', regionCN: '东北部' },
  { code: 'Virginia', name: 'Virginia', nameCN: '弗吉尼亚州', capital: 'Richmond', capitalCN: '里士满', region: 'South', regionCN: '南部' },
  { code: 'Washington', name: 'Washington', nameCN: '华盛顿州', capital: 'Olympia', capitalCN: '奥林匹亚', region: 'West', regionCN: '西部' },
  { code: 'West Virginia', name: 'West Virginia', nameCN: '西弗吉尼亚州', capital: 'Charleston', capitalCN: '查尔斯顿', region: 'South', regionCN: '南部' },
  { code: 'Wisconsin', name: 'Wisconsin', nameCN: '威斯康星州', capital: 'Madison', capitalCN: '麦迪逊', region: 'Midwest', regionCN: '中西部' },
  { code: 'Wyoming', name: 'Wyoming', nameCN: '怀俄明州', capital: 'Cheyenne', capitalCN: '夏延', region: 'West', regionCN: '西部' }
];

// 德国各州数据
const germanyStates: StateInfo[] = [
  { code: 'Baden-Württemberg', name: 'Baden-Württemberg', nameCN: '巴登-符腾堡', capital: 'Stuttgart', capitalCN: '斯图加特', region: 'South', regionCN: '南部' },
  { code: 'Bavaria', name: 'Bavaria', nameCN: '巴伐利亚', capital: 'Munich', capitalCN: '慕尼黑', region: 'South', regionCN: '南部' },
  { code: 'Berlin', name: 'Berlin', nameCN: '柏林', capital: 'Berlin', capitalCN: '柏林', region: 'East', regionCN: '东部' },
  { code: 'Brandenburg', name: 'Brandenburg', nameCN: '勃兰登堡', capital: 'Potsdam', capitalCN: '波茨坦', region: 'East', regionCN: '东部' },
  { code: 'Bremen', name: 'Bremen', nameCN: '不来梅', capital: 'Bremen', capitalCN: '不来梅', region: 'North', regionCN: '北部' },
  { code: 'Hamburg', name: 'Hamburg', nameCN: '汉堡', capital: 'Hamburg', capitalCN: '汉堡', region: 'North', regionCN: '北部' },
  { code: 'Hesse', name: 'Hesse', nameCN: '黑森', capital: 'Wiesbaden', capitalCN: '威斯巴登', region: 'Central', regionCN: '中部' },
  { code: 'Lower Saxony', name: 'Lower Saxony', nameCN: '下萨克森', capital: 'Hanover', capitalCN: '汉诺威', region: 'North', regionCN: '北部' },
  { code: 'Mecklenburg-Vorpommern', name: 'Mecklenburg-Vorpommern', nameCN: '梅克伦堡-前波美拉尼亚', capital: 'Schwerin', capitalCN: '什未林', region: 'North', regionCN: '北部' },
  { code: 'North Rhine-Westphalia', name: 'North Rhine-Westphalia', nameCN: '北莱茵-威斯特法伦', capital: 'Düsseldorf', capitalCN: '杜塞尔多夫', region: 'West', regionCN: '西部' },
  { code: 'Rhineland-Palatinate', name: 'Rhineland-Palatinate', nameCN: '莱茵兰-普法尔茨', capital: 'Mainz', capitalCN: '美因茨', region: 'West', regionCN: '西部' },
  { code: 'Saarland', name: 'Saarland', nameCN: '萨尔', capital: 'Saarbrücken', capitalCN: '萨尔布吕肯', region: 'West', regionCN: '西部' },
  { code: 'Saxony', name: 'Saxony', nameCN: '萨克森', capital: 'Dresden', capitalCN: '德累斯顿', region: 'East', regionCN: '东部' },
  { code: 'Saxony-Anhalt', name: 'Saxony-Anhalt', nameCN: '萨克森-安哈尔特', capital: 'Magdeburg', capitalCN: '马格德堡', region: 'East', regionCN: '东部' },
  { code: 'Schleswig-Holstein', name: 'Schleswig-Holstein', nameCN: '石勒苏益格-荷尔斯泰因', capital: 'Kiel', capitalCN: '基尔', region: 'North', regionCN: '北部' },
  { code: 'Thuringia', name: 'Thuringia', nameCN: '图林根', capital: 'Erfurt', capitalCN: '埃尔福特', region: 'East', regionCN: '东部' }
];

// 瑞士各州数据
const switzerlandStates: StateInfo[] = [
  { code: 'Aargau', name: 'Aargau', nameCN: '阿尔高', capital: 'Aarau', capitalCN: '阿劳', region: 'German', regionCN: '德语区' },
  { code: 'Appenzell Ausserrhoden', name: 'Appenzell Ausserrhoden', nameCN: '外阿彭策尔', capital: 'Herisau', capitalCN: '黑里绍', region: 'German', regionCN: '德语区' },
  { code: 'Appenzell Innerrhoden', name: 'Appenzell Innerrhoden', nameCN: '内阿彭策尔', capital: 'Appenzell', capitalCN: '阿彭策尔', region: 'German', regionCN: '德语区' },
  { code: 'Basel-Landschaft', name: 'Basel-Landschaft', nameCN: '巴塞尔乡村', capital: 'Liestal', capitalCN: '利斯塔尔', region: 'German', regionCN: '德语区' },
  { code: 'Basel-Stadt', name: 'Basel-Stadt', nameCN: '巴塞尔城市', capital: 'Basel', capitalCN: '巴塞尔', region: 'German', regionCN: '德语区' },
  { code: 'Bern', name: 'Bern', nameCN: '伯尔尼', capital: 'Bern', capitalCN: '伯尔尼', region: 'German', regionCN: '德语区' },
  { code: 'Fribourg', name: 'Fribourg', nameCN: '弗里堡', capital: 'Fribourg', capitalCN: '弗里堡', region: 'French', regionCN: '法语区' },
  { code: 'Geneva', name: 'Geneva', nameCN: '日内瓦', capital: 'Geneva', capitalCN: '日内瓦', region: 'French', regionCN: '法语区' },
  { code: 'Glarus', name: 'Glarus', nameCN: '格拉鲁斯', capital: 'Glarus', capitalCN: '格拉鲁斯', region: 'German', regionCN: '德语区' },
  { code: 'Graubünden', name: 'Graubünden', nameCN: '格劳宾登', capital: 'Chur', capitalCN: '库尔', region: 'German', regionCN: '德语区' },
  { code: 'Jura', name: 'Jura', nameCN: '汝拉', capital: 'Delémont', capitalCN: '德莱蒙', region: 'French', regionCN: '法语区' },
  { code: 'Lucerne', name: 'Lucerne', nameCN: '卢塞恩', capital: 'Lucerne', capitalCN: '卢塞恩', region: 'German', regionCN: '德语区' },
  { code: 'Neuchâtel', name: 'Neuchâtel', nameCN: '纳沙泰尔', capital: 'Neuchâtel', capitalCN: '纳沙泰尔', region: 'French', regionCN: '法语区' },
  { code: 'Nidwalden', name: 'Nidwalden', nameCN: '下瓦尔登', capital: 'Stans', capitalCN: '施坦斯', region: 'German', regionCN: '德语区' },
  { code: 'Obwalden', name: 'Obwalden', nameCN: '上瓦尔登', capital: 'Sarnen', capitalCN: '萨尔嫩', region: 'German', regionCN: '德语区' },
  { code: 'Schaffhausen', name: 'Schaffhausen', nameCN: '沙夫豪森', capital: 'Schaffhausen', capitalCN: '沙夫豪森', region: 'German', regionCN: '德语区' },
  { code: 'Schwyz', name: 'Schwyz', nameCN: '施维茨', capital: 'Schwyz', capitalCN: '施维茨', region: 'German', regionCN: '德语区' },
  { code: 'Solothurn', name: 'Solothurn', nameCN: '索洛图恩', capital: 'Solothurn', capitalCN: '索洛图恩', region: 'German', regionCN: '德语区' },
  { code: 'St. Gallen', name: 'St. Gallen', nameCN: '圣加仑', capital: 'St. Gallen', capitalCN: '圣加仑', region: 'German', regionCN: '德语区' },
  { code: 'Thurgau', name: 'Thurgau', nameCN: '图尔高', capital: 'Frauenfeld', capitalCN: '弗劳恩费尔德', region: 'German', regionCN: '德语区' },
  { code: 'Ticino', name: 'Ticino', nameCN: '提契诺', capital: 'Bellinzona', capitalCN: '贝林佐纳', region: 'Italian', regionCN: '意语区' },
  { code: 'Uri', name: 'Uri', nameCN: '乌里', capital: 'Altdorf', capitalCN: '阿尔特多夫', region: 'German', regionCN: '德语区' },
  { code: 'Valais', name: 'Valais', nameCN: '瓦莱', capital: 'Sion', capitalCN: '锡永', region: 'French', regionCN: '法语区' },
  { code: 'Vaud', name: 'Vaud', nameCN: '沃', capital: 'Lausanne', capitalCN: '洛桑', region: 'French', regionCN: '法语区' },
  { code: 'Zug', name: 'Zug', nameCN: '楚格', capital: 'Zug', capitalCN: '楚格', region: 'German', regionCN: '德语区' },
  { code: 'Zürich', name: 'Zürich', nameCN: '苏黎世', capital: 'Zürich', capitalCN: '苏黎世', region: 'German', regionCN: '德语区' }
];

// 英国构成国数据
const ukStates: StateInfo[] = [
  { code: 'England', name: 'England', nameCN: '英格兰', capital: 'London', capitalCN: '伦敦', region: 'England', regionCN: '英格兰' },
  { code: 'Scotland', name: 'Scotland', nameCN: '苏格兰', capital: 'Edinburgh', capitalCN: '爱丁堡', region: 'Scotland', regionCN: '苏格兰' },
  { code: 'Wales', name: 'Wales', nameCN: '威尔士', capital: 'Cardiff', capitalCN: '加的夫', region: 'Wales', regionCN: '威尔士' },
  { code: 'Northern Ireland', name: 'Northern Ireland', nameCN: '北爱尔兰', capital: 'Belfast', capitalCN: '贝尔法斯特', region: 'Northern Ireland', regionCN: '北爱尔兰' },
  { code: 'Gibraltar', name: 'Gibraltar', nameCN: '直布罗陀', capital: 'Gibraltar', capitalCN: '直布罗陀', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Bermuda', name: 'Bermuda', nameCN: '百慕大', capital: 'Hamilton', capitalCN: '汉密尔顿', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'British Virgin Islands', name: 'British Virgin Islands', nameCN: '英属维尔京群岛', capital: 'Road Town', capitalCN: '罗德城', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Cayman Islands', name: 'Cayman Islands', nameCN: '开曼群岛', capital: 'George Town', capitalCN: '乔治敦', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Falkland Islands', name: 'Falkland Islands', nameCN: '福克兰群岛', capital: 'Stanley', capitalCN: '斯坦利', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Montserrat', name: 'Montserrat', nameCN: '蒙特塞拉特', capital: 'Plymouth', capitalCN: '普利茅斯', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Turks and Caicos Islands', name: 'Turks and Caicos Islands', nameCN: '特克斯和凯科斯群岛', capital: 'Cockburn Town', capitalCN: '科伯恩城', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Anguilla', name: 'Anguilla', nameCN: '安圭拉', capital: 'The Valley', capitalCN: '瓦利', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Pitcairn Islands', name: 'Pitcairn Islands', nameCN: '皮特凯恩群岛', capital: 'Adamstown', capitalCN: '亚当斯敦', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'Saint Helena', name: 'Saint Helena', nameCN: '圣赫勒拿', capital: 'Jamestown', capitalCN: '詹姆斯敦', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'South Georgia', name: 'South Georgia', nameCN: '南乔治亚岛', capital: 'King Edward Point', capitalCN: '爱德华王角', region: 'Overseas Territory', regionCN: '海外领地' },
  { code: 'British Indian Ocean Territory', name: 'British Indian Ocean Territory', nameCN: '英属印度洋领地', capital: 'Diego Garcia', capitalCN: '迪戈加西亚', region: 'Overseas Territory', regionCN: '海外领地' }
];

// 意大利大区数据
const italyStates: StateInfo[] = [
  { code: 'Abruzzo', name: 'Abruzzo', nameCN: '阿布鲁佐', capital: "L'Aquila", capitalCN: '拉奎拉', region: 'Central', regionCN: '中部' },
  { code: 'Aosta Valley', name: 'Aosta Valley', nameCN: '瓦莱达奥斯塔', capital: 'Aosta', capitalCN: '奥斯塔', region: 'Northwest', regionCN: '西北部' },
  { code: 'Apulia', name: 'Apulia', nameCN: '普利亚', capital: 'Bari', capitalCN: '巴里', region: 'South', regionCN: '南部' },
  { code: 'Basilicata', name: 'Basilicata', nameCN: '巴斯利卡塔', capital: 'Potenza', capitalCN: '波坦察', region: 'South', regionCN: '南部' },
  { code: 'Calabria', name: 'Calabria', nameCN: '卡拉布里亚', capital: 'Catanzaro', capitalCN: '卡坦扎罗', region: 'South', regionCN: '南部' },
  { code: 'Campania', name: 'Campania', nameCN: '坎帕尼亚', capital: 'Naples', capitalCN: '那不勒斯', region: 'South', regionCN: '南部' },
  { code: 'Emilia-Romagna', name: 'Emilia-Romagna', nameCN: '艾米利亚-罗马涅', capital: 'Bologna', capitalCN: '博洛尼亚', region: 'Northeast', regionCN: '东北部' },
  { code: 'Friuli-Venezia Giulia', name: 'Friuli-Venezia Giulia', nameCN: '弗留利-威尼斯朱利亚', capital: 'Trieste', capitalCN: '的里雅斯特', region: 'Northeast', regionCN: '东北部' },
  { code: 'Lazio', name: 'Lazio', nameCN: '拉齐奥', capital: 'Rome', capitalCN: '罗马', region: 'Central', regionCN: '中部' },
  { code: 'Liguria', name: 'Liguria', nameCN: '利古里亚', capital: 'Genoa', capitalCN: '热那亚', region: 'Northwest', regionCN: '西北部' },
  { code: 'Lombardy', name: 'Lombardy', nameCN: '伦巴第', capital: 'Milan', capitalCN: '米兰', region: 'Northwest', regionCN: '西北部' },
  { code: 'Marche', name: 'Marche', nameCN: '马尔凯', capital: 'Ancona', capitalCN: '安科纳', region: 'Central', regionCN: '中部' },
  { code: 'Molise', name: 'Molise', nameCN: '莫利塞', capital: 'Campobasso', capitalCN: '坎波巴索', region: 'South', regionCN: '南部' },
  { code: 'Piedmont', name: 'Piedmont', nameCN: '皮埃蒙特', capital: 'Turin', capitalCN: '都灵', region: 'Northwest', regionCN: '西北部' },
  { code: 'Sardinia', name: 'Sardinia', nameCN: '撒丁岛', capital: 'Cagliari', capitalCN: '卡利亚里', region: 'Islands', regionCN: '岛屿' },
  { code: 'Sicily', name: 'Sicily', nameCN: '西西里岛', capital: 'Palermo', capitalCN: '巴勒莫', region: 'Islands', regionCN: '岛屿' },
  { code: 'Trentino-Alto Adige', name: 'Trentino-Alto Adige', nameCN: '特伦蒂诺-上阿迪杰', capital: 'Trento', capitalCN: '特伦托', region: 'Northeast', regionCN: '东北部' },
  { code: 'Tuscany', name: 'Tuscany', nameCN: '托斯卡纳', capital: 'Florence', capitalCN: '佛罗伦萨', region: 'Central', regionCN: '中部' },
  { code: 'Umbria', name: 'Umbria', nameCN: '翁布里亚', capital: 'Perugia', capitalCN: '佩鲁贾', region: 'Central', regionCN: '中部' },
  { code: 'Veneto', name: 'Veneto', nameCN: '威尼托', capital: 'Venice', capitalCN: '威尼斯', region: 'Northeast', regionCN: '东北部' }
];

// 西班牙自治区数据
const spainStates: StateInfo[] = [
  { code: 'Andalusia', name: 'Andalusia', nameCN: '安达卢西亚', capital: 'Seville', capitalCN: '塞维利亚', region: 'South', regionCN: '南部' },
  { code: 'Aragon', name: 'Aragon', nameCN: '阿拉贡', capital: 'Zaragoza', capitalCN: '萨拉戈萨', region: 'Northeast', regionCN: '东北部' },
  { code: 'Asturias', name: 'Asturias', nameCN: '阿斯图里亚斯', capital: 'Oviedo', capitalCN: '奥维耶多', region: 'North', regionCN: '北部' },
  { code: 'Balearic Islands', name: 'Balearic Islands', nameCN: '巴利阿里群岛', capital: 'Palma', capitalCN: '帕尔马', region: 'Islands', regionCN: '岛屿' },
  { code: 'Basque Country', name: 'Basque Country', nameCN: '巴斯克', capital: 'Vitoria-Gasteiz', capitalCN: '维多利亚', region: 'North', regionCN: '北部' },
  { code: 'Canary Islands', name: 'Canary Islands', nameCN: '加那利群岛', capital: 'Las Palmas/Santa Cruz', capitalCN: '拉斯帕尔马斯/圣克鲁斯', region: 'Islands', regionCN: '岛屿' },
  { code: 'Cantabria', name: 'Cantabria', nameCN: '坎塔布里亚', capital: 'Santander', capitalCN: '桑坦德', region: 'North', regionCN: '北部' },
  { code: 'Castile and León', name: 'Castile and León', nameCN: '卡斯蒂利亚-莱昂', capital: 'Valladolid', capitalCN: '巴利亚多利德', region: 'Central', regionCN: '中部' },
  { code: 'Castilla-La Mancha', name: 'Castilla-La Mancha', nameCN: '卡斯蒂利亚-拉曼恰', capital: 'Toledo', capitalCN: '托莱多', region: 'Central', regionCN: '中部' },
  { code: 'Catalonia', name: 'Catalonia', nameCN: '加泰罗尼亚', capital: 'Barcelona', capitalCN: '巴塞罗那', region: 'Northeast', regionCN: '东北部' },
  { code: 'Ceuta', name: 'Ceuta', nameCN: '休达', capital: 'Ceuta', capitalCN: '休达', region: 'Africa', regionCN: '非洲' },
  { code: 'Extremadura', name: 'Extremadura', nameCN: '埃斯特雷马杜拉', capital: 'Mérida', capitalCN: '梅里达', region: 'West', regionCN: '西部' },
  { code: 'Galicia', name: 'Galicia', nameCN: '加利西亚', capital: 'Santiago de Compostela', capitalCN: '圣地亚哥-德孔波斯特拉', region: 'Northwest', regionCN: '西北部' },
  { code: 'La Rioja', name: 'La Rioja', nameCN: '拉里奥哈', capital: 'Logroño', capitalCN: '洛格罗尼奥', region: 'North', regionCN: '北部' },
  { code: 'Community of Madrid', name: 'Community of Madrid', nameCN: '马德里自治区', capital: 'Madrid', capitalCN: '马德里', region: 'Central', regionCN: '中部' },
  { code: 'Melilla', name: 'Melilla', nameCN: '梅利利亚', capital: 'Melilla', capitalCN: '梅利利亚', region: 'Africa', regionCN: '非洲' },
  { code: 'Region of Murcia', name: 'Region of Murcia', nameCN: '穆尔西亚', capital: 'Murcia', capitalCN: '穆尔西亚', region: 'Southeast', regionCN: '东南部' },
  { code: 'Navarre', name: 'Navarre', nameCN: '纳瓦拉', capital: 'Pamplona', capitalCN: '潘普洛纳', region: 'North', regionCN: '北部' },
  { code: 'Valencian Community', name: 'Valencian Community', nameCN: '巴伦西亚', capital: 'Valencia', capitalCN: '瓦伦西亚', region: 'East', regionCN: '东部' }
];

// 所有支持的国家州旗数据
export const countryStateDataList: CountryStateData[] = [
  {
    countryCode: 'jp',
    countryName: 'Japan',
    countryNameCN: '日本',
    countryEmoji: '🇯🇵',
    stateLabel: '都道府县',
    states: japanStates
  },
  {
    countryCode: 'us',
    countryName: 'United States',
    countryNameCN: '美国',
    countryEmoji: '🇺🇸',
    stateLabel: '州',
    states: usStates
  },
  {
    countryCode: 'de',
    countryName: 'Germany',
    countryNameCN: '德国',
    countryEmoji: '🇩🇪',
    stateLabel: '州',
    states: germanyStates
  },
  {
    countryCode: 'au',
    countryName: 'Australia',
    countryNameCN: '澳大利亚',
    countryEmoji: '🇦🇺',
    stateLabel: '州',
    states: australiaStates
  },
  {
    countryCode: 'br',
    countryName: 'Brazil',
    countryNameCN: '巴西',
    countryEmoji: '🇧🇷',
    stateLabel: '州',
    states: brazilStates
  },
  {
    countryCode: 'ca',
    countryName: 'Canada',
    countryNameCN: '加拿大',
    countryEmoji: '🇨🇦',
    stateLabel: '省',
    states: canadaStates
  },
  {
    countryCode: 'kr',
    countryName: 'South Korea',
    countryNameCN: '韩国',
    countryEmoji: '🇰🇷',
    stateLabel: '行政区',
    states: koreaStates
  },
  {
    countryCode: 'ch',
    countryName: 'Switzerland',
    countryNameCN: '瑞士',
    countryEmoji: '🇨🇭',
    stateLabel: '州',
    states: switzerlandStates
  },
  {
    countryCode: 'gb',
    countryName: 'United Kingdom',
    countryNameCN: '英国',
    countryEmoji: '🇬🇧',
    stateLabel: '地区',
    states: ukStates
  },
  {
    countryCode: 'it',
    countryName: 'Italy',
    countryNameCN: '意大利',
    countryEmoji: '🇮🇹',
    stateLabel: '大区',
    states: italyStates
  },
  {
    countryCode: 'es',
    countryName: 'Spain',
    countryNameCN: '西班牙',
    countryEmoji: '🇪🇸',
    stateLabel: '自治区',
    states: spainStates
  }
];

// 获取所有国家州旗数据
export function getAllCountryStateData(): CountryStateData[] {
  return countryStateDataList;
}

// 根据国家代码获取州旗数据
export function getCountryStateData(countryCode: string): CountryStateData | undefined {
  return countryStateDataList.find(data => data.countryCode === countryCode);
}

// 特殊文件名映射
const fileNameMap: Record<string, string> = {
  // 韩国
  'north jeolla': 'jeonbuk',
  // 瑞士
  'graubünden': 'graubuenden',
  'zürich': 'zuerich',
  'neuchâtel': 'neuchatel',
  'st. gallen': 'st_gallen',
  // 意大利
  'trentino-alto adige': 'trentino_south_tyrol',
  'aosta valley': 'valle_daosta',
  'friuli-venezia giulia': 'friuli_venezia_giulia',
  'emilia-romagna': 'emilia_romagna',
  // 西班牙
  'castilla-la mancha': 'castile_la_mancha',
  'castile and león': 'castile_and_león',
  // 英国
  'turks and caicos islands': 'turks_and_caicos',
  // 巴西
  'são paulo': 'sao_paulo',
  'espírito santo': 'espirito_santo',
  'ceará': 'ceara',
  'maranhão': 'maranhao',
  'piauí': 'piaui',
  'paraná': 'parana',
  'paraíba': 'paraiba',
  'pará': 'para',
  'goiás': 'goias',
  'amapá': 'amapa',
  'rondônia': 'rondonia'
};

// 获取州旗文件路径（与 stateflags 模块 rawfile 目录一致：{countryCode}/{file}.svg）
export function getStateFlagPath(countryCode: string, stateCode: string): string {
  const lowerCode = stateCode.toLowerCase();
  let fileName: string;

  if (fileNameMap[lowerCode]) {
    fileName = fileNameMap[lowerCode];
  } else {
    fileName = lowerCode.replace(/ /g, '_').replace(/-/g, '_');
  }

  return `${countryCode}/${fileName}.svg`;
}
