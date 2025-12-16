import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { CommonConstants, Logger, SettingModel, TabModel, WindowModel } from 'lib_common';
import { ThemeController } from 'module_theme';
import { TabBarItem, TabBarType, TABS_INFO } from '../common/Constants';

@ComponentV2
export struct CustomTabBar {
  @Param fontSizeRatio: number = 0;
  @Consumer() selectedIndex: number = TabBarType.HOME;
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  tabModel: TabModel = AppStorageV2.connect(TabModel, () => new TabModel())!;
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;

  getTabColor(id: number): ResourceColor {
    if (this.selectedIndex === id) {
      return ThemeController.theme.themeColor;
    }
    Logger.info('this.settingInfo.themeColor' + ThemeController.theme.fontSecondary)

    return ThemeController.theme.fontSecondary
  }

  getBgColor(): ResourceColor {
    return $r('sys.color.background_primary');
  }

  build() {
    Row() {
      ForEach(TABS_INFO, (item: TabBarItem) => {
        Column({ space: CommonConstants.SPACE_XS }) {
          Image(item.activeIcon)
            .width($r('app.float.normal_img_size'))
            .draggable(false)
            .fillColor(this.getTabColor(item.id))
            .objectFit(ImageFit.Contain)
          Text(item.title)
            .fontSize(10 * this.fontSizeRatio)
            .fontColor(this.getTabColor(item.id))
        }
        .layoutWeight(1)
        .padding({ top: CommonConstants.PADDING_XS, bottom: CommonConstants.PADDING_XS })
        .onClick(() => {
          this.selectedIndex = item.id;
        })
      }, (v: TabBarItem) => v.id.toString())
    }
    .backgroundColor(Color.Transparent)
    .width(CommonConstants.FULL_PERCENT)
    .padding({ bottom: this.windowModel.windowBottomPadding })
  }
}