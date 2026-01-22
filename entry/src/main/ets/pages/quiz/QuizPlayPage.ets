import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { fileUri } from '@kit.CoreFileKit';
import { GameOverDialog } from '../../components/GameOverDialog';
import { Country, getCountryByCode, Countries, getLocalizedCountryName } from '../../utils/countryData';
import { QuizLevel, getQuizLevel, getAllQuizLevels, getQuizLevelName } from './QuizLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { screenshotManager } from '../../utils/ScreenshotManager';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import UiConstants from '../../utils/UiConstants';

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
  @State sharePixelMap: image.PixelMap | null = null;
  @State optionVisible: boolean[] = [false, false, false, false];  // 选项可见性
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';
  private context = getContext(this) as common.UIAbilityContext;
  private readonly SHARE_CONTAINER_ID = 'quizShareContainer';
  private timeoutIds: number[] = []; // 存储所有setTimeout的ID，用于清理
  private gameOverDialogController: CustomDialogController | null = null;

  async aboutToAppear() {
    // 初始化音效播放器和振动工具
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    // 初始化截图管理器
    screenshotManager.init(this.getUIContext());

    const params = router.getParams() as RouterParams;
    if (params) {
      this.quizType = params.quizType || 'flagToName';
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
        console.warn('[QuizPlayPage] Failed to release share pixelmap:', e);
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
    this.level = getQuizLevel(levelId);
    if (this.level) {
      this.lives = this.level.lives;
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
      this.optionVisible = [false, false, false, false];
      this.generateQuestions();
      // 触发选项动画
      this.animateOptions();
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
    // 防止重复点击和动画冲突
    if (this.isAnswered || this.animatingIndex !== -1 || this.showResult) return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    // 开始动画
    this.animatingIndex = index;
    this.scaleValue = 1.1;

    // 动画结束后检查答案
    const id1 = setTimeout(() => {
      this.scaleValue = 1;
      const id2 = setTimeout(async () => {
        await this.checkAnswer(index);
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

  private async checkAnswer(index: number): Promise<void> {
    this.selectedIndex = index;
    this.isAnswered = true;
    this.animatingIndex = -1;

    // 安全检查
    if (!this.questions || this.questions.length === 0 ||
        this.currentIndex < 0 || this.currentIndex >= this.questions.length) {
      return;
    }

    const question = this.questions[this.currentIndex];
    if (!question || !question.choices || index < 0 || index >= question.choices.length) {
      return;
    }

    const selectedCountry = question.choices[index];
    if (!selectedCountry || !question.correctCountry) {
      return;
    }

    this.isCorrect = selectedCountry.code === question.correctCountry.code;

    if (this.isCorrect) {
      // 播放正确答案音效和振动
      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();
      this.correctAnswers++;
      this.combo++;
      if (this.combo > this.maxCombo) {
        this.maxCombo = this.combo;
      }
    } else {
      // 播放错误答案音效和振动
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();
      this.lives--;
      this.combo = 0;

      if (this.lives <= 0) {
        // 延迟显示失败
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
    
    if (this.currentIndex < this.questions.length - 1) {
      this.currentIndex++;
      this.selectedIndex = -1;
      this.isAnswered = false;
      this.isCorrect = false;
      this.animatingIndex = -1;
      this.scaleValue = 1;
      this.optionVisible = [false, false, false, false];
      // 触发选项动画
      this.animateOptions();
    } else {
      // 完成所有题目，解锁下一关
      if (this.level) {
        await GameProgressManager.init(this.context);
        await GameProgressManager.unlockNextLevel(GameType.QUIZ, this.level.id);
      }
      // 播放恭喜音效和振动
      await SoundEffectUtil.playCongrats();
      VibratorUtil.vibrateWin();
      this.showResult = true;
    }
  }

  private showGameOver(): void {
    const challengeFailed = this.context.resourceManager.getStringSync($r('app.string.challenge_failed').id);
    const correctAnswersText = this.context.resourceManager.getStringSync($r('app.string.correct_answers_count').id, this.correctAnswers.toString());
    const maxComboText = this.context.resourceManager.getStringSync($r('app.string.max_combo').id, this.maxCombo.toString());
    const backText = this.context.resourceManager.getStringSync($r('app.string.back').id);
    const restartText = this.context.resourceManager.getStringSync($r('app.string.restart').id);

    if (this.gameOverDialogController) {
      try {
        this.gameOverDialogController.close();
      } catch (error) {
        console.warn('[QuizPlayPage] Failed to close game over dialog:', error);
      }
    }

    this.gameOverDialogController = new CustomDialogController({
      builder: GameOverDialog({
        title: challengeFailed,
        message: `${correctAnswersText}\n${maxComboText}`,
        backText,
        restartText,
        onBack: () => {
          router.back();
        },
        onRestart: () => {
          this.restartQuiz();
        }
      }),
      autoCancel: false,
      customStyle: true
    });
    this.gameOverDialogController.open();
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
    return this.quizType === 'flagToName' 
      ? this.context.resourceManager.getStringSync($r('app.string.quiz_flag_to_name').id)
      : this.context.resourceManager.getStringSync($r('app.string.quiz_name_to_flag').id);
  }

  private getCorrectIndex(): number {
    if (!this.questions || this.questions.length === 0 ||
        this.currentIndex < 0 || this.currentIndex >= this.questions.length) {
      return -1;
    }
    const question = this.questions[this.currentIndex];
    if (!question || !question.choices || !question.correctCountry) {
      return -1;
    }
    return question.choices.findIndex(c => c.code === question.correctCountry.code);
  }

  private animateOptions(): void {
    // 重置所有选项为不可见
    this.optionVisible = [false, false, false, false];
    
    // 逐个显示选项
    for (let i = 0; i < 4; i++) {
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
  
  private getCountryName(country: Country): string {
    return getLocalizedCountryName(country, this.currentLanguage);
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          if (this.showResult) {
            this.ResultView()
          } else if (this.questions.length > 0) {
            Column() {
              // 隐藏的分享容器（包含问题 UI）
              Column() {
                if (this.questions.length > 0) {
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
                  // 左侧：第几关
                  Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_secondary'))
                    .layoutWeight(1)

                  // 中间：生命值
                  Row() {
                    ForEach(Array.from({ length: this.level?.lives || 5 }), (_: undefined, index: number) => {
                      Text(index < this.lives ? UiConstants.HEART_FILLED : UiConstants.HEART_EMPTY)
                        .fontSize(14)
                        .margin({ left: 1, right: 1 })
                    })
                  }
                  .layoutWeight(1)
                    .justifyContent(FlexAlign.Center)

                  // 右侧：序号
                  Text(this.context.resourceManager.getStringSync($r('app.string.progress_indicator').id, (this.currentIndex + 1).toString(), this.questions.length.toString()))
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
                  Text(`${UiConstants.COMBO_FIRE} ${this.context.resourceManager.getStringSync($r('app.string.combo_streak').id, this.combo.toString())}`)
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
                  Button(this.currentIndex < this.questions.length - 1 
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
            .width('100%')
            .height('100%')
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
        .height('100%')
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
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
    if (this.questions.length > 0 && this.currentIndex >= 0 && this.currentIndex < this.questions.length &&
        this.questions[this.currentIndex] && this.questions[this.currentIndex].correctCountry) {
      Column({ space: 16 }) {
        // 关卡信息
        Row() {
          Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_secondary'))
            .layoutWeight(1)

          Text(`${this.currentIndex + 1} / ${this.questions.length}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.End)
        }
        .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 12 })

        // 问题内容
        if (this.quizType === 'flagToName') {
          // 看旗猜名
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

            Text(this.context.resourceManager.getStringSync($r('app.string.which_country_flag').id))
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 20 })

            // 选项
            Column() {
              ForEach(this.questions[this.currentIndex].choices, (country: Country, index: number) => {
                Row() {
                  Text(this.getCountryName(country))
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.text_primary'))
                }
                .width('100%')
                  .height(52)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('app.color.bg_card'))
                  .borderRadius(12)
                  .margin({ bottom: 12 })
              })
            }
            .width('100%')
              .padding({ left: 20, right: 20 })
          }
          .width('100%')
        } else {
          // 看名猜旗
          Column() {
            // 显示国家名称
            Column() {
              Text(this.getCountryName(this.questions[this.currentIndex].correctCountry))
                .fontSize(32)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              // 中文环境下显示英文名称作为副标题
              if (this.currentLanguage !== 'en' && !this.currentLanguage.startsWith('en-')) {
                Text(this.questions[this.currentIndex].correctCountry.name)
                  .fontSize(16)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ top: 8 })
              }
            }
            .width('100%')
              .padding(32)
              .margin({ bottom: 24 })

            Text(this.context.resourceManager.getStringSync($r('app.string.select_correct_flag').id))
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 20 })

            // 国旗选项 - 2x2 网格
            Grid() {
              ForEach(this.questions[this.currentIndex].choices, (country: Country, index: number) => {
                GridItem() {
                  Column() {
                    Image($rawfile(`flags/${country.code}.svg`))
                      .width('100%')
                      .height('100%')
                      .objectFit(ImageFit.Contain)
                      .padding(12)
                  }
                  .width('100%')
                    .height('100%')
                    .backgroundColor($r('app.color.bg_card'))
                    .borderRadius(12)
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
    if (this.isSharing || this.questions.length === 0) return;

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
      console.info(`[QuizPlayPage] Image packed, data size: ${imageData.byteLength} bytes`);

      // 保存到临时文件
      const timestamp = Date.now();
      tempFilePath = this.context.cacheDir + '/share_quiz_' + timestamp + '.jpg';
      
      // 使用同步文件操作
      const fileHandle = fs.openSync(tempFilePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(fileHandle.fd, imageData);
      fs.closeSync(fileHandle);
      
      // 验证文件是否存在且不为空
      const stat = fs.statSync(tempFilePath);
      if (stat.size === 0) {
        throw new Error('Image file is empty');
      }
      
      console.info(`[QuizPlayPage] Image file created: ${tempFilePath}, size: ${stat.size} bytes`);

      // 获取文件URI
      const imageUri = fileUri.getUriFromPath(tempFilePath);
      console.info(`[QuizPlayPage] Image URI: ${imageUri}`);
      
      // 获取图片类型描述符
      const utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg', uniformTypeDescriptor.UniformDataType.IMAGE);
      console.info(`[QuizPlayPage] UTD Type ID: ${utdTypeId}`);

      // 使用图片URI分享
      const levelText = this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString());
      const quizTypeName = this.context.resourceManager.getStringSync($r('app.string.quiz_flag_to_name').id);
      const fromAppText = this.context.resourceManager.getStringSync($r('app.string.from_app').id);
      const shareData = new systemShare.SharedData({
        utd: utdTypeId,
        uri: imageUri,
        title: `${levelText} - ${quizTypeName}`,
        description: fromAppText
      });
      
      console.info(`[QuizPlayPage] ShareData created: utd=${utdTypeId}, uri=${imageUri}`);

      const controller = new systemShare.ShareController(shareData);
      
      // 显示分享面板
      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      console.info('[QuizPlayPage] Share panel opened successfully');
      
      // 分享成功后释放 PixelMap
      this.releaseSharePixelMap();
      
      // 延迟删除文件，确保分享完成
      setTimeout(() => {
        if (tempFilePath) {
          try {
            fs.unlinkSync(tempFilePath);
            console.info(`[QuizPlayPage] Temp file deleted: ${tempFilePath}`);
          } catch (unlinkError) {
            console.warn('[QuizPlayPage] Failed to delete temp file:', unlinkError);
          }
        }
      }, 5000); // 5秒后删除

    } catch (err) {
      const error = err as BusinessError;
      console.error(`[QuizPlayPage] Failed to share: code: ${error?.code}, message: ${error?.message}`);
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
          console.warn('[QuizPlayPage] Failed to delete temp file on error:', unlinkError);
        }
      }
    } finally {
      this.isSharing = false;
    }
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

      Text(this.context.resourceManager.getStringSync($r('app.string.which_country_flag').id))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 20 })

      // 选项
      Column() {
        ForEach(this.questions[this.currentIndex].choices, (country: Country, index: number) => {
          this.ChoiceButton(this.getCountryName(country), index)
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
        Text(this.getCountryName(this.questions[this.currentIndex].correctCountry))
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        // 中文环境下显示英文名称作为副标题
        if (this.currentLanguage !== 'en' && !this.currentLanguage.startsWith('en-')) {
          Text(this.questions[this.currentIndex].correctCountry.name)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 8 })
        }
      }
      .width('100%')
        .padding(32)
        .margin({ bottom: 24 })

      Text(this.context.resourceManager.getStringSync($r('app.string.select_correct_flag').id))
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
    Stack({ alignContent: Alignment.End }) {
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

      // 结果显示图标（在按钮缩放动画结束后显示）
      if (this.isAnswered && this.animatingIndex === -1) {
        this.ResultIcon(index, true)
      }
    }
    .width('100%')
      .height(52)
      .margin({ bottom: 12 })
      .opacity(this.optionVisible[index] ? 1 : 0)
      .scale({ 
        x: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8), 
        y: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8) 
      })
      .animation({ duration: 300, curve: Curve.EaseOut })
      .onClick(() => {
        this.selectAnswer(index);
      })
  }

  @Builder
  FlagChoiceButton(country: Country, index: number) {
    Stack({ alignContent: Alignment.TopStart }) {
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

      // 结果显示图标（在按钮缩放动画结束后显示）
      if (this.isAnswered && this.animatingIndex === -1) {
        this.ResultIcon(index, false)
      }
    }
    .width('100%')
      .height('100%')
      .opacity(this.optionVisible[index] ? 1 : 0)
      .scale({ 
        x: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8), 
        y: this.animatingIndex === index ? this.scaleValue : (this.optionVisible[index] ? 1 : 0.8) 
      })
      .animation({ duration: 300, curve: Curve.EaseOut })
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
  ResultIcon(index: number, isTextOption: boolean) {
    if (index === this.getCorrectIndex() || (index === this.selectedIndex && !this.isCorrect)) {
      if (isTextOption) {
        Stack() {
          Column()
            .width(28)
            .height(28)
            .backgroundColor(index === this.getCorrectIndex() ? $r('app.color.color_green') : $r('app.color.color_red'))
            .borderRadius(14)
          Text(index === this.getCorrectIndex() ? UiConstants.CORRECT_MARK : UiConstants.INCORRECT_MARK)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .opacity(1)
          .animation({ duration: 200, curve: Curve.EaseOut })
          .margin({ right: 12 })
      } else {
        Stack() {
          Column()
            .width(28)
            .height(28)
            .backgroundColor(index === this.getCorrectIndex() ? $r('app.color.color_green') : $r('app.color.color_red'))
            .borderRadius(14)
          Text(index === this.getCorrectIndex() ? UiConstants.CORRECT_MARK : UiConstants.INCORRECT_MARK)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .opacity(1)
          .animation({ duration: 200, curve: Curve.EaseOut })
          .position({ x: 8, y: 8 })
      }
    }
  }

  @Builder
  ResultView() {
    Column() {
      // 可分享的内容区域
      Column() {
        Text(UiConstants.CELEBRATION)
          .fontSize(64)
          .margin({ top: 40 })

        Text($r('app.string.congratulations'))
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 24 })

        Text(`${this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString())} · ${this.level ? getQuizLevelName(this.level.id, this.context) : ''}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 8 })

        // 统计信息
        Column() {
          Row() {
            Text(this.context.resourceManager.getStringSync($r('app.string.correct_answers').id))
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
            Text(this.context.resourceManager.getStringSync($r('app.string.max_combo').id, this.maxCombo.toString()))
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
            Text(this.context.resourceManager.getStringSync($r('app.string.remaining_lives').id))
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`${this.lives} ${UiConstants.HEART_FILLED}`)
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

        Text(this.context.resourceManager.getStringSync($r('app.string.from_app').id))
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
        Button(this.context.resourceManager.getStringSync($r('app.string.share_score').id))
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

        Button(this.level && this.level.id < getAllQuizLevels().length ? $r('app.string.next_level') : $r('app.string.perfect_finish'))
          .layoutWeight(1)
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.button_primary'))
          .onClick(async () => {
            if (this.level && this.level.id < getAllQuizLevels().length) {
              // 下一关 - 在当前页面重新加载数据
              await GameProgressManager.init(this.context);
              await GameProgressManager.unlockNextLevel(GameType.QUIZ, this.level.id);
              this.loadLevel(this.level.id + 1);
            } else {
              // 完美收官，退出
              router.back();
            }
          })
      }
      .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ bottom: 32 })
    }
    .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
  }

  private async onShareResult(): Promise<void> {
    if (this.isSharing) return;

    this.isSharing = true;
    promptAction.showToast({
      message: this.context.resourceManager.getStringSync($r('app.string.preparing_share').id),
      duration: 1500
    });

    try {
      // 构建分享文本
      const quizTypeNameRes = this.quizType === 'flagToName' 
        ? $r('app.string.quiz_flag_to_name') 
        : $r('app.string.quiz_name_to_flag');
      const quizTypeName = this.context.resourceManager.getStringSync(quizTypeNameRes.id);
      const shareText = await this.buildShareText(quizTypeName);

      // 使用文本分享
      const gameQuizName = this.context.resourceManager.getStringSync($r('app.string.game_quiz').id);
      const levelChallengeSuccess = this.context.resourceManager.getStringSync(
        $r('app.string.level_challenge_success').id, 
        this.level?.id?.toString() || '1'
      );
      const shareData = new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.TEXT,
        content: shareText,
        title: `${gameQuizName} - ${quizTypeName}`,
        description: levelChallengeSuccess
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
        message: this.context.resourceManager.getStringSync($r('app.string.share_failed').id),
        duration: 2000
      });
    } finally {
      this.isSharing = false;
    }
  }

  private async buildShareText(quizTypeName: string): Promise<string> {
    const lines: string[] = [];
    const rm = this.context.resourceManager;
    const congratsText = await rm.getStringValue($r('app.string.congratulations').id);
    lines.push(`${UiConstants.CELEBRATION} ${congratsText}`);
    lines.push('');
    lines.push(`${UiConstants.GAME_CONTROLLER} ${quizTypeName}`);
    const levelText = rm.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString());
    const levelName = this.level ? getQuizLevelName(this.level.id, this.context) : '';
    lines.push(`${UiConstants.TROPHY} ${levelText} · ${levelName}`);
    lines.push('');
    lines.push(`${UiConstants.CORRECT_MARK} ${rm.getStringSync($r('app.string.correct_answers_share').id, this.correctAnswers.toString(), this.questions.length.toString())}`);
    lines.push(`${UiConstants.COMBO_FIRE} ${rm.getStringSync($r('app.string.max_combo_share').id, this.maxCombo.toString())}`);
    lines.push(`${UiConstants.HEART_FILLED} ${rm.getStringSync($r('app.string.remaining_lives_share').id, this.lives.toString())}`);
    lines.push('');
    const fromAppText = rm.getStringSync($r('app.string.from_app').id);
    lines.push(`—— ${fromAppText}`);

    return lines.join('\n');
  }
}
