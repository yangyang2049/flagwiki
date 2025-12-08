import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { FavoritesManager, FavoriteItem } from '../../utils/favoritesManager';
import { KnowledgeData } from '../../utils/knowledgeData';

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

    if (type === 'knowledge') {
      // 知识库类型，根据标题查找内容
      const knowledgeItem = KnowledgeData.getKnowledgeByTitle(identifier);
      if (knowledgeItem) {
        router.pushUrl({
          url: 'pages/knowledge/KnowledgeDetailPage',
          params: {
            title: knowledgeItem.title,
            category: knowledgeItem.category,
            content: knowledgeItem.content
          }
        }, router.RouterMode.Standard).catch((err: Error) => {
          console.error(`Failed to push url. Code: ${err.message}`);
          promptAction.showToast({
            message: '导航失败',
            duration: 2000
          });
        });
      } else {
        promptAction.showToast({
          message: '未找到相关内容',
          duration: 2000
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
                Image($r('app.media.icon_favorite_selected'))
                  .width(20)
                  .height(20)
                  .margin({ right: 12 })
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

