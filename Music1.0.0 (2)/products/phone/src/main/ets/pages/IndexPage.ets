import { CommonConstants } from 'lib_common';
import { HomePageBuilder } from 'business_home';
import { MinePageBuilder } from 'business_mine';
import { CustomTabBar } from '../components/CustomTabBar';
import { IndexPageViewModel } from '../viewmodels/IndexPageVM';
import { MusicPlayController } from 'module_musicplay';
import { ThemeController } from 'module_theme';

/**
 * index页面
 */
@Builder
export function IndexPageBuilder() {
  IndexPage()
}

@ComponentV2
struct IndexPage {
  @Local vm: IndexPageViewModel = new IndexPageViewModel();
  @Provider() selectedIndex: number = 0;

  aboutToAppear(): void {
    this.vm.refreshUserInfo();
    this.vm.getFirstLoginTime();
    this.vm.onChangeUserVip();
  }

  @Monitor('selectedIndex')
  onChangeTabIndex() {
    this.vm.tabModel.selectedIndex = this.selectedIndex;
  }

  build() {
    NavDestination() {
      Column() {
        Tabs({ index: $$this.selectedIndex }) {
          TabContent() {
            HomePageBuilder()
          }
          .backgroundColor(Color.Transparent)

          TabContent() {
            MinePageBuilder()
          }
        }
        .width(CommonConstants.FULL_PERCENT)
        .layoutWeight(1)
        .barHeight(0)
        .scrollable(false)
        .barBackgroundColor(Color.Transparent)
        .onChange((index) => {
          this.selectedIndex = index;
        })

        MusicPlayController({
          themeColor: ThemeController.theme.themeColor,
          playBarBgColor: ThemeController.theme.themeColors[1],
          isDefaultTheme: ThemeController.theme.isDefaultTheme,
          titleFontColor: ThemeController.theme.themeColors[2],
          singerFontColor: ThemeController.theme.themeColors[4],
          onPlayerViewClose: () => {
            setTimeout(() => {
              this.vm.setStatusbarContentColor(ThemeController.theme.themeColors[2])
            }, 300)

          },
        })

        CustomTabBar({
          fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
        })
          .translate({ x: 0, y: this.vm.translateY })
          .animation({ duration: 200, curve: Curve.EaseInOut })
          .onAreaChange((ov: Area, nv: Area) => {
            this.vm.tabPaddingBottom = nv.height;
            this.vm.tabModel.tabHeight = nv.height
          })
      }
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .backgroundColor('#F1F3F5')
    .backgroundImage(!ThemeController.theme.isDefaultTheme ? ThemeController.themePic : '')
    .backgroundImageSize(ImageSize.Cover)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.vm.onReady(context);
    })
    .onBackPressed(() => {
      return this.vm.onBackPressed();
    })
    .onHidden(() => {
      this.vm.setStatusbarContentColor('#ff090909')
    })
    .onWillShow(() => {
      this.vm.setStatusbarContentColor(ThemeController.theme.themeColors[2])
    })
  }
}
