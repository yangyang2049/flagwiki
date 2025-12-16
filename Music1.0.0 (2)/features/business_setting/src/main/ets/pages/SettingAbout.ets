import { CommonConstants } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { SettingAboutVM } from '../viewmodels/SettingAboutVM';
import promptAction from '@ohos.promptAction';

@Builder
export function SettingAboutBuilder() {
  SettingAbout()
}

@ComponentV2
struct SettingAbout {
  vm: SettingAboutVM = new SettingAboutVM();

  build() {
    NavDestination() {
      NavHeaderBar({ title: '关于' })
      Scroll() {
        Column() {
          this.appInfo()
          this.cardInfo()
          this.otherInfo()
        }
        .width(CommonConstants.FULL_PERCENT)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .padding({
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        bottom: this.vm.windowModel.windowBottomPadding,
      })
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  appInfo() {
    Column({ space: CommonConstants.SPACE_S }) {
      Stack() {
        Image($r('app.media.background'))
          .width(72)
          .aspectRatio(1)
          .borderRadius($r('app.float.large_radius'))
          .draggable(false)
        Image($r('app.media.foreground'))
          .width(72)
          .aspectRatio(1)
          .borderRadius($r('app.float.large_radius'))
          .draggable(false)
      }

      Text(this.vm.appName)
        .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(224)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  cardInfo() {
    Column() {
      Row() {
        Column({ space: CommonConstants.SPACE_XXS }) {
          Row({ space: CommonConstants.SPACE_XS }) {
            Text('版本信息')
              .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
            Circle()
              .width(6)
              .aspectRatio(1)
              .backgroundColor($r('sys.color.warning'))
              .visibility(this.vm.hasNewVersion ? Visibility.Visible : Visibility.None)
          }

          Text(this.vm.appVersionName)
            .fontSize(14 * this.vm.settingInfo.fontSizeRatio)
            .fontColor($r('sys.color.font_secondary'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({
          top: 10,
          bottom: 10
        })

        Row({ space: CommonConstants.SPACE_XS }) {
          if (this.vm.loading) {
            LoadingProgress()
              .width(24)
              .aspectRatio(1)
              .color($r('sys.color.icon_on_primary'))
          } else {
            Text(this.vm.updateLabel)
              .fontSize(14 * this.vm.settingInfo.fontSizeRatio)
              .fontColor($r('sys.color.font_secondary'))
            Image($r('app.media.ic_right'))
              .width($r('app.float.arrow_right_w'))
              .draggable(false)
          }
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .onClick(() => {
        this.vm.checkUpdate();
      })

      Divider().strokeWidth(0.5)

      Row() {
        Column({ space: CommonConstants.SPACE_XXS }) {
          Text('客服电话')
            .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
          Text(this.vm.hotline)
            .fontSize(14 * this.vm.settingInfo.fontSizeRatio)
            .fontColor($r('sys.color.font_secondary'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({
          top: 10,
          bottom: 10
        })
        .onClick(() => {
          this.vm.callHotline();
        })
      }
      .width(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('app.float.xxl_radius'))
    .padding({
      top: CommonConstants.PADDING_L,
      bottom: CommonConstants.PADDING_L,
      left: CommonConstants.PADDING_M,
      right: CommonConstants.PADDING_M,
    })
    .margin({ top: CommonConstants.PADDING_L })
  }

  @Builder
  otherInfo() {
    Column() {
      Text('苏ICP备17040376号-135A')
        .fontSize($r('sys.float.Body_S'))
        .fontColor($r('app.color.app_theme'))
        .onClick(() => {
          promptAction.showToast({ message: '待配置调整地址' })
        })
      Text('华为xx 版权所有 © 2019-2025')
        .fontSize($r('sys.float.Body_S'))
        .fontColor($r('sys.color.font_secondary'))
      Text('技术支持：xxxxxxxx')
        .fontSize($r('sys.float.Body_S'))
        .fontColor($r('sys.color.font_secondary'))
    }
    .width(CommonConstants.FULL_PERCENT)
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }
}