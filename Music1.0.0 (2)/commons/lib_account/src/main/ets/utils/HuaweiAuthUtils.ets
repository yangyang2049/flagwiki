import { authentication } from '@kit.AccountKit';
import { Logger } from 'lib_common';

const TAG = '[HuaweiAuthUtils]';

/**
 * 华为登录认证工具类
 */
export class HuaweiAuthUtils {
  /**
   * 获取匿名手机号
   */
  static async quickLoginAnonymousPhone() {
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    authRequest.scopes = ['quickLoginAnonymousPhone'];
    authRequest.forceAuthorization = false;
    const controller = new authentication.AuthenticationController();
    let quickLoginAnonymousPhone: string = '';
    let unionID: string = '';
    try {
      const response: authentication.AuthorizationWithHuaweiIDResponse = await controller.executeRequest(authRequest);
      unionID = response.data?.unionID as string;
      quickLoginAnonymousPhone = response.data?.extraInfo?.quickLoginAnonymousPhone as string ?? '';
      Logger.info(TAG,
        `Succeeded in authorizing. unionID is ${unionID}, quickLoginAnonymousPhone is ${quickLoginAnonymousPhone}`);
      return quickLoginAnonymousPhone;
    } catch (error) {
      Logger.error(TAG,
        `Failed to authorize. errCode is ${error.code}, message is ${error.message}`);
      return quickLoginAnonymousPhone;
    }
  }
}