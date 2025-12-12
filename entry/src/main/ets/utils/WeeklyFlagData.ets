// 本周国旗数据 - 按国庆日选择每周展示的国旗

export interface WeeklyFlagItem {
  weekNumber: number;        // 第几周 (1-52)
  countryCode: string;       // 国家代码
  countryNameCN: string;     // 中文名称
  nationalDay: string;       // 国庆日日期 (MM-DD格式)
  nationalDayDesc: string;   // 国庆日描述
}

// 全年52周的国旗数据（基于各国国庆日/独立日选择）
const weeklyFlags: WeeklyFlagItem[] = [
  // === 1月 ===
  // 第1周 (12月29日-1月4日) - 古巴解放日 1月1日
  { weekNumber: 1, countryCode: 'cu', countryNameCN: '古巴', nationalDay: '01-01', nationalDayDesc: '古巴解放日' },
  // 第2周 (1月5日-11日) - 苏丹独立日 1月1日
  { weekNumber: 2, countryCode: 'sd', countryNameCN: '苏丹', nationalDay: '01-01', nationalDayDesc: '苏丹独立日' },
  // 第3周 (1月12日-18日) - 塞尔维亚建国日 1月15日
  { weekNumber: 3, countryCode: 'rs', countryNameCN: '塞尔维亚', nationalDay: '01-15', nationalDayDesc: '塞尔维亚建国日' },
  // 第4周 (1月19日-25日) - 澳大利亚国庆日 1月26日
  { weekNumber: 4, countryCode: 'au', countryNameCN: '澳大利亚', nationalDay: '01-26', nationalDayDesc: '澳大利亚国庆日' },
  
  // === 2月 ===
  // 第5周 (1月26日-2月1日) - 新西兰国庆日 2月6日（怀唐伊日）
  { weekNumber: 5, countryCode: 'nz', countryNameCN: '新西兰', nationalDay: '02-06', nationalDayDesc: '新西兰怀唐伊日' },
  // 第6周 (2月2日-8日) - 斯里兰卡独立日 2月4日
  { weekNumber: 6, countryCode: 'lk', countryNameCN: '斯里兰卡', nationalDay: '02-04', nationalDayDesc: '斯里兰卡独立日' },
  // 第7周 (2月9日-15日) - 立陶宛独立日 2月16日
  { weekNumber: 7, countryCode: 'lt', countryNameCN: '立陶宛', nationalDay: '02-16', nationalDayDesc: '立陶宛独立日' },
  // 第8周 (2月16日-22日) - 爱沙尼亚独立日 2月24日
  { weekNumber: 8, countryCode: 'ee', countryNameCN: '爱沙尼亚', nationalDay: '02-24', nationalDayDesc: '爱沙尼亚独立日' },
  
  // === 3月 ===
  // 第9周 (2月23日-3月1日) - 保加利亚解放日 3月3日
  { weekNumber: 9, countryCode: 'bg', countryNameCN: '保加利亚', nationalDay: '03-03', nationalDayDesc: '保加利亚解放日' },
  // 第10周 (3月2日-8日) - 加纳独立日 3月6日
  { weekNumber: 10, countryCode: 'gh', countryNameCN: '加纳', nationalDay: '03-06', nationalDayDesc: '加纳独立日' },
  // 第11周 (3月9日-15日) - 爱尔兰圣帕特里克节 3月17日
  { weekNumber: 11, countryCode: 'ie', countryNameCN: '爱尔兰', nationalDay: '03-17', nationalDayDesc: '爱尔兰圣帕特里克节' },
  // 第12周 (3月16日-22日) - 希腊独立日 3月25日
  { weekNumber: 12, countryCode: 'gr', countryNameCN: '希腊', nationalDay: '03-25', nationalDayDesc: '希腊独立日' },
  // 第13周 (3月23日-29日) - 孟加拉国独立日 3月26日
  { weekNumber: 13, countryCode: 'bd', countryNameCN: '孟加拉国', nationalDay: '03-26', nationalDayDesc: '孟加拉国独立日' },
  
  // === 4月 ===
  // 第14周 (3月30日-4月5日) - 塞内加尔独立日 4月4日
  { weekNumber: 14, countryCode: 'sn', countryNameCN: '塞内加尔', nationalDay: '04-04', nationalDayDesc: '塞内加尔独立日' },
  // 第15周 (4月6日-12日) - 泰国宋干节 4月13日
  { weekNumber: 15, countryCode: 'th', countryNameCN: '泰国', nationalDay: '04-13', nationalDayDesc: '泰国宋干节' },
  // 第16周 (4月13日-19日) - 津巴布韦独立日 4月18日
  { weekNumber: 16, countryCode: 'zw', countryNameCN: '津巴布韦', nationalDay: '04-18', nationalDayDesc: '津巴布韦独立日' },
  // 第17周 (4月20日-26日) - 荷兰国王日 4月27日
  { weekNumber: 17, countryCode: 'nl', countryNameCN: '荷兰', nationalDay: '04-27', nationalDayDesc: '荷兰国王日' },
  
  // === 5月 ===
  // 第18周 (4月27日-5月3日) - 以色列独立日 5月14日（依犹太历，约5月）
  { weekNumber: 18, countryCode: 'il', countryNameCN: '以色列', nationalDay: '05-14', nationalDayDesc: '以色列独立日' },
  // 第19周 (5月4日-10日) - 挪威宪法日 5月17日
  { weekNumber: 19, countryCode: 'no', countryNameCN: '挪威', nationalDay: '05-17', nationalDayDesc: '挪威宪法日' },
  // 第20周 (5月11日-17日) - 阿根廷五月革命日 5月25日
  { weekNumber: 20, countryCode: 'ar', countryNameCN: '阿根廷', nationalDay: '05-25', nationalDayDesc: '阿根廷五月革命日' },
  // 第21周 (5月18日-24日) - 约旦独立日 5月25日
  { weekNumber: 21, countryCode: 'jo', countryNameCN: '约旦', nationalDay: '05-25', nationalDayDesc: '约旦独立日' },
  // 第22周 (5月25日-31日) - 尼日利亚民主日 5月29日
  { weekNumber: 22, countryCode: 'ng', countryNameCN: '尼日利亚', nationalDay: '05-29', nationalDayDesc: '尼日利亚民主日' },
  
  // === 6月 ===
  // 第23周 (6月1日-7日) - 丹麦宪法日 6月5日
  { weekNumber: 23, countryCode: 'dk', countryNameCN: '丹麦', nationalDay: '06-05', nationalDayDesc: '丹麦宪法日' },
  // 第24周 (6月8日-14日) - 瑞典国庆日 6月6日
  { weekNumber: 24, countryCode: 'se', countryNameCN: '瑞典', nationalDay: '06-06', nationalDayDesc: '瑞典国庆日' },
  // 第25周 (6月15日-21日) - 冰岛独立日 6月17日
  { weekNumber: 25, countryCode: 'is', countryNameCN: '冰岛', nationalDay: '06-17', nationalDayDesc: '冰岛独立日' },
  // 第26周 (6月22日-28日) - 卢森堡国庆日 6月23日
  { weekNumber: 26, countryCode: 'lu', countryNameCN: '卢森堡', nationalDay: '06-23', nationalDayDesc: '卢森堡国庆日' },
  
  // === 7月 ===
  // 第27周 (6月29日-7月5日) - 加拿大国庆日 7月1日
  { weekNumber: 27, countryCode: 'ca', countryNameCN: '加拿大', nationalDay: '07-01', nationalDayDesc: '加拿大国庆日' },
  // 第28周 (7月6日-12日) - 美国独立日 7月4日
  { weekNumber: 28, countryCode: 'us', countryNameCN: '美国', nationalDay: '07-04', nationalDayDesc: '美国独立日' },
  // 第29周 (7月13日-19日) - 法国国庆日 7月14日
  { weekNumber: 29, countryCode: 'fr', countryNameCN: '法国', nationalDay: '07-14', nationalDayDesc: '法国国庆日（巴士底日）' },
  // 第30周 (7月20日-26日) - 哥伦比亚独立日 7月20日
  { weekNumber: 30, countryCode: 'co', countryNameCN: '哥伦比亚', nationalDay: '07-20', nationalDayDesc: '哥伦比亚独立日' },
  
  // === 8月 ===
  // 第31周 (7月27日-8月2日) - 瑞士国庆日 8月1日
  { weekNumber: 31, countryCode: 'ch', countryNameCN: '瑞士', nationalDay: '08-01', nationalDayDesc: '瑞士国庆日' },
  // 第32周 (8月3日-9日) - 牙买加独立日 8月6日
  { weekNumber: 32, countryCode: 'jm', countryNameCN: '牙买加', nationalDay: '08-06', nationalDayDesc: '牙买加独立日' },
  // 第33周 (8月10日-16日) - 新加坡国庆日 8月9日
  { weekNumber: 33, countryCode: 'sg', countryNameCN: '新加坡', nationalDay: '08-09', nationalDayDesc: '新加坡国庆日' },
  // 第34周 (8月17日-23日) - 印度独立日 8月15日
  { weekNumber: 34, countryCode: 'in', countryNameCN: '印度', nationalDay: '08-15', nationalDayDesc: '印度独立日' },
  // 第35周 (8月24日-30日) - 乌克兰独立日 8月24日
  { weekNumber: 35, countryCode: 'ua', countryNameCN: '乌克兰', nationalDay: '08-24', nationalDayDesc: '乌克兰独立日' },
  
  // === 9月 ===
  // 第36周 (8月31日-9月6日) - 巴西独立日 9月7日
  { weekNumber: 36, countryCode: 'br', countryNameCN: '巴西', nationalDay: '09-07', nationalDayDesc: '巴西独立日' },
  // 第37周 (9月7日-13日) - 墨西哥独立日 9月16日
  { weekNumber: 37, countryCode: 'mx', countryNameCN: '墨西哥', nationalDay: '09-16', nationalDayDesc: '墨西哥独立日' },
  // 第38周 (9月14日-20日) - 智利独立日 9月18日
  { weekNumber: 38, countryCode: 'cl', countryNameCN: '智利', nationalDay: '09-18', nationalDayDesc: '智利独立日' },
  // 第39周 (9月21日-27日) - 沙特阿拉伯国庆日 9月23日
  { weekNumber: 39, countryCode: 'sa', countryNameCN: '沙特阿拉伯', nationalDay: '09-23', nationalDayDesc: '沙特阿拉伯国庆日' },
  
  // === 10月 ===
  // 第40周 (9月28日-10月4日) - 中国国庆日 10月1日
  { weekNumber: 40, countryCode: 'cn', countryNameCN: '中国', nationalDay: '10-01', nationalDayDesc: '中华人民共和国国庆日' },
  // 第41周 (10月5日-11日) - 德国统一日 10月3日
  { weekNumber: 41, countryCode: 'de', countryNameCN: '德国', nationalDay: '10-03', nationalDayDesc: '德国统一日' },
  // 第42周 (10月12日-18日) - 西班牙国庆日 10月12日
  { weekNumber: 42, countryCode: 'es', countryNameCN: '西班牙', nationalDay: '10-12', nationalDayDesc: '西班牙国庆日' },
  // 第43周 (10月19日-25日) - 奥地利国庆日 10月26日
  { weekNumber: 43, countryCode: 'at', countryNameCN: '奥地利', nationalDay: '10-26', nationalDayDesc: '奥地利国庆日' },
  // 第44周 (10月26日-11月1日) - 土耳其共和国日 10月29日
  { weekNumber: 44, countryCode: 'tr', countryNameCN: '土耳其', nationalDay: '10-29', nationalDayDesc: '土耳其共和国日' },
  
  // === 11月 ===
  // 第45周 (11月2日-8日) - 巴拿马独立日 11月3日
  { weekNumber: 45, countryCode: 'pa', countryNameCN: '巴拿马', nationalDay: '11-03', nationalDayDesc: '巴拿马独立日' },
  // 第46周 (11月9日-15日) - 波兰独立日 11月11日
  { weekNumber: 46, countryCode: 'pl', countryNameCN: '波兰', nationalDay: '11-11', nationalDayDesc: '波兰独立日' },
  // 第47周 (11月16日-22日) - 拉脱维亚独立日 11月18日
  { weekNumber: 47, countryCode: 'lv', countryNameCN: '拉脱维亚', nationalDay: '11-18', nationalDayDesc: '拉脱维亚独立日' },
  // 第48周 (11月23日-29日) - 阿尔巴尼亚独立日 11月28日
  { weekNumber: 48, countryCode: 'al', countryNameCN: '阿尔巴尼亚', nationalDay: '11-28', nationalDayDesc: '阿尔巴尼亚独立日' },
  
  // === 12月 ===
  // 第49周 (11月30日-12月6日) - 阿联酋国庆日 12月2日
  { weekNumber: 49, countryCode: 'ae', countryNameCN: '阿联酋', nationalDay: '12-02', nationalDayDesc: '阿联酋国庆日' },
  // 第50周 (12月7日-13日) - 芬兰独立日 12月6日
  { weekNumber: 50, countryCode: 'fi', countryNameCN: '芬兰', nationalDay: '12-06', nationalDayDesc: '芬兰独立日' },
  // 第51周 (12月14日-20日) - 卡塔尔国庆日 12月18日
  { weekNumber: 51, countryCode: 'qa', countryNameCN: '卡塔尔', nationalDay: '12-18', nationalDayDesc: '卡塔尔国庆日' },
  // 第52周 (12月21日-27日) - 日本天皇诞生日 12月23日（改为展示日本）
  { weekNumber: 52, countryCode: 'jp', countryNameCN: '日本', nationalDay: '12-23', nationalDayDesc: '日本天皇诞生日' },
];

// 获取当前年的周数
function getWeekNumber(date: Date): number {
  const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
  const pastDaysOfYear = (date.getTime() - firstDayOfYear.getTime()) / 86400000;
  return Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
}

// 获取当前周的国旗
export function getCurrentWeekFlag(): WeeklyFlagItem | undefined {
  const now = new Date();
  const currentWeek = getWeekNumber(now);
  return weeklyFlags.find(item => item.weekNumber === currentWeek);
}

// 获取指定周的国旗
export function getWeekFlag(weekNumber: number): WeeklyFlagItem | undefined {
  return weeklyFlags.find(item => item.weekNumber === weekNumber);
}

// 获取最近的国旗数据（按当前周排序）
export function getRecentWeekFlags(): WeeklyFlagItem[] {
  const now = new Date();
  const currentWeek = getWeekNumber(now);
  
  // 按距离当前周的远近排序
  const sortedFlags = [...weeklyFlags].sort((a, b) => {
    const distA = Math.abs(a.weekNumber - currentWeek);
    const distB = Math.abs(b.weekNumber - currentWeek);
    // 处理跨年的情况
    const adjustedDistA = Math.min(distA, 52 - distA);
    const adjustedDistB = Math.min(distB, 52 - distB);
    return adjustedDistA - adjustedDistB;
  });
  
  return sortedFlags;
}

// 获取所有周旗数据
export function getAllWeeklyFlags(): WeeklyFlagItem[] {
  return weeklyFlags;
}







