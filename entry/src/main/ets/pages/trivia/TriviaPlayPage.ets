import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { getCountryByCode } from '../../utils/countryData';
import { TriviaLevel, TriviaQuestion, getTriviaLevel } from './TriviaLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

interface RouterParams {
  levelId: number;
}

@Entry
@Component
struct TriviaPlayPage {
  @State level: TriviaLevel | undefined = undefined;
  @State currentIndex: number = 0;
  @State lives: number = 3;
  @State selectedOption: string = '';
  @State isAnswered: boolean = false;
  @State isCorrect: boolean = false;
  @State showResult: boolean = false;
  @State correctAnswers: number = 0;
  @State shuffledOptions: string[] = [];  // 打乱后的选项
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params) {
      const levelId = params.levelId || 1;
      this.level = getTriviaLevel(levelId);
      if (this.level) {
        this.lives = this.level.lives;
        this.initCurrentQuestionOptions();
      }
    }
  }

  private getCurrentQuestion(): TriviaQuestion | undefined {
    if (!this.level || this.currentIndex >= this.level.questions.length) {
      return undefined;
    }
    return this.level.questions[this.currentIndex];
  }

  // 打乱选项顺序
  private shuffleOptions(options: string[]): string[] {
    const shuffled = [...options];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  // 初始化当前题目的选项（打乱）
  private initCurrentQuestionOptions(): void {
    const question = this.getCurrentQuestion();
    if (question) {
      this.shuffledOptions = this.shuffleOptions(question.options);
    }
  }

  private selectOption(option: string): void {
    if (this.isAnswered) return;

    const question = this.getCurrentQuestion();
    if (!question) return;

    this.selectedOption = option;
    this.isAnswered = true;
    this.isCorrect = option === question.answer;

    if (this.isCorrect) {
      this.correctAnswers++;
      promptAction.showToast({
        message: '✓ 正确!',
        duration: 1000
      });
    } else {
      this.lives--;
      promptAction.showToast({
        message: '✗ 错误',
        duration: 1000
      });

      if (this.lives <= 0) {
        setTimeout(() => {
          this.showGameOver();
        }, 1500);
        return;
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    if (!this.level) return;

    if (this.currentIndex < this.level.questions.length - 1) {
      this.currentIndex++;
      this.selectedOption = '';
      this.isAnswered = false;
      this.isCorrect = false;
      this.initCurrentQuestionOptions();  // 为新题目打乱选项
    } else {
      // 完成所有题目，解锁下一关
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.TRIVIA, this.level.id);
      this.showResult = true;
    }
  }

  private showGameOver(): void {
    promptAction.showDialog({
      title: '挑战失败',
      message: `正确回答了 ${this.correctAnswers} 题`,
      buttons: [
        { text: '返回', color: '#666666' },
        { text: '重新开始', color: '#1677FF' }
      ]
    }).then((result) => {
      if (result.index === 0) {
        router.back();
      } else {
        this.restartGame();
      }
    });
  }

  private restartGame(): void {
    this.currentIndex = 0;
    this.selectedOption = '';
    this.isAnswered = false;
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.showResult = false;
    if (this.level) {
      this.lives = this.level.lives;
      this.initCurrentQuestionOptions();  // 重新打乱选项
    }
  }

  private getOptionText(option: string): string {
    const question = this.getCurrentQuestion();
    if (!question) return option;

    // 如果选项是国家代码，显示国家名称
    const country = getCountryByCode(option);
    if (country) {
      return country.nameCN;
    }
    return option;
  }

  private getOptionBackgroundColor(option: string): Resource {
    if (!this.isAnswered) {
      return $r('app.color.bg_card');
    }

    const question = this.getCurrentQuestion();
    if (!question) return $r('app.color.bg_card');

    if (option === question.answer) {
      return $r('app.color.bg_green_light');
    }
    if (option === this.selectedOption && !this.isCorrect) {
      return $r('app.color.bg_red_light');
    }
    return $r('app.color.bg_card');
  }

  private getOptionBorderColor(option: string): Resource {
    if (!this.isAnswered) {
      return $r('app.color.gray_border');
    }

    const question = this.getCurrentQuestion();
    if (!question) return $r('app.color.gray_border');

    if (option === question.answer) {
      return $r('app.color.color_green');
    }
    if (option === this.selectedOption && !this.isCorrect) {
      return $r('app.color.color_red');
    }
    return $r('app.color.gray_border');
  }

  build() {
    Navigation() {
      if (this.showResult) {
        this.ResultView()
      } else if (this.level && this.getCurrentQuestion()) {
        Column() {
          // 顶部状态栏
          Row() {
            Text(`第 ${this.level?.id} 关`)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)

            Row() {
              ForEach(Array.from({ length: this.level?.lives || 3 }), (_: undefined, index: number) => {
                Text(index < this.lives ? '❤️' : '🖤')
                  .fontSize(14)
                  .margin({ left: 1, right: 1 })
              })
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)

            Text(`${this.currentIndex + 1} / ${this.level?.questions.length}`)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 12, bottom: 12 })

          // 问题
          Column() {
            Text(this.getCurrentQuestion()?.question || '')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .textAlign(TextAlign.Center)
              .padding({ left: 20, right: 20 })
          }
          .width('100%')
          .margin({ top: 60, bottom: 60 })

          // 选项（使用打乱后的选项）
          Column() {
            ForEach(this.shuffledOptions, (option: string) => {
              Row() {
                Text(this.getOptionText(option))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.text_primary'))
                  .textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(56)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(this.getOptionBackgroundColor(option))
              .borderRadius(12)
              .border({
                width: 2,
                color: this.getOptionBorderColor(option)
              })
              .margin({ bottom: 12 })
              .onClick(() => {
                this.selectOption(option);
              })
            })
          }
          .width('100%')
          .padding({ left: 20, right: 20 })

          Blank()

          // 下一题按钮
          if (this.isAnswered) {
            Button(this.currentIndex < (this.level?.questions.length || 0) - 1 ? '下一题' : '查看结果')
              .width('80%')
              .height(48)
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .backgroundColor($r('app.color.button_primary'))
              .margin({ bottom: 32 })
              .onClick(() => {
                this.nextQuestion();
              })
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.bg_page'))
      } else {
        Column() {
          Text('加载中...')
            .fontSize(16)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  ResultView() {
    Column() {
      Text('🎉')
        .fontSize(64)
        .margin({ top: 60 })

      Text('恭喜过关！')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 24 })

      Text(`第 ${this.level?.id} 关`)
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 8 })

      Column() {
        Row() {
          Text('正确回答')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
          Blank()
          Text(`${this.correctAnswers} / ${this.level?.questions.length}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })

        Divider().color($r('app.color.gray_very_light'))

        Row() {
          Text('剩余生命')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
          Blank()
          Text(`${this.lives} ❤️`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })
      }
      .width('100%')
      .padding({ left: 24, right: 24 })
      .margin({ top: 40 })
      .backgroundColor($r('app.color.bg_card'))
      .borderRadius(16)

      Blank()

      Button('返回关卡列表')
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.button_primary'))
        .margin({ bottom: 16 })
        .onClick(() => {
          router.back();
        })

      Button('再来一次')
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .backgroundColor(Color.Transparent)
        .border({ width: 1, color: $r('app.color.button_primary') })
        .margin({ bottom: 32 })
        .onClick(() => {
          this.restartGame();
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.bg_page'))
  }
}

