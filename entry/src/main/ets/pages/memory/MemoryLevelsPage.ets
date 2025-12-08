import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { MemoryLevel, getAllMemoryLevels } from './MemoryLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

@Entry
@Component
struct MemoryLevelsPage {
  @State levels: MemoryLevel[] = [];
  @State unlockedLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    this.levels = getAllMemoryLevels();
    // 初始化进度管理器并读取解锁进度
    await GameProgressManager.init(this.context);
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.MEMORY);
  }

  onPageShow() {
    // 页面重新显示时刷新解锁进度
    this.refreshUnlockedLevel();
  }

  private async refreshUnlockedLevel(): Promise<void> {
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.MEMORY);
  }

  private isLevelUnlocked(levelId: number): boolean {
    return levelId <= this.unlockedLevel;
  }

  build() {
    Navigation() {
      List() {
        ForEach(this.levels, (level: MemoryLevel) => {
          ListItem() {
            Row() {
              // 关卡图标
              Column() {
                Text(`${level.id}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_white') : $r('app.color.text_tertiary'))
              }
              .width(48)
              .height(48)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(this.isLevelUnlocked(level.id) ? $r('app.color.button_primary') : $r('app.color.bg_tertiary'))
              .borderRadius(24)

              // 关卡信息
              Column() {
                Text(`第 ${level.id} 关 · ${level.name}`)
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
          }
          .margin({ left: 16, right: 16, bottom: 12 })
          .onClick(() => {
            if (this.isLevelUnlocked(level.id)) {
              router.pushUrl({
                url: 'pages/memory/MemoryPlayPage',
                params: { levelId: level.id }
              });
            }
          })
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 12 })
      .backgroundColor($r('app.color.bg_page'))
    }
    .title('记忆翻牌')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}

