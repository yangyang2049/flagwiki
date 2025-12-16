import { AppStorageV2 } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { CommonConstants, WindowModel } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';

/**
 * 首次安装弹出的隐私协议页面
 */
@Builder
export function PrivacyPageBuilder() {
  PrivacyPage()
}

@ComponentV2
struct PrivacyPage {
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  webViewController: webview.WebviewController = new webview.WebviewController();
  mode: WebDarkMode = WebDarkMode.Auto;

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar()
        Web({
          src: $rawfile('privacy-statement.htm'),
          controller: this.webViewController,
        })
          .fileAccess(false)
          .geolocationAccess(false)
          .darkMode(this.mode)
          .forceDarkAccess(true)
          .backgroundColor($r('sys.color.background_secondary'))
          .layoutWeight(1)
      }
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        bottom: this.windowModel.windowBottomPadding,
      })
    }
    .hideTitleBar(true)
  }
}
