import { BaseViewModel, CommonConfirmDialog, PreferenceUtils, RouterMap } from 'lib_common';
import { SettingItem } from '../types/Types';
import { common } from '@kit.AbilityKit';


@ObservedV2
export class SettingPrivacyVM extends BaseViewModel {
  @Trace list1: SettingItem[] = [
    new SettingItem({
      label: '个性化推荐',
      subLabel: '推荐符合我的个性化内容',
      typeSwitch: true,
      switchV: this.settingInfo.personalizedPush,
      onClick: (isOn) => {
        this.settingInfo.personalizedPush = isOn as boolean;
      },
    }),
  ];
  @Trace list2: SettingItem[] = [
    new SettingItem({
      label: '用户协议',
      routerName: RouterMap.SETTING_H5,
      routerParams: 1,
    }),
    new SettingItem({
      label: '隐私政策',
      routerName: RouterMap.SETTING_H5,
      routerParams: 2,
    }),
    new SettingItem({
      label: '第三方信息共享清单',
      routerName: RouterMap.SETTING_H5,
      routerParams: 3,
    }),
    new SettingItem({
      label: '个人信息收集清单',
      routerName: RouterMap.SETTING_H5,
      routerParams: 4,
    }),
  ];
  @Trace list3: SettingItem[] = [
    new SettingItem({
      label: '撤回隐私政策同意',
      onClick: (isOn) => {
        CommonConfirmDialog.show({
          primaryTitle: '撤回隐私政策同意',
          content: '如果您撤回隐私政策同意，将无法体验APP的完整功能',
          secBtnV: '确认撤回',
          secBtnFg: $r('sys.color.warning'),
          confirm: () => {
            // 撤回隐私政策
            PreferenceUtils.getInstance().put('isAgreePrivacy', false);
            (getContext(this) as common.UIAbilityContext)?.terminateSelf();

          },
        })
      },
    })
  ];
  @Trace list4: SettingItem[] = [
    new SettingItem({
      label: '系统权限',
      routerName: RouterMap.SETTING_SYSTEM,
      routerParams: 5,
    })
  ];
}