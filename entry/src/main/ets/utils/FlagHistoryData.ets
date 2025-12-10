/**
 * 历史国旗数据
 * 存储各国国旗的历史变迁信息
 * 数据来源：维基百科 - 各国国旗变迁时间轴
 * https://zh.wikipedia.org/wiki/各国国旗变迁时间轴
 */

import { getCountryByCode } from './countryData';

// 历史国旗条目
export interface FlagHistoryItem {
  countryCode: string;  // 国家代码
  year: number;         // 年份
  imagePath: string;    // 图片路径（资源名称，不含扩展名）
  description?: string; // 可选描述
}

// 国家历史国旗数据
export interface CountryFlagHistory {
  countryCode: string;
  history: FlagHistoryItem[];
}

// 历史国旗数据
const FLAG_HISTORY_DATA: CountryFlagHistory[] = [
  {
    countryCode: 'ad',
    history: [
      { countryCode: 'ad', year: 1000, imagePath: 'flag_history_ad_1000', description: '安道尔 1000年国旗' },
      { countryCode: 'ad', year: 1806, imagePath: 'flag_history_ad_1806', description: '安道尔 1806年国旗' },
      { countryCode: 'ad', year: 1812, imagePath: 'flag_history_ad_1812', description: '安道尔 1812年国旗' },
      { countryCode: 'ad', year: 1813, imagePath: 'flag_history_ad_1813', description: '安道尔 1813年国旗' },
      { countryCode: 'ad', year: 1866, imagePath: 'flag_history_ad_1866', description: '安道尔 1866年国旗' }
    ]
  },
  {
    countryCode: 'ae',
    history: [
      { countryCode: 'ae', year: 1200, imagePath: 'flag_history_ae_1200', description: '阿联酋 1200年国旗' },
      { countryCode: 'ae', year: 1892, imagePath: 'flag_history_ae_1892', description: '阿联酋 1892年国旗' },
      { countryCode: 'ae', year: 1950, imagePath: 'flag_history_ae_1950', description: '阿联酋 1950年国旗' },
      { countryCode: 'ae', year: 1971, imagePath: 'flag_history_ae_1971', description: '阿联酋 1971年国旗' }
    ]
  },
  {
    countryCode: 'af',
    history: [
      { countryCode: 'af', year: 1570, imagePath: 'flag_history_af_1570', description: '阿富汗 1570年国旗' },
      { countryCode: 'af', year: 1738, imagePath: 'flag_history_af_1738', description: '阿富汗 1738年国旗' },
      { countryCode: 'af', year: 1747, imagePath: 'flag_history_af_1747', description: '阿富汗 1747年国旗' },
      { countryCode: 'af', year: 1880, imagePath: 'flag_history_af_1880', description: '阿富汗 1880年国旗' },
      { countryCode: 'af', year: 1901, imagePath: 'flag_history_af_1901', description: '阿富汗 1901年国旗' },
      { countryCode: 'af', year: 1919, imagePath: 'flag_history_af_1919', description: '阿富汗 1919年国旗' },
      { countryCode: 'af', year: 1921, imagePath: 'flag_history_af_1921', description: '阿富汗 1921年国旗' },
      { countryCode: 'af', year: 1928, imagePath: 'flag_history_af_1928', description: '阿富汗 1928年国旗' },
      { countryCode: 'af', year: 1929, imagePath: 'flag_history_af_1929', description: '阿富汗 1929年国旗' },
      { countryCode: 'af', year: 1930, imagePath: 'flag_history_af_1930', description: '阿富汗 1930年国旗' },
      { countryCode: 'af', year: 1973, imagePath: 'flag_history_af_1973', description: '阿富汗 1973年国旗' },
      { countryCode: 'af', year: 1978, imagePath: 'flag_history_af_1978', description: '阿富汗 1978年国旗' },
      { countryCode: 'af', year: 1979, imagePath: 'flag_history_af_1979', description: '阿富汗 1979年国旗' },
      { countryCode: 'af', year: 1992, imagePath: 'flag_history_af_1992', description: '阿富汗 1992年国旗' },
      { countryCode: 'af', year: 1996, imagePath: 'flag_history_af_1996', description: '阿富汗 1996年国旗' },
      { countryCode: 'af', year: 1997, imagePath: 'flag_history_af_1997', description: '阿富汗 1997年国旗' },
      { countryCode: 'af', year: 2001, imagePath: 'flag_history_af_2001', description: '阿富汗 2001年国旗' },
      { countryCode: 'af', year: 2002, imagePath: 'flag_history_af_2002', description: '阿富汗 2002年国旗' },
      { countryCode: 'af', year: 2004, imagePath: 'flag_history_af_2004', description: '阿富汗 2004年国旗' },
      { countryCode: 'af', year: 2021, imagePath: 'flag_history_af_2021', description: '阿富汗 2021年国旗（当前）' }
    ]
  },
  {
    countryCode: 'ag',
    history: [
      { countryCode: 'ag', year: 1632, imagePath: 'flag_history_ag_1632', description: '安提瓜和巴布达 1632年国旗' },
      { countryCode: 'ag', year: 1801, imagePath: 'flag_history_ag_1801', description: '安提瓜和巴布达 1801年国旗' },
      { countryCode: 'ag', year: 1958, imagePath: 'flag_history_ag_1958', description: '安提瓜和巴布达 1958年国旗' },
      { countryCode: 'ag', year: 1962, imagePath: 'flag_history_ag_1962', description: '安提瓜和巴布达 1962年国旗' },
      { countryCode: 'ag', year: 1967, imagePath: 'flag_history_ag_1967', description: '安提瓜和巴布达 1967年国旗' }
    ]
  },
  {
    countryCode: 'al',
    history: [
      { countryCode: 'al', year: 1453, imagePath: 'flag_history_al_1453', description: '阿尔巴尼亚 1453年国旗' },
      { countryCode: 'al', year: 1844, imagePath: 'flag_history_al_1844', description: '阿尔巴尼亚 1844年国旗' },
      { countryCode: 'al', year: 1912, imagePath: 'flag_history_al_1912', description: '阿尔巴尼亚 1912年国旗' },
      { countryCode: 'al', year: 1914, imagePath: 'flag_history_al_1914', description: '阿尔巴尼亚 1914年国旗' },
      { countryCode: 'al', year: 1920, imagePath: 'flag_history_al_1920', description: '阿尔巴尼亚 1920年国旗' },
      { countryCode: 'al', year: 1926, imagePath: 'flag_history_al_1926', description: '阿尔巴尼亚 1926年国旗' },
      { countryCode: 'al', year: 1928, imagePath: 'flag_history_al_1928', description: '阿尔巴尼亚 1928年国旗' },
      { countryCode: 'al', year: 1934, imagePath: 'flag_history_al_1934', description: '阿尔巴尼亚 1934年国旗' },
      { countryCode: 'al', year: 1939, imagePath: 'flag_history_al_1939', description: '阿尔巴尼亚 1939年国旗' },
      { countryCode: 'al', year: 1943, imagePath: 'flag_history_al_1943', description: '阿尔巴尼亚 1943年国旗' },
      { countryCode: 'al', year: 1944, imagePath: 'flag_history_al_1944', description: '阿尔巴尼亚 1944年国旗' },
      { countryCode: 'al', year: 1946, imagePath: 'flag_history_al_1946', description: '阿尔巴尼亚 1946年国旗' },
      { countryCode: 'al', year: 1992, imagePath: 'flag_history_al_1992', description: '阿尔巴尼亚 1992年国旗' }
    ]
  },
  {
    countryCode: 'am',
    history: [
      { countryCode: 'am', year: 1200, imagePath: 'flag_history_am_1200', description: '亚美尼亚 1200年国旗' },
      { countryCode: 'am', year: 1453, imagePath: 'flag_history_am_1453', description: '亚美尼亚 1453年国旗' },
      { countryCode: 'am', year: 1828, imagePath: 'flag_history_am_1828', description: '亚美尼亚 1828年国旗' },
      { countryCode: 'am', year: 1858, imagePath: 'flag_history_am_1858', description: '亚美尼亚 1858年国旗' },
      { countryCode: 'am', year: 1883, imagePath: 'flag_history_am_1883', description: '亚美尼亚 1883年国旗' },
      { countryCode: 'am', year: 1918, imagePath: 'flag_history_am_1918', description: '亚美尼亚 1918年国旗' },
      { countryCode: 'am', year: 1922, imagePath: 'flag_history_am_1922', description: '亚美尼亚 1922年国旗' },
      { countryCode: 'am', year: 1937, imagePath: 'flag_history_am_1937', description: '亚美尼亚 1937年国旗' },
      { countryCode: 'am', year: 1940, imagePath: 'flag_history_am_1940', description: '亚美尼亚 1940年国旗' },
      { countryCode: 'am', year: 1952, imagePath: 'flag_history_am_1952', description: '亚美尼亚 1952年国旗' },
      { countryCode: 'am', year: 1990, imagePath: 'flag_history_am_1990', description: '亚美尼亚 1990年国旗' }
    ]
  },
  {
    countryCode: 'ao',
    history: [
      { countryCode: 'ao', year: 1667, imagePath: 'flag_history_ao_1667', description: '安哥拉 1667年国旗' },
      { countryCode: 'ao', year: 1707, imagePath: 'flag_history_ao_1707', description: '安哥拉 1707年国旗' },
      { countryCode: 'ao', year: 1750, imagePath: 'flag_history_ao_1750', description: '安哥拉 1750年国旗' },
      { countryCode: 'ao', year: 1816, imagePath: 'flag_history_ao_1816', description: '安哥拉 1816年国旗' },
      { countryCode: 'ao', year: 1826, imagePath: 'flag_history_ao_1826', description: '安哥拉 1826年国旗' },
      { countryCode: 'ao', year: 1830, imagePath: 'flag_history_ao_1830', description: '安哥拉 1830年国旗' },
      { countryCode: 'ao', year: 1911, imagePath: 'flag_history_ao_1911', description: '安哥拉 1911年国旗' },
      { countryCode: 'ao', year: 1975, imagePath: 'flag_history_ao_1975', description: '安哥拉 1975年国旗' }
    ]
  },
  {
    countryCode: 'ar',
    history: [
      { countryCode: 'ar', year: 1536, imagePath: 'flag_history_ar_1536', description: '阿根廷 1536年国旗' },
      { countryCode: 'ar', year: 1717, imagePath: 'flag_history_ar_1717', description: '阿根廷 1717年国旗' },
      { countryCode: 'ar', year: 1785, imagePath: 'flag_history_ar_1785', description: '阿根廷 1785年国旗' },
      { countryCode: 'ar', year: 1812, imagePath: 'flag_history_ar_1812', description: '阿根廷 1812年国旗' },
      { countryCode: 'ar', year: 1816, imagePath: 'flag_history_ar_1816', description: '阿根廷 1816年国旗' },
      { countryCode: 'ar', year: 1818, imagePath: 'flag_history_ar_1818', description: '阿根廷 1818年国旗' },
      { countryCode: 'ar', year: 1830, imagePath: 'flag_history_ar_1830', description: '阿根廷 1830年国旗' },
      { countryCode: 'ar', year: 1835, imagePath: 'flag_history_ar_1835', description: '阿根廷 1835年国旗' },
      { countryCode: 'ar', year: 1850, imagePath: 'flag_history_ar_1850', description: '阿根廷 1850年国旗' },
      { countryCode: 'ar', year: 1861, imagePath: 'flag_history_ar_1861', description: '阿根廷 1861年国旗' }
    ]
  },
  {
    countryCode: 'at',
    history: [
      { countryCode: 'at', year: 1230, imagePath: 'flag_history_at_1230', description: '奥地利 1230年国旗' },
      { countryCode: 'at', year: 1804, imagePath: 'flag_history_at_1804', description: '奥地利 1804年国旗' },
      { countryCode: 'at', year: 1918, imagePath: 'flag_history_at_1918', description: '奥地利 1918年国旗' },
      { countryCode: 'at', year: 1938, imagePath: 'flag_history_at_1938', description: '奥地利 1938年国旗' },
      { countryCode: 'at', year: 1945, imagePath: 'flag_history_at_1945', description: '奥地利 1945年国旗' }
    ]
  },
  {
    countryCode: 'au',
    history: [
      { countryCode: 'au', year: 1280, imagePath: 'flag_history_au_1280', description: '澳大利亚 1280年国旗' },
      { countryCode: 'au', year: 1770, imagePath: 'flag_history_au_1770', description: '澳大利亚 1770年国旗' },
      { countryCode: 'au', year: 1801, imagePath: 'flag_history_au_1801', description: '澳大利亚 1801年国旗' },
      { countryCode: 'au', year: 1901, imagePath: 'flag_history_au_1901', description: '澳大利亚 1901年国旗' },
      { countryCode: 'au', year: 1903, imagePath: 'flag_history_au_1903', description: '澳大利亚 1903年国旗' },
      { countryCode: 'au', year: 1909, imagePath: 'flag_history_au_1909', description: '澳大利亚 1909年国旗' }
    ]
  },
  {
    countryCode: 'az',
    history: [
      { countryCode: 'az', year: 1200, imagePath: 'flag_history_az_1200', description: '阿塞拜疆 1200年国旗' },
      { countryCode: 'az', year: 1576, imagePath: 'flag_history_az_1576', description: '阿塞拜疆 1576年国旗' },
      { countryCode: 'az', year: 1736, imagePath: 'flag_history_az_1736', description: '阿塞拜疆 1736年国旗' },
      { countryCode: 'az', year: 1747, imagePath: 'flag_history_az_1747', description: '阿塞拜疆 1747年国旗' },
      { countryCode: 'az', year: 1760, imagePath: 'flag_history_az_1760', description: '阿塞拜疆 1760年国旗' },
      { countryCode: 'az', year: 1796, imagePath: 'flag_history_az_1796', description: '阿塞拜疆 1796年国旗' },
      { countryCode: 'az', year: 1813, imagePath: 'flag_history_az_1813', description: '阿塞拜疆 1813年国旗' },
      { countryCode: 'az', year: 1858, imagePath: 'flag_history_az_1858', description: '阿塞拜疆 1858年国旗' },
      { countryCode: 'az', year: 1883, imagePath: 'flag_history_az_1883', description: '阿塞拜疆 1883年国旗' },
      { countryCode: 'az', year: 1918, imagePath: 'flag_history_az_1918', description: '阿塞拜疆 1918年国旗' },
      { countryCode: 'az', year: 1920, imagePath: 'flag_history_az_1920', description: '阿塞拜疆 1920年国旗' },
      { countryCode: 'az', year: 1922, imagePath: 'flag_history_az_1922', description: '阿塞拜疆 1922年国旗' },
      { countryCode: 'az', year: 1937, imagePath: 'flag_history_az_1937', description: '阿塞拜疆 1937年国旗' },
      { countryCode: 'az', year: 1940, imagePath: 'flag_history_az_1940', description: '阿塞拜疆 1940年国旗' },
      { countryCode: 'az', year: 1952, imagePath: 'flag_history_az_1952', description: '阿塞拜疆 1952年国旗' },
      { countryCode: 'az', year: 1990, imagePath: 'flag_history_az_1990', description: '阿塞拜疆 1990年国旗' }
    ]
  },
  {
    countryCode: 'ba',
    history: [
      { countryCode: 'ba', year: 1453, imagePath: 'flag_history_ba_1453', description: '波斯尼亚和黑塞哥维那 1453年国旗' },
      { countryCode: 'ba', year: 1844, imagePath: 'flag_history_ba_1844', description: '波斯尼亚和黑塞哥维那 1844年国旗' },
      { countryCode: 'ba', year: 1878, imagePath: 'flag_history_ba_1878', description: '波斯尼亚和黑塞哥维那 1878年国旗' },
      { countryCode: 'ba', year: 1908, imagePath: 'flag_history_ba_1908', description: '波斯尼亚和黑塞哥维那 1908年国旗' },
      { countryCode: 'ba', year: 1922, imagePath: 'flag_history_ba_1922', description: '波斯尼亚和黑塞哥维那 1922年国旗' },
      { countryCode: 'ba', year: 1941, imagePath: 'flag_history_ba_1941', description: '波斯尼亚和黑塞哥维那 1941年国旗' },
      { countryCode: 'ba', year: 1945, imagePath: 'flag_history_ba_1945', description: '波斯尼亚和黑塞哥维那 1945年国旗' },
      { countryCode: 'ba', year: 1992, imagePath: 'flag_history_ba_1992', description: '波斯尼亚和黑塞哥维那 1992年国旗' },
      { countryCode: 'ba', year: 1998, imagePath: 'flag_history_ba_1998', description: '波斯尼亚和黑塞哥维那 1998年国旗' }
    ]
  },
  {
    countryCode: 'bb',
    history: [
      { countryCode: 'bb', year: 1500, imagePath: 'flag_history_bb_1500', description: '巴巴多斯 1500年国旗' },
      { countryCode: 'bb', year: 1632, imagePath: 'flag_history_bb_1632', description: '巴巴多斯 1632年国旗' },
      { countryCode: 'bb', year: 1801, imagePath: 'flag_history_bb_1801', description: '巴巴多斯 1801年国旗' },
      { countryCode: 'bb', year: 1885, imagePath: 'flag_history_bb_1885', description: '巴巴多斯 1885年国旗' },
      { countryCode: 'bb', year: 1958, imagePath: 'flag_history_bb_1958', description: '巴巴多斯 1958年国旗' },
      { countryCode: 'bb', year: 1966, imagePath: 'flag_history_bb_1966', description: '巴巴多斯 1966年国旗' }
    ]
  },
  {
    countryCode: 'bd',
    history: [
      { countryCode: 'bd', year: 1757, imagePath: 'flag_history_bd_1757', description: '孟加拉国 1757年国旗' },
      { countryCode: 'bd', year: 1801, imagePath: 'flag_history_bd_1801', description: '孟加拉国 1801年国旗' },
      { countryCode: 'bd', year: 1858, imagePath: 'flag_history_bd_1858', description: '孟加拉国 1858年国旗' },
      { countryCode: 'bd', year: 1947, imagePath: 'flag_history_bd_1947', description: '孟加拉国 1947年国旗' },
      { countryCode: 'bd', year: 1971, imagePath: 'flag_history_bd_1971', description: '孟加拉国 1971年国旗' },
      { countryCode: 'bd', year: 1972, imagePath: 'flag_history_bd_1972', description: '孟加拉国 1972年国旗' }
    ]
  },
  {
    countryCode: 'be',
    history: [
      { countryCode: 'be', year: 1482, imagePath: 'flag_history_be_1482', description: '比利时 1482年国旗' },
      { countryCode: 'be', year: 1790, imagePath: 'flag_history_be_1790', description: '比利时 1790年国旗' },
      { countryCode: 'be', year: 1795, imagePath: 'flag_history_be_1795', description: '比利时 1795年国旗' },
      { countryCode: 'be', year: 1815, imagePath: 'flag_history_be_1815', description: '比利时 1815年国旗' },
      { countryCode: 'be', year: 1830, imagePath: 'flag_history_be_1830', description: '比利时 1830年国旗' },
      { countryCode: 'be', year: 1831, imagePath: 'flag_history_be_1831', description: '比利时 1831年国旗' },
      { countryCode: 'be', year: 1940, imagePath: 'flag_history_be_1940', description: '比利时 1940年国旗' },
      { countryCode: 'be', year: 1944, imagePath: 'flag_history_be_1944', description: '比利时 1944年国旗' }
    ]
  },
  {
    countryCode: 'bf',
    history: [
      { countryCode: 'bf', year: 1896, imagePath: 'flag_history_bf_1896', description: '布基纳法索 1896年国旗' },
      { countryCode: 'bf', year: 1959, imagePath: 'flag_history_bf_1959', description: '布基纳法索 1959年国旗' },
      { countryCode: 'bf', year: 1984, imagePath: 'flag_history_bf_1984', description: '布基纳法索 1984年国旗' }
    ]
  },
  {
    countryCode: 'bg',
    history: [
      { countryCode: 'bg', year: 1000, imagePath: 'flag_history_bg_1000', description: '保加利亚 1000年国旗' },
      { countryCode: 'bg', year: 1453, imagePath: 'flag_history_bg_1453', description: '保加利亚 1453年国旗' },
      { countryCode: 'bg', year: 1844, imagePath: 'flag_history_bg_1844', description: '保加利亚 1844年国旗' },
      { countryCode: 'bg', year: 1878, imagePath: 'flag_history_bg_1878', description: '保加利亚 1878年国旗' },
      { countryCode: 'bg', year: 1948, imagePath: 'flag_history_bg_1948', description: '保加利亚 1948年国旗' },
      { countryCode: 'bg', year: 1967, imagePath: 'flag_history_bg_1967', description: '保加利亚 1967年国旗' },
      { countryCode: 'bg', year: 1971, imagePath: 'flag_history_bg_1971', description: '保加利亚 1971年国旗' },
      { countryCode: 'bg', year: 1991, imagePath: 'flag_history_bg_1991', description: '保加利亚 1991年国旗' }
    ]
  },
  {
    countryCode: 'bh',
    history: [
      { countryCode: 'bh', year: 1000, imagePath: 'flag_history_bh_1000', description: '巴林 1000年国旗' },
      { countryCode: 'bh', year: 1820, imagePath: 'flag_history_bh_1820', description: '巴林 1820年国旗' },
      { countryCode: 'bh', year: 1932, imagePath: 'flag_history_bh_1932', description: '巴林 1932年国旗' },
      { countryCode: 'bh', year: 1972, imagePath: 'flag_history_bh_1972', description: '巴林 1972年国旗' },
      { countryCode: 'bh', year: 2002, imagePath: 'flag_history_bh_2002', description: '巴林 2002年国旗' }
    ]
  },
  {
    countryCode: 'bi',
    history: [
      { countryCode: 'bi', year: 1000, imagePath: 'flag_history_bi_1000', description: '布隆迪 1000年国旗' },
      { countryCode: 'bi', year: 1885, imagePath: 'flag_history_bi_1885', description: '布隆迪 1885年国旗' },
      { countryCode: 'bi', year: 1919, imagePath: 'flag_history_bi_1919', description: '布隆迪 1919年国旗' },
      { countryCode: 'bi', year: 1961, imagePath: 'flag_history_bi_1961', description: '布隆迪 1961年国旗' },
      { countryCode: 'bi', year: 1962, imagePath: 'flag_history_bi_1962', description: '布隆迪 1962年国旗' },
      { countryCode: 'bi', year: 1966, imagePath: 'flag_history_bi_1966', description: '布隆迪 1966年国旗' },
      { countryCode: 'bi', year: 1967, imagePath: 'flag_history_bi_1967', description: '布隆迪 1967年国旗' },
      { countryCode: 'bi', year: 1982, imagePath: 'flag_history_bi_1982', description: '布隆迪 1982年国旗' }
    ]
  },
  {
    countryCode: 'bj',
    history: [
      { countryCode: 'bj', year: 1900, imagePath: 'flag_history_bj_1900', description: '贝宁 1900年国旗' },
      { countryCode: 'bj', year: 1958, imagePath: 'flag_history_bj_1958', description: '贝宁 1958年国旗' },
      { countryCode: 'bj', year: 1975, imagePath: 'flag_history_bj_1975', description: '贝宁 1975年国旗' },
      { countryCode: 'bj', year: 1990, imagePath: 'flag_history_bj_1990', description: '贝宁 1990年国旗' }
    ]
  },
  {
    countryCode: 'bn',
    history: [
      { countryCode: 'bn', year: 1440, imagePath: 'flag_history_bn_1440', description: '文莱 1440年国旗' },
      { countryCode: 'bn', year: 1906, imagePath: 'flag_history_bn_1906', description: '文莱 1906年国旗' },
      { countryCode: 'bn', year: 1941, imagePath: 'flag_history_bn_1941', description: '文莱 1941年国旗' },
      { countryCode: 'bn', year: 1945, imagePath: 'flag_history_bn_1945', description: '文莱 1945年国旗' },
      { countryCode: 'bn', year: 1959, imagePath: 'flag_history_bn_1959', description: '文莱 1959年国旗' }
    ]
  },
  {
    countryCode: 'bo',
    history: [
      { countryCode: 'bo', year: 1100, imagePath: 'flag_history_bo_1100', description: '玻利维亚 1100年国旗' },
      { countryCode: 'bo', year: 1534, imagePath: 'flag_history_bo_1534', description: '玻利维亚 1534年国旗' },
      { countryCode: 'bo', year: 1717, imagePath: 'flag_history_bo_1717', description: '玻利维亚 1717年国旗' },
      { countryCode: 'bo', year: 1785, imagePath: 'flag_history_bo_1785', description: '玻利维亚 1785年国旗' },
      { countryCode: 'bo', year: 1825, imagePath: 'flag_history_bo_1825', description: '玻利维亚 1825年国旗' },
      { countryCode: 'bo', year: 1826, imagePath: 'flag_history_bo_1826', description: '玻利维亚 1826年国旗' },
      { countryCode: 'bo', year: 1851, imagePath: 'flag_history_bo_1851', description: '玻利维亚 1851年国旗' }
    ]
  },
  {
    countryCode: 'br',
    history: [
      { countryCode: 'br', year: 1000, imagePath: 'flag_history_br_1000', description: '巴西 1000年国旗' },
      { countryCode: 'br', year: 1697, imagePath: 'flag_history_br_1697', description: '巴西 1697年国旗' },
      { countryCode: 'br', year: 1816, imagePath: 'flag_history_br_1816', description: '巴西 1816年国旗' },
      { countryCode: 'br', year: 1822, imagePath: 'flag_history_br_1822', description: '巴西 1822年国旗' },
      { countryCode: 'br', year: 1870, imagePath: 'flag_history_br_1870', description: '巴西 1870年国旗' },
      { countryCode: 'br', year: 1889, imagePath: 'flag_history_br_1889', description: '巴西 1889年国旗' },
      { countryCode: 'br', year: 1960, imagePath: 'flag_history_br_1960', description: '巴西 1960年国旗' },
      { countryCode: 'br', year: 1968, imagePath: 'flag_history_br_1968', description: '巴西 1968年国旗' },
      { countryCode: 'br', year: 1992, imagePath: 'flag_history_br_1992', description: '巴西 1992年国旗' }
    ]
  },
  {
    countryCode: 'bs',
    history: [
      { countryCode: 'bs', year: 1200, imagePath: 'flag_history_bs_1200', description: '巴哈马 1200年国旗' },
      { countryCode: 'bs', year: 1648, imagePath: 'flag_history_bs_1648', description: '巴哈马 1648年国旗' },
      { countryCode: 'bs', year: 1801, imagePath: 'flag_history_bs_1801', description: '巴哈马 1801年国旗' },
      { countryCode: 'bs', year: 1869, imagePath: 'flag_history_bs_1869', description: '巴哈马 1869年国旗' },
      { countryCode: 'bs', year: 1904, imagePath: 'flag_history_bs_1904', description: '巴哈马 1904年国旗' },
      { countryCode: 'bs', year: 1923, imagePath: 'flag_history_bs_1923', description: '巴哈马 1923年国旗' },
      { countryCode: 'bs', year: 1953, imagePath: 'flag_history_bs_1953', description: '巴哈马 1953年国旗' },
      { countryCode: 'bs', year: 1964, imagePath: 'flag_history_bs_1964', description: '巴哈马 1964年国旗' },
      { countryCode: 'bs', year: 1973, imagePath: 'flag_history_bs_1973', description: '巴哈马 1973年国旗' }
    ]
  },
  {
    countryCode: 'bt',
    history: [
      { countryCode: 'bt', year: 1949, imagePath: 'flag_history_bt_1949', description: '不丹 1949年国旗' },
      { countryCode: 'bt', year: 1956, imagePath: 'flag_history_bt_1956', description: '不丹 1956年国旗' },
      { countryCode: 'bt', year: 1969, imagePath: 'flag_history_bt_1969', description: '不丹 1969年国旗' }
    ]
  },
  {
    countryCode: 'bw',
    history: [
      { countryCode: 'bw', year: 1200, imagePath: 'flag_history_bw_1200', description: '博茨瓦纳 1200年国旗' },
      { countryCode: 'bw', year: 1885, imagePath: 'flag_history_bw_1885', description: '博茨瓦纳 1885年国旗' },
      { countryCode: 'bw', year: 1966, imagePath: 'flag_history_bw_1966', description: '博茨瓦纳 1966年国旗' }
    ]
  },
  {
    countryCode: 'by',
    history: [
      { countryCode: 'by', year: 1200, imagePath: 'flag_history_by_1200', description: '白俄罗斯 1200年国旗' },
      { countryCode: 'by', year: 1793, imagePath: 'flag_history_by_1793', description: '白俄罗斯 1793年国旗' },
      { countryCode: 'by', year: 1858, imagePath: 'flag_history_by_1858', description: '白俄罗斯 1858年国旗' },
      { countryCode: 'by', year: 1883, imagePath: 'flag_history_by_1883', description: '白俄罗斯 1883年国旗' },
      { countryCode: 'by', year: 1918, imagePath: 'flag_history_by_1918', description: '白俄罗斯 1918年国旗' },
      { countryCode: 'by', year: 1919, imagePath: 'flag_history_by_1919', description: '白俄罗斯 1919年国旗' },
      { countryCode: 'by', year: 1937, imagePath: 'flag_history_by_1937', description: '白俄罗斯 1937年国旗' },
      { countryCode: 'by', year: 1941, imagePath: 'flag_history_by_1941', description: '白俄罗斯 1941年国旗' },
      { countryCode: 'by', year: 1944, imagePath: 'flag_history_by_1944', description: '白俄罗斯 1944年国旗' },
      { countryCode: 'by', year: 1951, imagePath: 'flag_history_by_1951', description: '白俄罗斯 1951年国旗' },
      { countryCode: 'by', year: 1991, imagePath: 'flag_history_by_1991', description: '白俄罗斯 1991年国旗' },
      { countryCode: 'by', year: 1995, imagePath: 'flag_history_by_1995', description: '白俄罗斯 1995年国旗' },
      { countryCode: 'by', year: 2012, imagePath: 'flag_history_by_2012', description: '白俄罗斯 2012年国旗' }
    ]
  },
  {
    countryCode: 'bz',
    history: [
      { countryCode: 'bz', year: 1000, imagePath: 'flag_history_bz_1000', description: '伯利兹 1000年国旗' },
      { countryCode: 'bz', year: 1519, imagePath: 'flag_history_bz_1519', description: '伯利兹 1519年国旗' },
      { countryCode: 'bz', year: 1821, imagePath: 'flag_history_bz_1821', description: '伯利兹 1821年国旗' },
      { countryCode: 'bz', year: 1823, imagePath: 'flag_history_bz_1823', description: '伯利兹 1823年国旗' },
      { countryCode: 'bz', year: 1825, imagePath: 'flag_history_bz_1825', description: '伯利兹 1825年国旗' },
      { countryCode: 'bz', year: 1838, imagePath: 'flag_history_bz_1838', description: '伯利兹 1838年国旗' },
      { countryCode: 'bz', year: 1875, imagePath: 'flag_history_bz_1875', description: '伯利兹 1875年国旗' },
      { countryCode: 'bz', year: 1884, imagePath: 'flag_history_bz_1884', description: '伯利兹 1884年国旗' },
      { countryCode: 'bz', year: 1919, imagePath: 'flag_history_bz_1919', description: '伯利兹 1919年国旗' },
      { countryCode: 'bz', year: 1981, imagePath: 'flag_history_bz_1981', description: '伯利兹 1981年国旗' }
    ]
  },
  {
    countryCode: 'ca',
    history: [
      { countryCode: 'ca', year: 1200, imagePath: 'flag_history_ca_1200', description: '加拿大 1200年国旗' },
      { countryCode: 'ca', year: 1606, imagePath: 'flag_history_ca_1606', description: '加拿大 1606年国旗' },
      { countryCode: 'ca', year: 1707, imagePath: 'flag_history_ca_1707', description: '加拿大 1707年国旗' },
      { countryCode: 'ca', year: 1801, imagePath: 'flag_history_ca_1801', description: '加拿大 1801年国旗' },
      { countryCode: 'ca', year: 1868, imagePath: 'flag_history_ca_1868', description: '加拿大 1868年国旗' },
      { countryCode: 'ca', year: 1921, imagePath: 'flag_history_ca_1921', description: '加拿大 1921年国旗' },
      { countryCode: 'ca', year: 1957, imagePath: 'flag_history_ca_1957', description: '加拿大 1957年国旗' },
      { countryCode: 'ca', year: 1965, imagePath: 'flag_history_ca_1965', description: '加拿大 1965年国旗' }
    ]
  },
  {
    countryCode: 'cd',
    history: [
      { countryCode: 'cd', year: 1877, imagePath: 'flag_history_cd_1877', description: '刚果（金） 1877年国旗' },
      { countryCode: 'cd', year: 1960, imagePath: 'flag_history_cd_1960', description: '刚果（金） 1960年国旗' },
      { countryCode: 'cd', year: 1963, imagePath: 'flag_history_cd_1963', description: '刚果（金） 1963年国旗' },
      { countryCode: 'cd', year: 1966, imagePath: 'flag_history_cd_1966', description: '刚果（金） 1966年国旗' },
      { countryCode: 'cd', year: 1971, imagePath: 'flag_history_cd_1971', description: '刚果（金） 1971年国旗' },
      { countryCode: 'cd', year: 1997, imagePath: 'flag_history_cd_1997', description: '刚果（金） 1997年国旗' },
      { countryCode: 'cd', year: 2003, imagePath: 'flag_history_cd_2003', description: '刚果（金） 2003年国旗' },
      { countryCode: 'cd', year: 2006, imagePath: 'flag_history_cd_2006', description: '刚果（金） 2006年国旗' }
    ]
  },
  {
    countryCode: 'cf',
    history: [
      { countryCode: 'cf', year: 1903, imagePath: 'flag_history_cf_1903', description: '中非 1903年国旗' },
      { countryCode: 'cf', year: 1958, imagePath: 'flag_history_cf_1958', description: '中非 1958年国旗' }
    ]
  },
  {
    countryCode: 'cg',
    history: [
      { countryCode: 'cg', year: 1891, imagePath: 'flag_history_cg_1891', description: '刚果（布） 1891年国旗' },
      { countryCode: 'cg', year: 1958, imagePath: 'flag_history_cg_1958', description: '刚果（布） 1958年国旗' },
      { countryCode: 'cg', year: 1970, imagePath: 'flag_history_cg_1970', description: '刚果（布） 1970年国旗' },
      { countryCode: 'cg', year: 1991, imagePath: 'flag_history_cg_1991', description: '刚果（布） 1991年国旗' }
    ]
  },
  {
    countryCode: 'ch',
    history: [
      { countryCode: 'ch', year: 1798, imagePath: 'flag_history_ch_1798', description: '瑞士 1798年国旗' },
      { countryCode: 'ch', year: 1889, imagePath: 'flag_history_ch_1889', description: '瑞士 1889年国旗' }
    ]
  },
  {
    countryCode: 'cl',
    history: [
      { countryCode: 'cl', year: 1541, imagePath: 'flag_history_cl_1541', description: '智利 1541年国旗' },
      { countryCode: 'cl', year: 1717, imagePath: 'flag_history_cl_1717', description: '智利 1717年国旗' },
      { countryCode: 'cl', year: 1785, imagePath: 'flag_history_cl_1785', description: '智利 1785年国旗' },
      { countryCode: 'cl', year: 1812, imagePath: 'flag_history_cl_1812', description: '智利 1812年国旗' },
      { countryCode: 'cl', year: 1817, imagePath: 'flag_history_cl_1817', description: '智利 1817年国旗' }
    ]
  },
  {
    countryCode: 'cm',
    history: [
      { countryCode: 'cm', year: 1884, imagePath: 'flag_history_cm_1884', description: '喀麦隆 1884年国旗' },
      { countryCode: 'cm', year: 1916, imagePath: 'flag_history_cm_1916', description: '喀麦隆 1916年国旗' },
      { countryCode: 'cm', year: 1957, imagePath: 'flag_history_cm_1957', description: '喀麦隆 1957年国旗' },
      { countryCode: 'cm', year: 1961, imagePath: 'flag_history_cm_1961', description: '喀麦隆 1961年国旗' },
      { countryCode: 'cm', year: 1975, imagePath: 'flag_history_cm_1975', description: '喀麦隆 1975年国旗' }
    ]
  },
  {
    countryCode: 'cn',
    history: [
      { countryCode: 'cn', year: 1862, imagePath: 'flag_history_cn_1862', description: '中国大陆 1862年国旗' },
      { countryCode: 'cn', year: 1889, imagePath: 'flag_history_cn_1889', description: '中国大陆 1889年国旗' },
      { countryCode: 'cn', year: 1912, imagePath: 'flag_history_cn_1912', description: '中国大陆 1912年国旗' },
      { countryCode: 'cn', year: 1928, imagePath: 'flag_history_cn_1928', description: '中国大陆 1928年国旗' },
      { countryCode: 'cn', year: 1949, imagePath: 'flag_history_cn_1949', description: '中国大陆 1949年国旗' }
    ]
  },
  {
    countryCode: 'co',
    history: [
      { countryCode: 'co', year: 1525, imagePath: 'flag_history_co_1525', description: '哥伦比亚 1525年国旗' },
      { countryCode: 'co', year: 1717, imagePath: 'flag_history_co_1717', description: '哥伦比亚 1717年国旗' },
      { countryCode: 'co', year: 1785, imagePath: 'flag_history_co_1785', description: '哥伦比亚 1785年国旗' },
      { countryCode: 'co', year: 1811, imagePath: 'flag_history_co_1811', description: '哥伦比亚 1811年国旗' },
      { countryCode: 'co', year: 1816, imagePath: 'flag_history_co_1816', description: '哥伦比亚 1816年国旗' },
      { countryCode: 'co', year: 1819, imagePath: 'flag_history_co_1819', description: '哥伦比亚 1819年国旗' },
      { countryCode: 'co', year: 1820, imagePath: 'flag_history_co_1820', description: '哥伦比亚 1820年国旗' },
      { countryCode: 'co', year: 1821, imagePath: 'flag_history_co_1821', description: '哥伦比亚 1821年国旗' },
      { countryCode: 'co', year: 1834, imagePath: 'flag_history_co_1834', description: '哥伦比亚 1834年国旗' },
      { countryCode: 'co', year: 1861, imagePath: 'flag_history_co_1861', description: '哥伦比亚 1861年国旗' }
    ]
  },
  {
    countryCode: 'cr',
    history: [
      { countryCode: 'cr', year: 1000, imagePath: 'flag_history_cr_1000', description: '哥斯达黎加 1000年国旗' },
      { countryCode: 'cr', year: 1506, imagePath: 'flag_history_cr_1506', description: '哥斯达黎加 1506年国旗' },
      { countryCode: 'cr', year: 1821, imagePath: 'flag_history_cr_1821', description: '哥斯达黎加 1821年国旗' },
      { countryCode: 'cr', year: 1823, imagePath: 'flag_history_cr_1823', description: '哥斯达黎加 1823年国旗' },
      { countryCode: 'cr', year: 1824, imagePath: 'flag_history_cr_1824', description: '哥斯达黎加 1824年国旗' },
      { countryCode: 'cr', year: 1842, imagePath: 'flag_history_cr_1842', description: '哥斯达黎加 1842年国旗' },
      { countryCode: 'cr', year: 1848, imagePath: 'flag_history_cr_1848', description: '哥斯达黎加 1848年国旗' },
      { countryCode: 'cr', year: 1906, imagePath: 'flag_history_cr_1906', description: '哥斯达黎加 1906年国旗' }
    ]
  },
  {
    countryCode: 'cu',
    history: [
      { countryCode: 'cu', year: 1200, imagePath: 'flag_history_cu_1200', description: '古巴 1200年国旗' },
      { countryCode: 'cu', year: 1506, imagePath: 'flag_history_cu_1506', description: '古巴 1506年国旗' },
      { countryCode: 'cu', year: 1898, imagePath: 'flag_history_cu_1898', description: '古巴 1898年国旗' },
      { countryCode: 'cu', year: 1902, imagePath: 'flag_history_cu_1902', description: '古巴 1902年国旗' }
    ]
  },
  {
    countryCode: 'cv',
    history: [
      { countryCode: 'cv', year: 1020, imagePath: 'flag_history_cv_1020', description: '佛得角 1020年国旗' },
      { countryCode: 'cv', year: 1667, imagePath: 'flag_history_cv_1667', description: '佛得角 1667年国旗' },
      { countryCode: 'cv', year: 1707, imagePath: 'flag_history_cv_1707', description: '佛得角 1707年国旗' },
      { countryCode: 'cv', year: 1750, imagePath: 'flag_history_cv_1750', description: '佛得角 1750年国旗' },
      { countryCode: 'cv', year: 1816, imagePath: 'flag_history_cv_1816', description: '佛得角 1816年国旗' },
      { countryCode: 'cv', year: 1826, imagePath: 'flag_history_cv_1826', description: '佛得角 1826年国旗' },
      { countryCode: 'cv', year: 1830, imagePath: 'flag_history_cv_1830', description: '佛得角 1830年国旗' },
      { countryCode: 'cv', year: 1911, imagePath: 'flag_history_cv_1911', description: '佛得角 1911年国旗' },
      { countryCode: 'cv', year: 1975, imagePath: 'flag_history_cv_1975', description: '佛得角 1975年国旗' },
      { countryCode: 'cv', year: 1992, imagePath: 'flag_history_cv_1992', description: '佛得角 1992年国旗' }
    ]
  },
  {
    countryCode: 'cy',
    history: [
      { countryCode: 'cy', year: 1200, imagePath: 'flag_history_cy_1200', description: '塞浦路斯 1200年国旗' },
      { countryCode: 'cy', year: 1453, imagePath: 'flag_history_cy_1453', description: '塞浦路斯 1453年国旗' },
      { countryCode: 'cy', year: 1844, imagePath: 'flag_history_cy_1844', description: '塞浦路斯 1844年国旗' },
      { countryCode: 'cy', year: 1878, imagePath: 'flag_history_cy_1878', description: '塞浦路斯 1878年国旗' },
      { countryCode: 'cy', year: 1922, imagePath: 'flag_history_cy_1922', description: '塞浦路斯 1922年国旗' },
      { countryCode: 'cy', year: 1960, imagePath: 'flag_history_cy_1960', description: '塞浦路斯 1960年国旗' }
    ]
  },
  {
    countryCode: 'cz',
    history: [
      { countryCode: 'cz', year: 1400, imagePath: 'flag_history_cz_1400', description: '捷克 1400年国旗' },
      { countryCode: 'cz', year: 1804, imagePath: 'flag_history_cz_1804', description: '捷克 1804年国旗' },
      { countryCode: 'cz', year: 1869, imagePath: 'flag_history_cz_1869', description: '捷克 1869年国旗' },
      { countryCode: 'cz', year: 1918, imagePath: 'flag_history_cz_1918', description: '捷克 1918年国旗' },
      { countryCode: 'cz', year: 1920, imagePath: 'flag_history_cz_1920', description: '捷克 1920年国旗' },
      { countryCode: 'cz', year: 1939, imagePath: 'flag_history_cz_1939', description: '捷克 1939年国旗' },
      { countryCode: 'cz', year: 1945, imagePath: 'flag_history_cz_1945', description: '捷克 1945年国旗' },
      { countryCode: 'cz', year: 1990, imagePath: 'flag_history_cz_1990', description: '捷克 1990年国旗' },
      { countryCode: 'cz', year: 1993, imagePath: 'flag_history_cz_1993', description: '捷克 1993年国旗' }
    ]
  },
  {
    countryCode: 'de',
    history: [
      { countryCode: 'de', year: 1000, imagePath: 'flag_history_de_1000', description: '德国 1000年国旗' },
      { countryCode: 'de', year: 1402, imagePath: 'flag_history_de_1402', description: '德国 1402年国旗' },
      { countryCode: 'de', year: 1815, imagePath: 'flag_history_de_1815', description: '德国 1815年国旗' },
      { countryCode: 'de', year: 1871, imagePath: 'flag_history_de_1871', description: '德国 1871年国旗' },
      { countryCode: 'de', year: 1919, imagePath: 'flag_history_de_1919', description: '德国 1919年国旗' },
      { countryCode: 'de', year: 1933, imagePath: 'flag_history_de_1933', description: '德国 1933年国旗' },
      { countryCode: 'de', year: 1935, imagePath: 'flag_history_de_1935', description: '德国 1935年国旗' },
      { countryCode: 'de', year: 1945, imagePath: 'flag_history_de_1945', description: '德国 1945年国旗' },
      { countryCode: 'de', year: 1949, imagePath: 'flag_history_de_1949', description: '德国 1949年国旗' }
    ]
  },
  {
    countryCode: 'dj',
    history: [
      { countryCode: 'dj', year: 1453, imagePath: 'flag_history_dj_1453', description: '吉布提 1453年国旗' },
      { countryCode: 'dj', year: 1844, imagePath: 'flag_history_dj_1844', description: '吉布提 1844年国旗' },
      { countryCode: 'dj', year: 1896, imagePath: 'flag_history_dj_1896', description: '吉布提 1896年国旗' },
      { countryCode: 'dj', year: 1977, imagePath: 'flag_history_dj_1977', description: '吉布提 1977年国旗' }
    ]
  },
  {
    countryCode: 'dk',
    history: [
      { countryCode: 'dk', year: 1219, imagePath: 'flag_history_dk_1219', description: '丹麦 1219年国旗' },
      { countryCode: 'dk', year: 1940, imagePath: 'flag_history_dk_1940', description: '丹麦 1940年国旗' },
      { countryCode: 'dk', year: 1945, imagePath: 'flag_history_dk_1945', description: '丹麦 1945年国旗' }
    ]
  },
  {
    countryCode: 'dm',
    history: [
      { countryCode: 'dm', year: 1200, imagePath: 'flag_history_dm_1200', description: '多米尼克 1200年国旗' },
      { countryCode: 'dm', year: 1663, imagePath: 'flag_history_dm_1663', description: '多米尼克 1663年国旗' },
      { countryCode: 'dm', year: 1715, imagePath: 'flag_history_dm_1715', description: '多米尼克 1715年国旗' },
      { countryCode: 'dm', year: 1763, imagePath: 'flag_history_dm_1763', description: '多米尼克 1763年国旗' },
      { countryCode: 'dm', year: 1801, imagePath: 'flag_history_dm_1801', description: '多米尼克 1801年国旗' },
      { countryCode: 'dm', year: 1940, imagePath: 'flag_history_dm_1940', description: '多米尼克 1940年国旗' },
      { countryCode: 'dm', year: 1958, imagePath: 'flag_history_dm_1958', description: '多米尼克 1958年国旗' },
      { countryCode: 'dm', year: 1962, imagePath: 'flag_history_dm_1962', description: '多米尼克 1962年国旗' },
      { countryCode: 'dm', year: 1978, imagePath: 'flag_history_dm_1978', description: '多米尼克 1978年国旗' },
      { countryCode: 'dm', year: 1981, imagePath: 'flag_history_dm_1981', description: '多米尼克 1981年国旗' },
      { countryCode: 'dm', year: 1988, imagePath: 'flag_history_dm_1988', description: '多米尼克 1988年国旗' },
      { countryCode: 'dm', year: 1990, imagePath: 'flag_history_dm_1990', description: '多米尼克 1990年国旗' }
    ]
  },
  {
    countryCode: 'do',
    history: [
      { countryCode: 'do', year: 1506, imagePath: 'flag_history_do_1506', description: '多米尼加 1506年国旗' },
      { countryCode: 'do', year: 1795, imagePath: 'flag_history_do_1795', description: '多米尼加 1795年国旗' },
      { countryCode: 'do', year: 1808, imagePath: 'flag_history_do_1808', description: '多米尼加 1808年国旗' },
      { countryCode: 'do', year: 1821, imagePath: 'flag_history_do_1821', description: '多米尼加 1821年国旗' },
      { countryCode: 'do', year: 1844, imagePath: 'flag_history_do_1844', description: '多米尼加 1844年国旗' },
      { countryCode: 'do', year: 1849, imagePath: 'flag_history_do_1849', description: '多米尼加 1849年国旗' },
      { countryCode: 'do', year: 1861, imagePath: 'flag_history_do_1861', description: '多米尼加 1861年国旗' },
      { countryCode: 'do', year: 1865, imagePath: 'flag_history_do_1865', description: '多米尼加 1865年国旗' }
    ]
  },
  {
    countryCode: 'dz',
    history: [
      { countryCode: 'dz', year: 1516, imagePath: 'flag_history_dz_1516', description: '阿尔及利亚 1516年国旗' },
      { countryCode: 'dz', year: 1830, imagePath: 'flag_history_dz_1830', description: '阿尔及利亚 1830年国旗' },
      { countryCode: 'dz', year: 1962, imagePath: 'flag_history_dz_1962', description: '阿尔及利亚 1962年国旗' }
    ]
  },
  {
    countryCode: 'ec',
    history: [
      { countryCode: 'ec', year: 1440, imagePath: 'flag_history_ec_1440', description: '厄瓜多尔 1440年国旗' },
      { countryCode: 'ec', year: 1534, imagePath: 'flag_history_ec_1534', description: '厄瓜多尔 1534年国旗' },
      { countryCode: 'ec', year: 1717, imagePath: 'flag_history_ec_1717', description: '厄瓜多尔 1717年国旗' },
      { countryCode: 'ec', year: 1785, imagePath: 'flag_history_ec_1785', description: '厄瓜多尔 1785年国旗' },
      { countryCode: 'ec', year: 1809, imagePath: 'flag_history_ec_1809', description: '厄瓜多尔 1809年国旗' },
      { countryCode: 'ec', year: 1812, imagePath: 'flag_history_ec_1812', description: '厄瓜多尔 1812年国旗' },
      { countryCode: 'ec', year: 1820, imagePath: 'flag_history_ec_1820', description: '厄瓜多尔 1820年国旗' },
      { countryCode: 'ec', year: 1822, imagePath: 'flag_history_ec_1822', description: '厄瓜多尔 1822年国旗' },
      { countryCode: 'ec', year: 1845, imagePath: 'flag_history_ec_1845', description: '厄瓜多尔 1845年国旗' },
      { countryCode: 'ec', year: 1860, imagePath: 'flag_history_ec_1860', description: '厄瓜多尔 1860年国旗' },
      { countryCode: 'ec', year: 1900, imagePath: 'flag_history_ec_1900', description: '厄瓜多尔 1900年国旗' },
      { countryCode: 'ec', year: 2009, imagePath: 'flag_history_ec_2009', description: '厄瓜多尔 2009年国旗' }
    ]
  },
  {
    countryCode: 'ee',
    history: [
      { countryCode: 'ee', year: 1562, imagePath: 'flag_history_ee_1562', description: '爱沙尼亚 1562年国旗' },
      { countryCode: 'ee', year: 1721, imagePath: 'flag_history_ee_1721', description: '爱沙尼亚 1721年国旗' },
      { countryCode: 'ee', year: 1918, imagePath: 'flag_history_ee_1918', description: '爱沙尼亚 1918年国旗' },
      { countryCode: 'ee', year: 1940, imagePath: 'flag_history_ee_1940', description: '爱沙尼亚 1940年国旗' },
      { countryCode: 'ee', year: 1941, imagePath: 'flag_history_ee_1941', description: '爱沙尼亚 1941年国旗' },
      { countryCode: 'ee', year: 1944, imagePath: 'flag_history_ee_1944', description: '爱沙尼亚 1944年国旗' },
      { countryCode: 'ee', year: 1953, imagePath: 'flag_history_ee_1953', description: '爱沙尼亚 1953年国旗' },
      { countryCode: 'ee', year: 1990, imagePath: 'flag_history_ee_1990', description: '爱沙尼亚 1990年国旗' }
    ]
  },
  {
    countryCode: 'eg',
    history: [
      { countryCode: 'eg', year: 1517, imagePath: 'flag_history_eg_1517', description: '埃及 1517年国旗' },
      { countryCode: 'eg', year: 1844, imagePath: 'flag_history_eg_1844', description: '埃及 1844年国旗' },
      { countryCode: 'eg', year: 1882, imagePath: 'flag_history_eg_1882', description: '埃及 1882年国旗' },
      { countryCode: 'eg', year: 1922, imagePath: 'flag_history_eg_1922', description: '埃及 1922年国旗' },
      { countryCode: 'eg', year: 1952, imagePath: 'flag_history_eg_1952', description: '埃及 1952年国旗' },
      { countryCode: 'eg', year: 1958, imagePath: 'flag_history_eg_1958', description: '埃及 1958年国旗' },
      { countryCode: 'eg', year: 1972, imagePath: 'flag_history_eg_1972', description: '埃及 1972年国旗' },
      { countryCode: 'eg', year: 1984, imagePath: 'flag_history_eg_1984', description: '埃及 1984年国旗' }
    ]
  },
  {
    countryCode: 'eh',
    history: [
      { countryCode: 'eh', year: 1976, imagePath: 'flag_history_eh_1976', description: '西撒哈拉 1976年国旗' }
    ]
  },
  {
    countryCode: 'er',
    history: [
      { countryCode: 'er', year: 1200, imagePath: 'flag_history_er_1200', description: '厄立特里亚 1200年国旗' },
      { countryCode: 'er', year: 1890, imagePath: 'flag_history_er_1890', description: '厄立特里亚 1890年国旗' },
      { countryCode: 'er', year: 1941, imagePath: 'flag_history_er_1941', description: '厄立特里亚 1941年国旗' },
      { countryCode: 'er', year: 1952, imagePath: 'flag_history_er_1952', description: '厄立特里亚 1952年国旗' },
      { countryCode: 'er', year: 1974, imagePath: 'flag_history_er_1974', description: '厄立特里亚 1974年国旗' },
      { countryCode: 'er', year: 1987, imagePath: 'flag_history_er_1987', description: '厄立特里亚 1987年国旗' },
      { countryCode: 'er', year: 1991, imagePath: 'flag_history_er_1991', description: '厄立特里亚 1991年国旗' },
      { countryCode: 'er', year: 1993, imagePath: 'flag_history_er_1993', description: '厄立特里亚 1993年国旗' },
      { countryCode: 'er', year: 1995, imagePath: 'flag_history_er_1995', description: '厄立特里亚 1995年国旗' }
    ]
  },
  {
    countryCode: 'es',
    history: [
      { countryCode: 'es', year: 1506, imagePath: 'flag_history_es_1506', description: '西班牙 1506年国旗' },
      { countryCode: 'es', year: 1701, imagePath: 'flag_history_es_1701', description: '西班牙 1701年国旗' },
      { countryCode: 'es', year: 1748, imagePath: 'flag_history_es_1748', description: '西班牙 1748年国旗' },
      { countryCode: 'es', year: 1785, imagePath: 'flag_history_es_1785', description: '西班牙 1785年国旗' },
      { countryCode: 'es', year: 1873, imagePath: 'flag_history_es_1873', description: '西班牙 1873年国旗' },
      { countryCode: 'es', year: 1875, imagePath: 'flag_history_es_1875', description: '西班牙 1875年国旗' },
      { countryCode: 'es', year: 1931, imagePath: 'flag_history_es_1931', description: '西班牙 1931年国旗' },
      { countryCode: 'es', year: 1936, imagePath: 'flag_history_es_1936', description: '西班牙 1936年国旗' },
      { countryCode: 'es', year: 1938, imagePath: 'flag_history_es_1938', description: '西班牙 1938年国旗' },
      { countryCode: 'es', year: 1945, imagePath: 'flag_history_es_1945', description: '西班牙 1945年国旗' },
      { countryCode: 'es', year: 1977, imagePath: 'flag_history_es_1977', description: '西班牙 1977年国旗' },
      { countryCode: 'es', year: 1981, imagePath: 'flag_history_es_1981', description: '西班牙 1981年国旗' }
    ]
  },
  {
    countryCode: 'et',
    history: [
      { countryCode: 'et', year: 1200, imagePath: 'flag_history_et_1200', description: '埃塞俄比亚 1200年国旗' },
      { countryCode: 'et', year: 1889, imagePath: 'flag_history_et_1889', description: '埃塞俄比亚 1889年国旗' },
      { countryCode: 'et', year: 1897, imagePath: 'flag_history_et_1897', description: '埃塞俄比亚 1897年国旗' },
      { countryCode: 'et', year: 1936, imagePath: 'flag_history_et_1936', description: '埃塞俄比亚 1936年国旗' },
      { countryCode: 'et', year: 1962, imagePath: 'flag_history_et_1962', description: '埃塞俄比亚 1962年国旗' },
      { countryCode: 'et', year: 1974, imagePath: 'flag_history_et_1974', description: '埃塞俄比亚 1974年国旗' },
      { countryCode: 'et', year: 1987, imagePath: 'flag_history_et_1987', description: '埃塞俄比亚 1987年国旗' },
      { countryCode: 'et', year: 1991, imagePath: 'flag_history_et_1991', description: '埃塞俄比亚 1991年国旗' },
      { countryCode: 'et', year: 1996, imagePath: 'flag_history_et_1996', description: '埃塞俄比亚 1996年国旗' },
      { countryCode: 'et', year: 2009, imagePath: 'flag_history_et_2009', description: '埃塞俄比亚 2009年国旗' }
    ]
  },
  {
    countryCode: 'fi',
    history: [
      { countryCode: 'fi', year: 1562, imagePath: 'flag_history_fi_1562', description: '芬兰 1562年国旗' },
      { countryCode: 'fi', year: 1800, imagePath: 'flag_history_fi_1800', description: '芬兰 1800年国旗' },
      { countryCode: 'fi', year: 1809, imagePath: 'flag_history_fi_1809', description: '芬兰 1809年国旗' },
      { countryCode: 'fi', year: 1858, imagePath: 'flag_history_fi_1858', description: '芬兰 1858年国旗' },
      { countryCode: 'fi', year: 1883, imagePath: 'flag_history_fi_1883', description: '芬兰 1883年国旗' },
      { countryCode: 'fi', year: 1917, imagePath: 'flag_history_fi_1917', description: '芬兰 1917年国旗' },
      { countryCode: 'fi', year: 1918, imagePath: 'flag_history_fi_1918', description: '芬兰 1918年国旗' }
    ]
  },
  {
    countryCode: 'fj',
    history: [
      { countryCode: 'fj', year: 1200, imagePath: 'flag_history_fj_1200', description: '斐济 1200年国旗' },
      { countryCode: 'fj', year: 1878, imagePath: 'flag_history_fj_1878', description: '斐济 1878年国旗' },
      { countryCode: 'fj', year: 1924, imagePath: 'flag_history_fj_1924', description: '斐济 1924年国旗' },
      { countryCode: 'fj', year: 1970, imagePath: 'flag_history_fj_1970', description: '斐济 1970年国旗' }
    ]
  },
  {
    countryCode: 'fm',
    history: [
      { countryCode: 'fm', year: 1885, imagePath: 'flag_history_fm_1885', description: '密克罗尼西亚联邦 1885年国旗' },
      { countryCode: 'fm', year: 1899, imagePath: 'flag_history_fm_1899', description: '密克罗尼西亚联邦 1899年国旗' },
      { countryCode: 'fm', year: 1914, imagePath: 'flag_history_fm_1914', description: '密克罗尼西亚联邦 1914年国旗' },
      { countryCode: 'fm', year: 1944, imagePath: 'flag_history_fm_1944', description: '密克罗尼西亚联邦 1944年国旗' },
      { countryCode: 'fm', year: 1947, imagePath: 'flag_history_fm_1947', description: '密克罗尼西亚联邦 1947年国旗' },
      { countryCode: 'fm', year: 1965, imagePath: 'flag_history_fm_1965', description: '密克罗尼西亚联邦 1965年国旗' },
      { countryCode: 'fm', year: 1979, imagePath: 'flag_history_fm_1979', description: '密克罗尼西亚联邦 1979年国旗' }
    ]
  },
  {
    countryCode: 'fr',
    history: [
      { countryCode: 'fr', year: 1365, imagePath: 'flag_history_fr_1365', description: '法国 1365年国旗' },
      { countryCode: 'fr', year: 1790, imagePath: 'flag_history_fr_1790', description: '法国 1790年国旗' },
      { countryCode: 'fr', year: 1794, imagePath: 'flag_history_fr_1794', description: '法国 1794年国旗' },
      { countryCode: 'fr', year: 1814, imagePath: 'flag_history_fr_1814', description: '法国 1814年国旗' },
      { countryCode: 'fr', year: 1830, imagePath: 'flag_history_fr_1830', description: '法国 1830年国旗' }
    ]
  },
  {
    countryCode: 'ga',
    history: [
      { countryCode: 'ga', year: 1000, imagePath: 'flag_history_ga_1000', description: '加蓬 1000年国旗' },
      { countryCode: 'ga', year: 1903, imagePath: 'flag_history_ga_1903', description: '加蓬 1903年国旗' },
      { countryCode: 'ga', year: 1959, imagePath: 'flag_history_ga_1959', description: '加蓬 1959年国旗' },
      { countryCode: 'ga', year: 1960, imagePath: 'flag_history_ga_1960', description: '加蓬 1960年国旗' }
    ]
  },
  {
    countryCode: 'gb',
    history: [
      { countryCode: 'gb', year: 1000, imagePath: 'flag_history_gb_1000', description: '英国 1000年国旗' },
      { countryCode: 'gb', year: 1707, imagePath: 'flag_history_gb_1707', description: '英国 1707年国旗' },
      { countryCode: 'gb', year: 1801, imagePath: 'flag_history_gb_1801', description: '英国 1801年国旗' }
    ]
  },
  {
    countryCode: 'gd',
    history: [
      { countryCode: 'gd', year: 1000, imagePath: 'flag_history_gd_1000', description: '格林纳达 1000年国旗' },
      { countryCode: 'gd', year: 1663, imagePath: 'flag_history_gd_1663', description: '格林纳达 1663年国旗' },
      { countryCode: 'gd', year: 1715, imagePath: 'flag_history_gd_1715', description: '格林纳达 1715年国旗' },
      { countryCode: 'gd', year: 1763, imagePath: 'flag_history_gd_1763', description: '格林纳达 1763年国旗' },
      { countryCode: 'gd', year: 1779, imagePath: 'flag_history_gd_1779', description: '格林纳达 1779年国旗' },
      { countryCode: 'gd', year: 1783, imagePath: 'flag_history_gd_1783', description: '格林纳达 1783年国旗' },
      { countryCode: 'gd', year: 1801, imagePath: 'flag_history_gd_1801', description: '格林纳达 1801年国旗' },
      { countryCode: 'gd', year: 1958, imagePath: 'flag_history_gd_1958', description: '格林纳达 1958年国旗' },
      { countryCode: 'gd', year: 1962, imagePath: 'flag_history_gd_1962', description: '格林纳达 1962年国旗' },
      { countryCode: 'gd', year: 1967, imagePath: 'flag_history_gd_1967', description: '格林纳达 1967年国旗' },
      { countryCode: 'gd', year: 1974, imagePath: 'flag_history_gd_1974', description: '格林纳达 1974年国旗' }
    ]
  },
  {
    countryCode: 'ge',
    history: [
      { countryCode: 'ge', year: 1490, imagePath: 'flag_history_ge_1490', description: '格鲁吉亚 1490年国旗' },
      { countryCode: 'ge', year: 1762, imagePath: 'flag_history_ge_1762', description: '格鲁吉亚 1762年国旗' },
      { countryCode: 'ge', year: 1801, imagePath: 'flag_history_ge_1801', description: '格鲁吉亚 1801年国旗' },
      { countryCode: 'ge', year: 1858, imagePath: 'flag_history_ge_1858', description: '格鲁吉亚 1858年国旗' },
      { countryCode: 'ge', year: 1883, imagePath: 'flag_history_ge_1883', description: '格鲁吉亚 1883年国旗' },
      { countryCode: 'ge', year: 1918, imagePath: 'flag_history_ge_1918', description: '格鲁吉亚 1918年国旗' },
      { countryCode: 'ge', year: 1921, imagePath: 'flag_history_ge_1921', description: '格鲁吉亚 1921年国旗' },
      { countryCode: 'ge', year: 1922, imagePath: 'flag_history_ge_1922', description: '格鲁吉亚 1922年国旗' },
      { countryCode: 'ge', year: 1937, imagePath: 'flag_history_ge_1937', description: '格鲁吉亚 1937年国旗' },
      { countryCode: 'ge', year: 1951, imagePath: 'flag_history_ge_1951', description: '格鲁吉亚 1951年国旗' },
      { countryCode: 'ge', year: 1990, imagePath: 'flag_history_ge_1990', description: '格鲁吉亚 1990年国旗' },
      { countryCode: 'ge', year: 2004, imagePath: 'flag_history_ge_2004', description: '格鲁吉亚 2004年国旗' }
    ]
  },
  {
    countryCode: 'gh',
    history: [
      { countryCode: 'gh', year: 1821, imagePath: 'flag_history_gh_1821', description: '加纳 1821年国旗' },
      { countryCode: 'gh', year: 1877, imagePath: 'flag_history_gh_1877', description: '加纳 1877年国旗' },
      { countryCode: 'gh', year: 1957, imagePath: 'flag_history_gh_1957', description: '加纳 1957年国旗' },
      { countryCode: 'gh', year: 1961, imagePath: 'flag_history_gh_1961', description: '加纳 1961年国旗' },
      { countryCode: 'gh', year: 1964, imagePath: 'flag_history_gh_1964', description: '加纳 1964年国旗' },
      { countryCode: 'gh', year: 1966, imagePath: 'flag_history_gh_1966', description: '加纳 1966年国旗' }
    ]
  },
  {
    countryCode: 'gm',
    history: [
      { countryCode: 'gm', year: 1783, imagePath: 'flag_history_gm_1783', description: '冈比亚 1783年国旗' },
      { countryCode: 'gm', year: 1801, imagePath: 'flag_history_gm_1801', description: '冈比亚 1801年国旗' },
      { countryCode: 'gm', year: 1965, imagePath: 'flag_history_gm_1965', description: '冈比亚 1965年国旗' }
    ]
  },
  {
    countryCode: 'gn',
    history: [
      { countryCode: 'gn', year: 1898, imagePath: 'flag_history_gn_1898', description: '几内亚 1898年国旗' },
      { countryCode: 'gn', year: 1958, imagePath: 'flag_history_gn_1958', description: '几内亚 1958年国旗' }
    ]
  },
  {
    countryCode: 'gq',
    history: [
      { countryCode: 'gq', year: 1200, imagePath: 'flag_history_gq_1200', description: '赤道几内亚 1200年国旗' },
      { countryCode: 'gq', year: 1667, imagePath: 'flag_history_gq_1667', description: '赤道几内亚 1667年国旗' },
      { countryCode: 'gq', year: 1707, imagePath: 'flag_history_gq_1707', description: '赤道几内亚 1707年国旗' },
      { countryCode: 'gq', year: 1750, imagePath: 'flag_history_gq_1750', description: '赤道几内亚 1750年国旗' },
      { countryCode: 'gq', year: 1778, imagePath: 'flag_history_gq_1778', description: '赤道几内亚 1778年国旗' },
      { countryCode: 'gq', year: 1785, imagePath: 'flag_history_gq_1785', description: '赤道几内亚 1785年国旗' },
      { countryCode: 'gq', year: 1931, imagePath: 'flag_history_gq_1931', description: '赤道几内亚 1931年国旗' },
      { countryCode: 'gq', year: 1936, imagePath: 'flag_history_gq_1936', description: '赤道几内亚 1936年国旗' },
      { countryCode: 'gq', year: 1938, imagePath: 'flag_history_gq_1938', description: '赤道几内亚 1938年国旗' },
      { countryCode: 'gq', year: 1945, imagePath: 'flag_history_gq_1945', description: '赤道几内亚 1945年国旗' },
      { countryCode: 'gq', year: 1968, imagePath: 'flag_history_gq_1968', description: '赤道几内亚 1968年国旗' },
      { countryCode: 'gq', year: 1973, imagePath: 'flag_history_gq_1973', description: '赤道几内亚 1973年国旗' },
      { countryCode: 'gq', year: 1979, imagePath: 'flag_history_gq_1979', description: '赤道几内亚 1979年国旗' }
    ]
  },
  {
    countryCode: 'gr',
    history: [
      { countryCode: 'gr', year: 1453, imagePath: 'flag_history_gr_1453', description: '希腊 1453年国旗' },
      { countryCode: 'gr', year: 1769, imagePath: 'flag_history_gr_1769', description: '希腊 1769年国旗' },
      { countryCode: 'gr', year: 1822, imagePath: 'flag_history_gr_1822', description: '希腊 1822年国旗' },
      { countryCode: 'gr', year: 1833, imagePath: 'flag_history_gr_1833', description: '希腊 1833年国旗' },
      { countryCode: 'gr', year: 1862, imagePath: 'flag_history_gr_1862', description: '希腊 1862年国旗' },
      { countryCode: 'gr', year: 1924, imagePath: 'flag_history_gr_1924', description: '希腊 1924年国旗' },
      { countryCode: 'gr', year: 1935, imagePath: 'flag_history_gr_1935', description: '希腊 1935年国旗' },
      { countryCode: 'gr', year: 1941, imagePath: 'flag_history_gr_1941', description: '希腊 1941年国旗' },
      { countryCode: 'gr', year: 1944, imagePath: 'flag_history_gr_1944', description: '希腊 1944年国旗' },
      { countryCode: 'gr', year: 1967, imagePath: 'flag_history_gr_1967', description: '希腊 1967年国旗' },
      { countryCode: 'gr', year: 1970, imagePath: 'flag_history_gr_1970', description: '希腊 1970年国旗' },
      { countryCode: 'gr', year: 1975, imagePath: 'flag_history_gr_1975', description: '希腊 1975年国旗' },
      { countryCode: 'gr', year: 1978, imagePath: 'flag_history_gr_1978', description: '希腊 1978年国旗' }
    ]
  },
  {
    countryCode: 'gt',
    history: [
      { countryCode: 'gt', year: 1519, imagePath: 'flag_history_gt_1519', description: '危地马拉 1519年国旗' },
      { countryCode: 'gt', year: 1821, imagePath: 'flag_history_gt_1821', description: '危地马拉 1821年国旗' },
      { countryCode: 'gt', year: 1823, imagePath: 'flag_history_gt_1823', description: '危地马拉 1823年国旗' },
      { countryCode: 'gt', year: 1825, imagePath: 'flag_history_gt_1825', description: '危地马拉 1825年国旗' },
      { countryCode: 'gt', year: 1838, imagePath: 'flag_history_gt_1838', description: '危地马拉 1838年国旗' },
      { countryCode: 'gt', year: 1843, imagePath: 'flag_history_gt_1843', description: '危地马拉 1843年国旗' },
      { countryCode: 'gt', year: 1851, imagePath: 'flag_history_gt_1851', description: '危地马拉 1851年国旗' },
      { countryCode: 'gt', year: 1858, imagePath: 'flag_history_gt_1858', description: '危地马拉 1858年国旗' },
      { countryCode: 'gt', year: 1871, imagePath: 'flag_history_gt_1871', description: '危地马拉 1871年国旗' }
    ]
  },
  {
    countryCode: 'gw',
    history: [
      { countryCode: 'gw', year: 1200, imagePath: 'flag_history_gw_1200', description: '几内亚比绍 1200年国旗' },
      { countryCode: 'gw', year: 1667, imagePath: 'flag_history_gw_1667', description: '几内亚比绍 1667年国旗' },
      { countryCode: 'gw', year: 1707, imagePath: 'flag_history_gw_1707', description: '几内亚比绍 1707年国旗' },
      { countryCode: 'gw', year: 1750, imagePath: 'flag_history_gw_1750', description: '几内亚比绍 1750年国旗' },
      { countryCode: 'gw', year: 1816, imagePath: 'flag_history_gw_1816', description: '几内亚比绍 1816年国旗' },
      { countryCode: 'gw', year: 1826, imagePath: 'flag_history_gw_1826', description: '几内亚比绍 1826年国旗' },
      { countryCode: 'gw', year: 1830, imagePath: 'flag_history_gw_1830', description: '几内亚比绍 1830年国旗' },
      { countryCode: 'gw', year: 1911, imagePath: 'flag_history_gw_1911', description: '几内亚比绍 1911年国旗' },
      { countryCode: 'gw', year: 1974, imagePath: 'flag_history_gw_1974', description: '几内亚比绍 1974年国旗' }
    ]
  },
  {
    countryCode: 'gy',
    history: [
      { countryCode: 'gy', year: 1000, imagePath: 'flag_history_gy_1000', description: '圭亚那 1000年国旗' },
      { countryCode: 'gy', year: 1581, imagePath: 'flag_history_gy_1581', description: '圭亚那 1581年国旗' },
      { countryCode: 'gy', year: 1795, imagePath: 'flag_history_gy_1795', description: '圭亚那 1795年国旗' },
      { countryCode: 'gy', year: 1806, imagePath: 'flag_history_gy_1806', description: '圭亚那 1806年国旗' },
      { countryCode: 'gy', year: 1810, imagePath: 'flag_history_gy_1810', description: '圭亚那 1810年国旗' },
      { countryCode: 'gy', year: 1814, imagePath: 'flag_history_gy_1814', description: '圭亚那 1814年国旗' },
      { countryCode: 'gy', year: 1966, imagePath: 'flag_history_gy_1966', description: '圭亚那 1966年国旗' }
    ]
  },
  {
    countryCode: 'hn',
    history: [
      { countryCode: 'hn', year: 1519, imagePath: 'flag_history_hn_1519', description: '洪都拉斯 1519年国旗' },
      { countryCode: 'hn', year: 1821, imagePath: 'flag_history_hn_1821', description: '洪都拉斯 1821年国旗' },
      { countryCode: 'hn', year: 1823, imagePath: 'flag_history_hn_1823', description: '洪都拉斯 1823年国旗' },
      { countryCode: 'hn', year: 1825, imagePath: 'flag_history_hn_1825', description: '洪都拉斯 1825年国旗' },
      { countryCode: 'hn', year: 1838, imagePath: 'flag_history_hn_1838', description: '洪都拉斯 1838年国旗' },
      { countryCode: 'hn', year: 1866, imagePath: 'flag_history_hn_1866', description: '洪都拉斯 1866年国旗' },
      { countryCode: 'hn', year: 1898, imagePath: 'flag_history_hn_1898', description: '洪都拉斯 1898年国旗' },
      { countryCode: 'hn', year: 2022, imagePath: 'flag_history_hn_2022', description: '洪都拉斯 2022年国旗' }
    ]
  },
  {
    countryCode: 'hr',
    history: [
      { countryCode: 'hr', year: 1200, imagePath: 'flag_history_hr_1200', description: '克罗地亚 1200年国旗' },
      { countryCode: 'hr', year: 1401, imagePath: 'flag_history_hr_1401', description: '克罗地亚 1401年国旗' },
      { countryCode: 'hr', year: 1809, imagePath: 'flag_history_hr_1809', description: '克罗地亚 1809年国旗' },
      { countryCode: 'hr', year: 1848, imagePath: 'flag_history_hr_1848', description: '克罗地亚 1848年国旗' },
      { countryCode: 'hr', year: 1852, imagePath: 'flag_history_hr_1852', description: '克罗地亚 1852年国旗' },
      { countryCode: 'hr', year: 1868, imagePath: 'flag_history_hr_1868', description: '克罗地亚 1868年国旗' },
      { countryCode: 'hr', year: 1918, imagePath: 'flag_history_hr_1918', description: '克罗地亚 1918年国旗' },
      { countryCode: 'hr', year: 1939, imagePath: 'flag_history_hr_1939', description: '克罗地亚 1939年国旗' },
      { countryCode: 'hr', year: 1941, imagePath: 'flag_history_hr_1941', description: '克罗地亚 1941年国旗' },
      { countryCode: 'hr', year: 1943, imagePath: 'flag_history_hr_1943', description: '克罗地亚 1943年国旗' },
      { countryCode: 'hr', year: 1945, imagePath: 'flag_history_hr_1945', description: '克罗地亚 1945年国旗' },
      { countryCode: 'hr', year: 1990, imagePath: 'flag_history_hr_1990', description: '克罗地亚 1990年国旗' }
    ]
  },
  {
    countryCode: 'ht',
    history: [
      { countryCode: 'ht', year: 1000, imagePath: 'flag_history_ht_1000', description: '海地 1000年国旗' },
      { countryCode: 'ht', year: 1663, imagePath: 'flag_history_ht_1663', description: '海地 1663年国旗' },
      { countryCode: 'ht', year: 1715, imagePath: 'flag_history_ht_1715', description: '海地 1715年国旗' },
      { countryCode: 'ht', year: 1789, imagePath: 'flag_history_ht_1789', description: '海地 1789年国旗' },
      { countryCode: 'ht', year: 1804, imagePath: 'flag_history_ht_1804', description: '海地 1804年国旗' },
      { countryCode: 'ht', year: 1811, imagePath: 'flag_history_ht_1811', description: '海地 1811年国旗' },
      { countryCode: 'ht', year: 1821, imagePath: 'flag_history_ht_1821', description: '海地 1821年国旗' },
      { countryCode: 'ht', year: 1849, imagePath: 'flag_history_ht_1849', description: '海地 1849年国旗' },
      { countryCode: 'ht', year: 1859, imagePath: 'flag_history_ht_1859', description: '海地 1859年国旗' },
      { countryCode: 'ht', year: 1964, imagePath: 'flag_history_ht_1964', description: '海地 1964年国旗' },
      { countryCode: 'ht', year: 1986, imagePath: 'flag_history_ht_1986', description: '海地 1986年国旗' }
    ]
  },
  {
    countryCode: 'hu',
    history: [
      { countryCode: 'hu', year: 1200, imagePath: 'flag_history_hu_1200', description: '匈牙利 1200年国旗' },
      { countryCode: 'hu', year: 1541, imagePath: 'flag_history_hu_1541', description: '匈牙利 1541年国旗' },
      { countryCode: 'hu', year: 1711, imagePath: 'flag_history_hu_1711', description: '匈牙利 1711年国旗' },
      { countryCode: 'hu', year: 1849, imagePath: 'flag_history_hu_1849', description: '匈牙利 1849年国旗' },
      { countryCode: 'hu', year: 1867, imagePath: 'flag_history_hu_1867', description: '匈牙利 1867年国旗' },
      { countryCode: 'hu', year: 1869, imagePath: 'flag_history_hu_1869', description: '匈牙利 1869年国旗' },
      { countryCode: 'hu', year: 1874, imagePath: 'flag_history_hu_1874', description: '匈牙利 1874年国旗' },
      { countryCode: 'hu', year: 1896, imagePath: 'flag_history_hu_1896', description: '匈牙利 1896年国旗' },
      { countryCode: 'hu', year: 1915, imagePath: 'flag_history_hu_1915', description: '匈牙利 1915年国旗' },
      { countryCode: 'hu', year: 1919, imagePath: 'flag_history_hu_1919', description: '匈牙利 1919年国旗' },
      { countryCode: 'hu', year: 1946, imagePath: 'flag_history_hu_1946', description: '匈牙利 1946年国旗' },
      { countryCode: 'hu', year: 1949, imagePath: 'flag_history_hu_1949', description: '匈牙利 1949年国旗' },
      { countryCode: 'hu', year: 1957, imagePath: 'flag_history_hu_1957', description: '匈牙利 1957年国旗' },
      { countryCode: 'hu', year: 2000, imagePath: 'flag_history_hu_2000', description: '匈牙利 2000年国旗' }
    ]
  },
  {
    countryCode: 'id',
    history: [
      { countryCode: 'id', year: 1603, imagePath: 'flag_history_id_1603', description: '印尼 1603年国旗' },
      { countryCode: 'id', year: 1800, imagePath: 'flag_history_id_1800', description: '印尼 1800年国旗' },
      { countryCode: 'id', year: 1942, imagePath: 'flag_history_id_1942', description: '印尼 1942年国旗' },
      { countryCode: 'id', year: 1945, imagePath: 'flag_history_id_1945', description: '印尼 1945年国旗' },
      { countryCode: 'id', year: 1949, imagePath: 'flag_history_id_1949', description: '印尼 1949年国旗' }
    ]
  },
  {
    countryCode: 'ie',
    history: [
      { countryCode: 'ie', year: 1200, imagePath: 'flag_history_ie_1200', description: '爱尔兰 1200年国旗' },
      { countryCode: 'ie', year: 1542, imagePath: 'flag_history_ie_1542', description: '爱尔兰 1542年国旗' },
      { countryCode: 'ie', year: 1801, imagePath: 'flag_history_ie_1801', description: '爱尔兰 1801年国旗' },
      { countryCode: 'ie', year: 1919, imagePath: 'flag_history_ie_1919', description: '爱尔兰 1919年国旗' }
    ]
  },
  {
    countryCode: 'il',
    history: [
      { countryCode: 'il', year: 1100, imagePath: 'flag_history_il_1100', description: '以色列 1100年国旗' },
      { countryCode: 'il', year: 1453, imagePath: 'flag_history_il_1453', description: '以色列 1453年国旗' },
      { countryCode: 'il', year: 1844, imagePath: 'flag_history_il_1844', description: '以色列 1844年国旗' },
      { countryCode: 'il', year: 1920, imagePath: 'flag_history_il_1920', description: '以色列 1920年国旗' },
      { countryCode: 'il', year: 1927, imagePath: 'flag_history_il_1927', description: '以色列 1927年国旗' },
      { countryCode: 'il', year: 1948, imagePath: 'flag_history_il_1948', description: '以色列 1948年国旗' }
    ]
  },
  {
    countryCode: 'in',
    history: [
      { countryCode: 'in', year: 1674, imagePath: 'flag_history_in_1674', description: '印度 1674年国旗' },
      { countryCode: 'in', year: 1820, imagePath: 'flag_history_in_1820', description: '印度 1820年国旗' },
      { countryCode: 'in', year: 1858, imagePath: 'flag_history_in_1858', description: '印度 1858年国旗' },
      { countryCode: 'in', year: 1880, imagePath: 'flag_history_in_1880', description: '印度 1880年国旗' },
      { countryCode: 'in', year: 1947, imagePath: 'flag_history_in_1947', description: '印度 1947年国旗' }
    ]
  },
  {
    countryCode: 'iq',
    history: [
      { countryCode: 'iq', year: 1453, imagePath: 'flag_history_iq_1453', description: '伊拉克 1453年国旗' },
      { countryCode: 'iq', year: 1844, imagePath: 'flag_history_iq_1844', description: '伊拉克 1844年国旗' },
      { countryCode: 'iq', year: 1921, imagePath: 'flag_history_iq_1921', description: '伊拉克 1921年国旗' },
      { countryCode: 'iq', year: 1958, imagePath: 'flag_history_iq_1958', description: '伊拉克 1958年国旗' },
      { countryCode: 'iq', year: 1959, imagePath: 'flag_history_iq_1959', description: '伊拉克 1959年国旗' },
      { countryCode: 'iq', year: 1963, imagePath: 'flag_history_iq_1963', description: '伊拉克 1963年国旗' },
      { countryCode: 'iq', year: 1991, imagePath: 'flag_history_iq_1991', description: '伊拉克 1991年国旗' },
      { countryCode: 'iq', year: 2004, imagePath: 'flag_history_iq_2004', description: '伊拉克 2004年国旗' },
      { countryCode: 'iq', year: 2008, imagePath: 'flag_history_iq_2008', description: '伊拉克 2008年国旗' }
    ]
  },
  {
    countryCode: 'ir',
    history: [
      { countryCode: 'ir', year: 1576, imagePath: 'flag_history_ir_1576', description: '伊朗 1576年国旗' },
      { countryCode: 'ir', year: 1736, imagePath: 'flag_history_ir_1736', description: '伊朗 1736年国旗' },
      { countryCode: 'ir', year: 1747, imagePath: 'flag_history_ir_1747', description: '伊朗 1747年国旗' },
      { countryCode: 'ir', year: 1760, imagePath: 'flag_history_ir_1760', description: '伊朗 1760年国旗' },
      { countryCode: 'ir', year: 1796, imagePath: 'flag_history_ir_1796', description: '伊朗 1796年国旗' },
      { countryCode: 'ir', year: 1849, imagePath: 'flag_history_ir_1849', description: '伊朗 1849年国旗' },
      { countryCode: 'ir', year: 1907, imagePath: 'flag_history_ir_1907', description: '伊朗 1907年国旗' },
      { countryCode: 'ir', year: 1925, imagePath: 'flag_history_ir_1925', description: '伊朗 1925年国旗' },
      { countryCode: 'ir', year: 1980, imagePath: 'flag_history_ir_1980', description: '伊朗 1980年国旗' }
    ]
  },
  {
    countryCode: 'is',
    history: [
      { countryCode: 'is', year: 1250, imagePath: 'flag_history_is_1250', description: '冰岛 1250年国旗' },
      { countryCode: 'is', year: 1536, imagePath: 'flag_history_is_1536', description: '冰岛 1536年国旗' },
      { countryCode: 'is', year: 1900, imagePath: 'flag_history_is_1900', description: '冰岛 1900年国旗' },
      { countryCode: 'is', year: 1918, imagePath: 'flag_history_is_1918', description: '冰岛 1918年国旗' },
      { countryCode: 'is', year: 1944, imagePath: 'flag_history_is_1944', description: '冰岛 1944年国旗' }
    ]
  },
  {
    countryCode: 'it',
    history: [
      { countryCode: 'it', year: 1500, imagePath: 'flag_history_it_1500', description: '意大利 1500年国旗' },
      { countryCode: 'it', year: 1848, imagePath: 'flag_history_it_1848', description: '意大利 1848年国旗' },
      { countryCode: 'it', year: 1943, imagePath: 'flag_history_it_1943', description: '意大利 1943年国旗' },
      { countryCode: 'it', year: 1945, imagePath: 'flag_history_it_1945', description: '意大利 1945年国旗' },
      { countryCode: 'it', year: 2003, imagePath: 'flag_history_it_2003', description: '意大利 2003年国旗' },
      { countryCode: 'it', year: 2006, imagePath: 'flag_history_it_2006', description: '意大利 2006年国旗' }
    ]
  },
  {
    countryCode: 'jm',
    history: [
      { countryCode: 'jm', year: 1200, imagePath: 'flag_history_jm_1200', description: '牙买加 1200年国旗' },
      { countryCode: 'jm', year: 1655, imagePath: 'flag_history_jm_1655', description: '牙买加 1655年国旗' },
      { countryCode: 'jm', year: 1801, imagePath: 'flag_history_jm_1801', description: '牙买加 1801年国旗' },
      { countryCode: 'jm', year: 1875, imagePath: 'flag_history_jm_1875', description: '牙买加 1875年国旗' },
      { countryCode: 'jm', year: 1906, imagePath: 'flag_history_jm_1906', description: '牙买加 1906年国旗' },
      { countryCode: 'jm', year: 1957, imagePath: 'flag_history_jm_1957', description: '牙买加 1957年国旗' },
      { countryCode: 'jm', year: 1962, imagePath: 'flag_history_jm_1962', description: '牙买加 1962年国旗' }
    ]
  },
  {
    countryCode: 'jo',
    history: [
      { countryCode: 'jo', year: 1200, imagePath: 'flag_history_jo_1200', description: '约旦 1200年国旗' },
      { countryCode: 'jo', year: 1453, imagePath: 'flag_history_jo_1453', description: '约旦 1453年国旗' },
      { countryCode: 'jo', year: 1844, imagePath: 'flag_history_jo_1844', description: '约旦 1844年国旗' },
      { countryCode: 'jo', year: 1920, imagePath: 'flag_history_jo_1920', description: '约旦 1920年国旗' },
      { countryCode: 'jo', year: 1921, imagePath: 'flag_history_jo_1921', description: '约旦 1921年国旗' }
    ]
  },
  {
    countryCode: 'jp',
    history: [
      { countryCode: 'jp', year: 1185, imagePath: 'flag_history_jp_1185', description: '日本 1185年国旗' },
      { countryCode: 'jp', year: 1333, imagePath: 'flag_history_jp_1333', description: '日本 1333年国旗' },
      { countryCode: 'jp', year: 1338, imagePath: 'flag_history_jp_1338', description: '日本 1338年国旗' },
      { countryCode: 'jp', year: 1603, imagePath: 'flag_history_jp_1603', description: '日本 1603年国旗' },
      { countryCode: 'jp', year: 1854, imagePath: 'flag_history_jp_1854', description: '日本 1854年国旗' },
      { countryCode: 'jp', year: 1869, imagePath: 'flag_history_jp_1869', description: '日本 1869年国旗' },
      { countryCode: 'jp', year: 1870, imagePath: 'flag_history_jp_1870', description: '日本 1870年国旗' },
      { countryCode: 'jp', year: 1999, imagePath: 'flag_history_jp_1999', description: '日本 1999年国旗' }
    ]
  },
  {
    countryCode: 'ke',
    history: [
      { countryCode: 'ke', year: 1885, imagePath: 'flag_history_ke_1885', description: '肯尼亚 1885年国旗' },
      { countryCode: 'ke', year: 1921, imagePath: 'flag_history_ke_1921', description: '肯尼亚 1921年国旗' },
      { countryCode: 'ke', year: 1963, imagePath: 'flag_history_ke_1963', description: '肯尼亚 1963年国旗' }
    ]
  },
  {
    countryCode: 'kg',
    history: [
      { countryCode: 'kg', year: 1000, imagePath: 'flag_history_kg_1000', description: '吉尔吉斯斯坦 1000年国旗' },
      { countryCode: 'kg', year: 1858, imagePath: 'flag_history_kg_1858', description: '吉尔吉斯斯坦 1858年国旗' },
      { countryCode: 'kg', year: 1883, imagePath: 'flag_history_kg_1883', description: '吉尔吉斯斯坦 1883年国旗' },
      { countryCode: 'kg', year: 1920, imagePath: 'flag_history_kg_1920', description: '吉尔吉斯斯坦 1920年国旗' },
      { countryCode: 'kg', year: 1936, imagePath: 'flag_history_kg_1936', description: '吉尔吉斯斯坦 1936年国旗' },
      { countryCode: 'kg', year: 1952, imagePath: 'flag_history_kg_1952', description: '吉尔吉斯斯坦 1952年国旗' },
      { countryCode: 'kg', year: 1992, imagePath: 'flag_history_kg_1992', description: '吉尔吉斯斯坦 1992年国旗' }
    ]
  },
  {
    countryCode: 'kh',
    history: [
      { countryCode: 'kh', year: 1000, imagePath: 'flag_history_kh_1000', description: '柬埔寨 1000年国旗' },
      { countryCode: 'kh', year: 1863, imagePath: 'flag_history_kh_1863', description: '柬埔寨 1863年国旗' },
      { countryCode: 'kh', year: 1887, imagePath: 'flag_history_kh_1887', description: '柬埔寨 1887年国旗' },
      { countryCode: 'kh', year: 1953, imagePath: 'flag_history_kh_1953', description: '柬埔寨 1953年国旗' },
      { countryCode: 'kh', year: 1970, imagePath: 'flag_history_kh_1970', description: '柬埔寨 1970年国旗' },
      { countryCode: 'kh', year: 1975, imagePath: 'flag_history_kh_1975', description: '柬埔寨 1975年国旗' },
      { countryCode: 'kh', year: 1979, imagePath: 'flag_history_kh_1979', description: '柬埔寨 1979年国旗' },
      { countryCode: 'kh', year: 1989, imagePath: 'flag_history_kh_1989', description: '柬埔寨 1989年国旗' },
      { countryCode: 'kh', year: 1992, imagePath: 'flag_history_kh_1992', description: '柬埔寨 1992年国旗' },
      { countryCode: 'kh', year: 1993, imagePath: 'flag_history_kh_1993', description: '柬埔寨 1993年国旗' }
    ]
  },
  {
    countryCode: 'ki',
    history: [
      { countryCode: 'ki', year: 1892, imagePath: 'flag_history_ki_1892', description: '基里巴斯 1892年国旗' },
      { countryCode: 'ki', year: 1937, imagePath: 'flag_history_ki_1937', description: '基里巴斯 1937年国旗' },
      { countryCode: 'ki', year: 1942, imagePath: 'flag_history_ki_1942', description: '基里巴斯 1942年国旗' },
      { countryCode: 'ki', year: 1943, imagePath: 'flag_history_ki_1943', description: '基里巴斯 1943年国旗' },
      { countryCode: 'ki', year: 1979, imagePath: 'flag_history_ki_1979', description: '基里巴斯 1979年国旗' }
    ]
  },
  {
    countryCode: 'km',
    history: [
      { countryCode: 'km', year: 1000, imagePath: 'flag_history_km_1000', description: '科摩罗 1000年国旗' },
      { countryCode: 'km', year: 1887, imagePath: 'flag_history_km_1887', description: '科摩罗 1887年国旗' },
      { countryCode: 'km', year: 1963, imagePath: 'flag_history_km_1963', description: '科摩罗 1963年国旗' },
      { countryCode: 'km', year: 1975, imagePath: 'flag_history_km_1975', description: '科摩罗 1975年国旗' },
      { countryCode: 'km', year: 1978, imagePath: 'flag_history_km_1978', description: '科摩罗 1978年国旗' },
      { countryCode: 'km', year: 1992, imagePath: 'flag_history_km_1992', description: '科摩罗 1992年国旗' },
      { countryCode: 'km', year: 1996, imagePath: 'flag_history_km_1996', description: '科摩罗 1996年国旗' },
      { countryCode: 'km', year: 2001, imagePath: 'flag_history_km_2001', description: '科摩罗 2001年国旗' }
    ]
  },
  {
    countryCode: 'kn',
    history: [
      { countryCode: 'kn', year: 1626, imagePath: 'flag_history_kn_1626', description: '圣基茨和尼维斯 1626年国旗' },
      { countryCode: 'kn', year: 1713, imagePath: 'flag_history_kn_1713', description: '圣基茨和尼维斯 1713年国旗' },
      { countryCode: 'kn', year: 1801, imagePath: 'flag_history_kn_1801', description: '圣基茨和尼维斯 1801年国旗' },
      { countryCode: 'kn', year: 1958, imagePath: 'flag_history_kn_1958', description: '圣基茨和尼维斯 1958年国旗' },
      { countryCode: 'kn', year: 1983, imagePath: 'flag_history_kn_1983', description: '圣基茨和尼维斯 1983年国旗' }
    ]
  },
  {
    countryCode: 'kp',
    history: [
      { countryCode: 'kp', year: 1200, imagePath: 'flag_history_kp_1200', description: '朝鲜 1200年国旗' },
      { countryCode: 'kp', year: 1392, imagePath: 'flag_history_kp_1392', description: '朝鲜 1392年国旗' },
      { countryCode: 'kp', year: 1870, imagePath: 'flag_history_kp_1870', description: '朝鲜 1870年国旗' },
      { countryCode: 'kp', year: 1882, imagePath: 'flag_history_kp_1882', description: '朝鲜 1882年国旗' },
      { countryCode: 'kp', year: 1888, imagePath: 'flag_history_kp_1888', description: '朝鲜 1888年国旗' },
      { countryCode: 'kp', year: 1893, imagePath: 'flag_history_kp_1893', description: '朝鲜 1893年国旗' },
      { countryCode: 'kp', year: 1899, imagePath: 'flag_history_kp_1899', description: '朝鲜 1899年国旗' },
      { countryCode: 'kp', year: 1936, imagePath: 'flag_history_kp_1936', description: '朝鲜 1936年国旗' },
      { countryCode: 'kp', year: 1946, imagePath: 'flag_history_kp_1946', description: '朝鲜 1946年国旗' }
    ]
  },
  {
    countryCode: 'kr',
    history: [
      { countryCode: 'kr', year: 1392, imagePath: 'flag_history_kr_1392', description: '韩国 1392年国旗' },
      { countryCode: 'kr', year: 1870, imagePath: 'flag_history_kr_1870', description: '韩国 1870年国旗' },
      { countryCode: 'kr', year: 1882, imagePath: 'flag_history_kr_1882', description: '韩国 1882年国旗' },
      { countryCode: 'kr', year: 1888, imagePath: 'flag_history_kr_1888', description: '韩国 1888年国旗' },
      { countryCode: 'kr', year: 1893, imagePath: 'flag_history_kr_1893', description: '韩国 1893年国旗' },
      { countryCode: 'kr', year: 1899, imagePath: 'flag_history_kr_1899', description: '韩国 1899年国旗' },
      { countryCode: 'kr', year: 1912, imagePath: 'flag_history_kr_1912', description: '韩国 1912年国旗' },
      { countryCode: 'kr', year: 1948, imagePath: 'flag_history_kr_1948', description: '韩国 1948年国旗' },
      { countryCode: 'kr', year: 1949, imagePath: 'flag_history_kr_1949', description: '韩国 1949年国旗' },
      { countryCode: 'kr', year: 1997, imagePath: 'flag_history_kr_1997', description: '韩国 1997年国旗' }
    ]
  },
  {
    countryCode: 'kw',
    history: [
      { countryCode: 'kw', year: 1200, imagePath: 'flag_history_kw_1200', description: '科威特 1200年国旗' },
      { countryCode: 'kw', year: 1752, imagePath: 'flag_history_kw_1752', description: '科威特 1752年国旗' },
      { countryCode: 'kw', year: 1898, imagePath: 'flag_history_kw_1898', description: '科威特 1898年国旗' },
      { countryCode: 'kw', year: 1899, imagePath: 'flag_history_kw_1899', description: '科威特 1899年国旗' },
      { countryCode: 'kw', year: 1961, imagePath: 'flag_history_kw_1961', description: '科威特 1961年国旗' }
    ]
  },
  {
    countryCode: 'kz',
    history: [
      { countryCode: 'kz', year: 1000, imagePath: 'flag_history_kz_1000', description: '哈萨克斯坦 1000年国旗' },
      { countryCode: 'kz', year: 1831, imagePath: 'flag_history_kz_1831', description: '哈萨克斯坦 1831年国旗' },
      { countryCode: 'kz', year: 1858, imagePath: 'flag_history_kz_1858', description: '哈萨克斯坦 1858年国旗' },
      { countryCode: 'kz', year: 1883, imagePath: 'flag_history_kz_1883', description: '哈萨克斯坦 1883年国旗' },
      { countryCode: 'kz', year: 1917, imagePath: 'flag_history_kz_1917', description: '哈萨克斯坦 1917年国旗' },
      { countryCode: 'kz', year: 1920, imagePath: 'flag_history_kz_1920', description: '哈萨克斯坦 1920年国旗' },
      { countryCode: 'kz', year: 1937, imagePath: 'flag_history_kz_1937', description: '哈萨克斯坦 1937年国旗' },
      { countryCode: 'kz', year: 1940, imagePath: 'flag_history_kz_1940', description: '哈萨克斯坦 1940年国旗' },
      { countryCode: 'kz', year: 1953, imagePath: 'flag_history_kz_1953', description: '哈萨克斯坦 1953年国旗' },
      { countryCode: 'kz', year: 1992, imagePath: 'flag_history_kz_1992', description: '哈萨克斯坦 1992年国旗' }
    ]
  },
  {
    countryCode: 'la',
    history: [
      { countryCode: 'la', year: 1893, imagePath: 'flag_history_la_1893', description: '老挝 1893年国旗' },
      { countryCode: 'la', year: 1952, imagePath: 'flag_history_la_1952', description: '老挝 1952年国旗' },
      { countryCode: 'la', year: 1975, imagePath: 'flag_history_la_1975', description: '老挝 1975年国旗' }
    ]
  },
  {
    countryCode: 'lb',
    history: [
      { countryCode: 'lb', year: 1453, imagePath: 'flag_history_lb_1453', description: '黎巴嫩 1453年国旗' },
      { countryCode: 'lb', year: 1844, imagePath: 'flag_history_lb_1844', description: '黎巴嫩 1844年国旗' },
      { countryCode: 'lb', year: 1920, imagePath: 'flag_history_lb_1920', description: '黎巴嫩 1920年国旗' },
      { countryCode: 'lb', year: 1943, imagePath: 'flag_history_lb_1943', description: '黎巴嫩 1943年国旗' }
    ]
  },
  {
    countryCode: 'lc',
    history: [
      { countryCode: 'lc', year: 1200, imagePath: 'flag_history_lc_1200', description: '圣卢西亚 1200年国旗' },
      { countryCode: 'lc', year: 1663, imagePath: 'flag_history_lc_1663', description: '圣卢西亚 1663年国旗' },
      { countryCode: 'lc', year: 1715, imagePath: 'flag_history_lc_1715', description: '圣卢西亚 1715年国旗' },
      { countryCode: 'lc', year: 1743, imagePath: 'flag_history_lc_1743', description: '圣卢西亚 1743年国旗' },
      { countryCode: 'lc', year: 1756, imagePath: 'flag_history_lc_1756', description: '圣卢西亚 1756年国旗' },
      { countryCode: 'lc', year: 1762, imagePath: 'flag_history_lc_1762', description: '圣卢西亚 1762年国旗' },
      { countryCode: 'lc', year: 1763, imagePath: 'flag_history_lc_1763', description: '圣卢西亚 1763年国旗' },
      { countryCode: 'lc', year: 1778, imagePath: 'flag_history_lc_1778', description: '圣卢西亚 1778年国旗' },
      { countryCode: 'lc', year: 1783, imagePath: 'flag_history_lc_1783', description: '圣卢西亚 1783年国旗' },
      { countryCode: 'lc', year: 1789, imagePath: 'flag_history_lc_1789', description: '圣卢西亚 1789年国旗' },
      { countryCode: 'lc', year: 1796, imagePath: 'flag_history_lc_1796', description: '圣卢西亚 1796年国旗' },
      { countryCode: 'lc', year: 1801, imagePath: 'flag_history_lc_1801', description: '圣卢西亚 1801年国旗' },
      { countryCode: 'lc', year: 1802, imagePath: 'flag_history_lc_1802', description: '圣卢西亚 1802年国旗' },
      { countryCode: 'lc', year: 1803, imagePath: 'flag_history_lc_1803', description: '圣卢西亚 1803年国旗' },
      { countryCode: 'lc', year: 1903, imagePath: 'flag_history_lc_1903', description: '圣卢西亚 1903年国旗' },
      { countryCode: 'lc', year: 1958, imagePath: 'flag_history_lc_1958', description: '圣卢西亚 1958年国旗' },
      { countryCode: 'lc', year: 1962, imagePath: 'flag_history_lc_1962', description: '圣卢西亚 1962年国旗' },
      { countryCode: 'lc', year: 1967, imagePath: 'flag_history_lc_1967', description: '圣卢西亚 1967年国旗' },
      { countryCode: 'lc', year: 1979, imagePath: 'flag_history_lc_1979', description: '圣卢西亚 1979年国旗' },
      { countryCode: 'lc', year: 2002, imagePath: 'flag_history_lc_2002', description: '圣卢西亚 2002年国旗' }
    ]
  },
  {
    countryCode: 'li',
    history: [
      { countryCode: 'li', year: 1000, imagePath: 'flag_history_li_1000', description: '列支敦士登 1000年国旗' },
      { countryCode: 'li', year: 1400, imagePath: 'flag_history_li_1400', description: '列支敦士登 1400年国旗' },
      { countryCode: 'li', year: 1719, imagePath: 'flag_history_li_1719', description: '列支敦士登 1719年国旗' },
      { countryCode: 'li', year: 1852, imagePath: 'flag_history_li_1852', description: '列支敦士登 1852年国旗' },
      { countryCode: 'li', year: 1921, imagePath: 'flag_history_li_1921', description: '列支敦士登 1921年国旗' },
      { countryCode: 'li', year: 1937, imagePath: 'flag_history_li_1937', description: '列支敦士登 1937年国旗' },
      { countryCode: 'li', year: 1982, imagePath: 'flag_history_li_1982', description: '列支敦士登 1982年国旗' }
    ]
  },
  {
    countryCode: 'lk',
    history: [
      { countryCode: 'lk', year: 1200, imagePath: 'flag_history_lk_1200', description: '斯里兰卡 1200年国旗' },
      { countryCode: 'lk', year: 1656, imagePath: 'flag_history_lk_1656', description: '斯里兰卡 1656年国旗' },
      { countryCode: 'lk', year: 1815, imagePath: 'flag_history_lk_1815', description: '斯里兰卡 1815年国旗' },
      { countryCode: 'lk', year: 1948, imagePath: 'flag_history_lk_1948', description: '斯里兰卡 1948年国旗' },
      { countryCode: 'lk', year: 1951, imagePath: 'flag_history_lk_1951', description: '斯里兰卡 1951年国旗' },
      { countryCode: 'lk', year: 1972, imagePath: 'flag_history_lk_1972', description: '斯里兰卡 1972年国旗' }
    ]
  },
  {
    countryCode: 'lr',
    history: [
      { countryCode: 'lr', year: 1140, imagePath: 'flag_history_lr_1140', description: '利比里亚 1140年国旗' },
      { countryCode: 'lr', year: 1827, imagePath: 'flag_history_lr_1827', description: '利比里亚 1827年国旗' },
      { countryCode: 'lr', year: 1847, imagePath: 'flag_history_lr_1847', description: '利比里亚 1847年国旗' }
    ]
  },
  {
    countryCode: 'ls',
    history: [
      { countryCode: 'ls', year: 1652, imagePath: 'flag_history_ls_1652', description: '莱索托 1652年国旗' },
      { countryCode: 'ls', year: 1795, imagePath: 'flag_history_ls_1795', description: '莱索托 1795年国旗' },
      { countryCode: 'ls', year: 1801, imagePath: 'flag_history_ls_1801', description: '莱索托 1801年国旗' },
      { countryCode: 'ls', year: 1875, imagePath: 'flag_history_ls_1875', description: '莱索托 1875年国旗' },
      { countryCode: 'ls', year: 1884, imagePath: 'flag_history_ls_1884', description: '莱索托 1884年国旗' },
      { countryCode: 'ls', year: 1966, imagePath: 'flag_history_ls_1966', description: '莱索托 1966年国旗' },
      { countryCode: 'ls', year: 1987, imagePath: 'flag_history_ls_1987', description: '莱索托 1987年国旗' },
      { countryCode: 'ls', year: 2006, imagePath: 'flag_history_ls_2006', description: '莱索托 2006年国旗' }
    ]
  },
  {
    countryCode: 'lt',
    history: [
      { countryCode: 'lt', year: 1000, imagePath: 'flag_history_lt_1000', description: '立陶宛 1000年国旗' },
      { countryCode: 'lt', year: 1795, imagePath: 'flag_history_lt_1795', description: '立陶宛 1795年国旗' },
      { countryCode: 'lt', year: 1858, imagePath: 'flag_history_lt_1858', description: '立陶宛 1858年国旗' },
      { countryCode: 'lt', year: 1883, imagePath: 'flag_history_lt_1883', description: '立陶宛 1883年国旗' },
      { countryCode: 'lt', year: 1918, imagePath: 'flag_history_lt_1918', description: '立陶宛 1918年国旗' },
      { countryCode: 'lt', year: 1940, imagePath: 'flag_history_lt_1940', description: '立陶宛 1940年国旗' },
      { countryCode: 'lt', year: 1941, imagePath: 'flag_history_lt_1941', description: '立陶宛 1941年国旗' },
      { countryCode: 'lt', year: 1944, imagePath: 'flag_history_lt_1944', description: '立陶宛 1944年国旗' },
      { countryCode: 'lt', year: 1953, imagePath: 'flag_history_lt_1953', description: '立陶宛 1953年国旗' },
      { countryCode: 'lt', year: 1988, imagePath: 'flag_history_lt_1988', description: '立陶宛 1988年国旗' },
      { countryCode: 'lt', year: 2004, imagePath: 'flag_history_lt_2004', description: '立陶宛 2004年国旗' }
    ]
  },
  {
    countryCode: 'lu',
    history: [
      { countryCode: 'lu', year: 1482, imagePath: 'flag_history_lu_1482', description: '卢森堡 1482年国旗' },
      { countryCode: 'lu', year: 1795, imagePath: 'flag_history_lu_1795', description: '卢森堡 1795年国旗' },
      { countryCode: 'lu', year: 1815, imagePath: 'flag_history_lu_1815', description: '卢森堡 1815年国旗' },
      { countryCode: 'lu', year: 1845, imagePath: 'flag_history_lu_1845', description: '卢森堡 1845年国旗' },
      { countryCode: 'lu', year: 1940, imagePath: 'flag_history_lu_1940', description: '卢森堡 1940年国旗' },
      { countryCode: 'lu', year: 1944, imagePath: 'flag_history_lu_1944', description: '卢森堡 1944年国旗' }
    ]
  },
  {
    countryCode: 'lv',
    history: [
      { countryCode: 'lv', year: 1200, imagePath: 'flag_history_lv_1200', description: '拉脱维亚 1200年国旗' },
      { countryCode: 'lv', year: 1692, imagePath: 'flag_history_lv_1692', description: '拉脱维亚 1692年国旗' },
      { countryCode: 'lv', year: 1721, imagePath: 'flag_history_lv_1721', description: '拉脱维亚 1721年国旗' },
      { countryCode: 'lv', year: 1918, imagePath: 'flag_history_lv_1918', description: '拉脱维亚 1918年国旗' },
      { countryCode: 'lv', year: 1919, imagePath: 'flag_history_lv_1919', description: '拉脱维亚 1919年国旗' },
      { countryCode: 'lv', year: 1920, imagePath: 'flag_history_lv_1920', description: '拉脱维亚 1920年国旗' },
      { countryCode: 'lv', year: 1940, imagePath: 'flag_history_lv_1940', description: '拉脱维亚 1940年国旗' },
      { countryCode: 'lv', year: 1941, imagePath: 'flag_history_lv_1941', description: '拉脱维亚 1941年国旗' },
      { countryCode: 'lv', year: 1944, imagePath: 'flag_history_lv_1944', description: '拉脱维亚 1944年国旗' },
      { countryCode: 'lv', year: 1953, imagePath: 'flag_history_lv_1953', description: '拉脱维亚 1953年国旗' },
      { countryCode: 'lv', year: 1990, imagePath: 'flag_history_lv_1990', description: '拉脱维亚 1990年国旗' }
    ]
  },
  {
    countryCode: 'ly',
    history: [
      { countryCode: 'ly', year: 1575, imagePath: 'flag_history_ly_1575', description: '利比亚 1575年国旗' },
      { countryCode: 'ly', year: 1912, imagePath: 'flag_history_ly_1912', description: '利比亚 1912年国旗' },
      { countryCode: 'ly', year: 1951, imagePath: 'flag_history_ly_1951', description: '利比亚 1951年国旗' },
      { countryCode: 'ly', year: 1969, imagePath: 'flag_history_ly_1969', description: '利比亚 1969年国旗' },
      { countryCode: 'ly', year: 1972, imagePath: 'flag_history_ly_1972', description: '利比亚 1972年国旗' },
      { countryCode: 'ly', year: 1977, imagePath: 'flag_history_ly_1977', description: '利比亚 1977年国旗' },
      { countryCode: 'ly', year: 2011, imagePath: 'flag_history_ly_2011', description: '利比亚 2011年国旗' }
    ]
  },
  {
    countryCode: 'ma',
    history: [
      { countryCode: 'ma', year: 1666, imagePath: 'flag_history_ma_1666', description: '摩洛哥 1666年国旗' },
      { countryCode: 'ma', year: 1913, imagePath: 'flag_history_ma_1913', description: '摩洛哥 1913年国旗' },
      { countryCode: 'ma', year: 1956, imagePath: 'flag_history_ma_1956', description: '摩洛哥 1956年国旗' }
    ]
  },
  {
    countryCode: 'mc',
    history: [
      { countryCode: 'mc', year: 1000, imagePath: 'flag_history_mc_1000', description: '摩纳哥 1000年国旗' },
      { countryCode: 'mc', year: 1793, imagePath: 'flag_history_mc_1793', description: '摩纳哥 1793年国旗' },
      { countryCode: 'mc', year: 1881, imagePath: 'flag_history_mc_1881', description: '摩纳哥 1881年国旗' },
      { countryCode: 'mc', year: 1942, imagePath: 'flag_history_mc_1942', description: '摩纳哥 1942年国旗' },
      { countryCode: 'mc', year: 1943, imagePath: 'flag_history_mc_1943', description: '摩纳哥 1943年国旗' },
      { countryCode: 'mc', year: 1945, imagePath: 'flag_history_mc_1945', description: '摩纳哥 1945年国旗' }
    ]
  },
  {
    countryCode: 'md',
    history: [
      { countryCode: 'md', year: 1490, imagePath: 'flag_history_md_1490', description: '摩尔多瓦 1490年国旗' },
      { countryCode: 'md', year: 1800, imagePath: 'flag_history_md_1800', description: '摩尔多瓦 1800年国旗' },
      { countryCode: 'md', year: 1834, imagePath: 'flag_history_md_1834', description: '摩尔多瓦 1834年国旗' },
      { countryCode: 'md', year: 1866, imagePath: 'flag_history_md_1866', description: '摩尔多瓦 1866年国旗' },
      { countryCode: 'md', year: 1917, imagePath: 'flag_history_md_1917', description: '摩尔多瓦 1917年国旗' },
      { countryCode: 'md', year: 1919, imagePath: 'flag_history_md_1919', description: '摩尔多瓦 1919年国旗' },
      { countryCode: 'md', year: 1925, imagePath: 'flag_history_md_1925', description: '摩尔多瓦 1925年国旗' },
      { countryCode: 'md', year: 1937, imagePath: 'flag_history_md_1937', description: '摩尔多瓦 1937年国旗' },
      { countryCode: 'md', year: 1938, imagePath: 'flag_history_md_1938', description: '摩尔多瓦 1938年国旗' },
      { countryCode: 'md', year: 1940, imagePath: 'flag_history_md_1940', description: '摩尔多瓦 1940年国旗' },
      { countryCode: 'md', year: 1952, imagePath: 'flag_history_md_1952', description: '摩尔多瓦 1952年国旗' },
      { countryCode: 'md', year: 1990, imagePath: 'flag_history_md_1990', description: '摩尔多瓦 1990年国旗' }
    ]
  },
  {
    countryCode: 'me',
    history: [
      { countryCode: 'me', year: 1200, imagePath: 'flag_history_me_1200', description: '黑山 1200年国旗' },
      { countryCode: 'me', year: 1545, imagePath: 'flag_history_me_1545', description: '黑山 1545年国旗' },
      { countryCode: 'me', year: 1876, imagePath: 'flag_history_me_1876', description: '黑山 1876年国旗' },
      { countryCode: 'me', year: 1905, imagePath: 'flag_history_me_1905', description: '黑山 1905年国旗' },
      { countryCode: 'me', year: 1946, imagePath: 'flag_history_me_1946', description: '黑山 1946年国旗' },
      { countryCode: 'me', year: 1993, imagePath: 'flag_history_me_1993', description: '黑山 1993年国旗' },
      { countryCode: 'me', year: 2004, imagePath: 'flag_history_me_2004', description: '黑山 2004年国旗' }
    ]
  },
  {
    countryCode: 'mg',
    history: [
      { countryCode: 'mg', year: 1896, imagePath: 'flag_history_mg_1896', description: '马达加斯加 1896年国旗' },
      { countryCode: 'mg', year: 1958, imagePath: 'flag_history_mg_1958', description: '马达加斯加 1958年国旗' }
    ]
  },
  {
    countryCode: 'mh',
    history: [
      { countryCode: 'mh', year: 1140, imagePath: 'flag_history_mh_1140', description: '马绍尔群岛 1140年国旗' },
      { countryCode: 'mh', year: 1885, imagePath: 'flag_history_mh_1885', description: '马绍尔群岛 1885年国旗' },
      { countryCode: 'mh', year: 1889, imagePath: 'flag_history_mh_1889', description: '马绍尔群岛 1889年国旗' },
      { countryCode: 'mh', year: 1914, imagePath: 'flag_history_mh_1914', description: '马绍尔群岛 1914年国旗' },
      { countryCode: 'mh', year: 1944, imagePath: 'flag_history_mh_1944', description: '马绍尔群岛 1944年国旗' },
      { countryCode: 'mh', year: 1947, imagePath: 'flag_history_mh_1947', description: '马绍尔群岛 1947年国旗' },
      { countryCode: 'mh', year: 1965, imagePath: 'flag_history_mh_1965', description: '马绍尔群岛 1965年国旗' },
      { countryCode: 'mh', year: 1979, imagePath: 'flag_history_mh_1979', description: '马绍尔群岛 1979年国旗' }
    ]
  },
  {
    countryCode: 'mk',
    history: [
      { countryCode: 'mk', year: 1200, imagePath: 'flag_history_mk_1200', description: '北马其顿 1200年国旗' },
      { countryCode: 'mk', year: 1453, imagePath: 'flag_history_mk_1453', description: '北马其顿 1453年国旗' },
      { countryCode: 'mk', year: 1844, imagePath: 'flag_history_mk_1844', description: '北马其顿 1844年国旗' },
      { countryCode: 'mk', year: 1903, imagePath: 'flag_history_mk_1903', description: '北马其顿 1903年国旗' },
      { countryCode: 'mk', year: 1912, imagePath: 'flag_history_mk_1912', description: '北马其顿 1912年国旗' },
      { countryCode: 'mk', year: 1918, imagePath: 'flag_history_mk_1918', description: '北马其顿 1918年国旗' },
      { countryCode: 'mk', year: 1941, imagePath: 'flag_history_mk_1941', description: '北马其顿 1941年国旗' },
      { countryCode: 'mk', year: 1944, imagePath: 'flag_history_mk_1944', description: '北马其顿 1944年国旗' },
      { countryCode: 'mk', year: 1946, imagePath: 'flag_history_mk_1946', description: '北马其顿 1946年国旗' },
      { countryCode: 'mk', year: 1991, imagePath: 'flag_history_mk_1991', description: '北马其顿 1991年国旗' },
      { countryCode: 'mk', year: 1995, imagePath: 'flag_history_mk_1995', description: '北马其顿 1995年国旗' }
    ]
  },
  {
    countryCode: 'ml',
    history: [
      { countryCode: 'ml', year: 1892, imagePath: 'flag_history_ml_1892', description: '马里 1892年国旗' },
      { countryCode: 'ml', year: 1958, imagePath: 'flag_history_ml_1958', description: '马里 1958年国旗' },
      { countryCode: 'ml', year: 1959, imagePath: 'flag_history_ml_1959', description: '马里 1959年国旗' },
      { countryCode: 'ml', year: 1961, imagePath: 'flag_history_ml_1961', description: '马里 1961年国旗' }
    ]
  },
  {
    countryCode: 'mm',
    history: [
      { countryCode: 'mm', year: 1200, imagePath: 'flag_history_mm_1200', description: '缅甸 1200年国旗' },
      { countryCode: 'mm', year: 1753, imagePath: 'flag_history_mm_1753', description: '缅甸 1753年国旗' },
      { countryCode: 'mm', year: 1885, imagePath: 'flag_history_mm_1885', description: '缅甸 1885年国旗' },
      { countryCode: 'mm', year: 1937, imagePath: 'flag_history_mm_1937', description: '缅甸 1937年国旗' },
      { countryCode: 'mm', year: 1943, imagePath: 'flag_history_mm_1943', description: '缅甸 1943年国旗' },
      { countryCode: 'mm', year: 1945, imagePath: 'flag_history_mm_1945', description: '缅甸 1945年国旗' },
      { countryCode: 'mm', year: 1948, imagePath: 'flag_history_mm_1948', description: '缅甸 1948年国旗' },
      { countryCode: 'mm', year: 1974, imagePath: 'flag_history_mm_1974', description: '缅甸 1974年国旗' },
      { countryCode: 'mm', year: 2010, imagePath: 'flag_history_mm_2010', description: '缅甸 2010年国旗' }
    ]
  },
  {
    countryCode: 'mn',
    history: [
      { countryCode: 'mn', year: 1200, imagePath: 'flag_history_mn_1200', description: '蒙古 1200年国旗' },
      { countryCode: 'mn', year: 1862, imagePath: 'flag_history_mn_1862', description: '蒙古 1862年国旗' },
      { countryCode: 'mn', year: 1890, imagePath: 'flag_history_mn_1890', description: '蒙古 1890年国旗' },
      { countryCode: 'mn', year: 1911, imagePath: 'flag_history_mn_1911', description: '蒙古 1911年国旗' },
      { countryCode: 'mn', year: 1915, imagePath: 'flag_history_mn_1915', description: '蒙古 1915年国旗' },
      { countryCode: 'mn', year: 1921, imagePath: 'flag_history_mn_1921', description: '蒙古 1921年国旗' },
      { countryCode: 'mn', year: 1924, imagePath: 'flag_history_mn_1924', description: '蒙古 1924年国旗' },
      { countryCode: 'mn', year: 1940, imagePath: 'flag_history_mn_1940', description: '蒙古 1940年国旗' },
      { countryCode: 'mn', year: 1992, imagePath: 'flag_history_mn_1992', description: '蒙古 1992年国旗' }
    ]
  },
  {
    countryCode: 'mr',
    history: [
      { countryCode: 'mr', year: 1200, imagePath: 'flag_history_mr_1200', description: '毛里塔尼亚 1200年国旗' },
      { countryCode: 'mr', year: 1900, imagePath: 'flag_history_mr_1900', description: '毛里塔尼亚 1900年国旗' },
      { countryCode: 'mr', year: 1959, imagePath: 'flag_history_mr_1959', description: '毛里塔尼亚 1959年国旗' },
      { countryCode: 'mr', year: 2017, imagePath: 'flag_history_mr_2017', description: '毛里塔尼亚 2017年国旗' }
    ]
  },
  {
    countryCode: 'mt',
    history: [
      { countryCode: 'mt', year: 1567, imagePath: 'flag_history_mt_1567', description: '马耳他 1567年国旗' },
      { countryCode: 'mt', year: 1798, imagePath: 'flag_history_mt_1798', description: '马耳他 1798年国旗' },
      { countryCode: 'mt', year: 1800, imagePath: 'flag_history_mt_1800', description: '马耳他 1800年国旗' },
      { countryCode: 'mt', year: 1801, imagePath: 'flag_history_mt_1801', description: '马耳他 1801年国旗' },
      { countryCode: 'mt', year: 1875, imagePath: 'flag_history_mt_1875', description: '马耳他 1875年国旗' },
      { countryCode: 'mt', year: 1898, imagePath: 'flag_history_mt_1898', description: '马耳他 1898年国旗' },
      { countryCode: 'mt', year: 1923, imagePath: 'flag_history_mt_1923', description: '马耳他 1923年国旗' },
      { countryCode: 'mt', year: 1943, imagePath: 'flag_history_mt_1943', description: '马耳他 1943年国旗' },
      { countryCode: 'mt', year: 1964, imagePath: 'flag_history_mt_1964', description: '马耳他 1964年国旗' }
    ]
  },
  {
    countryCode: 'mu',
    history: [
      { countryCode: 'mu', year: 1666, imagePath: 'flag_history_mu_1666', description: '毛里求斯 1666年国旗' },
      { countryCode: 'mu', year: 1710, imagePath: 'flag_history_mu_1710', description: '毛里求斯 1710年国旗' },
      { countryCode: 'mu', year: 1789, imagePath: 'flag_history_mu_1789', description: '毛里求斯 1789年国旗' },
      { countryCode: 'mu', year: 1810, imagePath: 'flag_history_mu_1810', description: '毛里求斯 1810年国旗' },
      { countryCode: 'mu', year: 1906, imagePath: 'flag_history_mu_1906', description: '毛里求斯 1906年国旗' },
      { countryCode: 'mu', year: 1923, imagePath: 'flag_history_mu_1923', description: '毛里求斯 1923年国旗' },
      { countryCode: 'mu', year: 1968, imagePath: 'flag_history_mu_1968', description: '毛里求斯 1968年国旗' }
    ]
  },
  {
    countryCode: 'mv',
    history: [
      { countryCode: 'mv', year: 1886, imagePath: 'flag_history_mv_1886', description: '马尔代夫 1886年国旗' },
      { countryCode: 'mv', year: 1926, imagePath: 'flag_history_mv_1926', description: '马尔代夫 1926年国旗' },
      { countryCode: 'mv', year: 1953, imagePath: 'flag_history_mv_1953', description: '马尔代夫 1953年国旗' },
      { countryCode: 'mv', year: 1965, imagePath: 'flag_history_mv_1965', description: '马尔代夫 1965年国旗' }
    ]
  },
  {
    countryCode: 'mw',
    history: [
      { countryCode: 'mw', year: 1907, imagePath: 'flag_history_mw_1907', description: '马拉维 1907年国旗' },
      { countryCode: 'mw', year: 1953, imagePath: 'flag_history_mw_1953', description: '马拉维 1953年国旗' },
      { countryCode: 'mw', year: 1963, imagePath: 'flag_history_mw_1963', description: '马拉维 1963年国旗' },
      { countryCode: 'mw', year: 1964, imagePath: 'flag_history_mw_1964', description: '马拉维 1964年国旗' },
      { countryCode: 'mw', year: 2010, imagePath: 'flag_history_mw_2010', description: '马拉维 2010年国旗' },
      { countryCode: 'mw', year: 2012, imagePath: 'flag_history_mw_2012', description: '马拉维 2012年国旗' }
    ]
  },
  {
    countryCode: 'mx',
    history: [
      { countryCode: 'mx', year: 1519, imagePath: 'flag_history_mx_1519', description: '墨西哥 1519年国旗' },
      { countryCode: 'mx', year: 1821, imagePath: 'flag_history_mx_1821', description: '墨西哥 1821年国旗' },
      { countryCode: 'mx', year: 1823, imagePath: 'flag_history_mx_1823', description: '墨西哥 1823年国旗' },
      { countryCode: 'mx', year: 1864, imagePath: 'flag_history_mx_1864', description: '墨西哥 1864年国旗' },
      { countryCode: 'mx', year: 1867, imagePath: 'flag_history_mx_1867', description: '墨西哥 1867年国旗' },
      { countryCode: 'mx', year: 1893, imagePath: 'flag_history_mx_1893', description: '墨西哥 1893年国旗' },
      { countryCode: 'mx', year: 1916, imagePath: 'flag_history_mx_1916', description: '墨西哥 1916年国旗' },
      { countryCode: 'mx', year: 1934, imagePath: 'flag_history_mx_1934', description: '墨西哥 1934年国旗' },
      { countryCode: 'mx', year: 1968, imagePath: 'flag_history_mx_1968', description: '墨西哥 1968年国旗' }
    ]
  },
  {
    countryCode: 'my',
    history: [
      { countryCode: 'my', year: 1200, imagePath: 'flag_history_my_1200', description: '马来西亚 1200年国旗' },
      { countryCode: 'my', year: 1641, imagePath: 'flag_history_my_1641', description: '马来西亚 1641年国旗' },
      { countryCode: 'my', year: 1795, imagePath: 'flag_history_my_1795', description: '马来西亚 1795年国旗' },
      { countryCode: 'my', year: 1801, imagePath: 'flag_history_my_1801', description: '马来西亚 1801年国旗' },
      { countryCode: 'my', year: 1818, imagePath: 'flag_history_my_1818', description: '马来西亚 1818年国旗' },
      { countryCode: 'my', year: 1824, imagePath: 'flag_history_my_1824', description: '马来西亚 1824年国旗' },
      { countryCode: 'my', year: 1896, imagePath: 'flag_history_my_1896', description: '马来西亚 1896年国旗' },
      { countryCode: 'my', year: 1942, imagePath: 'flag_history_my_1942', description: '马来西亚 1942年国旗' },
      { countryCode: 'my', year: 1945, imagePath: 'flag_history_my_1945', description: '马来西亚 1945年国旗' },
      { countryCode: 'my', year: 1949, imagePath: 'flag_history_my_1949', description: '马来西亚 1949年国旗' },
      { countryCode: 'my', year: 1963, imagePath: 'flag_history_my_1963', description: '马来西亚 1963年国旗' }
    ]
  },
  {
    countryCode: 'mz',
    history: [
      { countryCode: 'mz', year: 1667, imagePath: 'flag_history_mz_1667', description: '莫桑比克 1667年国旗' },
      { countryCode: 'mz', year: 1707, imagePath: 'flag_history_mz_1707', description: '莫桑比克 1707年国旗' },
      { countryCode: 'mz', year: 1750, imagePath: 'flag_history_mz_1750', description: '莫桑比克 1750年国旗' },
      { countryCode: 'mz', year: 1816, imagePath: 'flag_history_mz_1816', description: '莫桑比克 1816年国旗' },
      { countryCode: 'mz', year: 1826, imagePath: 'flag_history_mz_1826', description: '莫桑比克 1826年国旗' },
      { countryCode: 'mz', year: 1830, imagePath: 'flag_history_mz_1830', description: '莫桑比克 1830年国旗' },
      { countryCode: 'mz', year: 1911, imagePath: 'flag_history_mz_1911', description: '莫桑比克 1911年国旗' },
      { countryCode: 'mz', year: 1974, imagePath: 'flag_history_mz_1974', description: '莫桑比克 1974年国旗' },
      { countryCode: 'mz', year: 1975, imagePath: 'flag_history_mz_1975', description: '莫桑比克 1975年国旗' },
      { countryCode: 'mz', year: 1983, imagePath: 'flag_history_mz_1983', description: '莫桑比克 1983年国旗' }
    ]
  },
  {
    countryCode: 'na',
    history: [
      { countryCode: 'na', year: 1884, imagePath: 'flag_history_na_1884', description: '纳米比亚 1884年国旗' },
      { countryCode: 'na', year: 1915, imagePath: 'flag_history_na_1915', description: '纳米比亚 1915年国旗' },
      { countryCode: 'na', year: 1928, imagePath: 'flag_history_na_1928', description: '纳米比亚 1928年国旗' },
      { countryCode: 'na', year: 1990, imagePath: 'flag_history_na_1990', description: '纳米比亚 1990年国旗' }
    ]
  },
  {
    countryCode: 'ne',
    history: [
      { countryCode: 'ne', year: 1922, imagePath: 'flag_history_ne_1922', description: '尼日尔 1922年国旗' },
      { countryCode: 'ne', year: 1959, imagePath: 'flag_history_ne_1959', description: '尼日尔 1959年国旗' }
    ]
  },
  {
    countryCode: 'ng',
    history: [
      { countryCode: 'ng', year: 1200, imagePath: 'flag_history_ng_1200', description: '尼日利亚 1200年国旗' },
      { countryCode: 'ng', year: 1886, imagePath: 'flag_history_ng_1886', description: '尼日利亚 1886年国旗' },
      { countryCode: 'ng', year: 1900, imagePath: 'flag_history_ng_1900', description: '尼日利亚 1900年国旗' },
      { countryCode: 'ng', year: 1960, imagePath: 'flag_history_ng_1960', description: '尼日利亚 1960年国旗' }
    ]
  },
  {
    countryCode: 'ni',
    history: [
      { countryCode: 'ni', year: 1000, imagePath: 'flag_history_ni_1000', description: '尼加拉瓜 1000年国旗' },
      { countryCode: 'ni', year: 1524, imagePath: 'flag_history_ni_1524', description: '尼加拉瓜 1524年国旗' },
      { countryCode: 'ni', year: 1821, imagePath: 'flag_history_ni_1821', description: '尼加拉瓜 1821年国旗' },
      { countryCode: 'ni', year: 1823, imagePath: 'flag_history_ni_1823', description: '尼加拉瓜 1823年国旗' },
      { countryCode: 'ni', year: 1825, imagePath: 'flag_history_ni_1825', description: '尼加拉瓜 1825年国旗' },
      { countryCode: 'ni', year: 1839, imagePath: 'flag_history_ni_1839', description: '尼加拉瓜 1839年国旗' },
      { countryCode: 'ni', year: 1858, imagePath: 'flag_history_ni_1858', description: '尼加拉瓜 1858年国旗' },
      { countryCode: 'ni', year: 1889, imagePath: 'flag_history_ni_1889', description: '尼加拉瓜 1889年国旗' },
      { countryCode: 'ni', year: 1893, imagePath: 'flag_history_ni_1893', description: '尼加拉瓜 1893年国旗' },
      { countryCode: 'ni', year: 1896, imagePath: 'flag_history_ni_1896', description: '尼加拉瓜 1896年国旗' },
      { countryCode: 'ni', year: 1908, imagePath: 'flag_history_ni_1908', description: '尼加拉瓜 1908年国旗' }
    ]
  },
  {
    countryCode: 'nl',
    history: [
      { countryCode: 'nl', year: 1581, imagePath: 'flag_history_nl_1581', description: '荷兰 1581年国旗' },
      { countryCode: 'nl', year: 1795, imagePath: 'flag_history_nl_1795', description: '荷兰 1795年国旗' },
      { countryCode: 'nl', year: 1806, imagePath: 'flag_history_nl_1806', description: '荷兰 1806年国旗' },
      { countryCode: 'nl', year: 1810, imagePath: 'flag_history_nl_1810', description: '荷兰 1810年国旗' },
      { countryCode: 'nl', year: 1814, imagePath: 'flag_history_nl_1814', description: '荷兰 1814年国旗' },
      { countryCode: 'nl', year: 1940, imagePath: 'flag_history_nl_1940', description: '荷兰 1940年国旗' },
      { countryCode: 'nl', year: 1944, imagePath: 'flag_history_nl_1944', description: '荷兰 1944年国旗' }
    ]
  },
  {
    countryCode: 'no',
    history: [
      { countryCode: 'no', year: 1536, imagePath: 'flag_history_no_1536', description: '挪威 1536年国旗' },
      { countryCode: 'no', year: 1815, imagePath: 'flag_history_no_1815', description: '挪威 1815年国旗' },
      { countryCode: 'no', year: 1844, imagePath: 'flag_history_no_1844', description: '挪威 1844年国旗' },
      { countryCode: 'no', year: 1899, imagePath: 'flag_history_no_1899', description: '挪威 1899年国旗' },
      { countryCode: 'no', year: 1940, imagePath: 'flag_history_no_1940', description: '挪威 1940年国旗' },
      { countryCode: 'no', year: 1945, imagePath: 'flag_history_no_1945', description: '挪威 1945年国旗' }
    ]
  },
  {
    countryCode: 'np',
    history: [
      { countryCode: 'np', year: 1928, imagePath: 'flag_history_np_1928', description: '尼泊尔 1928年国旗' },
      { countryCode: 'np', year: 1962, imagePath: 'flag_history_np_1962', description: '尼泊尔 1962年国旗' }
    ]
  },
  {
    countryCode: 'nr',
    history: [
      { countryCode: 'nr', year: 1888, imagePath: 'flag_history_nr_1888', description: '瑙鲁 1888年国旗' },
      { countryCode: 'nr', year: 1889, imagePath: 'flag_history_nr_1889', description: '瑙鲁 1889年国旗' },
      { countryCode: 'nr', year: 1914, imagePath: 'flag_history_nr_1914', description: '瑙鲁 1914年国旗' },
      { countryCode: 'nr', year: 1942, imagePath: 'flag_history_nr_1942', description: '瑙鲁 1942年国旗' },
      { countryCode: 'nr', year: 1945, imagePath: 'flag_history_nr_1945', description: '瑙鲁 1945年国旗' },
      { countryCode: 'nr', year: 1968, imagePath: 'flag_history_nr_1968', description: '瑙鲁 1968年国旗' }
    ]
  },
  {
    countryCode: 'nz',
    history: [
      { countryCode: 'nz', year: 1200, imagePath: 'flag_history_nz_1200', description: '新西兰 1200年国旗' },
      { countryCode: 'nz', year: 1834, imagePath: 'flag_history_nz_1834', description: '新西兰 1834年国旗' },
      { countryCode: 'nz', year: 1840, imagePath: 'flag_history_nz_1840', description: '新西兰 1840年国旗' },
      { countryCode: 'nz', year: 1867, imagePath: 'flag_history_nz_1867', description: '新西兰 1867年国旗' },
      { countryCode: 'nz', year: 1902, imagePath: 'flag_history_nz_1902', description: '新西兰 1902年国旗' }
    ]
  },
  {
    countryCode: 'om',
    history: [
      { countryCode: 'om', year: 1856, imagePath: 'flag_history_om_1856', description: '阿曼 1856年国旗' },
      { countryCode: 'om', year: 1970, imagePath: 'flag_history_om_1970', description: '阿曼 1970年国旗' },
      { countryCode: 'om', year: 1995, imagePath: 'flag_history_om_1995', description: '阿曼 1995年国旗' }
    ]
  },
  {
    countryCode: 'pa',
    history: [
      { countryCode: 'pa', year: 1510, imagePath: 'flag_history_pa_1510', description: '巴拿马 1510年国旗' },
      { countryCode: 'pa', year: 1717, imagePath: 'flag_history_pa_1717', description: '巴拿马 1717年国旗' },
      { countryCode: 'pa', year: 1785, imagePath: 'flag_history_pa_1785', description: '巴拿马 1785年国旗' },
      { countryCode: 'pa', year: 1811, imagePath: 'flag_history_pa_1811', description: '巴拿马 1811年国旗' },
      { countryCode: 'pa', year: 1816, imagePath: 'flag_history_pa_1816', description: '巴拿马 1816年国旗' },
      { countryCode: 'pa', year: 1819, imagePath: 'flag_history_pa_1819', description: '巴拿马 1819年国旗' },
      { countryCode: 'pa', year: 1820, imagePath: 'flag_history_pa_1820', description: '巴拿马 1820年国旗' },
      { countryCode: 'pa', year: 1821, imagePath: 'flag_history_pa_1821', description: '巴拿马 1821年国旗' },
      { countryCode: 'pa', year: 1834, imagePath: 'flag_history_pa_1834', description: '巴拿马 1834年国旗' },
      { countryCode: 'pa', year: 1861, imagePath: 'flag_history_pa_1861', description: '巴拿马 1861年国旗' },
      { countryCode: 'pa', year: 1903, imagePath: 'flag_history_pa_1903', description: '巴拿马 1903年国旗' },
      { countryCode: 'pa', year: 1925, imagePath: 'flag_history_pa_1925', description: '巴拿马 1925年国旗' }
    ]
  },
  {
    countryCode: 'pe',
    history: [
      { countryCode: 'pe', year: 1532, imagePath: 'flag_history_pe_1532', description: '秘鲁 1532年国旗' },
      { countryCode: 'pe', year: 1717, imagePath: 'flag_history_pe_1717', description: '秘鲁 1717年国旗' },
      { countryCode: 'pe', year: 1785, imagePath: 'flag_history_pe_1785', description: '秘鲁 1785年国旗' },
      { countryCode: 'pe', year: 1820, imagePath: 'flag_history_pe_1820', description: '秘鲁 1820年国旗' },
      { countryCode: 'pe', year: 1822, imagePath: 'flag_history_pe_1822', description: '秘鲁 1822年国旗' },
      { countryCode: 'pe', year: 1825, imagePath: 'flag_history_pe_1825', description: '秘鲁 1825年国旗' },
      { countryCode: 'pe', year: 1950, imagePath: 'flag_history_pe_1950', description: '秘鲁 1950年国旗' }
    ]
  },
  {
    countryCode: 'pg',
    history: [
      { countryCode: 'pg', year: 1884, imagePath: 'flag_history_pg_1884', description: '巴布亚新几内亚 1884年国旗' },
      { countryCode: 'pg', year: 1906, imagePath: 'flag_history_pg_1906', description: '巴布亚新几内亚 1906年国旗' },
      { countryCode: 'pg', year: 1942, imagePath: 'flag_history_pg_1942', description: '巴布亚新几内亚 1942年国旗' },
      { countryCode: 'pg', year: 1945, imagePath: 'flag_history_pg_1945', description: '巴布亚新几内亚 1945年国旗' },
      { countryCode: 'pg', year: 1949, imagePath: 'flag_history_pg_1949', description: '巴布亚新几内亚 1949年国旗' },
      { countryCode: 'pg', year: 1965, imagePath: 'flag_history_pg_1965', description: '巴布亚新几内亚 1965年国旗' },
      { countryCode: 'pg', year: 1970, imagePath: 'flag_history_pg_1970', description: '巴布亚新几内亚 1970年国旗' },
      { countryCode: 'pg', year: 1971, imagePath: 'flag_history_pg_1971', description: '巴布亚新几内亚 1971年国旗' }
    ]
  },
  {
    countryCode: 'ph',
    history: [
      { countryCode: 'ph', year: 1200, imagePath: 'flag_history_ph_1200', description: '菲律宾 1200年国旗' },
      { countryCode: 'ph', year: 1535, imagePath: 'flag_history_ph_1535', description: '菲律宾 1535年国旗' },
      { countryCode: 'ph', year: 1762, imagePath: 'flag_history_ph_1762', description: '菲律宾 1762年国旗' },
      { countryCode: 'ph', year: 1764, imagePath: 'flag_history_ph_1764', description: '菲律宾 1764年国旗' },
      { countryCode: 'ph', year: 1821, imagePath: 'flag_history_ph_1821', description: '菲律宾 1821年国旗' },
      { countryCode: 'ph', year: 1898, imagePath: 'flag_history_ph_1898', description: '菲律宾 1898年国旗' },
      { countryCode: 'ph', year: 1901, imagePath: 'flag_history_ph_1901', description: '菲律宾 1901年国旗' },
      { countryCode: 'ph', year: 1908, imagePath: 'flag_history_ph_1908', description: '菲律宾 1908年国旗' },
      { countryCode: 'ph', year: 1912, imagePath: 'flag_history_ph_1912', description: '菲律宾 1912年国旗' },
      { countryCode: 'ph', year: 1919, imagePath: 'flag_history_ph_1919', description: '菲律宾 1919年国旗' },
      { countryCode: 'ph', year: 1942, imagePath: 'flag_history_ph_1942', description: '菲律宾 1942年国旗' },
      { countryCode: 'ph', year: 1943, imagePath: 'flag_history_ph_1943', description: '菲律宾 1943年国旗' },
      { countryCode: 'ph', year: 1945, imagePath: 'flag_history_ph_1945', description: '菲律宾 1945年国旗' },
      { countryCode: 'ph', year: 1981, imagePath: 'flag_history_ph_1981', description: '菲律宾 1981年国旗' },
      { countryCode: 'ph', year: 1986, imagePath: 'flag_history_ph_1986', description: '菲律宾 1986年国旗' },
      { countryCode: 'ph', year: 1998, imagePath: 'flag_history_ph_1998', description: '菲律宾 1998年国旗' }
    ]
  },
  {
    countryCode: 'pk',
    history: [
      { countryCode: 'pk', year: 1526, imagePath: 'flag_history_pk_1526', description: '巴基斯坦 1526年国旗' },
      { countryCode: 'pk', year: 1747, imagePath: 'flag_history_pk_1747', description: '巴基斯坦 1747年国旗' },
      { countryCode: 'pk', year: 1761, imagePath: 'flag_history_pk_1761', description: '巴基斯坦 1761年国旗' },
      { countryCode: 'pk', year: 1849, imagePath: 'flag_history_pk_1849', description: '巴基斯坦 1849年国旗' },
      { countryCode: 'pk', year: 1858, imagePath: 'flag_history_pk_1858', description: '巴基斯坦 1858年国旗' },
      { countryCode: 'pk', year: 1880, imagePath: 'flag_history_pk_1880', description: '巴基斯坦 1880年国旗' },
      { countryCode: 'pk', year: 1947, imagePath: 'flag_history_pk_1947', description: '巴基斯坦 1947年国旗' }
    ]
  },
  {
    countryCode: 'pl',
    history: [
      { countryCode: 'pl', year: 1225, imagePath: 'flag_history_pl_1225', description: '波兰 1225年国旗' },
      { countryCode: 'pl', year: 1587, imagePath: 'flag_history_pl_1587', description: '波兰 1587年国旗' },
      { countryCode: 'pl', year: 1795, imagePath: 'flag_history_pl_1795', description: '波兰 1795年国旗' },
      { countryCode: 'pl', year: 1807, imagePath: 'flag_history_pl_1807', description: '波兰 1807年国旗' },
      { countryCode: 'pl', year: 1815, imagePath: 'flag_history_pl_1815', description: '波兰 1815年国旗' },
      { countryCode: 'pl', year: 1919, imagePath: 'flag_history_pl_1919', description: '波兰 1919年国旗' },
      { countryCode: 'pl', year: 1939, imagePath: 'flag_history_pl_1939', description: '波兰 1939年国旗' },
      { countryCode: 'pl', year: 1944, imagePath: 'flag_history_pl_1944', description: '波兰 1944年国旗' }
    ]
  },
  {
    countryCode: 'pt',
    history: [
      { countryCode: 'pt', year: 1667, imagePath: 'flag_history_pt_1667', description: '葡萄牙 1667年国旗' },
      { countryCode: 'pt', year: 1707, imagePath: 'flag_history_pt_1707', description: '葡萄牙 1707年国旗' },
      { countryCode: 'pt', year: 1750, imagePath: 'flag_history_pt_1750', description: '葡萄牙 1750年国旗' },
      { countryCode: 'pt', year: 1816, imagePath: 'flag_history_pt_1816', description: '葡萄牙 1816年国旗' },
      { countryCode: 'pt', year: 1826, imagePath: 'flag_history_pt_1826', description: '葡萄牙 1826年国旗' },
      { countryCode: 'pt', year: 1830, imagePath: 'flag_history_pt_1830', description: '葡萄牙 1830年国旗' },
      { countryCode: 'pt', year: 1911, imagePath: 'flag_history_pt_1911', description: '葡萄牙 1911年国旗' }
    ]
  },
  {
    countryCode: 'pw',
    history: [
      { countryCode: 'pw', year: 1885, imagePath: 'flag_history_pw_1885', description: '帕劳 1885年国旗' },
      { countryCode: 'pw', year: 1899, imagePath: 'flag_history_pw_1899', description: '帕劳 1899年国旗' },
      { countryCode: 'pw', year: 1914, imagePath: 'flag_history_pw_1914', description: '帕劳 1914年国旗' },
      { countryCode: 'pw', year: 1944, imagePath: 'flag_history_pw_1944', description: '帕劳 1944年国旗' },
      { countryCode: 'pw', year: 1947, imagePath: 'flag_history_pw_1947', description: '帕劳 1947年国旗' },
      { countryCode: 'pw', year: 1965, imagePath: 'flag_history_pw_1965', description: '帕劳 1965年国旗' },
      { countryCode: 'pw', year: 1981, imagePath: 'flag_history_pw_1981', description: '帕劳 1981年国旗' }
    ]
  },
  {
    countryCode: 'py',
    history: [
      { countryCode: 'py', year: 1200, imagePath: 'flag_history_py_1200', description: '巴拉圭 1200年国旗' },
      { countryCode: 'py', year: 1537, imagePath: 'flag_history_py_1537', description: '巴拉圭 1537年国旗' },
      { countryCode: 'py', year: 1717, imagePath: 'flag_history_py_1717', description: '巴拉圭 1717年国旗' },
      { countryCode: 'py', year: 1785, imagePath: 'flag_history_py_1785', description: '巴拉圭 1785年国旗' },
      { countryCode: 'py', year: 1811, imagePath: 'flag_history_py_1811', description: '巴拉圭 1811年国旗' },
      { countryCode: 'py', year: 1812, imagePath: 'flag_history_py_1812', description: '巴拉圭 1812年国旗' },
      { countryCode: 'py', year: 1826, imagePath: 'flag_history_py_1826', description: '巴拉圭 1826年国旗' },
      { countryCode: 'py', year: 1842, imagePath: 'flag_history_py_1842', description: '巴拉圭 1842年国旗' },
      { countryCode: 'py', year: 1954, imagePath: 'flag_history_py_1954', description: '巴拉圭 1954年国旗' },
      { countryCode: 'py', year: 1988, imagePath: 'flag_history_py_1988', description: '巴拉圭 1988年国旗' },
      { countryCode: 'py', year: 1990, imagePath: 'flag_history_py_1990', description: '巴拉圭 1990年国旗' },
      { countryCode: 'py', year: 2013, imagePath: 'flag_history_py_2013', description: '巴拉圭 2013年国旗' }
    ]
  },
  {
    countryCode: 'qa',
    history: [
      { countryCode: 'qa', year: 1400, imagePath: 'flag_history_qa_1400', description: '卡塔尔 1400年国旗' },
      { countryCode: 'qa', year: 1818, imagePath: 'flag_history_qa_1818', description: '卡塔尔 1818年国旗' },
      { countryCode: 'qa', year: 1872, imagePath: 'flag_history_qa_1872', description: '卡塔尔 1872年国旗' },
      { countryCode: 'qa', year: 1916, imagePath: 'flag_history_qa_1916', description: '卡塔尔 1916年国旗' },
      { countryCode: 'qa', year: 1936, imagePath: 'flag_history_qa_1936', description: '卡塔尔 1936年国旗' },
      { countryCode: 'qa', year: 1949, imagePath: 'flag_history_qa_1949', description: '卡塔尔 1949年国旗' },
      { countryCode: 'qa', year: 1971, imagePath: 'flag_history_qa_1971', description: '卡塔尔 1971年国旗' }
    ]
  },
  {
    countryCode: 'ro',
    history: [
      { countryCode: 'ro', year: 1859, imagePath: 'flag_history_ro_1859', description: '罗马尼亚 1859年国旗' },
      { countryCode: 'ro', year: 1862, imagePath: 'flag_history_ro_1862', description: '罗马尼亚 1862年国旗' },
      { countryCode: 'ro', year: 1867, imagePath: 'flag_history_ro_1867', description: '罗马尼亚 1867年国旗' },
      { countryCode: 'ro', year: 1948, imagePath: 'flag_history_ro_1948', description: '罗马尼亚 1948年国旗' },
      { countryCode: 'ro', year: 1952, imagePath: 'flag_history_ro_1952', description: '罗马尼亚 1952年国旗' },
      { countryCode: 'ro', year: 1965, imagePath: 'flag_history_ro_1965', description: '罗马尼亚 1965年国旗' },
      { countryCode: 'ro', year: 1989, imagePath: 'flag_history_ro_1989', description: '罗马尼亚 1989年国旗' }
    ]
  },
  {
    countryCode: 'rs',
    history: [
      { countryCode: 'rs', year: 1350, imagePath: 'flag_history_rs_1350', description: '塞尔维亚 1350年国旗' },
      { countryCode: 'rs', year: 1453, imagePath: 'flag_history_rs_1453', description: '塞尔维亚 1453年国旗' },
      { countryCode: 'rs', year: 1835, imagePath: 'flag_history_rs_1835', description: '塞尔维亚 1835年国旗' },
      { countryCode: 'rs', year: 1918, imagePath: 'flag_history_rs_1918', description: '塞尔维亚 1918年国旗' },
      { countryCode: 'rs', year: 1943, imagePath: 'flag_history_rs_1943', description: '塞尔维亚 1943年国旗' },
      { countryCode: 'rs', year: 1992, imagePath: 'flag_history_rs_1992', description: '塞尔维亚 1992年国旗' },
      { countryCode: 'rs', year: 2004, imagePath: 'flag_history_rs_2004', description: '塞尔维亚 2004年国旗' },
      { countryCode: 'rs', year: 2010, imagePath: 'flag_history_rs_2010', description: '塞尔维亚 2010年国旗' }
    ]
  },
  {
    countryCode: 'ru',
    history: [
      { countryCode: 'ru', year: 1699, imagePath: 'flag_history_ru_1699', description: '俄罗斯 1699年国旗' },
      { countryCode: 'ru', year: 1858, imagePath: 'flag_history_ru_1858', description: '俄罗斯 1858年国旗' },
      { countryCode: 'ru', year: 1883, imagePath: 'flag_history_ru_1883', description: '俄罗斯 1883年国旗' },
      { countryCode: 'ru', year: 1918, imagePath: 'flag_history_ru_1918', description: '俄罗斯 1918年国旗' },
      { countryCode: 'ru', year: 1937, imagePath: 'flag_history_ru_1937', description: '俄罗斯 1937年国旗' },
      { countryCode: 'ru', year: 1954, imagePath: 'flag_history_ru_1954', description: '俄罗斯 1954年国旗' },
      { countryCode: 'ru', year: 1991, imagePath: 'flag_history_ru_1991', description: '俄罗斯 1991年国旗' },
      { countryCode: 'ru', year: 1993, imagePath: 'flag_history_ru_1993', description: '俄罗斯 1993年国旗' }
    ]
  },
  {
    countryCode: 'rw',
    history: [
      { countryCode: 'rw', year: 1885, imagePath: 'flag_history_rw_1885', description: '卢旺达 1885年国旗' },
      { countryCode: 'rw', year: 1919, imagePath: 'flag_history_rw_1919', description: '卢旺达 1919年国旗' },
      { countryCode: 'rw', year: 1959, imagePath: 'flag_history_rw_1959', description: '卢旺达 1959年国旗' },
      { countryCode: 'rw', year: 1961, imagePath: 'flag_history_rw_1961', description: '卢旺达 1961年国旗' },
      { countryCode: 'rw', year: 1962, imagePath: 'flag_history_rw_1962', description: '卢旺达 1962年国旗' },
      { countryCode: 'rw', year: 2001, imagePath: 'flag_history_rw_2001', description: '卢旺达 2001年国旗' }
    ]
  },
  {
    countryCode: 'sa',
    history: [
      { countryCode: 'sa', year: 1517, imagePath: 'flag_history_sa_1517', description: '沙特阿拉伯 1517年国旗' },
      { countryCode: 'sa', year: 1744, imagePath: 'flag_history_sa_1744', description: '沙特阿拉伯 1744年国旗' },
      { countryCode: 'sa', year: 1818, imagePath: 'flag_history_sa_1818', description: '沙特阿拉伯 1818年国旗' },
      { countryCode: 'sa', year: 1824, imagePath: 'flag_history_sa_1824', description: '沙特阿拉伯 1824年国旗' },
      { countryCode: 'sa', year: 1891, imagePath: 'flag_history_sa_1891', description: '沙特阿拉伯 1891年国旗' },
      { countryCode: 'sa', year: 1902, imagePath: 'flag_history_sa_1902', description: '沙特阿拉伯 1902年国旗' },
      { countryCode: 'sa', year: 1926, imagePath: 'flag_history_sa_1926', description: '沙特阿拉伯 1926年国旗' },
      { countryCode: 'sa', year: 1932, imagePath: 'flag_history_sa_1932', description: '沙特阿拉伯 1932年国旗' },
      { countryCode: 'sa', year: 1934, imagePath: 'flag_history_sa_1934', description: '沙特阿拉伯 1934年国旗' },
      { countryCode: 'sa', year: 1938, imagePath: 'flag_history_sa_1938', description: '沙特阿拉伯 1938年国旗' },
      { countryCode: 'sa', year: 1973, imagePath: 'flag_history_sa_1973', description: '沙特阿拉伯 1973年国旗' }
    ]
  },
  {
    countryCode: 'sb',
    history: [
      { countryCode: 'sb', year: 1200, imagePath: 'flag_history_sb_1200', description: '所罗门群岛 1200年国旗' },
      { countryCode: 'sb', year: 1886, imagePath: 'flag_history_sb_1886', description: '所罗门群岛 1886年国旗' },
      { countryCode: 'sb', year: 1942, imagePath: 'flag_history_sb_1942', description: '所罗门群岛 1942年国旗' },
      { countryCode: 'sb', year: 1945, imagePath: 'flag_history_sb_1945', description: '所罗门群岛 1945年国旗' },
      { countryCode: 'sb', year: 1977, imagePath: 'flag_history_sb_1977', description: '所罗门群岛 1977年国旗' }
    ]
  },
  {
    countryCode: 'sc',
    history: [
      { countryCode: 'sc', year: 1200, imagePath: 'flag_history_sc_1200', description: '塞舌尔 1200年国旗' },
      { countryCode: 'sc', year: 1756, imagePath: 'flag_history_sc_1756', description: '塞舌尔 1756年国旗' },
      { countryCode: 'sc', year: 1811, imagePath: 'flag_history_sc_1811', description: '塞舌尔 1811年国旗' },
      { countryCode: 'sc', year: 1976, imagePath: 'flag_history_sc_1976', description: '塞舌尔 1976年国旗' },
      { countryCode: 'sc', year: 1977, imagePath: 'flag_history_sc_1977', description: '塞舌尔 1977年国旗' },
      { countryCode: 'sc', year: 1996, imagePath: 'flag_history_sc_1996', description: '塞舌尔 1996年国旗' }
    ]
  },
  {
    countryCode: 'sd',
    history: [
      { countryCode: 'sd', year: 1200, imagePath: 'flag_history_sd_1200', description: '苏丹 1200年国旗' }
    ]
  },
  {
    countryCode: 'se',
    history: [
      { countryCode: 'se', year: 1562, imagePath: 'flag_history_se_1562', description: '瑞典 1562年国旗' },
      { countryCode: 'se', year: 1600, imagePath: 'flag_history_se_1600', description: '瑞典 1600年国旗' },
      { countryCode: 'se', year: 1815, imagePath: 'flag_history_se_1815', description: '瑞典 1815年国旗' },
      { countryCode: 'se', year: 1844, imagePath: 'flag_history_se_1844', description: '瑞典 1844年国旗' },
      { countryCode: 'se', year: 1906, imagePath: 'flag_history_se_1906', description: '瑞典 1906年国旗' }
    ]
  },
  {
    countryCode: 'sg',
    history: [
      { countryCode: 'sg', year: 1819, imagePath: 'flag_history_sg_1819', description: '新加坡 1819年国旗' },
      { countryCode: 'sg', year: 1874, imagePath: 'flag_history_sg_1874', description: '新加坡 1874年国旗' },
      { countryCode: 'sg', year: 1942, imagePath: 'flag_history_sg_1942', description: '新加坡 1942年国旗' },
      { countryCode: 'sg', year: 1945, imagePath: 'flag_history_sg_1945', description: '新加坡 1945年国旗' },
      { countryCode: 'sg', year: 1946, imagePath: 'flag_history_sg_1946', description: '新加坡 1946年国旗' },
      { countryCode: 'sg', year: 1959, imagePath: 'flag_history_sg_1959', description: '新加坡 1959年国旗' },
      { countryCode: 'sg', year: 1963, imagePath: 'flag_history_sg_1963', description: '新加坡 1963年国旗' },
      { countryCode: 'sg', year: 1965, imagePath: 'flag_history_sg_1965', description: '新加坡 1965年国旗' }
    ]
  },
  {
    countryCode: 'si',
    history: [
      { countryCode: 'si', year: 1200, imagePath: 'flag_history_si_1200', description: '斯洛文尼亚 1200年国旗' },
      { countryCode: 'si', year: 1848, imagePath: 'flag_history_si_1848', description: '斯洛文尼亚 1848年国旗' },
      { countryCode: 'si', year: 1868, imagePath: 'flag_history_si_1868', description: '斯洛文尼亚 1868年国旗' },
      { countryCode: 'si', year: 1918, imagePath: 'flag_history_si_1918', description: '斯洛文尼亚 1918年国旗' },
      { countryCode: 'si', year: 1943, imagePath: 'flag_history_si_1943', description: '斯洛文尼亚 1943年国旗' },
      { countryCode: 'si', year: 1945, imagePath: 'flag_history_si_1945', description: '斯洛文尼亚 1945年国旗' },
      { countryCode: 'si', year: 1991, imagePath: 'flag_history_si_1991', description: '斯洛文尼亚 1991年国旗' }
    ]
  },
  {
    countryCode: 'sk',
    history: [
      { countryCode: 'sk', year: 1804, imagePath: 'flag_history_sk_1804', description: '斯洛伐克 1804年国旗' },
      { countryCode: 'sk', year: 1869, imagePath: 'flag_history_sk_1869', description: '斯洛伐克 1869年国旗' },
      { countryCode: 'sk', year: 1918, imagePath: 'flag_history_sk_1918', description: '斯洛伐克 1918年国旗' },
      { countryCode: 'sk', year: 1920, imagePath: 'flag_history_sk_1920', description: '斯洛伐克 1920年国旗' },
      { countryCode: 'sk', year: 1938, imagePath: 'flag_history_sk_1938', description: '斯洛伐克 1938年国旗' },
      { countryCode: 'sk', year: 1945, imagePath: 'flag_history_sk_1945', description: '斯洛伐克 1945年国旗' },
      { countryCode: 'sk', year: 1992, imagePath: 'flag_history_sk_1992', description: '斯洛伐克 1992年国旗' }
    ]
  },
  {
    countryCode: 'sl',
    history: [
      { countryCode: 'sl', year: 1792, imagePath: 'flag_history_sl_1792', description: '塞拉利昂 1792年国旗' },
      { countryCode: 'sl', year: 1801, imagePath: 'flag_history_sl_1801', description: '塞拉利昂 1801年国旗' },
      { countryCode: 'sl', year: 1961, imagePath: 'flag_history_sl_1961', description: '塞拉利昂 1961年国旗' }
    ]
  },
  {
    countryCode: 'sm',
    history: [
      { countryCode: 'sm', year: 1465, imagePath: 'flag_history_sm_1465', description: '圣马力诺 1465年国旗' },
      { countryCode: 'sm', year: 1862, imagePath: 'flag_history_sm_1862', description: '圣马力诺 1862年国旗' },
      { countryCode: 'sm', year: 2011, imagePath: 'flag_history_sm_2011', description: '圣马力诺 2011年国旗' }
    ]
  },
  {
    countryCode: 'sn',
    history: [
      { countryCode: 'sn', year: 1595, imagePath: 'flag_history_sn_1595', description: '塞内加尔 1595年国旗' },
      { countryCode: 'sn', year: 1789, imagePath: 'flag_history_sn_1789', description: '塞内加尔 1789年国旗' },
      { countryCode: 'sn', year: 1814, imagePath: 'flag_history_sn_1814', description: '塞内加尔 1814年国旗' },
      { countryCode: 'sn', year: 1830, imagePath: 'flag_history_sn_1830', description: '塞内加尔 1830年国旗' },
      { countryCode: 'sn', year: 1958, imagePath: 'flag_history_sn_1958', description: '塞内加尔 1958年国旗' },
      { countryCode: 'sn', year: 1959, imagePath: 'flag_history_sn_1959', description: '塞内加尔 1959年国旗' },
      { countryCode: 'sn', year: 1960, imagePath: 'flag_history_sn_1960', description: '塞内加尔 1960年国旗' }
    ]
  },
  {
    countryCode: 'so',
    history: [
      { countryCode: 'so', year: 1888, imagePath: 'flag_history_so_1888', description: '索马里 1888年国旗' },
      { countryCode: 'so', year: 1941, imagePath: 'flag_history_so_1941', description: '索马里 1941年国旗' },
      { countryCode: 'so', year: 1950, imagePath: 'flag_history_so_1950', description: '索马里 1950年国旗' },
      { countryCode: 'so', year: 1960, imagePath: 'flag_history_so_1960', description: '索马里 1960年国旗' }
    ]
  },
  {
    countryCode: 'sr',
    history: [
      { countryCode: 'sr', year: 1581, imagePath: 'flag_history_sr_1581', description: '苏里南 1581年国旗' },
      { countryCode: 'sr', year: 1795, imagePath: 'flag_history_sr_1795', description: '苏里南 1795年国旗' },
      { countryCode: 'sr', year: 1806, imagePath: 'flag_history_sr_1806', description: '苏里南 1806年国旗' },
      { countryCode: 'sr', year: 1810, imagePath: 'flag_history_sr_1810', description: '苏里南 1810年国旗' },
      { countryCode: 'sr', year: 1814, imagePath: 'flag_history_sr_1814', description: '苏里南 1814年国旗' },
      { countryCode: 'sr', year: 1959, imagePath: 'flag_history_sr_1959', description: '苏里南 1959年国旗' },
      { countryCode: 'sr', year: 1975, imagePath: 'flag_history_sr_1975', description: '苏里南 1975年国旗' }
    ]
  },
  {
    countryCode: 'ss',
    history: [
      { countryCode: 'ss', year: 1140, imagePath: 'flag_history_ss_1140', description: '南苏丹 1140年国旗' },
      { countryCode: 'ss', year: 1517, imagePath: 'flag_history_ss_1517', description: '南苏丹 1517年国旗' },
      { countryCode: 'ss', year: 1844, imagePath: 'flag_history_ss_1844', description: '南苏丹 1844年国旗' },
      { countryCode: 'ss', year: 1882, imagePath: 'flag_history_ss_1882', description: '南苏丹 1882年国旗' },
      { countryCode: 'ss', year: 1899, imagePath: 'flag_history_ss_1899', description: '南苏丹 1899年国旗' },
      { countryCode: 'ss', year: 1922, imagePath: 'flag_history_ss_1922', description: '南苏丹 1922年国旗' },
      { countryCode: 'ss', year: 1952, imagePath: 'flag_history_ss_1952', description: '南苏丹 1952年国旗' },
      { countryCode: 'ss', year: 1956, imagePath: 'flag_history_ss_1956', description: '南苏丹 1956年国旗' },
      { countryCode: 'ss', year: 1970, imagePath: 'flag_history_ss_1970', description: '南苏丹 1970年国旗' },
      { countryCode: 'ss', year: 2011, imagePath: 'flag_history_ss_2011', description: '南苏丹 2011年国旗' }
    ]
  },
  {
    countryCode: 'st',
    history: [
      { countryCode: 'st', year: 1200, imagePath: 'flag_history_st_1200', description: '圣多美和普林西比 1200年国旗' },
      { countryCode: 'st', year: 1667, imagePath: 'flag_history_st_1667', description: '圣多美和普林西比 1667年国旗' },
      { countryCode: 'st', year: 1707, imagePath: 'flag_history_st_1707', description: '圣多美和普林西比 1707年国旗' },
      { countryCode: 'st', year: 1750, imagePath: 'flag_history_st_1750', description: '圣多美和普林西比 1750年国旗' },
      { countryCode: 'st', year: 1816, imagePath: 'flag_history_st_1816', description: '圣多美和普林西比 1816年国旗' },
      { countryCode: 'st', year: 1826, imagePath: 'flag_history_st_1826', description: '圣多美和普林西比 1826年国旗' },
      { countryCode: 'st', year: 1830, imagePath: 'flag_history_st_1830', description: '圣多美和普林西比 1830年国旗' },
      { countryCode: 'st', year: 1911, imagePath: 'flag_history_st_1911', description: '圣多美和普林西比 1911年国旗' },
      { countryCode: 'st', year: 1975, imagePath: 'flag_history_st_1975', description: '圣多美和普林西比 1975年国旗' }
    ]
  },
  {
    countryCode: 'sv',
    history: [
      { countryCode: 'sv', year: 1005, imagePath: 'flag_history_sv_1005', description: '萨尔瓦多 1005年国旗' },
      { countryCode: 'sv', year: 1519, imagePath: 'flag_history_sv_1519', description: '萨尔瓦多 1519年国旗' },
      { countryCode: 'sv', year: 1821, imagePath: 'flag_history_sv_1821', description: '萨尔瓦多 1821年国旗' },
      { countryCode: 'sv', year: 1823, imagePath: 'flag_history_sv_1823', description: '萨尔瓦多 1823年国旗' },
      { countryCode: 'sv', year: 1825, imagePath: 'flag_history_sv_1825', description: '萨尔瓦多 1825年国旗' },
      { countryCode: 'sv', year: 1839, imagePath: 'flag_history_sv_1839', description: '萨尔瓦多 1839年国旗' },
      { countryCode: 'sv', year: 1865, imagePath: 'flag_history_sv_1865', description: '萨尔瓦多 1865年国旗' },
      { countryCode: 'sv', year: 1875, imagePath: 'flag_history_sv_1875', description: '萨尔瓦多 1875年国旗' },
      { countryCode: 'sv', year: 1898, imagePath: 'flag_history_sv_1898', description: '萨尔瓦多 1898年国旗' },
      { countryCode: 'sv', year: 1912, imagePath: 'flag_history_sv_1912', description: '萨尔瓦多 1912年国旗' }
    ]
  },
  {
    countryCode: 'sy',
    history: [
      { countryCode: 'sy', year: 1453, imagePath: 'flag_history_sy_1453', description: '叙利亚 1453年国旗' },
      { countryCode: 'sy', year: 1844, imagePath: 'flag_history_sy_1844', description: '叙利亚 1844年国旗' },
      { countryCode: 'sy', year: 1920, imagePath: 'flag_history_sy_1920', description: '叙利亚 1920年国旗' },
      { countryCode: 'sy', year: 1922, imagePath: 'flag_history_sy_1922', description: '叙利亚 1922年国旗' },
      { countryCode: 'sy', year: 1932, imagePath: 'flag_history_sy_1932', description: '叙利亚 1932年国旗' },
      { countryCode: 'sy', year: 1958, imagePath: 'flag_history_sy_1958', description: '叙利亚 1958年国旗' },
      { countryCode: 'sy', year: 1961, imagePath: 'flag_history_sy_1961', description: '叙利亚 1961年国旗' },
      { countryCode: 'sy', year: 1963, imagePath: 'flag_history_sy_1963', description: '叙利亚 1963年国旗' },
      { countryCode: 'sy', year: 1972, imagePath: 'flag_history_sy_1972', description: '叙利亚 1972年国旗' },
      { countryCode: 'sy', year: 1980, imagePath: 'flag_history_sy_1980', description: '叙利亚 1980年国旗' },
      { countryCode: 'sy', year: 2025, imagePath: 'flag_history_sy_2025', description: '叙利亚 2025年国旗' }
    ]
  },
  {
    countryCode: 'sz',
    history: [
      { countryCode: 'sz', year: 1894, imagePath: 'flag_history_sz_1894', description: '斯威士兰 1894年国旗' },
      { countryCode: 'sz', year: 1903, imagePath: 'flag_history_sz_1903', description: '斯威士兰 1903年国旗' },
      { countryCode: 'sz', year: 1968, imagePath: 'flag_history_sz_1968', description: '斯威士兰 1968年国旗' }
    ]
  },
  {
    countryCode: 'td',
    history: [
      { countryCode: 'td', year: 1900, imagePath: 'flag_history_td_1900', description: '乍得 1900年国旗' },
      { countryCode: 'td', year: 1959, imagePath: 'flag_history_td_1959', description: '乍得 1959年国旗' }
    ]
  },
  {
    countryCode: 'tg',
    history: [
      { countryCode: 'tg', year: 1884, imagePath: 'flag_history_tg_1884', description: '多哥 1884年国旗' },
      { countryCode: 'tg', year: 1914, imagePath: 'flag_history_tg_1914', description: '多哥 1914年国旗' },
      { countryCode: 'tg', year: 1957, imagePath: 'flag_history_tg_1957', description: '多哥 1957年国旗' },
      { countryCode: 'tg', year: 1958, imagePath: 'flag_history_tg_1958', description: '多哥 1958年国旗' },
      { countryCode: 'tg', year: 1960, imagePath: 'flag_history_tg_1960', description: '多哥 1960年国旗' }
    ]
  },
  {
    countryCode: 'th',
    history: [
      { countryCode: 'th', year: 1700, imagePath: 'flag_history_th_1700', description: '泰国 1700年国旗' },
      { countryCode: 'th', year: 1782, imagePath: 'flag_history_th_1782', description: '泰国 1782年国旗' },
      { countryCode: 'th', year: 1817, imagePath: 'flag_history_th_1817', description: '泰国 1817年国旗' },
      { countryCode: 'th', year: 1855, imagePath: 'flag_history_th_1855', description: '泰国 1855年国旗' },
      { countryCode: 'th', year: 1916, imagePath: 'flag_history_th_1916', description: '泰国 1916年国旗' },
      { countryCode: 'th', year: 1917, imagePath: 'flag_history_th_1917', description: '泰国 1917年国旗' }
    ]
  },
  {
    countryCode: 'tj',
    history: [
      { countryCode: 'tj', year: 1699, imagePath: 'flag_history_tj_1699', description: '塔吉克斯坦 1699年国旗' },
      { countryCode: 'tj', year: 1858, imagePath: 'flag_history_tj_1858', description: '塔吉克斯坦 1858年国旗' },
      { countryCode: 'tj', year: 1883, imagePath: 'flag_history_tj_1883', description: '塔吉克斯坦 1883年国旗' },
      { countryCode: 'tj', year: 1918, imagePath: 'flag_history_tj_1918', description: '塔吉克斯坦 1918年国旗' },
      { countryCode: 'tj', year: 1924, imagePath: 'flag_history_tj_1924', description: '塔吉克斯坦 1924年国旗' },
      { countryCode: 'tj', year: 1953, imagePath: 'flag_history_tj_1953', description: '塔吉克斯坦 1953年国旗' },
      { countryCode: 'tj', year: 1992, imagePath: 'flag_history_tj_1992', description: '塔吉克斯坦 1992年国旗' }
    ]
  },
  {
    countryCode: 'tl',
    history: [
      { countryCode: 'tl', year: 1200, imagePath: 'flag_history_tl_1200', description: '东帝汶 1200年国旗' },
      { countryCode: 'tl', year: 1702, imagePath: 'flag_history_tl_1702', description: '东帝汶 1702年国旗' },
      { countryCode: 'tl', year: 1707, imagePath: 'flag_history_tl_1707', description: '东帝汶 1707年国旗' },
      { countryCode: 'tl', year: 1750, imagePath: 'flag_history_tl_1750', description: '东帝汶 1750年国旗' },
      { countryCode: 'tl', year: 1816, imagePath: 'flag_history_tl_1816', description: '东帝汶 1816年国旗' },
      { countryCode: 'tl', year: 1826, imagePath: 'flag_history_tl_1826', description: '东帝汶 1826年国旗' },
      { countryCode: 'tl', year: 1830, imagePath: 'flag_history_tl_1830', description: '东帝汶 1830年国旗' },
      { countryCode: 'tl', year: 1911, imagePath: 'flag_history_tl_1911', description: '东帝汶 1911年国旗' },
      { countryCode: 'tl', year: 1975, imagePath: 'flag_history_tl_1975', description: '东帝汶 1975年国旗' },
      { countryCode: 'tl', year: 1999, imagePath: 'flag_history_tl_1999', description: '东帝汶 1999年国旗' },
      { countryCode: 'tl', year: 2002, imagePath: 'flag_history_tl_2002', description: '东帝汶 2002年国旗' }
    ]
  },
  {
    countryCode: 'tm',
    history: [
      { countryCode: 'tm', year: 1517, imagePath: 'flag_history_tm_1517', description: '土库曼斯坦 1517年国旗' },
      { countryCode: 'tm', year: 1917, imagePath: 'flag_history_tm_1917', description: '土库曼斯坦 1917年国旗' },
      { countryCode: 'tm', year: 1922, imagePath: 'flag_history_tm_1922', description: '土库曼斯坦 1922年国旗' },
      { countryCode: 'tm', year: 1953, imagePath: 'flag_history_tm_1953', description: '土库曼斯坦 1953年国旗' },
      { countryCode: 'tm', year: 1992, imagePath: 'flag_history_tm_1992', description: '土库曼斯坦 1992年国旗' },
      { countryCode: 'tm', year: 1997, imagePath: 'flag_history_tm_1997', description: '土库曼斯坦 1997年国旗' },
      { countryCode: 'tm', year: 2001, imagePath: 'flag_history_tm_2001', description: '土库曼斯坦 2001年国旗' }
    ]
  },
  {
    countryCode: 'tn',
    history: [
      { countryCode: 'tn', year: 1200, imagePath: 'flag_history_tn_1200', description: '突尼斯 1200年国旗' },
      { countryCode: 'tn', year: 1574, imagePath: 'flag_history_tn_1574', description: '突尼斯 1574年国旗' },
      { countryCode: 'tn', year: 1831, imagePath: 'flag_history_tn_1831', description: '突尼斯 1831年国旗' },
      { countryCode: 'tn', year: 1999, imagePath: 'flag_history_tn_1999', description: '突尼斯 1999年国旗' }
    ]
  },
  {
    countryCode: 'to',
    history: [
      { countryCode: 'to', year: 1884, imagePath: 'flag_history_to_1884', description: '汤加 1884年国旗' }
    ]
  },
  {
    countryCode: 'tr',
    history: [
      { countryCode: 'tr', year: 1200, imagePath: 'flag_history_tr_1200', description: '土耳其 1200年国旗' },
      { countryCode: 'tr', year: 1453, imagePath: 'flag_history_tr_1453', description: '土耳其 1453年国旗' },
      { countryCode: 'tr', year: 1844, imagePath: 'flag_history_tr_1844', description: '土耳其 1844年国旗' },
      { countryCode: 'tr', year: 1936, imagePath: 'flag_history_tr_1936', description: '土耳其 1936年国旗' }
    ]
  },
  {
    countryCode: 'tt',
    history: [
      { countryCode: 'tt', year: 1498, imagePath: 'flag_history_tt_1498', description: '特立尼达和多巴哥 1498年国旗' },
      { countryCode: 'tt', year: 1796, imagePath: 'flag_history_tt_1796', description: '特立尼达和多巴哥 1796年国旗' },
      { countryCode: 'tt', year: 1801, imagePath: 'flag_history_tt_1801', description: '特立尼达和多巴哥 1801年国旗' },
      { countryCode: 'tt', year: 1958, imagePath: 'flag_history_tt_1958', description: '特立尼达和多巴哥 1958年国旗' },
      { countryCode: 'tt', year: 1962, imagePath: 'flag_history_tt_1962', description: '特立尼达和多巴哥 1962年国旗' }
    ]
  },
  {
    countryCode: 'tv',
    history: [
      { countryCode: 'tv', year: 1200, imagePath: 'flag_history_tv_1200', description: '图瓦卢 1200年国旗' },
      { countryCode: 'tv', year: 1892, imagePath: 'flag_history_tv_1892', description: '图瓦卢 1892年国旗' },
      { countryCode: 'tv', year: 1937, imagePath: 'flag_history_tv_1937', description: '图瓦卢 1937年国旗' },
      { countryCode: 'tv', year: 1976, imagePath: 'flag_history_tv_1976', description: '图瓦卢 1976年国旗' },
      { countryCode: 'tv', year: 1978, imagePath: 'flag_history_tv_1978', description: '图瓦卢 1978年国旗' },
      { countryCode: 'tv', year: 1996, imagePath: 'flag_history_tv_1996', description: '图瓦卢 1996年国旗' },
      { countryCode: 'tv', year: 1997, imagePath: 'flag_history_tv_1997', description: '图瓦卢 1997年国旗' }
    ]
  },
  {
    countryCode: 'tz',
    history: [
      { countryCode: 'tz', year: 1885, imagePath: 'flag_history_tz_1885', description: '坦桑尼亚 1885年国旗' },
      { countryCode: 'tz', year: 1919, imagePath: 'flag_history_tz_1919', description: '坦桑尼亚 1919年国旗' },
      { countryCode: 'tz', year: 1961, imagePath: 'flag_history_tz_1961', description: '坦桑尼亚 1961年国旗' },
      { countryCode: 'tz', year: 1964, imagePath: 'flag_history_tz_1964', description: '坦桑尼亚 1964年国旗' }
    ]
  },
  {
    countryCode: 'ua',
    history: [
      { countryCode: 'ua', year: 1200, imagePath: 'flag_history_ua_1200', description: '乌克兰 1200年国旗' },
      { countryCode: 'ua', year: 1793, imagePath: 'flag_history_ua_1793', description: '乌克兰 1793年国旗' },
      { countryCode: 'ua', year: 1858, imagePath: 'flag_history_ua_1858', description: '乌克兰 1858年国旗' },
      { countryCode: 'ua', year: 1883, imagePath: 'flag_history_ua_1883', description: '乌克兰 1883年国旗' },
      { countryCode: 'ua', year: 1917, imagePath: 'flag_history_ua_1917', description: '乌克兰 1917年国旗' },
      { countryCode: 'ua', year: 1919, imagePath: 'flag_history_ua_1919', description: '乌克兰 1919年国旗' },
      { countryCode: 'ua', year: 1929, imagePath: 'flag_history_ua_1929', description: '乌克兰 1929年国旗' },
      { countryCode: 'ua', year: 1937, imagePath: 'flag_history_ua_1937', description: '乌克兰 1937年国旗' },
      { countryCode: 'ua', year: 1941, imagePath: 'flag_history_ua_1941', description: '乌克兰 1941年国旗' },
      { countryCode: 'ua', year: 1944, imagePath: 'flag_history_ua_1944', description: '乌克兰 1944年国旗' },
      { countryCode: 'ua', year: 1949, imagePath: 'flag_history_ua_1949', description: '乌克兰 1949年国旗' },
      { countryCode: 'ua', year: 1991, imagePath: 'flag_history_ua_1991', description: '乌克兰 1991年国旗' }
    ]
  },
  {
    countryCode: 'ug',
    history: [
      { countryCode: 'ug', year: 1894, imagePath: 'flag_history_ug_1894', description: '乌干达 1894年国旗' },
      { countryCode: 'ug', year: 1914, imagePath: 'flag_history_ug_1914', description: '乌干达 1914年国旗' },
      { countryCode: 'ug', year: 1962, imagePath: 'flag_history_ug_1962', description: '乌干达 1962年国旗' }
    ]
  },
  {
    countryCode: 'us',
    history: [
      { countryCode: 'us', year: 1235, imagePath: 'flag_history_us_1235', description: '美国 1235年国旗' },
      { countryCode: 'us', year: 1606, imagePath: 'flag_history_us_1606', description: '美国 1606年国旗' },
      { countryCode: 'us', year: 1707, imagePath: 'flag_history_us_1707', description: '美国 1707年国旗' },
      { countryCode: 'us', year: 1775, imagePath: 'flag_history_us_1775', description: '美国 1775年国旗' },
      { countryCode: 'us', year: 1776, imagePath: 'flag_history_us_1776', description: '美国 1776年国旗' },
      { countryCode: 'us', year: 1777, imagePath: 'flag_history_us_1777', description: '美国 1777年国旗' },
      { countryCode: 'us', year: 1795, imagePath: 'flag_history_us_1795', description: '美国 1795年国旗' },
      { countryCode: 'us', year: 1819, imagePath: 'flag_history_us_1819', description: '美国 1819年国旗' },
      { countryCode: 'us', year: 1820, imagePath: 'flag_history_us_1820', description: '美国 1820年国旗' },
      { countryCode: 'us', year: 1822, imagePath: 'flag_history_us_1822', description: '美国 1822年国旗' },
      { countryCode: 'us', year: 1837, imagePath: 'flag_history_us_1837', description: '美国 1837年国旗' },
      { countryCode: 'us', year: 1845, imagePath: 'flag_history_us_1845', description: '美国 1845年国旗' },
      { countryCode: 'us', year: 1847, imagePath: 'flag_history_us_1847', description: '美国 1847年国旗' },
      { countryCode: 'us', year: 1848, imagePath: 'flag_history_us_1848', description: '美国 1848年国旗' },
      { countryCode: 'us', year: 1851, imagePath: 'flag_history_us_1851', description: '美国 1851年国旗' },
      { countryCode: 'us', year: 1859, imagePath: 'flag_history_us_1859', description: '美国 1859年国旗' },
      { countryCode: 'us', year: 1861, imagePath: 'flag_history_us_1861', description: '美国 1861年国旗' },
      { countryCode: 'us', year: 1863, imagePath: 'flag_history_us_1863', description: '美国 1863年国旗' },
      { countryCode: 'us', year: 1865, imagePath: 'flag_history_us_1865', description: '美国 1865年国旗' },
      { countryCode: 'us', year: 1867, imagePath: 'flag_history_us_1867', description: '美国 1867年国旗' },
      { countryCode: 'us', year: 1877, imagePath: 'flag_history_us_1877', description: '美国 1877年国旗' },
      { countryCode: 'us', year: 1891, imagePath: 'flag_history_us_1891', description: '美国 1891年国旗' },
      { countryCode: 'us', year: 1896, imagePath: 'flag_history_us_1896', description: '美国 1896年国旗' },
      { countryCode: 'us', year: 1908, imagePath: 'flag_history_us_1908', description: '美国 1908年国旗' },
      { countryCode: 'us', year: 1912, imagePath: 'flag_history_us_1912', description: '美国 1912年国旗' },
      { countryCode: 'us', year: 1959, imagePath: 'flag_history_us_1959', description: '美国 1959年国旗' },
      { countryCode: 'us', year: 1960, imagePath: 'flag_history_us_1960', description: '美国 1960年国旗' }
    ]
  },
  {
    countryCode: 'uy',
    history: [
      { countryCode: 'uy', year: 1624, imagePath: 'flag_history_uy_1624', description: '乌拉圭 1624年国旗' },
      { countryCode: 'uy', year: 1717, imagePath: 'flag_history_uy_1717', description: '乌拉圭 1717年国旗' },
      { countryCode: 'uy', year: 1785, imagePath: 'flag_history_uy_1785', description: '乌拉圭 1785年国旗' },
      { countryCode: 'uy', year: 1812, imagePath: 'flag_history_uy_1812', description: '乌拉圭 1812年国旗' },
      { countryCode: 'uy', year: 1815, imagePath: 'flag_history_uy_1815', description: '乌拉圭 1815年国旗' },
      { countryCode: 'uy', year: 1821, imagePath: 'flag_history_uy_1821', description: '乌拉圭 1821年国旗' },
      { countryCode: 'uy', year: 1828, imagePath: 'flag_history_uy_1828', description: '乌拉圭 1828年国旗' },
      { countryCode: 'uy', year: 1830, imagePath: 'flag_history_uy_1830', description: '乌拉圭 1830年国旗' }
    ]
  },
  {
    countryCode: 'uz',
    history: [
      { countryCode: 'uz', year: 1000, imagePath: 'flag_history_uz_1000', description: '乌兹别克斯坦 1000年国旗' },
      { countryCode: 'uz', year: 1785, imagePath: 'flag_history_uz_1785', description: '乌兹别克斯坦 1785年国旗' },
      { countryCode: 'uz', year: 1920, imagePath: 'flag_history_uz_1920', description: '乌兹别克斯坦 1920年国旗' },
      { countryCode: 'uz', year: 1924, imagePath: 'flag_history_uz_1924', description: '乌兹别克斯坦 1924年国旗' },
      { countryCode: 'uz', year: 1953, imagePath: 'flag_history_uz_1953', description: '乌兹别克斯坦 1953年国旗' },
      { countryCode: 'uz', year: 1991, imagePath: 'flag_history_uz_1991', description: '乌兹别克斯坦 1991年国旗' }
    ]
  },
  {
    countryCode: 'va',
    history: [
      { countryCode: 'va', year: 1808, imagePath: 'flag_history_va_1808', description: '梵蒂冈 1808年国旗' },
      { countryCode: 'va', year: 1870, imagePath: 'flag_history_va_1870', description: '梵蒂冈 1870年国旗' },
      { countryCode: 'va', year: 1929, imagePath: 'flag_history_va_1929', description: '梵蒂冈 1929年国旗' },
      { countryCode: 'va', year: 2023, imagePath: 'flag_history_va_2023', description: '梵蒂冈 2023年国旗' }
    ]
  },
  {
    countryCode: 'vc',
    history: [
      { countryCode: 'vc', year: 1663, imagePath: 'flag_history_vc_1663', description: '圣文森特和格林纳丁斯 1663年国旗' },
      { countryCode: 'vc', year: 1715, imagePath: 'flag_history_vc_1715', description: '圣文森特和格林纳丁斯 1715年国旗' },
      { countryCode: 'vc', year: 1763, imagePath: 'flag_history_vc_1763', description: '圣文森特和格林纳丁斯 1763年国旗' },
      { countryCode: 'vc', year: 1778, imagePath: 'flag_history_vc_1778', description: '圣文森特和格林纳丁斯 1778年国旗' },
      { countryCode: 'vc', year: 1783, imagePath: 'flag_history_vc_1783', description: '圣文森特和格林纳丁斯 1783年国旗' },
      { countryCode: 'vc', year: 1801, imagePath: 'flag_history_vc_1801', description: '圣文森特和格林纳丁斯 1801年国旗' },
      { countryCode: 'vc', year: 1903, imagePath: 'flag_history_vc_1903', description: '圣文森特和格林纳丁斯 1903年国旗' },
      { countryCode: 'vc', year: 1958, imagePath: 'flag_history_vc_1958', description: '圣文森特和格林纳丁斯 1958年国旗' },
      { countryCode: 'vc', year: 1962, imagePath: 'flag_history_vc_1962', description: '圣文森特和格林纳丁斯 1962年国旗' },
      { countryCode: 'vc', year: 1979, imagePath: 'flag_history_vc_1979', description: '圣文森特和格林纳丁斯 1979年国旗' },
      { countryCode: 'vc', year: 1985, imagePath: 'flag_history_vc_1985', description: '圣文森特和格林纳丁斯 1985年国旗' }
    ]
  },
  {
    countryCode: 've',
    history: [
      { countryCode: 've', year: 1522, imagePath: 'flag_history_ve_1522', description: '委内瑞拉 1522年国旗' },
      { countryCode: 've', year: 1717, imagePath: 'flag_history_ve_1717', description: '委内瑞拉 1717年国旗' },
      { countryCode: 've', year: 1785, imagePath: 'flag_history_ve_1785', description: '委内瑞拉 1785年国旗' },
      { countryCode: 've', year: 1811, imagePath: 'flag_history_ve_1811', description: '委内瑞拉 1811年国旗' },
      { countryCode: 've', year: 1813, imagePath: 'flag_history_ve_1813', description: '委内瑞拉 1813年国旗' },
      { countryCode: 've', year: 1814, imagePath: 'flag_history_ve_1814', description: '委内瑞拉 1814年国旗' },
      { countryCode: 've', year: 1817, imagePath: 'flag_history_ve_1817', description: '委内瑞拉 1817年国旗' },
      { countryCode: 've', year: 1819, imagePath: 'flag_history_ve_1819', description: '委内瑞拉 1819年国旗' },
      { countryCode: 've', year: 1820, imagePath: 'flag_history_ve_1820', description: '委内瑞拉 1820年国旗' },
      { countryCode: 've', year: 1821, imagePath: 'flag_history_ve_1821', description: '委内瑞拉 1821年国旗' },
      { countryCode: 've', year: 1836, imagePath: 'flag_history_ve_1836', description: '委内瑞拉 1836年国旗' },
      { countryCode: 've', year: 1859, imagePath: 'flag_history_ve_1859', description: '委内瑞拉 1859年国旗' },
      { countryCode: 've', year: 1863, imagePath: 'flag_history_ve_1863', description: '委内瑞拉 1863年国旗' },
      { countryCode: 've', year: 1905, imagePath: 'flag_history_ve_1905', description: '委内瑞拉 1905年国旗' },
      { countryCode: 've', year: 1930, imagePath: 'flag_history_ve_1930', description: '委内瑞拉 1930年国旗' },
      { countryCode: 've', year: 2006, imagePath: 'flag_history_ve_2006', description: '委内瑞拉 2006年国旗' }
    ]
  },
  {
    countryCode: 'vn',
    history: [
      { countryCode: 'vn', year: 1802, imagePath: 'flag_history_vn_1802', description: '越南 1802年国旗' },
      { countryCode: 'vn', year: 1885, imagePath: 'flag_history_vn_1885', description: '越南 1885年国旗' },
      { countryCode: 'vn', year: 1887, imagePath: 'flag_history_vn_1887', description: '越南 1887年国旗' },
      { countryCode: 'vn', year: 1890, imagePath: 'flag_history_vn_1890', description: '越南 1890年国旗' },
      { countryCode: 'vn', year: 1920, imagePath: 'flag_history_vn_1920', description: '越南 1920年国旗' },
      { countryCode: 'vn', year: 1945, imagePath: 'flag_history_vn_1945', description: '越南 1945年国旗' },
      { countryCode: 'vn', year: 1955, imagePath: 'flag_history_vn_1955', description: '越南 1955年国旗' },
      { countryCode: 'vn', year: 1976, imagePath: 'flag_history_vn_1976', description: '越南 1976年国旗' }
    ]
  },
  {
    countryCode: 'vu',
    history: [
      { countryCode: 'vu', year: 1887, imagePath: 'flag_history_vu_1887', description: '瓦努阿图 1887年国旗' },
      { countryCode: 'vu', year: 1906, imagePath: 'flag_history_vu_1906', description: '瓦努阿图 1906年国旗' },
      { countryCode: 'vu', year: 1980, imagePath: 'flag_history_vu_1980', description: '瓦努阿图 1980年国旗' }
    ]
  },
  {
    countryCode: 'ws',
    history: [
      { countryCode: 'ws', year: 1200, imagePath: 'flag_history_ws_1200', description: '萨摩亚 1200年国旗' },
      { countryCode: 'ws', year: 1900, imagePath: 'flag_history_ws_1900', description: '萨摩亚 1900年国旗' },
      { countryCode: 'ws', year: 1914, imagePath: 'flag_history_ws_1914', description: '萨摩亚 1914年国旗' },
      { countryCode: 'ws', year: 1922, imagePath: 'flag_history_ws_1922', description: '萨摩亚 1922年国旗' },
      { countryCode: 'ws', year: 1948, imagePath: 'flag_history_ws_1948', description: '萨摩亚 1948年国旗' },
      { countryCode: 'ws', year: 1962, imagePath: 'flag_history_ws_1962', description: '萨摩亚 1962年国旗' }
    ]
  },
  {
    countryCode: 'xk',
    history: [
      { countryCode: 'xk', year: 1453, imagePath: 'flag_history_xk_1453', description: '科索沃 1453年国旗' },
      { countryCode: 'xk', year: 1835, imagePath: 'flag_history_xk_1835', description: '科索沃 1835年国旗' },
      { countryCode: 'xk', year: 1882, imagePath: 'flag_history_xk_1882', description: '科索沃 1882年国旗' },
      { countryCode: 'xk', year: 1918, imagePath: 'flag_history_xk_1918', description: '科索沃 1918年国旗' },
      { countryCode: 'xk', year: 1941, imagePath: 'flag_history_xk_1941', description: '科索沃 1941年国旗' },
      { countryCode: 'xk', year: 1943, imagePath: 'flag_history_xk_1943', description: '科索沃 1943年国旗' },
      { countryCode: 'xk', year: 1991, imagePath: 'flag_history_xk_1991', description: '科索沃 1991年国旗' },
      { countryCode: 'xk', year: 1999, imagePath: 'flag_history_xk_1999', description: '科索沃 1999年国旗' },
      { countryCode: 'xk', year: 2008, imagePath: 'flag_history_xk_2008', description: '科索沃 2008年国旗' }
    ]
  },
  {
    countryCode: 'ye',
    history: [
      { countryCode: 'ye', year: 1872, imagePath: 'flag_history_ye_1872', description: '也门 1872年国旗' },
      { countryCode: 'ye', year: 1918, imagePath: 'flag_history_ye_1918', description: '也门 1918年国旗' },
      { countryCode: 'ye', year: 1927, imagePath: 'flag_history_ye_1927', description: '也门 1927年国旗' },
      { countryCode: 'ye', year: 1962, imagePath: 'flag_history_ye_1962', description: '也门 1962年国旗' },
      { countryCode: 'ye', year: 1990, imagePath: 'flag_history_ye_1990', description: '也门 1990年国旗' }
    ]
  },
  {
    countryCode: 'za',
    history: [
      { countryCode: 'za', year: 1652, imagePath: 'flag_history_za_1652', description: '南非 1652年国旗' },
      { countryCode: 'za', year: 1795, imagePath: 'flag_history_za_1795', description: '南非 1795年国旗' },
      { countryCode: 'za', year: 1801, imagePath: 'flag_history_za_1801', description: '南非 1801年国旗' },
      { countryCode: 'za', year: 1875, imagePath: 'flag_history_za_1875', description: '南非 1875年国旗' },
      { countryCode: 'za', year: 1910, imagePath: 'flag_history_za_1910', description: '南非 1910年国旗' },
      { countryCode: 'za', year: 1912, imagePath: 'flag_history_za_1912', description: '南非 1912年国旗' },
      { countryCode: 'za', year: 1928, imagePath: 'flag_history_za_1928', description: '南非 1928年国旗' },
      { countryCode: 'za', year: 1994, imagePath: 'flag_history_za_1994', description: '南非 1994年国旗' }
    ]
  },
  {
    countryCode: 'zm',
    history: [
      { countryCode: 'zm', year: 1924, imagePath: 'flag_history_zm_1924', description: '赞比亚 1924年国旗' },
      { countryCode: 'zm', year: 1953, imagePath: 'flag_history_zm_1953', description: '赞比亚 1953年国旗' },
      { countryCode: 'zm', year: 1963, imagePath: 'flag_history_zm_1963', description: '赞比亚 1963年国旗' },
      { countryCode: 'zm', year: 1964, imagePath: 'flag_history_zm_1964', description: '赞比亚 1964年国旗' },
      { countryCode: 'zm', year: 1996, imagePath: 'flag_history_zm_1996', description: '赞比亚 1996年国旗' }
    ]
  },
  {
    countryCode: 'zw',
    history: [
      { countryCode: 'zw', year: 1200, imagePath: 'flag_history_zw_1200', description: '津巴布韦 1200年国旗' },
      { countryCode: 'zw', year: 1896, imagePath: 'flag_history_zw_1896', description: '津巴布韦 1896年国旗' },
      { countryCode: 'zw', year: 1923, imagePath: 'flag_history_zw_1923', description: '津巴布韦 1923年国旗' },
      { countryCode: 'zw', year: 1953, imagePath: 'flag_history_zw_1953', description: '津巴布韦 1953年国旗' },
      { countryCode: 'zw', year: 1964, imagePath: 'flag_history_zw_1964', description: '津巴布韦 1964年国旗' },
      { countryCode: 'zw', year: 1968, imagePath: 'flag_history_zw_1968', description: '津巴布韦 1968年国旗' },
      { countryCode: 'zw', year: 1979, imagePath: 'flag_history_zw_1979', description: '津巴布韦 1979年国旗' },
      { countryCode: 'zw', year: 1980, imagePath: 'flag_history_zw_1980', description: '津巴布韦 1980年国旗' }
    ]
  }
];

/**
 * 获取指定国家的历史国旗
 */
export function getFlagHistory(countryCode: string): FlagHistoryItem[] {
  const countryHistory = FLAG_HISTORY_DATA.find(item => item.countryCode === countryCode);
  return countryHistory ? countryHistory.history : [];
}

/**
 * 获取所有有历史数据的国家代码
 */
export function getCountriesWithHistory(): string[] {
  return FLAG_HISTORY_DATA
    .filter(item => item.history && item.history.length > 0)
    .map(item => item.countryCode);
}

/**
 * 检查是否有任何历史数据
 */
export function hasAnyHistory(): boolean {
  return FLAG_HISTORY_DATA.length > 0 && 
         FLAG_HISTORY_DATA.some(item => item.history && item.history.length > 0);
}

/**
 * 获取所有历史数据
 */
export function getAllFlagHistory(): CountryFlagHistory[] {
  return FLAG_HISTORY_DATA.filter(item => item.history && item.history.length > 0);
}
