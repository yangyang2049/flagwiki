import { HomePage } from './home/HomePage';
import { GalleryPage } from './gallery/GalleryPage';
import { AnthemPage } from './anthem/AnthemPage';
import { ExplorePage } from './explore/ExplorePage';
import { ProfilePage } from './profile/ProfilePage';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { PreferencesManager } from '../utils/PreferencesManager';
import router from '@ohos.router';
import { shouldAllowEdgeSwipeExit } from '../utils/WatchGestureHelper';
import {
  MODULE_ANTHEM,
  MODULE_FLAGHISTORY,
  MODULE_STATE_FLAGS,
  MODULE_COAT_OF_ARMS,
  refreshOptionalModuleAppStorage
} from '../utils/OptionalModuleHelper';

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
  @State exploreRefreshKey: number = 0;
  @State homeRefreshKey: number = 0;
  @State isGallerySearchExpanded: boolean = false;
  @State isAnthemSearchExpanded: boolean = false;
  @StorageLink('optionalModuleAnthemReady') anthemModuleReady: boolean = false;
  @StorageLink('optionalModuleInstallBusy') optionalModuleInstallBusy: boolean = false;
  @StorageLink('optionalModuleInstallBusyId') optionalModuleInstallBusyId: string = '';
  @State anthemPageRefreshKey: number = 0;
  private tabController: TabsController = new TabsController();
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

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
    return [home, anthem, gallery, explore, profile];
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
  }

  async onPageShow() {
    await refreshOptionalModuleAppStorage(this.context);

    if (this.currentTabIndex === 0) {
      this.homeRefreshKey++;
    } else if (this.currentSpecId() === 'explore') {
      this.exploreRefreshKey++;
    } else if (this.currentTabIndex === this.getTabSpecs().length - 1) {
      this.profileRefreshKey++;
    }
    if (this.getTabSpecs()[this.currentTabIndex]?.id === 'anthem') {
      this.anthemPageRefreshKey++;
    }
  }

  private switchTab(index: number): void {
    this.currentTabIndex = index;
    this.tabController.changeIndex(index);
  }

  private getOptionalDownloadBannerText(): string {
    const id = this.optionalModuleInstallBusyId;
    let title = '';
    if (id === MODULE_ANTHEM) {
      title = this.context.resourceManager.getStringSync($r('app.string.optional_module_anthem_title').id);
    } else if (id === MODULE_FLAGHISTORY) {
      title = this.context.resourceManager.getStringSync($r('app.string.optional_module_flaghistory_title').id);
    } else if (id === MODULE_STATE_FLAGS) {
      title = this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_title').id);
    } else if (id === MODULE_COAT_OF_ARMS) {
      title = this.context.resourceManager.getStringSync($r('app.string.optional_module_coat_of_arms_title').id);
    }
    return this.context.resourceManager.getStringSync($r('app.string.optional_module_downloading_banner').id, title);
  }

  @Builder
  TabBarForSpec(spec: MainTabSpec, index: number) {
    Column() {
      Stack() {
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
        isSearchExpanded: this.isAnthemSearchExpanded,
        refreshKey: this.anthemPageRefreshKey
      })
    } else if (spec.id === 'gallery') {
      GalleryPage({ isSearchExpanded: this.isGallerySearchExpanded, context: this.context })
    } else if (spec.id === 'explore') {
      ExplorePage({ refreshKey: this.exploreRefreshKey })
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

        if (this.optionalModuleInstallBusy) {
          Row({ space: 10 }) {
            LoadingProgress()
              .width(22)
              .height(22)
              .color($r('app.color.button_primary'))
            Text(this.getOptionalDownloadBannerText())
              .fontSize(13)
              .fontColor($r('app.color.text_primary'))
              .layoutWeight(1)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 10,
            bottom: 10
          })
          .backgroundColor($r('app.color.bg_blue_light'))
        }

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
          if (sid === 'anthem') {
            this.anthemPageRefreshKey++;
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
