import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';

export class CommonUtil {
  private static _domain: number = 0xff00;
  private static _prefix: string = 'Theme';
  private static _format: string = '%{public}s, %{public}s';

  public static info(...args: string[]): void {
    hilog.info(CommonUtil._domain, CommonUtil._prefix, CommonUtil._format, args);
  }

  public static error(...args: string[]): void {
    hilog.error(CommonUtil._domain, CommonUtil._prefix, CommonUtil._format, args);
  }

  public static getTimeIntervalIndex(): number {
    const now = new Date();
    const currentHours = now.getHours() + now.getMinutes() / 60 + now.getSeconds() / 3600;
    const intervalSize = 24 / 5;
    return Math.min(Math.floor(currentHours / intervalSize), 4);
  }

  public static getPixelmap(s: Resource) {
    const unit8Array = getContext().resourceManager.getMediaContentSync(s);
    const imageSource: image.ImageSource =
      image.createImageSource(unit8Array?.buffer.slice(0, unit8Array.buffer.byteLength));
    const info = imageSource.getImageInfoSync();

    let opts: image.DecodingOptions =
      { editable: false, desiredSize: info.size };
    return imageSource.createPixelMapSync(opts);
  }

  public static getLargestColor(pic: image.PixelMap, callback: (res: string) => void) {
    effectKit.createColorPicker(pic, (error, colorPicker) => {
      if (error) {
        CommonUtil.error('Failed to create color picker.Cause:' + JSON.stringify(error));
      } else {
        CommonUtil.info('Succeeded in creating color picker.');
        const color = colorPicker.getLargestProportionColor();
        const res = `rgba(${color.red},${color.green},${color.blue},${color.alpha / 255})`;
        callback(res);
      }
    });
  }
}