import { AppStorageV2 } from '@ohos.arkui.StateManagement';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonUtil } from './CommonUtil';


const TAG = 'WindowUtil';

@ObservedV2
export class AvoidAreaSize {
  @Trace top: number = 0;
  @Trace bottom: number = 0;
}

export class WindowUtil {
  private static _init: boolean = false;
  private static _currentWindow: window.Window | null = null;
  private static _avoidAreaSize: AvoidAreaSize = AppStorageV2.connect(AvoidAreaSize, () => new AvoidAreaSize())!;

  public static async initWindowUtil() {
    if (WindowUtil._init) {
      return;
    }
    await WindowUtil._getCurrentWindow();
    WindowUtil.addWindowAvoidAreaListener();
    WindowUtil._init = true;
  }

  public static addWindowAvoidAreaListener() {
    if (WindowUtil._currentWindow) {
      const systemArea = WindowUtil._currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      WindowUtil._avoidAreaSize.top = px2vp(systemArea.topRect.height);
      const bottomArea = WindowUtil._currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil._avoidAreaSize.bottom = px2vp(bottomArea.bottomRect.height);
    }
  }

  public static getAvoidArea() {
    return WindowUtil._avoidAreaSize;
  }

  private static async _getCurrentWindow() {
    await window
      .getLastWindow(getContext())
      .then((win) => {
        WindowUtil._currentWindow = win;
      })
      .catch((error: BusinessError) => {
        WindowUtil._dealAllError(error);
      });
  }

  private static _dealAllError(error: BusinessError): void {
    CommonUtil.error(TAG, `Failed to use WindowUtil, errorCode: ${error.code}, errorMsg: ${error.message}`);
  }
}
