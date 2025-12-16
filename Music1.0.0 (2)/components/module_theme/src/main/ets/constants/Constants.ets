import { IThemeInfo } from '../types/Types';

// 页面名
export enum ThemePage {
  /**
   * 主题列表页
   */
  THEME_LIST = 'ThemeList',
  /**
   * 主题详情页
   */
  THEME_DETAIL = 'ThemeDetail',
}

// #ff090909
export const THEME_LIST: IThemeInfo[] = [
  {
    id: 0,
    pics: ['theme0', 'theme_y_0'], // ['无内容背景图'，'有内容背景图‘]]
    colors: ['#FFFA2840', '#FFFFFFFF', '#E6000000', '#8c8b8b', '#99000000', '#FFFFFFFF',
      '#0D000000'], // ['主题色'，'播放条‘，’一级字体‘，'tab未选中','二级字体','主色反色字体','搜索背景']
    label: '默认',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: false,
    isDownload: false
  },
  {
    id: 1,
    pics: ['theme1', 'theme_y_1', 'theme_min_1'],
    colors: ['#FF2C79F4', '#FFFFFFFF', '#E6000000', '#99000000', '#99000000', '#FFFFFFFF', '#0D000000'],
    label: '天空',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: true,
    isDownload: false
  },
  {
    id: 2,
    pics: ['theme2', 'theme_y_2', 'theme_min_2'],
    colors: ['#FFFFFFFF', '#ff242424', '#FFFFFFFF', '#99FFFFFF', '#FFFFFFFF', '#ff242424', '#0DFFFFFF'],
    label: '雨夜',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: false,
    isDownload: false
  },
  {
    id: 3,
    pics: ['theme3', 'theme_y_3', 'theme_min_3'],
    colors: ['#FFFFFFFF', '#ff242424', '#FFFFFFFF', '#99FFFFFF', '#99FFFFFF', '#ff242424', '#0DFFFFFF'],
    label: '城市夜',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: false,
    isDownload: false
  },
  {
    id: 4,
    pics: ['theme4', 'theme_y_4'],
    colors: ['#FF28BF92', '#FFFFFFFF', '#E6000000', '#99777575', '#99000000', '#FFFFFFFF', '#0D000000'],
    label: '城市',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: false,
    isDownload: false
  },
  {
    id: 5,
    pics: ['theme5', 'theme_y_5'],
    colors: ['#FFFFFFFF', '#ff242424', '#FFFFFFFF', '#99FFFFFF', '#FFFFFFFF', '#ff242424', '#0DFFFFFF'],
    label: '星空',
    desc: '漫游城市，探索车水马龙与人文',
    isVip: true,
    isDownload: false
  },
  {
    id: 6,
    pics: ['theme6', 'theme_y_6'],
    colors: ['#FF9661D9', '#FFFFFFFF', '#E6000000', '#99FFFFFF', '#99000000', '#FFFFFFFF', '#0D000000'],
    label: '日落',
    desc: '领略四季，走进自然和奇幻世界',
    isVip: false,
    isDownload: false
  },
  {
    id: 7,
    pics: ['theme7', 'theme_y_7'],
    colors: ['#ff367ecf', '#FFFFFFFF', '#E6000000', '#8c8b8b', '#99000000', '#FFFFFFFF', '#0D000000'],
    label: '冰山',
    desc: '领略四季，走进自然和奇幻世界',
    isVip: false,
    isDownload: false
  }
];