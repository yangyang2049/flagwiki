import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { CommonConstants } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { SettingPersonalVM } from '../viewmodels/SettingPersonalVM';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo as fs } from '@kit.CoreFileKit';

const TAG = 0x0000;

@Builder
export function SettingPersonalBuilder() {
  SettingPersonal()
}

@ComponentV2
struct SettingPersonal {
  @Local vm: SettingPersonalVM = new SettingPersonalVM();
  @Local selectUris: string[] = [];
  @Local currentUri: string = '';
  private context: Context = this.getUIContext().getHostContext()!;

  aboutToAppear(): void {
    this.vm.registerKeyboard();
  }

  aboutToDisappear(): void {
    this.vm.unRegisterKeyboard();
  }

  // 获取存入沙箱的背景图地址
  getUri() {
    try {
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.isEditSupported = false;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then(async (photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        if (photoSelectResult.photoUris.length > 0) {
          this.selectUris.push(photoSelectResult.photoUris[0]);
          this.currentUri = photoSelectResult.photoUris[0];
          if (this.selectUris.length > 0) {

            let file: fs.File | null = null;
            let file2: fs.File | null = null;
            try {
              // 存入沙箱
              file = fs.openSync(this.currentUri, fs.OpenMode.READ_ONLY)
              let fileName = this.context.filesDir + '/' + Date.now() + 'picture.jpg'
              file2 = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
              fs.copyFileSync(file.fd, file2.fd)
              fileName = 'file://' + fileName;
              this.vm.userInfoModel.authorIcon = fileName
            } catch (error) {
              let err: BusinessError = error as BusinessError;
              hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
            } finally {
              if (file) {
                fs.closeSync(file);
              }
              if (file2) {
                fs.closeSync(file2);
              }
            }

          }

        }
      }).catch((err: BusinessError) => {
        hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  build() {
    NavDestination() {
      NavHeaderBar({
        title: '个人信息',
        onBack: () => {
          this.vm.customBack();
        },
      })
      Scroll() {
        Column({ space: CommonConstants.SPACE_M }) {
          this.userIconBuilder()
          List() {
            ListItem() {
              this.nickNameBuilder()
            }

            ListItem() {
              this.phoneBuilder()
            }
          }
          .width(CommonConstants.FULL_PERCENT)
          .borderRadius($r('app.float.large_radius'))
          .padding(CommonConstants.PADDING_XS)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .divider({
            strokeWidth: 0.5,
            color: $r('sys.color.comp_divider'),
            startMargin: CommonConstants.PADDING_M,
            endMargin: CommonConstants.PADDING_M,
          })

          this.personalDescBuilder()
        }
        .padding({
          top: CommonConstants.PADDING_M,
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onBackPressed(() => {
      this.vm.customBack();
      return true;
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
  userIconBuilder() {
    Row() {
      Row() {
        Text('头像')
          .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Row({ space: CommonConstants.SPACE_XS }) {
          FunctionalButton({
            params: {
              openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
              label: '',
              styleOption: {
                styleConfig: new functionalButtonComponentManager.ButtonConfig()
                  .type(ButtonType.Normal)
                  .backgroundImage(this.vm.userInfoModel.authorIcon ? this.vm.userInfoModel.authorIcon :
                  $r('app.media.ic_user_default'))
                  .backgroundImageSize(ImageSize.Cover)
                  .width(40)
                  .height(40)
                  .borderRadius(50)
                  .backgroundColor('#E5E5E5'),
              },
            },
            controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err,
              data) => {
              if (data) {
                this.vm.saveUserIcon(data.avatarUri!);
              }
            }),
          })
          Image($r('app.media.ic_right'))
            .width($r('app.float.arrow_right_w'))
            .draggable(false)
        }
      }
      .innerCard()
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.pressedStyles,
      })
    }
    .outerCard()
  }

  @Builder
  nickNameBuilder() {
    Row() {
      Text('昵称')
        .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
      Row({ space: CommonConstants.SPACE_XS }) {
        Text(this.vm.userInfoModel.authorNickName)
          .fontSize(14 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_secondary'))
          .constraintSize({ maxWidth: '80%' })
        Image($r('app.media.ic_right'))
          .width($r('app.float.arrow_right_w'))
          .draggable(false)
      }
    }
    .innerCard(48)
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .onClick(() => {
      this.vm.nickName = this.vm.userInfoModel.authorNickName;
      this.vm.showNickNameSheet = true;
    })
    .bindSheet($$this.vm.showNickNameSheet, this.modifyNameSheet(), {
      title: { title: '设置昵称' },
      height: this.vm.defaultSheetH,
      detents: [this.vm.defaultSheetH, SheetSize.MEDIUM],
      showClose: true,
      keyboardAvoidMode: SheetKeyboardAvoidMode.NONE,
    })
  }

  @Builder
  phoneBuilder() {
    Row() {
      Text('手机号')
        .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
      Row({ space: CommonConstants.SPACE_XS }) {
        Text(this.vm.userInfoModel.authorPhone)
          .fontSize(14 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.ic_right'))
          .width($r('app.float.arrow_right_w'))
          .draggable(false)
      }
    }
    .innerCard(48)
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .onClick(() => {
      this.vm.contactPhone = this.vm.userInfoModel.authorPhone;
      this.vm.showPhoneSheet = true;
    })
    .bindSheet($$this.vm.showPhoneSheet, this.modifyPhoneSheet(), {
      title: { title: '设置手机号' },
      height: this.vm.defaultSheetH,
      detents: [this.vm.defaultSheetH, SheetSize.MEDIUM],
      showClose: true,
      keyboardAvoidMode: SheetKeyboardAvoidMode.NONE,
    })
  }

  @Builder
  personalDescBuilder() {
    Row() {
      Row() {
        Text('个人简介')
          .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Image($r('app.media.ic_right'))
          .width($r('app.float.arrow_right_w'))
          .draggable(false)
      }
      .innerCard()
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.pressedStyles,
      })
    }
    .outerCard()
    .onClick(() => {
      this.vm.personalDesc = this.vm.userInfoModel.authorDesc;
      this.vm.showPersonDescSheet = true;
    })
    .bindSheet($$this.vm.showPersonDescSheet, this.modifyPersonalDescSheet(), {
      title: { title: '个人简介' },
      height: this.vm.defaultSheetH,
      detents: [this.vm.defaultSheetH, SheetSize.MEDIUM],
      showClose: true,
      keyboardAvoidMode: SheetKeyboardAvoidMode.NONE,
    })
  }

  @Builder
  modifyNameSheet() {
    Column() {
      Column() {
        TextInput({ text: $$this.vm.nickName })
          .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .cancelButton({ style: CancelButtonStyle.INPUT, icon: { size: 16 } })
          .maxLength(20)
          .showCounter(true)
          .height(40)
          .margin({ top: 12 })
        Column() {
          Button('确定')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.app_theme'))
            .width('100%')
            .onClick(() => {
              this.vm.modifyNickName();
            })
        }
        .padding({ bottom: this.vm.keyHeight })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      bottom: this.vm.windowModel.windowBottomPadding
    })
  }

  @Builder
  modifyPhoneSheet() {
    Column() {
      Column() {
        TextInput({ text: $$this.vm.contactPhone })
          .type(InputType.PhoneNumber)
          .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .cancelButton({ style: CancelButtonStyle.INPUT, icon: { size: 16 } })
          .maxLength(11)
          .showCounter(true)
          .height(40)
          .margin({ top: 12 })
        Column() {
          Button('确定')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.app_theme'))
            .width('100%')
            .onClick(() => {
              this.vm.modifyContactPhone();
            })
        }
        .padding({ bottom: this.vm.keyHeight })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      bottom: this.vm.windowModel.windowBottomPadding
    })
  }

  @Builder
  modifyPersonalDescSheet() {
    Column() {
      Column() {
        TextArea({ text: $$this.vm.personalDesc, placeholder: '简单介绍一下自己吧~~' })
          .fontSize(16 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .placeholderColor($r('sys.color.font_tertiary'))
          .placeholderFont({ size: 16 * this.vm.settingInfo.fontSizeRatio })
          .maxLength(70)
          .showCounter(true)
          .height(156)
          .margin({ top: 12 })
        Column() {
          Button('确定')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.app_theme'))
            .width('100%')
            .onClick(() => {
              this.vm.modifyPersonalDesc();
            })
        }
        .padding({ bottom: this.vm.keyHeight })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      bottom: this.vm.windowModel.windowBottomPadding
    })
  }
}

@Extend(Row)
function innerCard(height: number | string = CommonConstants.FULL_PERCENT) {
  .width(CommonConstants.FULL_PERCENT)
  .height(height)
  .padding(CommonConstants.PADDING_S)
  .borderRadius($r('app.float.large_radius'))
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Row)
function outerCard(height: number = 56) {
  .width(CommonConstants.FULL_PERCENT)
  .height(height)
  .padding(CommonConstants.PADDING_XS)
  .borderRadius($r('app.float.large_radius'))
  .backgroundColor($r('sys.color.comp_background_primary'))
}