/**
 * 主要城市社保缴费基数上限数据
 * 数据来源：2025年各地社保部门公布的数据
 * 缴费基数上限通常为当地上年度社平工资的3倍
 * 数据更新日期：2025年
 */
export interface CityData {
  city: string;
  maxBase: number; // 缴费基数上限（元/月）
}

export const CITY_DATA: CityData[] = [
  { city: '上海', maxBase: 37302 },
  { city: '北京', maxBase: 35811 },
  { city: '成都', maxBase: 31378 },
  { city: '广州', maxBase: 27549 },
  { city: '深圳', maxBase: 27501 },
  { city: '天津', maxBase: 25620 },
  { city: '杭州', maxBase: 25299 },
  { city: '宁波', maxBase: 25299 },
  { city: '苏州', maxBase: 24762 },
  { city: '南京', maxBase: 24762 },
  { city: '武汉', maxBase: 22467 },
  { city: '济南', maxBase: 22078 },
  { city: '重庆', maxBase: 22017 },
  { city: '长沙', maxBase: 20361 },
  { city: '西安', maxBase: 20955 },
  { city: '郑州', maxBase: 17895 },
  { city: '青岛', maxBase: 21207 },
  { city: '无锡', maxBase: 24762 },
  { city: '佛山', maxBase: 27549 },
  { city: '东莞', maxBase: 27549 },
  { city: '合肥', maxBase: 19160 },
  { city: '大连', maxBase: 20121 },
  { city: '厦门', maxBase: 20331 },
  { city: '福州', maxBase: 20331 },
  { city: '昆明', maxBase: 19593 },
  { city: '南昌', maxBase: 18432 },
  { city: '石家庄', maxBase: 17895 },
  { city: '哈尔滨', maxBase: 18432 },
  { city: '长春', maxBase: 18432 },
  { city: '沈阳', maxBase: 20121 },
  { city: '太原', maxBase: 18432 },
  { city: '南宁', maxBase: 18432 },
  { city: '海口', maxBase: 18432 },
  { city: '贵阳', maxBase: 18432 },
  { city: '银川', maxBase: 18432 },
  { city: '西宁', maxBase: 18432 },
  { city: '乌鲁木齐', maxBase: 18432 },
  { city: '拉萨', maxBase: 18432 }
];

/**
 * 获取所有城市名称列表
 */
export function getAllCityNames(): string[] {
  return CITY_DATA.map(item => item.city);
}

/**
 * 根据城市名称获取缴费基数上限
 * @param cityName 城市名称
 * @returns 缴费基数上限，如果城市不存在则返回 null
 */
export function getMaxBaseByCity(cityName: string): number | null {
  const city = CITY_DATA.find(item => item.city === cityName);
  return city ? city.maxBase : null;
}

/**
 * 检查城市是否在数据列表中
 * @param cityName 城市名称
 * @returns 是否存在
 */
export function isCityInList(cityName: string): boolean {
  return CITY_DATA.some(item => item.city === cityName);
}

