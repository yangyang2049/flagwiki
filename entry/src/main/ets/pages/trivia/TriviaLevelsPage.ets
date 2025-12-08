import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { getTotalTriviaLevels, getTriviaLevel, TriviaLevel } from './TriviaLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

interface LevelItem {
  id: number;
  name: string;
}

@Entry
@Component
struct TriviaLevelsPage {
  @State levels: LevelItem[] = [];
  @State unlockedLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    this.loadLevels();
    await GameProgressManager.init(this.context);
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.TRIVIA);
  }

  onPageShow() {
    this.refreshUnlockedLevel();
  }

  private async refreshUnlockedLevel(): Promise<void> {
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.TRIVIA);
  }

  private loadLevels(): void {
    const total = getTotalTriviaLevels();
    const levelList: LevelItem[] = [];
    for (let i = 1; i <= total; i++) {
      const level = getTriviaLevel(i);
      if (level) {
        levelList.push({ id: level.id, name: level.name });
      }
    }
    this.levels = levelList;
  }

  private isLevelUnlocked(levelId: number): boolean {
    return levelId <= this.unlockedLevel;
  }

  build() {
    Navigation() {
      List() {
        ForEach(this.levels, (level: LevelItem) => {
          ListItem() {
            Row() {
              // 关卡序号
              Column() {
                Text(`${level.id}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_white') : $r('app.color.text_tertiary'))
              }
              .width(48)
              .height(48)
              .borderRadius(24)
              .backgroundColor(this.isLevelUnlocked(level.id) ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
              .justifyContent(FlexAlign.Center)

              // 关卡信息
              Column() {
                Text(`${level.name}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_primary') : $r('app.color.text_tertiary'))
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 16 })
              .layoutWeight(1)

              // 锁定图标或箭头
              if (this.isLevelUnlocked(level.id)) {
                Image($r('app.media.icon_arrow_right'))
                  .width(20)
                  .height(20)
              } else {
                Text('🔒')
                  .fontSize(20)
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(12)
            .onClick(() => {
              if (this.isLevelUnlocked(level.id)) {
                this.goToLevel(level.id);
              }
            })
          }
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 8, bottom: 16 })
    }
    .title('知识问答')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }

  private goToLevel(levelId: number): void {
    router.pushUrl({
      url: 'pages/trivia/TriviaPlayPage',
      params: { levelId: levelId }
    }).catch((err: Error) => {
      console.error(`Navigation failed: ${err.message}`);
    });
  }
}

