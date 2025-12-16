import { PersistenceV2, promptAction } from '@kit.ArkUI';
import {
  CommonConfirmDialog,
  CommonConstants,
  Logger,
  PopViewUtils,
  RouterUtils,
  SettingModel,
  UserInfoModel
} from 'lib_common';
import { CommonEnterDialog } from 'lib_common/src/main/ets/dialogs/CommonEnterDialog';
import { SettingItem } from '../types/Types';
import { SettingSelectDialog } from './SettingSelectDialog';

const TAG = '[SettingCard]';

@ComponentV2
export struct SettingCard {
  @Param list: SettingItem[] = [];
  @Param labelSize: number = 16;
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Param fontPrimaryColor: ResourceColor = $r('sys.color.font_primary');
  @Param fontSecondaryColor: ResourceColor = $r('sys.color.font_secondary');
  @Param backgroundPrimaryColor: ResourceColor = $r('sys.color.comp_background_primary')
  @Param themeColor: ResourceColor = $r('sys.color.font_primary');

  build() {
    List() {
      ForEach(this.list, (v: SettingItem) => {
        ListItem() {
          Row({ space: CommonConstants.SPACE_M }) {
            if (v.icon) {
              Image(v.icon)
                .width($r('app.float.normal_img_size'))
                .fillColor(this.themeColor)
                .draggable(false)
            }
            Column() {
              Text(v.label)
                .fontSize(this.labelSize * this.settingInfo.fontSizeRatio)
                .fontColor(this.fontPrimaryColor)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
              Text(v.subLabel)
                .fontSize(12 * this.settingInfo.fontSizeRatio)
                .fontColor(this.fontSecondaryColor)
                .visibility(v.subLabel ? Visibility.Visible : Visibility.None)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            if (v.typeSwitch) {
              if (v.isConfirm) {
                this.toggleSceneConfirm(v)
              } else {
                this.toggleScene(v)
              }
            } else if (v.typeSelect) {
              this.selectScene(v)
            } else if (v.updatelabel) {
              this.updateLabel(v)
            } else {
              this.normalScene(v)
            }
          }
          .padding({
            top: CommonConstants.PADDING_M,
            bottom: CommonConstants.PADDING_M,
            left: CommonConstants.PADDING_S,
            right: CommonConstants.PADDING_S,
          })
          .borderRadius($r('app.float.large_radius'))
          .stateStyles({
            normal: this.normalStyles,
            pressed: this.pressedStyles,
          })
          .backgroundColor(Color.Transparent)
        }
        .onClick(() => {
          if (v.onClick) {
            v.onClick();
          } else if (v.routerName) {
            RouterUtils.pushPathByName(v.routerName, v.routerParams);
          }
        })
      }, (v: SettingItem) => v.label as string)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height('auto')
    .padding({
      left: CommonConstants.PADDING_XS,
      right: CommonConstants.PADDING_XS,
      top: CommonConstants.PADDING_XS,
      bottom: CommonConstants.PADDING_XS,
    })
    .borderRadius($r('app.float.large_radius'))
    .backgroundColor(this.backgroundPrimaryColor)
    .divider({
      strokeWidth: 0.5,
      color: $r('sys.color.comp_divider'),
      startMargin: CommonConstants.PADDING_M,
      endMargin: CommonConstants.PADDING_M,
    })
  }

  @Styles
  normalStyles() {
    .backgroundColor($r('sys.color.comp_background_primary'))
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.interactive_pressed'))
  }

  @Builder
  toggleScene(v: SettingItem) {
    Column() {
      Toggle({ type: ToggleType.Switch, isOn: v.switchV })
        .hitTestBehavior(HitTestMode.Block)
        .enabled(false)// 禁用交互
        .opacity(1)// 保持正常透明度，避免置灰效果
        .blendMode(BlendMode.SRC_OVER)
    }
    .onClick(() => {
      //判断vip是否开通，没有开通不运行设置
      if (!this.userInfoModel.isVip) {
        promptAction.showToast({message: '请开通会员'})
        return
      }
      if (v.label === '边听边存') {
        if (v.switchV) {
          // 关闭时的确认对话框
          CommonConfirmDialog.show({
            primaryTitle: v.label,
            content: '确定要关闭吗？',
            secBtnV: '确认关闭',
            secBtnFg: $r('sys.color.warning'),
            confirm: () => {
              this.settingInfo.teenagersSwitch = false
              if (v.onClick) {
                v.switchV = false
                v.onClick(false);
              }
            },
          })
        } else {
          this.settingInfo.teenagersSwitch = true
          if (v.onClick) {
            v.switchV = true
            v.onClick(true);
          }
        }
      }
    })
  }

  @Builder
  toggleSceneConfirm(v: SettingItem) {
    Column() {
      // 倒计时

      Toggle({ type: ToggleType.Switch, isOn: v.switchV })
        .hitTestBehavior(HitTestMode.Block)
        .enabled(false)// 禁用交互
        .opacity(1)// 保持正常透明度，避免置灰效果
        .blendMode(BlendMode.SRC_OVER)
    }
    .onClick(() => {
      if (v.label === '未成年模式') {
        if (v.switchV) {
          // 关闭时的确认对话框
          CommonConfirmDialog.show({
            primaryTitle: v.label,
            content: '确定要关闭未成年模式吗？',
            secBtnV: '确认关闭',
            secBtnFg: $r('sys.color.warning'),
            confirm: () => {
              this.settingInfo.teenagersSwitch = false
              if (v.onClick) {
                v.switchV = false
                v.onClick(false);
              }
            },
          })
        } else {
          // 打开时的确认对话框
          CommonConfirmDialog.show({
            primaryTitle: v.label,
            content: '未成年模式下，当天音乐限播10分钟,时间刚到点不影响正在播放歌曲',
            secBtnV: '确认开启',
            secBtnFg: $r('sys.color.warning'),
            confirm: () => {
              this.settingInfo.teenagersSwitch = true
              if (v.onClick) {
                v.switchV = true
                v.onClick(true);
              }
            },
          })
        }
      }
    })
  }

  @Builder
  selectScene(v: SettingItem) {
    Row({ space: CommonConstants.SPACE_XS }) {
      Text(this.getSelectLabel(v))
        .fontSize(12 * this.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_secondary'))
      Image($r('app.media.ic_right'))
        .width($r('app.float.arrow_right_w'))
        .draggable(false)
    }
    .onClick(() => {
      PopViewUtils.showPopView(wrapBuilder(SettingSelectDialog), {}, v);
    })
  }

  @Builder
  normalScene(v: SettingItem) {
    Row({ space: CommonConstants.SPACE_XS }) {
      if (v.extraLabel) {
        if (v.isConfirm) {
          Text(this.settingInfo.teenagersSwitch ? '开启' : '未开启')
            .fontSize(14 * this.settingInfo.fontSizeRatio)
            .fontColor($r('sys.color.font_secondary'))
            .width(150)
            .textAlign(TextAlign.End)
        } else {
          Text(v.extraLabel)
            .fontSize(14 * this.settingInfo.fontSizeRatio)
            .fontColor($r('sys.color.font_secondary'))
            .textAlign(TextAlign.End)
        }


      }
      Image($r('app.media.ic_right'))
        .width($r('app.float.arrow_right_w'))
        .draggable(false)
    }
  }

  @Builder
  updateLabel(v: SettingItem) {
    Row({ space: CommonConstants.SPACE_XS }) {
      Text(v.updateV)
        .fontSize(12 * this.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_secondary'))
      Image($r('app.media.ic_right'))
        .width($r('app.float.arrow_right_w'))
        .draggable(false)
    }
    .onClick(() => {
      CommonEnterDialog.show({
        primaryTitle: `修改${v.label}`,
        content: `${v.updateV}`,
        confirm: (value) => {
          if (v.onClick) {
            v.onClick(value);
          }
          PopViewUtils.closePopView();
        },
        cancel: () => {
          PopViewUtils.closePopView();
        }
      })
    })
  }

  getSelectLabel(v: SettingItem) {
    const option = v.selectOptions?.find(option => option.id === v.selectV);
    return option?.label || '';
  }
}
