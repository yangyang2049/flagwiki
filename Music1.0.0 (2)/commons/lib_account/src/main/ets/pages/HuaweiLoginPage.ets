import { loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { CommonConstants } from 'lib_common';
import { AgreePrivacyBox } from '../components/AgreePrivacyBox';
import { Constants } from '../constants/Constants';
import { LoginRouterParams } from '../constants/Types';
import { LoginVM } from '../viewmodels/LoginVM';

@Builder
export function HuaweiLoginPageBuilder() {
  HuaweiLoginPage()
}

@ComponentV2
struct HuaweiLoginPage {
  @Local vm: LoginVM = LoginVM.getInstance(false);

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Image($r('app.media.startIcon'))
              .width(Constants.START_ICON_WIDTH)
              .aspectRatio(1)
              .draggable(false)
              .borderRadius($r('app.float.large_radius'))
              .margin({
                top: this.vm.iconMarginTop(),
                bottom: Constants.PADDING_40,
              })
            Text(this.vm.anonymousPhone)
              .fontSize($r('sys.float.Title_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Bold)

            Text('华为账号绑定号码')
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .margin({ top: CommonConstants.PADDING_XS })

            Column() {
              LoginWithHuaweiIDButton({
                params: {
                  style: loginComponentManager.Style.BUTTON_CUSTOM,
                  extraStyle: {
                    buttonStyle: new loginComponentManager.ButtonStyle().loadingStyle({
                      show: true
                    }).backgroundColor($r('app.color.app_theme'))
                  },
                  loginType: loginComponentManager.LoginType.QUICK_LOGIN,
                  supportDarkMode: false,
                },
                controller: this.vm.controller,
              }).id('login_with_huaweiId_button')
            }
            .height(Constants.BTN_HEIGHT)
            .margin({
              top: Constants.PADDING_40 + CommonConstants.PADDING_S,
            })

            Button('其他方式登录')
              .width(CommonConstants.FULL_PERCENT)
              .height(Constants.BTN_HEIGHT)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .margin({
                top: CommonConstants.PADDING_M,
                bottom: CommonConstants.PADDING_S,
              })
              .onClick(() => {
                this.vm.jumpOtherLogin();
              })
          }
        }
        .layoutWeight(1)
        .align(Alignment.Top)
        .scrollBar(BarState.Off)

        AgreePrivacyBox()
      }
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        bottom: this.vm.windowModel.windowBottomPadding,
      })
    }
    .hideTitleBar(true)
    .backgroundColor(this.vm.pageBgColor())
    .onReady((context) => {
      const param = context.pathInfo.param as LoginRouterParams
      if (!param || !param?.keepVM) {
        this.vm = LoginVM.getInstance(true);
        this.vm.isSheet = param?.isSheet ?? false;
      } else {
        this.vm.resetInput();
      }
      this.vm.stack = context.pathStack;
    })
    .onBackPressed(() => {
      this.vm.handleClose();
      return true;
    })
  }
}