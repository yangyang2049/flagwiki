import { CommonConstants, PreferenceUtils, RouterMap, RouterUtils } from 'lib_common';
import { AdvertisementComponent } from 'module_advertisement';
import { ISFIRST_GUIDE } from '../common/Constants';

/**
 * 广告页
 */
@Builder
export function SplashPageBuilder() {
  SplashPage()
}


@ComponentV2
struct SplashPage {
  //是否位首次安装引导
  isFirstGuide() {
    return PreferenceUtils.getInstance().get(ISFIRST_GUIDE) as boolean;
  }

  build() {
    Column() {
      AdvertisementComponent({
        adType: 1,
        testAd: 'testd7c5cewoj6',
        skipAd: () => {
          if (!this.isFirstGuide()) {
            //引导页
            RouterUtils.replacePathByName(RouterMap.STARTGUIDE_PAGE);
            return
          }
          RouterUtils.replacePathByName(RouterMap.INDEX_PAGE);
        }
      })
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }
}