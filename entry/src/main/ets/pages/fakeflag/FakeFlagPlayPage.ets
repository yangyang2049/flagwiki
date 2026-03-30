import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { getCountryByCode, getLocalizedCountryName } from '../../utils/countryData';
import { FakeFlagLevel, FakeFlagQuestion, getFakeFlagLevel, getAllFakeFlagLevels } from './FakeFlagLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import { FlagSvgAssets } from '../../utils/FlagSvgAssets';

interface RouterParams {
  levelId: number;
}

@Entry
@Component
  struct FakeFlagPlayPage {
  @State level: FakeFlagLevel | undefined = undefined;
  @State currentIndex: number = 0;
  @State lives: number = 3;
  @State selectedCode: string = '';
  @State isAnswered: boolean = false;
  @State isCorrect: boolean = false;
  @State showResult: boolean = false;
  @State correctAnswers: number = 0;
  @State animatingCode: string = '';
  @State scaleValue: number = 1;
  @State showCompareDialog: boolean = false;
  @State flagVisible: boolean[] = [false, false, false, false];  // 国旗选项可见性
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
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
    this.level = getFakeFlagLevel(levelId);
    if (this.level) {
      this.lives = this.level.lives;
      this.currentIndex = 0;
      this.selectedCode = '';
      this.isAnswered = false;
      this.isCorrect = false;
      this.showResult = false;
      this.correctAnswers = 0;
      this.animatingCode = '';
      this.scaleValue = 1;
      this.showCompareDialog = false;
      this.flagVisible = [false, false, false, false];
      // 触发选项动画
      this.animateFlags();
    }
  }

  private getCurrentQuestion(): FakeFlagQuestion | undefined {
    if (!this.level || this.currentIndex >= this.level.questions.length) {
      return undefined;
    }
    return this.level.questions[this.currentIndex];
  }

  private selectFlag(code: string): void {
    // 如果已答对、正在动画中、或者当前正在显示错误状态，则不处理
    if (this.isAnswered || this.animatingCode !== '' || this.selectedCode !== '') return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    const question = this.getCurrentQuestion();
    if (!question) return;

    // 开始动画
    this.animatingCode = code;
    this.scaleValue = 1.05;

    // 动画结束后检查答案
    const id1 = setTimeout(() => {
      this.scaleValue = 1;
      const id2 = setTimeout(async () => {
        await this.checkAnswer(code);
        // 移除已执行的定时器ID
        const index2 = this.timeoutIds.indexOf(id2);
        if (index2 > -1) {
          this.timeoutIds.splice(index2, 1);
        }
      }, 100);
      this.timeoutIds.push(id2);
      // 移除已执行的定时器ID
      const index1 = this.timeoutIds.indexOf(id1);
      if (index1 > -1) {
        this.timeoutIds.splice(index1, 1);
      }
    }, 150);
    this.timeoutIds.push(id1);
  }

  private async checkAnswer(code: string): Promise<void> {
    const question = this.getCurrentQuestion();
    if (!question) return;

    this.selectedCode = code;
    this.animatingCode = '';
    this.isCorrect = code === question.fakeCountryCode;

    if (this.isCorrect) {
      // 播放正确答案音效和振动
      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();
      this.isAnswered = true;
      this.correctAnswers++;
      // 正确时显示对比弹窗（延迟弹出）
      const id1 = setTimeout(() => {
        this.showCompareDialog = true;
        // 移除已执行的定时器ID
        const index1 = this.timeoutIds.indexOf(id1);
        if (index1 > -1) {
          this.timeoutIds.splice(index1, 1);
        }
      }, 800);
      this.timeoutIds.push(id1);
    } else {
      // 播放错误答案音效和振动
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();
      // 错误时扣除生命值，但允许继续选择
      this.lives--;
      // 短暂显示错误状态后重置选择
      const id2 = setTimeout(() => {
        this.selectedCode = '';
        // 移除已执行的定时器ID
        const index2 = this.timeoutIds.indexOf(id2);
        if (index2 > -1) {
          this.timeoutIds.splice(index2, 1);
        }
      }, 800);
      this.timeoutIds.push(id2);

      if (this.lives <= 0) {
        const id3 = setTimeout(async () => {
          await SoundEffectUtil.playOver();
          this.showGameOver();
          // 移除已执行的定时器ID
          const index3 = this.timeoutIds.indexOf(id3);
          if (index3 > -1) {
            this.timeoutIds.splice(index3, 1);
          }
        }, 1000);
        this.timeoutIds.push(id3);
        return;
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    if (!this.level) return;

    this.showCompareDialog = false;

    if (this.currentIndex < this.level.questions.length - 1) {
      this.currentIndex++;
      this.selectedCode = '';
      this.isAnswered = false;
      this.isCorrect = false;
      this.animatingCode = '';
      this.scaleValue = 1;
      this.flagVisible = [false, false, false, false];
      // 触发选项动画
      this.animateFlags();
    } else {
      // 完成所有题目，解锁下一关
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.FAKE_FLAG, this.level.id);
      // 播放恭喜音效和振动
      await SoundEffectUtil.playCongrats();
      VibratorUtil.vibrateWin();
      this.showResult = true;
    }
  }

  private showGameOver(): void {
    const challengeFailed = this.context.resourceManager.getStringSync($r('app.string.challenge_failed').id);
    const correctFoundText = this.context.resourceManager.getStringSync($r('app.string.correct_found_count').id, this.correctAnswers.toString());
    const backText = this.context.resourceManager.getStringSync($r('app.string.back').id);
    const restartText = this.context.resourceManager.getStringSync($r('app.string.restart').id);
    
    promptAction.showDialog({
      title: challengeFailed,
      message: correctFoundText,
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

  private animateFlags(): void {
    // 重置所有选项为不可见
    this.flagVisible = [false, false, false, false];
    
    // 逐个显示选项
    for (let i = 0; i < 4; i++) {
      const id = setTimeout(() => {
        const newVisible = [...this.flagVisible];
        newVisible[i] = true;
        this.flagVisible = newVisible;
        // 移除已执行的定时器ID
        const index = this.timeoutIds.indexOf(id);
        if (index > -1) {
          this.timeoutIds.splice(index, 1);
        }
      }, i * 100); // 每个选项延迟100ms
      this.timeoutIds.push(id);
    }
  }

  private restartGame(): void {
    this.currentIndex = 0;
    this.selectedCode = '';
    this.isAnswered = false;
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.showResult = false;
    this.showCompareDialog = false;
    this.animatingCode = '';
    this.scaleValue = 1;
    this.flagVisible = [false, false, false, false];
    if (this.level) {
      this.lives = this.level.lives;
      // 触发选项动画
      this.animateFlags();
    }
  }

  private getFlagSource(code: string, question: FakeFlagQuestion): string {
    // 如果这是假旗且类型是wrongFlag，显示替代的旗帜
    if (code === question.fakeCountryCode && question.fakeType === 'wrongFlag') {
      return `flags/${question.fakeFlagAssetPath}.svg`;
    }
    return `flags/${code}.svg`;
  }

  private getFlagSourceForCode(code: string): string {
    const question = this.getCurrentQuestion();
    if (question) {
      return this.getFlagSource(code, question);
    }
    return `flags/${code}.svg`;
  }

  private getFlagTransform(code: string, question: FakeFlagQuestion): TransformOptions {
    // 如果这是假旗，根据类型应用变换
    if (code === question.fakeCountryCode) {
      if (question.fakeType === 'flipX') {
        return { x: -1, y: 1 };
      } else if (question.fakeType === 'flipY') {
        return { x: 1, y: -1 };
      }
    }
    return { x: 1, y: 1 };
  }

  private getFlagTransformForCode(code: string): TransformOptions {
    const question = this.getCurrentQuestion();
    if (question) {
      return this.getFlagTransform(code, question);
    }
    return { x: 1, y: 1 };
  }

  private getCountryName(code: string): string {
    const country = getCountryByCode(code);
    if (!country) return code.toUpperCase();
    return getLocalizedCountryName(country, this.currentLanguage);
  }

  private getCardBorderColor(code: string): Resource {
    if (!this.isAnswered) {
      return $r('app.color.gray_border');
    }

    const question = this.getCurrentQuestion();
    if (!question) return $r('app.color.gray_border');

    if (code === question.fakeCountryCode) {
      return $r('app.color.color_green');
    }
    if (code === this.selectedCode && !this.isCorrect) {
      return $r('app.color.color_red');
    }
    return $r('app.color.gray_border');
  }

  private getCardBackgroundColor(code: string): Resource {
    if (!this.isAnswered) {
      return $r('app.color.bg_card');
    }

    const question = this.getCurrentQuestion();
    if (!question) return $r('app.color.bg_card');

    if (code === question.fakeCountryCode) {
      return $r('app.color.bg_green_light');
    }
    if (code === this.selectedCode && !this.isCorrect) {
      return $r('app.color.bg_red_light');
    }
    return $r('app.color.bg_card');
  }

  build() {
    Stack() {
      Navigation() {
        Row() {
          Column() {
            if (this.showResult) {
              this.ResultView()
            } else if (this.level && this.getCurrentQuestion()) {
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

              Text(`${this.currentIndex + 1} / ${this.level?.questions.length}`)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_secondary'))
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
              .padding({ left: 20, right: 20, top: 12, bottom: 12 })

            // 提示文字
            Text(this.context.resourceManager.getStringSync($r('app.string.find_fake_flag').id))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ top: 60, bottom: 60 })

            // 4个国旗选项 - 2x2网格
            this.FlagGrid()

            Blank()
            }
            .width('100%')
            .height('100%')
            .backgroundColor($r('app.color.bg_page'))
            .constraintSize({ maxWidth: getContentMaxWidth() })
          } else {
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.loading').id))
                .fontSize(16)
                .fontColor($r('app.color.text_tertiary'))
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .constraintSize({ maxWidth: getContentMaxWidth() })
          }
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      }
      .title('')
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
      .backgroundColor($r('app.color.bg_page'))

      // 对比弹窗
      if (this.showCompareDialog) {
        this.CompareDialog()
      }
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  FlagGrid() {
    Grid() {
      ForEach(this.getCurrentQuestion()?.countryCodes || [], (code: string, index: number) => {
        GridItem() {
          this.FlagCard(code, index)
        }
      })
    }
    .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(16)
      .rowsGap(16)
      .width('100%')
      .height(340)
      .padding({ left: 20, right: 20 })
  }

  @Builder
  FlagCard(code: string, index: number) {
    Column() {
      Image(FlagSvgAssets.getUriForRelativePath(this.getFlagSourceForCode(code)))
        .width('90%')
        .height('70%')
        .objectFit(ImageFit.Contain)
        .scale(this.getFlagTransformForCode(code))

      Text(this.getCountryName(code))
        .fontSize(13)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(12)
    .border({
      width: 2,
      color: this.getCardBorderColor(code)
    })
    .opacity(this.flagVisible[index] ? 1 : 0)
    .scale({
      x: this.animatingCode === code ? this.scaleValue : (this.flagVisible[index] ? 1 : 0.8),
      y: this.animatingCode === code ? this.scaleValue : (this.flagVisible[index] ? 1 : 0.8)
    })
    .animation({ duration: 300, curve: Curve.EaseOut })
    .onClick(async () => {
      await this.selectFlag(code);
    })
  }

  @Builder
  CompareDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.6)')

      // 对话框内容
      Column() {
        // 假旗部分（带左侧浮动X标记）
        Stack({ alignContent: Alignment.Start }) {
          // 国旗居中
          Image(FlagSvgAssets.getUriForRelativePath(this.getFakeFlagSource()))
            .width('100%')
            .height(100)
            .objectFit(ImageFit.Contain)
            .scale(this.getFakeFlagTransform())

          // 左侧浮动X标记
          Stack() {
            Column()
              .width(28)
              .height(28)
              .backgroundColor($r('app.color.color_red'))
              .borderRadius(14)
            Text('✗')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .position({ x: 8, y: 36 })
        }
        .width('90%')
          .margin({ top: 20 })

        // 国家名称
        Text(this.getFakeCountryName())
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 16, bottom: 16 })

        // 真旗部分（带左侧浮动✓标记）
        Stack({ alignContent: Alignment.Start }) {
          // 国旗居中
          Image(FlagSvgAssets.getUriForRelativePath(this.getTrueFlagSource()))
            .width('100%')
            .height(100)
            .objectFit(ImageFit.Contain)

          // 左侧浮动✓标记
          Stack() {
            Column()
              .width(28)
              .height(28)
              .backgroundColor($r('app.color.color_green'))
              .borderRadius(14)
            Text('✓')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .position({ x: 8, y: 36 })
        }
        .width('90%')

        // 按钮
        Button(this.currentIndex < (this.level?.questions.length || 0) - 1 
          ? this.context.resourceManager.getStringSync($r('app.string.next_question').id)
          : this.context.resourceManager.getStringSync($r('app.string.view_results').id))
          .width('90%')
          .height(44)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.button_primary'))
          .margin({ top: 24, bottom: 20 })
          .onClick(async () => {
            await this.nextQuestion();
          })
      }
      .width('85%')
        .constraintSize({ maxWidth: 320 })
        .backgroundColor($r('app.color.bg_page'))
        .borderRadius(20)
        .shadow({
          radius: 20,
          color: 'rgba(0, 0, 0, 0.3)',
          offsetX: 0,
          offsetY: 4
        })
    }
    .width('100%')
      .height('100%')
  }

  private getFakeFlagSource(): string {
    const question = this.getCurrentQuestion();
    if (question) {
      if (question.fakeType === 'wrongFlag' && question.fakeFlagAssetPath) {
        return `flags/${question.fakeFlagAssetPath}.svg`;
      }
      return `flags/${question.fakeCountryCode}.svg`;
    }
    return 'flags/cn.svg';
  }

  private getFakeFlagTransform(): TransformOptions {
    const question = this.getCurrentQuestion();
    if (question) {
      if (question.fakeType === 'flipX') {
        return { x: -1, y: 1 };
      } else if (question.fakeType === 'flipY') {
        return { x: 1, y: -1 };
      }
    }
    return { x: 1, y: 1 };
  }

  private getTrueFlagSource(): string {
    const question = this.getCurrentQuestion();
    if (question) {
      return `flags/${question.fakeCountryCode}.svg`;
    }
    return 'flags/cn.svg';
  }

  private getFakeCountryName(): string {
    const question = this.getCurrentQuestion();
    if (question) {
      const country = getCountryByCode(question.fakeCountryCode);
      if (!country) return question.fakeCountryCode.toUpperCase();
      return getLocalizedCountryName(country, this.currentLanguage);
    }
    return '';
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
          Text(this.context.resourceManager.getStringSync($r('app.string.correct_found').id))
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

      Button(this.level && this.level.id < getAllFakeFlagLevels().length ? $r('app.string.next_level') : $r('app.string.perfect_finish'))
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
          if (this.level && this.level.id < getAllFakeFlagLevels().length) {
            // 下一关 - 在当前页面重新加载数据
            await GameProgressManager.init(this.context);
            await GameProgressManager.unlockNextLevel(GameType.FAKE_FLAG, this.level.id);
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

interface TransformOptions {
  x: number;
  y: number;
}

