import { RouterMap } from 'lib_common';

export interface TabBarItem {
  id: TabBarType;
  title: ResourceStr;
  activeIcon: ResourceStr;
}

export enum TabBarType {
  HOME = 0,
  MINE
}

export const TABS_INFO: TabBarItem[] = [
  {
    id: TabBarType.HOME,
    title: '首页',
    activeIcon: $r('app.media.ic_tab_home'),
  },
  {
    id: TabBarType.MINE,
    title: '我的',
    activeIcon: $r('app.media.ic_tab_mine'),
  },
]

/**
 * 依赖登录的页面
 */
export const REQUIRE_LOGIN_PAGE_LIST: RouterMap[] = [
  RouterMap.MINE_MARK_PAGE,
  RouterMap.FEEDBACK_PAGE,
  RouterMap.LOCALSONGS_PAGE,
  RouterMap.MINE_MUSIC_PAGE,
  RouterMap.MINE_ONE_PLAY_LIST,
  RouterMap.ADD_ONE_PLAY_LIST,
  RouterMap.MINE_MARK_PAGE,
  RouterMap.THEMELIST_PAGE,
  RouterMap.THEME_LIST,
  RouterMap.SETTING_PAGE
];

export const agreePrivacyKey: string = 'isAgreePrivacy';

export const SOURCE_FORM_CARD: string = 'FormCard';

export const NEWS_DETAIL_PAGE: string = 'NewsDetailPage';

export const ISFIRST_GUIDE: string = 'isFirstGuide';
