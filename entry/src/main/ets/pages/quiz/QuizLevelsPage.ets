import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { QuizLevel, getAllQuizLevels } from './QuizLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

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

  private getTitle(): Resource {
    return this.quizType === 'flagToName' ? $r('app.string.quiz_flag_to_name') : $r('app.string.quiz_name_to_flag');
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
      Row() {
        Column() {
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
                  this.startQuiz(level);
                })
              }
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            })
          }
          .width('100%')
          .height('100%')
          .padding({ top: 8, bottom: 16 })
          .scrollBar(BarState.Off)
          .constraintSize({ maxWidth: getContentMaxWidth() })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title(this.getTitle())
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
  }
}

