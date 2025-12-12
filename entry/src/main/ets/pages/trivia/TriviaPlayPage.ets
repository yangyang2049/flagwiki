import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { getCountryByCode } from '../../utils/countryData';
import { TriviaLevel, TriviaQuestion, getTriviaLevel, getTotalTriviaLevels } from './TriviaLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { screenshotManager } from '../../utils/ScreenshotManager';

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
  @State optionVisible: boolean[] = [];  // 选项可见性
  @State animatingIndex: number = -1;  // 正在动画的选项索引
  @State scaleValue: number = 1;  // 缩放值
  @State isSharing: boolean = false;
  @State sharePixelMap: image.PixelMap | null = null;
  private context = getContext(this) as common.UIAbilityContext;
  private readonly SHARE_CONTAINER_ID = 'triviaShareContainer';
  private timeoutIds: number[] = []; // 存储所有setTimeout的ID，用于清理

  async aboutToAppear() {
    // 初始化音效播放器
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());

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
    // 释放分享 PixelMap
    this.releaseSharePixelMap();
  }

  private releaseSharePixelMap(): void {
    if (this.sharePixelMap) {
      try {
        this.sharePixelMap.release();
      } catch (e) {
        console.warn('[TriviaPlayPage] Failed to release share pixelmap:', e);
      }
      this.sharePixelMap = null;
    }
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
    this.level = getTriviaLevel(levelId, this.context);
    if (this.level) {
      this.lives = this.level.lives;
      this.currentIndex = 0;
      this.selectedOption = '';
      this.isAnswered = false;
      this.isCorrect = false;
      this.showResult = false;
      this.correctAnswers = 0;
      this.shuffledOptions = [];
      this.optionVisible = [];
      this.animatingIndex = -1;
      this.scaleValue = 1;
      this.initCurrentQuestionOptions();
      // 触发选项动画
      this.animateOptions();
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

  private async selectOption(option: string): Promise<void> {
    if (this.isAnswered || this.animatingIndex !== -1) return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    const question = this.getCurrentQuestion();
    if (!question) return;

    // 找到选项的索引
    const optionIndex = this.shuffledOptions.findIndex(opt => opt === option);
    if (optionIndex === -1) return;

    // 开始动画
    this.animatingIndex = optionIndex;
    this.scaleValue = 1.1;

    // 动画结束后检查答案
    const id1 = setTimeout(() => {
      this.scaleValue = 1;
      const id2 = setTimeout(async () => {
        await this.checkAnswer(option);
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

  private async checkAnswer(option: string): Promise<void> {
    const question = this.getCurrentQuestion();
    if (!question) return;

    this.selectedOption = option;
    this.isAnswered = true;
    this.animatingIndex = -1;
    this.isCorrect = option === question.answer;

    if (this.isCorrect) {
      // 播放正确答案音效和振动
      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();
      this.correctAnswers++;
    } else {
      // 播放错误答案音效和振动
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();
      this.lives--;

      if (this.lives <= 0) {
        const id = setTimeout(async () => {
          await SoundEffectUtil.playOver();
          this.showGameOver();
          // 移除已执行的定时器ID
          const index = this.timeoutIds.indexOf(id);
          if (index > -1) {
            this.timeoutIds.splice(index, 1);
          }
        }, 1500);
        this.timeoutIds.push(id);
        return;
      }
    }
  }

  private async nextQuestion(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    if (!this.level) return;

    if (this.currentIndex < this.level.questions.length - 1) {
      this.currentIndex++;
      this.selectedOption = '';
      this.isAnswered = false;
      this.isCorrect = false;
      this.animatingIndex = -1;
      this.scaleValue = 1;
      this.optionVisible = [];
      this.initCurrentQuestionOptions();  // 为新题目打乱选项
      // 触发选项动画
      this.animateOptions();
    } else {
      // 完成所有题目，解锁下一关
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.TRIVIA, this.level.id);
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
    this.selectedOption = '';
    this.isAnswered = false;
    this.isCorrect = false;
    this.correctAnswers = 0;
    this.showResult = false;
    this.animatingIndex = -1;
    this.scaleValue = 1;
    this.optionVisible = [];
    if (this.level) {
      this.lives = this.level.lives;
      this.initCurrentQuestionOptions();  // 重新打乱选项
      // 触发选项动画
      this.animateOptions();
    }
  }

  private animateOptions(): void {
    const question = this.getCurrentQuestion();
    if (!question) return;
    
    const optionCount = question.options.length;
    // 重置所有选项为不可见
    this.optionVisible = new Array(optionCount).fill(false);
    
    // 逐个显示选项
    for (let i = 0; i < optionCount; i++) {
      const id = setTimeout(() => {
        const newVisible = [...this.optionVisible];
        newVisible[i] = true;
        this.optionVisible = newVisible;
        // 移除已执行的定时器ID
        const index = this.timeoutIds.indexOf(id);
        if (index > -1) {
          this.timeoutIds.splice(index, 1);
        }
      }, i * 100); // 每个选项延迟100ms
      this.timeoutIds.push(id);
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

  @Builder
  OptionButton(option: string, index: number) {
    Stack({ alignContent: Alignment.End }) {
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

      // 结果显示图标（在按钮缩放动画结束后显示）
      if (this.isAnswered && this.animatingIndex === -1) {
        this.ResultIcon(option)
      }
    }
    .width('100%')
      .height(56)
      .margin({ bottom: 12 })
      .opacity(this.optionVisible[index] ? 1 : 0)
      .scale({ 
        x: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8), 
        y: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8) 
      })
      .animation({ duration: 300, curve: Curve.EaseOut })
      .onClick(async () => {
        await this.selectOption(option);
      })
  }

  @Builder
  ResultIcon(option: string) {
    if (this.getCurrentQuestion() && (option === this.getCurrentQuestion()?.answer || (option === this.selectedOption && !this.isCorrect))) {
      Stack() {
        Column()
          .width(28)
          .height(28)
          .backgroundColor(option === this.getCurrentQuestion()?.answer ? $r('app.color.color_green') : $r('app.color.color_red'))
          .borderRadius(14)
        Text(option === this.getCurrentQuestion()?.answer ? '✓' : '✗')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .opacity(1)
        .animation({ duration: 200, curve: Curve.EaseOut })
        .margin({ right: 12 })
    }
  }

  build() {
    Navigation() {
      Column() {
        if (this.showResult) {
          this.ResultView()
        } else if (this.level && this.getCurrentQuestion()) {
          Column() {
            // 隐藏的分享容器（包含问题 UI）
            Column() {
              if (this.level && this.getCurrentQuestion()) {
                this.ShareContentBuilder()
              }
            }
            .id(this.SHARE_CONTAINER_ID)
            .position({ x: -1000, y: -1000 })
            .width(400)
            .backgroundColor($r('app.color.bg_page'))

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
                ForEach(this.shuffledOptions, (option: string, index: number) => {
                  this.OptionButton(option, index)
                })
              }
              .width('100%')
                .padding({ left: 20, right: 20 })

              Blank()

              // 下一题按钮
              if (this.isAnswered) {
                Button(this.currentIndex < (this.level?.questions.length || 0) - 1 
                  ? this.context.resourceManager.getStringSync($r('app.string.next_question').id)
                  : this.context.resourceManager.getStringSync($r('app.string.view_results').id))
                  .width('80%')
                  .height(48)
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor($r('app.color.button_primary'))
                  .margin({ bottom: 32 })
                  .onClick(async () => {
                    await this.nextQuestion();
                  })
              }
            }
            .width('100%')
              .height('100%')
              .backgroundColor($r('app.color.bg_page'))
          }
        } else {
          Column() {
            Text($r('app.string.loading'))
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))
          }
          .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
        .height('100%')
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
    .menus(this.MenuBuilder)
  }

  @Builder
  MenuBuilder() {
    Row({ space: 20 }) {
      Image($r('app.media.icon_share'))
        .width(22)
        .height(22)
        .onClick(() => {
          this.onShareClick();
        })
    }
    .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: 16 })
  }

  @Builder
  ShareContentBuilder() {
    if (this.getCurrentQuestion()) {
      Column({ space: 16 }) {
      // 关卡信息
      Row() {
        Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_secondary'))
          .layoutWeight(1)

        Text(`${this.currentIndex + 1} / ${this.level?.questions.length}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_secondary'))
          .textAlign(TextAlign.End)
      }
      .width('100%')
        .padding({ left: 16, right: 16, top: 20, bottom: 12 })

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
        .margin({ top: 40, bottom: 40 })

      // 选项
      Column() {
        ForEach(this.shuffledOptions, (option: string, index: number) => {
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
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(12)
            .margin({ bottom: 12 })
        })
      }
      .width('100%')
        .padding({ left: 20, right: 20 })

        Text(this.context.resourceManager.getStringSync($r('app.string.from_app').id))
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 16, bottom: 20 })
      }
      .width('100%')
        .padding({ top: 20, bottom: 20 })
        .backgroundColor($r('app.color.bg_page'))
    }
  }

  private async onShareClick(): Promise<void> {
    if (this.isSharing || !this.level || !this.getCurrentQuestion()) return;

    this.isSharing = true;
    promptAction.showToast({
      message: this.context.resourceManager.getStringSync($r('app.string.preparing_share').id),
      duration: 1500
    });

    let tempFilePath: string | null = null;

    try {
      // 先释放之前的 PixelMap
      this.releaseSharePixelMap();

      // 截取分享容器内容
      const pixmap = await screenshotManager.captureSnapshot(this.SHARE_CONTAINER_ID);
      if (!pixmap) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.screenshot_failed').id),
          duration: 2000
        });
        this.isSharing = false;
        return;
      }

      this.sharePixelMap = pixmap;

      // 创建图像打包器并打包为 ArrayBuffer
      const imagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 90
      };
      
      const imageData: ArrayBuffer = await imagePacker.packing(pixmap, packOpts);
      console.info(`[TriviaPlayPage] Image packed, data size: ${imageData.byteLength} bytes`);

      // 保存到临时文件
      const timestamp = Date.now();
      tempFilePath = this.context.cacheDir + '/share_trivia_' + timestamp + '.jpg';
      
      // 使用同步文件操作
      const fileHandle = fs.openSync(tempFilePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(fileHandle.fd, imageData);
      fs.closeSync(fileHandle);
      
      // 验证文件是否存在且不为空
      const stat = fs.statSync(tempFilePath);
      if (stat.size === 0) {
        throw new Error('Image file is empty');
      }
      
      console.info(`[TriviaPlayPage] Image file created: ${tempFilePath}, size: ${stat.size} bytes`);

      // 获取文件URI
      const imageUri = fileUri.getUriFromPath(tempFilePath);
      console.info(`[TriviaPlayPage] Image URI: ${imageUri}`);
      
      // 获取图片类型描述符
      const utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg', uniformTypeDescriptor.UniformDataType.IMAGE);
      console.info(`[TriviaPlayPage] UTD Type ID: ${utdTypeId}`);

      // 使用图片URI分享
      const levelText = this.context.resourceManager.getStringSync($r('app.string.level_number').id, this.level.id.toString());
      const triviaName = this.context.resourceManager.getStringSync($r('app.string.game_trivia').id);
      const fromAppText = this.context.resourceManager.getStringSync($r('app.string.from_app').id);
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${levelText} - ${triviaName}`,
        description: fromAppText
      });
      
      console.info(`[TriviaPlayPage] ShareData created: utd=${utdTypeId}, uri=${imageUri}`);

      const controller = new systemShare.ShareController(shareData);
      
      // 显示分享面板
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      console.info('[TriviaPlayPage] Share panel opened successfully');
      
      // 分享成功后释放 PixelMap
      this.releaseSharePixelMap();
      
      // 延迟删除文件，确保分享完成
      setTimeout(() => {
        if (tempFilePath) {
          try {
            fs.unlinkSync(tempFilePath);
            console.info(`[TriviaPlayPage] Temp file deleted: ${tempFilePath}`);
          } catch (unlinkError) {
            console.warn('[TriviaPlayPage] Failed to delete temp file:', unlinkError);
          }
        }
      }, 5000); // 5秒后删除

    } catch (err) {
      const error = err as BusinessError;
      console.error(`[TriviaPlayPage] Failed to share: code: ${error?.code}, message: ${error?.message}`);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
        duration: 2000
      });
      
      // 清理资源
      this.releaseSharePixelMap();
      if (tempFilePath) {
        try {
          fs.unlinkSync(tempFilePath);
        } catch (unlinkError) {
          console.warn('[TriviaPlayPage] Failed to delete temp file on error:', unlinkError);
        }
      }
    } finally {
      this.isSharing = false;
    }
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

      Button(this.level && this.level.id < getTotalTriviaLevels() 
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
          if (this.level && this.level.id < getTotalTriviaLevels()) {
            // 下一关 - 在当前页面重新加载数据
            await GameProgressManager.init(this.context);
            await GameProgressManager.unlockNextLevel(GameType.TRIVIA, this.level.id);
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

