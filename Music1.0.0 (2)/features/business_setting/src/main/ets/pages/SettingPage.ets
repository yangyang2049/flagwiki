import { CommonConfirmDialog, CommonConstants, RouterMap, RouterUtils } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { SettingCard } from '../components/SettingCard';
import { SettingViewModel } from '../viewmodels/SettingVM';

@Builder
export function SettingPageBuilder() {
  SettingPage()
}


@ComponentV2
struct SettingPage {
  @Local vm: SettingViewModel = new SettingViewModel();

  aboutToAppear(): void {
    this.vm.getCache();
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '设置',
        })
        Scroll() {
          Column({ space: CommonConstants.SPACE_M }) {
            if (this.vm.userInfoModel.isLogin) {
              Column() {
                Row({ space: CommonConstants.SPACE_L }) {
                  Column({ space: CommonConstants.SPACE_XXS }) {
                    Text(this.vm.userInfoModel.authorNickName)
                      .fontSize(18 * this.vm.settingInfo.fontSizeRatio)
                      .fontColor($r('sys.color.font_primary'))
                      .fontWeight(FontWeight.Medium)
                    Row({ space: CommonConstants.SPACE_XS }) {
                      Image($r('app.media.ic_phone'))
                        .width($r('app.float.medium_img_width'))
                        .draggable(false)
                        .fillColor($r('sys.color.icon_secondary'))
                      Text(this.vm.userInfoModel.authorPhone)
                        .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
                        .fontColor($r('sys.color.font_secondary'))
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)

                  Image($r('app.media.ic_right'))
                    .width($r('app.float.arrow_right_w'))
                    .draggable(false)
                }
                .borderRadius($r('app.float.large_radius'))
                .padding(CommonConstants.PADDING_S)
                .stateStyles({
                  normal: this.normalStyles,
                  pressed: this.pressedStyles,
                })
                .onClick(() => {
                  RouterUtils.pushPathByName(RouterMap.SETTING_PERSONAL)
                })
              }

            }
            SettingCard({ list: this.vm.list1 })
            SettingCard({ list: this.vm.list5 })
            SettingCard({ list: this.vm.list4 })
          }
          .padding({
            left: CommonConstants.PADDING_PAGE,
            right: CommonConstants.PADDING_PAGE,
            top: CommonConstants.PADDING_M,
          })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        .edgeEffect(EdgeEffect.Spring)

        Column() {
          Button() {
            Row({ space: CommonConstants.SPACE_XS }) {
              LoadingProgress()
                .width(16)
                .aspectRatio(1)
                .color($r('sys.color.font_primary'))
                .visibility(this.vm.isLoading ? Visibility.Visible : Visibility.None)
              Text(this.vm.signOutBtnLabel)
                .fontSize($r('sys.float.Body_L'))
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
            }
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(40)
          .backgroundColor($r('app.color.app_theme'))
          .margin({ top: CommonConstants.PADDING_S, bottom: CommonConstants.PADDING_S })
          .enabled(!this.vm.isLoading)
          .onClick(() => {
            CommonConfirmDialog.show({
              primaryTitle: '温馨提示',
              content: '是否确定要退出登录？',
              confirm: () => {
                this.vm.onSignOutBtnClick();
              },
            })
          })
        }
        .visibility(this.vm.userInfoModel.isLogin ? Visibility.Visible : Visibility.None)
        .padding({
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
          bottom: this.vm.windowModel.windowBottomPadding,
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Styles
  normalStyles() {
    .backgroundColor($r('sys.color.comp_background_primary'))
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.interactive_pressed'))
  }
}