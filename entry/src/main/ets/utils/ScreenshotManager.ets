/**
 * 截图工具类
 * 提供统一的截图功能，包括截图、保存等操作
 */

import { image } from "@kit.ImageKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import fs from "@ohos.file.fs";
import common from "@ohos.app.ability.common";

/**
 * 截图管理器
 */
export class ScreenshotManager {
  private uiContext: UIContext | null = null;

  /**
   * 初始化截图管理器
   */
  init(uiContext: UIContext): void {
    this.uiContext = uiContext;
  }

  /**
   * 截取组件快照
   * @param containerId 容器ID
   * @returns PixelMap对象
   */
  async captureSnapshot(containerId: string): Promise<image.PixelMap | null> {
    if (!this.uiContext) {
      console.error("[ScreenshotManager] UIContext not initialized");
      return null;
    }

    try {
      const componentSnapshot = this.uiContext.getComponentSnapshot();
      const pixmap: image.PixelMap = await componentSnapshot.get(containerId);

      if (pixmap) {
        console.info("[ScreenshotManager] Screenshot captured successfully");
        return pixmap;
      } else {
        console.error("[ScreenshotManager] Screenshot failed: PixelMap is null");
        return null;
      }
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error("[ScreenshotManager] Failed to capture screenshot:", errorMsg);
      return null;
    }
  }

  /**
   * 保存截图到相册
   * @param pixmap PixelMap对象
   * @param fileName 文件名
   * @param context UIAbilityContext
   * @param releasePixmap 是否在保存后释放PixelMap（默认true）
   * @returns 是否保存成功
   */
  async saveToGallery(
    pixmap: image.PixelMap,
    fileName: string,
    context: common.UIAbilityContext,
    releasePixmap: boolean = true
  ): Promise<boolean> {
    let fileDescriptor: number | null = null;

    try {
      // 创建图像打包器并打包为 ArrayBuffer
      const imagePacker = image.createImagePacker();
      const imageData: ArrayBuffer = await imagePacker.packToData(pixmap, {
        format: "image/png",
        quality: 100,
      });

      // 使用 photoAccessHelper 保存到相册
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

      // 创建照片资源
      const createOption: photoAccessHelper.CreateOptions = {
        title: fileName,
      };

      const photoAssetUri = await phAccessHelper.createAsset(
        photoAccessHelper.PhotoType.IMAGE,
        "png",
        createOption
      );

      // 写入图片数据
      const file = await fs.open(photoAssetUri, fs.OpenMode.READ_WRITE);
      fileDescriptor = file.fd;

      try {
        await fs.write(file.fd, imageData);
      } finally {
        // 确保文件描述符总是被关闭
        if (fileDescriptor !== null) {
          await fs.close(fileDescriptor);
          fileDescriptor = null;
        }
      }

      console.info(`[ScreenshotManager] Screenshot saved to gallery: ${fileName}`);
      return true;
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error("[ScreenshotManager] Failed to save screenshot:", errorMsg);

      // 尝试关闭可能未关闭的文件描述符
      if (fileDescriptor !== null) {
        try {
          await fs.close(fileDescriptor);
        } catch (closeError) {
          console.error("[ScreenshotManager] Failed to close file descriptor:", closeError);
        }
      }

      return false;
    } finally {
      // 释放 PixelMap 原生内存
      if (releasePixmap) {
        try {
          pixmap.release();
          console.info("[ScreenshotManager] PixelMap released");
        } catch (releaseError) {
          console.warn("[ScreenshotManager] Failed to release PixelMap:", releaseError);
        }
      }
    }
  }

  /**
   * 生成默认文件名
   * @param prefix 文件名前缀
   * @param extraInfo 额外信息
   * @returns 文件名
   */
  generateFileName(prefix: string, extraInfo?: string): string {
    const timestamp = new Date()
      .toISOString()
      .replace(/[:.]/g, "-")
      .slice(0, -5);
    if (extraInfo) {
      return `${prefix}_${extraInfo}_${timestamp}`;
    }
    return `${prefix}_${timestamp}`;
  }
}

/**
 * 截图管理器单例
 */
export const screenshotManager = new ScreenshotManager();

