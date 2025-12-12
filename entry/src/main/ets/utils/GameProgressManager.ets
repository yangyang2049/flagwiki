/**
 * 游戏进度管理器
 * 用于持久化存储和读取各个游戏的解锁进度
 */

import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';

// 游戏类型枚举
export enum GameType {
  MEMORY = 'memory',           // 记忆翻牌
  FAKE_FLAG = 'fakeFlag',      // 找不同
  QUIZ = 'quiz',               // 国旗猜猜
  INPUT = 'input',             // 输入游戏
  TRIVIA = 'trivia',           // 知识问答
  CONNECTIONS = 'connections', // 分组连线
  PAINT_WORLD = 'paint_world', // 涂鸦-世界
  PAINT_US = 'paint_us'        // 涂鸦-美国
}

// 进度存储的 key 前缀
const PROGRESS_KEY_PREFIX = 'game_unlocked_level_';
const PREFS_NAME = 'game_progress';

class GameProgressManagerClass {
  private prefs: preferences.Preferences | null = null;
  private isInitialized: boolean = false;
  private initPromise: Promise<void> | null = null;

  /**
   * 初始化进度管理器
   */
  async init(context: common.UIAbilityContext): Promise<void> {
    if (this.isInitialized) return;
    
    if (this.initPromise) {
      await this.initPromise;
      return;
    }

    this.initPromise = this.doInit(context);
    await this.initPromise;
  }

  private async doInit(context: common.UIAbilityContext): Promise<void> {
    try {
      this.prefs = await preferences.getPreferences(context, PREFS_NAME);
      this.isInitialized = true;
      this.initPromise = null; // 成功后清空 initPromise
      console.info('[GameProgressManager] Initialized successfully');
    } catch (err) {
      console.error('[GameProgressManager] Failed to initialize:', err);
      // 初始化失败时重置 initPromise，允许重试
      this.initPromise = null;
      // ArkTS 要求 throw 必须是 Error 类型
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(`Failed to initialize GameProgressManager: ${String(err)}`);
      }
    }
  }

  /**
   * 获取某个游戏的解锁关卡数
   * @param gameType 游戏类型
   * @returns 已解锁的最高关卡号（默认为1）
   */
  async getUnlockedLevel(gameType: GameType): Promise<number> {
    if (!this.prefs) {
      console.warn('[GameProgressManager] Prefs not initialized, returning default level 1');
      return 1;
    }

    try {
      const key = PROGRESS_KEY_PREFIX + gameType;
      const level = await this.prefs.get(key, 1);
      return level as number;
    } catch (err) {
      console.error('[GameProgressManager] Failed to get unlocked level:', err);
      return 1;
    }
  }

  /**
   * 设置解锁关卡数（用于重置进度）
   * @param gameType 游戏类型
   * @param level 要设置的关卡号
   */
  async setUnlockedLevel(gameType: GameType, level: number): Promise<void> {
    if (!this.prefs) {
      console.warn('[GameProgressManager] Prefs not initialized');
      return;
    }

    try {
      const key = PROGRESS_KEY_PREFIX + gameType;
      await this.prefs.put(key, level);
      await this.prefs.flush();
      console.info(`[GameProgressManager] Set unlocked level for ${gameType} to ${level}`);
    } catch (err) {
      console.error('[GameProgressManager] Failed to set unlocked level:', err);
      // ArkTS 要求 throw 必须是 Error 类型
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(`Failed to set unlocked level: ${String(err)}`);
      }
    }
  }

  /**
   * 解锁下一关
   * @param gameType 游戏类型
   * @param completedLevel 刚完成的关卡号
   * @param maxLevel 最大关卡数（可选，用于防止溢出）
   * @returns 新的解锁关卡号
   */
  async unlockNextLevel(gameType: GameType, completedLevel: number, maxLevel?: number): Promise<number> {
    if (!this.prefs) {
      console.warn('[GameProgressManager] Prefs not initialized');
      return completedLevel + 1;
    }

    try {
      const key = PROGRESS_KEY_PREFIX + gameType;
      const currentUnlocked = await this.getUnlockedLevel(gameType);
      let newLevel = Math.max(currentUnlocked, completedLevel + 1);
      
      // 如果提供了最大关卡数，防止溢出
      if (maxLevel !== undefined && newLevel > maxLevel) {
        newLevel = maxLevel;
      }
      
      await this.prefs.put(key, newLevel);
      await this.prefs.flush();
      
      console.info(`[GameProgressManager] Unlocked level ${newLevel} for ${gameType}`);
      return newLevel;
    } catch (err) {
      console.error('[GameProgressManager] Failed to unlock next level:', err);
      return completedLevel + 1;
    }
  }

  /**
   * 重置某个游戏的进度
   * @param gameType 游戏类型
   */
  async resetProgress(gameType: GameType): Promise<void> {
    if (!this.prefs) return;

    try {
      const key = PROGRESS_KEY_PREFIX + gameType;
      await this.prefs.delete(key);
      await this.prefs.flush();
      console.info(`[GameProgressManager] Reset progress for ${gameType}`);
    } catch (err) {
      console.error('[GameProgressManager] Failed to reset progress:', err);
    }
  }

  /**
   * 重置所有游戏进度
   */
  async resetAllProgress(): Promise<void> {
    if (!this.prefs) return;

    try {
      await this.prefs.clear();
      await this.prefs.flush();
      console.info('[GameProgressManager] Reset all progress');
    } catch (err) {
      console.error('[GameProgressManager] Failed to reset all progress:', err);
    }
  }
}

// 单例导出
export const GameProgressManager = new GameProgressManagerClass();

