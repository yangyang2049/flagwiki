import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
import router from '@ohos.router';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import {
  MODULE_ANTHEM,
  MODULE_FLAGHISTORY,
  MODULE_STATE_FLAGS,
  MODULE_COAT_OF_ARMS,
  openOptionalModuleInstallFlow,
  refreshOptionalModuleAppStorage
} from '../../utils/OptionalModuleHelper';

@Component
export struct ProfilePage {
  @StorageLink('optionalModuleAnthemReady') anthemModuleReady: boolean = false;
  @StorageLink('optionalModuleFlagHistoryReady') flagHistoryModuleReady: boolean = false;
  @StorageLink('optionalModuleStateFlagsReady') stateFlagsModuleReady: boolean = false;
  @StorageLink('optionalModuleCoatOfArmsReady') coatOfArmsModuleReady: boolean = false;
  @State colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @State showThemeDialog: boolean = false;
  /** 扩展包详情弹窗：'' | anthem | flaghistory | stateflags | coatofarms */
  @State optionalModuleDialogTarget: string = '';
  @State optionalModuleDownloadStartedInDialog: boolean = false;
  @State vibrationEnabled: boolean = true; // 振动反馈开关，默认启用
  @Prop @Watch('onRefreshKeyChanged') refreshKey: number = 0;
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    await this.loadColorMode();
    await this.loadVibrationPreference();
    await VibratorUtil.init(this.context);
    await refreshOptionalModuleAppStorage(this.context);
  }

  private onRefreshKeyChanged(): void {
    this.loadColorMode();
    this.loadVibrationPreference();
    void refreshOptionalModuleAppStorage(this.context);
  }

  private getOptionalStatusText(ready: boolean): string {
    return ready
      ? this.context.resourceManager.getStringSync($r('app.string.optional_module_status_ready').id)
      : this.context.resourceManager.getStringSync($r('app.string.optional_module_status_missing').id);
  }

  private openOptionalModuleDetailDialog(moduleName: string): void {
    this.optionalModuleDialogTarget = moduleName;
    this.optionalModuleDownloadStartedInDialog = false;
    void refreshOptionalModuleAppStorage(this.context);
  }

  private closeOptionalModuleDetailDialog(): void {
    this.optionalModuleDialogTarget = '';
    this.optionalModuleDownloadStartedInDialog = false;
  }

  private isOptionalDialogTargetReady(): boolean {
    if (this.optionalModuleDialogTarget === MODULE_ANTHEM) {
      return this.anthemModuleReady;
    }
    if (this.optionalModuleDialogTarget === MODULE_FLAGHISTORY) {
      return this.flagHistoryModuleReady;
    }
    if (this.optionalModuleDialogTarget === MODULE_STATE_FLAGS) {
      return this.stateFlagsModuleReady;
    }
    if (this.optionalModuleDialogTarget === MODULE_COAT_OF_ARMS) {
      return this.coatOfArmsModuleReady;
    }
    return false;
  }

  private getOptionalModuleDialogTitle(): string {
    if (this.optionalModuleDialogTarget === MODULE_ANTHEM) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_title').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_FLAGHISTORY) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_title').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_STATE_FLAGS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_title').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_COAT_OF_ARMS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_title').id);
    }
    return '';
  }

  private getOptionalModuleApproxSizeHint(): string {
    if (this.optionalModuleDialogTarget === MODULE_ANTHEM) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_size_hint').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_STATE_FLAGS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_size_hint').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_COAT_OF_ARMS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_size_hint').id);
    }
    return this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_size_hint').id);
  }

  /** 安装完成后在应用内的入口位置（简短说明） */
  private getOptionalModuleEntryHint(): string {
    if (this.optionalModuleDialogTarget === MODULE_ANTHEM) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_entry').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_FLAGHISTORY) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_entry').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_STATE_FLAGS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_entry').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_COAT_OF_ARMS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_entry').id);
    }
    return '';
  }

  private getOptionalModuleDetailScrollText(): string {
    if (this.optionalModuleDialogTarget === MODULE_ANTHEM) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_detail').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_STATE_FLAGS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_detail').id);
    }
    if (this.optionalModuleDialogTarget === MODULE_COAT_OF_ARMS) {
      return this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_detail').id);
    }
    return this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_detail').id);
  }

  private async onOptionalModuleDialogDownload(): Promise<void> {
    if (this.optionalModuleDialogTarget !== MODULE_ANTHEM && this.optionalModuleDialogTarget !== MODULE_FLAGHISTORY &&
      this.optionalModuleDialogTarget !== MODULE_STATE_FLAGS && this.optionalModuleDialogTarget !== MODULE_COAT_OF_ARMS) {
      return;
    }
    const moduleName = this.optionalModuleDialogTarget as 'anthem' | 'flaghistory' | 'stateflags' | 'coatofarms';
    try {
      await openOptionalModuleInstallFlow(this.context, moduleName);
      this.optionalModuleDownloadStartedInDialog = true;
      await refreshOptionalModuleAppStorage(this.context);
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.optional_module_dialog_toast_after_download').id),
          duration: 3500
        });
      } catch (_t) {
        void 0;
      }
    } catch (err) {
      console.error(`onOptionalModuleDialogDownload: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.cannot_open_market').id),
          duration: 2000
        });
      } catch (_e2) {
        void 0;
      }
    }
  }

  private async loadColorMode(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      const saved: number = await this.prefs.get('colorMode', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
      this.colorMode = saved as ConfigurationConstant.ColorMode;
      this.applyColorMode();
    } catch (err) {
      console.error(`Failed to load color mode: ${JSON.stringify(err)}`);
    }
  }

  private async saveColorMode(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('colorMode', this.colorMode);
      await this.prefs.flush();
      this.applyColorMode();
    } catch (err) {
      console.error(`Failed to save color mode: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.save_failed_toast').id),
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private applyColorMode(): void {
    try {
      this.context.getApplicationContext().setColorMode(this.colorMode);
    } catch (err) {
      console.error(`Failed to apply color mode: ${JSON.stringify(err)}`);
    }
  }

  private showThemeSettings(): void {
    this.showThemeDialog = true;
  }

  private getThemeText(): string {
    switch (this.colorMode) {
      case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
        return this.context.resourceManager.getStringSync($r('app.string.theme_light').id);
      case ConfigurationConstant.ColorMode.COLOR_MODE_DARK:
        return this.context.resourceManager.getStringSync($r('app.string.theme_dark').id);
      case ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET:
      default:
        return this.context.resourceManager.getStringSync($r('app.string.theme_follow_system').id);
    }
  }

  private async loadVibrationPreference(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean;
    } catch (err) {
      console.error(`Failed to load vibration preference: ${JSON.stringify(err)}`);
      this.vibrationEnabled = true; // 默认启用
    }
  }

  private async saveVibrationPreference(enabled: boolean): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('vibration_enabled', enabled);
      await this.prefs.flush();
      this.vibrationEnabled = enabled;
      await VibratorUtil.setEnabled(enabled);
    } catch (err) {
      console.error(`Failed to save vibration preference: ${JSON.stringify(err)}`);
    }
  }

  private showAboutApp(): void {
    try {
      promptAction.showDialog({
        title: this.context.resourceManager.getStringSync($r('app.string.about_app').id),
        message: this.context.resourceManager.getStringSync($r('app.string.about_app_message').id),
        buttons: [
          { text: this.context.resourceManager.getStringSync($r('app.string.confirm').id), color: $r('app.color.button_primary') }
        ]
      }).then(() => {
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private showFeedback(): void {
    try {
      promptAction.showDialog({
        title: this.context.resourceManager.getStringSync($r('app.string.feedback').id),
        message: this.context.resourceManager.getStringSync($r('app.string.feedback_message').id),
        buttons: [
          { text: this.context.resourceManager.getStringSync($r('app.string.ok').id), color: $r('app.color.button_primary') }
        ]
      }).then(() => {
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async shareApp(): Promise<void> {
    try {
      const bundleName = 'com.douhua.flag';
      const appGalleryUrl = `https://appgallery.huawei.com/app/detail?id=${bundleName}&channelId=SHARE&source=appshare`;
      const shareTextTemplate = this.context.resourceManager.getStringSync($r('app.string.share_app_text').id);
      const shareText = shareTextTemplate.replace('{url}', appGalleryUrl);

      const shareData: systemShare.SharedData = new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.TEXT,
        content: shareText,
        title: this.context.resourceManager.getStringSync($r('app.string.share_app_title').id),
        description: this.context.resourceManager.getStringSync($r('app.string.share_app_description').id)
      });

      const controller: systemShare.ShareController = new systemShare.ShareController(shareData);

      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DEFAULT
      });

      console.info('Share panel opened successfully');
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to share: code: ${error?.code}, message: ${error?.message}`);
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private async rateApp(): Promise<void> {
    const bundleName = 'com.douhua.flag';
    try {
      const want: Want = {
        action: 'ohos.want.action.viewData',
        uri: `appmarket://details?id=${bundleName}`
      };

      try {
        await this.context.startAbility(want);
      } catch (err) {
        try {
          const fallbackWant: Want = {
            action: 'ohos.want.action.viewData',
            bundleName: 'com.huawei.appmarket',
            uri: `appmarket://details?id=${bundleName}`
          };
          await this.context.startAbility(fallbackWant);
        } catch (fallbackErr) {
          console.error(`Failed to open app market: ${JSON.stringify(fallbackErr)}`);
          promptAction.showToast({
            message: this.context.resourceManager.getStringSync($r('app.string.cannot_open_market_manual').id),
            duration: 2000
          });
        }
      }
    } catch (err) {
      console.error(`Failed to open app market: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.cannot_open_market').id),
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          Column() {
            // 我的收藏
            Column() {
              this.settingItem($r('app.media.icon_favorite'), this.context.resourceManager.getStringSync($r('app.string.my_favorites').id), '', () => {
                router.pushUrl({ url: 'pages/profile/FavoritesPage' })
                  .catch((err: Error) => {
                    console.error(`Failed to navigate to FavoritesPage: ${err.message}`);
                  });
              })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 16, bottom: 0 })

            // 扩展资源包（顺序：国徽 → 历史国旗 → 州旗 → 国歌）
            // 图标与底部 Tab 同形（国徽无对应 Tab，沿用星形 icon_star）；使用 icon_optional_* 独立文件以便列表配色（base #000 / dark #FFF），不与 Tab 资源混用
            Column() {
              this.settingItemWithValue($r('app.media.icon_optional_coat_of_arms'),
                this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_title').id),
                () => this.getOptionalStatusText(this.coatOfArmsModuleReady),
                () => {
                  this.openOptionalModuleDetailDialog(MODULE_COAT_OF_ARMS);
                })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithValue($r('app.media.icon_optional_flag_history'),
                this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_title').id),
                () => this.getOptionalStatusText(this.flagHistoryModuleReady),
                () => {
                  this.openOptionalModuleDetailDialog(MODULE_FLAGHISTORY);
                })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithValue($r('app.media.icon_optional_state_flags'),
                this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_title').id),
                () => this.getOptionalStatusText(this.stateFlagsModuleReady),
                () => {
                  this.openOptionalModuleDetailDialog(MODULE_STATE_FLAGS);
                })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithValue($r('app.media.icon_optional_anthem'),
                this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_title').id),
                () => this.getOptionalStatusText(this.anthemModuleReady),
                () => {
                  this.openOptionalModuleDetailDialog(MODULE_ANTHEM);
                })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 16, bottom: 0 })

            // 设置项
            Column() {
              this.settingItemWithValue($r('app.media.icon_theme'), this.context.resourceManager.getStringSync($r('app.string.dark_mode').id), () => this.getThemeText(), () => {
                this.showThemeSettings();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithToggle($r('app.media.icon_vibration'), this.context.resourceManager.getStringSync($r('app.string.vibration_feedback').id), this.vibrationEnabled, (enabled: boolean) => {
                this.saveVibrationPreference(enabled);
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_star'), this.context.resourceManager.getStringSync($r('app.string.app_rating').id), '', () => {
                this.rateApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_share'), this.context.resourceManager.getStringSync($r('app.string.share_app').id), '', () => {
                this.shareApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_feedback'), this.context.resourceManager.getStringSync($r('app.string.feedback').id), '', () => {
                this.showFeedback();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_about'), this.context.resourceManager.getStringSync($r('app.string.about_app').id), '', () => {
                this.showAboutApp();
              })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 12, bottom: 0 })

            // 应用信息
            Text($r('app.string.profile_watch_launched'))
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .textAlign(TextAlign.Center)
              .margin({ top: 40, bottom: 40 })
          }
          .width('100%')
            .constraintSize({ maxWidth: getContentMaxWidth() })
            .padding({ left: 20, right: 20, bottom: 16 })
        }
        .width('100%')
          .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .focusable(true)
      .defaultFocus(true)

      // 主题设置对话框
      if (this.showThemeDialog) {
        this.ThemeDialog()
      }

      if (this.optionalModuleDialogTarget !== '') {
        this.OptionalModuleDetailDialog()
      }
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  settingItem(icon: Resource, title: string, value: string, onClick?: () => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      if (value !== '') {
        Row() {
          Text(value)
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
          Text('›')
            .fontSize(20)
            .fontColor($r('app.color.gray_disabled'))
            .margin({ left: 8 })
        }
      } else {
        Text('›')
          .fontSize(20)
          .fontColor($r('app.color.gray_disabled'))
      }
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        if (onClick) {
          onClick();
        }
      })
  }

  @Builder
  settingItemWithValue(icon: Resource, title: string, valueGetter: () => string, onClick?: () => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      if (valueGetter() !== '') {
        Row() {
          Text(valueGetter())
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('›')
            .fontSize(20)
            .fontColor($r('app.color.gray_disabled'))
            .margin({ left: 8 })
        }
      } else {
        Text('›')
          .fontSize(20)
          .fontColor($r('app.color.gray_disabled'))
      }
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        if (onClick) {
          onClick();
        }
      })
  }

  @Builder
  settingItemWithToggle(icon: Resource, title: string, enabled: boolean, onToggle: (enabled: boolean) => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .selectedColor($r('app.color.button_primary'))
        .switchPointColor($r('app.color.white'))
        .onChange((isOn: boolean) => {
          onToggle(isOn);
        })
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
  }

  @Builder
  OptionalModuleDetailDialog() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.closeOptionalModuleDetailDialog();
        })

      Column() {
        Text(this.getOptionalModuleDialogTitle())
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 8 })

        Text(
          this.isOptionalDialogTargetReady()
            ? this.context.resourceManager.getStringSync($r('app.string.optional_module_status_ready').id)
            : this.context.resourceManager.getStringSync($r('app.string.optional_module_status_missing').id)
        )
          .fontSize(13)
          .fontColor($r('app.color.text_tertiary'))
          .width('100%')
          .margin({ bottom: 8 })

        Text(this.getOptionalModuleApproxSizeHint())
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
          .width('100%')
          .opacity(0.9)
          .margin({ bottom: 12 })

        Text(this.getOptionalModuleEntryHint())
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
          .width('100%')
          .margin({ bottom: 12 })

        Scroll() {
          Text(this.getOptionalModuleDetailScrollText())
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .lineHeight(22)
            .width('100%')
        }
        .width('100%')
        .constraintSize({ maxHeight: 220 })
        .scrollBar(BarState.Auto)
        .margin({ bottom: 16 })

        if (this.isOptionalDialogTargetReady()) {
          Text(this.context.resourceManager.getStringSync($r('app.string.optional_module_dialog_installed_hint').id))
            .fontSize(14)
            .fontColor($r('app.color.color_green'))
            .width('100%')
            .margin({ bottom: 16 })
        }

        if (!this.isOptionalDialogTargetReady()) {
          if (!this.optionalModuleDownloadStartedInDialog) {
            Button(this.context.resourceManager.getStringSync($r('app.string.optional_module_dialog_download').id))
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.button_primary'))
              .fontColor($r('app.color.white'))
              .fontSize(16)
              .width('100%')
              .height(48)
              .borderRadius(8)
              .margin({ bottom: 12 })
              .onClick(() => {
                void this.onOptionalModuleDialogDownload();
              })
          } else {
            Text(this.context.resourceManager.getStringSync($r('app.string.optional_module_dialog_after_download_hint').id))
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
              .width('100%')
              .margin({ bottom: 16 })
          }
        }

        Button(this.context.resourceManager.getStringSync($r('app.string.optional_module_dialog_close').id))
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.bg_secondary'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .width('100%')
          .height(48)
          .borderRadius(8)
          .onClick(() => {
            this.closeOptionalModuleDetailDialog();
          })
      }
      .width('85%')
      .constraintSize({ maxWidth: 340 })
      .padding({ left: 22, right: 22, top: 22, bottom: 22 })
      .backgroundColor($r('app.color.bg_card'))
      .borderRadius(16)
      .shadow({
        radius: 20,
        color: $r('app.color.shadow'),
        offsetX: 0,
        offsetY: 4
      })
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  ThemeDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.showThemeDialog = false;
        })

      // 对话框
      Column() {
        Text(this.context.resourceManager.getStringSync($r('app.string.dark_mode').id))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 20 })

        this.ThemeOption(this.context.resourceManager.getStringSync($r('app.string.theme_follow_system').id), ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
        this.ThemeOption(this.context.resourceManager.getStringSync($r('app.string.theme_light').id), ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
        this.ThemeOption(this.context.resourceManager.getStringSync($r('app.string.theme_dark').id), ConfigurationConstant.ColorMode.COLOR_MODE_DARK)

        Button(this.context.resourceManager.getStringSync($r('app.string.confirm').id))
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.white'))
          .fontSize(16)
          .width('100%')
          .height(48)
          .borderRadius(8)
          .margin({ top: 20 })
          .onClick(async () => {
            await this.saveColorMode();
            this.showThemeDialog = false;
          })
      }
      .width('80%')
        .constraintSize({ maxWidth: 320 })
        .padding({ left: 24, right: 24, top: 24, bottom: 24 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .shadow({
          radius: 20,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  ThemeOption(label: string, value: ConfigurationConstant.ColorMode) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)

      if (this.colorMode === value) {
        Text('✓')
          .fontSize(18)
          .fontColor($r('app.color.button_primary'))
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
      .padding({ top: 16, bottom: 16, left: 16, right: 16 })
      .borderRadius(8)
      .backgroundColor(this.colorMode === value ? $r('app.color.bg_blue_light') : $r('app.color.bg_secondary'))
      .margin({ bottom: 12 })
      .onClick(() => {
        this.colorMode = value;
      })
  }
}
