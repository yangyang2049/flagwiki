import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
import router from '@ohos.router';
import { i18n } from '@kit.LocalizationKit';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

// 总关卡数
const QUIZ_TOTAL_LEVELS = 10;
const FAKE_FLAG_TOTAL_LEVELS = 10;
const INPUT_TOTAL_LEVELS = 39;
const TRIVIA_TOTAL_LEVELS = 10;

interface ChallengeProgress {
  name: Resource;
  emoji: string;
  current: number;
  total: number;
  color: Resource;
}

@Component
export struct ProfilePage {
  @State colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @State showThemeDialog: boolean = false;
  @State showLanguageDialog: boolean = false;
  @State selectedLanguage: string = 'zh'; // 'zh' 或 'en'
  @State vibrationEnabled: boolean = true; // 振动反馈开关，默认启用
  @State soundEnabled: boolean = true; // 音效开关，默认启用
  @State loopPlaybackEnabled: boolean = true; // 循环播放开关，默认启用
  @StorageLink('currentLanguage') systemLanguage: string = 'zh';
  @Prop @Watch('onRefreshKeyChanged') refreshKey: number = 0;
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  // 辅助函数：从 Resource 获取字符串值
  private async getStringFromResource(resource: Resource): Promise<string> {
    try {
      const resourceManager = this.context.resourceManager;
      // 在 HarmonyOS 中，Resource 类型可能包含 id 属性（内部属性）
      // 尝试使用 getStringValue 方法获取字符串值
      // 定义接口来访问 Resource 的内部 id 属性
      interface ResourceWithId {
        id: number;
      }
      const resourceRecord = resource as ResourceWithId;
      const resourceId = resourceRecord.id;
      if (resourceId !== undefined && resourceId !== null) {
        try {
          const value = await resourceManager.getStringValue(resourceId);
          return value;
        } catch (e) {
          // 如果 getStringValue 失败，尝试其他方法
          console.warn(`getStringValue failed, trying alternative method: ${JSON.stringify(e)}`);
        }
      }
      // 如果无法获取，返回空字符串
      return '';
    } catch (err) {
      console.error(`Failed to get string from resource: ${JSON.stringify(err)}`);
      return '';
    }
  }

  // 游戏进度状态
  @State quizLevel: number = 1;
  @State fakeFlagLevel: number = 1;
  @State inputLevel: number = 1;
  @State triviaLevel: number = 1;

  async aboutToAppear() {
    // systemLanguage 已通过 @StorageLink 自动同步
    await this.loadColorMode();
    await this.loadLanguage();
    await this.loadGameProgress();
    await this.loadVibrationPreference();
    await this.loadSoundPreference();
    await this.loadLoopPlaybackPreference();
    await VibratorUtil.init(this.context);
    await SoundEffectUtil.init(this.context);
  }

  private onRefreshKeyChanged(): void {
    this.loadColorMode();
    this.loadLanguage();
    this.loadGameProgress();
    this.loadVibrationPreference();
    this.loadSoundPreference();
    this.loadLoopPlaybackPreference();
  }

  private async loadGameProgress(): Promise<void> {
    try {
      // 使用 GameProgressManager 统一读取进度
      await GameProgressManager.init(this.context);
      this.quizLevel = await GameProgressManager.getUnlockedLevel(GameType.QUIZ);
      this.fakeFlagLevel = await GameProgressManager.getUnlockedLevel(GameType.FAKE_FLAG);
      this.inputLevel = await GameProgressManager.getUnlockedLevel(GameType.INPUT);
      this.triviaLevel = await GameProgressManager.getUnlockedLevel(GameType.TRIVIA);
    } catch (err) {
      console.error(`Failed to load game progress: ${JSON.stringify(err)}`);
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
          message: $r('app.string.save_failed_toast'),
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

  private async loadLanguage(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      
      // 检查是否已经保存过语言偏好
      const hasLanguageKey = await this.prefs.has('language');
      
      if (hasLanguageKey) {
        // 已保存过语言偏好，使用保存的值
        const saved: string = await this.prefs.get('language', 'zh') as string;
        this.selectedLanguage = saved;
        console.info(`[ProfilePage] Using saved language preference: ${saved}`);
      } else {
        // 首次安装，检测系统语言
        const systemLang = await LocalizationUtil.getSystemLanguage(this.context);
        this.selectedLanguage = systemLang;
        console.info(`[ProfilePage] First installation, detected system language: ${systemLang}`);
        
        // 保存检测到的系统语言作为初始偏好
        await this.prefs.put('language', systemLang);
        await this.prefs.flush();
      }
      
      // 设置应用偏好语言
      await this.setAppPreferredLanguage(this.selectedLanguage);
      
      // 同步到 AppStorage
      AppStorage.setOrCreate('currentLanguage', this.selectedLanguage);
      
    } catch (err) {
      console.error(`Failed to load language: ${JSON.stringify(err)}`);
      // 出错时使用中文作为默认语言
      this.selectedLanguage = 'zh';
      AppStorage.setOrCreate('currentLanguage', 'zh');
    }
  }

  private async saveLanguage(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('language', this.selectedLanguage);
      await this.prefs.flush();
      
      // 设置应用偏好语言
      await this.setAppPreferredLanguage(this.selectedLanguage);
      
      // 同步到AppStorage
      AppStorage.setOrCreate('currentLanguage', this.selectedLanguage);
    } catch (err) {
      console.error(`Failed to save language: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: $r('app.string.save_failed_toast'),
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private async setAppPreferredLanguage(languageCode: string): Promise<void> {
    try {
      console.log(`[ProfilePage] Setting app preferred language to: ${languageCode}`);
      
      // 将语言代码转换为正确的格式
      let preferredLanguage = languageCode;
      if (languageCode === 'zh') {
        preferredLanguage = 'zh-Hans-CN'; // 简体中文
      } else if (languageCode === 'en') {
        preferredLanguage = 'en-Latn-US'; // 美式英语
      }
      
      // 设置应用偏好语言
      i18n.System.setAppPreferredLanguage(preferredLanguage);
      console.log(`[ProfilePage] App preferred language set to: ${preferredLanguage}`);
    } catch (error) {
      const err = error as BusinessError;
      console.error(`[ProfilePage] Failed to set app preferred language, error code: ${err.code}, message: ${err.message}`);
    }
  }

  private showLanguageSettings(): void {
    this.showLanguageDialog = true;
  }

  private getLanguageText(): Resource {
    if (this.selectedLanguage === 'zh') {
      return $r('app.string.chinese');
    } else {
      return $r('app.string.english');
    }
  }

  private showThemeSettings(): void {
    this.showThemeDialog = true;
  }

  private getThemeText(): Resource {
    switch (this.colorMode) {
      case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
        return $r('app.string.light');
      case ConfigurationConstant.ColorMode.COLOR_MODE_DARK:
        return $r('app.string.dark');
      case ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET:
      default:
        return $r('app.string.follow_system');
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

  private async loadSoundPreference(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      this.soundEnabled = await this.prefs.get('sound_enabled', true) as boolean;
    } catch (err) {
      console.error(`Failed to load sound preference: ${JSON.stringify(err)}`);
      this.soundEnabled = true; // 默认启用
    }
  }

  private async loadLoopPlaybackPreference(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      this.loopPlaybackEnabled = await this.prefs.get('loop_playback_enabled', true) as boolean;
      // 同步到 AppStorage，供 MediaService 使用
      AppStorage.setOrCreate('loopPlaybackEnabled', this.loopPlaybackEnabled);
    } catch (err) {
      console.error(`Failed to load loop playback preference: ${JSON.stringify(err)}`);
      this.loopPlaybackEnabled = true; // 默认启用
      AppStorage.setOrCreate('loopPlaybackEnabled', true);
    }
  }

  private async saveSoundPreference(enabled: boolean): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('sound_enabled', enabled);
      await this.prefs.flush();
      this.soundEnabled = enabled;
      await SoundEffectUtil.setEnabled(enabled);
    } catch (err) {
      console.error(`Failed to save sound preference: ${JSON.stringify(err)}`);
    }
  }

  private async saveLoopPlaybackPreference(enabled: boolean): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('loop_playback_enabled', enabled);
      await this.prefs.flush();
      this.loopPlaybackEnabled = enabled;
      // 同步到 AppStorage，供 MediaService 使用
      AppStorage.setOrCreate('loopPlaybackEnabled', enabled);
    } catch (err) {
      console.error(`Failed to save loop playback preference: ${JSON.stringify(err)}`);
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
      // 在 HarmonyOS 中，showDialog 支持 Resource 类型
      interface DialogButton {
        text: Resource;
        color: Resource;
      }
      interface ShowDialogOptions {
        title: Resource;
        message: Resource;
        buttons: DialogButton[];
      }
      const options: ShowDialogOptions = {
        title: $r('app.string.about_app'),
        message: $r('app.string.about_app_message'),
        buttons: [
          { text: $r('app.string.confirm'), color: $r('app.color.button_primary') }
        ]
      };
      promptAction.showDialog(options).then(() => {
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private showFeedback(): void {
    try {
      // 在 HarmonyOS 中，showDialog 支持 Resource 类型
      interface DialogButton {
        text: Resource;
        color: Resource;
      }
      interface ShowDialogOptions {
        title: Resource;
        message: Resource;
        buttons: DialogButton[];
      }
      const options: ShowDialogOptions = {
        title: $r('app.string.feedback'),
        message: $r('app.string.feedback_message'),
        buttons: [
          { text: $r('app.string.ok'), color: $r('app.color.button_primary') }
        ]
      };
      promptAction.showDialog(options).then(() => {
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
      // 获取字符串资源值
      const appTitle = await this.getStringFromResource($r('app.string.app_welcome_title'));
      const appDesc = await this.getStringFromResource($r('app.string.share_app_description'));
      const downloadText = await this.getStringFromResource($r('app.string.download'));
      const shareText = `${appTitle} - ${appDesc}\n\n${downloadText}: ${appGalleryUrl}`;

      const shareData: systemShare.SharedData = new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.TEXT,
        content: shareText,
        title: appTitle,
        description: appDesc
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
          message: $r('app.string.share_failed'),
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
            message: $r('app.string.cannot_open_app_market'),
            duration: 2000
          });
        }
      }
    } catch (err) {
      console.error(`Failed to open app market: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: $r('app.string.cannot_open_app_market_simple'),
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private getTotalCompletedLevels(): number {
    return (this.quizLevel - 1) + (this.fakeFlagLevel - 1) + (this.inputLevel - 1) + (this.triviaLevel - 1);
  }


  private getTotalLevels(): number {
    return QUIZ_TOTAL_LEVELS + FAKE_FLAG_TOTAL_LEVELS + INPUT_TOTAL_LEVELS + TRIVIA_TOTAL_LEVELS;
  }

  private getChallengeProgressList(): ChallengeProgress[] {
    return [
      {
        name: $r('app.string.game_quiz'),
        emoji: '🎯',
        current: this.quizLevel - 1,
        total: QUIZ_TOTAL_LEVELS,
        color: $r('app.color.button_primary')
      },
      {
        name: $r('app.string.game_fake_flag'),
        emoji: '🔍',
        current: this.fakeFlagLevel - 1,
        total: FAKE_FLAG_TOTAL_LEVELS,
        color: $r('app.color.color_green')
      },
      {
        name: $r('app.string.game_input'),
        emoji: '⌨️',
        current: this.inputLevel - 1,
        total: INPUT_TOTAL_LEVELS,
        color: $r('app.color.color_orange')
      },
      {
        name: $r('app.string.game_trivia'),
        emoji: '🧩',
        current: this.triviaLevel - 1,
        total: TRIVIA_TOTAL_LEVELS,
        color: $r('app.color.color_purple')
      }
    ];
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          Column() {
            // 统计 Banner
            Column() {
              // 顶部总览
              Row() {
                Column() {
                  Text('🏆')
                    .fontSize(40)
                }
                .width(64)
                  .height(64)
                  .backgroundColor($r('app.color.bg_yellow_light'))
                  .borderRadius(32)
                  .justifyContent(FlexAlign.Center)

                Column() {
                  Text($r('app.string.exploration_progress'))
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))

                  Row() {
                    if (!LocalizationUtil.isEnglish(this.systemLanguage)) {
                      Text(`${this.context.resourceManager.getStringSync($r('app.string.completed').id)} `)
                        .fontSize(14)
                        .fontColor($r('app.color.text_secondary'))
                    }
                    Text(`${this.getTotalCompletedLevels()}`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.button_primary'))
                    Text(LocalizationUtil.isEnglish(this.systemLanguage) 
                      ? ` / ${this.getTotalLevels()}`
                      : ` / ${this.getTotalLevels()}${this.context.resourceManager.getStringSync($r('app.string.level').id)}`)
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                  .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                  .margin({ left: 16 })
              }
              .width('100%')
                .margin({ bottom: 20 })

              // 各项进度
              ForEach(this.getChallengeProgressList(), (game: ChallengeProgress) => {
                Row() {
                  Text(game.emoji)
                    .fontSize(20)
                    .width(32)

                  Text(this.context.resourceManager.getStringSync(game.name.id))
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .width(72)

                  // 进度条
                  Stack({ alignContent: Alignment.Start }) {
                    // 背景
                    Row()
                      .width('100%')
                      .height(8)
                      .backgroundColor($r('app.color.bg_secondary'))
                      .borderRadius(4)

                    // 进度
                    Row()
                      .width(`${(game.current / game.total) * 100}%`)
                      .height(8)
                      .backgroundColor(game.color)
                      .borderRadius(4)
                  }
                  .layoutWeight(1)
                    .margin({ left: 12, right: 12 })

                  Text(`${game.current}/${game.total}`)
                    .fontSize(13)
                    .fontColor($r('app.color.text_tertiary'))
                    .width(50)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
                  .margin({ bottom: 12 })
              })
            }
            .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
              .margin({ top: 16 })

            // 我的收藏
            Column() {
              this.settingItem($r('app.media.icon_favorite'), $r('app.string.my_favorites'), '', () => {
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

            // 设置项
            Column() {
              this.settingItemWithValue(this.getThemeIcon(), $r('app.string.dark_mode'), () => this.getThemeText(), () => {
                this.showThemeSettings();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithValue($r('app.media.icon_setting_config'), $r('app.string.language'), () => this.getLanguageText(), () => {
                this.showLanguageSettings();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithToggle($r('app.media.icon_sound'), $r('app.string.sound'), this.soundEnabled, (enabled: boolean) => {
                this.saveSoundPreference(enabled);
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithToggle($r('app.media.icon_vibration'), $r('app.string.vibration'), this.vibrationEnabled, (enabled: boolean) => {
                this.saveVibrationPreference(enabled);
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithToggle($r('app.media.icon_setting_config'), $r('app.string.loop_playback'), this.loopPlaybackEnabled, (enabled: boolean) => {
                this.saveLoopPlaybackPreference(enabled);
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_star'), $r('app.string.rate_app'), '', () => {
                this.rateApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_all_application'), $r('app.string.feedback'), '', () => {
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
              this.settingItem($r('app.media.icon_all_application'), $r('app.string.about_app'), '', () => {
                this.showAboutApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_all_application'), $r('app.string.data_info'), '', () => {
                router.pushUrl({ url: 'pages/profile/DataInfoPage' })
                  .catch((err: Error) => {
                    console.error(`Failed to navigate to DataInfoPage: ${err.message}`);
                  });
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_share'), $r('app.string.share_app'), '', () => {
                this.shareApp();
              })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 12, bottom: 0 })

            // 应用信息
            Text($r('app.string.app_tagline'))
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .textAlign(TextAlign.Center)
              .margin({ top: 40, bottom: 40 })
          }
          .width('100%')
            .constraintSize({ maxWidth: 400 })
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

      // 主题设置对话框
      if (this.showThemeDialog) {
        this.ThemeDialog()
      }

      // 语言设置对话框
      if (this.showLanguageDialog) {
        this.LanguageDialog()
      }
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  settingItem(icon: Resource, title: Resource | string, value: string, onClick?: () => void) {
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
  settingItemWithValue(icon: Resource, title: Resource, valueGetter: () => Resource, onClick?: () => void) {
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

  private getThemeIcon(): Resource {
    // 根据当前颜色模式返回对应的图标
    if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      return $r('app.media.icon_dark_mode');
    } else if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      return $r('app.media.icon_light_mode');
    } else {
      // 跟随系统模式，使用设置图标
      return $r('app.media.icon_setting_config');
    }
  }

  @Builder
  settingItemWithToggle(icon: Resource, title: Resource | string, enabled: boolean, onToggle: (enabled: boolean) => void) {
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
        Text($r('app.string.dark_mode'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 20 })

        this.ThemeOption($r('app.string.follow_system'), ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
        this.ThemeOption($r('app.string.light'), ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
        this.ThemeOption($r('app.string.dark'), ConfigurationConstant.ColorMode.COLOR_MODE_DARK)

        Button($r('app.string.confirm'))
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
  ThemeOption(label: Resource, value: ConfigurationConstant.ColorMode) {
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

  @Builder
  LanguageDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.showLanguageDialog = false;
        })

      // 对话框
      Column() {
        Text($r('app.string.language'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 20 })

        this.LanguageOption($r('app.string.chinese'), 'zh')
        this.LanguageOption($r('app.string.english'), 'en')

        Button($r('app.string.confirm'))
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.white'))
          .fontSize(16)
          .width('100%')
          .height(48)
          .borderRadius(8)
          .margin({ top: 20 })
          .onClick(async () => {
            await this.saveLanguage();
            this.showLanguageDialog = false;
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
  LanguageOption(label: Resource, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)

      if (this.selectedLanguage === value) {
        Text('✓')
          .fontSize(18)
          .fontColor($r('app.color.button_primary'))
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
      .padding({ top: 16, bottom: 16, left: 16, right: 16 })
      .borderRadius(8)
      .backgroundColor(this.selectedLanguage === value ? $r('app.color.bg_blue_light') : $r('app.color.bg_secondary'))
      .margin({ bottom: 12 })
      .onClick(() => {
        this.selectedLanguage = value;
      })
  }
}
