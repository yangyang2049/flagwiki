import common from '@ohos.app.ability.common';
import { moduleInstallManager } from '@kit.AppGalleryKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import promptAction from '@ohos.promptAction';

const DOMAIN = 0xF1A9;

/** 历史国旗 HSP 模块名 */
export const MODULE_FLAGHISTORY = 'flaghistory';

/** 州旗资源 HSP 模块名 */
export const MODULE_STATE_FLAGS = 'stateflags';

/** 国徽资源 HSP 模块名 */
export const MODULE_COAT_OF_ARMS = 'coatofarms';

/** 与 UI @StorageLink 绑定的键名 */
export const STORAGE_KEY_FLAGHISTORY_READY = 'optionalModuleFlagHistoryReady';
export const STORAGE_KEY_STATE_FLAGS_READY = 'optionalModuleStateFlagsReady';
export const STORAGE_KEY_COAT_OF_ARMS_READY = 'optionalModuleCoatOfArmsReady';
/** 扩展包正在从应用市场下载/安装（用于顶部横幅） */
export const STORAGE_KEY_INSTALL_BUSY = 'optionalModuleInstallBusy';
/** 模块名或 '' */
export const STORAGE_KEY_INSTALL_BUSY_ID = 'optionalModuleInstallBusyId';

export type OptionalModuleName = 'flaghistory' | 'stateflags' | 'coatofarms';

const MODULE_INSTALL_LISTEN_TIMEOUT_SECONDS = 30 * 60;
const activeInstallTasks: Map<OptionalModuleName, Promise<boolean>> = new Map();

function getOptionalModuleStorageKey(moduleName: OptionalModuleName): string {
  if (moduleName === MODULE_FLAGHISTORY) {
    return STORAGE_KEY_FLAGHISTORY_READY;
  }
  if (moduleName === MODULE_STATE_FLAGS) {
    return STORAGE_KEY_STATE_FLAGS_READY;
  }
  return STORAGE_KEY_COAT_OF_ARMS_READY;
}

function setOptionalModuleReady(moduleName: OptionalModuleName, ready: boolean): void {
  const storageKey = getOptionalModuleStorageKey(moduleName);
  AppStorage.setOrCreate(storageKey, ready);
  AppStorage.set(storageKey, ready);
}

/**
 * 使用 AppGalleryKit 查询动态模块安装状态。
 */
export async function isModuleInstalled(moduleName: string): Promise<boolean> {
  try {
    const moduleInfo = moduleInstallManager.getInstalledModule(moduleName);
    return moduleInfo.installStatus === moduleInstallManager.InstallStatus.INSTALLED;
  } catch (e) {
    hilog.error(DOMAIN, 'OptionalModule', `getInstalledModule failed: ${JSON.stringify(e)}`);
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
  const historyOk = await refreshOptionalModuleStatus(MODULE_FLAGHISTORY);
  const stateFlagsOk = await refreshOptionalModuleStatus(MODULE_STATE_FLAGS);
  const coatOk = await refreshOptionalModuleStatus(MODULE_COAT_OF_ARMS);
  hilog.info(DOMAIN, 'OptionalModule', `flaghistory=${historyOk}, stateflags=${stateFlagsOk}, coatofarms=${coatOk}`);
}

function getOptionalModuleTitle(context: common.UIAbilityContext, moduleName: OptionalModuleName): string {
  let resource: Resource;
  if (moduleName === MODULE_FLAGHISTORY) {
    resource = $r('app.string.optional_module_flaghistory_title');
  } else if (moduleName === MODULE_STATE_FLAGS) {
    resource = $r('app.string.optional_module_state_flags_title');
  } else {
    resource = $r('app.string.optional_module_coat_of_arms_title');
  }
  return context.resourceManager.getStringSync(resource.id);
}

function showOptionalModuleToast(context: common.UIAbilityContext, message: string, durationMs: number = 2200): void {
  try {
    promptAction.showToast({
      message: message,
      duration: durationMs
    });
  } catch (_e) {
    void 0;
  }
}

function setOptionalModuleInstallBusy(busy: boolean, moduleName: OptionalModuleName | ''): void {
  const id = busy ? moduleName : '';
  AppStorage.setOrCreate(STORAGE_KEY_INSTALL_BUSY, busy);
  AppStorage.setOrCreate(STORAGE_KEY_INSTALL_BUSY_ID, id);
  AppStorage.set(STORAGE_KEY_INSTALL_BUSY, busy);
  AppStorage.set(STORAGE_KEY_INSTALL_BUSY_ID, id);
}

function createInstallStateHandler(
  context: common.UIAbilityContext,
  moduleName: OptionalModuleName,
  resolve: (ready: boolean) => void,
  cleanup: () => void
): (state: moduleInstallManager.ModuleInstallSessionState) => Promise<boolean> {
  let finished = false;
  const moduleTitle = getOptionalModuleTitle(context, moduleName);

  return async (state: moduleInstallManager.ModuleInstallSessionState): Promise<boolean> => {
    if (finished) {
      return true;
    }
    if (state.modules && state.modules.length > 0 && !state.modules.includes(moduleName)) {
      return false;
    }

    hilog.info(
      DOMAIN,
      'OptionalModule',
      `module=${moduleName}, code=${state.code}, taskStatus=${state.taskStatus}, taskId=${state.taskId ?? ''}`
    );

    if (state.code === moduleInstallManager.RequestErrorCode.DOWNLOAD_WAIT_WIFI && state.taskId) {
      try {
        moduleInstallManager.showCellularDataConfirmation(context, state.taskId);
      } catch (error) {
        hilog.error(DOMAIN, 'OptionalModule', `showCellularDataConfirmation failed: ${JSON.stringify(error)}`);
      }
      showOptionalModuleToast(
        context,
        context.resourceManager.getStringSync($r('app.string.optional_module_wait_wifi').id, moduleTitle)
      );
      return false;
    }

    if (state.code === moduleInstallManager.RequestErrorCode.MODULE_ALREADY_EXISTS) {
      const ready = await refreshOptionalModuleStatus(moduleName);
      finished = true;
      cleanup();
      resolve(ready);
      return true;
    }

    if (
      state.code !== moduleInstallManager.RequestErrorCode.SUCCESS &&
      state.code !== moduleInstallManager.RequestErrorCode.DOWNLOAD_WAIT_WIFI
    ) {
      finished = true;
      cleanup();
      setOptionalModuleReady(moduleName, false);
      showOptionalModuleToast(
        context,
        context.resourceManager.getStringSync($r('app.string.optional_module_download_failed').id, moduleTitle)
      );
      resolve(false);
      return true;
    }

    switch (state.taskStatus) {
      case moduleInstallManager.TaskStatus.INSTALL_SUCCESSFUL: {
        const ready = await refreshOptionalModuleStatus(moduleName);
        finished = true;
        cleanup();
        showOptionalModuleToast(
          context,
          context.resourceManager.getStringSync($r('app.string.optional_module_download_success').id, moduleTitle)
        );
        resolve(ready);
        return true;
      }
      case moduleInstallManager.TaskStatus.DOWNLOAD_FAILED:
      case moduleInstallManager.TaskStatus.INSTALL_FAILED:
      case moduleInstallManager.TaskStatus.CREATE_TASK_FAILED:
      case moduleInstallManager.TaskStatus.HIGHER_VERSION_INSTALLED:
      case moduleInstallManager.TaskStatus.TASK_UNFOUND: {
        finished = true;
        cleanup();
        setOptionalModuleReady(moduleName, false);
        showOptionalModuleToast(
          context,
          context.resourceManager.getStringSync($r('app.string.optional_module_download_failed').id, moduleTitle)
        );
        resolve(false);
        return true;
      }
      default:
        return false;
    }
  };
}

/**
 * 统一的扩展内容获取入口。
 * 在应用内直接触发按需下载，无需跳转应用市场详情页。
 */
export async function openOptionalModuleInstallFlow(
  context: common.UIAbilityContext,
  moduleName: OptionalModuleName
): Promise<boolean> {
  const ready = await refreshOptionalModuleStatus(moduleName);
  if (ready) {
    return true;
  }

  const existingTask = activeInstallTasks.get(moduleName);
  if (existingTask) {
    return existingTask;
  }

  const installTask = new Promise<boolean>((resolve) => {
    let installStatusCallback: ((state: moduleInstallManager.ModuleInstallSessionState) => void) | undefined;
    const cleanup = (): void => {
      setOptionalModuleInstallBusy(false, '');
      if (installStatusCallback) {
        try {
          moduleInstallManager.off('moduleInstallStatus', installStatusCallback);
        } catch (error) {
          hilog.warn(DOMAIN, 'OptionalModule', `moduleInstallManager.off failed: ${JSON.stringify(error)}`);
        }
        installStatusCallback = undefined;
      }
      activeInstallTasks.delete(moduleName);
    };
    const handleState = createInstallStateHandler(context, moduleName, resolve, cleanup);

    installStatusCallback = (state: moduleInstallManager.ModuleInstallSessionState): void => {
      void handleState(state);
    };

    try {
      moduleInstallManager.on('moduleInstallStatus', installStatusCallback, MODULE_INSTALL_LISTEN_TIMEOUT_SECONDS);
      const moduleInstallProvider = new moduleInstallManager.ModuleInstallProvider();
      const request = moduleInstallProvider.createModuleInstallRequest(context);
      const addResult = request.addModule(moduleName);
      if (addResult !== moduleInstallManager.ReturnCode.SUCCESS) {
        cleanup();
        setOptionalModuleReady(moduleName, false);
        showOptionalModuleToast(
          context,
          context.resourceManager.getStringSync(
            $r('app.string.optional_module_download_failed').id,
            getOptionalModuleTitle(context, moduleName)
          )
        );
        resolve(false);
        return;
      }

      const moduleTitle = getOptionalModuleTitle(context, moduleName);
      setOptionalModuleInstallBusy(true, moduleName);
      showOptionalModuleToast(
        context,
        context.resourceManager.getStringSync($r('app.string.optional_module_download_started_detail').id, moduleTitle),
        10000
      );

      void moduleInstallManager.fetchModules(request)
        .then(async (state: moduleInstallManager.ModuleInstallSessionState) => {
          const handled = await handleState(state);
          if (!handled && state.taskStatus === moduleInstallManager.TaskStatus.TASK_ALREADY_EXISTS) {
            return;
          }
        })
        .catch((error: Object) => {
          cleanup();
          setOptionalModuleReady(moduleName, false);
          hilog.error(DOMAIN, 'OptionalModule', `fetchModules failed: ${JSON.stringify(error)}`);
          showOptionalModuleToast(
            context,
            context.resourceManager.getStringSync(
              $r('app.string.optional_module_download_failed').id,
              getOptionalModuleTitle(context, moduleName)
            )
          );
          resolve(false);
        });
    } catch (error) {
      cleanup();
      setOptionalModuleReady(moduleName, false);
      hilog.error(DOMAIN, 'OptionalModule', `openOptionalModuleInstallFlow failed: ${JSON.stringify(error)}`);
      showOptionalModuleToast(
        context,
        context.resourceManager.getStringSync(
          $r('app.string.optional_module_download_failed').id,
          getOptionalModuleTitle(context, moduleName)
        )
      );
      resolve(false);
    }
  });

  activeInstallTasks.set(moduleName, installTask);
  return installTask;
}
