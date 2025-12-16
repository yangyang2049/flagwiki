import { AccountApi } from 'lib_account';
import { RouterMap, RouterUtils } from 'lib_common';

@Builder
export function SettingH5Builder() {
  SettingH5()
}

@ComponentV2
struct SettingH5 {
  @Local content: string = '';
  private accountInstance: AccountApi = new AccountApi();

  aboutToAppear(): void {
    this.getParams();
  }

  getParams() {
    const param = RouterUtils.getParamByName(RouterMap.SETTING_H5) as number
    switch (param) {
      case 1:
        this.content = this.accountInstance.getUserAgreeInfo();
        RouterUtils.replacePathByName(RouterMap.PROTOCOL_WEBVIEW, this.content);
        break;
      case 2:
        this.content = this.accountInstance.getPrivacyInfo();
        RouterUtils.replacePathByName(RouterMap.PROTOCOL_WEBVIEW, this.content);
        break;
      case 3:
        this.content = this.accountInstance.getThirdPartyInfo();
        RouterUtils.replacePathByName(RouterMap.PROTOCOL_WEBVIEW, this.content);
        break;
      case 4:
        this.content = this.accountInstance.getPersonalInfoCollection();
        RouterUtils.replacePathByName(RouterMap.PROTOCOL_WEBVIEW, this.content);
        break;
      default:
        this.content = '';
        RouterUtils.replacePathByName(RouterMap.PROTOCOL_WEBVIEW, this.content);
    }
  }

  build() {
    NavDestination() {
    }
    .hideTitleBar(true)
  }
}