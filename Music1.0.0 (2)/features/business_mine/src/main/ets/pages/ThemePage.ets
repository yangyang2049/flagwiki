import { PersistenceV2 } from '@kit.ArkUI';
import { RouterUtils, SettingModel } from 'lib_common';
import { ThemeController, ThemesCard } from 'module_theme';

@Builder
export function ThemePageBuilder() {
  ThemePage()
}

@ComponentV2
struct ThemePage {
  stack: NavPathStack = RouterUtils.getStack();
  @Local fullScreen: boolean = false;
  settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;

  async aboutToDisappear(): Promise<void> {
    this.settingInfo.themePic = ThemeController.theme.themePic
  }

  build() {
    NavDestination() {
      Column() {
        ThemesCard({ stack: this.stack })
      }
      .backgroundImage(ThemeController.themePic)
      .backgroundImageSize(ImageSize.Cover)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}