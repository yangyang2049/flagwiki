import { promptAction } from '@kit.ArkUI';
import { BaseViewModel, CommonConstants, FileUtils, RouterMap, RouterUtils } from 'lib_common';
import { AccountApi } from 'lib_account';
import { ISelectOption, SettingItem } from '../types/Types';
@ObservedV2
export class SettingViewModel extends BaseViewModel {
  private accountInstance: AccountApi = new AccountApi();
  @Trace isLoading: boolean = false;
  @Trace cacheSize: string = '10';
  @Trace location: string = '/storage/emulated/0/Download/Music/'
  @Trace teenagers: string = this.settingInfo.teenagersSwitch ? '已开启' : '未开启'
  @Trace cacheSettingItem = new SettingItem({
    label: '清理缓存',
    extraLabel: this.getLocalCacheLabel(),
    onClick: () => {
      this.cacheSize = '0';
      this.cacheSettingItem.extraLabel = this.getLocalCacheLabel();
      FileUtils.clearCache();
      promptAction.showToast({ message: '清除缓存成功' });
    },
  })
  @Trace list1: SettingItem[] = [
    new SettingItem({
      typeSwitch: true,
      label: '未成年模式',
      switchV: this.settingInfo.teenagersSwitch,
      onClick: (isOn) => {
        this.settingInfo.teenagersSwitch = isOn as boolean;
      },
      isConfirm: true,
    }),
    new SettingItem({
      label: '隐私管理',
      routerName: RouterMap.SETTING_PRIVACY,
    }),

  ];
  @Trace list4: SettingItem[] = [
    new SettingItem({
      label: '关于我们',
      routerName: RouterMap.SETTING_ABOUT,
    }),
    this.cacheSettingItem
  ];
  // 下载和缓存设置
  @Trace item1: SettingItem = new SettingItem({
    typeSelect: true,
    label: '歌曲下载品质',
    selectTitle: '品质选择',
    selectOptions: [
      {
        id: 0,
        label: '标准',
      },
      {
        id: 1,
        label: 'HQ 高品质',
      },
      {
        id: 2,
        label: 'SQ 无损品质',
      },
      {
        id: 3,
        label: 'Hi-Res 品质',
      },
    ],
    selectV: this.settingInfo.qualitySwitch,
    onSelect: (option) => {
      this.settingInfo.qualitySwitch = (option as ISelectOption).id;
      this.item1.selectV = this.settingInfo.qualitySwitch;
    },
  });
  @Trace item2: SettingItem = new SettingItem({
    typeSwitch: true,
    label: '边听边存',
    switchV: this.settingInfo.storageSwitch,
    onClick: (isOn) => {
      this.settingInfo.storageSwitch = isOn as boolean;
    },
  });
  @Trace item3: SettingItem = new SettingItem({
    updatelabel: true,
    label: '歌曲存放地址',
    updateV: this.settingInfo.cachePath,
    onClick: (value) => {
      if (value === '') {
        promptAction.showToast({ message: '请设置正确的路径' });
        return
      }
      if (!value) {
        return ;
      }

      this.settingInfo.cachePath = value as string;
      this.item3.updateV = this.settingInfo.cachePath;
      AppStorage.setOrCreate(CommonConstants.STORAGE_CACHE_PATH, this.settingInfo.cachePath)
    },
  });
  @Trace list5: SettingItem[] = [
    this.item1,
    this.item2,
    this.item3
  ];

  getCache() {
    FileUtils.getCache().then((resp: number) => {
      this.cacheSize = (resp / 1024 / 1024).toFixed(2);
      this.cacheSettingItem.extraLabel = this.getLocalCacheLabel();
    })
  }

  getLocalCacheLabel() {
    return `${this.cacheSize}M`;
  }

  onSignOutBtnClick() {
    this.isLoading = true;
    this.accountInstance.signOut()
      .then(() => {
        promptAction.showToast({ message: '已退出登录' });
        RouterUtils.pop();
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  @Computed
  get signOutBtnLabel() {
    if (this.isLoading) {
      return '正在退出登录...'
    }
    return '退出登录'
  }

  getLocationLabel() {
    return `${this.location}M`;
  }

  getTeenagersLabel() {
    return `${this.settingInfo.teenagersSwitch ? '已开启' : '未开启'}`;
  }

  onChanegeTeenagersSwitch(password: string) {
    // 校验密码是否输入
    if (password.length === 0) {
      promptAction.showToast({ message: '请输入密码' });
      return
    }
    if (password !== this.settingInfo.teenagersPassword) {
      promptAction.showToast({ message: '密码错误' });
      return
    }
    this.settingInfo.teenagersSwitch = !this.settingInfo.teenagersSwitch;
    //关闭页面
    RouterUtils.pop();
  }
}