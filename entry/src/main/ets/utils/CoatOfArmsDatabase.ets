/**
 * 国徽数据库管理器
 * 使用关系型数据库存储国徽信息和下载进度
 */

import { relationalStore } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';

// 国徽信息表结构
export interface CoatOfArmsInfo {
  countryCode: string;      // 国家代码（主键）
  filePath: string;        // 本地文件路径
  downloadTime: number;    // 下载时间戳
  fileSize: number;        // 文件大小（字节）
}

// 下载进度表结构
export interface DownloadProgress {
  countryCode: string;     // 国家代码（主键）
  status: string;          // 状态：pending, downloading, completed, failed
  progress: number;        // 下载进度 0-100
  errorMessage?: string;   // 错误信息
  lastUpdateTime: number; // 最后更新时间戳
}

const DB_NAME = 'flagwiki.db';
const DB_VERSION = 1;
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME,
  securityLevel: relationalStore.SecurityLevel.S1
};

class CoatOfArmsDatabaseClass {
  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.UIAbilityContext | null = null;
  private isInitialized: boolean = false;
  private initPromise: Promise<void> | null = null;

  /**
   * 初始化数据库
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
      this.context = context;
      const rdbManager = await new Promise<relationalStore.RdbStore>((resolve, reject) => {
        relationalStore.getRdbStore(context, STORE_CONFIG, (err: BusinessError | null, store: relationalStore.RdbStore | null) => {
          if (err || !store) {
            reject(err || new Error('Failed to get RdbStore'));
          } else {
            resolve(store);
          }
        });
      });

      // 创建国徽信息表
      await this.createCoatOfArmsTable(rdbManager);

      // 创建下载进度表
      await this.createDownloadProgressTable(rdbManager);

      this.rdbStore = rdbManager;
      this.isInitialized = true;
      console.info('[CoatOfArmsDatabase] Initialized successfully');
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to initialize:', err);
      this.initPromise = null;
      const error = err instanceof Error ? err : new Error(`Failed to initialize database: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 创建国徽信息表
   */
  private async createCoatOfArmsTable(rdbStore: relationalStore.RdbStore): Promise<void> {
    const createTableSql = `
      CREATE TABLE IF NOT EXISTS coat_of_arms (
        country_code TEXT PRIMARY KEY NOT NULL,
        file_path TEXT NOT NULL,
        download_time INTEGER NOT NULL,
        file_size INTEGER NOT NULL
      )
    `;
    await rdbStore.executeSql(createTableSql);
  }

  /**
   * 创建下载进度表
   */
  private async createDownloadProgressTable(rdbStore: relationalStore.RdbStore): Promise<void> {
    const createTableSql = `
      CREATE TABLE IF NOT EXISTS download_progress (
        country_code TEXT PRIMARY KEY NOT NULL,
        status TEXT NOT NULL,
        progress INTEGER NOT NULL,
        error_message TEXT,
        last_update_time INTEGER NOT NULL
      )
    `;
    await rdbStore.executeSql(createTableSql);
  }

  /**
   * 保存国徽信息
   */
  async saveCoatOfArms(info: CoatOfArmsInfo): Promise<void> {
    if (!this.rdbStore) {
      const error = new Error('Database not initialized');
      throw error;
    }

    try {
      const insertSql = `
        INSERT OR REPLACE INTO coat_of_arms 
        (country_code, file_path, download_time, file_size)
        VALUES (?, ?, ?, ?)
      `;
      await this.rdbStore.executeSql(insertSql, [
        info.countryCode,
        info.filePath,
        info.downloadTime,
        info.fileSize
      ]);
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to save coat of arms:', err);
      const error = err instanceof Error ? err : new Error(`Failed to save coat of arms: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 获取国徽信息
   */
  async getCoatOfArms(countryCode: string): Promise<CoatOfArmsInfo | null> {
    if (!this.rdbStore) {
      return null;
    }

    try {
      const predicates = new relationalStore.RdbPredicates('coat_of_arms');
      predicates.equalTo('country_code', countryCode);
      const resultSet = await this.rdbStore.query(predicates);

      if (resultSet.goToFirstRow()) {
        return {
          countryCode: resultSet.getString(resultSet.getColumnIndex('country_code')) || '',
          filePath: resultSet.getString(resultSet.getColumnIndex('file_path')) || '',
          downloadTime: resultSet.getLong(resultSet.getColumnIndex('download_time')),
          fileSize: resultSet.getLong(resultSet.getColumnIndex('file_size'))
        };
      }

      resultSet.close();
      return null;
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to get coat of arms:', err);
      return null;
    }
  }

  /**
   * 更新下载进度
   */
  async updateDownloadProgress(progress: DownloadProgress): Promise<void> {
    if (!this.rdbStore) {
      const error = new Error('Database not initialized');
      throw error;
    }

    try {
      const insertSql = `
        INSERT OR REPLACE INTO download_progress 
        (country_code, status, progress, error_message, last_update_time)
        VALUES (?, ?, ?, ?, ?)
      `;
      await this.rdbStore.executeSql(insertSql, [
        progress.countryCode,
        progress.status,
        progress.progress,
        progress.errorMessage || null,
        progress.lastUpdateTime
      ]);
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to update download progress:', err);
      const error = err instanceof Error ? err : new Error(`Failed to update download progress: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 获取下载进度
   */
  async getDownloadProgress(countryCode: string): Promise<DownloadProgress | null> {
    if (!this.rdbStore) {
      return null;
    }

    try {
      const predicates = new relationalStore.RdbPredicates('download_progress');
      predicates.equalTo('country_code', countryCode);
      const resultSet = await this.rdbStore.query(predicates);

      if (resultSet.goToFirstRow()) {
        return {
          countryCode: resultSet.getString(resultSet.getColumnIndex('country_code')) || '',
          status: resultSet.getString(resultSet.getColumnIndex('status')) || 'pending',
          progress: resultSet.getLong(resultSet.getColumnIndex('progress')),
          errorMessage: resultSet.getString(resultSet.getColumnIndex('error_message')) || undefined,
          lastUpdateTime: resultSet.getLong(resultSet.getColumnIndex('last_update_time'))
        };
      }

      resultSet.close();
      return null;
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to get download progress:', err);
      return null;
    }
  }

  /**
   * 获取所有下载进度
   */
  async getAllDownloadProgress(): Promise<DownloadProgress[]> {
    if (!this.rdbStore) {
      return [];
    }

    try {
      const predicates = new relationalStore.RdbPredicates('download_progress');
      predicates.orderByDesc('last_update_time');
      const resultSet = await this.rdbStore.query(predicates);

      const progressList: DownloadProgress[] = [];
      while (resultSet.goToNextRow()) {
        progressList.push({
          countryCode: resultSet.getString(resultSet.getColumnIndex('country_code')) || '',
          status: resultSet.getString(resultSet.getColumnIndex('status')) || 'pending',
          progress: resultSet.getLong(resultSet.getColumnIndex('progress')),
          errorMessage: resultSet.getString(resultSet.getColumnIndex('error_message')) || undefined,
          lastUpdateTime: resultSet.getLong(resultSet.getColumnIndex('last_update_time'))
        });
      }

      resultSet.close();
      return progressList;
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to get all download progress:', err);
      return [];
    }
  }

  /**
   * 删除国徽信息
   */
  async deleteCoatOfArms(countryCode: string): Promise<void> {
    if (!this.rdbStore) {
      const error = new Error('Database not initialized');
      throw error;
    }

    try {
      const deleteSql = `DELETE FROM coat_of_arms WHERE country_code = ?`;
      await this.rdbStore.executeSql(deleteSql, [countryCode]);
    } catch (err) {
      console.error('[CoatOfArmsDatabase] Failed to delete coat of arms:', err);
      const error = err instanceof Error ? err : new Error(`Failed to delete coat of arms: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 检查国徽是否存在
   */
  async hasCoatOfArms(countryCode: string): Promise<boolean> {
    const info = await this.getCoatOfArms(countryCode);
    return info !== null;
  }
}

export const coatOfArmsDatabase = new CoatOfArmsDatabaseClass();

