import { window } from '@kit.ArkUI';
import { GlobalContext } from './GlobalContext';
import { Logger } from './Logger';

class ScreenUtil {
  setScreenSize(): void {
    window.getLastWindow(getContext(this))
      .then((windowClass: window.Window) => {
        let screenWidth = px2fp(windowClass.getWindowProperties().windowRect.width);
        let screenHeight = px2fp(windowClass.getWindowProperties().windowRect.height);
        GlobalContext.getContext().setObject('screenWidth', screenWidth);
        GlobalContext.getContext().setObject('screenHeight', screenHeight);
        GlobalContext.getContext().setObject('windowClass', windowClass);
      })
      .catch((error: Error) => {
        Logger.error('[ScreenUtil] Failed to obtain the window size. Cause: ' + JSON.stringify(error));
      })
  }
}

export default new ScreenUtil();