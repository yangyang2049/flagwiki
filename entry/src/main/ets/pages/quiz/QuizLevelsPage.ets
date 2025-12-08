import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { QuizLevel, getAllQuizLevels } from './QuizLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

interface RouterParams {
  quizType: string;
}

@Entry
@Component
struct QuizLevelsPage {
  @State quizType: string = 'flagToName';
  @State levels: QuizLevel[] = [];
  @State unlockedLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params && params.quizType) {
      this.quizType = params.quizType;
    }
    this.levels = getAllQuizLevels();
    await GameProgressManager.init(this.context);
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.QUIZ);
  }

  onPageShow() {
    this.refreshUnlockedLevel();
  }

  private async refreshUnlockedLevel(): Promise<void> {
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.QUIZ);
  }

  private getTitle(): string {
    return this.quizType === 'flagToName' ? '看旗猜国名' : '看名猜国旗';
  }

  private isLevelUnlocked(levelId: number): boolean {
    return levelId <= this.unlockedLevel;
  }

  private startQuiz(level: QuizLevel): void {
    if (!this.isLevelUnlocked(level.id)) {
      return;
    }

    router.pushUrl({
      url: 'pages/quiz/QuizPlayPage',
      params: {
        quizType: this.quizType,
        levelId: level.id
      }
    });
  }

  build() {
    Navigation() {
      List() {
        ForEach(this.levels, (level: QuizLevel) => {
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
                Text(`第 ${level.id} 关 · ${level.name}`)
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
              this.startQuiz(level);
            })
          }
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 8, bottom: 16 })
    }
    .title(this.getTitle())
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }
}

