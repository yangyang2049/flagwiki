import { CommonConstants, RouterUtils, UserInfoModel } from 'lib_common';
import { VipCenter } from 'module_vip_center';
import { PersistenceV2 } from '@kit.ArkUI';

@Builder
export function VipCenterPageBuilder() {
  VipCenterPage()
}

@ComponentV2
struct VipCenterPage {
  stack: NavPathStack = RouterUtils.getStack();
  @Local userInfo: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  build() {
    NavDestination() {
      Column() {
        VipCenter({
          userName: this.userInfo.authorNickName,
          avatar: this.userInfo.authorIcon,
          isVip: this.userInfo.isVip,
          vipType: '',
          routerModule: this.stack,
          onVipOpen: () => {
            this.userInfo.isVip = true;
          },
          onCancelVip: () => {
            this.userInfo.isVip = false;
          }
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
  }
}