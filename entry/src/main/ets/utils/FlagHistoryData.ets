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
      { countryCode: 'ad', year: 1700, imagePath: 'flag_history_ad_1700', description: '安道尔 1700年国旗' },
      { countryCode: 'ad', year: 1710, imagePath: 'flag_history_ad_1710', description: '安道尔 1710年国旗' },
      { countryCode: 'ad', year: 1720, imagePath: 'flag_history_ad_1720', description: '安道尔 1720年国旗' },
      { countryCode: 'ad', year: 1730, imagePath: 'flag_history_ad_1730', description: '安道尔 1730年国旗' },
      { countryCode: 'ad', year: 1740, imagePath: 'flag_history_ad_1740', description: '安道尔 1740年国旗' }
    ]
  },
  {
    countryCode: 'ae',
    history: [
      { countryCode: 'ae', year: 1700, imagePath: 'flag_history_ae_1700', description: '阿联酋 1700年国旗' },
      { countryCode: 'ae', year: 1710, imagePath: 'flag_history_ae_1710', description: '阿联酋 1710年国旗' },
      { countryCode: 'ae', year: 1720, imagePath: 'flag_history_ae_1720', description: '阿联酋 1720年国旗' },
      { countryCode: 'ae', year: 1730, imagePath: 'flag_history_ae_1730', description: '阿联酋 1730年国旗' }
    ]
  },
  {
    countryCode: 'af',
    history: [
      { countryCode: 'af', year: 1710, imagePath: 'flag_history_af_1710', description: '阿富汗 1710年国旗' },
      { countryCode: 'af', year: 1720, imagePath: 'flag_history_af_1720', description: '阿富汗 1720年国旗' },
      { countryCode: 'af', year: 1740, imagePath: 'flag_history_af_1740', description: '阿富汗 1740年国旗' },
      { countryCode: 'af', year: 1750, imagePath: 'flag_history_af_1750', description: '阿富汗 1750年国旗' },
      { countryCode: 'af', year: 1760, imagePath: 'flag_history_af_1760', description: '阿富汗 1760年国旗' },
      { countryCode: 'af', year: 1770, imagePath: 'flag_history_af_1770', description: '阿富汗 1770年国旗' },
      { countryCode: 'af', year: 1780, imagePath: 'flag_history_af_1780', description: '阿富汗 1780年国旗' },
      { countryCode: 'af', year: 1790, imagePath: 'flag_history_af_1790', description: '阿富汗 1790年国旗' },
      { countryCode: 'af', year: 1800, imagePath: 'flag_history_af_1800', description: '阿富汗 1800年国旗' },
      { countryCode: 'af', year: 1810, imagePath: 'flag_history_af_1810', description: '阿富汗 1810年国旗' },
      { countryCode: 'af', year: 1820, imagePath: 'flag_history_af_1820', description: '阿富汗 1820年国旗' },
      { countryCode: 'af', year: 1830, imagePath: 'flag_history_af_1830', description: '阿富汗 1830年国旗' },
      { countryCode: 'af', year: 1850, imagePath: 'flag_history_af_1850', description: '阿富汗 1850年国旗' },
      { countryCode: 'af', year: 1870, imagePath: 'flag_history_af_1870', description: '阿富汗 1870年国旗' },
      { countryCode: 'af', year: 1890, imagePath: 'flag_history_af_1890', description: '阿富汗 1890年国旗' },
      { countryCode: 'af', year: 1900, imagePath: 'flag_history_af_1900', description: '阿富汗 1900年国旗' },
      { countryCode: 'af', year: 1910, imagePath: 'flag_history_af_1910', description: '阿富汗 1910年国旗' },
      { countryCode: 'af', year: 1920, imagePath: 'flag_history_af_1920', description: '阿富汗 1920年国旗' },
      { countryCode: 'af', year: 1930, imagePath: 'flag_history_af_1930', description: '阿富汗 1930年国旗' },
      { countryCode: 'af', year: 1940, imagePath: 'flag_history_af_1940', description: '阿富汗 1940年国旗' },
      { countryCode: 'af', year: 1950, imagePath: 'flag_history_af_1950', description: '阿富汗 1950年国旗' },
      { countryCode: 'af', year: 1960, imagePath: 'flag_history_af_1960', description: '阿富汗 1960年国旗' }
    ]
  },
  {
    countryCode: 'ag',
    history: [
      { countryCode: 'ag', year: 1700, imagePath: 'flag_history_ag_1700', description: '安提瓜和巴布达 1700年国旗' },
      { countryCode: 'ag', year: 1710, imagePath: 'flag_history_ag_1710', description: '安提瓜和巴布达 1710年国旗' },
      { countryCode: 'ag', year: 1720, imagePath: 'flag_history_ag_1720', description: '安提瓜和巴布达 1720年国旗' },
      { countryCode: 'ag', year: 1730, imagePath: 'flag_history_ag_1730', description: '安提瓜和巴布达 1730年国旗' },
      { countryCode: 'ag', year: 1740, imagePath: 'flag_history_ag_1740', description: '安提瓜和巴布达 1740年国旗' }
    ]
  },
  {
    countryCode: 'al',
    history: [
      { countryCode: 'al', year: 1700, imagePath: 'flag_history_al_1700', description: '阿尔巴尼亚 1700年国旗' },
      { countryCode: 'al', year: 1710, imagePath: 'flag_history_al_1710', description: '阿尔巴尼亚 1710年国旗' },
      { countryCode: 'al', year: 1720, imagePath: 'flag_history_al_1720', description: '阿尔巴尼亚 1720年国旗' },
      { countryCode: 'al', year: 1730, imagePath: 'flag_history_al_1730', description: '阿尔巴尼亚 1730年国旗' },
      { countryCode: 'al', year: 1740, imagePath: 'flag_history_al_1740', description: '阿尔巴尼亚 1740年国旗' },
      { countryCode: 'al', year: 1750, imagePath: 'flag_history_al_1750', description: '阿尔巴尼亚 1750年国旗' },
      { countryCode: 'al', year: 1760, imagePath: 'flag_history_al_1760', description: '阿尔巴尼亚 1760年国旗' },
      { countryCode: 'al', year: 1770, imagePath: 'flag_history_al_1770', description: '阿尔巴尼亚 1770年国旗' },
      { countryCode: 'al', year: 1780, imagePath: 'flag_history_al_1780', description: '阿尔巴尼亚 1780年国旗' },
      { countryCode: 'al', year: 1790, imagePath: 'flag_history_al_1790', description: '阿尔巴尼亚 1790年国旗' },
      { countryCode: 'al', year: 1800, imagePath: 'flag_history_al_1800', description: '阿尔巴尼亚 1800年国旗' },
      { countryCode: 'al', year: 1810, imagePath: 'flag_history_al_1810', description: '阿尔巴尼亚 1810年国旗' },
      { countryCode: 'al', year: 1820, imagePath: 'flag_history_al_1820', description: '阿尔巴尼亚 1820年国旗' }
    ]
  },
  {
    countryCode: 'am',
    history: [
      { countryCode: 'am', year: 1700, imagePath: 'flag_history_am_1700', description: '亚美尼亚 1700年国旗' },
      { countryCode: 'am', year: 1710, imagePath: 'flag_history_am_1710', description: '亚美尼亚 1710年国旗' },
      { countryCode: 'am', year: 1720, imagePath: 'flag_history_am_1720', description: '亚美尼亚 1720年国旗' },
      { countryCode: 'am', year: 1730, imagePath: 'flag_history_am_1730', description: '亚美尼亚 1730年国旗' },
      { countryCode: 'am', year: 1740, imagePath: 'flag_history_am_1740', description: '亚美尼亚 1740年国旗' },
      { countryCode: 'am', year: 1750, imagePath: 'flag_history_am_1750', description: '亚美尼亚 1750年国旗' },
      { countryCode: 'am', year: 1760, imagePath: 'flag_history_am_1760', description: '亚美尼亚 1760年国旗' },
      { countryCode: 'am', year: 1770, imagePath: 'flag_history_am_1770', description: '亚美尼亚 1770年国旗' },
      { countryCode: 'am', year: 1780, imagePath: 'flag_history_am_1780', description: '亚美尼亚 1780年国旗' },
      { countryCode: 'am', year: 1790, imagePath: 'flag_history_am_1790', description: '亚美尼亚 1790年国旗' },
      { countryCode: 'am', year: 1800, imagePath: 'flag_history_am_1800', description: '亚美尼亚 1800年国旗' }
    ]
  },
  {
    countryCode: 'ao',
    history: [
      { countryCode: 'ao', year: 1700, imagePath: 'flag_history_ao_1700', description: '安哥拉 1700年国旗' },
      { countryCode: 'ao', year: 1710, imagePath: 'flag_history_ao_1710', description: '安哥拉 1710年国旗' },
      { countryCode: 'ao', year: 1720, imagePath: 'flag_history_ao_1720', description: '安哥拉 1720年国旗' },
      { countryCode: 'ao', year: 1730, imagePath: 'flag_history_ao_1730', description: '安哥拉 1730年国旗' },
      { countryCode: 'ao', year: 1740, imagePath: 'flag_history_ao_1740', description: '安哥拉 1740年国旗' },
      { countryCode: 'ao', year: 1750, imagePath: 'flag_history_ao_1750', description: '安哥拉 1750年国旗' },
      { countryCode: 'ao', year: 1760, imagePath: 'flag_history_ao_1760', description: '安哥拉 1760年国旗' },
      { countryCode: 'ao', year: 1770, imagePath: 'flag_history_ao_1770', description: '安哥拉 1770年国旗' }
    ]
  },
  {
    countryCode: 'ar',
    history: [
      { countryCode: 'ar', year: 1700, imagePath: 'flag_history_ar_1700', description: '阿根廷 1700年国旗' },
      { countryCode: 'ar', year: 1710, imagePath: 'flag_history_ar_1710', description: '阿根廷 1710年国旗' },
      { countryCode: 'ar', year: 1720, imagePath: 'flag_history_ar_1720', description: '阿根廷 1720年国旗' },
      { countryCode: 'ar', year: 1730, imagePath: 'flag_history_ar_1730', description: '阿根廷 1730年国旗' },
      { countryCode: 'ar', year: 1740, imagePath: 'flag_history_ar_1740', description: '阿根廷 1740年国旗' },
      { countryCode: 'ar', year: 1750, imagePath: 'flag_history_ar_1750', description: '阿根廷 1750年国旗' },
      { countryCode: 'ar', year: 1760, imagePath: 'flag_history_ar_1760', description: '阿根廷 1760年国旗' },
      { countryCode: 'ar', year: 1770, imagePath: 'flag_history_ar_1770', description: '阿根廷 1770年国旗' },
      { countryCode: 'ar', year: 1780, imagePath: 'flag_history_ar_1780', description: '阿根廷 1780年国旗' },
      { countryCode: 'ar', year: 1790, imagePath: 'flag_history_ar_1790', description: '阿根廷 1790年国旗' }
    ]
  },
  {
    countryCode: 'at',
    history: [
      { countryCode: 'at', year: 1700, imagePath: 'flag_history_at_1700', description: '奥地利 1700年国旗' },
      { countryCode: 'at', year: 1710, imagePath: 'flag_history_at_1710', description: '奥地利 1710年国旗' },
      { countryCode: 'at', year: 1720, imagePath: 'flag_history_at_1720', description: '奥地利 1720年国旗' },
      { countryCode: 'at', year: 1730, imagePath: 'flag_history_at_1730', description: '奥地利 1730年国旗' },
      { countryCode: 'at', year: 1740, imagePath: 'flag_history_at_1740', description: '奥地利 1740年国旗' }
    ]
  },
  {
    countryCode: 'au',
    history: [
      { countryCode: 'au', year: 1700, imagePath: 'flag_history_au_1700', description: '澳大利亚 1700年国旗' },
      { countryCode: 'au', year: 1710, imagePath: 'flag_history_au_1710', description: '澳大利亚 1710年国旗' },
      { countryCode: 'au', year: 1720, imagePath: 'flag_history_au_1720', description: '澳大利亚 1720年国旗' },
      { countryCode: 'au', year: 1730, imagePath: 'flag_history_au_1730', description: '澳大利亚 1730年国旗' },
      { countryCode: 'au', year: 1740, imagePath: 'flag_history_au_1740', description: '澳大利亚 1740年国旗' },
      { countryCode: 'au', year: 1750, imagePath: 'flag_history_au_1750', description: '澳大利亚 1750年国旗' }
    ]
  },
  {
    countryCode: 'az',
    history: [
      { countryCode: 'az', year: 1700, imagePath: 'flag_history_az_1700', description: '阿塞拜疆 1700年国旗' },
      { countryCode: 'az', year: 1710, imagePath: 'flag_history_az_1710', description: '阿塞拜疆 1710年国旗' },
      { countryCode: 'az', year: 1720, imagePath: 'flag_history_az_1720', description: '阿塞拜疆 1720年国旗' },
      { countryCode: 'az', year: 1730, imagePath: 'flag_history_az_1730', description: '阿塞拜疆 1730年国旗' },
      { countryCode: 'az', year: 1740, imagePath: 'flag_history_az_1740', description: '阿塞拜疆 1740年国旗' },
      { countryCode: 'az', year: 1750, imagePath: 'flag_history_az_1750', description: '阿塞拜疆 1750年国旗' },
      { countryCode: 'az', year: 1760, imagePath: 'flag_history_az_1760', description: '阿塞拜疆 1760年国旗' },
      { countryCode: 'az', year: 1770, imagePath: 'flag_history_az_1770', description: '阿塞拜疆 1770年国旗' },
      { countryCode: 'az', year: 1780, imagePath: 'flag_history_az_1780', description: '阿塞拜疆 1780年国旗' },
      { countryCode: 'az', year: 1790, imagePath: 'flag_history_az_1790', description: '阿塞拜疆 1790年国旗' },
      { countryCode: 'az', year: 1800, imagePath: 'flag_history_az_1800', description: '阿塞拜疆 1800年国旗' },
      { countryCode: 'az', year: 1810, imagePath: 'flag_history_az_1810', description: '阿塞拜疆 1810年国旗' },
      { countryCode: 'az', year: 1820, imagePath: 'flag_history_az_1820', description: '阿塞拜疆 1820年国旗' },
      { countryCode: 'az', year: 1830, imagePath: 'flag_history_az_1830', description: '阿塞拜疆 1830年国旗' },
      { countryCode: 'az', year: 1840, imagePath: 'flag_history_az_1840', description: '阿塞拜疆 1840年国旗' },
      { countryCode: 'az', year: 1850, imagePath: 'flag_history_az_1850', description: '阿塞拜疆 1850年国旗' },
      { countryCode: 'az', year: 1860, imagePath: 'flag_history_az_1860', description: '阿塞拜疆 1860年国旗' }
    ]
  },
  {
    countryCode: 'ba',
    history: [
      { countryCode: 'ba', year: 1700, imagePath: 'flag_history_ba_1700', description: '波斯尼亚和黑塞哥维那 1700年国旗' },
      { countryCode: 'ba', year: 1710, imagePath: 'flag_history_ba_1710', description: '波斯尼亚和黑塞哥维那 1710年国旗' },
      { countryCode: 'ba', year: 1720, imagePath: 'flag_history_ba_1720', description: '波斯尼亚和黑塞哥维那 1720年国旗' },
      { countryCode: 'ba', year: 1730, imagePath: 'flag_history_ba_1730', description: '波斯尼亚和黑塞哥维那 1730年国旗' },
      { countryCode: 'ba', year: 1740, imagePath: 'flag_history_ba_1740', description: '波斯尼亚和黑塞哥维那 1740年国旗' },
      { countryCode: 'ba', year: 1750, imagePath: 'flag_history_ba_1750', description: '波斯尼亚和黑塞哥维那 1750年国旗' },
      { countryCode: 'ba', year: 1760, imagePath: 'flag_history_ba_1760', description: '波斯尼亚和黑塞哥维那 1760年国旗' },
      { countryCode: 'ba', year: 1770, imagePath: 'flag_history_ba_1770', description: '波斯尼亚和黑塞哥维那 1770年国旗' },
      { countryCode: 'ba', year: 1780, imagePath: 'flag_history_ba_1780', description: '波斯尼亚和黑塞哥维那 1780年国旗' }
    ]
  },
  {
    countryCode: 'bb',
    history: [
      { countryCode: 'bb', year: 1700, imagePath: 'flag_history_bb_1700', description: '巴巴多斯 1700年国旗' },
      { countryCode: 'bb', year: 1710, imagePath: 'flag_history_bb_1710', description: '巴巴多斯 1710年国旗' },
      { countryCode: 'bb', year: 1720, imagePath: 'flag_history_bb_1720', description: '巴巴多斯 1720年国旗' },
      { countryCode: 'bb', year: 1730, imagePath: 'flag_history_bb_1730', description: '巴巴多斯 1730年国旗' },
      { countryCode: 'bb', year: 1740, imagePath: 'flag_history_bb_1740', description: '巴巴多斯 1740年国旗' }
    ]
  },
  {
    countryCode: 'bd',
    history: [
      { countryCode: 'bd', year: 1700, imagePath: 'flag_history_bd_1700', description: '孟加拉国 1700年国旗' },
      { countryCode: 'bd', year: 1710, imagePath: 'flag_history_bd_1710', description: '孟加拉国 1710年国旗' },
      { countryCode: 'bd', year: 1720, imagePath: 'flag_history_bd_1720', description: '孟加拉国 1720年国旗' },
      { countryCode: 'bd', year: 1730, imagePath: 'flag_history_bd_1730', description: '孟加拉国 1730年国旗' },
      { countryCode: 'bd', year: 1740, imagePath: 'flag_history_bd_1740', description: '孟加拉国 1740年国旗' },
      { countryCode: 'bd', year: 1750, imagePath: 'flag_history_bd_1750', description: '孟加拉国 1750年国旗' },
      { countryCode: 'bd', year: 1760, imagePath: 'flag_history_bd_1760', description: '孟加拉国 1760年国旗' }
    ]
  },
  {
    countryCode: 'be',
    history: [
      { countryCode: 'be', year: 1710, imagePath: 'flag_history_be_1710', description: '比利时 1710年国旗' },
      { countryCode: 'be', year: 1730, imagePath: 'flag_history_be_1730', description: '比利时 1730年国旗' },
      { countryCode: 'be', year: 1740, imagePath: 'flag_history_be_1740', description: '比利时 1740年国旗' },
      { countryCode: 'be', year: 1750, imagePath: 'flag_history_be_1750', description: '比利时 1750年国旗' },
      { countryCode: 'be', year: 1760, imagePath: 'flag_history_be_1760', description: '比利时 1760年国旗' },
      { countryCode: 'be', year: 1770, imagePath: 'flag_history_be_1770', description: '比利时 1770年国旗' },
      { countryCode: 'be', year: 1780, imagePath: 'flag_history_be_1780', description: '比利时 1780年国旗' },
      { countryCode: 'be', year: 1790, imagePath: 'flag_history_be_1790', description: '比利时 1790年国旗' }
    ]
  },
  {
    countryCode: 'bf',
    history: [
      { countryCode: 'bf', year: 1700, imagePath: 'flag_history_bf_1700', description: '布基纳法索 1700年国旗' },
      { countryCode: 'bf', year: 1710, imagePath: 'flag_history_bf_1710', description: '布基纳法索 1710年国旗' },
      { countryCode: 'bf', year: 1720, imagePath: 'flag_history_bf_1720', description: '布基纳法索 1720年国旗' },
      { countryCode: 'bf', year: 1730, imagePath: 'flag_history_bf_1730', description: '布基纳法索 1730年国旗' }
    ]
  },
  {
    countryCode: 'bg',
    history: [
      { countryCode: 'bg', year: 1700, imagePath: 'flag_history_bg_1700', description: '保加利亚 1700年国旗' },
      { countryCode: 'bg', year: 1710, imagePath: 'flag_history_bg_1710', description: '保加利亚 1710年国旗' },
      { countryCode: 'bg', year: 1720, imagePath: 'flag_history_bg_1720', description: '保加利亚 1720年国旗' },
      { countryCode: 'bg', year: 1730, imagePath: 'flag_history_bg_1730', description: '保加利亚 1730年国旗' },
      { countryCode: 'bg', year: 1740, imagePath: 'flag_history_bg_1740', description: '保加利亚 1740年国旗' },
      { countryCode: 'bg', year: 1750, imagePath: 'flag_history_bg_1750', description: '保加利亚 1750年国旗' },
      { countryCode: 'bg', year: 1760, imagePath: 'flag_history_bg_1760', description: '保加利亚 1760年国旗' }
    ]
  },
  {
    countryCode: 'bh',
    history: [
      { countryCode: 'bh', year: 1700, imagePath: 'flag_history_bh_1700', description: '巴林 1700年国旗' },
      { countryCode: 'bh', year: 1710, imagePath: 'flag_history_bh_1710', description: '巴林 1710年国旗' },
      { countryCode: 'bh', year: 1720, imagePath: 'flag_history_bh_1720', description: '巴林 1720年国旗' },
      { countryCode: 'bh', year: 1730, imagePath: 'flag_history_bh_1730', description: '巴林 1730年国旗' },
      { countryCode: 'bh', year: 1740, imagePath: 'flag_history_bh_1740', description: '巴林 1740年国旗' }
    ]
  },
  {
    countryCode: 'bi',
    history: [
      { countryCode: 'bi', year: 1700, imagePath: 'flag_history_bi_1700', description: '布隆迪 1700年国旗' },
      { countryCode: 'bi', year: 1710, imagePath: 'flag_history_bi_1710', description: '布隆迪 1710年国旗' },
      { countryCode: 'bi', year: 1720, imagePath: 'flag_history_bi_1720', description: '布隆迪 1720年国旗' },
      { countryCode: 'bi', year: 1730, imagePath: 'flag_history_bi_1730', description: '布隆迪 1730年国旗' },
      { countryCode: 'bi', year: 1740, imagePath: 'flag_history_bi_1740', description: '布隆迪 1740年国旗' },
      { countryCode: 'bi', year: 1750, imagePath: 'flag_history_bi_1750', description: '布隆迪 1750年国旗' },
      { countryCode: 'bi', year: 1760, imagePath: 'flag_history_bi_1760', description: '布隆迪 1760年国旗' },
      { countryCode: 'bi', year: 1770, imagePath: 'flag_history_bi_1770', description: '布隆迪 1770年国旗' }
    ]
  },
  {
    countryCode: 'bj',
    history: [
      { countryCode: 'bj', year: 1700, imagePath: 'flag_history_bj_1700', description: '贝宁 1700年国旗' },
      { countryCode: 'bj', year: 1710, imagePath: 'flag_history_bj_1710', description: '贝宁 1710年国旗' },
      { countryCode: 'bj', year: 1720, imagePath: 'flag_history_bj_1720', description: '贝宁 1720年国旗' },
      { countryCode: 'bj', year: 1730, imagePath: 'flag_history_bj_1730', description: '贝宁 1730年国旗' },
      { countryCode: 'bj', year: 1740, imagePath: 'flag_history_bj_1740', description: '贝宁 1740年国旗' }
    ]
  },
  {
    countryCode: 'bn',
    history: [
      { countryCode: 'bn', year: 1700, imagePath: 'flag_history_bn_1700', description: '文莱 1700年国旗' },
      { countryCode: 'bn', year: 1710, imagePath: 'flag_history_bn_1710', description: '文莱 1710年国旗' },
      { countryCode: 'bn', year: 1720, imagePath: 'flag_history_bn_1720', description: '文莱 1720年国旗' },
      { countryCode: 'bn', year: 1730, imagePath: 'flag_history_bn_1730', description: '文莱 1730年国旗' },
      { countryCode: 'bn', year: 1740, imagePath: 'flag_history_bn_1740', description: '文莱 1740年国旗' }
    ]
  },
  {
    countryCode: 'bo',
    history: [
      { countryCode: 'bo', year: 1700, imagePath: 'flag_history_bo_1700', description: '玻利维亚 1700年国旗' },
      { countryCode: 'bo', year: 1710, imagePath: 'flag_history_bo_1710', description: '玻利维亚 1710年国旗' },
      { countryCode: 'bo', year: 1720, imagePath: 'flag_history_bo_1720', description: '玻利维亚 1720年国旗' },
      { countryCode: 'bo', year: 1730, imagePath: 'flag_history_bo_1730', description: '玻利维亚 1730年国旗' },
      { countryCode: 'bo', year: 1740, imagePath: 'flag_history_bo_1740', description: '玻利维亚 1740年国旗' },
      { countryCode: 'bo', year: 1750, imagePath: 'flag_history_bo_1750', description: '玻利维亚 1750年国旗' }
    ]
  },
  {
    countryCode: 'br',
    history: [
      { countryCode: 'br', year: 1700, imagePath: 'flag_history_br_1700', description: '巴西 1700年国旗' },
      { countryCode: 'br', year: 1710, imagePath: 'flag_history_br_1710', description: '巴西 1710年国旗' },
      { countryCode: 'br', year: 1720, imagePath: 'flag_history_br_1720', description: '巴西 1720年国旗' },
      { countryCode: 'br', year: 1730, imagePath: 'flag_history_br_1730', description: '巴西 1730年国旗' },
      { countryCode: 'br', year: 1740, imagePath: 'flag_history_br_1740', description: '巴西 1740年国旗' },
      { countryCode: 'br', year: 1750, imagePath: 'flag_history_br_1750', description: '巴西 1750年国旗' },
      { countryCode: 'br', year: 1760, imagePath: 'flag_history_br_1760', description: '巴西 1760年国旗' },
      { countryCode: 'br', year: 1770, imagePath: 'flag_history_br_1770', description: '巴西 1770年国旗' }
    ]
  },
  {
    countryCode: 'bs',
    history: [
      { countryCode: 'bs', year: 1700, imagePath: 'flag_history_bs_1700', description: '巴哈马 1700年国旗' },
      { countryCode: 'bs', year: 1710, imagePath: 'flag_history_bs_1710', description: '巴哈马 1710年国旗' },
      { countryCode: 'bs', year: 1720, imagePath: 'flag_history_bs_1720', description: '巴哈马 1720年国旗' },
      { countryCode: 'bs', year: 1730, imagePath: 'flag_history_bs_1730', description: '巴哈马 1730年国旗' },
      { countryCode: 'bs', year: 1740, imagePath: 'flag_history_bs_1740', description: '巴哈马 1740年国旗' },
      { countryCode: 'bs', year: 1750, imagePath: 'flag_history_bs_1750', description: '巴哈马 1750年国旗' },
      { countryCode: 'bs', year: 1760, imagePath: 'flag_history_bs_1760', description: '巴哈马 1760年国旗' },
      { countryCode: 'bs', year: 1770, imagePath: 'flag_history_bs_1770', description: '巴哈马 1770年国旗' }
    ]
  },
  {
    countryCode: 'bt',
    history: [
      { countryCode: 'bt', year: 1700, imagePath: 'flag_history_bt_1700', description: '不丹 1700年国旗' },
      { countryCode: 'bt', year: 1710, imagePath: 'flag_history_bt_1710', description: '不丹 1710年国旗' },
      { countryCode: 'bt', year: 1720, imagePath: 'flag_history_bt_1720', description: '不丹 1720年国旗' },
      { countryCode: 'bt', year: 1730, imagePath: 'flag_history_bt_1730', description: '不丹 1730年国旗' }
    ]
  },
  {
    countryCode: 'bw',
    history: [
      { countryCode: 'bw', year: 1700, imagePath: 'flag_history_bw_1700', description: '博茨瓦纳 1700年国旗' },
      { countryCode: 'bw', year: 1710, imagePath: 'flag_history_bw_1710', description: '博茨瓦纳 1710年国旗' },
      { countryCode: 'bw', year: 1720, imagePath: 'flag_history_bw_1720', description: '博茨瓦纳 1720年国旗' }
    ]
  },
  {
    countryCode: 'by',
    history: [
      { countryCode: 'by', year: 1700, imagePath: 'flag_history_by_1700', description: '白俄罗斯 1700年国旗' },
      { countryCode: 'by', year: 1710, imagePath: 'flag_history_by_1710', description: '白俄罗斯 1710年国旗' },
      { countryCode: 'by', year: 1720, imagePath: 'flag_history_by_1720', description: '白俄罗斯 1720年国旗' },
      { countryCode: 'by', year: 1730, imagePath: 'flag_history_by_1730', description: '白俄罗斯 1730年国旗' },
      { countryCode: 'by', year: 1740, imagePath: 'flag_history_by_1740', description: '白俄罗斯 1740年国旗' },
      { countryCode: 'by', year: 1750, imagePath: 'flag_history_by_1750', description: '白俄罗斯 1750年国旗' },
      { countryCode: 'by', year: 1760, imagePath: 'flag_history_by_1760', description: '白俄罗斯 1760年国旗' },
      { countryCode: 'by', year: 1770, imagePath: 'flag_history_by_1770', description: '白俄罗斯 1770年国旗' },
      { countryCode: 'by', year: 1780, imagePath: 'flag_history_by_1780', description: '白俄罗斯 1780年国旗' },
      { countryCode: 'by', year: 1790, imagePath: 'flag_history_by_1790', description: '白俄罗斯 1790年国旗' },
      { countryCode: 'by', year: 1800, imagePath: 'flag_history_by_1800', description: '白俄罗斯 1800年国旗' },
      { countryCode: 'by', year: 1810, imagePath: 'flag_history_by_1810', description: '白俄罗斯 1810年国旗' },
      { countryCode: 'by', year: 1820, imagePath: 'flag_history_by_1820', description: '白俄罗斯 1820年国旗' }
    ]
  },
  {
    countryCode: 'bz',
    history: [
      { countryCode: 'bz', year: 1700, imagePath: 'flag_history_bz_1700', description: '伯利兹 1700年国旗' },
      { countryCode: 'bz', year: 1710, imagePath: 'flag_history_bz_1710', description: '伯利兹 1710年国旗' },
      { countryCode: 'bz', year: 1720, imagePath: 'flag_history_bz_1720', description: '伯利兹 1720年国旗' },
      { countryCode: 'bz', year: 1730, imagePath: 'flag_history_bz_1730', description: '伯利兹 1730年国旗' },
      { countryCode: 'bz', year: 1740, imagePath: 'flag_history_bz_1740', description: '伯利兹 1740年国旗' },
      { countryCode: 'bz', year: 1750, imagePath: 'flag_history_bz_1750', description: '伯利兹 1750年国旗' },
      { countryCode: 'bz', year: 1760, imagePath: 'flag_history_bz_1760', description: '伯利兹 1760年国旗' },
      { countryCode: 'bz', year: 1770, imagePath: 'flag_history_bz_1770', description: '伯利兹 1770年国旗' },
      { countryCode: 'bz', year: 1780, imagePath: 'flag_history_bz_1780', description: '伯利兹 1780年国旗' }
    ]
  },
  {
    countryCode: 'ca',
    history: [
      { countryCode: 'ca', year: 1700, imagePath: 'flag_history_ca_1700', description: '加拿大 1700年国旗' },
      { countryCode: 'ca', year: 1720, imagePath: 'flag_history_ca_1720', description: '加拿大 1720年国旗' },
      { countryCode: 'ca', year: 1730, imagePath: 'flag_history_ca_1730', description: '加拿大 1730年国旗' },
      { countryCode: 'ca', year: 1740, imagePath: 'flag_history_ca_1740', description: '加拿大 1740年国旗' },
      { countryCode: 'ca', year: 1750, imagePath: 'flag_history_ca_1750', description: '加拿大 1750年国旗' },
      { countryCode: 'ca', year: 1760, imagePath: 'flag_history_ca_1760', description: '加拿大 1760年国旗' },
      { countryCode: 'ca', year: 1770, imagePath: 'flag_history_ca_1770', description: '加拿大 1770年国旗' }
    ]
  },
  {
    countryCode: 'cd',
    history: [
      { countryCode: 'cd', year: 1700, imagePath: 'flag_history_cd_1700', description: '刚果（金） 1700年国旗' },
      { countryCode: 'cd', year: 1710, imagePath: 'flag_history_cd_1710', description: '刚果（金） 1710年国旗' },
      { countryCode: 'cd', year: 1720, imagePath: 'flag_history_cd_1720', description: '刚果（金） 1720年国旗' },
      { countryCode: 'cd', year: 1730, imagePath: 'flag_history_cd_1730', description: '刚果（金） 1730年国旗' },
      { countryCode: 'cd', year: 1740, imagePath: 'flag_history_cd_1740', description: '刚果（金） 1740年国旗' },
      { countryCode: 'cd', year: 1750, imagePath: 'flag_history_cd_1750', description: '刚果（金） 1750年国旗' },
      { countryCode: 'cd', year: 1760, imagePath: 'flag_history_cd_1760', description: '刚果（金） 1760年国旗' },
      { countryCode: 'cd', year: 1770, imagePath: 'flag_history_cd_1770', description: '刚果（金） 1770年国旗' },
      { countryCode: 'cd', year: 1780, imagePath: 'flag_history_cd_1780', description: '刚果（金） 1780年国旗' }
    ]
  },
  {
    countryCode: 'cf',
    history: [
      { countryCode: 'cf', year: 1700, imagePath: 'flag_history_cf_1700', description: '中非 1700年国旗' },
      { countryCode: 'cf', year: 1710, imagePath: 'flag_history_cf_1710', description: '中非 1710年国旗' },
      { countryCode: 'cf', year: 1720, imagePath: 'flag_history_cf_1720', description: '中非 1720年国旗' }
    ]
  },
  {
    countryCode: 'cg',
    history: [
      { countryCode: 'cg', year: 1700, imagePath: 'flag_history_cg_1700', description: '刚果（布） 1700年国旗' },
      { countryCode: 'cg', year: 1710, imagePath: 'flag_history_cg_1710', description: '刚果（布） 1710年国旗' },
      { countryCode: 'cg', year: 1720, imagePath: 'flag_history_cg_1720', description: '刚果（布） 1720年国旗' },
      { countryCode: 'cg', year: 1730, imagePath: 'flag_history_cg_1730', description: '刚果（布） 1730年国旗' },
      { countryCode: 'cg', year: 1740, imagePath: 'flag_history_cg_1740', description: '刚果（布） 1740年国旗' }
    ]
  },
  {
    countryCode: 'ch',
    history: [
      { countryCode: 'ch', year: 1700, imagePath: 'flag_history_ch_1700', description: '瑞士 1700年国旗' },
      { countryCode: 'ch', year: 1720, imagePath: 'flag_history_ch_1720', description: '瑞士 1720年国旗' },
      { countryCode: 'ch', year: 1730, imagePath: 'flag_history_ch_1730', description: '瑞士 1730年国旗' }
    ]
  },
  {
    countryCode: 'cl',
    history: [
      { countryCode: 'cl', year: 1700, imagePath: 'flag_history_cl_1700', description: '智利 1700年国旗' },
      { countryCode: 'cl', year: 1710, imagePath: 'flag_history_cl_1710', description: '智利 1710年国旗' },
      { countryCode: 'cl', year: 1720, imagePath: 'flag_history_cl_1720', description: '智利 1720年国旗' },
      { countryCode: 'cl', year: 1730, imagePath: 'flag_history_cl_1730', description: '智利 1730年国旗' },
      { countryCode: 'cl', year: 1740, imagePath: 'flag_history_cl_1740', description: '智利 1740年国旗' }
    ]
  },
  {
    countryCode: 'cm',
    history: [
      { countryCode: 'cm', year: 1700, imagePath: 'flag_history_cm_1700', description: '喀麦隆 1700年国旗' },
      { countryCode: 'cm', year: 1710, imagePath: 'flag_history_cm_1710', description: '喀麦隆 1710年国旗' },
      { countryCode: 'cm', year: 1720, imagePath: 'flag_history_cm_1720', description: '喀麦隆 1720年国旗' },
      { countryCode: 'cm', year: 1730, imagePath: 'flag_history_cm_1730', description: '喀麦隆 1730年国旗' },
      { countryCode: 'cm', year: 1740, imagePath: 'flag_history_cm_1740', description: '喀麦隆 1740年国旗' },
      { countryCode: 'cm', year: 1750, imagePath: 'flag_history_cm_1750', description: '喀麦隆 1750年国旗' }
    ]
  },
  {
    countryCode: 'cn',
    history: [
      { countryCode: 'cn', year: 1700, imagePath: 'flag_history_cn_1700', description: '中国大陆 1700年国旗' },
      { countryCode: 'cn', year: 1710, imagePath: 'flag_history_cn_1710', description: '中国大陆 1710年国旗' },
      { countryCode: 'cn', year: 1720, imagePath: 'flag_history_cn_1720', description: '中国大陆 1720年国旗' },
      { countryCode: 'cn', year: 1730, imagePath: 'flag_history_cn_1730', description: '中国大陆 1730年国旗' },
      { countryCode: 'cn', year: 1740, imagePath: 'flag_history_cn_1740', description: '中国大陆 1740年国旗' },
      { countryCode: 'cn', year: 1750, imagePath: 'flag_history_cn_1750', description: '中国大陆 1750年国旗' }
    ]
  },
  {
    countryCode: 'co',
    history: [
      { countryCode: 'co', year: 1700, imagePath: 'flag_history_co_1700', description: '哥伦比亚 1700年国旗' },
      { countryCode: 'co', year: 1710, imagePath: 'flag_history_co_1710', description: '哥伦比亚 1710年国旗' },
      { countryCode: 'co', year: 1720, imagePath: 'flag_history_co_1720', description: '哥伦比亚 1720年国旗' },
      { countryCode: 'co', year: 1730, imagePath: 'flag_history_co_1730', description: '哥伦比亚 1730年国旗' },
      { countryCode: 'co', year: 1740, imagePath: 'flag_history_co_1740', description: '哥伦比亚 1740年国旗' },
      { countryCode: 'co', year: 1750, imagePath: 'flag_history_co_1750', description: '哥伦比亚 1750年国旗' },
      { countryCode: 'co', year: 1760, imagePath: 'flag_history_co_1760', description: '哥伦比亚 1760年国旗' },
      { countryCode: 'co', year: 1770, imagePath: 'flag_history_co_1770', description: '哥伦比亚 1770年国旗' },
      { countryCode: 'co', year: 1780, imagePath: 'flag_history_co_1780', description: '哥伦比亚 1780年国旗' },
      { countryCode: 'co', year: 1790, imagePath: 'flag_history_co_1790', description: '哥伦比亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'cr',
    history: [
      { countryCode: 'cr', year: 1700, imagePath: 'flag_history_cr_1700', description: '哥斯达黎加 1700年国旗' },
      { countryCode: 'cr', year: 1710, imagePath: 'flag_history_cr_1710', description: '哥斯达黎加 1710年国旗' },
      { countryCode: 'cr', year: 1720, imagePath: 'flag_history_cr_1720', description: '哥斯达黎加 1720年国旗' },
      { countryCode: 'cr', year: 1730, imagePath: 'flag_history_cr_1730', description: '哥斯达黎加 1730年国旗' },
      { countryCode: 'cr', year: 1740, imagePath: 'flag_history_cr_1740', description: '哥斯达黎加 1740年国旗' },
      { countryCode: 'cr', year: 1750, imagePath: 'flag_history_cr_1750', description: '哥斯达黎加 1750年国旗' },
      { countryCode: 'cr', year: 1760, imagePath: 'flag_history_cr_1760', description: '哥斯达黎加 1760年国旗' }
    ]
  },
  {
    countryCode: 'cu',
    history: [
      { countryCode: 'cu', year: 1700, imagePath: 'flag_history_cu_1700', description: '古巴 1700年国旗' },
      { countryCode: 'cu', year: 1710, imagePath: 'flag_history_cu_1710', description: '古巴 1710年国旗' },
      { countryCode: 'cu', year: 1720, imagePath: 'flag_history_cu_1720', description: '古巴 1720年国旗' }
    ]
  },
  {
    countryCode: 'cv',
    history: [
      { countryCode: 'cv', year: 1700, imagePath: 'flag_history_cv_1700', description: '佛得角 1700年国旗' },
      { countryCode: 'cv', year: 1710, imagePath: 'flag_history_cv_1710', description: '佛得角 1710年国旗' },
      { countryCode: 'cv', year: 1720, imagePath: 'flag_history_cv_1720', description: '佛得角 1720年国旗' },
      { countryCode: 'cv', year: 1730, imagePath: 'flag_history_cv_1730', description: '佛得角 1730年国旗' },
      { countryCode: 'cv', year: 1740, imagePath: 'flag_history_cv_1740', description: '佛得角 1740年国旗' },
      { countryCode: 'cv', year: 1750, imagePath: 'flag_history_cv_1750', description: '佛得角 1750年国旗' },
      { countryCode: 'cv', year: 1760, imagePath: 'flag_history_cv_1760', description: '佛得角 1760年国旗' },
      { countryCode: 'cv', year: 1770, imagePath: 'flag_history_cv_1770', description: '佛得角 1770年国旗' },
      { countryCode: 'cv', year: 1780, imagePath: 'flag_history_cv_1780', description: '佛得角 1780年国旗' }
    ]
  },
  {
    countryCode: 'cy',
    history: [
      { countryCode: 'cy', year: 1700, imagePath: 'flag_history_cy_1700', description: '塞浦路斯 1700年国旗' },
      { countryCode: 'cy', year: 1710, imagePath: 'flag_history_cy_1710', description: '塞浦路斯 1710年国旗' },
      { countryCode: 'cy', year: 1720, imagePath: 'flag_history_cy_1720', description: '塞浦路斯 1720年国旗' },
      { countryCode: 'cy', year: 1730, imagePath: 'flag_history_cy_1730', description: '塞浦路斯 1730年国旗' },
      { countryCode: 'cy', year: 1740, imagePath: 'flag_history_cy_1740', description: '塞浦路斯 1740年国旗' },
      { countryCode: 'cy', year: 1750, imagePath: 'flag_history_cy_1750', description: '塞浦路斯 1750年国旗' }
    ]
  },
  {
    countryCode: 'cz',
    history: [
      { countryCode: 'cz', year: 1700, imagePath: 'flag_history_cz_1700', description: '捷克 1700年国旗' },
      { countryCode: 'cz', year: 1710, imagePath: 'flag_history_cz_1710', description: '捷克 1710年国旗' },
      { countryCode: 'cz', year: 1720, imagePath: 'flag_history_cz_1720', description: '捷克 1720年国旗' },
      { countryCode: 'cz', year: 1730, imagePath: 'flag_history_cz_1730', description: '捷克 1730年国旗' },
      { countryCode: 'cz', year: 1740, imagePath: 'flag_history_cz_1740', description: '捷克 1740年国旗' },
      { countryCode: 'cz', year: 1750, imagePath: 'flag_history_cz_1750', description: '捷克 1750年国旗' },
      { countryCode: 'cz', year: 1760, imagePath: 'flag_history_cz_1760', description: '捷克 1760年国旗' },
      { countryCode: 'cz', year: 1770, imagePath: 'flag_history_cz_1770', description: '捷克 1770年国旗' },
      { countryCode: 'cz', year: 1780, imagePath: 'flag_history_cz_1780', description: '捷克 1780年国旗' },
      { countryCode: 'cz', year: 1790, imagePath: 'flag_history_cz_1790', description: '捷克 1790年国旗' }
    ]
  },
  {
    countryCode: 'de',
    history: [
      { countryCode: 'de', year: 1710, imagePath: 'flag_history_de_1710', description: '德国 1710年国旗' },
      { countryCode: 'de', year: 1720, imagePath: 'flag_history_de_1720', description: '德国 1720年国旗' },
      { countryCode: 'de', year: 1730, imagePath: 'flag_history_de_1730', description: '德国 1730年国旗' },
      { countryCode: 'de', year: 1740, imagePath: 'flag_history_de_1740', description: '德国 1740年国旗' },
      { countryCode: 'de', year: 1750, imagePath: 'flag_history_de_1750', description: '德国 1750年国旗' },
      { countryCode: 'de', year: 1760, imagePath: 'flag_history_de_1760', description: '德国 1760年国旗' },
      { countryCode: 'de', year: 1770, imagePath: 'flag_history_de_1770', description: '德国 1770年国旗' },
      { countryCode: 'de', year: 1800, imagePath: 'flag_history_de_1800', description: '德国 1800年国旗' }
    ]
  },
  {
    countryCode: 'dj',
    history: [
      { countryCode: 'dj', year: 1700, imagePath: 'flag_history_dj_1700', description: '吉布提 1700年国旗' },
      { countryCode: 'dj', year: 1720, imagePath: 'flag_history_dj_1720', description: '吉布提 1720年国旗' },
      { countryCode: 'dj', year: 1730, imagePath: 'flag_history_dj_1730', description: '吉布提 1730年国旗' },
      { countryCode: 'dj', year: 1740, imagePath: 'flag_history_dj_1740', description: '吉布提 1740年国旗' }
    ]
  },
  {
    countryCode: 'dk',
    history: [
      { countryCode: 'dk', year: 1700, imagePath: 'flag_history_dk_1700', description: '丹麦 1700年国旗' },
      { countryCode: 'dk', year: 1710, imagePath: 'flag_history_dk_1710', description: '丹麦 1710年国旗' },
      { countryCode: 'dk', year: 1720, imagePath: 'flag_history_dk_1720', description: '丹麦 1720年国旗' }
    ]
  },
  {
    countryCode: 'dm',
    history: [
      { countryCode: 'dm', year: 1700, imagePath: 'flag_history_dm_1700', description: '多米尼克 1700年国旗' },
      { countryCode: 'dm', year: 1710, imagePath: 'flag_history_dm_1710', description: '多米尼克 1710年国旗' },
      { countryCode: 'dm', year: 1720, imagePath: 'flag_history_dm_1720', description: '多米尼克 1720年国旗' },
      { countryCode: 'dm', year: 1730, imagePath: 'flag_history_dm_1730', description: '多米尼克 1730年国旗' },
      { countryCode: 'dm', year: 1740, imagePath: 'flag_history_dm_1740', description: '多米尼克 1740年国旗' },
      { countryCode: 'dm', year: 1750, imagePath: 'flag_history_dm_1750', description: '多米尼克 1750年国旗' },
      { countryCode: 'dm', year: 1760, imagePath: 'flag_history_dm_1760', description: '多米尼克 1760年国旗' },
      { countryCode: 'dm', year: 1770, imagePath: 'flag_history_dm_1770', description: '多米尼克 1770年国旗' },
      { countryCode: 'dm', year: 1780, imagePath: 'flag_history_dm_1780', description: '多米尼克 1780年国旗' },
      { countryCode: 'dm', year: 1790, imagePath: 'flag_history_dm_1790', description: '多米尼克 1790年国旗' },
      { countryCode: 'dm', year: 1800, imagePath: 'flag_history_dm_1800', description: '多米尼克 1800年国旗' }
    ]
  },
  {
    countryCode: 'do',
    history: [
      { countryCode: 'do', year: 1700, imagePath: 'flag_history_do_1700', description: '多米尼加 1700年国旗' },
      { countryCode: 'do', year: 1710, imagePath: 'flag_history_do_1710', description: '多米尼加 1710年国旗' },
      { countryCode: 'do', year: 1720, imagePath: 'flag_history_do_1720', description: '多米尼加 1720年国旗' },
      { countryCode: 'do', year: 1730, imagePath: 'flag_history_do_1730', description: '多米尼加 1730年国旗' },
      { countryCode: 'do', year: 1740, imagePath: 'flag_history_do_1740', description: '多米尼加 1740年国旗' },
      { countryCode: 'do', year: 1750, imagePath: 'flag_history_do_1750', description: '多米尼加 1750年国旗' },
      { countryCode: 'do', year: 1760, imagePath: 'flag_history_do_1760', description: '多米尼加 1760年国旗' },
      { countryCode: 'do', year: 1770, imagePath: 'flag_history_do_1770', description: '多米尼加 1770年国旗' }
    ]
  },
  {
    countryCode: 'dz',
    history: [
      { countryCode: 'dz', year: 1700, imagePath: 'flag_history_dz_1700', description: '阿尔及利亚 1700年国旗' },
      { countryCode: 'dz', year: 1710, imagePath: 'flag_history_dz_1710', description: '阿尔及利亚 1710年国旗' },
      { countryCode: 'dz', year: 1720, imagePath: 'flag_history_dz_1720', description: '阿尔及利亚 1720年国旗' }
    ]
  },
  {
    countryCode: 'ec',
    history: [
      { countryCode: 'ec', year: 1700, imagePath: 'flag_history_ec_1700', description: '厄瓜多尔 1700年国旗' },
      { countryCode: 'ec', year: 1710, imagePath: 'flag_history_ec_1710', description: '厄瓜多尔 1710年国旗' },
      { countryCode: 'ec', year: 1720, imagePath: 'flag_history_ec_1720', description: '厄瓜多尔 1720年国旗' },
      { countryCode: 'ec', year: 1730, imagePath: 'flag_history_ec_1730', description: '厄瓜多尔 1730年国旗' },
      { countryCode: 'ec', year: 1740, imagePath: 'flag_history_ec_1740', description: '厄瓜多尔 1740年国旗' },
      { countryCode: 'ec', year: 1750, imagePath: 'flag_history_ec_1750', description: '厄瓜多尔 1750年国旗' },
      { countryCode: 'ec', year: 1760, imagePath: 'flag_history_ec_1760', description: '厄瓜多尔 1760年国旗' },
      { countryCode: 'ec', year: 1770, imagePath: 'flag_history_ec_1770', description: '厄瓜多尔 1770年国旗' },
      { countryCode: 'ec', year: 1780, imagePath: 'flag_history_ec_1780', description: '厄瓜多尔 1780年国旗' },
      { countryCode: 'ec', year: 1790, imagePath: 'flag_history_ec_1790', description: '厄瓜多尔 1790年国旗' },
      { countryCode: 'ec', year: 1800, imagePath: 'flag_history_ec_1800', description: '厄瓜多尔 1800年国旗' }
    ]
  },
  {
    countryCode: 'ee',
    history: [
      { countryCode: 'ee', year: 1700, imagePath: 'flag_history_ee_1700', description: '爱沙尼亚 1700年国旗' },
      { countryCode: 'ee', year: 1710, imagePath: 'flag_history_ee_1710', description: '爱沙尼亚 1710年国旗' },
      { countryCode: 'ee', year: 1720, imagePath: 'flag_history_ee_1720', description: '爱沙尼亚 1720年国旗' },
      { countryCode: 'ee', year: 1730, imagePath: 'flag_history_ee_1730', description: '爱沙尼亚 1730年国旗' },
      { countryCode: 'ee', year: 1740, imagePath: 'flag_history_ee_1740', description: '爱沙尼亚 1740年国旗' },
      { countryCode: 'ee', year: 1750, imagePath: 'flag_history_ee_1750', description: '爱沙尼亚 1750年国旗' },
      { countryCode: 'ee', year: 1760, imagePath: 'flag_history_ee_1760', description: '爱沙尼亚 1760年国旗' },
      { countryCode: 'ee', year: 1770, imagePath: 'flag_history_ee_1770', description: '爱沙尼亚 1770年国旗' }
    ]
  },
  {
    countryCode: 'eg',
    history: [
      { countryCode: 'eg', year: 1700, imagePath: 'flag_history_eg_1700', description: '埃及 1700年国旗' },
      { countryCode: 'eg', year: 1710, imagePath: 'flag_history_eg_1710', description: '埃及 1710年国旗' },
      { countryCode: 'eg', year: 1720, imagePath: 'flag_history_eg_1720', description: '埃及 1720年国旗' },
      { countryCode: 'eg', year: 1730, imagePath: 'flag_history_eg_1730', description: '埃及 1730年国旗' },
      { countryCode: 'eg', year: 1740, imagePath: 'flag_history_eg_1740', description: '埃及 1740年国旗' },
      { countryCode: 'eg', year: 1750, imagePath: 'flag_history_eg_1750', description: '埃及 1750年国旗' },
      { countryCode: 'eg', year: 1760, imagePath: 'flag_history_eg_1760', description: '埃及 1760年国旗' },
      { countryCode: 'eg', year: 1770, imagePath: 'flag_history_eg_1770', description: '埃及 1770年国旗' }
    ]
  },
  {
    countryCode: 'eh',
    history: [
      { countryCode: 'eh', year: 1700, imagePath: 'flag_history_eh_1700', description: '西撒哈拉 1700年国旗' },
      { countryCode: 'eh', year: 1710, imagePath: 'flag_history_eh_1710', description: '西撒哈拉 1710年国旗' }
    ]
  },
  {
    countryCode: 'er',
    history: [
      { countryCode: 'er', year: 1700, imagePath: 'flag_history_er_1700', description: '厄立特里亚 1700年国旗' },
      { countryCode: 'er', year: 1710, imagePath: 'flag_history_er_1710', description: '厄立特里亚 1710年国旗' },
      { countryCode: 'er', year: 1720, imagePath: 'flag_history_er_1720', description: '厄立特里亚 1720年国旗' },
      { countryCode: 'er', year: 1730, imagePath: 'flag_history_er_1730', description: '厄立特里亚 1730年国旗' },
      { countryCode: 'er', year: 1740, imagePath: 'flag_history_er_1740', description: '厄立特里亚 1740年国旗' },
      { countryCode: 'er', year: 1750, imagePath: 'flag_history_er_1750', description: '厄立特里亚 1750年国旗' },
      { countryCode: 'er', year: 1760, imagePath: 'flag_history_er_1760', description: '厄立特里亚 1760年国旗' },
      { countryCode: 'er', year: 1770, imagePath: 'flag_history_er_1770', description: '厄立特里亚 1770年国旗' },
      { countryCode: 'er', year: 1780, imagePath: 'flag_history_er_1780', description: '厄立特里亚 1780年国旗' },
      { countryCode: 'er', year: 1790, imagePath: 'flag_history_er_1790', description: '厄立特里亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'es',
    history: [
      { countryCode: 'es', year: 1700, imagePath: 'flag_history_es_1700', description: '西班牙 1700年国旗' },
      { countryCode: 'es', year: 1710, imagePath: 'flag_history_es_1710', description: '西班牙 1710年国旗' },
      { countryCode: 'es', year: 1720, imagePath: 'flag_history_es_1720', description: '西班牙 1720年国旗' },
      { countryCode: 'es', year: 1730, imagePath: 'flag_history_es_1730', description: '西班牙 1730年国旗' },
      { countryCode: 'es', year: 1740, imagePath: 'flag_history_es_1740', description: '西班牙 1740年国旗' },
      { countryCode: 'es', year: 1750, imagePath: 'flag_history_es_1750', description: '西班牙 1750年国旗' },
      { countryCode: 'es', year: 1760, imagePath: 'flag_history_es_1760', description: '西班牙 1760年国旗' },
      { countryCode: 'es', year: 1770, imagePath: 'flag_history_es_1770', description: '西班牙 1770年国旗' },
      { countryCode: 'es', year: 1780, imagePath: 'flag_history_es_1780', description: '西班牙 1780年国旗' },
      { countryCode: 'es', year: 1790, imagePath: 'flag_history_es_1790', description: '西班牙 1790年国旗' },
      { countryCode: 'es', year: 1800, imagePath: 'flag_history_es_1800', description: '西班牙 1800年国旗' },
      { countryCode: 'es', year: 1810, imagePath: 'flag_history_es_1810', description: '西班牙 1810年国旗' }
    ]
  },
  {
    countryCode: 'et',
    history: [
      { countryCode: 'et', year: 1700, imagePath: 'flag_history_et_1700', description: '埃塞俄比亚 1700年国旗' },
      { countryCode: 'et', year: 1710, imagePath: 'flag_history_et_1710', description: '埃塞俄比亚 1710年国旗' },
      { countryCode: 'et', year: 1720, imagePath: 'flag_history_et_1720', description: '埃塞俄比亚 1720年国旗' },
      { countryCode: 'et', year: 1730, imagePath: 'flag_history_et_1730', description: '埃塞俄比亚 1730年国旗' },
      { countryCode: 'et', year: 1740, imagePath: 'flag_history_et_1740', description: '埃塞俄比亚 1740年国旗' },
      { countryCode: 'et', year: 1750, imagePath: 'flag_history_et_1750', description: '埃塞俄比亚 1750年国旗' },
      { countryCode: 'et', year: 1760, imagePath: 'flag_history_et_1760', description: '埃塞俄比亚 1760年国旗' },
      { countryCode: 'et', year: 1770, imagePath: 'flag_history_et_1770', description: '埃塞俄比亚 1770年国旗' },
      { countryCode: 'et', year: 1780, imagePath: 'flag_history_et_1780', description: '埃塞俄比亚 1780年国旗' },
      { countryCode: 'et', year: 1790, imagePath: 'flag_history_et_1790', description: '埃塞俄比亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'fi',
    history: [
      { countryCode: 'fi', year: 1700, imagePath: 'flag_history_fi_1700', description: '芬兰 1700年国旗' },
      { countryCode: 'fi', year: 1710, imagePath: 'flag_history_fi_1710', description: '芬兰 1710年国旗' },
      { countryCode: 'fi', year: 1720, imagePath: 'flag_history_fi_1720', description: '芬兰 1720年国旗' },
      { countryCode: 'fi', year: 1730, imagePath: 'flag_history_fi_1730', description: '芬兰 1730年国旗' },
      { countryCode: 'fi', year: 1740, imagePath: 'flag_history_fi_1740', description: '芬兰 1740年国旗' },
      { countryCode: 'fi', year: 1750, imagePath: 'flag_history_fi_1750', description: '芬兰 1750年国旗' }
    ]
  },
  {
    countryCode: 'fj',
    history: [
      { countryCode: 'fj', year: 1700, imagePath: 'flag_history_fj_1700', description: '斐济 1700年国旗' },
      { countryCode: 'fj', year: 1710, imagePath: 'flag_history_fj_1710', description: '斐济 1710年国旗' },
      { countryCode: 'fj', year: 1720, imagePath: 'flag_history_fj_1720', description: '斐济 1720年国旗' },
      { countryCode: 'fj', year: 1730, imagePath: 'flag_history_fj_1730', description: '斐济 1730年国旗' }
    ]
  },
  {
    countryCode: 'fm',
    history: [
      { countryCode: 'fm', year: 1700, imagePath: 'flag_history_fm_1700', description: '密克罗尼西亚联邦 1700年国旗' },
      { countryCode: 'fm', year: 1710, imagePath: 'flag_history_fm_1710', description: '密克罗尼西亚联邦 1710年国旗' },
      { countryCode: 'fm', year: 1720, imagePath: 'flag_history_fm_1720', description: '密克罗尼西亚联邦 1720年国旗' },
      { countryCode: 'fm', year: 1730, imagePath: 'flag_history_fm_1730', description: '密克罗尼西亚联邦 1730年国旗' },
      { countryCode: 'fm', year: 1740, imagePath: 'flag_history_fm_1740', description: '密克罗尼西亚联邦 1740年国旗' },
      { countryCode: 'fm', year: 1750, imagePath: 'flag_history_fm_1750', description: '密克罗尼西亚联邦 1750年国旗' },
      { countryCode: 'fm', year: 1760, imagePath: 'flag_history_fm_1760', description: '密克罗尼西亚联邦 1760年国旗' },
      { countryCode: 'fm', year: 1770, imagePath: 'flag_history_fm_1770', description: '密克罗尼西亚联邦 1770年国旗' }
    ]
  },
  {
    countryCode: 'fr',
    history: [
      { countryCode: 'fr', year: 1700, imagePath: 'flag_history_fr_1700', description: '法国 1700年国旗' },
      { countryCode: 'fr', year: 1710, imagePath: 'flag_history_fr_1710', description: '法国 1710年国旗' },
      { countryCode: 'fr', year: 1720, imagePath: 'flag_history_fr_1720', description: '法国 1720年国旗' },
      { countryCode: 'fr', year: 1730, imagePath: 'flag_history_fr_1730', description: '法国 1730年国旗' },
      { countryCode: 'fr', year: 1740, imagePath: 'flag_history_fr_1740', description: '法国 1740年国旗' }
    ]
  },
  {
    countryCode: 'ga',
    history: [
      { countryCode: 'ga', year: 1700, imagePath: 'flag_history_ga_1700', description: '加蓬 1700年国旗' },
      { countryCode: 'ga', year: 1710, imagePath: 'flag_history_ga_1710', description: '加蓬 1710年国旗' },
      { countryCode: 'ga', year: 1720, imagePath: 'flag_history_ga_1720', description: '加蓬 1720年国旗' },
      { countryCode: 'ga', year: 1730, imagePath: 'flag_history_ga_1730', description: '加蓬 1730年国旗' }
    ]
  },
  {
    countryCode: 'gb',
    history: [
      { countryCode: 'gb', year: 1700, imagePath: 'flag_history_gb_1700', description: '英国 1700年国旗' },
      { countryCode: 'gb', year: 1710, imagePath: 'flag_history_gb_1710', description: '英国 1710年国旗' }
    ]
  },
  {
    countryCode: 'gd',
    history: [
      { countryCode: 'gd', year: 1700, imagePath: 'flag_history_gd_1700', description: '格林纳达 1700年国旗' },
      { countryCode: 'gd', year: 1710, imagePath: 'flag_history_gd_1710', description: '格林纳达 1710年国旗' },
      { countryCode: 'gd', year: 1720, imagePath: 'flag_history_gd_1720', description: '格林纳达 1720年国旗' },
      { countryCode: 'gd', year: 1730, imagePath: 'flag_history_gd_1730', description: '格林纳达 1730年国旗' },
      { countryCode: 'gd', year: 1740, imagePath: 'flag_history_gd_1740', description: '格林纳达 1740年国旗' },
      { countryCode: 'gd', year: 1750, imagePath: 'flag_history_gd_1750', description: '格林纳达 1750年国旗' },
      { countryCode: 'gd', year: 1760, imagePath: 'flag_history_gd_1760', description: '格林纳达 1760年国旗' },
      { countryCode: 'gd', year: 1770, imagePath: 'flag_history_gd_1770', description: '格林纳达 1770年国旗' },
      { countryCode: 'gd', year: 1780, imagePath: 'flag_history_gd_1780', description: '格林纳达 1780年国旗' },
      { countryCode: 'gd', year: 1790, imagePath: 'flag_history_gd_1790', description: '格林纳达 1790年国旗' }
    ]
  },
  {
    countryCode: 'ge',
    history: [
      { countryCode: 'ge', year: 1710, imagePath: 'flag_history_ge_1710', description: '格鲁吉亚 1710年国旗' },
      { countryCode: 'ge', year: 1720, imagePath: 'flag_history_ge_1720', description: '格鲁吉亚 1720年国旗' },
      { countryCode: 'ge', year: 1730, imagePath: 'flag_history_ge_1730', description: '格鲁吉亚 1730年国旗' },
      { countryCode: 'ge', year: 1740, imagePath: 'flag_history_ge_1740', description: '格鲁吉亚 1740年国旗' },
      { countryCode: 'ge', year: 1750, imagePath: 'flag_history_ge_1750', description: '格鲁吉亚 1750年国旗' },
      { countryCode: 'ge', year: 1760, imagePath: 'flag_history_ge_1760', description: '格鲁吉亚 1760年国旗' },
      { countryCode: 'ge', year: 1770, imagePath: 'flag_history_ge_1770', description: '格鲁吉亚 1770年国旗' },
      { countryCode: 'ge', year: 1780, imagePath: 'flag_history_ge_1780', description: '格鲁吉亚 1780年国旗' },
      { countryCode: 'ge', year: 1790, imagePath: 'flag_history_ge_1790', description: '格鲁吉亚 1790年国旗' },
      { countryCode: 'ge', year: 1800, imagePath: 'flag_history_ge_1800', description: '格鲁吉亚 1800年国旗' },
      { countryCode: 'ge', year: 1810, imagePath: 'flag_history_ge_1810', description: '格鲁吉亚 1810年国旗' },
      { countryCode: 'ge', year: 1820, imagePath: 'flag_history_ge_1820', description: '格鲁吉亚 1820年国旗' },
      { countryCode: 'ge', year: 1830, imagePath: 'flag_history_ge_1830', description: '格鲁吉亚 1830年国旗' }
    ]
  },
  {
    countryCode: 'gh',
    history: [
      { countryCode: 'gh', year: 1700, imagePath: 'flag_history_gh_1700', description: '加纳 1700年国旗' },
      { countryCode: 'gh', year: 1720, imagePath: 'flag_history_gh_1720', description: '加纳 1720年国旗' },
      { countryCode: 'gh', year: 1730, imagePath: 'flag_history_gh_1730', description: '加纳 1730年国旗' },
      { countryCode: 'gh', year: 1740, imagePath: 'flag_history_gh_1740', description: '加纳 1740年国旗' },
      { countryCode: 'gh', year: 1750, imagePath: 'flag_history_gh_1750', description: '加纳 1750年国旗' },
      { countryCode: 'gh', year: 1760, imagePath: 'flag_history_gh_1760', description: '加纳 1760年国旗' },
      { countryCode: 'gh', year: 1770, imagePath: 'flag_history_gh_1770', description: '加纳 1770年国旗' }
    ]
  },
  {
    countryCode: 'gm',
    history: [
      { countryCode: 'gm', year: 1700, imagePath: 'flag_history_gm_1700', description: '冈比亚 1700年国旗' },
      { countryCode: 'gm', year: 1710, imagePath: 'flag_history_gm_1710', description: '冈比亚 1710年国旗' },
      { countryCode: 'gm', year: 1720, imagePath: 'flag_history_gm_1720', description: '冈比亚 1720年国旗' },
      { countryCode: 'gm', year: 1730, imagePath: 'flag_history_gm_1730', description: '冈比亚 1730年国旗' }
    ]
  },
  {
    countryCode: 'gn',
    history: [
      { countryCode: 'gn', year: 1700, imagePath: 'flag_history_gn_1700', description: '几内亚 1700年国旗' },
      { countryCode: 'gn', year: 1710, imagePath: 'flag_history_gn_1710', description: '几内亚 1710年国旗' },
      { countryCode: 'gn', year: 1720, imagePath: 'flag_history_gn_1720', description: '几内亚 1720年国旗' }
    ]
  },
  {
    countryCode: 'gq',
    history: [
      { countryCode: 'gq', year: 1700, imagePath: 'flag_history_gq_1700', description: '赤道几内亚 1700年国旗' },
      { countryCode: 'gq', year: 1710, imagePath: 'flag_history_gq_1710', description: '赤道几内亚 1710年国旗' },
      { countryCode: 'gq', year: 1720, imagePath: 'flag_history_gq_1720', description: '赤道几内亚 1720年国旗' },
      { countryCode: 'gq', year: 1730, imagePath: 'flag_history_gq_1730', description: '赤道几内亚 1730年国旗' },
      { countryCode: 'gq', year: 1740, imagePath: 'flag_history_gq_1740', description: '赤道几内亚 1740年国旗' },
      { countryCode: 'gq', year: 1750, imagePath: 'flag_history_gq_1750', description: '赤道几内亚 1750年国旗' },
      { countryCode: 'gq', year: 1760, imagePath: 'flag_history_gq_1760', description: '赤道几内亚 1760年国旗' },
      { countryCode: 'gq', year: 1770, imagePath: 'flag_history_gq_1770', description: '赤道几内亚 1770年国旗' },
      { countryCode: 'gq', year: 1780, imagePath: 'flag_history_gq_1780', description: '赤道几内亚 1780年国旗' },
      { countryCode: 'gq', year: 1790, imagePath: 'flag_history_gq_1790', description: '赤道几内亚 1790年国旗' },
      { countryCode: 'gq', year: 1800, imagePath: 'flag_history_gq_1800', description: '赤道几内亚 1800年国旗' },
      { countryCode: 'gq', year: 1810, imagePath: 'flag_history_gq_1810', description: '赤道几内亚 1810年国旗' }
    ]
  },
  {
    countryCode: 'gr',
    history: [
      { countryCode: 'gr', year: 1700, imagePath: 'flag_history_gr_1700', description: '希腊 1700年国旗' },
      { countryCode: 'gr', year: 1710, imagePath: 'flag_history_gr_1710', description: '希腊 1710年国旗' },
      { countryCode: 'gr', year: 1720, imagePath: 'flag_history_gr_1720', description: '希腊 1720年国旗' },
      { countryCode: 'gr', year: 1730, imagePath: 'flag_history_gr_1730', description: '希腊 1730年国旗' },
      { countryCode: 'gr', year: 1740, imagePath: 'flag_history_gr_1740', description: '希腊 1740年国旗' },
      { countryCode: 'gr', year: 1750, imagePath: 'flag_history_gr_1750', description: '希腊 1750年国旗' },
      { countryCode: 'gr', year: 1760, imagePath: 'flag_history_gr_1760', description: '希腊 1760年国旗' },
      { countryCode: 'gr', year: 1770, imagePath: 'flag_history_gr_1770', description: '希腊 1770年国旗' },
      { countryCode: 'gr', year: 1780, imagePath: 'flag_history_gr_1780', description: '希腊 1780年国旗' },
      { countryCode: 'gr', year: 1790, imagePath: 'flag_history_gr_1790', description: '希腊 1790年国旗' },
      { countryCode: 'gr', year: 1800, imagePath: 'flag_history_gr_1800', description: '希腊 1800年国旗' },
      { countryCode: 'gr', year: 1810, imagePath: 'flag_history_gr_1810', description: '希腊 1810年国旗' },
      { countryCode: 'gr', year: 1820, imagePath: 'flag_history_gr_1820', description: '希腊 1820年国旗' }
    ]
  },
  {
    countryCode: 'gt',
    history: [
      { countryCode: 'gt', year: 1700, imagePath: 'flag_history_gt_1700', description: '危地马拉 1700年国旗' },
      { countryCode: 'gt', year: 1710, imagePath: 'flag_history_gt_1710', description: '危地马拉 1710年国旗' },
      { countryCode: 'gt', year: 1720, imagePath: 'flag_history_gt_1720', description: '危地马拉 1720年国旗' },
      { countryCode: 'gt', year: 1730, imagePath: 'flag_history_gt_1730', description: '危地马拉 1730年国旗' },
      { countryCode: 'gt', year: 1740, imagePath: 'flag_history_gt_1740', description: '危地马拉 1740年国旗' },
      { countryCode: 'gt', year: 1750, imagePath: 'flag_history_gt_1750', description: '危地马拉 1750年国旗' },
      { countryCode: 'gt', year: 1760, imagePath: 'flag_history_gt_1760', description: '危地马拉 1760年国旗' },
      { countryCode: 'gt', year: 1770, imagePath: 'flag_history_gt_1770', description: '危地马拉 1770年国旗' },
      { countryCode: 'gt', year: 1780, imagePath: 'flag_history_gt_1780', description: '危地马拉 1780年国旗' }
    ]
  },
  {
    countryCode: 'gw',
    history: [
      { countryCode: 'gw', year: 1700, imagePath: 'flag_history_gw_1700', description: '几内亚比绍 1700年国旗' },
      { countryCode: 'gw', year: 1710, imagePath: 'flag_history_gw_1710', description: '几内亚比绍 1710年国旗' },
      { countryCode: 'gw', year: 1720, imagePath: 'flag_history_gw_1720', description: '几内亚比绍 1720年国旗' },
      { countryCode: 'gw', year: 1730, imagePath: 'flag_history_gw_1730', description: '几内亚比绍 1730年国旗' },
      { countryCode: 'gw', year: 1740, imagePath: 'flag_history_gw_1740', description: '几内亚比绍 1740年国旗' },
      { countryCode: 'gw', year: 1750, imagePath: 'flag_history_gw_1750', description: '几内亚比绍 1750年国旗' },
      { countryCode: 'gw', year: 1760, imagePath: 'flag_history_gw_1760', description: '几内亚比绍 1760年国旗' },
      { countryCode: 'gw', year: 1770, imagePath: 'flag_history_gw_1770', description: '几内亚比绍 1770年国旗' }
    ]
  },
  {
    countryCode: 'gy',
    history: [
      { countryCode: 'gy', year: 1700, imagePath: 'flag_history_gy_1700', description: '圭亚那 1700年国旗' },
      { countryCode: 'gy', year: 1710, imagePath: 'flag_history_gy_1710', description: '圭亚那 1710年国旗' },
      { countryCode: 'gy', year: 1720, imagePath: 'flag_history_gy_1720', description: '圭亚那 1720年国旗' },
      { countryCode: 'gy', year: 1730, imagePath: 'flag_history_gy_1730', description: '圭亚那 1730年国旗' },
      { countryCode: 'gy', year: 1740, imagePath: 'flag_history_gy_1740', description: '圭亚那 1740年国旗' },
      { countryCode: 'gy', year: 1750, imagePath: 'flag_history_gy_1750', description: '圭亚那 1750年国旗' }
    ]
  },
  {
    countryCode: 'hn',
    history: [
      { countryCode: 'hn', year: 1700, imagePath: 'flag_history_hn_1700', description: '洪都拉斯 1700年国旗' },
      { countryCode: 'hn', year: 1710, imagePath: 'flag_history_hn_1710', description: '洪都拉斯 1710年国旗' },
      { countryCode: 'hn', year: 1720, imagePath: 'flag_history_hn_1720', description: '洪都拉斯 1720年国旗' },
      { countryCode: 'hn', year: 1730, imagePath: 'flag_history_hn_1730', description: '洪都拉斯 1730年国旗' },
      { countryCode: 'hn', year: 1740, imagePath: 'flag_history_hn_1740', description: '洪都拉斯 1740年国旗' },
      { countryCode: 'hn', year: 1750, imagePath: 'flag_history_hn_1750', description: '洪都拉斯 1750年国旗' },
      { countryCode: 'hn', year: 1760, imagePath: 'flag_history_hn_1760', description: '洪都拉斯 1760年国旗' },
      { countryCode: 'hn', year: 1770, imagePath: 'flag_history_hn_1770', description: '洪都拉斯 1770年国旗' }
    ]
  },
  {
    countryCode: 'hr',
    history: [
      { countryCode: 'hr', year: 1700, imagePath: 'flag_history_hr_1700', description: '克罗地亚 1700年国旗' },
      { countryCode: 'hr', year: 1710, imagePath: 'flag_history_hr_1710', description: '克罗地亚 1710年国旗' },
      { countryCode: 'hr', year: 1720, imagePath: 'flag_history_hr_1720', description: '克罗地亚 1720年国旗' },
      { countryCode: 'hr', year: 1730, imagePath: 'flag_history_hr_1730', description: '克罗地亚 1730年国旗' },
      { countryCode: 'hr', year: 1740, imagePath: 'flag_history_hr_1740', description: '克罗地亚 1740年国旗' },
      { countryCode: 'hr', year: 1750, imagePath: 'flag_history_hr_1750', description: '克罗地亚 1750年国旗' },
      { countryCode: 'hr', year: 1760, imagePath: 'flag_history_hr_1760', description: '克罗地亚 1760年国旗' },
      { countryCode: 'hr', year: 1770, imagePath: 'flag_history_hr_1770', description: '克罗地亚 1770年国旗' },
      { countryCode: 'hr', year: 1780, imagePath: 'flag_history_hr_1780', description: '克罗地亚 1780年国旗' },
      { countryCode: 'hr', year: 1790, imagePath: 'flag_history_hr_1790', description: '克罗地亚 1790年国旗' },
      { countryCode: 'hr', year: 1800, imagePath: 'flag_history_hr_1800', description: '克罗地亚 1800年国旗' }
    ]
  },
  {
    countryCode: 'ht',
    history: [
      { countryCode: 'ht', year: 1700, imagePath: 'flag_history_ht_1700', description: '海地 1700年国旗' },
      { countryCode: 'ht', year: 1710, imagePath: 'flag_history_ht_1710', description: '海地 1710年国旗' },
      { countryCode: 'ht', year: 1720, imagePath: 'flag_history_ht_1720', description: '海地 1720年国旗' },
      { countryCode: 'ht', year: 1730, imagePath: 'flag_history_ht_1730', description: '海地 1730年国旗' },
      { countryCode: 'ht', year: 1740, imagePath: 'flag_history_ht_1740', description: '海地 1740年国旗' },
      { countryCode: 'ht', year: 1750, imagePath: 'flag_history_ht_1750', description: '海地 1750年国旗' },
      { countryCode: 'ht', year: 1760, imagePath: 'flag_history_ht_1760', description: '海地 1760年国旗' },
      { countryCode: 'ht', year: 1770, imagePath: 'flag_history_ht_1770', description: '海地 1770年国旗' },
      { countryCode: 'ht', year: 1780, imagePath: 'flag_history_ht_1780', description: '海地 1780年国旗' },
      { countryCode: 'ht', year: 1790, imagePath: 'flag_history_ht_1790', description: '海地 1790年国旗' }
    ]
  },
  {
    countryCode: 'hu',
    history: [
      { countryCode: 'hu', year: 1700, imagePath: 'flag_history_hu_1700', description: '匈牙利 1700年国旗' },
      { countryCode: 'hu', year: 1710, imagePath: 'flag_history_hu_1710', description: '匈牙利 1710年国旗' },
      { countryCode: 'hu', year: 1720, imagePath: 'flag_history_hu_1720', description: '匈牙利 1720年国旗' },
      { countryCode: 'hu', year: 1730, imagePath: 'flag_history_hu_1730', description: '匈牙利 1730年国旗' },
      { countryCode: 'hu', year: 1740, imagePath: 'flag_history_hu_1740', description: '匈牙利 1740年国旗' },
      { countryCode: 'hu', year: 1750, imagePath: 'flag_history_hu_1750', description: '匈牙利 1750年国旗' },
      { countryCode: 'hu', year: 1760, imagePath: 'flag_history_hu_1760', description: '匈牙利 1760年国旗' },
      { countryCode: 'hu', year: 1770, imagePath: 'flag_history_hu_1770', description: '匈牙利 1770年国旗' },
      { countryCode: 'hu', year: 1780, imagePath: 'flag_history_hu_1780', description: '匈牙利 1780年国旗' },
      { countryCode: 'hu', year: 1790, imagePath: 'flag_history_hu_1790', description: '匈牙利 1790年国旗' },
      { countryCode: 'hu', year: 1800, imagePath: 'flag_history_hu_1800', description: '匈牙利 1800年国旗' },
      { countryCode: 'hu', year: 1810, imagePath: 'flag_history_hu_1810', description: '匈牙利 1810年国旗' },
      { countryCode: 'hu', year: 1820, imagePath: 'flag_history_hu_1820', description: '匈牙利 1820年国旗' }
    ]
  },
  {
    countryCode: 'id',
    history: [
      { countryCode: 'id', year: 1700, imagePath: 'flag_history_id_1700', description: '印尼 1700年国旗' },
      { countryCode: 'id', year: 1710, imagePath: 'flag_history_id_1710', description: '印尼 1710年国旗' },
      { countryCode: 'id', year: 1720, imagePath: 'flag_history_id_1720', description: '印尼 1720年国旗' },
      { countryCode: 'id', year: 1730, imagePath: 'flag_history_id_1730', description: '印尼 1730年国旗' },
      { countryCode: 'id', year: 1740, imagePath: 'flag_history_id_1740', description: '印尼 1740年国旗' }
    ]
  },
  {
    countryCode: 'ie',
    history: [
      { countryCode: 'ie', year: 1700, imagePath: 'flag_history_ie_1700', description: '爱尔兰 1700年国旗' },
      { countryCode: 'ie', year: 1710, imagePath: 'flag_history_ie_1710', description: '爱尔兰 1710年国旗' },
      { countryCode: 'ie', year: 1720, imagePath: 'flag_history_ie_1720', description: '爱尔兰 1720年国旗' }
    ]
  },
  {
    countryCode: 'il',
    history: [
      { countryCode: 'il', year: 1700, imagePath: 'flag_history_il_1700', description: '以色列 1700年国旗' },
      { countryCode: 'il', year: 1710, imagePath: 'flag_history_il_1710', description: '以色列 1710年国旗' },
      { countryCode: 'il', year: 1720, imagePath: 'flag_history_il_1720', description: '以色列 1720年国旗' },
      { countryCode: 'il', year: 1730, imagePath: 'flag_history_il_1730', description: '以色列 1730年国旗' },
      { countryCode: 'il', year: 1740, imagePath: 'flag_history_il_1740', description: '以色列 1740年国旗' }
    ]
  },
  {
    countryCode: 'in',
    history: [
      { countryCode: 'in', year: 1700, imagePath: 'flag_history_in_1700', description: '印度 1700年国旗' },
      { countryCode: 'in', year: 1710, imagePath: 'flag_history_in_1710', description: '印度 1710年国旗' },
      { countryCode: 'in', year: 1720, imagePath: 'flag_history_in_1720', description: '印度 1720年国旗' },
      { countryCode: 'in', year: 1730, imagePath: 'flag_history_in_1730', description: '印度 1730年国旗' },
      { countryCode: 'in', year: 1740, imagePath: 'flag_history_in_1740', description: '印度 1740年国旗' }
    ]
  },
  {
    countryCode: 'iq',
    history: [
      { countryCode: 'iq', year: 1700, imagePath: 'flag_history_iq_1700', description: '伊拉克 1700年国旗' },
      { countryCode: 'iq', year: 1710, imagePath: 'flag_history_iq_1710', description: '伊拉克 1710年国旗' },
      { countryCode: 'iq', year: 1720, imagePath: 'flag_history_iq_1720', description: '伊拉克 1720年国旗' },
      { countryCode: 'iq', year: 1730, imagePath: 'flag_history_iq_1730', description: '伊拉克 1730年国旗' },
      { countryCode: 'iq', year: 1740, imagePath: 'flag_history_iq_1740', description: '伊拉克 1740年国旗' },
      { countryCode: 'iq', year: 1750, imagePath: 'flag_history_iq_1750', description: '伊拉克 1750年国旗' },
      { countryCode: 'iq', year: 1760, imagePath: 'flag_history_iq_1760', description: '伊拉克 1760年国旗' },
      { countryCode: 'iq', year: 1770, imagePath: 'flag_history_iq_1770', description: '伊拉克 1770年国旗' },
      { countryCode: 'iq', year: 1780, imagePath: 'flag_history_iq_1780', description: '伊拉克 1780年国旗' }
    ]
  },
  {
    countryCode: 'ir',
    history: [
      { countryCode: 'ir', year: 1700, imagePath: 'flag_history_ir_1700', description: '伊朗 1700年国旗' },
      { countryCode: 'ir', year: 1710, imagePath: 'flag_history_ir_1710', description: '伊朗 1710年国旗' },
      { countryCode: 'ir', year: 1720, imagePath: 'flag_history_ir_1720', description: '伊朗 1720年国旗' },
      { countryCode: 'ir', year: 1730, imagePath: 'flag_history_ir_1730', description: '伊朗 1730年国旗' },
      { countryCode: 'ir', year: 1740, imagePath: 'flag_history_ir_1740', description: '伊朗 1740年国旗' },
      { countryCode: 'ir', year: 1750, imagePath: 'flag_history_ir_1750', description: '伊朗 1750年国旗' },
      { countryCode: 'ir', year: 1760, imagePath: 'flag_history_ir_1760', description: '伊朗 1760年国旗' },
      { countryCode: 'ir', year: 1770, imagePath: 'flag_history_ir_1770', description: '伊朗 1770年国旗' },
      { countryCode: 'ir', year: 1780, imagePath: 'flag_history_ir_1780', description: '伊朗 1780年国旗' }
    ]
  },
  {
    countryCode: 'is',
    history: [
      { countryCode: 'is', year: 1700, imagePath: 'flag_history_is_1700', description: '冰岛 1700年国旗' },
      { countryCode: 'is', year: 1710, imagePath: 'flag_history_is_1710', description: '冰岛 1710年国旗' },
      { countryCode: 'is', year: 1720, imagePath: 'flag_history_is_1720', description: '冰岛 1720年国旗' },
      { countryCode: 'is', year: 1730, imagePath: 'flag_history_is_1730', description: '冰岛 1730年国旗' }
    ]
  },
  {
    countryCode: 'it',
    history: [
      { countryCode: 'it', year: 1700, imagePath: 'flag_history_it_1700', description: '意大利 1700年国旗' },
      { countryCode: 'it', year: 1710, imagePath: 'flag_history_it_1710', description: '意大利 1710年国旗' },
      { countryCode: 'it', year: 1720, imagePath: 'flag_history_it_1720', description: '意大利 1720年国旗' },
      { countryCode: 'it', year: 1730, imagePath: 'flag_history_it_1730', description: '意大利 1730年国旗' },
      { countryCode: 'it', year: 1740, imagePath: 'flag_history_it_1740', description: '意大利 1740年国旗' },
      { countryCode: 'it', year: 1750, imagePath: 'flag_history_it_1750', description: '意大利 1750年国旗' }
    ]
  },
  {
    countryCode: 'jm',
    history: [
      { countryCode: 'jm', year: 1700, imagePath: 'flag_history_jm_1700', description: '牙买加 1700年国旗' },
      { countryCode: 'jm', year: 1710, imagePath: 'flag_history_jm_1710', description: '牙买加 1710年国旗' },
      { countryCode: 'jm', year: 1720, imagePath: 'flag_history_jm_1720', description: '牙买加 1720年国旗' },
      { countryCode: 'jm', year: 1730, imagePath: 'flag_history_jm_1730', description: '牙买加 1730年国旗' },
      { countryCode: 'jm', year: 1740, imagePath: 'flag_history_jm_1740', description: '牙买加 1740年国旗' },
      { countryCode: 'jm', year: 1750, imagePath: 'flag_history_jm_1750', description: '牙买加 1750年国旗' }
    ]
  },
  {
    countryCode: 'jo',
    history: [
      { countryCode: 'jo', year: 1700, imagePath: 'flag_history_jo_1700', description: '约旦 1700年国旗' },
      { countryCode: 'jo', year: 1710, imagePath: 'flag_history_jo_1710', description: '约旦 1710年国旗' },
      { countryCode: 'jo', year: 1720, imagePath: 'flag_history_jo_1720', description: '约旦 1720年国旗' },
      { countryCode: 'jo', year: 1730, imagePath: 'flag_history_jo_1730', description: '约旦 1730年国旗' }
    ]
  },
  {
    countryCode: 'jp',
    history: [
      { countryCode: 'jp', year: 1700, imagePath: 'flag_history_jp_1700', description: '日本 1700年国旗' },
      { countryCode: 'jp', year: 1710, imagePath: 'flag_history_jp_1710', description: '日本 1710年国旗' },
      { countryCode: 'jp', year: 1720, imagePath: 'flag_history_jp_1720', description: '日本 1720年国旗' },
      { countryCode: 'jp', year: 1730, imagePath: 'flag_history_jp_1730', description: '日本 1730年国旗' },
      { countryCode: 'jp', year: 1740, imagePath: 'flag_history_jp_1740', description: '日本 1740年国旗' },
      { countryCode: 'jp', year: 1750, imagePath: 'flag_history_jp_1750', description: '日本 1750年国旗' },
      { countryCode: 'jp', year: 1760, imagePath: 'flag_history_jp_1760', description: '日本 1760年国旗' },
      { countryCode: 'jp', year: 1770, imagePath: 'flag_history_jp_1770', description: '日本 1770年国旗' },
      { countryCode: 'jp', year: 1780, imagePath: 'flag_history_jp_1780', description: '日本 1780年国旗' }
    ]
  },
  {
    countryCode: 'ke',
    history: [
      { countryCode: 'ke', year: 1700, imagePath: 'flag_history_ke_1700', description: '肯尼亚 1700年国旗' },
      { countryCode: 'ke', year: 1710, imagePath: 'flag_history_ke_1710', description: '肯尼亚 1710年国旗' },
      { countryCode: 'ke', year: 1720, imagePath: 'flag_history_ke_1720', description: '肯尼亚 1720年国旗' },
      { countryCode: 'ke', year: 1730, imagePath: 'flag_history_ke_1730', description: '肯尼亚 1730年国旗' }
    ]
  },
  {
    countryCode: 'kg',
    history: [
      { countryCode: 'kg', year: 1700, imagePath: 'flag_history_kg_1700', description: '吉尔吉斯斯坦 1700年国旗' },
      { countryCode: 'kg', year: 1710, imagePath: 'flag_history_kg_1710', description: '吉尔吉斯斯坦 1710年国旗' },
      { countryCode: 'kg', year: 1720, imagePath: 'flag_history_kg_1720', description: '吉尔吉斯斯坦 1720年国旗' },
      { countryCode: 'kg', year: 1730, imagePath: 'flag_history_kg_1730', description: '吉尔吉斯斯坦 1730年国旗' },
      { countryCode: 'kg', year: 1740, imagePath: 'flag_history_kg_1740', description: '吉尔吉斯斯坦 1740年国旗' },
      { countryCode: 'kg', year: 1750, imagePath: 'flag_history_kg_1750', description: '吉尔吉斯斯坦 1750年国旗' },
      { countryCode: 'kg', year: 1760, imagePath: 'flag_history_kg_1760', description: '吉尔吉斯斯坦 1760年国旗' }
    ]
  },
  {
    countryCode: 'kh',
    history: [
      { countryCode: 'kh', year: 1700, imagePath: 'flag_history_kh_1700', description: '柬埔寨 1700年国旗' },
      { countryCode: 'kh', year: 1710, imagePath: 'flag_history_kh_1710', description: '柬埔寨 1710年国旗' },
      { countryCode: 'kh', year: 1720, imagePath: 'flag_history_kh_1720', description: '柬埔寨 1720年国旗' },
      { countryCode: 'kh', year: 1730, imagePath: 'flag_history_kh_1730', description: '柬埔寨 1730年国旗' },
      { countryCode: 'kh', year: 1740, imagePath: 'flag_history_kh_1740', description: '柬埔寨 1740年国旗' },
      { countryCode: 'kh', year: 1750, imagePath: 'flag_history_kh_1750', description: '柬埔寨 1750年国旗' },
      { countryCode: 'kh', year: 1760, imagePath: 'flag_history_kh_1760', description: '柬埔寨 1760年国旗' },
      { countryCode: 'kh', year: 1770, imagePath: 'flag_history_kh_1770', description: '柬埔寨 1770年国旗' },
      { countryCode: 'kh', year: 1780, imagePath: 'flag_history_kh_1780', description: '柬埔寨 1780年国旗' },
      { countryCode: 'kh', year: 1790, imagePath: 'flag_history_kh_1790', description: '柬埔寨 1790年国旗' }
    ]
  },
  {
    countryCode: 'ki',
    history: [
      { countryCode: 'ki', year: 1700, imagePath: 'flag_history_ki_1700', description: '基里巴斯 1700年国旗' },
      { countryCode: 'ki', year: 1710, imagePath: 'flag_history_ki_1710', description: '基里巴斯 1710年国旗' },
      { countryCode: 'ki', year: 1720, imagePath: 'flag_history_ki_1720', description: '基里巴斯 1720年国旗' },
      { countryCode: 'ki', year: 1730, imagePath: 'flag_history_ki_1730', description: '基里巴斯 1730年国旗' },
      { countryCode: 'ki', year: 1740, imagePath: 'flag_history_ki_1740', description: '基里巴斯 1740年国旗' },
      { countryCode: 'ki', year: 1750, imagePath: 'flag_history_ki_1750', description: '基里巴斯 1750年国旗' }
    ]
  },
  {
    countryCode: 'km',
    history: [
      { countryCode: 'km', year: 1700, imagePath: 'flag_history_km_1700', description: '科摩罗 1700年国旗' },
      { countryCode: 'km', year: 1710, imagePath: 'flag_history_km_1710', description: '科摩罗 1710年国旗' },
      { countryCode: 'km', year: 1720, imagePath: 'flag_history_km_1720', description: '科摩罗 1720年国旗' },
      { countryCode: 'km', year: 1730, imagePath: 'flag_history_km_1730', description: '科摩罗 1730年国旗' },
      { countryCode: 'km', year: 1740, imagePath: 'flag_history_km_1740', description: '科摩罗 1740年国旗' },
      { countryCode: 'km', year: 1750, imagePath: 'flag_history_km_1750', description: '科摩罗 1750年国旗' },
      { countryCode: 'km', year: 1760, imagePath: 'flag_history_km_1760', description: '科摩罗 1760年国旗' },
      { countryCode: 'km', year: 1770, imagePath: 'flag_history_km_1770', description: '科摩罗 1770年国旗' }
    ]
  },
  {
    countryCode: 'kn',
    history: [
      { countryCode: 'kn', year: 1710, imagePath: 'flag_history_kn_1710', description: '圣基茨和尼维斯 1710年国旗' },
      { countryCode: 'kn', year: 1720, imagePath: 'flag_history_kn_1720', description: '圣基茨和尼维斯 1720年国旗' },
      { countryCode: 'kn', year: 1730, imagePath: 'flag_history_kn_1730', description: '圣基茨和尼维斯 1730年国旗' },
      { countryCode: 'kn', year: 1740, imagePath: 'flag_history_kn_1740', description: '圣基茨和尼维斯 1740年国旗' },
      { countryCode: 'kn', year: 1750, imagePath: 'flag_history_kn_1750', description: '圣基茨和尼维斯 1750年国旗' }
    ]
  },
  {
    countryCode: 'kp',
    history: [
      { countryCode: 'kp', year: 1700, imagePath: 'flag_history_kp_1700', description: '朝鲜 1700年国旗' },
      { countryCode: 'kp', year: 1710, imagePath: 'flag_history_kp_1710', description: '朝鲜 1710年国旗' },
      { countryCode: 'kp', year: 1720, imagePath: 'flag_history_kp_1720', description: '朝鲜 1720年国旗' },
      { countryCode: 'kp', year: 1730, imagePath: 'flag_history_kp_1730', description: '朝鲜 1730年国旗' },
      { countryCode: 'kp', year: 1740, imagePath: 'flag_history_kp_1740', description: '朝鲜 1740年国旗' },
      { countryCode: 'kp', year: 1750, imagePath: 'flag_history_kp_1750', description: '朝鲜 1750年国旗' },
      { countryCode: 'kp', year: 1760, imagePath: 'flag_history_kp_1760', description: '朝鲜 1760年国旗' },
      { countryCode: 'kp', year: 1770, imagePath: 'flag_history_kp_1770', description: '朝鲜 1770年国旗' },
      { countryCode: 'kp', year: 1780, imagePath: 'flag_history_kp_1780', description: '朝鲜 1780年国旗' },
      { countryCode: 'kp', year: 1790, imagePath: 'flag_history_kp_1790', description: '朝鲜 1790年国旗' }
    ]
  },
  {
    countryCode: 'kr',
    history: [
      { countryCode: 'kr', year: 1700, imagePath: 'flag_history_kr_1700', description: '韩国 1700年国旗' },
      { countryCode: 'kr', year: 1710, imagePath: 'flag_history_kr_1710', description: '韩国 1710年国旗' },
      { countryCode: 'kr', year: 1720, imagePath: 'flag_history_kr_1720', description: '韩国 1720年国旗' },
      { countryCode: 'kr', year: 1730, imagePath: 'flag_history_kr_1730', description: '韩国 1730年国旗' },
      { countryCode: 'kr', year: 1740, imagePath: 'flag_history_kr_1740', description: '韩国 1740年国旗' },
      { countryCode: 'kr', year: 1750, imagePath: 'flag_history_kr_1750', description: '韩国 1750年国旗' },
      { countryCode: 'kr', year: 1760, imagePath: 'flag_history_kr_1760', description: '韩国 1760年国旗' },
      { countryCode: 'kr', year: 1770, imagePath: 'flag_history_kr_1770', description: '韩国 1770年国旗' },
      { countryCode: 'kr', year: 1780, imagePath: 'flag_history_kr_1780', description: '韩国 1780年国旗' },
      { countryCode: 'kr', year: 1790, imagePath: 'flag_history_kr_1790', description: '韩国 1790年国旗' },
      { countryCode: 'kr', year: 1800, imagePath: 'flag_history_kr_1800', description: '韩国 1800年国旗' }
    ]
  },
  {
    countryCode: 'kw',
    history: [
      { countryCode: 'kw', year: 1700, imagePath: 'flag_history_kw_1700', description: '科威特 1700年国旗' },
      { countryCode: 'kw', year: 1710, imagePath: 'flag_history_kw_1710', description: '科威特 1710年国旗' },
      { countryCode: 'kw', year: 1720, imagePath: 'flag_history_kw_1720', description: '科威特 1720年国旗' },
      { countryCode: 'kw', year: 1730, imagePath: 'flag_history_kw_1730', description: '科威特 1730年国旗' },
      { countryCode: 'kw', year: 1740, imagePath: 'flag_history_kw_1740', description: '科威特 1740年国旗' }
    ]
  },
  {
    countryCode: 'kz',
    history: [
      { countryCode: 'kz', year: 1700, imagePath: 'flag_history_kz_1700', description: '哈萨克斯坦 1700年国旗' },
      { countryCode: 'kz', year: 1710, imagePath: 'flag_history_kz_1710', description: '哈萨克斯坦 1710年国旗' },
      { countryCode: 'kz', year: 1720, imagePath: 'flag_history_kz_1720', description: '哈萨克斯坦 1720年国旗' },
      { countryCode: 'kz', year: 1730, imagePath: 'flag_history_kz_1730', description: '哈萨克斯坦 1730年国旗' },
      { countryCode: 'kz', year: 1740, imagePath: 'flag_history_kz_1740', description: '哈萨克斯坦 1740年国旗' },
      { countryCode: 'kz', year: 1750, imagePath: 'flag_history_kz_1750', description: '哈萨克斯坦 1750年国旗' },
      { countryCode: 'kz', year: 1760, imagePath: 'flag_history_kz_1760', description: '哈萨克斯坦 1760年国旗' },
      { countryCode: 'kz', year: 1770, imagePath: 'flag_history_kz_1770', description: '哈萨克斯坦 1770年国旗' },
      { countryCode: 'kz', year: 1780, imagePath: 'flag_history_kz_1780', description: '哈萨克斯坦 1780年国旗' },
      { countryCode: 'kz', year: 1790, imagePath: 'flag_history_kz_1790', description: '哈萨克斯坦 1790年国旗' }
    ]
  },
  {
    countryCode: 'la',
    history: [
      { countryCode: 'la', year: 1700, imagePath: 'flag_history_la_1700', description: '老挝 1700年国旗' },
      { countryCode: 'la', year: 1710, imagePath: 'flag_history_la_1710', description: '老挝 1710年国旗' },
      { countryCode: 'la', year: 1720, imagePath: 'flag_history_la_1720', description: '老挝 1720年国旗' },
      { countryCode: 'la', year: 1730, imagePath: 'flag_history_la_1730', description: '老挝 1730年国旗' }
    ]
  },
  {
    countryCode: 'lb',
    history: [
      { countryCode: 'lb', year: 1700, imagePath: 'flag_history_lb_1700', description: '黎巴嫩 1700年国旗' },
      { countryCode: 'lb', year: 1710, imagePath: 'flag_history_lb_1710', description: '黎巴嫩 1710年国旗' },
      { countryCode: 'lb', year: 1720, imagePath: 'flag_history_lb_1720', description: '黎巴嫩 1720年国旗' },
      { countryCode: 'lb', year: 1730, imagePath: 'flag_history_lb_1730', description: '黎巴嫩 1730年国旗' }
    ]
  },
  {
    countryCode: 'lc',
    history: [
      { countryCode: 'lc', year: 1700, imagePath: 'flag_history_lc_1700', description: '圣卢西亚 1700年国旗' },
      { countryCode: 'lc', year: 1720, imagePath: 'flag_history_lc_1720', description: '圣卢西亚 1720年国旗' },
      { countryCode: 'lc', year: 1740, imagePath: 'flag_history_lc_1740', description: '圣卢西亚 1740年国旗' },
      { countryCode: 'lc', year: 1750, imagePath: 'flag_history_lc_1750', description: '圣卢西亚 1750年国旗' },
      { countryCode: 'lc', year: 1760, imagePath: 'flag_history_lc_1760', description: '圣卢西亚 1760年国旗' },
      { countryCode: 'lc', year: 1770, imagePath: 'flag_history_lc_1770', description: '圣卢西亚 1770年国旗' },
      { countryCode: 'lc', year: 1780, imagePath: 'flag_history_lc_1780', description: '圣卢西亚 1780年国旗' },
      { countryCode: 'lc', year: 1790, imagePath: 'flag_history_lc_1790', description: '圣卢西亚 1790年国旗' },
      { countryCode: 'lc', year: 1800, imagePath: 'flag_history_lc_1800', description: '圣卢西亚 1800年国旗' },
      { countryCode: 'lc', year: 1810, imagePath: 'flag_history_lc_1810', description: '圣卢西亚 1810年国旗' },
      { countryCode: 'lc', year: 1820, imagePath: 'flag_history_lc_1820', description: '圣卢西亚 1820年国旗' },
      { countryCode: 'lc', year: 1830, imagePath: 'flag_history_lc_1830', description: '圣卢西亚 1830年国旗' },
      { countryCode: 'lc', year: 1840, imagePath: 'flag_history_lc_1840', description: '圣卢西亚 1840年国旗' },
      { countryCode: 'lc', year: 1850, imagePath: 'flag_history_lc_1850', description: '圣卢西亚 1850年国旗' },
      { countryCode: 'lc', year: 1860, imagePath: 'flag_history_lc_1860', description: '圣卢西亚 1860年国旗' },
      { countryCode: 'lc', year: 1870, imagePath: 'flag_history_lc_1870', description: '圣卢西亚 1870年国旗' },
      { countryCode: 'lc', year: 1880, imagePath: 'flag_history_lc_1880', description: '圣卢西亚 1880年国旗' },
      { countryCode: 'lc', year: 1890, imagePath: 'flag_history_lc_1890', description: '圣卢西亚 1890年国旗' },
      { countryCode: 'lc', year: 1900, imagePath: 'flag_history_lc_1900', description: '圣卢西亚 1900年国旗' }
    ]
  },
  {
    countryCode: 'li',
    history: [
      { countryCode: 'li', year: 1700, imagePath: 'flag_history_li_1700', description: '列支敦士登 1700年国旗' },
      { countryCode: 'li', year: 1710, imagePath: 'flag_history_li_1710', description: '列支敦士登 1710年国旗' },
      { countryCode: 'li', year: 1720, imagePath: 'flag_history_li_1720', description: '列支敦士登 1720年国旗' },
      { countryCode: 'li', year: 1730, imagePath: 'flag_history_li_1730', description: '列支敦士登 1730年国旗' },
      { countryCode: 'li', year: 1740, imagePath: 'flag_history_li_1740', description: '列支敦士登 1740年国旗' },
      { countryCode: 'li', year: 1750, imagePath: 'flag_history_li_1750', description: '列支敦士登 1750年国旗' }
    ]
  },
  {
    countryCode: 'lk',
    history: [
      { countryCode: 'lk', year: 1710, imagePath: 'flag_history_lk_1710', description: '斯里兰卡 1710年国旗' },
      { countryCode: 'lk', year: 1720, imagePath: 'flag_history_lk_1720', description: '斯里兰卡 1720年国旗' },
      { countryCode: 'lk', year: 1730, imagePath: 'flag_history_lk_1730', description: '斯里兰卡 1730年国旗' },
      { countryCode: 'lk', year: 1740, imagePath: 'flag_history_lk_1740', description: '斯里兰卡 1740年国旗' },
      { countryCode: 'lk', year: 1750, imagePath: 'flag_history_lk_1750', description: '斯里兰卡 1750年国旗' }
    ]
  },
  {
    countryCode: 'lr',
    history: [
      { countryCode: 'lr', year: 1700, imagePath: 'flag_history_lr_1700', description: '利比里亚 1700年国旗' },
      { countryCode: 'lr', year: 1710, imagePath: 'flag_history_lr_1710', description: '利比里亚 1710年国旗' },
      { countryCode: 'lr', year: 1720, imagePath: 'flag_history_lr_1720', description: '利比里亚 1720年国旗' }
    ]
  },
  {
    countryCode: 'ls',
    history: [
      { countryCode: 'ls', year: 1700, imagePath: 'flag_history_ls_1700', description: '莱索托 1700年国旗' },
      { countryCode: 'ls', year: 1710, imagePath: 'flag_history_ls_1710', description: '莱索托 1710年国旗' },
      { countryCode: 'ls', year: 1720, imagePath: 'flag_history_ls_1720', description: '莱索托 1720年国旗' },
      { countryCode: 'ls', year: 1730, imagePath: 'flag_history_ls_1730', description: '莱索托 1730年国旗' },
      { countryCode: 'ls', year: 1740, imagePath: 'flag_history_ls_1740', description: '莱索托 1740年国旗' },
      { countryCode: 'ls', year: 1750, imagePath: 'flag_history_ls_1750', description: '莱索托 1750年国旗' },
      { countryCode: 'ls', year: 1760, imagePath: 'flag_history_ls_1760', description: '莱索托 1760年国旗' },
      { countryCode: 'ls', year: 1770, imagePath: 'flag_history_ls_1770', description: '莱索托 1770年国旗' }
    ]
  },
  {
    countryCode: 'lt',
    history: [
      { countryCode: 'lt', year: 1700, imagePath: 'flag_history_lt_1700', description: '立陶宛 1700年国旗' },
      { countryCode: 'lt', year: 1710, imagePath: 'flag_history_lt_1710', description: '立陶宛 1710年国旗' },
      { countryCode: 'lt', year: 1720, imagePath: 'flag_history_lt_1720', description: '立陶宛 1720年国旗' },
      { countryCode: 'lt', year: 1730, imagePath: 'flag_history_lt_1730', description: '立陶宛 1730年国旗' },
      { countryCode: 'lt', year: 1740, imagePath: 'flag_history_lt_1740', description: '立陶宛 1740年国旗' },
      { countryCode: 'lt', year: 1750, imagePath: 'flag_history_lt_1750', description: '立陶宛 1750年国旗' },
      { countryCode: 'lt', year: 1760, imagePath: 'flag_history_lt_1760', description: '立陶宛 1760年国旗' },
      { countryCode: 'lt', year: 1770, imagePath: 'flag_history_lt_1770', description: '立陶宛 1770年国旗' },
      { countryCode: 'lt', year: 1780, imagePath: 'flag_history_lt_1780', description: '立陶宛 1780年国旗' },
      { countryCode: 'lt', year: 1790, imagePath: 'flag_history_lt_1790', description: '立陶宛 1790年国旗' },
      { countryCode: 'lt', year: 1800, imagePath: 'flag_history_lt_1800', description: '立陶宛 1800年国旗' }
    ]
  },
  {
    countryCode: 'lu',
    history: [
      { countryCode: 'lu', year: 1710, imagePath: 'flag_history_lu_1710', description: '卢森堡 1710年国旗' },
      { countryCode: 'lu', year: 1720, imagePath: 'flag_history_lu_1720', description: '卢森堡 1720年国旗' },
      { countryCode: 'lu', year: 1730, imagePath: 'flag_history_lu_1730', description: '卢森堡 1730年国旗' },
      { countryCode: 'lu', year: 1740, imagePath: 'flag_history_lu_1740', description: '卢森堡 1740年国旗' },
      { countryCode: 'lu', year: 1750, imagePath: 'flag_history_lu_1750', description: '卢森堡 1750年国旗' },
      { countryCode: 'lu', year: 1760, imagePath: 'flag_history_lu_1760', description: '卢森堡 1760年国旗' }
    ]
  },
  {
    countryCode: 'lv',
    history: [
      { countryCode: 'lv', year: 1700, imagePath: 'flag_history_lv_1700', description: '拉脱维亚 1700年国旗' },
      { countryCode: 'lv', year: 1710, imagePath: 'flag_history_lv_1710', description: '拉脱维亚 1710年国旗' },
      { countryCode: 'lv', year: 1720, imagePath: 'flag_history_lv_1720', description: '拉脱维亚 1720年国旗' },
      { countryCode: 'lv', year: 1730, imagePath: 'flag_history_lv_1730', description: '拉脱维亚 1730年国旗' },
      { countryCode: 'lv', year: 1740, imagePath: 'flag_history_lv_1740', description: '拉脱维亚 1740年国旗' },
      { countryCode: 'lv', year: 1750, imagePath: 'flag_history_lv_1750', description: '拉脱维亚 1750年国旗' },
      { countryCode: 'lv', year: 1760, imagePath: 'flag_history_lv_1760', description: '拉脱维亚 1760年国旗' },
      { countryCode: 'lv', year: 1770, imagePath: 'flag_history_lv_1770', description: '拉脱维亚 1770年国旗' },
      { countryCode: 'lv', year: 1780, imagePath: 'flag_history_lv_1780', description: '拉脱维亚 1780年国旗' },
      { countryCode: 'lv', year: 1790, imagePath: 'flag_history_lv_1790', description: '拉脱维亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'ly',
    history: [
      { countryCode: 'ly', year: 1700, imagePath: 'flag_history_ly_1700', description: '利比亚 1700年国旗' },
      { countryCode: 'ly', year: 1710, imagePath: 'flag_history_ly_1710', description: '利比亚 1710年国旗' },
      { countryCode: 'ly', year: 1720, imagePath: 'flag_history_ly_1720', description: '利比亚 1720年国旗' },
      { countryCode: 'ly', year: 1730, imagePath: 'flag_history_ly_1730', description: '利比亚 1730年国旗' },
      { countryCode: 'ly', year: 1740, imagePath: 'flag_history_ly_1740', description: '利比亚 1740年国旗' },
      { countryCode: 'ly', year: 1750, imagePath: 'flag_history_ly_1750', description: '利比亚 1750年国旗' },
      { countryCode: 'ly', year: 1760, imagePath: 'flag_history_ly_1760', description: '利比亚 1760年国旗' }
    ]
  },
  {
    countryCode: 'ma',
    history: [
      { countryCode: 'ma', year: 1700, imagePath: 'flag_history_ma_1700', description: '摩洛哥 1700年国旗' },
      { countryCode: 'ma', year: 1730, imagePath: 'flag_history_ma_1730', description: '摩洛哥 1730年国旗' },
      { countryCode: 'ma', year: 1740, imagePath: 'flag_history_ma_1740', description: '摩洛哥 1740年国旗' }
    ]
  },
  {
    countryCode: 'mc',
    history: [
      { countryCode: 'mc', year: 1700, imagePath: 'flag_history_mc_1700', description: '摩纳哥 1700年国旗' },
      { countryCode: 'mc', year: 1720, imagePath: 'flag_history_mc_1720', description: '摩纳哥 1720年国旗' },
      { countryCode: 'mc', year: 1730, imagePath: 'flag_history_mc_1730', description: '摩纳哥 1730年国旗' },
      { countryCode: 'mc', year: 1740, imagePath: 'flag_history_mc_1740', description: '摩纳哥 1740年国旗' },
      { countryCode: 'mc', year: 1750, imagePath: 'flag_history_mc_1750', description: '摩纳哥 1750年国旗' },
      { countryCode: 'mc', year: 1760, imagePath: 'flag_history_mc_1760', description: '摩纳哥 1760年国旗' }
    ]
  },
  {
    countryCode: 'md',
    history: [
      { countryCode: 'md', year: 1700, imagePath: 'flag_history_md_1700', description: '摩尔多瓦 1700年国旗' },
      { countryCode: 'md', year: 1720, imagePath: 'flag_history_md_1720', description: '摩尔多瓦 1720年国旗' },
      { countryCode: 'md', year: 1730, imagePath: 'flag_history_md_1730', description: '摩尔多瓦 1730年国旗' },
      { countryCode: 'md', year: 1740, imagePath: 'flag_history_md_1740', description: '摩尔多瓦 1740年国旗' },
      { countryCode: 'md', year: 1750, imagePath: 'flag_history_md_1750', description: '摩尔多瓦 1750年国旗' },
      { countryCode: 'md', year: 1760, imagePath: 'flag_history_md_1760', description: '摩尔多瓦 1760年国旗' },
      { countryCode: 'md', year: 1770, imagePath: 'flag_history_md_1770', description: '摩尔多瓦 1770年国旗' },
      { countryCode: 'md', year: 1780, imagePath: 'flag_history_md_1780', description: '摩尔多瓦 1780年国旗' },
      { countryCode: 'md', year: 1800, imagePath: 'flag_history_md_1800', description: '摩尔多瓦 1800年国旗' },
      { countryCode: 'md', year: 1810, imagePath: 'flag_history_md_1810', description: '摩尔多瓦 1810年国旗' },
      { countryCode: 'md', year: 1820, imagePath: 'flag_history_md_1820', description: '摩尔多瓦 1820年国旗' }
    ]
  },
  {
    countryCode: 'me',
    history: [
      { countryCode: 'me', year: 1700, imagePath: 'flag_history_me_1700', description: '黑山 1700年国旗' },
      { countryCode: 'me', year: 1710, imagePath: 'flag_history_me_1710', description: '黑山 1710年国旗' },
      { countryCode: 'me', year: 1720, imagePath: 'flag_history_me_1720', description: '黑山 1720年国旗' },
      { countryCode: 'me', year: 1730, imagePath: 'flag_history_me_1730', description: '黑山 1730年国旗' },
      { countryCode: 'me', year: 1740, imagePath: 'flag_history_me_1740', description: '黑山 1740年国旗' },
      { countryCode: 'me', year: 1750, imagePath: 'flag_history_me_1750', description: '黑山 1750年国旗' }
    ]
  },
  {
    countryCode: 'mg',
    history: [
      { countryCode: 'mg', year: 1700, imagePath: 'flag_history_mg_1700', description: '马达加斯加 1700年国旗' },
      { countryCode: 'mg', year: 1710, imagePath: 'flag_history_mg_1710', description: '马达加斯加 1710年国旗' },
      { countryCode: 'mg', year: 1720, imagePath: 'flag_history_mg_1720', description: '马达加斯加 1720年国旗' }
    ]
  },
  {
    countryCode: 'mh',
    history: [
      { countryCode: 'mh', year: 1700, imagePath: 'flag_history_mh_1700', description: '马绍尔群岛 1700年国旗' },
      { countryCode: 'mh', year: 1710, imagePath: 'flag_history_mh_1710', description: '马绍尔群岛 1710年国旗' },
      { countryCode: 'mh', year: 1720, imagePath: 'flag_history_mh_1720', description: '马绍尔群岛 1720年国旗' },
      { countryCode: 'mh', year: 1730, imagePath: 'flag_history_mh_1730', description: '马绍尔群岛 1730年国旗' },
      { countryCode: 'mh', year: 1740, imagePath: 'flag_history_mh_1740', description: '马绍尔群岛 1740年国旗' },
      { countryCode: 'mh', year: 1750, imagePath: 'flag_history_mh_1750', description: '马绍尔群岛 1750年国旗' },
      { countryCode: 'mh', year: 1760, imagePath: 'flag_history_mh_1760', description: '马绍尔群岛 1760年国旗' },
      { countryCode: 'mh', year: 1770, imagePath: 'flag_history_mh_1770', description: '马绍尔群岛 1770年国旗' }
    ]
  },
  {
    countryCode: 'mk',
    history: [
      { countryCode: 'mk', year: 1700, imagePath: 'flag_history_mk_1700', description: '北马其顿 1700年国旗' },
      { countryCode: 'mk', year: 1710, imagePath: 'flag_history_mk_1710', description: '北马其顿 1710年国旗' },
      { countryCode: 'mk', year: 1720, imagePath: 'flag_history_mk_1720', description: '北马其顿 1720年国旗' },
      { countryCode: 'mk', year: 1730, imagePath: 'flag_history_mk_1730', description: '北马其顿 1730年国旗' },
      { countryCode: 'mk', year: 1740, imagePath: 'flag_history_mk_1740', description: '北马其顿 1740年国旗' },
      { countryCode: 'mk', year: 1750, imagePath: 'flag_history_mk_1750', description: '北马其顿 1750年国旗' },
      { countryCode: 'mk', year: 1760, imagePath: 'flag_history_mk_1760', description: '北马其顿 1760年国旗' },
      { countryCode: 'mk', year: 1770, imagePath: 'flag_history_mk_1770', description: '北马其顿 1770年国旗' },
      { countryCode: 'mk', year: 1780, imagePath: 'flag_history_mk_1780', description: '北马其顿 1780年国旗' },
      { countryCode: 'mk', year: 1790, imagePath: 'flag_history_mk_1790', description: '北马其顿 1790年国旗' },
      { countryCode: 'mk', year: 1800, imagePath: 'flag_history_mk_1800', description: '北马其顿 1800年国旗' }
    ]
  },
  {
    countryCode: 'ml',
    history: [
      { countryCode: 'ml', year: 1700, imagePath: 'flag_history_ml_1700', description: '马里 1700年国旗' },
      { countryCode: 'ml', year: 1710, imagePath: 'flag_history_ml_1710', description: '马里 1710年国旗' },
      { countryCode: 'ml', year: 1720, imagePath: 'flag_history_ml_1720', description: '马里 1720年国旗' },
      { countryCode: 'ml', year: 1730, imagePath: 'flag_history_ml_1730', description: '马里 1730年国旗' },
      { countryCode: 'ml', year: 1740, imagePath: 'flag_history_ml_1740', description: '马里 1740年国旗' }
    ]
  },
  {
    countryCode: 'mm',
    history: [
      { countryCode: 'mm', year: 1700, imagePath: 'flag_history_mm_1700', description: '缅甸 1700年国旗' },
      { countryCode: 'mm', year: 1710, imagePath: 'flag_history_mm_1710', description: '缅甸 1710年国旗' },
      { countryCode: 'mm', year: 1720, imagePath: 'flag_history_mm_1720', description: '缅甸 1720年国旗' },
      { countryCode: 'mm', year: 1730, imagePath: 'flag_history_mm_1730', description: '缅甸 1730年国旗' },
      { countryCode: 'mm', year: 1740, imagePath: 'flag_history_mm_1740', description: '缅甸 1740年国旗' },
      { countryCode: 'mm', year: 1750, imagePath: 'flag_history_mm_1750', description: '缅甸 1750年国旗' },
      { countryCode: 'mm', year: 1760, imagePath: 'flag_history_mm_1760', description: '缅甸 1760年国旗' },
      { countryCode: 'mm', year: 1770, imagePath: 'flag_history_mm_1770', description: '缅甸 1770年国旗' },
      { countryCode: 'mm', year: 1780, imagePath: 'flag_history_mm_1780', description: '缅甸 1780年国旗' }
    ]
  },
  {
    countryCode: 'mn',
    history: [
      { countryCode: 'mn', year: 1700, imagePath: 'flag_history_mn_1700', description: '蒙古 1700年国旗' },
      { countryCode: 'mn', year: 1710, imagePath: 'flag_history_mn_1710', description: '蒙古 1710年国旗' },
      { countryCode: 'mn', year: 1720, imagePath: 'flag_history_mn_1720', description: '蒙古 1720年国旗' },
      { countryCode: 'mn', year: 1730, imagePath: 'flag_history_mn_1730', description: '蒙古 1730年国旗' },
      { countryCode: 'mn', year: 1740, imagePath: 'flag_history_mn_1740', description: '蒙古 1740年国旗' },
      { countryCode: 'mn', year: 1750, imagePath: 'flag_history_mn_1750', description: '蒙古 1750年国旗' },
      { countryCode: 'mn', year: 1760, imagePath: 'flag_history_mn_1760', description: '蒙古 1760年国旗' },
      { countryCode: 'mn', year: 1770, imagePath: 'flag_history_mn_1770', description: '蒙古 1770年国旗' },
      { countryCode: 'mn', year: 1780, imagePath: 'flag_history_mn_1780', description: '蒙古 1780年国旗' }
    ]
  },
  {
    countryCode: 'mr',
    history: [
      { countryCode: 'mr', year: 1700, imagePath: 'flag_history_mr_1700', description: '毛里塔尼亚 1700年国旗' },
      { countryCode: 'mr', year: 1710, imagePath: 'flag_history_mr_1710', description: '毛里塔尼亚 1710年国旗' },
      { countryCode: 'mr', year: 1720, imagePath: 'flag_history_mr_1720', description: '毛里塔尼亚 1720年国旗' },
      { countryCode: 'mr', year: 1730, imagePath: 'flag_history_mr_1730', description: '毛里塔尼亚 1730年国旗' }
    ]
  },
  {
    countryCode: 'mt',
    history: [
      { countryCode: 'mt', year: 1700, imagePath: 'flag_history_mt_1700', description: '马耳他 1700年国旗' },
      { countryCode: 'mt', year: 1710, imagePath: 'flag_history_mt_1710', description: '马耳他 1710年国旗' },
      { countryCode: 'mt', year: 1720, imagePath: 'flag_history_mt_1720', description: '马耳他 1720年国旗' },
      { countryCode: 'mt', year: 1730, imagePath: 'flag_history_mt_1730', description: '马耳他 1730年国旗' },
      { countryCode: 'mt', year: 1740, imagePath: 'flag_history_mt_1740', description: '马耳他 1740年国旗' },
      { countryCode: 'mt', year: 1750, imagePath: 'flag_history_mt_1750', description: '马耳他 1750年国旗' },
      { countryCode: 'mt', year: 1760, imagePath: 'flag_history_mt_1760', description: '马耳他 1760年国旗' },
      { countryCode: 'mt', year: 1770, imagePath: 'flag_history_mt_1770', description: '马耳他 1770年国旗' },
      { countryCode: 'mt', year: 1780, imagePath: 'flag_history_mt_1780', description: '马耳他 1780年国旗' }
    ]
  },
  {
    countryCode: 'mu',
    history: [
      { countryCode: 'mu', year: 1700, imagePath: 'flag_history_mu_1700', description: '毛里求斯 1700年国旗' },
      { countryCode: 'mu', year: 1710, imagePath: 'flag_history_mu_1710', description: '毛里求斯 1710年国旗' },
      { countryCode: 'mu', year: 1720, imagePath: 'flag_history_mu_1720', description: '毛里求斯 1720年国旗' },
      { countryCode: 'mu', year: 1730, imagePath: 'flag_history_mu_1730', description: '毛里求斯 1730年国旗' },
      { countryCode: 'mu', year: 1740, imagePath: 'flag_history_mu_1740', description: '毛里求斯 1740年国旗' },
      { countryCode: 'mu', year: 1750, imagePath: 'flag_history_mu_1750', description: '毛里求斯 1750年国旗' },
      { countryCode: 'mu', year: 1760, imagePath: 'flag_history_mu_1760', description: '毛里求斯 1760年国旗' }
    ]
  },
  {
    countryCode: 'mv',
    history: [
      { countryCode: 'mv', year: 1700, imagePath: 'flag_history_mv_1700', description: '马尔代夫 1700年国旗' },
      { countryCode: 'mv', year: 1710, imagePath: 'flag_history_mv_1710', description: '马尔代夫 1710年国旗' },
      { countryCode: 'mv', year: 1720, imagePath: 'flag_history_mv_1720', description: '马尔代夫 1720年国旗' },
      { countryCode: 'mv', year: 1730, imagePath: 'flag_history_mv_1730', description: '马尔代夫 1730年国旗' },
      { countryCode: 'mv', year: 1740, imagePath: 'flag_history_mv_1740', description: '马尔代夫 1740年国旗' }
    ]
  },
  {
    countryCode: 'mw',
    history: [
      { countryCode: 'mw', year: 1700, imagePath: 'flag_history_mw_1700', description: '马拉维 1700年国旗' },
      { countryCode: 'mw', year: 1710, imagePath: 'flag_history_mw_1710', description: '马拉维 1710年国旗' },
      { countryCode: 'mw', year: 1720, imagePath: 'flag_history_mw_1720', description: '马拉维 1720年国旗' },
      { countryCode: 'mw', year: 1730, imagePath: 'flag_history_mw_1730', description: '马拉维 1730年国旗' },
      { countryCode: 'mw', year: 1740, imagePath: 'flag_history_mw_1740', description: '马拉维 1740年国旗' },
      { countryCode: 'mw', year: 1750, imagePath: 'flag_history_mw_1750', description: '马拉维 1750年国旗' },
      { countryCode: 'mw', year: 1760, imagePath: 'flag_history_mw_1760', description: '马拉维 1760年国旗' }
    ]
  },
  {
    countryCode: 'mx',
    history: [
      { countryCode: 'mx', year: 1700, imagePath: 'flag_history_mx_1700', description: '墨西哥 1700年国旗' },
      { countryCode: 'mx', year: 1710, imagePath: 'flag_history_mx_1710', description: '墨西哥 1710年国旗' },
      { countryCode: 'mx', year: 1720, imagePath: 'flag_history_mx_1720', description: '墨西哥 1720年国旗' },
      { countryCode: 'mx', year: 1730, imagePath: 'flag_history_mx_1730', description: '墨西哥 1730年国旗' },
      { countryCode: 'mx', year: 1740, imagePath: 'flag_history_mx_1740', description: '墨西哥 1740年国旗' },
      { countryCode: 'mx', year: 1750, imagePath: 'flag_history_mx_1750', description: '墨西哥 1750年国旗' },
      { countryCode: 'mx', year: 1760, imagePath: 'flag_history_mx_1760', description: '墨西哥 1760年国旗' },
      { countryCode: 'mx', year: 1770, imagePath: 'flag_history_mx_1770', description: '墨西哥 1770年国旗' },
      { countryCode: 'mx', year: 1780, imagePath: 'flag_history_mx_1780', description: '墨西哥 1780年国旗' },
      { countryCode: 'mx', year: 1790, imagePath: 'flag_history_mx_1790', description: '墨西哥 1790年国旗' }
    ]
  },
  {
    countryCode: 'my',
    history: [
      { countryCode: 'my', year: 1700, imagePath: 'flag_history_my_1700', description: '马来西亚 1700年国旗' },
      { countryCode: 'my', year: 1710, imagePath: 'flag_history_my_1710', description: '马来西亚 1710年国旗' },
      { countryCode: 'my', year: 1720, imagePath: 'flag_history_my_1720', description: '马来西亚 1720年国旗' },
      { countryCode: 'my', year: 1730, imagePath: 'flag_history_my_1730', description: '马来西亚 1730年国旗' },
      { countryCode: 'my', year: 1740, imagePath: 'flag_history_my_1740', description: '马来西亚 1740年国旗' },
      { countryCode: 'my', year: 1750, imagePath: 'flag_history_my_1750', description: '马来西亚 1750年国旗' },
      { countryCode: 'my', year: 1760, imagePath: 'flag_history_my_1760', description: '马来西亚 1760年国旗' },
      { countryCode: 'my', year: 1770, imagePath: 'flag_history_my_1770', description: '马来西亚 1770年国旗' },
      { countryCode: 'my', year: 1780, imagePath: 'flag_history_my_1780', description: '马来西亚 1780年国旗' },
      { countryCode: 'my', year: 1790, imagePath: 'flag_history_my_1790', description: '马来西亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'mz',
    history: [
      { countryCode: 'mz', year: 1700, imagePath: 'flag_history_mz_1700', description: '莫桑比克 1700年国旗' },
      { countryCode: 'mz', year: 1710, imagePath: 'flag_history_mz_1710', description: '莫桑比克 1710年国旗' },
      { countryCode: 'mz', year: 1720, imagePath: 'flag_history_mz_1720', description: '莫桑比克 1720年国旗' },
      { countryCode: 'mz', year: 1730, imagePath: 'flag_history_mz_1730', description: '莫桑比克 1730年国旗' },
      { countryCode: 'mz', year: 1740, imagePath: 'flag_history_mz_1740', description: '莫桑比克 1740年国旗' },
      { countryCode: 'mz', year: 1750, imagePath: 'flag_history_mz_1750', description: '莫桑比克 1750年国旗' },
      { countryCode: 'mz', year: 1760, imagePath: 'flag_history_mz_1760', description: '莫桑比克 1760年国旗' },
      { countryCode: 'mz', year: 1770, imagePath: 'flag_history_mz_1770', description: '莫桑比克 1770年国旗' },
      { countryCode: 'mz', year: 1780, imagePath: 'flag_history_mz_1780', description: '莫桑比克 1780年国旗' },
      { countryCode: 'mz', year: 1790, imagePath: 'flag_history_mz_1790', description: '莫桑比克 1790年国旗' }
    ]
  },
  {
    countryCode: 'na',
    history: [
      { countryCode: 'na', year: 1700, imagePath: 'flag_history_na_1700', description: '纳米比亚 1700年国旗' },
      { countryCode: 'na', year: 1710, imagePath: 'flag_history_na_1710', description: '纳米比亚 1710年国旗' },
      { countryCode: 'na', year: 1720, imagePath: 'flag_history_na_1720', description: '纳米比亚 1720年国旗' },
      { countryCode: 'na', year: 1730, imagePath: 'flag_history_na_1730', description: '纳米比亚 1730年国旗' },
      { countryCode: 'na', year: 1740, imagePath: 'flag_history_na_1740', description: '纳米比亚 1740年国旗' }
    ]
  },
  {
    countryCode: 'ne',
    history: [
      { countryCode: 'ne', year: 1700, imagePath: 'flag_history_ne_1700', description: '尼日尔 1700年国旗' },
      { countryCode: 'ne', year: 1710, imagePath: 'flag_history_ne_1710', description: '尼日尔 1710年国旗' },
      { countryCode: 'ne', year: 1720, imagePath: 'flag_history_ne_1720', description: '尼日尔 1720年国旗' }
    ]
  },
  {
    countryCode: 'ng',
    history: [
      { countryCode: 'ng', year: 1700, imagePath: 'flag_history_ng_1700', description: '尼日利亚 1700年国旗' },
      { countryCode: 'ng', year: 1710, imagePath: 'flag_history_ng_1710', description: '尼日利亚 1710年国旗' },
      { countryCode: 'ng', year: 1720, imagePath: 'flag_history_ng_1720', description: '尼日利亚 1720年国旗' },
      { countryCode: 'ng', year: 1730, imagePath: 'flag_history_ng_1730', description: '尼日利亚 1730年国旗' }
    ]
  },
  {
    countryCode: 'ni',
    history: [
      { countryCode: 'ni', year: 1700, imagePath: 'flag_history_ni_1700', description: '尼加拉瓜 1700年国旗' },
      { countryCode: 'ni', year: 1710, imagePath: 'flag_history_ni_1710', description: '尼加拉瓜 1710年国旗' },
      { countryCode: 'ni', year: 1720, imagePath: 'flag_history_ni_1720', description: '尼加拉瓜 1720年国旗' },
      { countryCode: 'ni', year: 1730, imagePath: 'flag_history_ni_1730', description: '尼加拉瓜 1730年国旗' },
      { countryCode: 'ni', year: 1740, imagePath: 'flag_history_ni_1740', description: '尼加拉瓜 1740年国旗' },
      { countryCode: 'ni', year: 1750, imagePath: 'flag_history_ni_1750', description: '尼加拉瓜 1750年国旗' },
      { countryCode: 'ni', year: 1760, imagePath: 'flag_history_ni_1760', description: '尼加拉瓜 1760年国旗' },
      { countryCode: 'ni', year: 1770, imagePath: 'flag_history_ni_1770', description: '尼加拉瓜 1770年国旗' },
      { countryCode: 'ni', year: 1780, imagePath: 'flag_history_ni_1780', description: '尼加拉瓜 1780年国旗' },
      { countryCode: 'ni', year: 1790, imagePath: 'flag_history_ni_1790', description: '尼加拉瓜 1790年国旗' }
    ]
  },
  {
    countryCode: 'nl',
    history: [
      { countryCode: 'nl', year: 1700, imagePath: 'flag_history_nl_1700', description: '荷兰 1700年国旗' },
      { countryCode: 'nl', year: 1710, imagePath: 'flag_history_nl_1710', description: '荷兰 1710年国旗' },
      { countryCode: 'nl', year: 1720, imagePath: 'flag_history_nl_1720', description: '荷兰 1720年国旗' },
      { countryCode: 'nl', year: 1730, imagePath: 'flag_history_nl_1730', description: '荷兰 1730年国旗' },
      { countryCode: 'nl', year: 1740, imagePath: 'flag_history_nl_1740', description: '荷兰 1740年国旗' },
      { countryCode: 'nl', year: 1750, imagePath: 'flag_history_nl_1750', description: '荷兰 1750年国旗' },
      { countryCode: 'nl', year: 1760, imagePath: 'flag_history_nl_1760', description: '荷兰 1760年国旗' }
    ]
  },
  {
    countryCode: 'no',
    history: [
      { countryCode: 'no', year: 1700, imagePath: 'flag_history_no_1700', description: '挪威 1700年国旗' },
      { countryCode: 'no', year: 1710, imagePath: 'flag_history_no_1710', description: '挪威 1710年国旗' },
      { countryCode: 'no', year: 1720, imagePath: 'flag_history_no_1720', description: '挪威 1720年国旗' },
      { countryCode: 'no', year: 1730, imagePath: 'flag_history_no_1730', description: '挪威 1730年国旗' },
      { countryCode: 'no', year: 1740, imagePath: 'flag_history_no_1740', description: '挪威 1740年国旗' },
      { countryCode: 'no', year: 1750, imagePath: 'flag_history_no_1750', description: '挪威 1750年国旗' }
    ]
  },
  {
    countryCode: 'np',
    history: [
      { countryCode: 'np', year: 1700, imagePath: 'flag_history_np_1700', description: '尼泊尔 1700年国旗' },
      { countryCode: 'np', year: 1710, imagePath: 'flag_history_np_1710', description: '尼泊尔 1710年国旗' },
      { countryCode: 'np', year: 1720, imagePath: 'flag_history_np_1720', description: '尼泊尔 1720年国旗' }
    ]
  },
  {
    countryCode: 'nr',
    history: [
      { countryCode: 'nr', year: 1700, imagePath: 'flag_history_nr_1700', description: '瑙鲁 1700年国旗' },
      { countryCode: 'nr', year: 1710, imagePath: 'flag_history_nr_1710', description: '瑙鲁 1710年国旗' },
      { countryCode: 'nr', year: 1720, imagePath: 'flag_history_nr_1720', description: '瑙鲁 1720年国旗' },
      { countryCode: 'nr', year: 1730, imagePath: 'flag_history_nr_1730', description: '瑙鲁 1730年国旗' },
      { countryCode: 'nr', year: 1740, imagePath: 'flag_history_nr_1740', description: '瑙鲁 1740年国旗' },
      { countryCode: 'nr', year: 1750, imagePath: 'flag_history_nr_1750', description: '瑙鲁 1750年国旗' },
      { countryCode: 'nr', year: 1760, imagePath: 'flag_history_nr_1760', description: '瑙鲁 1760年国旗' }
    ]
  },
  {
    countryCode: 'nz',
    history: [
      { countryCode: 'nz', year: 1700, imagePath: 'flag_history_nz_1700', description: '新西兰 1700年国旗' },
      { countryCode: 'nz', year: 1710, imagePath: 'flag_history_nz_1710', description: '新西兰 1710年国旗' },
      { countryCode: 'nz', year: 1720, imagePath: 'flag_history_nz_1720', description: '新西兰 1720年国旗' },
      { countryCode: 'nz', year: 1730, imagePath: 'flag_history_nz_1730', description: '新西兰 1730年国旗' },
      { countryCode: 'nz', year: 1740, imagePath: 'flag_history_nz_1740', description: '新西兰 1740年国旗' }
    ]
  },
  {
    countryCode: 'om',
    history: [
      { countryCode: 'om', year: 1700, imagePath: 'flag_history_om_1700', description: '阿曼 1700年国旗' },
      { countryCode: 'om', year: 1710, imagePath: 'flag_history_om_1710', description: '阿曼 1710年国旗' },
      { countryCode: 'om', year: 1720, imagePath: 'flag_history_om_1720', description: '阿曼 1720年国旗' },
      { countryCode: 'om', year: 1730, imagePath: 'flag_history_om_1730', description: '阿曼 1730年国旗' }
    ]
  },
  {
    countryCode: 'pa',
    history: [
      { countryCode: 'pa', year: 1700, imagePath: 'flag_history_pa_1700', description: '巴拿马 1700年国旗' },
      { countryCode: 'pa', year: 1710, imagePath: 'flag_history_pa_1710', description: '巴拿马 1710年国旗' },
      { countryCode: 'pa', year: 1720, imagePath: 'flag_history_pa_1720', description: '巴拿马 1720年国旗' },
      { countryCode: 'pa', year: 1730, imagePath: 'flag_history_pa_1730', description: '巴拿马 1730年国旗' },
      { countryCode: 'pa', year: 1740, imagePath: 'flag_history_pa_1740', description: '巴拿马 1740年国旗' },
      { countryCode: 'pa', year: 1750, imagePath: 'flag_history_pa_1750', description: '巴拿马 1750年国旗' },
      { countryCode: 'pa', year: 1760, imagePath: 'flag_history_pa_1760', description: '巴拿马 1760年国旗' },
      { countryCode: 'pa', year: 1770, imagePath: 'flag_history_pa_1770', description: '巴拿马 1770年国旗' },
      { countryCode: 'pa', year: 1780, imagePath: 'flag_history_pa_1780', description: '巴拿马 1780年国旗' },
      { countryCode: 'pa', year: 1790, imagePath: 'flag_history_pa_1790', description: '巴拿马 1790年国旗' },
      { countryCode: 'pa', year: 1800, imagePath: 'flag_history_pa_1800', description: '巴拿马 1800年国旗' },
      { countryCode: 'pa', year: 1810, imagePath: 'flag_history_pa_1810', description: '巴拿马 1810年国旗' }
    ]
  },
  {
    countryCode: 'pe',
    history: [
      { countryCode: 'pe', year: 1700, imagePath: 'flag_history_pe_1700', description: '秘鲁 1700年国旗' },
      { countryCode: 'pe', year: 1710, imagePath: 'flag_history_pe_1710', description: '秘鲁 1710年国旗' },
      { countryCode: 'pe', year: 1720, imagePath: 'flag_history_pe_1720', description: '秘鲁 1720年国旗' },
      { countryCode: 'pe', year: 1730, imagePath: 'flag_history_pe_1730', description: '秘鲁 1730年国旗' },
      { countryCode: 'pe', year: 1740, imagePath: 'flag_history_pe_1740', description: '秘鲁 1740年国旗' },
      { countryCode: 'pe', year: 1770, imagePath: 'flag_history_pe_1770', description: '秘鲁 1770年国旗' },
      { countryCode: 'pe', year: 1780, imagePath: 'flag_history_pe_1780', description: '秘鲁 1780年国旗' }
    ]
  },
  {
    countryCode: 'pg',
    history: [
      { countryCode: 'pg', year: 1700, imagePath: 'flag_history_pg_1700', description: '巴布亚新几内亚 1700年国旗' },
      { countryCode: 'pg', year: 1710, imagePath: 'flag_history_pg_1710', description: '巴布亚新几内亚 1710年国旗' },
      { countryCode: 'pg', year: 1720, imagePath: 'flag_history_pg_1720', description: '巴布亚新几内亚 1720年国旗' },
      { countryCode: 'pg', year: 1730, imagePath: 'flag_history_pg_1730', description: '巴布亚新几内亚 1730年国旗' },
      { countryCode: 'pg', year: 1740, imagePath: 'flag_history_pg_1740', description: '巴布亚新几内亚 1740年国旗' },
      { countryCode: 'pg', year: 1750, imagePath: 'flag_history_pg_1750', description: '巴布亚新几内亚 1750年国旗' },
      { countryCode: 'pg', year: 1760, imagePath: 'flag_history_pg_1760', description: '巴布亚新几内亚 1760年国旗' },
      { countryCode: 'pg', year: 1770, imagePath: 'flag_history_pg_1770', description: '巴布亚新几内亚 1770年国旗' },
      { countryCode: 'pg', year: 1780, imagePath: 'flag_history_pg_1780', description: '巴布亚新几内亚 1780年国旗' }
    ]
  },
  {
    countryCode: 'ph',
    history: [
      { countryCode: 'ph', year: 1700, imagePath: 'flag_history_ph_1700', description: '菲律宾 1700年国旗' },
      { countryCode: 'ph', year: 1710, imagePath: 'flag_history_ph_1710', description: '菲律宾 1710年国旗' },
      { countryCode: 'ph', year: 1720, imagePath: 'flag_history_ph_1720', description: '菲律宾 1720年国旗' },
      { countryCode: 'ph', year: 1730, imagePath: 'flag_history_ph_1730', description: '菲律宾 1730年国旗' },
      { countryCode: 'ph', year: 1740, imagePath: 'flag_history_ph_1740', description: '菲律宾 1740年国旗' },
      { countryCode: 'ph', year: 1750, imagePath: 'flag_history_ph_1750', description: '菲律宾 1750年国旗' },
      { countryCode: 'ph', year: 1760, imagePath: 'flag_history_ph_1760', description: '菲律宾 1760年国旗' },
      { countryCode: 'ph', year: 1770, imagePath: 'flag_history_ph_1770', description: '菲律宾 1770年国旗' },
      { countryCode: 'ph', year: 1780, imagePath: 'flag_history_ph_1780', description: '菲律宾 1780年国旗' },
      { countryCode: 'ph', year: 1790, imagePath: 'flag_history_ph_1790', description: '菲律宾 1790年国旗' },
      { countryCode: 'ph', year: 1800, imagePath: 'flag_history_ph_1800', description: '菲律宾 1800年国旗' },
      { countryCode: 'ph', year: 1810, imagePath: 'flag_history_ph_1810', description: '菲律宾 1810年国旗' },
      { countryCode: 'ph', year: 1820, imagePath: 'flag_history_ph_1820', description: '菲律宾 1820年国旗' },
      { countryCode: 'ph', year: 1830, imagePath: 'flag_history_ph_1830', description: '菲律宾 1830年国旗' },
      { countryCode: 'ph', year: 1840, imagePath: 'flag_history_ph_1840', description: '菲律宾 1840年国旗' }
    ]
  },
  {
    countryCode: 'pk',
    history: [
      { countryCode: 'pk', year: 1700, imagePath: 'flag_history_pk_1700', description: '巴基斯坦 1700年国旗' },
      { countryCode: 'pk', year: 1710, imagePath: 'flag_history_pk_1710', description: '巴基斯坦 1710年国旗' },
      { countryCode: 'pk', year: 1720, imagePath: 'flag_history_pk_1720', description: '巴基斯坦 1720年国旗' },
      { countryCode: 'pk', year: 1730, imagePath: 'flag_history_pk_1730', description: '巴基斯坦 1730年国旗' },
      { countryCode: 'pk', year: 1740, imagePath: 'flag_history_pk_1740', description: '巴基斯坦 1740年国旗' },
      { countryCode: 'pk', year: 1750, imagePath: 'flag_history_pk_1750', description: '巴基斯坦 1750年国旗' },
      { countryCode: 'pk', year: 1760, imagePath: 'flag_history_pk_1760', description: '巴基斯坦 1760年国旗' }
    ]
  },
  {
    countryCode: 'pl',
    history: [
      { countryCode: 'pl', year: 1700, imagePath: 'flag_history_pl_1700', description: '波兰 1700年国旗' },
      { countryCode: 'pl', year: 1710, imagePath: 'flag_history_pl_1710', description: '波兰 1710年国旗' },
      { countryCode: 'pl', year: 1720, imagePath: 'flag_history_pl_1720', description: '波兰 1720年国旗' },
      { countryCode: 'pl', year: 1730, imagePath: 'flag_history_pl_1730', description: '波兰 1730年国旗' },
      { countryCode: 'pl', year: 1750, imagePath: 'flag_history_pl_1750', description: '波兰 1750年国旗' },
      { countryCode: 'pl', year: 1760, imagePath: 'flag_history_pl_1760', description: '波兰 1760年国旗' },
      { countryCode: 'pl', year: 1770, imagePath: 'flag_history_pl_1770', description: '波兰 1770年国旗' },
      { countryCode: 'pl', year: 1780, imagePath: 'flag_history_pl_1780', description: '波兰 1780年国旗' }
    ]
  },
  {
    countryCode: 'pt',
    history: [
      { countryCode: 'pt', year: 1700, imagePath: 'flag_history_pt_1700', description: '葡萄牙 1700年国旗' },
      { countryCode: 'pt', year: 1710, imagePath: 'flag_history_pt_1710', description: '葡萄牙 1710年国旗' },
      { countryCode: 'pt', year: 1720, imagePath: 'flag_history_pt_1720', description: '葡萄牙 1720年国旗' },
      { countryCode: 'pt', year: 1730, imagePath: 'flag_history_pt_1730', description: '葡萄牙 1730年国旗' },
      { countryCode: 'pt', year: 1740, imagePath: 'flag_history_pt_1740', description: '葡萄牙 1740年国旗' },
      { countryCode: 'pt', year: 1750, imagePath: 'flag_history_pt_1750', description: '葡萄牙 1750年国旗' },
      { countryCode: 'pt', year: 1760, imagePath: 'flag_history_pt_1760', description: '葡萄牙 1760年国旗' }
    ]
  },
  {
    countryCode: 'pw',
    history: [
      { countryCode: 'pw', year: 1700, imagePath: 'flag_history_pw_1700', description: '帕劳 1700年国旗' },
      { countryCode: 'pw', year: 1710, imagePath: 'flag_history_pw_1710', description: '帕劳 1710年国旗' },
      { countryCode: 'pw', year: 1720, imagePath: 'flag_history_pw_1720', description: '帕劳 1720年国旗' },
      { countryCode: 'pw', year: 1730, imagePath: 'flag_history_pw_1730', description: '帕劳 1730年国旗' },
      { countryCode: 'pw', year: 1740, imagePath: 'flag_history_pw_1740', description: '帕劳 1740年国旗' },
      { countryCode: 'pw', year: 1750, imagePath: 'flag_history_pw_1750', description: '帕劳 1750年国旗' },
      { countryCode: 'pw', year: 1760, imagePath: 'flag_history_pw_1760', description: '帕劳 1760年国旗' },
      { countryCode: 'pw', year: 1770, imagePath: 'flag_history_pw_1770', description: '帕劳 1770年国旗' }
    ]
  },
  {
    countryCode: 'py',
    history: [
      { countryCode: 'py', year: 1700, imagePath: 'flag_history_py_1700', description: '巴拉圭 1700年国旗' },
      { countryCode: 'py', year: 1710, imagePath: 'flag_history_py_1710', description: '巴拉圭 1710年国旗' },
      { countryCode: 'py', year: 1720, imagePath: 'flag_history_py_1720', description: '巴拉圭 1720年国旗' },
      { countryCode: 'py', year: 1730, imagePath: 'flag_history_py_1730', description: '巴拉圭 1730年国旗' },
      { countryCode: 'py', year: 1740, imagePath: 'flag_history_py_1740', description: '巴拉圭 1740年国旗' },
      { countryCode: 'py', year: 1750, imagePath: 'flag_history_py_1750', description: '巴拉圭 1750年国旗' },
      { countryCode: 'py', year: 1760, imagePath: 'flag_history_py_1760', description: '巴拉圭 1760年国旗' },
      { countryCode: 'py', year: 1770, imagePath: 'flag_history_py_1770', description: '巴拉圭 1770年国旗' },
      { countryCode: 'py', year: 1780, imagePath: 'flag_history_py_1780', description: '巴拉圭 1780年国旗' },
      { countryCode: 'py', year: 1790, imagePath: 'flag_history_py_1790', description: '巴拉圭 1790年国旗' },
      { countryCode: 'py', year: 1800, imagePath: 'flag_history_py_1800', description: '巴拉圭 1800年国旗' }
    ]
  },
  {
    countryCode: 'qa',
    history: [
      { countryCode: 'qa', year: 1700, imagePath: 'flag_history_qa_1700', description: '卡塔尔 1700年国旗' },
      { countryCode: 'qa', year: 1720, imagePath: 'flag_history_qa_1720', description: '卡塔尔 1720年国旗' },
      { countryCode: 'qa', year: 1730, imagePath: 'flag_history_qa_1730', description: '卡塔尔 1730年国旗' },
      { countryCode: 'qa', year: 1740, imagePath: 'flag_history_qa_1740', description: '卡塔尔 1740年国旗' },
      { countryCode: 'qa', year: 1750, imagePath: 'flag_history_qa_1750', description: '卡塔尔 1750年国旗' },
      { countryCode: 'qa', year: 1760, imagePath: 'flag_history_qa_1760', description: '卡塔尔 1760年国旗' },
      { countryCode: 'qa', year: 1770, imagePath: 'flag_history_qa_1770', description: '卡塔尔 1770年国旗' }
    ]
  },
  {
    countryCode: 'ro',
    history: [
      { countryCode: 'ro', year: 1700, imagePath: 'flag_history_ro_1700', description: '罗马尼亚 1700年国旗' },
      { countryCode: 'ro', year: 1710, imagePath: 'flag_history_ro_1710', description: '罗马尼亚 1710年国旗' },
      { countryCode: 'ro', year: 1720, imagePath: 'flag_history_ro_1720', description: '罗马尼亚 1720年国旗' },
      { countryCode: 'ro', year: 1730, imagePath: 'flag_history_ro_1730', description: '罗马尼亚 1730年国旗' },
      { countryCode: 'ro', year: 1740, imagePath: 'flag_history_ro_1740', description: '罗马尼亚 1740年国旗' },
      { countryCode: 'ro', year: 1750, imagePath: 'flag_history_ro_1750', description: '罗马尼亚 1750年国旗' },
      { countryCode: 'ro', year: 1760, imagePath: 'flag_history_ro_1760', description: '罗马尼亚 1760年国旗' },
      { countryCode: 'ro', year: 1770, imagePath: 'flag_history_ro_1770', description: '罗马尼亚 1770年国旗' },
      { countryCode: 'ro', year: 1780, imagePath: 'flag_history_ro_1780', description: '罗马尼亚 1780年国旗' },
      { countryCode: 'ro', year: 1790, imagePath: 'flag_history_ro_1790', description: '罗马尼亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'rs',
    history: [
      { countryCode: 'rs', year: 1710, imagePath: 'flag_history_rs_1710', description: '塞尔维亚 1710年国旗' },
      { countryCode: 'rs', year: 1720, imagePath: 'flag_history_rs_1720', description: '塞尔维亚 1720年国旗' },
      { countryCode: 'rs', year: 1730, imagePath: 'flag_history_rs_1730', description: '塞尔维亚 1730年国旗' },
      { countryCode: 'rs', year: 1740, imagePath: 'flag_history_rs_1740', description: '塞尔维亚 1740年国旗' },
      { countryCode: 'rs', year: 1750, imagePath: 'flag_history_rs_1750', description: '塞尔维亚 1750年国旗' },
      { countryCode: 'rs', year: 1760, imagePath: 'flag_history_rs_1760', description: '塞尔维亚 1760年国旗' },
      { countryCode: 'rs', year: 1770, imagePath: 'flag_history_rs_1770', description: '塞尔维亚 1770年国旗' }
    ]
  },
  {
    countryCode: 'ru',
    history: [
      { countryCode: 'ru', year: 1700, imagePath: 'flag_history_ru_1700', description: '俄罗斯 1700年国旗' },
      { countryCode: 'ru', year: 1710, imagePath: 'flag_history_ru_1710', description: '俄罗斯 1710年国旗' },
      { countryCode: 'ru', year: 1720, imagePath: 'flag_history_ru_1720', description: '俄罗斯 1720年国旗' },
      { countryCode: 'ru', year: 1730, imagePath: 'flag_history_ru_1730', description: '俄罗斯 1730年国旗' },
      { countryCode: 'ru', year: 1740, imagePath: 'flag_history_ru_1740', description: '俄罗斯 1740年国旗' },
      { countryCode: 'ru', year: 1750, imagePath: 'flag_history_ru_1750', description: '俄罗斯 1750年国旗' },
      { countryCode: 'ru', year: 1760, imagePath: 'flag_history_ru_1760', description: '俄罗斯 1760年国旗' },
      { countryCode: 'ru', year: 1770, imagePath: 'flag_history_ru_1770', description: '俄罗斯 1770年国旗' }
    ]
  },
  {
    countryCode: 'rw',
    history: [
      { countryCode: 'rw', year: 1700, imagePath: 'flag_history_rw_1700', description: '卢旺达 1700年国旗' },
      { countryCode: 'rw', year: 1710, imagePath: 'flag_history_rw_1710', description: '卢旺达 1710年国旗' },
      { countryCode: 'rw', year: 1720, imagePath: 'flag_history_rw_1720', description: '卢旺达 1720年国旗' },
      { countryCode: 'rw', year: 1730, imagePath: 'flag_history_rw_1730', description: '卢旺达 1730年国旗' },
      { countryCode: 'rw', year: 1740, imagePath: 'flag_history_rw_1740', description: '卢旺达 1740年国旗' },
      { countryCode: 'rw', year: 1750, imagePath: 'flag_history_rw_1750', description: '卢旺达 1750年国旗' },
      { countryCode: 'rw', year: 1760, imagePath: 'flag_history_rw_1760', description: '卢旺达 1760年国旗' }
    ]
  },
  {
    countryCode: 'sa',
    history: [
      { countryCode: 'sa', year: 1700, imagePath: 'flag_history_sa_1700', description: '沙特阿拉伯 1700年国旗' },
      { countryCode: 'sa', year: 1710, imagePath: 'flag_history_sa_1710', description: '沙特阿拉伯 1710年国旗' },
      { countryCode: 'sa', year: 1720, imagePath: 'flag_history_sa_1720', description: '沙特阿拉伯 1720年国旗' },
      { countryCode: 'sa', year: 1730, imagePath: 'flag_history_sa_1730', description: '沙特阿拉伯 1730年国旗' },
      { countryCode: 'sa', year: 1740, imagePath: 'flag_history_sa_1740', description: '沙特阿拉伯 1740年国旗' },
      { countryCode: 'sa', year: 1760, imagePath: 'flag_history_sa_1760', description: '沙特阿拉伯 1760年国旗' },
      { countryCode: 'sa', year: 1770, imagePath: 'flag_history_sa_1770', description: '沙特阿拉伯 1770年国旗' },
      { countryCode: 'sa', year: 1780, imagePath: 'flag_history_sa_1780', description: '沙特阿拉伯 1780年国旗' },
      { countryCode: 'sa', year: 1790, imagePath: 'flag_history_sa_1790', description: '沙特阿拉伯 1790年国旗' },
      { countryCode: 'sa', year: 1800, imagePath: 'flag_history_sa_1800', description: '沙特阿拉伯 1800年国旗' },
      { countryCode: 'sa', year: 1810, imagePath: 'flag_history_sa_1810', description: '沙特阿拉伯 1810年国旗' }
    ]
  },
  {
    countryCode: 'sb',
    history: [
      { countryCode: 'sb', year: 1700, imagePath: 'flag_history_sb_1700', description: '所罗门群岛 1700年国旗' },
      { countryCode: 'sb', year: 1720, imagePath: 'flag_history_sb_1720', description: '所罗门群岛 1720年国旗' },
      { countryCode: 'sb', year: 1730, imagePath: 'flag_history_sb_1730', description: '所罗门群岛 1730年国旗' },
      { countryCode: 'sb', year: 1740, imagePath: 'flag_history_sb_1740', description: '所罗门群岛 1740年国旗' },
      { countryCode: 'sb', year: 1750, imagePath: 'flag_history_sb_1750', description: '所罗门群岛 1750年国旗' }
    ]
  },
  {
    countryCode: 'sc',
    history: [
      { countryCode: 'sc', year: 1700, imagePath: 'flag_history_sc_1700', description: '塞舌尔 1700年国旗' },
      { countryCode: 'sc', year: 1710, imagePath: 'flag_history_sc_1710', description: '塞舌尔 1710年国旗' },
      { countryCode: 'sc', year: 1720, imagePath: 'flag_history_sc_1720', description: '塞舌尔 1720年国旗' },
      { countryCode: 'sc', year: 1730, imagePath: 'flag_history_sc_1730', description: '塞舌尔 1730年国旗' },
      { countryCode: 'sc', year: 1740, imagePath: 'flag_history_sc_1740', description: '塞舌尔 1740年国旗' },
      { countryCode: 'sc', year: 1750, imagePath: 'flag_history_sc_1750', description: '塞舌尔 1750年国旗' }
    ]
  },
  {
    countryCode: 'sd',
    history: [
      { countryCode: 'sd', year: 1700, imagePath: 'flag_history_sd_1700', description: '苏丹 1700年国旗' }
    ]
  },
  {
    countryCode: 'se',
    history: [
      { countryCode: 'se', year: 1700, imagePath: 'flag_history_se_1700', description: '瑞典 1700年国旗' },
      { countryCode: 'se', year: 1710, imagePath: 'flag_history_se_1710', description: '瑞典 1710年国旗' },
      { countryCode: 'se', year: 1720, imagePath: 'flag_history_se_1720', description: '瑞典 1720年国旗' },
      { countryCode: 'se', year: 1730, imagePath: 'flag_history_se_1730', description: '瑞典 1730年国旗' }
    ]
  },
  {
    countryCode: 'sg',
    history: [
      { countryCode: 'sg', year: 1700, imagePath: 'flag_history_sg_1700', description: '新加坡 1700年国旗' },
      { countryCode: 'sg', year: 1710, imagePath: 'flag_history_sg_1710', description: '新加坡 1710年国旗' },
      { countryCode: 'sg', year: 1720, imagePath: 'flag_history_sg_1720', description: '新加坡 1720年国旗' },
      { countryCode: 'sg', year: 1730, imagePath: 'flag_history_sg_1730', description: '新加坡 1730年国旗' },
      { countryCode: 'sg', year: 1740, imagePath: 'flag_history_sg_1740', description: '新加坡 1740年国旗' },
      { countryCode: 'sg', year: 1750, imagePath: 'flag_history_sg_1750', description: '新加坡 1750年国旗' },
      { countryCode: 'sg', year: 1760, imagePath: 'flag_history_sg_1760', description: '新加坡 1760年国旗' },
      { countryCode: 'sg', year: 1770, imagePath: 'flag_history_sg_1770', description: '新加坡 1770年国旗' },
      { countryCode: 'sg', year: 1780, imagePath: 'flag_history_sg_1780', description: '新加坡 1780年国旗' }
    ]
  },
  {
    countryCode: 'si',
    history: [
      { countryCode: 'si', year: 1700, imagePath: 'flag_history_si_1700', description: '斯洛文尼亚 1700年国旗' },
      { countryCode: 'si', year: 1710, imagePath: 'flag_history_si_1710', description: '斯洛文尼亚 1710年国旗' },
      { countryCode: 'si', year: 1720, imagePath: 'flag_history_si_1720', description: '斯洛文尼亚 1720年国旗' },
      { countryCode: 'si', year: 1730, imagePath: 'flag_history_si_1730', description: '斯洛文尼亚 1730年国旗' },
      { countryCode: 'si', year: 1740, imagePath: 'flag_history_si_1740', description: '斯洛文尼亚 1740年国旗' },
      { countryCode: 'si', year: 1750, imagePath: 'flag_history_si_1750', description: '斯洛文尼亚 1750年国旗' },
      { countryCode: 'si', year: 1760, imagePath: 'flag_history_si_1760', description: '斯洛文尼亚 1760年国旗' }
    ]
  },
  {
    countryCode: 'sk',
    history: [
      { countryCode: 'sk', year: 1700, imagePath: 'flag_history_sk_1700', description: '斯洛伐克 1700年国旗' },
      { countryCode: 'sk', year: 1710, imagePath: 'flag_history_sk_1710', description: '斯洛伐克 1710年国旗' },
      { countryCode: 'sk', year: 1720, imagePath: 'flag_history_sk_1720', description: '斯洛伐克 1720年国旗' },
      { countryCode: 'sk', year: 1730, imagePath: 'flag_history_sk_1730', description: '斯洛伐克 1730年国旗' },
      { countryCode: 'sk', year: 1740, imagePath: 'flag_history_sk_1740', description: '斯洛伐克 1740年国旗' },
      { countryCode: 'sk', year: 1750, imagePath: 'flag_history_sk_1750', description: '斯洛伐克 1750年国旗' },
      { countryCode: 'sk', year: 1760, imagePath: 'flag_history_sk_1760', description: '斯洛伐克 1760年国旗' },
      { countryCode: 'sk', year: 1770, imagePath: 'flag_history_sk_1770', description: '斯洛伐克 1770年国旗' }
    ]
  },
  {
    countryCode: 'sl',
    history: [
      { countryCode: 'sl', year: 1700, imagePath: 'flag_history_sl_1700', description: '塞拉利昂 1700年国旗' },
      { countryCode: 'sl', year: 1710, imagePath: 'flag_history_sl_1710', description: '塞拉利昂 1710年国旗' },
      { countryCode: 'sl', year: 1720, imagePath: 'flag_history_sl_1720', description: '塞拉利昂 1720年国旗' },
      { countryCode: 'sl', year: 1730, imagePath: 'flag_history_sl_1730', description: '塞拉利昂 1730年国旗' }
    ]
  },
  {
    countryCode: 'sm',
    history: [
      { countryCode: 'sm', year: 1700, imagePath: 'flag_history_sm_1700', description: '圣马力诺 1700年国旗' },
      { countryCode: 'sm', year: 1710, imagePath: 'flag_history_sm_1710', description: '圣马力诺 1710年国旗' },
      { countryCode: 'sm', year: 1720, imagePath: 'flag_history_sm_1720', description: '圣马力诺 1720年国旗' }
    ]
  },
  {
    countryCode: 'sn',
    history: [
      { countryCode: 'sn', year: 1700, imagePath: 'flag_history_sn_1700', description: '塞内加尔 1700年国旗' },
      { countryCode: 'sn', year: 1710, imagePath: 'flag_history_sn_1710', description: '塞内加尔 1710年国旗' },
      { countryCode: 'sn', year: 1720, imagePath: 'flag_history_sn_1720', description: '塞内加尔 1720年国旗' },
      { countryCode: 'sn', year: 1730, imagePath: 'flag_history_sn_1730', description: '塞内加尔 1730年国旗' },
      { countryCode: 'sn', year: 1740, imagePath: 'flag_history_sn_1740', description: '塞内加尔 1740年国旗' },
      { countryCode: 'sn', year: 1750, imagePath: 'flag_history_sn_1750', description: '塞内加尔 1750年国旗' },
      { countryCode: 'sn', year: 1760, imagePath: 'flag_history_sn_1760', description: '塞内加尔 1760年国旗' }
    ]
  },
  {
    countryCode: 'so',
    history: [
      { countryCode: 'so', year: 1700, imagePath: 'flag_history_so_1700', description: '索马里 1700年国旗' },
      { countryCode: 'so', year: 1710, imagePath: 'flag_history_so_1710', description: '索马里 1710年国旗' },
      { countryCode: 'so', year: 1720, imagePath: 'flag_history_so_1720', description: '索马里 1720年国旗' },
      { countryCode: 'so', year: 1730, imagePath: 'flag_history_so_1730', description: '索马里 1730年国旗' },
      { countryCode: 'so', year: 1750, imagePath: 'flag_history_so_1750', description: '索马里 1750年国旗' }
    ]
  },
  {
    countryCode: 'sr',
    history: [
      { countryCode: 'sr', year: 1700, imagePath: 'flag_history_sr_1700', description: '苏里南 1700年国旗' },
      { countryCode: 'sr', year: 1710, imagePath: 'flag_history_sr_1710', description: '苏里南 1710年国旗' },
      { countryCode: 'sr', year: 1720, imagePath: 'flag_history_sr_1720', description: '苏里南 1720年国旗' },
      { countryCode: 'sr', year: 1730, imagePath: 'flag_history_sr_1730', description: '苏里南 1730年国旗' },
      { countryCode: 'sr', year: 1740, imagePath: 'flag_history_sr_1740', description: '苏里南 1740年国旗' },
      { countryCode: 'sr', year: 1750, imagePath: 'flag_history_sr_1750', description: '苏里南 1750年国旗' },
      { countryCode: 'sr', year: 1760, imagePath: 'flag_history_sr_1760', description: '苏里南 1760年国旗' }
    ]
  },
  {
    countryCode: 'ss',
    history: [
      { countryCode: 'ss', year: 1700, imagePath: 'flag_history_ss_1700', description: '南苏丹 1700年国旗' },
      { countryCode: 'ss', year: 1710, imagePath: 'flag_history_ss_1710', description: '南苏丹 1710年国旗' },
      { countryCode: 'ss', year: 1730, imagePath: 'flag_history_ss_1730', description: '南苏丹 1730年国旗' },
      { countryCode: 'ss', year: 1740, imagePath: 'flag_history_ss_1740', description: '南苏丹 1740年国旗' },
      { countryCode: 'ss', year: 1750, imagePath: 'flag_history_ss_1750', description: '南苏丹 1750年国旗' },
      { countryCode: 'ss', year: 1760, imagePath: 'flag_history_ss_1760', description: '南苏丹 1760年国旗' },
      { countryCode: 'ss', year: 1770, imagePath: 'flag_history_ss_1770', description: '南苏丹 1770年国旗' },
      { countryCode: 'ss', year: 1780, imagePath: 'flag_history_ss_1780', description: '南苏丹 1780年国旗' },
      { countryCode: 'ss', year: 1790, imagePath: 'flag_history_ss_1790', description: '南苏丹 1790年国旗' }
    ]
  },
  {
    countryCode: 'st',
    history: [
      { countryCode: 'st', year: 1700, imagePath: 'flag_history_st_1700', description: '圣多美和普林西比 1700年国旗' },
      { countryCode: 'st', year: 1710, imagePath: 'flag_history_st_1710', description: '圣多美和普林西比 1710年国旗' },
      { countryCode: 'st', year: 1720, imagePath: 'flag_history_st_1720', description: '圣多美和普林西比 1720年国旗' },
      { countryCode: 'st', year: 1730, imagePath: 'flag_history_st_1730', description: '圣多美和普林西比 1730年国旗' },
      { countryCode: 'st', year: 1740, imagePath: 'flag_history_st_1740', description: '圣多美和普林西比 1740年国旗' },
      { countryCode: 'st', year: 1750, imagePath: 'flag_history_st_1750', description: '圣多美和普林西比 1750年国旗' },
      { countryCode: 'st', year: 1760, imagePath: 'flag_history_st_1760', description: '圣多美和普林西比 1760年国旗' },
      { countryCode: 'st', year: 1770, imagePath: 'flag_history_st_1770', description: '圣多美和普林西比 1770年国旗' }
    ]
  },
  {
    countryCode: 'sv',
    history: [
      { countryCode: 'sv', year: 1700, imagePath: 'flag_history_sv_1700', description: '萨尔瓦多 1700年国旗' },
      { countryCode: 'sv', year: 1710, imagePath: 'flag_history_sv_1710', description: '萨尔瓦多 1710年国旗' },
      { countryCode: 'sv', year: 1720, imagePath: 'flag_history_sv_1720', description: '萨尔瓦多 1720年国旗' },
      { countryCode: 'sv', year: 1730, imagePath: 'flag_history_sv_1730', description: '萨尔瓦多 1730年国旗' },
      { countryCode: 'sv', year: 1740, imagePath: 'flag_history_sv_1740', description: '萨尔瓦多 1740年国旗' },
      { countryCode: 'sv', year: 1750, imagePath: 'flag_history_sv_1750', description: '萨尔瓦多 1750年国旗' },
      { countryCode: 'sv', year: 1760, imagePath: 'flag_history_sv_1760', description: '萨尔瓦多 1760年国旗' },
      { countryCode: 'sv', year: 1770, imagePath: 'flag_history_sv_1770', description: '萨尔瓦多 1770年国旗' },
      { countryCode: 'sv', year: 1780, imagePath: 'flag_history_sv_1780', description: '萨尔瓦多 1780年国旗' },
      { countryCode: 'sv', year: 1790, imagePath: 'flag_history_sv_1790', description: '萨尔瓦多 1790年国旗' }
    ]
  },
  {
    countryCode: 'sy',
    history: [
      { countryCode: 'sy', year: 1700, imagePath: 'flag_history_sy_1700', description: '叙利亚 1700年国旗' },
      { countryCode: 'sy', year: 1710, imagePath: 'flag_history_sy_1710', description: '叙利亚 1710年国旗' },
      { countryCode: 'sy', year: 1720, imagePath: 'flag_history_sy_1720', description: '叙利亚 1720年国旗' },
      { countryCode: 'sy', year: 1730, imagePath: 'flag_history_sy_1730', description: '叙利亚 1730年国旗' },
      { countryCode: 'sy', year: 1740, imagePath: 'flag_history_sy_1740', description: '叙利亚 1740年国旗' },
      { countryCode: 'sy', year: 1750, imagePath: 'flag_history_sy_1750', description: '叙利亚 1750年国旗' },
      { countryCode: 'sy', year: 1760, imagePath: 'flag_history_sy_1760', description: '叙利亚 1760年国旗' },
      { countryCode: 'sy', year: 1770, imagePath: 'flag_history_sy_1770', description: '叙利亚 1770年国旗' },
      { countryCode: 'sy', year: 1780, imagePath: 'flag_history_sy_1780', description: '叙利亚 1780年国旗' },
      { countryCode: 'sy', year: 1790, imagePath: 'flag_history_sy_1790', description: '叙利亚 1790年国旗' }
    ]
  },
  {
    countryCode: 'sz',
    history: [
      { countryCode: 'sz', year: 1700, imagePath: 'flag_history_sz_1700', description: '斯威士兰 1700年国旗' },
      { countryCode: 'sz', year: 1720, imagePath: 'flag_history_sz_1720', description: '斯威士兰 1720年国旗' },
      { countryCode: 'sz', year: 1730, imagePath: 'flag_history_sz_1730', description: '斯威士兰 1730年国旗' },
      { countryCode: 'sz', year: 1740, imagePath: 'flag_history_sz_1740', description: '斯威士兰 1740年国旗' }
    ]
  },
  {
    countryCode: 'td',
    history: [
      { countryCode: 'td', year: 1700, imagePath: 'flag_history_td_1700', description: '乍得 1700年国旗' },
      { countryCode: 'td', year: 1710, imagePath: 'flag_history_td_1710', description: '乍得 1710年国旗' },
      { countryCode: 'td', year: 1720, imagePath: 'flag_history_td_1720', description: '乍得 1720年国旗' }
    ]
  },
  {
    countryCode: 'tg',
    history: [
      { countryCode: 'tg', year: 1700, imagePath: 'flag_history_tg_1700', description: '多哥 1700年国旗' },
      { countryCode: 'tg', year: 1710, imagePath: 'flag_history_tg_1710', description: '多哥 1710年国旗' },
      { countryCode: 'tg', year: 1720, imagePath: 'flag_history_tg_1720', description: '多哥 1720年国旗' },
      { countryCode: 'tg', year: 1730, imagePath: 'flag_history_tg_1730', description: '多哥 1730年国旗' },
      { countryCode: 'tg', year: 1740, imagePath: 'flag_history_tg_1740', description: '多哥 1740年国旗' },
      { countryCode: 'tg', year: 1750, imagePath: 'flag_history_tg_1750', description: '多哥 1750年国旗' }
    ]
  },
  {
    countryCode: 'th',
    history: [
      { countryCode: 'th', year: 1700, imagePath: 'flag_history_th_1700', description: '泰国 1700年国旗' },
      { countryCode: 'th', year: 1710, imagePath: 'flag_history_th_1710', description: '泰国 1710年国旗' },
      { countryCode: 'th', year: 1720, imagePath: 'flag_history_th_1720', description: '泰国 1720年国旗' },
      { countryCode: 'th', year: 1730, imagePath: 'flag_history_th_1730', description: '泰国 1730年国旗' },
      { countryCode: 'th', year: 1740, imagePath: 'flag_history_th_1740', description: '泰国 1740年国旗' },
      { countryCode: 'th', year: 1750, imagePath: 'flag_history_th_1750', description: '泰国 1750年国旗' },
      { countryCode: 'th', year: 1760, imagePath: 'flag_history_th_1760', description: '泰国 1760年国旗' }
    ]
  },
  {
    countryCode: 'tj',
    history: [
      { countryCode: 'tj', year: 1700, imagePath: 'flag_history_tj_1700', description: '塔吉克斯坦 1700年国旗' },
      { countryCode: 'tj', year: 1710, imagePath: 'flag_history_tj_1710', description: '塔吉克斯坦 1710年国旗' },
      { countryCode: 'tj', year: 1720, imagePath: 'flag_history_tj_1720', description: '塔吉克斯坦 1720年国旗' },
      { countryCode: 'tj', year: 1730, imagePath: 'flag_history_tj_1730', description: '塔吉克斯坦 1730年国旗' },
      { countryCode: 'tj', year: 1740, imagePath: 'flag_history_tj_1740', description: '塔吉克斯坦 1740年国旗' },
      { countryCode: 'tj', year: 1750, imagePath: 'flag_history_tj_1750', description: '塔吉克斯坦 1750年国旗' },
      { countryCode: 'tj', year: 1760, imagePath: 'flag_history_tj_1760', description: '塔吉克斯坦 1760年国旗' }
    ]
  },
  {
    countryCode: 'tl',
    history: [
      { countryCode: 'tl', year: 1700, imagePath: 'flag_history_tl_1700', description: '东帝汶 1700年国旗' },
      { countryCode: 'tl', year: 1710, imagePath: 'flag_history_tl_1710', description: '东帝汶 1710年国旗' },
      { countryCode: 'tl', year: 1720, imagePath: 'flag_history_tl_1720', description: '东帝汶 1720年国旗' },
      { countryCode: 'tl', year: 1730, imagePath: 'flag_history_tl_1730', description: '东帝汶 1730年国旗' },
      { countryCode: 'tl', year: 1740, imagePath: 'flag_history_tl_1740', description: '东帝汶 1740年国旗' },
      { countryCode: 'tl', year: 1750, imagePath: 'flag_history_tl_1750', description: '东帝汶 1750年国旗' },
      { countryCode: 'tl', year: 1760, imagePath: 'flag_history_tl_1760', description: '东帝汶 1760年国旗' },
      { countryCode: 'tl', year: 1770, imagePath: 'flag_history_tl_1770', description: '东帝汶 1770年国旗' },
      { countryCode: 'tl', year: 1780, imagePath: 'flag_history_tl_1780', description: '东帝汶 1780年国旗' },
      { countryCode: 'tl', year: 1790, imagePath: 'flag_history_tl_1790', description: '东帝汶 1790年国旗' },
      { countryCode: 'tl', year: 1800, imagePath: 'flag_history_tl_1800', description: '东帝汶 1800年国旗' }
    ]
  },
  {
    countryCode: 'tm',
    history: [
      { countryCode: 'tm', year: 1700, imagePath: 'flag_history_tm_1700', description: '土库曼斯坦 1700年国旗' },
      { countryCode: 'tm', year: 1710, imagePath: 'flag_history_tm_1710', description: '土库曼斯坦 1710年国旗' },
      { countryCode: 'tm', year: 1720, imagePath: 'flag_history_tm_1720', description: '土库曼斯坦 1720年国旗' },
      { countryCode: 'tm', year: 1730, imagePath: 'flag_history_tm_1730', description: '土库曼斯坦 1730年国旗' },
      { countryCode: 'tm', year: 1740, imagePath: 'flag_history_tm_1740', description: '土库曼斯坦 1740年国旗' },
      { countryCode: 'tm', year: 1750, imagePath: 'flag_history_tm_1750', description: '土库曼斯坦 1750年国旗' },
      { countryCode: 'tm', year: 1760, imagePath: 'flag_history_tm_1760', description: '土库曼斯坦 1760年国旗' }
    ]
  },
  {
    countryCode: 'tn',
    history: [
      { countryCode: 'tn', year: 1700, imagePath: 'flag_history_tn_1700', description: '突尼斯 1700年国旗' },
      { countryCode: 'tn', year: 1710, imagePath: 'flag_history_tn_1710', description: '突尼斯 1710年国旗' },
      { countryCode: 'tn', year: 1720, imagePath: 'flag_history_tn_1720', description: '突尼斯 1720年国旗' }
    ]
  },
  {
    countryCode: 'to',
    history: [
      { countryCode: 'to', year: 1700, imagePath: 'flag_history_to_1700', description: '汤加 1700年国旗' },
      { countryCode: 'to', year: 1710, imagePath: 'flag_history_to_1710', description: '汤加 1710年国旗' }
    ]
  },
  {
    countryCode: 'tr',
    history: [
      { countryCode: 'tr', year: 1700, imagePath: 'flag_history_tr_1700', description: '土耳其 1700年国旗' },
      { countryCode: 'tr', year: 1710, imagePath: 'flag_history_tr_1710', description: '土耳其 1710年国旗' },
      { countryCode: 'tr', year: 1720, imagePath: 'flag_history_tr_1720', description: '土耳其 1720年国旗' }
    ]
  },
  {
    countryCode: 'tt',
    history: [
      { countryCode: 'tt', year: 1700, imagePath: 'flag_history_tt_1700', description: '特立尼达和多巴哥 1700年国旗' },
      { countryCode: 'tt', year: 1710, imagePath: 'flag_history_tt_1710', description: '特立尼达和多巴哥 1710年国旗' },
      { countryCode: 'tt', year: 1720, imagePath: 'flag_history_tt_1720', description: '特立尼达和多巴哥 1720年国旗' },
      { countryCode: 'tt', year: 1730, imagePath: 'flag_history_tt_1730', description: '特立尼达和多巴哥 1730年国旗' },
      { countryCode: 'tt', year: 1740, imagePath: 'flag_history_tt_1740', description: '特立尼达和多巴哥 1740年国旗' }
    ]
  },
  {
    countryCode: 'tv',
    history: [
      { countryCode: 'tv', year: 1700, imagePath: 'flag_history_tv_1700', description: '图瓦卢 1700年国旗' },
      { countryCode: 'tv', year: 1710, imagePath: 'flag_history_tv_1710', description: '图瓦卢 1710年国旗' },
      { countryCode: 'tv', year: 1720, imagePath: 'flag_history_tv_1720', description: '图瓦卢 1720年国旗' },
      { countryCode: 'tv', year: 1730, imagePath: 'flag_history_tv_1730', description: '图瓦卢 1730年国旗' },
      { countryCode: 'tv', year: 1740, imagePath: 'flag_history_tv_1740', description: '图瓦卢 1740年国旗' },
      { countryCode: 'tv', year: 1750, imagePath: 'flag_history_tv_1750', description: '图瓦卢 1750年国旗' },
      { countryCode: 'tv', year: 1760, imagePath: 'flag_history_tv_1760', description: '图瓦卢 1760年国旗' }
    ]
  },
  {
    countryCode: 'tz',
    history: [
      { countryCode: 'tz', year: 1700, imagePath: 'flag_history_tz_1700', description: '坦桑尼亚 1700年国旗' },
      { countryCode: 'tz', year: 1710, imagePath: 'flag_history_tz_1710', description: '坦桑尼亚 1710年国旗' },
      { countryCode: 'tz', year: 1720, imagePath: 'flag_history_tz_1720', description: '坦桑尼亚 1720年国旗' },
      { countryCode: 'tz', year: 1730, imagePath: 'flag_history_tz_1730', description: '坦桑尼亚 1730年国旗' },
      { countryCode: 'tz', year: 1740, imagePath: 'flag_history_tz_1740', description: '坦桑尼亚 1740年国旗' }
    ]
  },
  {
    countryCode: 'ua',
    history: [
      { countryCode: 'ua', year: 1700, imagePath: 'flag_history_ua_1700', description: '乌克兰 1700年国旗' },
      { countryCode: 'ua', year: 1710, imagePath: 'flag_history_ua_1710', description: '乌克兰 1710年国旗' },
      { countryCode: 'ua', year: 1720, imagePath: 'flag_history_ua_1720', description: '乌克兰 1720年国旗' },
      { countryCode: 'ua', year: 1730, imagePath: 'flag_history_ua_1730', description: '乌克兰 1730年国旗' },
      { countryCode: 'ua', year: 1740, imagePath: 'flag_history_ua_1740', description: '乌克兰 1740年国旗' },
      { countryCode: 'ua', year: 1750, imagePath: 'flag_history_ua_1750', description: '乌克兰 1750年国旗' },
      { countryCode: 'ua', year: 1760, imagePath: 'flag_history_ua_1760', description: '乌克兰 1760年国旗' },
      { countryCode: 'ua', year: 1770, imagePath: 'flag_history_ua_1770', description: '乌克兰 1770年国旗' },
      { countryCode: 'ua', year: 1780, imagePath: 'flag_history_ua_1780', description: '乌克兰 1780年国旗' },
      { countryCode: 'ua', year: 1790, imagePath: 'flag_history_ua_1790', description: '乌克兰 1790年国旗' },
      { countryCode: 'ua', year: 1800, imagePath: 'flag_history_ua_1800', description: '乌克兰 1800年国旗' },
      { countryCode: 'ua', year: 1810, imagePath: 'flag_history_ua_1810', description: '乌克兰 1810年国旗' }
    ]
  },
  {
    countryCode: 'ug',
    history: [
      { countryCode: 'ug', year: 1700, imagePath: 'flag_history_ug_1700', description: '乌干达 1700年国旗' },
      { countryCode: 'ug', year: 1710, imagePath: 'flag_history_ug_1710', description: '乌干达 1710年国旗' },
      { countryCode: 'ug', year: 1720, imagePath: 'flag_history_ug_1720', description: '乌干达 1720年国旗' },
      { countryCode: 'ug', year: 1730, imagePath: 'flag_history_ug_1730', description: '乌干达 1730年国旗' },
      { countryCode: 'ug', year: 1740, imagePath: 'flag_history_ug_1740', description: '乌干达 1740年国旗' }
    ]
  },
  {
    countryCode: 'us',
    history: [
      { countryCode: 'us', year: 1700, imagePath: 'flag_history_us_1700', description: '美国 1700年国旗' },
      { countryCode: 'us', year: 1710, imagePath: 'flag_history_us_1710', description: '美国 1710年国旗' },
      { countryCode: 'us', year: 1720, imagePath: 'flag_history_us_1720', description: '美国 1720年国旗' },
      { countryCode: 'us', year: 1730, imagePath: 'flag_history_us_1730', description: '美国 1730年国旗' },
      { countryCode: 'us', year: 1740, imagePath: 'flag_history_us_1740', description: '美国 1740年国旗' },
      { countryCode: 'us', year: 1750, imagePath: 'flag_history_us_1750', description: '美国 1750年国旗' },
      { countryCode: 'us', year: 1760, imagePath: 'flag_history_us_1760', description: '美国 1760年国旗' },
      { countryCode: 'us', year: 1770, imagePath: 'flag_history_us_1770', description: '美国 1770年国旗' },
      { countryCode: 'us', year: 1780, imagePath: 'flag_history_us_1780', description: '美国 1780年国旗' },
      { countryCode: 'us', year: 1790, imagePath: 'flag_history_us_1790', description: '美国 1790年国旗' },
      { countryCode: 'us', year: 1800, imagePath: 'flag_history_us_1800', description: '美国 1800年国旗' },
      { countryCode: 'us', year: 1810, imagePath: 'flag_history_us_1810', description: '美国 1810年国旗' },
      { countryCode: 'us', year: 1820, imagePath: 'flag_history_us_1820', description: '美国 1820年国旗' },
      { countryCode: 'us', year: 1830, imagePath: 'flag_history_us_1830', description: '美国 1830年国旗' },
      { countryCode: 'us', year: 1840, imagePath: 'flag_history_us_1840', description: '美国 1840年国旗' },
      { countryCode: 'us', year: 1850, imagePath: 'flag_history_us_1850', description: '美国 1850年国旗' },
      { countryCode: 'us', year: 1860, imagePath: 'flag_history_us_1860', description: '美国 1860年国旗' },
      { countryCode: 'us', year: 1870, imagePath: 'flag_history_us_1870', description: '美国 1870年国旗' },
      { countryCode: 'us', year: 1880, imagePath: 'flag_history_us_1880', description: '美国 1880年国旗' },
      { countryCode: 'us', year: 1890, imagePath: 'flag_history_us_1890', description: '美国 1890年国旗' },
      { countryCode: 'us', year: 1900, imagePath: 'flag_history_us_1900', description: '美国 1900年国旗' },
      { countryCode: 'us', year: 1910, imagePath: 'flag_history_us_1910', description: '美国 1910年国旗' },
      { countryCode: 'us', year: 1920, imagePath: 'flag_history_us_1920', description: '美国 1920年国旗' },
      { countryCode: 'us', year: 1930, imagePath: 'flag_history_us_1930', description: '美国 1930年国旗' },
      { countryCode: 'us', year: 1940, imagePath: 'flag_history_us_1940', description: '美国 1940年国旗' },
      { countryCode: 'us', year: 1950, imagePath: 'flag_history_us_1950', description: '美国 1950年国旗' }
    ]
  },
  {
    countryCode: 'uy',
    history: [
      { countryCode: 'uy', year: 1700, imagePath: 'flag_history_uy_1700', description: '乌拉圭 1700年国旗' },
      { countryCode: 'uy', year: 1710, imagePath: 'flag_history_uy_1710', description: '乌拉圭 1710年国旗' },
      { countryCode: 'uy', year: 1720, imagePath: 'flag_history_uy_1720', description: '乌拉圭 1720年国旗' },
      { countryCode: 'uy', year: 1730, imagePath: 'flag_history_uy_1730', description: '乌拉圭 1730年国旗' },
      { countryCode: 'uy', year: 1740, imagePath: 'flag_history_uy_1740', description: '乌拉圭 1740年国旗' },
      { countryCode: 'uy', year: 1760, imagePath: 'flag_history_uy_1760', description: '乌拉圭 1760年国旗' },
      { countryCode: 'uy', year: 1770, imagePath: 'flag_history_uy_1770', description: '乌拉圭 1770年国旗' },
      { countryCode: 'uy', year: 1780, imagePath: 'flag_history_uy_1780', description: '乌拉圭 1780年国旗' }
    ]
  },
  {
    countryCode: 'uz',
    history: [
      { countryCode: 'uz', year: 1700, imagePath: 'flag_history_uz_1700', description: '乌兹别克斯坦 1700年国旗' },
      { countryCode: 'uz', year: 1710, imagePath: 'flag_history_uz_1710', description: '乌兹别克斯坦 1710年国旗' },
      { countryCode: 'uz', year: 1720, imagePath: 'flag_history_uz_1720', description: '乌兹别克斯坦 1720年国旗' },
      { countryCode: 'uz', year: 1730, imagePath: 'flag_history_uz_1730', description: '乌兹别克斯坦 1730年国旗' },
      { countryCode: 'uz', year: 1740, imagePath: 'flag_history_uz_1740', description: '乌兹别克斯坦 1740年国旗' },
      { countryCode: 'uz', year: 1750, imagePath: 'flag_history_uz_1750', description: '乌兹别克斯坦 1750年国旗' }
    ]
  },
  {
    countryCode: 'va',
    history: [
      { countryCode: 'va', year: 1700, imagePath: 'flag_history_va_1700', description: '梵蒂冈 1700年国旗' },
      { countryCode: 'va', year: 1710, imagePath: 'flag_history_va_1710', description: '梵蒂冈 1710年国旗' },
      { countryCode: 'va', year: 1720, imagePath: 'flag_history_va_1720', description: '梵蒂冈 1720年国旗' },
      { countryCode: 'va', year: 1730, imagePath: 'flag_history_va_1730', description: '梵蒂冈 1730年国旗' }
    ]
  },
  {
    countryCode: 'vc',
    history: [
      { countryCode: 'vc', year: 1700, imagePath: 'flag_history_vc_1700', description: '圣文森特和格林纳丁斯 1700年国旗' },
      { countryCode: 'vc', year: 1710, imagePath: 'flag_history_vc_1710', description: '圣文森特和格林纳丁斯 1710年国旗' },
      { countryCode: 'vc', year: 1720, imagePath: 'flag_history_vc_1720', description: '圣文森特和格林纳丁斯 1720年国旗' },
      { countryCode: 'vc', year: 1730, imagePath: 'flag_history_vc_1730', description: '圣文森特和格林纳丁斯 1730年国旗' },
      { countryCode: 'vc', year: 1740, imagePath: 'flag_history_vc_1740', description: '圣文森特和格林纳丁斯 1740年国旗' },
      { countryCode: 'vc', year: 1750, imagePath: 'flag_history_vc_1750', description: '圣文森特和格林纳丁斯 1750年国旗' },
      { countryCode: 'vc', year: 1760, imagePath: 'flag_history_vc_1760', description: '圣文森特和格林纳丁斯 1760年国旗' },
      { countryCode: 'vc', year: 1770, imagePath: 'flag_history_vc_1770', description: '圣文森特和格林纳丁斯 1770年国旗' },
      { countryCode: 'vc', year: 1780, imagePath: 'flag_history_vc_1780', description: '圣文森特和格林纳丁斯 1780年国旗' },
      { countryCode: 'vc', year: 1790, imagePath: 'flag_history_vc_1790', description: '圣文森特和格林纳丁斯 1790年国旗' },
      { countryCode: 'vc', year: 1800, imagePath: 'flag_history_vc_1800', description: '圣文森特和格林纳丁斯 1800年国旗' }
    ]
  },
  {
    countryCode: 've',
    history: [
      { countryCode: 've', year: 1700, imagePath: 'flag_history_ve_1700', description: '委内瑞拉 1700年国旗' },
      { countryCode: 've', year: 1710, imagePath: 'flag_history_ve_1710', description: '委内瑞拉 1710年国旗' },
      { countryCode: 've', year: 1720, imagePath: 'flag_history_ve_1720', description: '委内瑞拉 1720年国旗' },
      { countryCode: 've', year: 1730, imagePath: 'flag_history_ve_1730', description: '委内瑞拉 1730年国旗' },
      { countryCode: 've', year: 1740, imagePath: 'flag_history_ve_1740', description: '委内瑞拉 1740年国旗' },
      { countryCode: 've', year: 1750, imagePath: 'flag_history_ve_1750', description: '委内瑞拉 1750年国旗' },
      { countryCode: 've', year: 1760, imagePath: 'flag_history_ve_1760', description: '委内瑞拉 1760年国旗' },
      { countryCode: 've', year: 1770, imagePath: 'flag_history_ve_1770', description: '委内瑞拉 1770年国旗' },
      { countryCode: 've', year: 1780, imagePath: 'flag_history_ve_1780', description: '委内瑞拉 1780年国旗' },
      { countryCode: 've', year: 1790, imagePath: 'flag_history_ve_1790', description: '委内瑞拉 1790年国旗' },
      { countryCode: 've', year: 1800, imagePath: 'flag_history_ve_1800', description: '委内瑞拉 1800年国旗' },
      { countryCode: 've', year: 1810, imagePath: 'flag_history_ve_1810', description: '委内瑞拉 1810年国旗' },
      { countryCode: 've', year: 1820, imagePath: 'flag_history_ve_1820', description: '委内瑞拉 1820年国旗' },
      { countryCode: 've', year: 1830, imagePath: 'flag_history_ve_1830', description: '委内瑞拉 1830年国旗' },
      { countryCode: 've', year: 1840, imagePath: 'flag_history_ve_1840', description: '委内瑞拉 1840年国旗' },
      { countryCode: 've', year: 1850, imagePath: 'flag_history_ve_1850', description: '委内瑞拉 1850年国旗' }
    ]
  },
  {
    countryCode: 'vn',
    history: [
      { countryCode: 'vn', year: 1700, imagePath: 'flag_history_vn_1700', description: '越南 1700年国旗' },
      { countryCode: 'vn', year: 1710, imagePath: 'flag_history_vn_1710', description: '越南 1710年国旗' },
      { countryCode: 'vn', year: 1720, imagePath: 'flag_history_vn_1720', description: '越南 1720年国旗' },
      { countryCode: 'vn', year: 1730, imagePath: 'flag_history_vn_1730', description: '越南 1730年国旗' },
      { countryCode: 'vn', year: 1740, imagePath: 'flag_history_vn_1740', description: '越南 1740年国旗' },
      { countryCode: 'vn', year: 1750, imagePath: 'flag_history_vn_1750', description: '越南 1750年国旗' },
      { countryCode: 'vn', year: 1760, imagePath: 'flag_history_vn_1760', description: '越南 1760年国旗' },
      { countryCode: 'vn', year: 1770, imagePath: 'flag_history_vn_1770', description: '越南 1770年国旗' },
      { countryCode: 'vn', year: 1780, imagePath: 'flag_history_vn_1780', description: '越南 1780年国旗' }
    ]
  },
  {
    countryCode: 'vu',
    history: [
      { countryCode: 'vu', year: 1700, imagePath: 'flag_history_vu_1700', description: '瓦努阿图 1700年国旗' },
      { countryCode: 'vu', year: 1710, imagePath: 'flag_history_vu_1710', description: '瓦努阿图 1710年国旗' },
      { countryCode: 'vu', year: 1720, imagePath: 'flag_history_vu_1720', description: '瓦努阿图 1720年国旗' },
      { countryCode: 'vu', year: 1730, imagePath: 'flag_history_vu_1730', description: '瓦努阿图 1730年国旗' }
    ]
  },
  {
    countryCode: 'ws',
    history: [
      { countryCode: 'ws', year: 1700, imagePath: 'flag_history_ws_1700', description: '萨摩亚 1700年国旗' },
      { countryCode: 'ws', year: 1710, imagePath: 'flag_history_ws_1710', description: '萨摩亚 1710年国旗' },
      { countryCode: 'ws', year: 1720, imagePath: 'flag_history_ws_1720', description: '萨摩亚 1720年国旗' },
      { countryCode: 'ws', year: 1730, imagePath: 'flag_history_ws_1730', description: '萨摩亚 1730年国旗' },
      { countryCode: 'ws', year: 1750, imagePath: 'flag_history_ws_1750', description: '萨摩亚 1750年国旗' },
      { countryCode: 'ws', year: 1760, imagePath: 'flag_history_ws_1760', description: '萨摩亚 1760年国旗' }
    ]
  },
  {
    countryCode: 'xk',
    history: [
      { countryCode: 'xk', year: 1710, imagePath: 'flag_history_xk_1710', description: '科索沃 1710年国旗' },
      { countryCode: 'xk', year: 1720, imagePath: 'flag_history_xk_1720', description: '科索沃 1720年国旗' },
      { countryCode: 'xk', year: 1730, imagePath: 'flag_history_xk_1730', description: '科索沃 1730年国旗' },
      { countryCode: 'xk', year: 1740, imagePath: 'flag_history_xk_1740', description: '科索沃 1740年国旗' },
      { countryCode: 'xk', year: 1750, imagePath: 'flag_history_xk_1750', description: '科索沃 1750年国旗' },
      { countryCode: 'xk', year: 1760, imagePath: 'flag_history_xk_1760', description: '科索沃 1760年国旗' },
      { countryCode: 'xk', year: 1770, imagePath: 'flag_history_xk_1770', description: '科索沃 1770年国旗' },
      { countryCode: 'xk', year: 1780, imagePath: 'flag_history_xk_1780', description: '科索沃 1780年国旗' },
      { countryCode: 'xk', year: 1790, imagePath: 'flag_history_xk_1790', description: '科索沃 1790年国旗' }
    ]
  },
  {
    countryCode: 'ye',
    history: [
      { countryCode: 'ye', year: 1700, imagePath: 'flag_history_ye_1700', description: '也门 1700年国旗' },
      { countryCode: 'ye', year: 1720, imagePath: 'flag_history_ye_1720', description: '也门 1720年国旗' },
      { countryCode: 'ye', year: 1740, imagePath: 'flag_history_ye_1740', description: '也门 1740年国旗' },
      { countryCode: 'ye', year: 1750, imagePath: 'flag_history_ye_1750', description: '也门 1750年国旗' },
      { countryCode: 'ye', year: 1760, imagePath: 'flag_history_ye_1760', description: '也门 1760年国旗' },
      { countryCode: 'ye', year: 1770, imagePath: 'flag_history_ye_1770', description: '也门 1770年国旗' }
    ]
  },
  {
    countryCode: 'za',
    history: [
      { countryCode: 'za', year: 1700, imagePath: 'flag_history_za_1700', description: '南非 1700年国旗' },
      { countryCode: 'za', year: 1710, imagePath: 'flag_history_za_1710', description: '南非 1710年国旗' },
      { countryCode: 'za', year: 1720, imagePath: 'flag_history_za_1720', description: '南非 1720年国旗' },
      { countryCode: 'za', year: 1730, imagePath: 'flag_history_za_1730', description: '南非 1730年国旗' },
      { countryCode: 'za', year: 1740, imagePath: 'flag_history_za_1740', description: '南非 1740年国旗' },
      { countryCode: 'za', year: 1750, imagePath: 'flag_history_za_1750', description: '南非 1750年国旗' },
      { countryCode: 'za', year: 1760, imagePath: 'flag_history_za_1760', description: '南非 1760年国旗' },
      { countryCode: 'za', year: 1770, imagePath: 'flag_history_za_1770', description: '南非 1770年国旗' }
    ]
  },
  {
    countryCode: 'zm',
    history: [
      { countryCode: 'zm', year: 1700, imagePath: 'flag_history_zm_1700', description: '赞比亚 1700年国旗' },
      { countryCode: 'zm', year: 1710, imagePath: 'flag_history_zm_1710', description: '赞比亚 1710年国旗' },
      { countryCode: 'zm', year: 1720, imagePath: 'flag_history_zm_1720', description: '赞比亚 1720年国旗' },
      { countryCode: 'zm', year: 1730, imagePath: 'flag_history_zm_1730', description: '赞比亚 1730年国旗' },
      { countryCode: 'zm', year: 1740, imagePath: 'flag_history_zm_1740', description: '赞比亚 1740年国旗' },
      { countryCode: 'zm', year: 1750, imagePath: 'flag_history_zm_1750', description: '赞比亚 1750年国旗' }
    ]
  },
  {
    countryCode: 'zw',
    history: [
      { countryCode: 'zw', year: 1700, imagePath: 'flag_history_zw_1700', description: '津巴布韦 1700年国旗' },
      { countryCode: 'zw', year: 1710, imagePath: 'flag_history_zw_1710', description: '津巴布韦 1710年国旗' },
      { countryCode: 'zw', year: 1720, imagePath: 'flag_history_zw_1720', description: '津巴布韦 1720年国旗' },
      { countryCode: 'zw', year: 1730, imagePath: 'flag_history_zw_1730', description: '津巴布韦 1730年国旗' },
      { countryCode: 'zw', year: 1740, imagePath: 'flag_history_zw_1740', description: '津巴布韦 1740年国旗' },
      { countryCode: 'zw', year: 1750, imagePath: 'flag_history_zw_1750', description: '津巴布韦 1750年国旗' },
      { countryCode: 'zw', year: 1760, imagePath: 'flag_history_zw_1760', description: '津巴布韦 1760年国旗' },
      { countryCode: 'zw', year: 1770, imagePath: 'flag_history_zw_1770', description: '津巴布韦 1770年国旗' },
      { countryCode: 'zw', year: 1780, imagePath: 'flag_history_zw_1780', description: '津巴布韦 1780年国旗' }
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
