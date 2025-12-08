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
  PAINT_WORLD = 'paint_world', // 涂鸦-世界
  PAINT_US = 'paint_us',       // 涂鸦-美国
  PAINT_DE = 'paint_de',       // 涂鸦-德国
  PAINT_IT = 'paint_it',       // 涂鸦-意大利
  PAINT_BR = 'paint_br'        // 涂鸦-巴西
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
      console.info('[GameProgressManager] Initialized successfully');
    } catch (err) {
      console.error('[GameProgressManager] Failed to initialize:', err);
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
   * 解锁下一关
   * @param gameType 游戏类型
   * @param completedLevel 刚完成的关卡号
   * @returns 新的解锁关卡号
   */
  async unlockNextLevel(gameType: GameType, completedLevel: number): Promise<number> {
    if (!this.prefs) {
      console.warn('[GameProgressManager] Prefs not initialized');
      return completedLevel + 1;
    }

    try {
      const key = PROGRESS_KEY_PREFIX + gameType;
      const currentUnlocked = await this.getUnlockedLevel(gameType);
      const newLevel = Math.max(currentUnlocked, completedLevel + 1);
      
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

