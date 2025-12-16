import { CommonConstants, PreferenceUtils, RouterMap, RouterUtils, SettingModel } from 'lib_common';
import { agreePrivacyKey } from '../common/Constants';
import { PersistenceV2 } from '@kit.ArkUI';

/**
 * 非首次打开首屏页
 */
@Builder
export function StartPageBuilder() {
  StartPage()
}

@ComponentV2
struct StartPage {
  // todo: 自行调整是否支持开屏广告
  @Local isShowAd: boolean = true;
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;

  isAgreePrivacy() {
    return PreferenceUtils.getInstance().get(agreePrivacyKey) as boolean;
  }

  aboutToAppear(): void {
    setTimeout(() => {
      if (this.isAgreePrivacy()) {
        let targetPage = this.isShowAd ? RouterMap.SPLASH_PAGE : RouterMap.INDEX_PAGE;
        RouterUtils.replacePathByName(targetPage);
      } else {
        // 未同意 跳转到同意隐私协议页面
        RouterUtils.replacePathByName(RouterMap.SAFE_PAGE);
      }
    }, 500)
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Image($r('app.media.startIcon'))
            .width(116)
            .height(116)
            .draggable(false)
            .margin({ top: 215, bottom: 258 })
          Text('音乐模板')
            .fontSize($r('sys.float.Title_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.app_theme'))
            .height(32)
          Text('音乐也是如此美妙')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('app.color.app_theme'))
            .height(21)
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundImage($r('app.media.ic_start_background'))
        .backgroundImageSize({ width: '100%', height: '100%' })
      }
    }
    .hideTitleBar(true)
  }
}
