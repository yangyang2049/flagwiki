// 本周国旗数据 - 按国庆日选择每周展示的国旗

export interface WeeklyFlagItem {
  weekNumber: number;        // 第几周 (1-52)
  countryCode: string;       // 国家代码
  countryNameCN: string;     // 中文名称
  nationalDay: string;       // 国庆日日期 (MM-DD格式)
  nationalDayDesc: string;   // 国庆日描述
}

// 最近十周的国旗数据（按国庆日选择）
// 基于2025年12月的周数往前推10周
const weeklyFlags: WeeklyFlagItem[] = [
  // 第49周 (12月1日-7日) - 阿联酋国庆日 12月2日
  { weekNumber: 49, countryCode: 'ae', countryNameCN: '阿联酋', nationalDay: '12-02', nationalDayDesc: '阿联酋国庆日（独立日）' },
  // 第50周 (12月8日-14日) - 芬兰独立日 12月6日（放这周展示）
  { weekNumber: 50, countryCode: 'fi', countryNameCN: '芬兰', nationalDay: '12-06', nationalDayDesc: '芬兰独立日' },
  // 第51周 (12月15日-21日) - 卡塔尔国庆日 12月18日
  { weekNumber: 51, countryCode: 'qa', countryNameCN: '卡塔尔', nationalDay: '12-18', nationalDayDesc: '卡塔尔国庆日' },
  // 第52周 (12月22日-28日) - 尼泊尔国庆日 12月28日
  { weekNumber: 52, countryCode: 'np', countryNameCN: '尼泊尔', nationalDay: '12-28', nationalDayDesc: '尼泊尔统一日' },
  // 第1周 (12月29日-1月4日) - 古巴解放日 1月1日
  { weekNumber: 1, countryCode: 'cu', countryNameCN: '古巴', nationalDay: '01-01', nationalDayDesc: '古巴解放日' },
  // 第2周 (1月5日-11日) - 苏丹独立日 1月1日
  { weekNumber: 2, countryCode: 'sd', countryNameCN: '苏丹', nationalDay: '01-01', nationalDayDesc: '苏丹独立日' },
  // 第45周 (11月3日-9日) - 巴拿马独立日 11月3日
  { weekNumber: 45, countryCode: 'pa', countryNameCN: '巴拿马', nationalDay: '11-03', nationalDayDesc: '巴拿马独立日' },
  // 第46周 (11月10日-16日) - 波兰独立日 11月11日
  { weekNumber: 46, countryCode: 'pl', countryNameCN: '波兰', nationalDay: '11-11', nationalDayDesc: '波兰独立日' },
  // 第47周 (11月17日-23日) - 拉脱维亚独立日 11月18日
  { weekNumber: 47, countryCode: 'lv', countryNameCN: '拉脱维亚', nationalDay: '11-18', nationalDayDesc: '拉脱维亚独立日' },
  // 第48周 (11月24日-30日) - 阿尔巴尼亚独立日 11月28日
  { weekNumber: 48, countryCode: 'al', countryNameCN: '阿尔巴尼亚', nationalDay: '11-28', nationalDayDesc: '阿尔巴尼亚独立日' },
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

// 获取最近10周的国旗数据（按当前周排序）
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






