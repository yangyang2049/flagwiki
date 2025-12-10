import vibrator from '@ohos.vibrator';
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { PreferencesManager } from './PreferencesManager';

/**
 * 振动工具类
 * 提供游戏中的触觉反馈：点击、正确、错误、胜利
 */
export class VibratorUtil {
  private static isInitialized: boolean = false;
  private static isEnabled: boolean = true; // 默认启用
  private static prefs: preferences.Preferences | null = null;

  /**
   * 初始化振动工具
   */
  static async init(context: common.Context): Promise<void> {
    if (VibratorUtil.isInitialized) {
      return;
    }
    try {
      VibratorUtil.prefs = await PreferencesManager.getPreferences('app_settings');
      // 读取振动设置，默认启用
      VibratorUtil.isEnabled = await VibratorUtil.prefs.get('vibration_enabled', true) as boolean;
      VibratorUtil.isInitialized = true;
      console.info(`[VibratorUtil] Initialized, vibration enabled: ${VibratorUtil.isEnabled}`);
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to initialize: ${error.message}`);
      VibratorUtil.isEnabled = true; // 默认启用
      VibratorUtil.isInitialized = true;
    }
  }

  /**
   * 设置是否启用振动
   */
  static async setEnabled(enabled: boolean): Promise<void> {
    VibratorUtil.isEnabled = enabled;
    try {
      if (VibratorUtil.prefs) {
        await VibratorUtil.prefs.put('vibration_enabled', enabled);
        await VibratorUtil.prefs.flush();
        console.info(`[VibratorUtil] Vibration ${enabled ? 'enabled' : 'disabled'}`);
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to save vibration setting: ${error.message}`);
    }
  }

  /**
   * 检查是否启用振动
   */
  static isVibrationEnabled(): boolean {
    return VibratorUtil.isEnabled;
  }

  /**
   * 点击振动（轻触反馈）
   */
  static vibrateTap(): void {
    if (!VibratorUtil.isEnabled) {
      return;
    }
    try {
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error(`[VibratorUtil] Failed to vibrate tap: code=${error.code}, message=${error.message}`);
        }
      });
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to vibrate tap: code=${error.code}, message=${error.message}`);
    }
  }

  /**
   * 正确答案振动（短促两次振动）
   */
  static vibrateCorrect(): void {
    if (!VibratorUtil.isEnabled) {
      return;
    }
    try {
      // 第一次短振
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error(`[VibratorUtil] Failed to vibrate correct (1st): code=${error.code}, message=${error.message}`);
        } else {
          // 短暂间隔后第二次振动
          setTimeout(() => {
            vibrator.vibrate(50, (error2: BusinessError) => {
              if (error2) {
                console.error(`[VibratorUtil] Failed to vibrate correct (2nd): code=${error2.code}, message=${error2.message}`);
              }
            });
          }, 80);
        }
      });
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to vibrate correct: code=${error.code}, message=${error.message}`);
    }
  }

  /**
   * 错误答案振动（中长振动）
   */
  static vibrateIncorrect(): void {
    if (!VibratorUtil.isEnabled) {
      return;
    }
    try {
      vibrator.vibrate(250, (error: BusinessError) => {
        if (error) {
          console.error(`[VibratorUtil] Failed to vibrate incorrect: code=${error.code}, message=${error.message}`);
        }
      });
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to vibrate incorrect: code=${error.code}, message=${error.message}`);
    }
  }

  /**
   * 胜利/完成振动（三次短振）
   */
  static vibrateWin(): void {
    if (!VibratorUtil.isEnabled) {
      return;
    }
    try {
      // 第一次短振
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error(`[VibratorUtil] Failed to vibrate win (1st): code=${error.code}, message=${error.message}`);
        } else {
          // 第二次短振
          setTimeout(() => {
            vibrator.vibrate(50, (error2: BusinessError) => {
              if (error2) {
                console.error(`[VibratorUtil] Failed to vibrate win (2nd): code=${error2.code}, message=${error2.message}`);
              } else {
                // 第三次短振
                setTimeout(() => {
                  vibrator.vibrate(50, (error3: BusinessError) => {
                    if (error3) {
                      console.error(`[VibratorUtil] Failed to vibrate win (3rd): code=${error3.code}, message=${error3.message}`);
                    }
                  });
                }, 80);
              }
            });
          }, 80);
        }
      });
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[VibratorUtil] Failed to vibrate win: code=${error.code}, message=${error.message}`);
    }
  }
}
