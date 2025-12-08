import { HomePage } from './home/HomePage';
import { GalleryPage } from './gallery/GalleryPage';
import { PaintHomePage } from './paintgame/PaintHomePage';
import { ExplorePage } from './explore/ExplorePage';
import { ProfilePage } from './profile/ProfilePage';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import { PreferencesManager } from '../utils/PreferencesManager';

interface TabItem {
  title: string;
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
  private tabController: TabsController = new TabsController();
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  private tabItems: TabItem[] = [
    { title: '首页', iconNormal: $r('app.media.icon_tab_home'), iconSelected: $r('app.media.icon_tab_home_selected') },
    { title: '画廊', iconNormal: $r('app.media.icon_tab_gallery'), iconSelected: $r('app.media.icon_tab_gallery_selected') },
    { title: '涂鸦', iconNormal: $r('app.media.icon_tab_paint'), iconSelected: $r('app.media.icon_tab_paint_selected') },
    { title: '探索', iconNormal: $r('app.media.icon_tab_explore'), iconSelected: $r('app.media.icon_tab_explore_selected') },
    { title: '我的', iconNormal: $r('app.media.icon_tab_profile'), iconSelected: $r('app.media.icon_tab_profile_selected') }
  ];

  private getTitleText(): string {
    const titles: string[] = ['国旗小百科', '画廊', '涂鸦', '探索', '我的'];
    if (this.currentTabIndex >= 0 && this.currentTabIndex < titles.length) {
      return titles[this.currentTabIndex];
    }
    return '国旗小百科';
  }

  async aboutToAppear() {
    try {
      this.prefs = await PreferencesManager.getPreferences('app_settings');
    } catch (err) {
      console.error(`Failed to load preferences: ${JSON.stringify(err)}`);
    }
  }

  onPageShow() {
    if (this.currentTabIndex === 0) {
      this.homeRefreshKey++;
    } else if (this.currentTabIndex === 4) {
      this.profileRefreshKey++;
    }
  }

  private switchTab(index: number): void {
    this.currentTabIndex = index;
    this.tabController.changeIndex(index);
  }

  @Builder
  TabItemBuilder(index: number) {
    Column() {
      Stack() {
        if (this.currentTabIndex === index) {
          Circle()
            .width(40)
            .height(40)
            .fill($r('app.color.bg_blue_light'))
            .opacity(0.3)
        }
        Image(this.currentTabIndex === index ? this.tabItems[index].iconSelected : this.tabItems[index].iconNormal)
          .width(24)
          .height(24)
      }
      .width(40)
      .height(40)

      Text(this.tabItems[index].title)
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

  build() {
    Stack() {
      Column() {
        // 顶部标题栏
        Row() {
          Text(this.getTitleText())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)

          // 画廊页面显示搜索按钮
          if (this.currentTabIndex === 1) {
            Image(this.isGallerySearchExpanded ? $r('app.media.icon_close') : $r('app.media.icon_search'))
              .width(22)
              .height(22)
              .onClick(() => {
                this.isGallerySearchExpanded = !this.isGallerySearchExpanded;
              })
          }
        }
        .width('100%')
        .height(56)
        .padding({ left: 20, right: 20 })
        .backgroundColor($r('app.color.bg_title_bar'))
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .shadow({
          radius: 4,
          color: 'rgba(0, 0, 0, 0.06)',
          offsetX: 0,
          offsetY: 2
        })

        // 主内容区域 - Tabs
        Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
          TabContent() {
            HomePage({
              refreshKey: this.homeRefreshKey,
              onTabChange: (index: number) => {
                this.switchTab(index);
              }
            })
          }
          .padding({ left: 4, right: 4 })
          .tabBar(this.TabItemBuilder(0))

          TabContent() {
            GalleryPage({ isSearchExpanded: this.isGallerySearchExpanded })
          }
          .tabBar(this.TabItemBuilder(1))

          TabContent() {
            PaintHomePage()
          }
          .tabBar(this.TabItemBuilder(2))

          TabContent() {
            ExplorePage()
          }
          .tabBar(this.TabItemBuilder(3))

          TabContent() {
            ProfilePage({
              refreshKey: this.profileRefreshKey
            })
          }
          .tabBar(this.TabItemBuilder(4))
        }
        .width('100%')
        .layoutWeight(1)
        .barHeight(64)
        .barBackgroundColor($r('app.color.bg_tab_bar'))
        .animationDuration(300)
        .onChange((index: number) => {
          this.currentTabIndex = index;
          // 切换tab时收起搜索框
          if (index !== 1) {
            this.isGallerySearchExpanded = false;
          }
          if (index === 0) {
            this.homeRefreshKey++;
          }
          if (index === 4) {
            this.profileRefreshKey++;
          }
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
