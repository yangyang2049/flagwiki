/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { window } from '@kit.ArkUI';

export class WindowUtils {
  public static initWindow(windowStage: window.WindowStage) {
    let windowClass: window.Window = windowStage.getMainWindowSync();
    windowClass.setWindowLayoutFullScreen(true);
    let statusBarArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    let statusBarHeight = px2vp(statusBarArea.topRect.height);
    AppStorage.setOrCreate('statusBarHeight', statusBarHeight);

    let naviBarArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    let naviIndicatorHeight = px2vp(naviBarArea.bottomRect.height);
    AppStorage.setOrCreate('naviIndicatorHeight', naviIndicatorHeight);

    let size = windowClass.getWindowProperties().windowRect;
    AppStorage.setOrCreate('windowHeight', px2vp(size.height));
    AppStorage.setOrCreate('windowWidth', px2vp(size.width));

    windowClass.on('windowSizeChange', data => {
      AppStorage.setOrCreate('windowHeight', px2vp(data.height));
      AppStorage.setOrCreate('windowWidth', px2vp(data.width));
    });

    windowClass.on('avoidAreaChange', (data) => {
      if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
        let statusBarHeight = px2vp(data.area.topRect.height);
        AppStorage.setOrCreate('statusBarHeight', statusBarHeight);
      } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        let naviIndicatorHeight = px2vp(data.area.bottomRect.height);
        AppStorage.setOrCreate('naviIndicatorHeight', naviIndicatorHeight);
      }
    });
  }

  public setStatusbarContentColor(color: string) {
    let windowStage: window.WindowStage = AppStorage.get('windowStage') as window.WindowStage;
    let mainWindow = windowStage.getMainWindowSync();
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: color
    };
    mainWindow.setWindowSystemBarProperties(systemBarProperties);
  }
}
