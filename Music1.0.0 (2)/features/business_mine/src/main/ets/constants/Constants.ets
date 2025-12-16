import { RouterMap } from 'lib_common';
import { MineGridItem } from '../types/Types';

export const mineGridList: MineGridItem[] = [
  {
    icon: $r('app.media.shouc'),
    label: '我的喜欢',
    routerName: RouterMap.MINE_MARK_PAGE,
  },
  {
    icon: $r('app.media.gedan'),
    label: '我的歌单',
    routerName: RouterMap.MINE_MUSIC_PAGE,
  },
  {
    icon: $r('app.media.xiaz'),
    label: '本地歌曲',
    routerName: RouterMap.LOCALSONGS_PAGE,
  }
];

/**
 * 离线WebID映射表
 */
export enum WebIdMap {
  ChatWebId = 'webId1',
}

export class Constants {
  public static readonly NEWS_IMAGE_WIDTH: number = 96;
  public static readonly NEWS_IMAGE_HEIGHT: number = 72;
  public static readonly NORMAL_BTN_H: number = 40;
  public static readonly SMALL_BTN_W: number = 72;
  public static readonly SMALL_BTN_H: number = 28;
}
