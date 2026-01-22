import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { DeviceHelper } from '../utils/DeviceHelper';
import { FavoritesManager } from '../utils/favoritesManager';
import { GameProgressManager } from '../utils/GameProgressManager';
import { PreferencesManager } from '../utils/PreferencesManager';
import { LocalizationUtil } from '../utils/LocalizationUtil';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 存储 context 到 AppStorage，供 MediaService 等使用
    AppStorage.setOrCreate('context', this.context);

    // 初始化 PreferencesManager
    PreferencesManager.init(this.context);

    // 初始化语言设置
    await this.initializeLanguage();

    // 加载并应用主题设置
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const savedColorMode: number = await prefs.get('colorMode', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
      this.context.getApplicationContext().setColorMode(savedColorMode as ConfigurationConstant.ColorMode);
      hilog.info(DOMAIN, 'testTag', 'Color mode loaded: %{public}d', savedColorMode);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to load color mode: %{public}s', JSON.stringify(err));
    }

    // 初始化收藏管理器
    try {
      await FavoritesManager.init(this.context);
      hilog.info(DOMAIN, 'testTag', 'FavoritesManager initialized');
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to init FavoritesManager. Cause: %{public}s', JSON.stringify(err));
    }

    // 初始化游戏进度管理器
    try {
      await GameProgressManager.init(this.context);
      hilog.info(DOMAIN, 'testTag', 'GameProgressManager initialized');
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to init GameProgressManager. Cause: %{public}s', JSON.stringify(err));
    }

    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  private async initializeLanguage(): Promise<void> {
    try {
      const resourceLanguage = this.getAppLanguageCode();
      const systemLanguage = await LocalizationUtil.getSystemLanguage(this.context);
      const fallbackLanguage = (resourceLanguage || systemLanguage || 'zh').toLowerCase();
      AppStorage.setOrCreate('currentLanguage', fallbackLanguage);
      AppStorage.set('currentLanguage', fallbackLanguage);
      const verifyLang = AppStorage.get<string>('currentLanguage');
      hilog.info(DOMAIN, 'testTag', 'Initialized language in AppStorage: %{public}s', verifyLang || 'undefined');
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', 'Failed to initialize language: %{public}s', JSON.stringify(error));
      AppStorage.setOrCreate('currentLanguage', 'zh');
      AppStorage.set('currentLanguage', 'zh');
    }
  }

  private getAppLanguageCode(): string {
    try {
      const language = this.context.resourceManager.getStringSync($r('app.string.app_language_code').id);
      return typeof language === 'string' ? language.trim().toLowerCase() : '';
    } catch (error) {
      hilog.warn(DOMAIN, 'testTag', 'Failed to read app language code: %{public}s', JSON.stringify(error));
      return '';
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    const mainPage = DeviceHelper.isWearable() ? 'pages/watch/Index' : 'pages/Index';
    windowStage.loadContent(mainPage, (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onConfigurationUpdated(config: Configuration): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onConfigurationUpdated');
    void this.initializeLanguage();
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    // Ensure English language is maintained
    void this.initializeLanguage();
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
