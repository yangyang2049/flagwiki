import { Constants } from './Constants';

/**
 * 跳转登录路由参数
 */
export interface LoginRouterParams {
  isSheet?: boolean
  keepVM?: boolean
}

/**
 * 登录半模态弹窗参数
 */
@ObservedV2
export class LoginSheetParams {
  @Trace height: number = Constants.DEFAULT_LOGIN_SHEET_HEIGHT;
}
