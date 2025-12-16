import { promptAction, window } from '@kit.ArkUI';
import { BaseViewModel, BreakpointNameEnum, FileUtils, Logger, PhoneNumberUtils, RouterUtils } from 'lib_common';
import { MineServiceApi } from 'lib_music_api';

const TAG = '[SettingPersonalVM]';

@ObservedV2
export class SettingPersonalVM extends BaseViewModel {
  @Trace nickName: string = this.userInfoModel.authorNickName;
  @Trace contactPhone: string = this.userInfoModel.authorPhone;
  @Trace personalDesc: string = this.userInfoModel.authorDesc;
  @Trace showNickNameSheet: boolean = false;
  @Trace showPersonDescSheet: boolean = false;
  @Trace showPhoneSheet: boolean = false;
  @Trace hasModify: boolean = false;
  @Trace keyHeight: number = 0;
  readonly defaultSheetH: SheetSize | Length = SheetSize.LARGE;

  modifyNickName() {
    if (!this.nickName) {
      promptAction.showToast({ message: '昵称不能为空' });
      return
    }
    MineServiceApi.modifyPersonalInfo({ authorNickName: this.nickName });
    this.userInfoModel.authorNickName = this.nickName;
    this.showNickNameSheet = false;
    this.hasModify = true;
  }

  modifyContactPhone() {
    if (!this.contactPhone) {
      promptAction.showToast({ message: '手机号码不能为空' });
      return;
    }
    if (!PhoneNumberUtils.isPhoneNumberValid(this.contactPhone)) {
      promptAction.showToast({ message: '请输入正确的手机号码' });
      return;
    }
    MineServiceApi.modifyPersonalInfo({ authorPhone: this.contactPhone });
    this.userInfoModel.authorPhone = PhoneNumberUtils.encryptPhone(this.contactPhone);
    this.showPhoneSheet = false;
    this.hasModify = true;
  }

  modifyPersonalDesc() {
    MineServiceApi.modifyPersonalInfo({ authorDesc: this.personalDesc });
    this.userInfoModel.authorDesc = this.personalDesc;
    this.showPersonDescSheet = false;
    this.hasModify = true;
  }

  saveUserIcon(uri: string) {
    if (!uri) {
      return;
    }
    const resp = FileUtils.handleUri(uri);
    Logger.info(TAG, 'user icon saved success, url:' + resp);
    MineServiceApi.modifyPersonalInfo({ authorIcon: resp });
    this.userInfoModel.authorIcon = resp;
    this.hasModify = true;
  }

  customBack() {
    RouterUtils.pop(this.hasModify ? 'modify-flag' : undefined);
  }

  registerKeyboard() {
    window.getLastWindow(getContext()).then(currentWindow => {
      currentWindow.on('avoidAreaChange', this.cb);
    })
  }

  unRegisterKeyboard() {
    window.getLastWindow(getContext()).then(currentWindow => {
      currentWindow.off('avoidAreaChange', this.cb);
    })
  }

  cb: (data: window.AvoidAreaOptions) => void = (data) => {
    if (data.type === window.AvoidAreaType.TYPE_KEYBOARD) {
      this.keyHeight = px2vp(data.area.bottomRect.height);
      if (this.keyHeight > 0 &&
      [BreakpointNameEnum.MD, BreakpointNameEnum.LG].includes(this.breakPointModel.currentBreakpoint)) {
        // 减去居中弹窗底部高度
        this.keyHeight -= 100;
      }
    }
  }
}