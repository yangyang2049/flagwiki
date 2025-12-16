import { CircleShape } from '@kit.ArkUI';
import { SettingCard } from 'business_setting';
import { CommonConstants, RouterMap, RouterUtils } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { ThemeController } from 'module_theme';
import { mineGridList } from '../constants/Constants';
import { MineGridItem } from '../types/Types';
import { MineViewModel } from '../viewmodels/MineVM';

@Builder
export function MinePageBuilder() {
  MinePage()
}

@ComponentV2
struct MinePage {
  @Local vm: MineViewModel = new MineViewModel();

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '我的',
          isSubTitle: false,
          fontColor: ThemeController.theme.themeColors[2],
          rightPartBuilder: () => {
            this.themeBuilder()
          },
        })
        Scroll() {
          Column({ space: CommonConstants.SPACE_M }) {
            this.loginCard()
            this.gridCard()
            this.listCard()
          }
        }
        .layoutWeight(1)
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .padding({
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
          top: CommonConstants.SPACE_M,
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .backgroundColor(this.vm.settingInfo.themePic === '' ? $r('sys.color.background_secondary') : Color.Transparent)
  }

  @Builder
  loginCard() {
    Column() {
      if (this.vm.userInfoModel.isLogin) {
        Column() {
          Row({ space: CommonConstants.SPACE_L }) {
            Image(this.vm.userIcon)
              .width($r('app.float.user_icon_width'))
              .height($r('app.float.user_icon_width'))
              .clipShape(new CircleShape({ width: 48, height: 48 }))
              .draggable(false)
              .fillColor(ThemeController.theme.themeColors[2])
            Column({ space: CommonConstants.SPACE_XXS }) {
              Row({ space: 8 }) {
                Text(this.vm.userInfoModel.authorNickName)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(ThemeController.theme.themeColors[4])
                Row({ space: 5 }) {
                  Image($r('app.media.vip'))
                    .width(12)
                    .height(12)
                    .fillColor(ThemeController.theme.themeColors[4])

                  Text(this.vm.userInfoModel.isVip ? '已开通' : '未开通')
                    .fontSize(10)
                    .fontColor(ThemeController.theme.themeColors[4])
                }
              }
              Row({ space: CommonConstants.SPACE_XS }) {
                Image($r('app.media.ic_phone'))
                  .width($r('app.float.medium_img_width'))
                  .draggable(false)
                  .fillColor(ThemeController.theme.themeColors[4])
                Text(this.vm.userInfoModel.authorPhone)
                  .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
                  .fontColor(ThemeController.theme.themeColors[4])
              }
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.ic_right'))
              .width($r('app.float.arrow_right_w'))
              .draggable(false)
              .fillColor(ThemeController.theme.themeColors[4])
          }
          .borderRadius($r('app.float.large_radius'))
          .padding(CommonConstants.PADDING_S)
          .stateStyles({
            normal: this.normalStyles,
            pressed: this.pressedStyles,
          })
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.SETTING_PERSONAL)
          })

          Divider().width(CommonConstants.FULL_PERCENT)
          Row({ space: CommonConstants.SPACE_L }) {
            Text('海量专属歌曲任享！')
              .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
              .fontColor(ThemeController.theme.themeColors[2])
              .layoutWeight(1)

            //会员中心按钮
            Button('会员中心')
              .height(28)
              .backgroundColor(ThemeController.theme.themeColor)
              .fontColor(ThemeController.theme.themeColors[5])
              .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
              .onClick(() => {
                RouterUtils.pushPathByName(RouterMap.VIPCENTER_PAGE);
              })
          }
          .padding(CommonConstants.PADDING_S)
        }
        .backgroundColor(Color.Transparent)

      } else {
        Row({ space: CommonConstants.SPACE_L }) {
          Image($r('app.media.ic_user_unlogin'))
            .width($r('app.float.user_icon_width'))
            .draggable(false)

          Column({ space: CommonConstants.SPACE_XXS }) {
            Text('点击登录')
              .fontSize(18 * this.vm.settingInfo.fontSizeRatio)
              .fontColor(ThemeController.theme.themeColors[2])
              .fontWeight(FontWeight.Medium)

            Text('登录后享受更多服务')
              .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
              .fontColor(ThemeController.theme.themeColors[4])
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Image($r('app.media.ic_right'))
            .width($r('app.float.arrow_right_w'))
            .draggable(false)
            .fillColor(ThemeController.theme.themeColors[2])
        }
        .borderRadius($r('app.float.large_radius'))
        .padding(CommonConstants.PADDING_S)
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.vm.jumpLogin();
        })
      }

    }
    .backgroundColor(ThemeController.theme.themeColors[1])
    .width(CommonConstants.FULL_PERCENT)
    .padding(CommonConstants.PADDING_XS)
    .borderRadius($r('app.float.large_radius'))
  }

  @Builder
  gridCard() {
    Column() {
      Grid() {
        ForEach(mineGridList, (v: MineGridItem) => {
          GridItem() {
            Column() {
              Image(v.icon)
                .width($r('app.float.grid_icon_width'))
                .draggable(false)
                .fillColor(ThemeController.theme.themeColor)
              Text(v.label)
                .fontSize(12 * this.vm.settingInfo.fontSizeRatio)
                .fontColor(ThemeController.theme.themeColors[2])
            }
            .height(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .borderRadius($r('app.float.large_radius'))
          .stateStyles({
            normal: this.normalStyles,
            pressed: this.pressedStyles,
          })
          .padding({
            top: CommonConstants.PADDING_S,
            bottom: CommonConstants.PADDING_S,
            left: CommonConstants.PADDING_XS,
            right: CommonConstants.PADDING_XS,
          })
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.vm.gridClick(v);
          })
        }, (v: MineGridItem) => v.label as string)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(76)
      .columnsTemplate('1fr 1fr 1fr')
      .backgroundColor(Color.Transparent)
    }
    .padding({
      top: CommonConstants.PADDING_XS,
      bottom: CommonConstants.PADDING_XS,
      left: CommonConstants.PADDING_XS,
      right: CommonConstants.PADDING_XS,
    })
    .backgroundColor(ThemeController.theme.themeColors[1])
    .borderRadius($r('app.float.large_radius'))
  }

  @Builder
  listCard() {
    Column({ space: CommonConstants.SPACE_M }) {
      Text('常用服务')
        .fontSize(18 * this.vm.settingInfo.fontSizeRatio)
        .fontColor(ThemeController.theme.themeColors[2])
        .fontWeight(FontWeight.Medium)
      SettingCard({
        list: this.vm.serviceList,
        fontPrimaryColor: ThemeController.theme.themeColors[2],
        fontSecondaryColor: ThemeController.theme.themeColors[4],
        themeColor: this.vm.settingInfo.themeColor,
        backgroundPrimaryColor: ThemeController.theme.themeColors[1],
      })
    }
    .margin({ top: CommonConstants.PADDING_XS })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  themeBuilder() {
    Row({ space: CommonConstants.SPACE_S }) {
      Image($r('app.media.ic_theme'))
        .width($r('app.float.nav_icon_width'))
        .fillColor(this.vm.settingInfo.themeColor)
        .width(30)
        .height(30)
        .onClick(() => {
          RouterUtils.pushPathByName(RouterMap.THEME_LIST, this.vm.breakPointModel.currentBreakpoint);
        })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
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