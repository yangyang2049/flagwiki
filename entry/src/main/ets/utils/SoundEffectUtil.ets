import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import { PreferencesManager } from './PreferencesManager';

/**
 * 音效类型枚举
 */
export enum SoundType {
  CORRECT = 'correct',        // 正确答案
  INCORRECT = 'incorrect',    // 错误答案
  BUTTON = 'button',          // 按钮点击
  TAP = 'tap',                // 轻触
  SUCCESS = 'success',        // 成功
  CONGRATS = 'congrats',      // 恭喜
  OVER = 'over',              // 游戏结束
  POP = 'pop',                // 弹出
  KEY = 'key',                // 按键
  HINT = 'hint',              // 提示
  BIP = 'bip',                // 哔声
  BER = 'ber',                // 提示音
  GUESSED = 'guessed',        // 已猜测
  WRONG = 'wrong'             // 错误
}

/**
 * 音效播放工具类
 * 用于管理游戏中的音效播放
 */
export class SoundEffectUtil {
  private static soundPool: media.SoundPool | null = null;
  private static soundMap: Map<SoundType, number> = new Map();
  private static context: common.UIAbilityContext | null = null;
  private static isInitialized: boolean = false;
  private static audioRendererInfo: audio.AudioRendererInfo | null = null;
  private static refCount: number = 0; // 引用计数，跟踪使用方数量
  private static isEnabled: boolean = true; // 默认启用
  private static prefs: preferences.Preferences | null = null;

  /**
   * 初始化音效播放器
   * @param context UIAbility上下文
   */
  static async init(context: common.UIAbilityContext): Promise<void> {
    // 增加引用计数
    SoundEffectUtil.refCount++;
    
    // 如果已经初始化，直接返回
    if (SoundEffectUtil.isInitialized) {
      console.info(`SoundEffectUtil already initialized, refCount: ${SoundEffectUtil.refCount}`);
      return;
    }

    try {
      SoundEffectUtil.context = context;
      
      // 读取音效设置
      SoundEffectUtil.prefs = await PreferencesManager.getPreferences('app_settings');
      SoundEffectUtil.isEnabled = await SoundEffectUtil.prefs.get('sound_enabled', true) as boolean;

      // 创建音频渲染器信息
      const audioStreamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
        channels: audio.AudioChannel.CHANNEL_2,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      };

      SoundEffectUtil.audioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_GAME,
        rendererFlags: 1
      };

      // 创建 SoundPool - 直接返回 Promise
      SoundEffectUtil.soundPool = await media.createSoundPool(10, SoundEffectUtil.audioRendererInfo);

      // 加载所有音效文件
      await SoundEffectUtil.loadAllSounds(context);

      SoundEffectUtil.isInitialized = true;
      console.info(`SoundEffectUtil initialized successfully, refCount: ${SoundEffectUtil.refCount}`);
    } catch (err) {
      const error = err as BusinessError;
      console.error(`SoundEffectUtil init failed. Code: ${error.code}, message: ${error.message}`);
      // 初始化失败时减少引用计数
      SoundEffectUtil.refCount--;
    }
  }

  /**
   * 加载所有音效文件
   */
  private static async loadAllSounds(context: common.UIAbilityContext): Promise<void> {
    if (!SoundEffectUtil.soundPool) return;

    try {
      const resourceManager = context.resourceManager;

      // 加载所有音效类型
      const soundTypes: SoundType[] = [
        SoundType.CORRECT,
        SoundType.INCORRECT,
        SoundType.BUTTON,
        SoundType.TAP,
        SoundType.SUCCESS,
        SoundType.CONGRATS,
        SoundType.OVER,
        SoundType.POP,
        SoundType.KEY,
        SoundType.HINT,
        SoundType.BIP,
        SoundType.BER,
        SoundType.GUESSED,
        SoundType.WRONG
      ];

      for (const soundType of soundTypes) {
        try {
          // 获取资源文件路径
          const filePath = `sfx/${soundType}.mp3`;
          
          if (!SoundEffectUtil.soundPool) {
            console.warn(`SoundPool not available for ${soundType}`);
            continue;
          }

          // 使用 getRawFdSync 获取文件描述符
          const fileDescriptor = resourceManager.getRawFdSync(filePath);
          if (!fileDescriptor) {
            console.warn(`Failed to get file descriptor for ${filePath}`);
            continue;
          }

          // 使用文件描述符加载音频 - load 返回 Promise<number>
          const soundId = await SoundEffectUtil.soundPool.load(
            fileDescriptor.fd,
            fileDescriptor.offset,
            fileDescriptor.length
          );

          if (soundId > 0) {
            SoundEffectUtil.soundMap.set(soundType, soundId);
            console.info(`Loaded sound: ${soundType}, soundId: ${soundId}`);
          } else {
            console.warn(`Failed to load sound ${soundType}, invalid soundId: ${soundId}`);
          }
        } catch (err) {
          const error = err as BusinessError;
          console.warn(`Failed to load sound ${soundType}: ${error.message}`);
        }
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to load sounds: ${error.message}`);
    }
  }

  /**
   * 设置是否启用音效
   */
  static async setEnabled(enabled: boolean): Promise<void> {
    SoundEffectUtil.isEnabled = enabled;
    try {
      if (SoundEffectUtil.prefs) {
        await SoundEffectUtil.prefs.put('sound_enabled', enabled);
        await SoundEffectUtil.prefs.flush();
        console.info(`[SoundEffectUtil] Sound ${enabled ? 'enabled' : 'disabled'}`);
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`[SoundEffectUtil] Failed to save sound setting: ${error.message}`);
    }
  }

  /**
   * 检查是否启用音效
   */
  static isSoundEnabled(): boolean {
    return SoundEffectUtil.isEnabled;
  }

  /**
   * 播放音效
   * @param soundType 音效类型
   * @param volume 音量 (0.0 - 1.0)，默认 1.0
   */
  static async playSound(soundType: SoundType, volume: number = 1.0): Promise<void> {
    // 如果音效被禁用，直接返回
    if (!SoundEffectUtil.isEnabled) {
      return;
    }
    
    if (!SoundEffectUtil.isInitialized || !SoundEffectUtil.soundPool) {
      console.warn('SoundEffectUtil not initialized');
      return;
    }

    const soundId = SoundEffectUtil.soundMap.get(soundType);
    if (soundId === undefined) {
      console.warn(`Sound not loaded: ${soundType}`);
      return;
    }

    try {
      if (!SoundEffectUtil.soundPool) {
        console.warn('SoundPool not available for playback');
        return;
      }

      const playParameters: media.PlayParameters = {
        loop: 0,
        rate: audio.AudioRendererRate.RENDER_RATE_NORMAL,
        leftVolume: volume,
        rightVolume: volume,
        priority: 0
      };

      // play 方法返回 Promise<number>
      await SoundEffectUtil.soundPool.play(soundId, playParameters);
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to play sound ${soundType}: ${error.message}`);
    }
  }

  /**
   * 播放正确答案音效
   */
  static async playCorrect(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.CORRECT);
  }

  /**
   * 播放错误答案音效
   */
  static async playIncorrect(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.INCORRECT);
  }

  /**
   * 播放按钮点击音效
   */
  static async playButton(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.BUTTON);
  }

  /**
   * 播放成功音效
   */
  static async playSuccess(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.SUCCESS);
  }

  /**
   * 播放恭喜音效
   */
  static async playCongrats(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.CONGRATS);
  }

  /**
   * 播放游戏结束音效
   */
  static async playOver(): Promise<void> {
    await SoundEffectUtil.playSound(SoundType.OVER);
  }

  /**
   * 释放资源（使用引用计数，只有最后一个使用方才真正释放）
   */
  static release(): void {
    // 减少引用计数
    SoundEffectUtil.refCount--;
    
    if (SoundEffectUtil.refCount < 0) {
      console.warn('SoundEffectUtil refCount became negative, resetting to 0');
      SoundEffectUtil.refCount = 0;
    }
    
    console.info(`SoundEffectUtil release called, refCount: ${SoundEffectUtil.refCount}`);
    
    // 只有当引用计数为0时才真正释放资源
    if (SoundEffectUtil.refCount === 0 && SoundEffectUtil.soundPool) {
      try {
        // 释放所有加载的音效
        for (const soundId of SoundEffectUtil.soundMap.values()) {
          SoundEffectUtil.soundPool.unload(soundId);
        }
        SoundEffectUtil.soundMap.clear();
        SoundEffectUtil.soundPool.release();
        SoundEffectUtil.soundPool = null;
        SoundEffectUtil.isInitialized = false;
        SoundEffectUtil.context = null;
        console.info('SoundEffectUtil released completely');
      } catch (err) {
        const error = err as BusinessError;
        console.error(`Failed to release SoundEffectUtil: ${error.message}`);
      }
    } else if (SoundEffectUtil.refCount > 0) {
      console.info(`SoundEffectUtil still in use by ${SoundEffectUtil.refCount} component(s), not releasing`);
    }
  }
}
