import { fileUri } from '@kit.CoreFileKit';

/** AppStorage：解压后的根目录，内含 flags/ 与 paint_flags/ */
export const STORAGE_KEY_FLAG_SVG_ROOT = 'flagSvgBundleRoot';
export const STORAGE_KEY_FLAG_SVG_READY = 'flagSvgAssetsReady';

/**
 * 国旗 / 涂鸦 SVG 解压后的本地路径与 file:// URI（首次启动由 FlagSvgBundleUnpacker 填充）。
 */
export class FlagSvgAssets {
  static isReady(): boolean {
    const v: boolean | undefined = AppStorage.get(STORAGE_KEY_FLAG_SVG_READY) as boolean | undefined;
    return v === true;
  }

  static getRoot(): string {
    const r = AppStorage.get(STORAGE_KEY_FLAG_SVG_ROOT) as string | undefined;
    return r ?? '';
  }

  static setRoot(root: string): void {
    AppStorage.setOrCreate(STORAGE_KEY_FLAG_SVG_ROOT, root);
    AppStorage.set(STORAGE_KEY_FLAG_SVG_ROOT, root);
    AppStorage.setOrCreate(STORAGE_KEY_FLAG_SVG_READY, true);
    AppStorage.set(STORAGE_KEY_FLAG_SVG_READY, true);
  }

  /** 普通国家国旗 file URI，供 Image() 使用 */
  static getFlagFileUri(code: string): string {
    const path = `${FlagSvgAssets.getRoot()}/flags/${code.toLowerCase()}.svg`;
    return fileUri.getUriFromPath(path);
  }

  /** 涂鸦用 paint_flags 下 SVG 的绝对路径 */
  static getPaintFlagFilePath(code: string): string {
    return `${FlagSvgAssets.getRoot()}/paint_flags/${code.toLowerCase()}.svg`;
  }

  static getPaintFlagFileUri(code: string): string {
    return fileUri.getUriFromPath(FlagSvgAssets.getPaintFlagFilePath(code));
  }

  /**
   * 相对路径如 flags/cn.svg、paint_flags/fr.svg
   */
  static getUriForRelativePath(relativePath: string): string {
    const path = `${FlagSvgAssets.getRoot()}/${relativePath}`;
    return fileUri.getUriFromPath(path);
  }
}
