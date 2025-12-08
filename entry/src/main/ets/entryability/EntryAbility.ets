import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { FavoritesManager } from '../utils/favoritesManager';
import { GameProgressManager } from '../utils/GameProgressManager';
import { PreferencesManager } from '../utils/PreferencesManager';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 初始化 PreferencesManager
    PreferencesManager.init(this.context);

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

    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
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