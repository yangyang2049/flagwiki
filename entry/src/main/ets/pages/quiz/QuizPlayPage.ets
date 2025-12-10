import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Country, getCountryByCode, Countries } from '../../utils/countryData';
import { QuizLevel, getQuizLevel, getAllQuizLevels } from './QuizLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

interface RouterParams {
  quizType: string;
  levelId: number;
}

interface QuizQuestion {
  correctCountry: Country;
  choices: Country[];
}

@Entry
@Component
  struct QuizPlayPage {
  @State quizType: string = 'flagToName';
  @State level: QuizLevel | undefined = undefined;
  @State questions: QuizQuestion[] = [];
  @State currentIndex: number = 0;
  @State lives: number = 5;
  @State selectedIndex: number = -1;
  @State isAnswered: boolean = false;
  @State isCorrect: boolean = false;
  @State correctAnswers: number = 0;
  @State combo: number = 0;
  @State maxCombo: number = 0;
  @State showResult: boolean = false;
  @State animatingIndex: number = -1;
  @State scaleValue: number = 1;
  @State isSharing: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params) {
      this.quizType = params.quizType || 'flagToName';
      const levelId = params.levelId || 1;
      this.level = getQuizLevel(levelId);
      if (this.level) {
        this.lives = this.level.lives;
        this.generateQuestions();
      }
    }
  }

  private generateQuestions(): void {
    if (!this.level) return;

    this.questions = [];
    for (const code of this.level.countries) {
      const country = getCountryByCode(code);
      if (country) {
        const choices = this.generateChoices(country);
        this.questions.push({
          correctCountry: country,
          choices: choices
        });
      }
    }
    // 随机打乱题目顺序
    this.shuffleArray(this.questions);
  }

  private generateChoices(correctCountry: Country): Country[] {
    const choices: Country[] = [correctCountry];
    const allCountries = Countries.filter(c => c.code !== correctCountry.code);

    // 随机选择3个错误选项
    while (choices.length < 4 && allCountries.length > 0) {
      const randomIndex = Math.floor(Math.random() * allCountries.length);
      choices.push(allCountries[randomIndex]);
      allCountries.splice(randomIndex, 1);
    }

    // 打乱选项顺序
    this.shuffleArray(choices);
    return choices;
  }

  private shuffleArray<T>(array: T[]): void {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  private selectAnswer(index: number): void {
    if (this.isAnswered || this.animatingIndex !== -1) return;

    // 开始动画
    this.animatingIndex = index;
    this.scaleValue = 1.1;

    // 动画结束后检查答案
    setTimeout(() => {
      this.scaleValue = 1;
      setTimeout(() => {
        this.checkAnswer(index);
      }, 100);
    }, 150);
  }

  private checkAnswer(index: number): void {
    this.selectedIndex = index;
    this.isAnswered = true;
    this.animatingIndex = -1;

    const question = this.questions[this.currentIndex];
    const selectedCountry = question.choices[index];
    this.isCorrect = selectedCountry.code === question.correctCountry.code;

    if (this.isCorrect) {
      this.correctAnswers++;
      this.combo++;
      if (this.combo > this.maxCombo) {
        this.maxCombo = this.combo;
      }
    } else {
      this.lives--;
      this.combo = 0;

      if (this.lives <= 0) {
        // 延迟显示失败
        setTimeout(() => {
          this.showGameOver();
        }, 1500);
        return;
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    if (this.currentIndex < this.questions.length - 1) {
      this.currentIndex++;
      this.selectedIndex = -1;
      this.isAnswered = false;
      this.isCorrect = false;
      this.animatingIndex = -1;
      this.scaleValue = 1;
    } else {
      // 完成所有题目，解锁下一关
      if (this.level) {
        await GameProgressManager.init(this.context);
        await GameProgressManager.unlockNextLevel(GameType.QUIZ, this.level.id);
      }
      this.showResult = true;
    }
  }

  private showGameOver(): void {
    promptAction.showDialog({
      title: '挑战失败',
      message: `正确回答了 ${this.correctAnswers} 道题\n最高连击 ${this.maxCombo}`,
      buttons: [
        { text: '返回', color: '#666666' },
        { text: '重新开始', color: '#1677FF' }
      ]
    }).then((result) => {
      if (result.index === 0) {
        router.back();
      } else {
        this.restartQuiz();
      }
    });
  }

  private restartQuiz(): void {
    this.currentIndex = 0;
    this.selectedIndex = -1;
    this.isAnswered = false;
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.combo = 0;
    this.maxCombo = 0;
    this.showResult = false;
    this.animatingIndex = -1;
    this.scaleValue = 1;
    if (this.level) {
      this.lives = this.level.lives;
    }
    this.generateQuestions();
  }

  private getTitle(): string {
    return this.quizType === 'flagToName' ? '看旗猜国名' : '看名猜国旗';
  }

  private getCorrectIndex(): number {
    const question = this.questions[this.currentIndex];
    return question.choices.findIndex(c => c.code === question.correctCountry.code);
  }

  build() {
    Navigation() {
      if (this.showResult) {
        this.ResultView()
      } else if (this.questions.length > 0) {
        Column() {
          // 顶部状态栏
          Row() {
            // 左侧：第几关
            Text(`第 ${this.level?.id} 关`)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)

            // 中间：生命值
            Row() {
              ForEach(Array.from({ length: this.level?.lives || 5 }), (_: undefined, index: number) => {
                Text(index < this.lives ? '❤️' : '🖤')
                  .fontSize(14)
                  .margin({ left: 1, right: 1 })
              })
            }
            .layoutWeight(1)
              .justifyContent(FlexAlign.Center)

            // 右侧：序号
            Text(`${this.currentIndex + 1} / ${this.questions.length}`)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .width('100%')
            .padding({ left: 20, right: 20, top: 12, bottom: 12 })

          // 连击提示
          if (this.combo >= 3) {
            Text(`🔥 ${this.combo} 连击！`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.color_orange'))
              .padding({ top: 8, bottom: 8 })
          }

          // 题目区域
          if (this.quizType === 'flagToName') {
            this.FlagToNameQuestion()
          } else {
            this.NameToFlagQuestion()
          }

          Blank()

          // 下一题按钮
          if (this.isAnswered) {
            Button(this.currentIndex < this.questions.length - 1 ? '下一题' : '查看结果')
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
  FlagToNameQuestion() {
    Column() {
      // 显示国旗
      Column() {
        Image($rawfile(`flags/${this.questions[this.currentIndex].correctCountry.code}.svg`))
          .width('80%')
          .height(160)
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
        .padding(24)
        .backgroundColor($r('app.color.bg_secondary'))
        .margin({ bottom: 24 })

      Text('这是哪个国家的国旗？')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 20 })

      // 选项
      Column() {
        ForEach(this.questions[this.currentIndex].choices, (country: Country, index: number) => {
          this.ChoiceButton(country.nameCN, index)
        })
      }
      .width('100%')
        .padding({ left: 20, right: 20 })
    }
    .width('100%')
  }

  @Builder
  NameToFlagQuestion() {
    Column() {
      // 显示国家名称
      Column() {
        Text(this.questions[this.currentIndex].correctCountry.nameCN)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Text(this.questions[this.currentIndex].correctCountry.name)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 8 })
      }
      .width('100%')
        .padding(32)
        .margin({ bottom: 24 })

      Text('请选择正确的国旗')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 20 })

      // 国旗选项 - 2x2 网格
      Grid() {
        ForEach(this.questions[this.currentIndex].choices, (country: Country, index: number) => {
          GridItem() {
            this.FlagChoiceButton(country, index)
          }
        })
      }
      .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .width('100%')
        .height(280)
        .padding({ left: 20, right: 20 })
    }
    .width('100%')
  }

  @Builder
  ChoiceButton(text: string, index: number) {
    Row() {
      Text(text)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getChoiceTextColor(index))
    }
    .width('100%')
      .height(52)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.getChoiceBackgroundColor(index))
      .borderRadius(12)
      .border({
        width: 2,
        color: this.getChoiceBorderColor(index)
      })
      .margin({ bottom: 12 })
      .scale({ x: this.animatingIndex === index ? this.scaleValue : 1, y: this.animatingIndex === index ? this.scaleValue : 1 })
      .animation({ duration: 150, curve: Curve.EaseOut })
      .onClick(() => {
        this.selectAnswer(index);
      })
  }

  @Builder
  FlagChoiceButton(country: Country, index: number) {
    Column() {
      Image($rawfile(`flags/${country.code}.svg`))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .padding(12)
    }
    .width('100%')
      .height('100%')
      .backgroundColor(this.getChoiceBackgroundColor(index))
      .borderRadius(12)
      .border({
        width: 1.5,
        color: this.getChoiceBorderColor(index)
      })
      .scale({ x: this.animatingIndex === index ? this.scaleValue : 1, y: this.animatingIndex === index ? this.scaleValue : 1 })
      .animation({ duration: 150, curve: Curve.EaseOut })
      .onClick(() => {
        this.selectAnswer(index);
      })
  }

  private getChoiceBackgroundColor(index: number): Resource {
    if (!this.isAnswered) {
      return $r('app.color.bg_card');
    }

    const correctIndex = this.getCorrectIndex();
    if (index === correctIndex) {
      return $r('app.color.bg_green_light');
    }
    if (index === this.selectedIndex && !this.isCorrect) {
      return $r('app.color.bg_red_light');
    }
    return $r('app.color.bg_card');
  }

  private getChoiceBorderColor(index: number): Resource {
    if (!this.isAnswered) {
      return $r('app.color.gray_border');
    }

    const correctIndex = this.getCorrectIndex();
    if (index === correctIndex) {
      return $r('app.color.color_green');
    }
    if (index === this.selectedIndex && !this.isCorrect) {
      return $r('app.color.color_red');
    }
    return $r('app.color.gray_border');
  }

  private getChoiceTextColor(index: number): Resource {
    if (!this.isAnswered) {
      return $r('app.color.text_primary');
    }

    const correctIndex = this.getCorrectIndex();
    if (index === correctIndex) {
      return $r('app.color.color_green');
    }
    if (index === this.selectedIndex && !this.isCorrect) {
      return $r('app.color.color_red');
    }
    return $r('app.color.text_primary');
  }

  @Builder
  ResultView() {
    Column() {
      // 可分享的内容区域
      Column() {
        Text('🎉')
          .fontSize(64)
          .margin({ top: 40 })

        Text('恭喜过关！')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 24 })

        Text(`第 ${this.level?.id} 关 · ${this.level?.name}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 8 })

        // 统计信息
        Column() {
          Row() {
            Text('正确答题')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`${this.correctAnswers} / ${this.questions.length}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .width('100%')
            .padding({ top: 16, bottom: 16 })

          Divider().color($r('app.color.gray_very_light'))

          Row() {
            Text('最高连击')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`${this.maxCombo}`)
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
          .margin({ top: 32 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(16)

        Text('国旗小百科')
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 16 })
      }
      .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .backgroundColor($r('app.color.bg_page'))

      Blank()

      // 按钮
      Row({ space: 12 }) {
        Button('分享成绩')
          .layoutWeight(1)
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.button_primary'))
          .backgroundColor(Color.Transparent)
          .border({ width: 1, color: $r('app.color.button_primary') })
          .onClick(() => {
            this.onShareResult();
          })

        Button('返回')
          .layoutWeight(1)
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.button_primary'))
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ bottom: 16 })

      Button(this.level && this.level.id < getAllQuizLevels().length ? '下一关' : '完美收官')
        .width('100%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .backgroundColor(Color.Transparent)
        .border({ width: 1, color: $r('app.color.button_primary') })
        .margin({ left: 16, right: 16, bottom: 32 })
        .onClick(() => {
          if (this.level && this.level.id < getAllQuizLevels().length) {
            // 下一关
            router.pushUrl({
              url: 'pages/quiz/QuizPlayPage',
              params: {
                quizType: this.quizType,
                levelId: this.level.id + 1
              }
            });
          } else {
            // 完美收官，退出
            router.back();
          }
        })
    }
    .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
  }

  private async onShareResult(): Promise<void> {
    if (this.isSharing) return;

    this.isSharing = true;
    promptAction.showToast({
      message: '正在准备分享...',
      duration: 1500
    });

    try {
      // 构建分享文本
      const quizTypeName = this.quizType === 'flagToName' ? '看旗猜国名' : '看名猜国旗';
      const shareText = this.buildShareText(quizTypeName);

      // 使用文本分享
      const shareData = new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.TEXT,
        content: shareText,
        title: `国旗猜猜 - ${quizTypeName}`,
        description: `第${this.level?.id}关挑战成功`
      });

      const controller = new systemShare.ShareController(shareData);
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DEFAULT
      });

    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to share: code: ${error?.code}, message: ${error?.message}`);
      promptAction.showToast({
        message: '分享失败',
        duration: 2000
      });
    } finally {
      this.isSharing = false;
    }
  }

  private buildShareText(quizTypeName: string): string {
    const lines: string[] = [];
    lines.push('🎉 恭喜过关！');
    lines.push('');
    lines.push(`🎮 ${quizTypeName}`);
    lines.push(`🏆 第 ${this.level?.id} 关 · ${this.level?.name}`);
    lines.push('');
    lines.push(`✅ 正确答题：${this.correctAnswers} / ${this.questions.length}`);
    lines.push(`🔥 最高连击：${this.maxCombo}`);
    lines.push(`❤️ 剩余生命：${this.lives}`);
    lines.push('');
    lines.push('—— 来自「国旗小百科」');

    return lines.join('\n');
  }
}

