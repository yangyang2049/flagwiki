/**
 * 国歌名称数据
 * 包含所有国歌的中英文名称
 */

export interface AnthemInfo {
  code: string;        // 国家代码（小写）
  nameEN: string;     // 英文名称
  nameCN: string;     // 中文名称
}

/**
 * 国歌名称数据映射表
 * 格式：国家代码（小写） -> 国歌信息
 */
export const AnthemNames: Record<string, AnthemInfo> = {
  // 亚洲
  'cn': { code: 'cn', nameEN: 'March of the Volunteers', nameCN: '义勇军进行曲' },
  'jp': { code: 'jp', nameEN: 'Kimigayo', nameCN: '君之代' },
  'kr': { code: 'kr', nameEN: 'Aegukga', nameCN: '爱国歌' },
  'kp': { code: 'kp', nameEN: 'Aegukka', nameCN: '爱国歌' },
  'in': { code: 'in', nameEN: 'Jana Gana Mana', nameCN: '人民的意志' },
  'id': { code: 'id', nameEN: 'Indonesia Raya', nameCN: '大印度尼西亚' },
  'th': { code: 'th', nameEN: 'Phleng Chat', nameCN: '国歌' },
  'vn': { code: 'vn', nameEN: 'Tiến Quân Ca', nameCN: '进军歌' },
  'my': { code: 'my', nameEN: 'Negaraku', nameCN: '我的国家' },
  'sg': { code: 'sg', nameEN: 'Majulah Singapura', nameCN: '前进吧，新加坡' },
  'ph': { code: 'ph', nameEN: 'Lupang Hinirang', nameCN: '被选中的土地' },
  'mm': { code: 'mm', nameEN: 'Kaba Ma Kyei', nameCN: '直到世界末日' },
  'kh': { code: 'kh', nameEN: 'Nokor Reach', nameCN: '王国' },
  'la': { code: 'la', nameEN: 'Pheng Xat Lao', nameCN: '老挝国歌' },
  'bn': { code: 'bn', nameEN: 'Allah Peliharakan Sultan', nameCN: '真主保佑苏丹' },
  'tl': { code: 'tl', nameEN: 'Pátria', nameCN: '祖国' },
  'pk': { code: 'pk', nameEN: 'Qaumi Taranah', nameCN: '国歌' },
  'bd': { code: 'bd', nameEN: 'Amar Sonar Bangla', nameCN: '我金色的孟加拉' },
  'lk': { code: 'lk', nameEN: 'Sri Lanka Matha', nameCN: '斯里兰卡母亲' },
  'np': { code: 'np', nameEN: 'Sayaun Thunga Phool Ka', nameCN: '由数百朵花组成' },
  'bt': { code: 'bt', nameEN: 'Druk tsendhen', nameCN: '雷龙王国' },
  'mv': { code: 'mv', nameEN: 'Gaumee Salaam', nameCN: '国家致敬' },
  'af': { code: 'af', nameEN: 'Milli Surood', nameCN: '国歌' },
  'ir': { code: 'ir', nameEN: 'Sorud-e Melli-ye Jomhuri-ye Eslami-ye Iran', nameCN: '伊朗伊斯兰共和国国歌' },
  'iq': { code: 'iq', nameEN: 'Mawtini', nameCN: '我的祖国' },
  'sa': { code: 'sa', nameEN: 'Aash Al Maleek', nameCN: '国王万岁' },
  'ae': { code: 'ae', nameEN: 'Ishy Bilady', nameCN: '我的国家万岁' },
  'qa': { code: 'qa', nameEN: 'As-Salam al-Amiri', nameCN: '和平的埃米尔' },
  'kw': { code: 'kw', nameEN: 'Al-Nasheed Al-Watani', nameCN: '国歌' },
  'bh': { code: 'bh', nameEN: 'Bahrainona', nameCN: '我们的巴林' },
  'om': { code: 'om', nameEN: 'Nashid as-Salaam as-Sultani', nameCN: '苏丹和平颂' },
  'ye': { code: 'ye', nameEN: 'United Republic', nameCN: '统一共和国' },
  'jo': { code: 'jo', nameEN: 'Al-salam Al-malaki Al-urdoni', nameCN: '约旦皇家国歌' },
  'lb': { code: 'lb', nameEN: 'Lebanese National Anthem', nameCN: '黎巴嫩国歌' },
  'sy': { code: 'sy', nameEN: 'Homat el Diyar', nameCN: '祖国卫士' },
  'il': { code: 'il', nameEN: 'Hatikvah', nameCN: '希望' },
  'ps': { code: 'ps', nameEN: 'Fida\'i', nameCN: '战士' },
  'kz': { code: 'kz', nameEN: 'Meniń Qazaqstanym', nameCN: '我的哈萨克斯坦' },
  'uz': { code: 'uz', nameEN: 'O\'zbekiston Respublikasining Davlat Madhiyasi', nameCN: '乌兹别克斯坦共和国国歌' },
  'tm': { code: 'tm', nameEN: 'Garaşsyz, Bitarap Türkmenistanyň Döwlet Gimni', nameCN: '独立、中立、土库曼斯坦国歌' },
  'tj': { code: 'tj', nameEN: 'Surudi Milli', nameCN: '国歌' },
  'kg': { code: 'kg', nameEN: 'Kyrgyz Respublikasynyn Mamlekettik Gimni', nameCN: '吉尔吉斯共和国国歌' },
  'mn': { code: 'mn', nameEN: 'Mongol Ulsyn Töriin Duulal', nameCN: '蒙古国歌' },
  'ge': { code: 'ge', nameEN: 'Tavisupleba', nameCN: '自由' },
  'am': { code: 'am', nameEN: 'Mer Hayrenik', nameCN: '我们的祖国' },
  'az': { code: 'az', nameEN: 'Azərbaycan marşı', nameCN: '阿塞拜疆进行曲' },
  'cy': { code: 'cy', nameEN: 'Ýmnos eis tīn Eleutherían', nameCN: '自由颂' },
  'tr': { code: 'tr', nameEN: 'İstiklal Marşı', nameCN: '独立进行曲' },
  
  // 欧洲
  'ru': { code: 'ru', nameEN: 'State Anthem of the Russian Federation', nameCN: '俄罗斯联邦国歌' },
  'gb': { code: 'gb', nameEN: 'God Save the King', nameCN: '天佑吾王' },
  'fr': { code: 'fr', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  'de': { code: 'de', nameEN: 'Das Lied der Deutschen', nameCN: '德意志之歌' },
  'it': { code: 'it', nameEN: 'Il Canto degli Italiani', nameCN: '意大利人之歌' },
  'es': { code: 'es', nameEN: 'Marcha Real', nameCN: '皇家进行曲' },
  'pl': { code: 'pl', nameEN: 'Mazurek Dąbrowskiego', nameCN: '波兰没有灭亡' },
  'ua': { code: 'ua', nameEN: 'Shche ne vmerla Ukrainy', nameCN: '乌克兰仍在人间' },
  'ro': { code: 'ro', nameEN: 'Deșteaptă-te, române!', nameCN: '醒来吧，罗马尼亚人' },
  'nl': { code: 'nl', nameEN: 'Wilhelmus', nameCN: '威廉颂' },
  'be': { code: 'be', nameEN: 'La Brabançonne', nameCN: '布拉班人之歌' },
  'gr': { code: 'gr', nameEN: 'Ýmnos eis tīn Eleutherían', nameCN: '自由颂' },
  'pt': { code: 'pt', nameEN: 'A Portuguesa', nameCN: '葡萄牙人' },
  'cz': { code: 'cz', nameEN: 'Kde domov můj', nameCN: '我的家乡在哪里' },
  'hu': { code: 'hu', nameEN: 'Himnusz', nameCN: '赞美诗' },
  'se': { code: 'se', nameEN: 'Du gamla, Du fria', nameCN: '你古老，你自由' },
  'at': { code: 'at', nameEN: 'Land der Berge, Land am Strome', nameCN: '山峦之国，河流之国' },
  'ch': { code: 'ch', nameEN: 'Swiss Psalm', nameCN: '瑞士诗篇' },
  'no': { code: 'no', nameEN: 'Ja, vi elsker dette landet', nameCN: '是的，我们热爱这片土地' },
  'dk': { code: 'dk', nameEN: 'Der er et yndigt land', nameCN: '有一个美丽的国家' },
  'fi': { code: 'fi', nameEN: 'Maamme', nameCN: '我们的土地' },
  'ie': { code: 'ie', nameEN: 'Amhrán na bhFiann', nameCN: '战士之歌' },
  'is': { code: 'is', nameEN: 'Lofsöngur', nameCN: '赞美诗' },
  'lu': { code: 'lu', nameEN: 'Ons Heemecht', nameCN: '我们的祖国' },
  'li': { code: 'li', nameEN: 'Oben am jungen Rhein', nameCN: '在年轻的莱茵河上' },
  'mc': { code: 'mc', nameEN: 'Hymne Monégasque', nameCN: '摩纳哥国歌' },
  'ad': { code: 'ad', nameEN: 'El Gran Carlemany', nameCN: '伟大的查理曼' },
  'sm': { code: 'sm', nameEN: 'Inno Nazionale della Repubblica', nameCN: '共和国国歌' },
  'va': { code: 'va', nameEN: 'Inno e Marcia Pontificale', nameCN: '教皇国歌和进行曲' },
  'mt': { code: 'mt', nameEN: 'L-Innu Malti', nameCN: '马耳他国歌' },
  'al': { code: 'al', nameEN: 'Himni i Flamurit', nameCN: '旗帜颂' },
  'ba': { code: 'ba', nameEN: 'Državna himna Bosne i Hercegovine', nameCN: '波斯尼亚和黑塞哥维那国歌' },
  'bg': { code: 'bg', nameEN: 'Mila Rodino', nameCN: '亲爱的祖国' },
  'hr': { code: 'hr', nameEN: 'Lijepa naša domovino', nameCN: '我们美丽的祖国' },
  'ee': { code: 'ee', nameEN: 'Mu isamaa, mu õnn ja rõõm', nameCN: '我的祖国，我的快乐和喜悦' },
  'lv': { code: 'lv', nameEN: 'Dievs, svētī Latviju!', nameCN: '上帝保佑拉脱维亚' },
  'lt': { code: 'lt', nameEN: 'Tautiška giesmė', nameCN: '国歌' },
  'me': { code: 'me', nameEN: 'Oj, svijetla majska zoro', nameCN: '哦，明亮的五月黎明' },
  'mk': { code: 'mk', nameEN: 'Denes nad Makedonija', nameCN: '今日在马其顿之上' },
  'rs': { code: 'rs', nameEN: 'Bože pravde', nameCN: '正义的上帝' },
  'si': { code: 'si', nameEN: 'Zdravljica', nameCN: '祝酒歌' },
  'sk': { code: 'sk', nameEN: 'Nad Tatrou sa blýska', nameCN: '塔特拉山上电光闪闪' },
  'by': { code: 'by', nameEN: 'My Belarusy', nameCN: '我们白俄罗斯人' },
  'md': { code: 'md', nameEN: 'Limba noastră', nameCN: '我们的语言' },
  
  // 非洲
  'eg': { code: 'eg', nameEN: 'Bilady, Bilady, Bilady', nameCN: '我的祖国，我的祖国，我的祖国' },
  'za': { code: 'za', nameEN: 'National Anthem of South Africa', nameCN: '南非国歌' },
  'ng': { code: 'ng', nameEN: 'Arise, O Compatriots', nameCN: '起来，同胞们' },
  'ke': { code: 'ke', nameEN: 'Ee Mungu Nguvu Yetu', nameCN: '哦，万能的上帝' },
  'et': { code: 'et', nameEN: 'Wodefit Gesgeshi, Widd Innat Ityopp\'ya', nameCN: '前进，亲爱的母亲埃塞俄比亚' },
  'tz': { code: 'tz', nameEN: 'Mungu ibariki Afrika', nameCN: '上帝保佑非洲' },
  'ug': { code: 'ug', nameEN: 'Oh Uganda, Land of Beauty', nameCN: '哦，乌干达，美丽的土地' },
  'gh': { code: 'gh', nameEN: 'God Bless Our Homeland Ghana', nameCN: '上帝保佑我们的祖国加纳' },
  'mg': { code: 'mg', nameEN: 'Ry Tanindrazanay malala ô', nameCN: '哦，我们亲爱的祖国' },
  'cm': { code: 'cm', nameEN: 'Ô Cameroun, Berceau de nos Ancêtres', nameCN: '哦，喀麦隆，我们祖先的摇篮' },
  'ci': { code: 'ci', nameEN: 'L\'Abidjanaise', nameCN: '阿比让之歌' },
  'ne': { code: 'ne', nameEN: 'La Nigérienne', nameCN: '尼日尔之歌' },
  'bf': { code: 'bf', nameEN: 'Une Seule Nuit', nameCN: '一夜' },
  'ml': { code: 'ml', nameEN: 'Le Mali', nameCN: '马里' },
  'mw': { code: 'mw', nameEN: 'Mulungu dalitsa Malawi', nameCN: '上帝保佑马拉维' },
  'zm': { code: 'zm', nameEN: 'Stand and Sing of Zambia, Proud and Free', nameCN: '站起来，歌唱赞比亚，自豪而自由' },
  'ao': { code: 'ao', nameEN: 'Angola Avante', nameCN: '前进，安哥拉' },
  'mz': { code: 'mz', nameEN: 'Pátria Amada', nameCN: '亲爱的祖国' },
  'zw': { code: 'zw', nameEN: 'Simudzai Mureza wedu WeZimbabwe', nameCN: '举起我们的津巴布韦国旗' },
  'sn': { code: 'sn', nameEN: 'Pincez Tous vos Koras, Frappez les Balafons', nameCN: '所有人弹奏你的科拉琴，敲击巴拉风琴' },
  'td': { code: 'td', nameEN: 'La Tchadienne', nameCN: '乍得之歌' },
  'so': { code: 'so', nameEN: 'Qolobaa Calankeed', nameCN: '向国旗致敬' },
  'rw': { code: 'rw', nameEN: 'Rwanda Nziza', nameCN: '美丽的卢旺达' },
  'bj': { code: 'bj', nameEN: 'L\'Aube Nouvelle', nameCN: '新黎明' },
  'tn': { code: 'tn', nameEN: 'Humat al-Hima', nameCN: '祖国卫士' },
  'ly': { code: 'ly', nameEN: 'Libya, Libya, Libya', nameCN: '利比亚，利比亚，利比亚' },
  'ma': { code: 'ma', nameEN: 'Hymne Chérifien', nameCN: '谢里夫国歌' },
  'dz': { code: 'dz', nameEN: 'Kassaman', nameCN: '我们发誓' },
  'sd': { code: 'sd', nameEN: 'Nahnu Jund Allah Jund Al-watan', nameCN: '我们是真主的军队，祖国的军队' },
  'er': { code: 'er', nameEN: 'Ertra, Ertra, Ertra', nameCN: '厄立特里亚，厄立特里亚，厄立特里亚' },
  'dj': { code: 'dj', nameEN: 'Djibouti', nameCN: '吉布提' },
  'ss': { code: 'ss', nameEN: 'South Sudan Oyee!', nameCN: '南苏丹万岁' },
  'cf': { code: 'cf', nameEN: 'La Renaissance', nameCN: '复兴' },
  'cg': { code: 'cg', nameEN: 'La Congolaise', nameCN: '刚果之歌' },
  'ga': { code: 'ga', nameEN: 'La Concorde', nameCN: '和谐' },
  'gq': { code: 'gq', nameEN: 'Caminemos pisando las sendas', nameCN: '让我们走在道路上' },
  'st': { code: 'st', nameEN: 'Independência total', nameCN: '完全独立' },
  'cv': { code: 'cv', nameEN: 'Cântico da Liberdade', nameCN: '自由之歌' },
  'gw': { code: 'gw', nameEN: 'Esta é a Nossa Pátria Bem Amada', nameCN: '这是我们深爱的祖国' },
  'gn': { code: 'gn', nameEN: 'Liberté', nameCN: '自由' },
  'lr': { code: 'lr', nameEN: 'All Hail, Liberia, Hail!', nameCN: '万岁，利比里亚，万岁' },
  'sl': { code: 'sl', nameEN: 'High We Exalt Thee, Realm of the Free', nameCN: '我们高举你，自由王国' },
  'gm': { code: 'gm', nameEN: 'For The Gambia, Our Homeland', nameCN: '为了冈比亚，我们的祖国' },
  'bi': { code: 'bi', nameEN: 'Burundi Bwacu', nameCN: '我们亲爱的布隆迪' },
  'mu': { code: 'mu', nameEN: 'Motherland', nameCN: '祖国' },
  'sc': { code: 'sc', nameEN: 'Koste Seselwa', nameCN: '塞舌尔人团结起来' },
  'km': { code: 'km', nameEN: 'Udzima wa ya Masiwa', nameCN: '大岛联盟' },
  'yt': { code: 'yt', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  're': { code: 're', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  'sh': { code: 'sh', nameEN: 'God Save the King', nameCN: '天佑吾王' },
  'eh': { code: 'eh', nameEN: 'Yā Banī al-Saḥrā\'', nameCN: '撒哈拉之子' },
  'ls': { code: 'ls', nameEN: 'Lesotho Fatše La Bontata Rona', nameCN: '莱索托，我们祖先的土地' },
  'sz': { code: 'sz', nameEN: 'Nkulunkulu Mnikati wetibusiso temaSwati', nameCN: '哦，上帝，赐予斯威士兰祝福' },
  'bw': { code: 'bw', nameEN: 'Fatshe leno la rona', nameCN: '我们的土地' },
  'na': { code: 'na', nameEN: 'Namibia, Land of the Brave', nameCN: '纳米比亚，勇敢者的土地' },
  'mr': { code: 'mr', nameEN: 'National Anthem of Mauritania', nameCN: '毛里塔尼亚国歌' },
  'to': { code: 'to', nameEN: 'Ko e fasi ʻo e tuʻi ʻo e ʻOtu Tonga', nameCN: '汤加王国国歌' },
  
  // 美洲
  'us': { code: 'us', nameEN: 'The Star-Spangled Banner', nameCN: '星条旗' },
  'ca': { code: 'ca', nameEN: 'O Canada', nameCN: '哦，加拿大' },
  'mx': { code: 'mx', nameEN: 'Himno Nacional Mexicano', nameCN: '墨西哥国歌' },
  'br': { code: 'br', nameEN: 'Hino Nacional Brasileiro', nameCN: '巴西国歌' },
  'ar': { code: 'ar', nameEN: 'Himno Nacional Argentino', nameCN: '阿根廷国歌' },
  'cl': { code: 'cl', nameEN: 'Himno Nacional de Chile', nameCN: '智利国歌' },
  'co': { code: 'co', nameEN: 'Himno Nacional de la República de Colombia', nameCN: '哥伦比亚共和国国歌' },
  'pe': { code: 'pe', nameEN: 'Himno Nacional del Perú', nameCN: '秘鲁国歌' },
  've': { code: 've', nameEN: 'Gloria al Bravo Pueblo', nameCN: '向勇敢的人民致敬' },
  'ec': { code: 'ec', nameEN: 'Salve, Oh Patria', nameCN: '致敬，哦，祖国' },
  'bo': { code: 'bo', nameEN: 'Himno Nacional de Bolivia', nameCN: '玻利维亚国歌' },
  'py': { code: 'py', nameEN: 'Himno Nacional Paraguayo', nameCN: '巴拉圭国歌' },
  'uy': { code: 'uy', nameEN: 'Himno Nacional', nameCN: '国歌' },
  'gy': { code: 'gy', nameEN: 'Dear Land of Guyana, of Rivers and Plains', nameCN: '亲爱的圭亚那，河流和平原的土地' },
  'sr': { code: 'sr', nameEN: 'God zij met ons Suriname', nameCN: '上帝与我们同在苏里南' },
  'gf': { code: 'gf', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  'fk': { code: 'fk', nameEN: 'God Save the King', nameCN: '天佑吾王' },
  'gt': { code: 'gt', nameEN: 'Himno Nacional de Guatemala', nameCN: '危地马拉国歌' },
  'bz': { code: 'bz', nameEN: 'Land of the Free', nameCN: '自由之地' },
  'sv': { code: 'sv', nameEN: 'Himno Nacional de El Salvador', nameCN: '萨尔瓦多国歌' },
  'hn': { code: 'hn', nameEN: 'Himno Nacional de Honduras', nameCN: '洪都拉斯国歌' },
  'ni': { code: 'ni', nameEN: 'Salve a ti, Nicaragua', nameCN: '致敬你，尼加拉瓜' },
  'cr': { code: 'cr', nameEN: 'Himno Nacional de Costa Rica', nameCN: '哥斯达黎加国歌' },
  'pa': { code: 'pa', nameEN: 'Himno Istmeño', nameCN: '地峡国歌' },
  'cu': { code: 'cu', nameEN: 'La Bayamesa', nameCN: '巴亚莫之歌' },
  'jm': { code: 'jm', nameEN: 'Jamaica, Land We Love', nameCN: '牙买加，我们热爱的土地' },
  'ht': { code: 'ht', nameEN: 'La Dessalinienne', nameCN: '德萨利纳之歌' },
  'do': { code: 'do', nameEN: 'Himno Nacional', nameCN: '国歌' },
  'tt': { code: 'tt', nameEN: 'Forged from the Love of Liberty', nameCN: '从自由之爱中锻造' },
  'bb': { code: 'bb', nameEN: 'In Plenty and In Time of Need', nameCN: '富足时和需要时' },
  'gd': { code: 'gd', nameEN: 'Hail Grenada', nameCN: '向格林纳达致敬' },
  'lc': { code: 'lc', nameEN: 'Sons and Daughters of Saint Lucia', nameCN: '圣卢西亚的儿女' },
  'vc': { code: 'vc', nameEN: 'Saint Vincent, Land so Beautiful', nameCN: '圣文森特，如此美丽的土地' },
  'ag': { code: 'ag', nameEN: 'Fair Antigua, We Salute Thee', nameCN: '美丽的安提瓜，我们向你致敬' },
  'kn': { code: 'kn', nameEN: 'O Land of Beauty!', nameCN: '哦，美丽的土地' },
  'dm': { code: 'dm', nameEN: 'Isle of Beauty, Isle of Splendour', nameCN: '美丽之岛，辉煌之岛' },
  'bs': { code: 'bs', nameEN: 'March On, Bahamaland', nameCN: '前进，巴哈马' },
  
  // 大洋洲
  'au': { code: 'au', nameEN: 'Advance Australia Fair', nameCN: '前进，美丽的澳大利亚' },
  'nz': { code: 'nz', nameEN: 'God Defend New Zealand', nameCN: '上帝保卫新西兰' },
  'pg': { code: 'pg', nameEN: 'O Arise, All You Sons', nameCN: '哦，起来，所有的儿子' },
  'fj': { code: 'fj', nameEN: 'Meda Dau Doka', nameCN: '上帝保佑斐济' },
  'sb': { code: 'sb', nameEN: 'God Save Our Solomon Islands', nameCN: '上帝保佑我们的所罗门群岛' },
  'vu': { code: 'vu', nameEN: 'Yumi, Yumi, Yumi', nameCN: '我们，我们，我们' },
  'nc': { code: 'nc', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  'pf': { code: 'pf', nameEN: 'La Marseillaise', nameCN: '马赛曲' },
  'ws': { code: 'ws', nameEN: 'The Banner of Freedom', nameCN: '自由之旗' },
  'ki': { code: 'ki', nameEN: 'Teirake kaini Kiribati', nameCN: '站起来，基里巴斯' },
  'tv': { code: 'tv', nameEN: 'Tuvalu mo te Atua', nameCN: '图瓦卢为了上帝' },
  'nr': { code: 'nr', nameEN: 'Nauru Bwiema', nameCN: '瑙鲁，我们的家园' },
  'pw': { code: 'pw', nameEN: 'Belau rekid', nameCN: '我们的帕劳' },
  'fm': { code: 'fm', nameEN: 'Patriots of Micronesia', nameCN: '密克罗尼西亚的爱国者' },
  'mh': { code: 'mh', nameEN: 'Forever Marshall Islands', nameCN: '永远的马绍尔群岛' },
};

/**
 * 获取国歌名称（英文）
 */
export function getAnthemNameEN(countryCode: string): string {
  const code = countryCode.toLowerCase();
  return AnthemNames[code]?.nameEN || '';
}

/**
 * 获取国歌名称（中文）
 */
export function getAnthemNameCN(countryCode: string): string {
  const code = countryCode.toLowerCase();
  return AnthemNames[code]?.nameCN || '';
}

/**
 * 获取国歌信息
 */
export function getAnthemInfo(countryCode: string): AnthemInfo | undefined {
  const code = countryCode.toLowerCase();
  return AnthemNames[code];
}

/**
 * 检查是否有国歌名称数据
 */
export function hasAnthemName(countryCode: string): boolean {
  const code = countryCode.toLowerCase();
  return AnthemNames[code] !== undefined;
}

