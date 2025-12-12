import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { ConnectionsLevel, ConnectionsLevels, getTotalConnectionsLevels } from './ConnectionsLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

@Entry
@Component
struct ConnectionsLevelsPage {
  @State levels: ConnectionsLevel[] = [];
  @State unlockedLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    this.levels = ConnectionsLevels;
    // 初始化进度管理器并读取解锁进度
    await GameProgressManager.init(this.context);
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.CONNECTIONS);
  }

  onPageShow() {
    // 页面重新显示时刷新解锁进度
    this.refreshUnlockedLevel();
  }

  private async refreshUnlockedLevel(): Promise<void> {
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.CONNECTIONS);
  }

  private isLevelUnlocked(levelId: number): boolean {
    return levelId <= this.unlockedLevel;
  }

  private startLevel(level: ConnectionsLevel): void {
    if (!this.isLevelUnlocked(level.id)) {
      return;
    }

    router.pushUrl({
      url: 'pages/connections/ConnectionsPlayPage',
      params: { levelId: level.id }
    });
  }

  build() {
    Navigation() {
      List() {
        ForEach(this.levels, (level: ConnectionsLevel) => {
          ListItem() {
            Row() {
              // 关卡序号
              Column() {
                Text(`${level.id}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.white') : $r('app.color.text_tertiary'))
              }
              .width(48)
              .height(48)
              .borderRadius(24)
              .backgroundColor(this.isLevelUnlocked(level.id) ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
              .justifyContent(FlexAlign.Center)

              // 关卡信息
              Column() {
                Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, level.id.toString()))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_primary') : $r('app.color.text_tertiary'))
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 16 })
              .layoutWeight(1)

              // 箭头图标（仅已解锁关卡显示）
              if (this.isLevelUnlocked(level.id)) {
                Image($r('app.media.icon_arrow_right'))
                  .width(20)
                  .height(20)
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(12)
            .onClick(() => {
              this.startLevel(level);
            })
          }
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 8, bottom: 16 })
      .scrollBar(BarState.Off)
    }
    .title($r('app.string.game_connections'))
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}
