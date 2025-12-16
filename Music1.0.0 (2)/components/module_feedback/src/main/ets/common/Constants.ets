export class Constants {
  static readonly FULL_PERCENT: string = '100%';
  static readonly HALF_PERCENT: string = '50%';
  static readonly TITLE_HEIGHT: number = 56;
  static readonly TITLE_ICON_WIDTH: number = 40;
  static readonly ICON_WIDTH: number = 24;
  static readonly SPACE_8: number = 8;
  static readonly SPACE_12: number = 12;
  static readonly PADDING_PAGE: number = 16;
  static readonly PADDING_XS: number = 4;
  static readonly PADDING_S: number = 8;
  static readonly PADDING_M: number = 12;
  static readonly PADDING_L: number = 16;
  static readonly RADIUS_16: number = 16;
  static readonly BTN_HEIGHT: number = 40;
  static readonly TEXT_INPUT_HEIGHT: number = 48;
  static readonly MAX_IMG_COUNT: number = 5;
  static readonly PHONE_REG = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
}

export enum RouterMap {
  FEEDBACK_PAGE = 'FeedbackPage',
  FEEDBACK_RECORD_LIST_PAGE = 'FeedbackRecordListPage',
  FEEDBACK_SUBMIT_PAGE = 'FeedbackSubmitPage',
}

export interface ISettingItem {
  label: string;
  routerName: RouterMap;
}

export const LIST_INFO: ISettingItem[] = [
  {
    label: '反馈问题',
    routerName: RouterMap.FEEDBACK_SUBMIT_PAGE,
  },
  {
    label: '反馈记录',
    routerName: RouterMap.FEEDBACK_RECORD_LIST_PAGE,
  }
];
