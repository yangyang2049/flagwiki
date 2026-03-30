import { getStateFlagPath } from './StateFlagData';
import {
  MODULE_COAT_OF_ARMS,
  MODULE_STATE_FLAGS,
  STORAGE_KEY_COAT_OF_ARMS_READY,
  STORAGE_KEY_STATE_FLAGS_READY
} from './OptionalModuleHelper';

export { MODULE_COAT_OF_ARMS, MODULE_STATE_FLAGS };

export function isStateFlagsModuleReady(): boolean {
  const v: boolean | undefined = AppStorage.get(STORAGE_KEY_STATE_FLAGS_READY) as boolean | undefined;
  return v === true;
}

export function isCoatOfArmsModuleReady(): boolean {
  const v: boolean | undefined = AppStorage.get(STORAGE_KEY_COAT_OF_ARMS_READY) as boolean | undefined;
  return v === true;
}

/**
 * 州旗图片（动态模块 stateflags rawfile），未安装模块时返回 null。
 */
export function getStateFlagImageResource(countryCode: string, stateCode: string): Resource | null {
  if (!isStateFlagsModuleReady()) {
    return null;
  }
  const rel = getStateFlagPath(countryCode, stateCode);
  try {
    return $rawfile(`[stateflags].${rel}`) as Resource;
  } catch (_e) {
    return null;
  }
}

/**
 * 国徽 WebP（动态模块 coatofarms rawfile），未安装模块时返回 null。
 */
export function getCoatOfArmsImageResourceFromModule(countryCode: string): Resource | null {
  if (!isCoatOfArmsModuleReady()) {
    return null;
  }
  const lowerCode = countryCode.toLowerCase();
  const rel = `coat_of_arms/coat_of_arms_${lowerCode}.webp`;
  try {
    return $rawfile(`[coatofarms].${rel}`) as Resource;
  } catch (_e) {
    return null;
  }
}
