import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { FavoritesManager, FavoriteItem } from '../../utils/favoritesManager';
import { getFlagImageSource } from '../../utils/countryData';
import { getStateFlagPath } from '../../utils/StateFlagData';

@Entry
@Component
export struct FavoritesPage {
  @State favorites: FavoriteItem[] = [];
  @State isEditMode: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    await FavoritesManager.init(this.context);
    await this.loadFavorites();
  }

  async onPageShow() {
    await this.loadFavorites();
  }

  private async loadFavorites() {
    this.favorites = await FavoritesManager.getFavorites();
  }

  private async deleteFavorite(item: FavoriteItem) {
    await FavoritesManager.removeFavorite(item.pageUrl);
    await this.loadFavorites();
    try {
      promptAction.showToast({
        message: '已取消收藏',
        duration: 2000
      });
    } catch (err) {
      console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private getStateFlagImagePath(pageUrl: string): string {
    // 格式: stateflag:countryCode:stateCode
    const parts = pageUrl.substring(10).split(':');
    if (parts.length >= 2) {
      return getStateFlagPath(parts[0], parts[1]);
    }
    return '';
  }

  private isValidStateFlagUrl(pageUrl: string): boolean {
    const parts = pageUrl.substring(10).split(':');
    return parts.length >= 2;
  }

  private navigateToTool(pageUrl: string) {
    // 解析 pageUrl，格式为 "type:identifier"
    const parts = pageUrl.split(':');
    if (parts.length < 2) {
      // 如果不是标准格式，尝试直接导航
      router.pushUrl({
        url: pageUrl
      }, router.RouterMode.Standard).catch((err: Error) => {
        console.error(`Failed to push url. Code: ${err.message}`);
        promptAction.showToast({
          message: '导航失败',
          duration: 2000
        });
      });
      return;
    }

    const type = parts[0];
    const identifier = parts.slice(1).join(':'); // 处理标题中可能包含冒号的情况

    if (type === 'flag') {
      // 国旗类型，导航到国旗详情页
      router.pushUrl({
        url: 'pages/gallery/FlagDetailPage',
        params: {
          countryCode: identifier
        }
      }, router.RouterMode.Standard).catch((err: Error) => {
        console.error(`Failed to push url. Code: ${err.message}`);
        promptAction.showToast({
          message: '导航失败',
          duration: 2000
        });
      });
    } else if (type === 'stateflag') {
      // 州旗类型，格式为 stateflag:countryCode:stateCode
      const stateParts = identifier.split(':');
      if (stateParts.length >= 2) {
        router.pushUrl({
          url: 'pages/stateflag/StateFlagDetailPage',
          params: {
            countryCode: stateParts[0],
            stateCode: stateParts[1]
          }
        }, router.RouterMode.Standard).catch((err: Error) => {
          console.error(`Failed to push url. Code: ${err.message}`);
          promptAction.showToast({
            message: '导航失败',
            duration: 2000
          });
        });
      }
    } else {
      // 其他类型，直接导航到 pageUrl
      router.pushUrl({
        url: pageUrl
      }, router.RouterMode.Standard).catch((err: Error) => {
        console.error(`Failed to push url. Code: ${err.message}`);
        promptAction.showToast({
          message: '导航失败',
          duration: 2000
        });
      });
    }
  }

  @Builder
  MenuBuilder() {
    Row() {
      if (this.isEditMode) {
        Image($r('app.media.icon_done'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.isEditMode = false;
          })
      } else {
        Image($r('app.media.icon_edit'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.isEditMode = true;
          })
      }
    }
    .height('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Center)
    .padding({ right: 16 })
  }

  build() {
    Navigation() {
      if (this.favorites.length === 0) {
        Column() {
          Text('暂无收藏')
            .fontSize(16)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 100 })
        }
        .width('100%')
      } else {
        List() {
          ForEach(this.favorites, (item: FavoriteItem, index: number) => {
            ListItem() {
              Row() {
                if (item.pageUrl.startsWith('flag:')) {
                  // 国旗类型，显示国旗图片
                  Image(getFlagImageSource(item.pageUrl.substring(5)))
                    .width(32)
                    .height(22)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 12 })
                    .borderRadius(2)
                } else if (item.pageUrl.startsWith('stateflag:') && this.isValidStateFlagUrl(item.pageUrl)) {
                  // 州旗类型，显示州旗图片
                  Image($rawfile(this.getStateFlagImagePath(item.pageUrl)))
                    .width(32)
                    .height(22)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 12 })
                    .borderRadius(2)
                } else {
                  // 其他类型，显示收藏图标
                  Image($r('app.media.icon_favorite_selected'))
                    .width(20)
                    .height(20)
                    .margin({ right: 12 })
                }
                Text(item.name)
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))
                  .layoutWeight(1)
                if (this.isEditMode) {
                  Button() {
                    Text('删除')
                      .fontSize(14)
                      .fontColor($r('app.color.color_red'))
                  }
                  .type(ButtonType.Normal)
                  .backgroundColor(Color.Transparent)
                  .padding({ left: 12, right: 12 })
                  .onClick(() => {
                    this.deleteFavorite(item);
                  })
                }
              }
              .width('100%')
              .height(56)
              .padding({ left: 16, right: 16 })
              .backgroundColor($r('app.color.bg_card'))
              .onClick(() => {
                if (this.isEditMode) {
                  // 编辑模式下点击删除
                  this.deleteFavorite(item);
                } else {
                  // 正常模式下点击导航
                  this.navigateToTool(item.pageUrl);
                }
              })
            }
          }, (item: FavoriteItem, index: number) => `${item.pageUrl}_${index}`)
        }
        .width('100%')
        .divider({ strokeWidth: 0.5, color: $r('app.color.gray_border'), startMargin: 16, endMargin: 16 })
        .margin({ top: 16 })
      }
    }
    .title('我的收藏')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
    .menus(this.MenuBuilder)
  }

  onBackPress(): boolean {
    router.back();
    return true;
  }
}

