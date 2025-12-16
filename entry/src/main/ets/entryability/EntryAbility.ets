import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { i18n } from '@kit.LocalizationKit';
import { FavoritesManager } from '../utils/favoritesManager';
import { GameProgressManager } from '../utils/GameProgressManager';
import { PreferencesManager } from '../utils/PreferencesManager';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 存储 context 到 AppStorage，供 MediaService 等使用
    AppStorage.setOrCreate('context', this.context);

    // 初始化 PreferencesManager
    PreferencesManager.init(this.context);

    // 初始化语言设置
    this.initializeLanguage();

    try {
      // 加载保存的主题设置
      await this.loadAndApplyColorMode();
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
      // 如果加载失败，使用默认值（跟随系统）
      try {
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      } catch (setErr) {
        hilog.error(DOMAIN, 'testTag', 'Failed to set default colorMode. Cause: %{public}s', JSON.stringify(setErr));
      }
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

    // 初始化循环播放设置
    try {
      await this.initializeLoopPlaybackPreference();
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to init loop playback preference. Cause: %{public}s', JSON.stringify(err));
    }

    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  private initializeLanguage(): void {
    try {
      // 尝试多种方法获取正确的系统语言
      const systemLocale = i18n.System.getSystemLocale();
      const appPreferredLanguage = i18n.System.getAppPreferredLanguage();

      hilog.info(DOMAIN, 'testTag', 'System locale: %{public}s', systemLocale);
      hilog.info(DOMAIN, 'testTag', 'App preferred language: %{public}s', appPreferredLanguage);

      let languageCode = 'zh'; // 默认中文

      // 使用应用偏好语言（如果可用），否则回退到系统语言
      const languageToCheck = appPreferredLanguage || systemLocale;
      hilog.info(DOMAIN, 'testTag', 'Language to check: %{public}s', languageToCheck);

      if (languageToCheck.startsWith('zh')) {
        languageCode = 'zh';
        hilog.info(DOMAIN, 'testTag', 'Detected Chinese language: %{public}s', languageToCheck);
      } else if (languageToCheck.startsWith('en')) {
        languageCode = 'en';
        hilog.info(DOMAIN, 'testTag', 'Detected English language: %{public}s', languageToCheck);
      } else {
        hilog.info(DOMAIN, 'testTag', 'Unknown language: %{public}s, defaulting to Chinese', languageToCheck);
      }

      hilog.info(DOMAIN, 'testTag', 'Setting initial language to: %{public}s', languageCode);
      AppStorage.setOrCreate('currentLanguage', languageCode);

      // 验证语言是否已设置
      const verifyLang = AppStorage.get<string>('currentLanguage');
      hilog.info(DOMAIN, 'testTag', 'Verified language in AppStorage: %{public}s', verifyLang || 'undefined');
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', 'Failed to initialize language: %{public}s', JSON.stringify(error));
      AppStorage.setOrCreate('currentLanguage', 'zh'); // 回退到中文
    }
  }

  private async loadAndApplyColorMode(): Promise<void> {
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const savedColorMode: number = await prefs.get('colorMode', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
      const colorMode = savedColorMode as ConfigurationConstant.ColorMode;
      this.context.getApplicationContext().setColorMode(colorMode);
      hilog.info(DOMAIN, 'testTag', 'Color mode loaded: %{public}d', colorMode);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to load color mode: %{public}s', JSON.stringify(err));
      throw new Error(`Failed to load color mode: ${JSON.stringify(err)}`);
    }
  }

  private async initializeLoopPlaybackPreference(): Promise<void> {
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const loopPlaybackEnabled = await prefs.get('loop_playback_enabled', true) as boolean;
      AppStorage.setOrCreate('loopPlaybackEnabled', loopPlaybackEnabled);
      hilog.info(DOMAIN, 'testTag', 'Loop playback preference initialized: %{public}s', loopPlaybackEnabled.toString());
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to initialize loop playback preference: %{public}s', JSON.stringify(err));
      // 默认启用循环播放
      AppStorage.setOrCreate('loopPlaybackEnabled', true);
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
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

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}