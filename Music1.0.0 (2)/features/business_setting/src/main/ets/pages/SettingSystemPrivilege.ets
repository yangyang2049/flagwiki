import { CommonConfirmDialog, CommonConstants } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { SettingCard } from '../components/SettingCard';
import { SettingItem } from '../types/Types';

@Builder
export function SettingSystemPrivilegeBuilder() {
  SettingSystemPrivilege()
}

@ComponentV2
struct SettingSystemPrivilege {
  @Local listPrivilege: SettingItem[] = [
    new SettingItem({
      label: '读取手机本地音乐权限',
      subLabel: '用于在app的本地功能,导入手机本地音乐',
      extraLabel: '已开启',
      onClick: () => {
        this.config()
      },
    }),
    new SettingItem({
      label: '相机读写权限',
      subLabel: '用于设置或更新头像',
      extraLabel: '去设置',
      onClick: () => {
        this.config()
      },
    }),
    new SettingItem({
      label: '相机权限',
      subLabel: '使用摄像头，用于设置或更新头像',
      extraLabel: '已开启',
      onClick: () => {
        this.config()
      },
    }),
    new SettingItem({
      label: '通知权限',
      subLabel: '音乐更新、应用版本个更新通知',
      extraLabel: '去设置',
      onClick: () => {
        this.config()
      },
    }),
  ];

  config() {
    CommonConfirmDialog.show({
      content: '请在“系统设置”内对权限进行管理',
      secBtnV: '知道了',
      secBtnFg: $r('sys.color.warning'),
      confirm: () => {
      },
    })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题
        NavHeaderBar({
          title: '系统权限'
        })

        Scroll() {
          Column({ space: CommonConstants.SPACE_M }) {
            SettingCard({ list: this.listPrivilege })
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

      }.height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}