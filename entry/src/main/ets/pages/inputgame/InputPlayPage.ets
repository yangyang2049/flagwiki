import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { getCountryByCode } from '../../utils/countryData';
import { InputGameLevel, getInputGameLevel, getTotalInputLevels } from './InputGameLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

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
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params) {
      const levelId = params.levelId || 1;
      this.level = getInputGameLevel(levelId);
      if (this.level) {
        this.lives = this.level.lives;
      }
    }
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

  private checkAnswer(): void {
    if (this.inputText.trim() === '') return;

    const correctName = this.getCurrentCountryName();
    const userInput = this.inputText.trim();

    // 检查答案是否正确（完全匹配或包含）
    if (userInput === correctName || correctName.includes(userInput) || userInput.includes(correctName)) {
      this.isCorrect = true;
      this.correctAnswers++;
      promptAction.showToast({
        message: '✓ 正确!',
        duration: 1500
      });
    } else {
      this.lives--;
      promptAction.showToast({
        message: '✗ 答案不正确',
        duration: 1000
      });

      setTimeout(() => {
        this.inputText = '';
      }, 300);

      if (this.lives <= 0) {
        setTimeout(() => {
          this.showGameOver();
        }, 1000);
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    if (!this.level) return;

    if (this.currentIndex < this.level.countries.length - 1) {
      this.currentIndex++;
      this.inputText = '';
      this.isCorrect = false;
    } else {
      // 完成所有题目，解锁下一关
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.INPUT, this.level.id);
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
    this.inputText = '';
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.showResult = false;
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
          }
          .width('100%')
            .margin({ top: 40, bottom: 40 })

          // 输入区域
          if (this.isCorrect) {
            // 正确答案显示
            Column() {
              Text('✓ 正确!')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_green'))
                .margin({ bottom: 8 })

              Text(this.getCurrentCountryName())
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Button(this.currentIndex < (this.level?.countries.length || 0) - 1 ? '下一题' : '查看结果')
                .width('80%')
                .height(48)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .margin({ top: 32 })
                .onClick(() => {
                  this.nextQuestion();
                })
            }
            .width('100%')
              .padding({ left: 20, right: 20 })
          } else {
            // 输入框和确认按钮
            Row() {
              TextInput({ text: this.inputText, placeholder: '请输入国家名称' })
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
                .onSubmit(() => {
                  this.checkAnswer();
                })

              Button('确认')
                .width(72)
                .height(50)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .borderRadius(12)
                .margin({ left: 12 })
                .onClick(() => {
                  this.checkAnswer();
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
          Text(`${this.correctAnswers} / ${this.level?.countries.length}`)
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

      Button(this.level && this.level.id < getTotalInputLevels() ? '下一关' : '完美收官')
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .backgroundColor(Color.Transparent)
        .border({ width: 1, color: $r('app.color.button_primary') })
        .margin({ bottom: 32 })
        .onClick(() => {
          if (this.level && this.level.id < getTotalInputLevels()) {
            // 下一关
            router.pushUrl({
              url: 'pages/inputgame/InputPlayPage',
              params: {
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
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.bg_page'))
  }
}

