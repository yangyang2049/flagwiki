import { PersistenceV2 } from '@ohos.arkui.StateManagement';
import { THEME_LIST } from '../constants/Constants';
import { CommonUtil } from './CommonUtil';
import { Logger } from './Logger';

@ObservedV2
export class ThemeModel {
  @Trace id: number = -1;
  //默认主题
  @Trace isDefaultTheme: boolean = true;
  // 主题背景图
  @Trace themePic: string = '';
  // 主题色
  @Trace themeColor: string = '#FF1949'
  // 主题色['主题色'，'播放条色‘，’播放条歌曲名色‘，'tab未选中色']
  @Trace themeColors: string[] = [];
  // 主题字体颜色
  @Trace fontSecondary: string = '#0D000000'
  // 断点
  @Trace breakpoint: string = 'sm'
  // 已下载的皮肤id
  @Trace downloadedThemeIds: number[] = [];
}

@ObservedV2
export class ThemeController {
  private static _theme: ThemeModel = PersistenceV2.connect(ThemeModel, 'theme', () => new ThemeModel())!;

  // 获取_theme
  public static get theme() {
    return ThemeController._theme;
  }

  @Computed
  public static get themePic() {
    Logger.info('ThemeController._theme is null' + JSON.stringify(ThemeController._theme))
    const theme = THEME_LIST.find(theme => theme.id === ThemeController._theme.id);
    if (theme?.id === 0) {
      ThemeController._theme.isDefaultTheme = true
      ThemeController._theme.themePic = '';
      ThemeController._theme.themeColor = '#FF1949';
      ThemeController._theme.themeColors = theme.colors;
      return null;
    } else {
      if (theme && theme.colors && theme.colors.length > 0) {
        ThemeController._theme.themeColor = theme.colors[0];
        ThemeController._theme.themePic = theme.pics[0];
        ThemeController._theme.themeColors = theme.colors;
      }
    }
    return $r(`app.media.${theme?.pics[0]}`);
  }

  @Computed
  public static get themeColor() {
    const theme = THEME_LIST.find(theme => theme.id === ThemeController._theme.id);
    return theme?.colors[CommonUtil.getTimeIntervalIndex() % theme.pics.length];
  }

  @Computed
  public static get themePics() {
    const theme = THEME_LIST.find(theme => theme.id === ThemeController._theme.id) ?? THEME_LIST[0];
    return theme.pics = [theme.pics[1]]
  }

  @Computed
  public static get themeLabel() {
    const theme = THEME_LIST.find(theme => theme.id === ThemeController._theme.id) ?? THEME_LIST[0];
    return theme.label;
  }

  public static getThemeId() {
    return ThemeController._theme.id;
  }

  public static getThemeById(id: number) {
    const theme = THEME_LIST.find(theme => theme.id === id) ?? THEME_LIST[0];
    return theme;
  }

  public static getThemePicsById(id: number) {
    const theme = THEME_LIST.find(theme => theme.id === id) ?? THEME_LIST[0];
    return theme.pics.map(s => $r(`app.media.${s.concat('_home')}`));
  }

  /**
   * 切换主题
   * @param id
   */
  public static change(id: number) {
    ThemeController._theme.id = id;
    const theme = THEME_LIST.find(theme => theme.id === ThemeController._theme.id);
    if (theme === null) {
      return
    }
    if (id === 0) {
      ThemeController._theme.isDefaultTheme = true
      ThemeController._theme.themePic = '';
    } else {
      ThemeController._theme.themePic = theme?.pics[0] ?? '';
      ThemeController._theme.isDefaultTheme = false
    }

    ThemeController._theme.themeColor = theme?.colors[0] ?? '';
    ThemeController._theme.fontSecondary = theme?.colors[3] ?? '';
    ThemeController._theme.themeColors = theme?.colors ?? [];
    // 模拟记录下载
    if (!ThemeController._theme.downloadedThemeIds.includes(id)) {
      ThemeController._theme.downloadedThemeIds.push(id);
    }
  }

  // 判断是否已经下载
  public static isDownloaded(id: number) {
    return ThemeController._theme.downloadedThemeIds.includes(id);
  }
}

