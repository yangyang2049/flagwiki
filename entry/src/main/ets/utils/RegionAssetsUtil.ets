import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
import { getStateFlagPath } from './StateFlagData';
import {
  MODULE_COAT_OF_ARMS,
  MODULE_STATE_FLAGS,
  STORAGE_KEY_COAT_OF_ARMS_READY,
  STORAGE_KEY_STATE_FLAGS_READY
} from './OptionalModuleHelper';

export { MODULE_COAT_OF_ARMS, MODULE_STATE_FLAGS };

const stateFlagUriCache: Map<string, string> = new Map();

function mkdirsSyncForFile(filePath: string): void {
  const lastSlash = filePath.lastIndexOf('/');
  if (lastSlash <= 0) {
    return;
  }
  const dirOnly = filePath.substring(0, lastSlash);
  const parts = dirOnly.split('/').filter((p: string) => p.length > 0);
  let acc = dirOnly.startsWith('/') ? '/' : '';
  const startIdx = dirOnly.startsWith('/') ? 1 : 0;
  for (let i = startIdx; i < parts.length; i++) {
    acc = acc === '/' ? '/' + parts[i] : acc + '/' + parts[i];
    try {
      fs.mkdirSync(acc);
    } catch (_e) {
      void 0;
    }
  }
}

function pathExists(path: string): boolean {
  try {
    fs.statSync(path);
    return true;
  } catch (_e) {
    return false;
  }
}

function getStateFlagCandidatePaths(countryCode: string, stateCode: string): string[] {
  const svgPath = getStateFlagPath(countryCode, stateCode);
  if (svgPath.endsWith('.svg')) {
    const pngPath = `${svgPath.substring(0, svgPath.length - 4)}.png`;
    // 不列颠哥伦比亚省旗 SVG 含复杂 clip-path，HarmonyOS Image 常渲染为空白；rawfile 提供同名 PNG 时优先
    if (svgPath === 'ca/british_columbia.svg') {
      return [pngPath, svgPath];
    }
    return [svgPath, pngPath];
  }
  return [svgPath];
}

function getStateFlagCacheRoot(context: common.UIAbilityContext): string {
  return `${context.filesDir}/stateflags_module`;
}

function getExistingStateFlagImageUri(
  context: common.UIAbilityContext,
  countryCode: string,
  stateCode: string
): string | null {
  const candidates = getStateFlagCandidatePaths(countryCode, stateCode);
  for (let i = 0; i < candidates.length; i++) {
    const rel = candidates[i];
    const cached = stateFlagUriCache.get(rel);
    if (cached) {
      return cached;
    }
    const outPath = `${getStateFlagCacheRoot(context)}/${rel}`;
    if (pathExists(outPath)) {
      const uri = fileUri.getUriFromPath(outPath);
      stateFlagUriCache.set(rel, uri);
      return uri;
    }
  }
  return null;
}

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
export function getStateFlagImageResource(countryCode: string, stateCode: string): string | Resource | null {
  if (!isStateFlagsModuleReady()) {
    return null;
  }
  const context = AppStorage.get('context') as common.UIAbilityContext | undefined;
  if (context) {
    const localUri = getExistingStateFlagImageUri(context, countryCode, stateCode);
    if (localUri !== null) {
      return localUri;
    }
  }
  const candidates = getStateFlagCandidatePaths(countryCode, stateCode);
  for (let i = 0; i < candidates.length; i++) {
    try {
      return $rawfile(`[stateflags].${candidates[i]}`) as Resource;
    } catch (_e) {
      void 0;
    }
  }
  return null;
}

/**
 * 将州旗动态模块中的 rawfile 拷贝到本地 filesDir，再返回 file:// URI。
 * 这样 Image() 不依赖 HSP rawfile 的直接解析能力，兼容性更稳定。
 */
export async function ensureStateFlagImageCached(
  context: common.UIAbilityContext,
  countryCode: string,
  stateCode: string
): Promise<string | null> {
  if (!isStateFlagsModuleReady()) {
    return null;
  }

  const existing = getExistingStateFlagImageUri(context, countryCode, stateCode);
  if (existing !== null) {
    return existing;
  }

  let rm: resourceManager.ResourceManager;
  try {
    rm = context.createModuleContext(MODULE_STATE_FLAGS).resourceManager;
  } catch (_e) {
    return null;
  }

  const candidates = getStateFlagCandidatePaths(countryCode, stateCode);
  for (let i = 0; i < candidates.length; i++) {
    const rel = candidates[i];
    try {
      const bytes = await rm.getRawFileContent(rel);
      const outPath = `${getStateFlagCacheRoot(context)}/${rel}`;
      mkdirsSyncForFile(outPath);
      const handle = fs.openSync(outPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      const ab = bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength);
      fs.writeSync(handle.fd, ab);
      fs.closeSync(handle);
      const uri = fileUri.getUriFromPath(outPath);
      stateFlagUriCache.set(rel, uri);
      return uri;
    } catch (_e) {
      void 0;
    }
  }

  return null;
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
