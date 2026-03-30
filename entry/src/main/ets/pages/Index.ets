import { HomePage } from './home/HomePage';
import { GalleryPage } from './gallery/GalleryPage';
import { AnthemPage } from './anthem/AnthemPage';
import { PaintHomePage } from './paintgame/PaintHomePage';
import { ExplorePage } from './explore/ExplorePage';
import { ProfilePage } from './profile/ProfilePage';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { PreferencesManager } from '../utils/PreferencesManager';
import router from '@ohos.router';
import { shouldAllowEdgeSwipeExit } from '../utils/WatchGestureHelper';
import { refreshOptionalModuleAppStorage, STORAGE_KEY_ANTHEM_READY } from '../utils/OptionalModuleHelper';
import promptAction from '@ohos.promptAction';

interface MainTabSpec {
  id: string;
  title: Resource;
  iconNormal: Resource;
  iconSelected: Resource;
}

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;
  @State profileRefreshKey: number = 0;
  @State homeRefreshKey: number = 0;
  @State isGallerySearchExpanded: boolean = false;
  @State isAnthemSearchExpanded: boolean = false;
  @StorageLink('optionalModuleAnthemReady') anthemModuleReady: boolean = false;
  private tabController: TabsController = new TabsController();
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private prevAnthemReady: boolean = false;

  private getTabSpecs(): MainTabSpec[] {
    const home: MainTabSpec = {
      id: 'home',
      title: $r('app.string.tab_home'),
      iconNormal: $r('app.media.icon_tab_home'),
      iconSelected: $r('app.media.icon_tab_home_selected')
    };
    const anthem: MainTabSpec = {
      id: 'anthem',
      title: $r('app.string.tab_anthem'),
      iconNormal: $r('app.media.icon_tab_anthem'),
      iconSelected: $r('app.media.icon_tab_anthem_selected')
    };
    const gallery: MainTabSpec = {
      id: 'gallery',
      title: $r('app.string.tab_gallery'),
      iconNormal: $r('app.media.icon_tab_gallery'),
      iconSelected: $r('app.media.icon_tab_gallery_selected')
    };
    const paint: MainTabSpec = {
      id: 'paint',
      title: $r('app.string.tab_paint'),
      iconNormal: $r('app.media.icon_tab_paint'),
      iconSelected: $r('app.media.icon_tab_paint_selected')
    };
    const explore: MainTabSpec = {
      id: 'explore',
      title: $r('app.string.tab_explore'),
      iconNormal: $r('app.media.icon_tab_explore'),
      iconSelected: $r('app.media.icon_tab_explore_selected')
    };
    const profile: MainTabSpec = {
      id: 'profile',
      title: $r('app.string.tab_profile'),
      iconNormal: $r('app.media.icon_tab_profile'),
      iconSelected: $r('app.media.icon_tab_profile_selected')
    };
    return [home, anthem, gallery, paint, explore, profile];
  }

  private getTitleText(): Resource {
    const specs = this.getTabSpecs();
    if (this.currentTabIndex >= 0 && this.currentTabIndex < specs.length) {
      return specs[this.currentTabIndex].title;
    }
    return $r('app.string.app_welcome_title');
  }

  private currentSpecId(): string {
    const specs = this.getTabSpecs();
    if (this.currentTabIndex < 0 || this.currentTabIndex >= specs.length) {
      return '';
    }
    return specs[this.currentTabIndex].id;
  }

  async aboutToAppear() {
    try {
      this.prefs = await PreferencesManager.getPreferences('app_settings');
    } catch (err) {
      console.error(`Failed to load preferences: ${JSON.stringify(err)}`);
    }
    await refreshOptionalModuleAppStorage(this.context);
    this.prevAnthemReady = AppStorage.get<boolean>(STORAGE_KEY_ANTHEM_READY) ?? false;
  }

  async onPageShow() {
    const beforeAnthem = this.prevAnthemReady;
    await refreshOptionalModuleAppStorage(this.context);
    const afterAnthem = AppStorage.get<boolean>(STORAGE_KEY_ANTHEM_READY) ?? false;
    if (!beforeAnthem && afterAnthem) {
      try {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.optional_module_toast_anthem_ready').id),
          duration: 2000
        });
      } catch (_e) {
        void 0;
      }
    }
    this.prevAnthemReady = afterAnthem;

    if (this.currentTabIndex === 0) {
      this.homeRefreshKey++;
    } else if (this.currentTabIndex === this.getTabSpecs().length - 1) {
      this.profileRefreshKey++;
    }
  }

  private switchTab(index: number): void {
    this.currentTabIndex = index;
    this.tabController.changeIndex(index);
  }

  @Builder
  TabBarForSpec(spec: MainTabSpec, index: number) {
    Column() {
      Stack() {
        if (this.currentTabIndex === index) {
          Circle()
            .width(40)
            .height(40)
            .fill($r('app.color.bg_blue_light'))
            .opacity(0.3)
        }
        Image(this.currentTabIndex === index ? spec.iconSelected : spec.iconNormal)
          .width(24)
          .height(24)
      }
      .width(40)
      .height(40)

      Text(spec.title)
        .fontSize(11)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.currentTabIndex === index ? $r('app.color.button_primary') : $r('app.color.text_tertiary'))
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.switchTab(index);
    })
  }

  @Builder
  TabBodyForSpec(spec: MainTabSpec) {
    if (spec.id === 'home') {
      Column() {
        HomePage({
          refreshKey: this.homeRefreshKey,
          galleryTabIndex: 2,
          onTabChange: (index: number) => {
            this.switchTab(index);
          }
        })
      }
      .padding({ left: 4, right: 4 })
      .width('100%')
      .height('100%')
    } else if (spec.id === 'anthem') {
      AnthemPage({
        context: this.context,
        isSearchExpanded: this.isAnthemSearchExpanded
      })
    } else if (spec.id === 'gallery') {
      GalleryPage({ isSearchExpanded: this.isGallerySearchExpanded, context: this.context })
    } else if (spec.id === 'paint') {
      PaintHomePage()
    } else if (spec.id === 'explore') {
      ExplorePage()
    } else if (spec.id === 'profile') {
      ProfilePage({
        refreshKey: this.profileRefreshKey
      })
    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text(this.getTitleText())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)

          if (this.currentSpecId() === 'gallery') {
            Image(this.isGallerySearchExpanded ? $r('app.media.icon_close') : $r('app.media.icon_search'))
              .width(22)
              .height(22)
              .onClick(() => {
                this.isGallerySearchExpanded = !this.isGallerySearchExpanded;
              })
          }

          if (this.currentSpecId() === 'anthem' && this.anthemModuleReady) {
            Image(this.isAnthemSearchExpanded ? $r('app.media.icon_close') : $r('app.media.icon_search'))
              .width(22)
              .height(22)
              .onClick(() => {
                this.isAnthemSearchExpanded = !this.isAnthemSearchExpanded;
              })
          }
        }
        .width('100%')
        .height(56)
        .padding({ left: 20, right: 20 })
        .backgroundColor($r('app.color.bg_title_bar'))
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
          ForEach(this.getTabSpecs(), (spec: MainTabSpec, index: number) => {
            TabContent() {
              this.TabBodyForSpec(spec)
            }
            .tabBar(this.TabBarForSpec(spec, index))
          }, (spec: MainTabSpec) => `${spec.id}_${this.anthemModuleReady ? 'a1' : 'a0'}`)
        }
        .width('100%')
        .layoutWeight(1)
        .barHeight(64)
        .barBackgroundColor($r('app.color.bg_tab_bar'))
        .animationDuration(300)
        .onChange((index: number) => {
          this.currentTabIndex = index;
          const sid = this.getTabSpecs()[index]?.id ?? '';
          if (sid !== 'gallery') {
            this.isGallerySearchExpanded = false;
          }
          if (sid !== 'anthem') {
            this.isAnthemSearchExpanded = false;
          }
          if (index === 0) {
            this.homeRefreshKey++;
          }
          if (index === this.getTabSpecs().length - 1) {
            this.profileRefreshKey++;
          }
        })
        .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
          others: Array<GestureRecognizer>): GestureJudgeResult => {
          if (this.currentTabIndex === 0 && shouldAllowEdgeSwipeExit(event, current)) {
            console.info('[Index] Right swipe from left edge on home page, allow exit');
            try {
              router.back();
            } catch (err) {
              console.info('[Index] Cannot go back from root page');
            }
            return GestureJudgeResult.REJECT;
          }
          return GestureJudgeResult.CONTINUE;
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
  }
}
