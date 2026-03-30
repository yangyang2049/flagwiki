import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { PreferencesManager } from './PreferencesManager';
import { FlagSvgAssets } from './FlagSvgAssets';

const DOMAIN = 0xF2B0;
const RAW_ZIP_PATH = 'compressed/flags_bundle.zip';
const PREFS_KEY_VERSION = 'flag_svg_bundle_version';
/** 与压缩包内容变更时递增，触发重新解压 */
export const FLAG_SVG_BUNDLE_VERSION = 1;

/** PK\003\004 本地文件头 */
const SIG_LOCAL = 0x04034b50;

function readU16(u8: Uint8Array, offset: number): number {
  return u8[offset] | (u8[offset + 1] << 8);
}

function readU32(u8: Uint8Array, offset: number): number {
  return u8[offset] | (u8[offset + 1] << 8) | (u8[offset + 2] << 16) | (u8[offset + 3] << 24);
}

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

/**
 * 仅支持 ZIP 内为 STORED（无压缩）的条目（zip -0 生成）。
 */
function unpackStoredZip(zipPath: string, destRoot: string): void {
  const stat = fs.statSync(zipPath);
  const size = stat.size;
  const handle = fs.openSync(zipPath, fs.OpenMode.READ_ONLY);
  const buf = new ArrayBuffer(size);
  fs.readSync(handle.fd, buf);
  fs.closeSync(handle);
  const u8 = new Uint8Array(buf);
  let pos = 0;
  while (pos < u8.length - 30) {
    const sig = readU32(u8, pos);
    if (sig !== SIG_LOCAL) {
      break;
    }
    const method = readU16(u8, pos + 8);
    const compSize = readU32(u8, pos + 18);
    const nameLen = readU16(u8, pos + 26);
    const extraLen = readU16(u8, pos + 28);
    const nameBytes = u8.subarray(pos + 30, pos + 30 + nameLen);
    let entryName = '';
    for (let i = 0; i < nameBytes.length; i++) {
      entryName += String.fromCharCode(nameBytes[i]);
    }
    if (method !== 0) {
      hilog.error(DOMAIN, 'FlagSvg', `ZIP entry uses compression ${method}, only STORED(0) supported: ${entryName}`);
      throw new Error(`Unsupported zip compression: ${method}`);
    }
    const dataStart = pos + 30 + nameLen + extraLen;
    const data = u8.subarray(dataStart, dataStart + compSize);
    const outPath = `${destRoot}/${entryName}`;
    if (entryName.endsWith('/')) {
      try {
        fs.mkdirSync(outPath);
      } catch (_e) {
        void 0;
      }
    } else {
      mkdirsSyncForFile(outPath);
      const fh = fs.openSync(outPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      const sliceBuf = data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
      fs.writeSync(fh.fd, sliceBuf);
      fs.closeSync(fh);
    }
    pos = dataStart + compSize;
  }
}

export class FlagSvgBundleUnpacker {
  static async ensureUnpacked(context: common.UIAbilityContext): Promise<void> {
    const destRoot = `${context.filesDir}/svg_flags_bundle`;
    const markerPath = `${destRoot}/.bundle_ok`;

    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const savedVer = await prefs.get(PREFS_KEY_VERSION, 0) as number;
      const versionOk = savedVer === FLAG_SVG_BUNDLE_VERSION && pathExists(markerPath);
      if (versionOk) {
        FlagSvgAssets.setRoot(destRoot);
        hilog.info(DOMAIN, 'FlagSvg', 'Bundle already extracted, skip.');
        return;
      }

      hilog.info(DOMAIN, 'FlagSvg', 'Extracting flag SVG bundle from rawfile...');
      const rm = context.resourceManager;
      const zipBytes = await rm.getRawFileContent(RAW_ZIP_PATH);
      const cacheZip = `${context.cacheDir}/flags_bundle.zip`;
      const zh = fs.openSync(cacheZip, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      const ab = zipBytes.buffer.slice(zipBytes.byteOffset, zipBytes.byteOffset + zipBytes.byteLength);
      fs.writeSync(zh.fd, ab);
      fs.closeSync(zh);

      try {
        fs.mkdirSync(destRoot);
      } catch (_e) {
        void 0;
      }

      unpackStoredZip(cacheZip, destRoot);

      const okHandle = fs.openSync(markerPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      fs.writeSync(okHandle.fd, new ArrayBuffer(0));
      fs.closeSync(okHandle);

      await prefs.put(PREFS_KEY_VERSION, FLAG_SVG_BUNDLE_VERSION);
      await prefs.flush();

      FlagSvgAssets.setRoot(destRoot);
      hilog.info(DOMAIN, 'FlagSvg', 'Flag SVG bundle extracted successfully.');
    } catch (e) {
      hilog.error(DOMAIN, 'FlagSvg', `Extract failed: ${JSON.stringify(e)}`);
      throw new Error('Flag SVG bundle extract failed');
    }
  }
}
