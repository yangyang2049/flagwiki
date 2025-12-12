import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { getCountryByCode } from '../../utils/countryData';
import { InputGameLevel, getInputGameLevel, getTotalInputLevels } from './InputGameLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';

interface RouterParams {
  levelId: number;
}

@Entry
@Component
  struct InputPlayPage {
  @State level: InputGameLevel | undefined = undefined;
  @State currentIndex: number = 0;
  @State lives: number = 3;
  @State inputText: string = '';
  @State isCorrect: boolean = false;
  @State showResult: boolean = false;
  @State correctAnswers: number = 0;
  @State flagVisible: boolean = false; // 国旗可见性
  private context = getContext(this) as common.UIAbilityContext;
  private timeoutIds: number[] = []; // 存储所有setTimeout的ID，用于清理

  async aboutToAppear() {
    // 初始化音效播放器
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    const params = router.getParams() as RouterParams;
    if (params) {
      const levelId = params.levelId || 1;
      this.loadLevel(levelId);
    }
  }

  aboutToDisappear() {
    // 清理所有setTimeout
    this.clearAllTimeouts();
    // 释放音效资源
    SoundEffectUtil.release();
  }

  private clearAllTimeouts(): void {
    for (const id of this.timeoutIds) {
      clearTimeout(id);
    }
    this.timeoutIds = [];
  }

  private loadLevel(levelId: number): void {
    // 清理之前的定时器
    this.clearAllTimeouts();
    this.level = getInputGameLevel(levelId);
    if (this.level) {
      this.lives = this.level.lives;
      this.currentIndex = 0;
      this.inputText = '';
      this.isCorrect = false;
      this.showResult = false;
      this.correctAnswers = 0;
      // 第一个国旗立即显示
      this.flagVisible = true;
    }
  }

  private animateFlag(): void {
    // 立即隐藏当前国旗
    this.flagVisible = false;
    // 然后逐渐显示新国旗
    const id = setTimeout(() => {
      this.flagVisible = true;
      // 移除已执行的定时器ID
      const index = this.timeoutIds.indexOf(id);
      if (index > -1) {
        this.timeoutIds.splice(index, 1);
      }
    }, 50);
    this.timeoutIds.push(id);
  }

  private getCurrentCountryCode(): string {
    if (!this.level || this.currentIndex >= this.level.countries.length) {
      return '';
    }
    return this.level.countries[this.currentIndex];
  }

  private getCurrentCountryName(): string {
    const code = this.getCurrentCountryCode();
    if (!code) return '';
    const country = getCountryByCode(code);
    return country?.nameCN || '';
  }

  private async checkAnswer(): Promise<void> {
    if (this.inputText.trim() === '') return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    const correctName = this.getCurrentCountryName();
    const userInput = this.inputText.trim();

    // 检查答案是否正确（完全匹配或包含）
    if (userInput === correctName || correctName.includes(userInput) || userInput.includes(correctName)) {
      // 播放正确答案音效和振动
      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();
      this.isCorrect = true;
      this.correctAnswers++;
    } else {
      // 播放错误答案音效和振动
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();
      this.lives--;

      const id1 = setTimeout(() => {
        this.inputText = '';
        // 移除已执行的定时器ID
        const index1 = this.timeoutIds.indexOf(id1);
        if (index1 > -1) {
          this.timeoutIds.splice(index1, 1);
        }
      }, 300);
      this.timeoutIds.push(id1);

      if (this.lives <= 0) {
        const id2 = setTimeout(async () => {
          await SoundEffectUtil.playOver();
          this.showGameOver();
          // 移除已执行的定时器ID
          const index2 = this.timeoutIds.indexOf(id2);
          if (index2 > -1) {
            this.timeoutIds.splice(index2, 1);
          }
        }, 1000);
        this.timeoutIds.push(id2);
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    if (!this.level) return;

    if (this.currentIndex < this.level.countries.length - 1) {
      this.currentIndex++;
      this.inputText = '';
      this.isCorrect = false;
      // 触发国旗动画
      this.animateFlag();
    } else {
      // 完成所有题目，解锁下一关
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.INPUT, this.level.id);
      // 播放恭喜音效和振动
      await SoundEffectUtil.playCongrats();
      VibratorUtil.vibrateWin();
      this.showResult = true;
    }
  }

  private showGameOver(): void {
    const challengeFailed = this.context.resourceManager.getStringSync($r('app.string.challenge_failed').id);
    const correctAnswersText = this.context.resourceManager.getStringSync($r('app.string.correct_answers_count_trivia').id, this.correctAnswers.toString());
    const backText = this.context.resourceManager.getStringSync($r('app.string.back').id);
    const restartText = this.context.resourceManager.getStringSync($r('app.string.restart').id);
    
    promptAction.showDialog({
      title: challengeFailed,
      message: correctAnswersText,
      buttons: [
        { text: backText, color: '#666666' },
        { text: restartText, color: '#1677FF' }
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
    this.inputText = '';
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.showResult = false;
    // 第一个国旗立即显示
    this.flagVisible = true;
    if (this.level) {
      this.lives = this.level.lives;
    }
  }

  build() {
    Navigation() {
      if (this.showResult) {
        this.ResultView()
      } else if (this.level) {
        Column() {
          // 顶部状态栏
          Row() {
            Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
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

            Text(`${this.currentIndex + 1} / ${this.level?.countries.length}`)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_secondary'))
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .width('100%')
            .padding({ left: 20, right: 20, top: 12, bottom: 12 })

          // 国旗展示
          Column() {
            Image($rawfile(`flags/${this.getCurrentCountryCode()}.svg`))
              .width('80%')
              .height(180)
              .objectFit(ImageFit.Contain)
              .opacity(this.flagVisible ? 1 : 0)
              .scale({ x: this.flagVisible ? 1 : 0.8, y: this.flagVisible ? 1 : 0.8 })
              .animation({
                duration: 300,
                curve: Curve.EaseOut
              })
          }
          .width('100%')
            .margin({ top: 40, bottom: 40 })

          // 输入区域
          if (this.isCorrect) {
            // 正确答案显示
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.correct_answer').id))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_green'))
                .margin({ bottom: 8 })

              Text(this.getCurrentCountryName())
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Button(this.currentIndex < (this.level?.countries.length || 0) - 1 
                ? this.context.resourceManager.getStringSync($r('app.string.next_question').id)
                : this.context.resourceManager.getStringSync($r('app.string.view_results').id))
                .width('80%')
                .height(48)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .margin({ top: 32 })
                .onClick(async () => {
                  await this.nextQuestion();
                })
            }
            .width('100%')
              .padding({ left: 20, right: 20 })
          } else {
            // 输入框和确认按钮
            Row() {
              TextInput({ text: this.inputText, placeholder: this.context.resourceManager.getStringSync($r('app.string.enter_country_name').id) })
                .layoutWeight(1)
                .height(50)
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(12)
                .border({
                  width: 1,
                  color: $r('app.color.gray_border')
                })
                .onChange((value: string) => {
                  this.inputText = value;
                })
                .onSubmit(async () => {
                  await this.checkAnswer();
                })

              Button('✓')
                .width(72)
                .height(50)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .borderRadius(12)
                .margin({ left: 12 })
                .onClick(async () => {
                  await this.checkAnswer();
                })
            }
            .width('100%')
              .padding({ left: 20, right: 20 })
          }

          Blank()
        }
        .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.bg_page'))
      } else {
        Column() {
          Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
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

      Text($r('app.string.congratulations'))
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 24 })

      Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 8 })

      Column() {
        Row() {
          Text(this.context.resourceManager.getStringSync($r('app.string.correct_answers_label').id))
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
          Blank()
          Text(`${this.correctAnswers} / ${this.level?.countries.length}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })

        Divider().color($r('app.color.gray_very_light'))

        Row() {
          Text(this.context.resourceManager.getStringSync($r('app.string.remaining_lives').id))
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

      Button(this.context.resourceManager.getStringSync($r('app.string.back_to_levels').id))
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.button_primary'))
        .margin({ bottom: 16 })
        .onClick(() => {
          router.back();
        })

      Button(this.level && this.level.id < getTotalInputLevels() 
        ? this.context.resourceManager.getStringSync($r('app.string.next_level').id)
        : this.context.resourceManager.getStringSync($r('app.string.perfect_finish').id))
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .backgroundColor(Color.Transparent)
        .border({ width: 1, color: $r('app.color.button_primary') })
        .margin({ bottom: 32 })
        .onClick(async () => {
          await SoundEffectUtil.playButton();
          if (this.level && this.level.id < getTotalInputLevels()) {
            // 下一关 - 在当前页面重新加载数据
            await GameProgressManager.init(this.context);
            await GameProgressManager.unlockNextLevel(GameType.INPUT, this.level.id);
            this.loadLevel(this.level.id + 1);
          } else {
            // 完美收官，退出
            router.back();
          }
        })
    }
    .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.bg_page'))
  }
}

