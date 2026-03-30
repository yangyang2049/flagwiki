import common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import promptAction from '@ohos.promptAction';

const DOMAIN = 0xF1A9;

/** 国歌 HSP 模块名（与 module.json5 中 name 一致） */
export const MODULE_ANTHEM = 'anthem';

/** 历史国旗 HSP 模块名 */
export const MODULE_FLAGHISTORY = 'flaghistory';

/** 与 UI @StorageLink 绑定的键名 */
export const STORAGE_KEY_ANTHEM_READY = 'optionalModuleAnthemReady';
export const STORAGE_KEY_FLAGHISTORY_READY = 'optionalModuleFlagHistoryReady';

export type OptionalModuleName = 'anthem' | 'flaghistory';

function getOptionalModuleStorageKey(moduleName: OptionalModuleName): string {
  return moduleName === MODULE_ANTHEM ? STORAGE_KEY_ANTHEM_READY : STORAGE_KEY_FLAGHISTORY_READY;
}

function setOptionalModuleReady(moduleName: OptionalModuleName, ready: boolean): void {
  const storageKey = getOptionalModuleStorageKey(moduleName);
  AppStorage.setOrCreate(storageKey, ready);
  AppStorage.set(storageKey, ready);
}

/**
 * 使用包管理查询当前应用已安装的 HAP/HSP 模块列表，判断是否包含指定模块。
 */
export async function isModuleInstalled(moduleName: string): Promise<boolean> {
  try {
    const flag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE;
    const info = await bundleManager.getBundleInfoForSelf(flag);
    const modules = info.hapModulesInfo;
    for (let i = 0; i < modules.length; i++) {
      if (modules[i].name === moduleName) {
        return true;
      }
    }
  } catch (e) {
    hilog.error(DOMAIN, 'OptionalModule', `getBundleInfoForSelf failed: ${JSON.stringify(e)}`);
  }
  return false;
}

/**
 * 刷新单个可选模块的安装状态，并同步到 AppStorage。
 */
export async function refreshOptionalModuleStatus(moduleName: OptionalModuleName): Promise<boolean> {
  const ready = await isModuleInstalled(moduleName);
  setOptionalModuleReady(moduleName, ready);
  return ready;
}

/**
 * 同步 AppStorage 中的模块就绪标记（供 Tab、详情页等绑定）。
 */
export async function refreshOptionalModuleAppStorage(_context: common.UIAbilityContext): Promise<void> {
  const anthemOk = await refreshOptionalModuleStatus(MODULE_ANTHEM);
  const historyOk = await refreshOptionalModuleStatus(MODULE_FLAGHISTORY);
  hilog.info(DOMAIN, 'OptionalModule', `anthem=${anthemOk}, flaghistory=${historyOk}`);
}

/**
 * 跳转华为应用市场应用详情页，供用户下载/更新含动态模块的版本（需在 AGC 配置按需模块）。
 */
export async function openAppGalleryAppDetail(context: common.UIAbilityContext): Promise<void> {
  const bundleName = 'com.douhua.flag';
  const want: Want = {
    action: 'ohos.want.action.viewData',
    uri: `appmarket://details?id=${bundleName}`
  };
  try {
    await context.startAbility(want);
  } catch (e) {
    hilog.error(DOMAIN, 'OptionalModule', `startAbility market: ${JSON.stringify(e)}`);
    try {
      const fallback: Want = {
        action: 'ohos.want.action.viewData',
        bundleName: 'com.huawei.appmarket',
        uri: `appmarket://details?id=${bundleName}`
      };
      await context.startAbility(fallback);
    } catch (e2) {
      throw (e2 instanceof Error ? e2 : new Error(String(e2)));
    }
  }
}

/**
 * 统一的扩展包获取入口。
 * 当前版本通过应用市场触发下载，返回应用后可再次刷新状态。
 */
export async function openOptionalModuleInstallFlow(context: common.UIAbilityContext): Promise<void> {
  await openAppGalleryAppDetail(context);
  try {
    promptAction.showToast({
      message: context.resourceManager.getStringSync($r('app.string.optional_module_market_hint').id),
      duration: 2500
    });
  } catch (_e) {
    void 0;
  }
}
