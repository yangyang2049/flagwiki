import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { Country, Countries, getFlagImageSource } from '../../utils/countryData';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';

const QUESTIONS_PER_SESSION = 10;
const PREFS_NAME = 'heads_up_settings';
const KEY_FIRST_TIME = 'has_shown_tutorial';

@Entry
@Component
export struct HeadsUpPlayPage {
  @State currentCountry: Country | undefined = undefined;
  @State showAnswer: boolean = false;
  @State currentIndex: number = 0;
  @State sessionCountries: Country[] = [];
  @State showSessionOver: boolean = false;
  @State sessionNumber: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    // 初始化音效播放器和振动工具
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);
    
    await this.checkAndShowTutorial();
    this.startNewSession();
  }

  aboutToDisappear() {
    // 释放音效资源
    SoundEffectUtil.release();
  }

  private async checkAndShowTutorial(): Promise<void> {
    try {
      const prefs = await PreferencesManager.getPreferences(PREFS_NAME);
      const hasShown = await prefs.get(KEY_FIRST_TIME, false) as boolean;
      
      if (!hasShown) {
        // 首次进入，显示提示弹窗
        promptAction.showDialog({
          title: '使用说明',
          message: '• 点击屏幕查看答案\n• 再点下一个\n• 每十个一轮',
          buttons: [
            { text: '知道了', color: '#1677FF' }
          ]
        }).then(() => {
          // 保存已显示状态
          this.saveTutorialShown();
        }).catch(() => {
          // 即使取消也保存，避免重复显示
          this.saveTutorialShown();
        });
      }
    } catch (err) {
      console.error(`Failed to check tutorial: ${JSON.stringify(err)}`);
    }
  }

  private async saveTutorialShown(): Promise<void> {
    try {
      const prefs = await PreferencesManager.getPreferences(PREFS_NAME);
      await prefs.put(KEY_FIRST_TIME, true);
      await prefs.flush();
    } catch (err) {
      console.error(`Failed to save tutorial status: ${JSON.stringify(err)}`);
    }
  }

  private startNewSession(): void {
    this.sessionCountries = this.generateRandomCountries(QUESTIONS_PER_SESSION);
    this.currentIndex = 0;
    this.showAnswer = false;
    this.showSessionOver = false;
    this.loadNextCountry();
  }

  private generateRandomCountries(count: number): Country[] {
    // 使用 Fisher-Yates 洗牌算法确保真正的随机
    const shuffled = [...Countries];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      // 使用临时变量交换元素（ArkTS 不支持解构赋值）
      const temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled.slice(0, count);
  }

  private loadNextCountry(): void {
    if (this.currentIndex < this.sessionCountries.length) {
      this.currentCountry = this.sessionCountries[this.currentIndex];
      this.showAnswer = false;
    } else {
      this.showSessionOver = true;
    }
  }

  private async handleTap(): Promise<void> {
    if (!this.currentCountry) return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    if (!this.showAnswer) {
      // 第一次点击：显示答案
      await SoundEffectUtil.playButton();
      this.showAnswer = true;
    } else {
      // 第二次点击：下一个
      await SoundEffectUtil.playButton();
      this.currentIndex++;
      this.loadNextCountry();
    }
  }

  private async continueSession(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();
    
    this.sessionNumber++;
    this.startNewSession();
  }

  private async exitGame(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();
    
    router.back();
  }

  build() {
    Navigation() {
      Stack() {
        if (this.showSessionOver) {
          this.SessionOverView()
        } else if (this.currentCountry) {
          this.GameView()
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
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  GameView() {
    Column() {
      // 顶部 box（固定高度）
      Row() {
        Blank()
        Text(`${this.currentIndex + 1} / ${QUESTIONS_PER_SESSION}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_secondary'))
        Blank()
      }
      .width('100%')
      .height(120)
      .justifyContent(FlexAlign.Center)

      // 中间：国旗（占据剩余空间）
      Column() {
        if (this.currentCountry) {
          Image(getFlagImageSource(this.currentCountry.code))
            .width('90%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      // 底部 box（固定高度，与顶部一样）
      Column() {
        if (this.currentCountry) {
          Text(this.currentCountry.nameCN)
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 12 })
            .visibility(this.showAnswer ? Visibility.Visible : Visibility.Hidden)

          Text(this.currentCountry.name)
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
            .visibility(this.showAnswer ? Visibility.Visible : Visibility.Hidden)
        }
      }
      .width('100%')
      .height(120)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 20, right: 20 })
    }
    .width('100%')
    .height('100%')
    .onClick(async () => {
      await this.handleTap();
    })
  }

  @Builder
  SessionOverView() {
    Column() {
      Text('🎉')
        .fontSize(80)
        .margin({ bottom: 20 })

      Text('本轮完成！')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })

      Text(`已完成 ${this.sessionNumber} 轮`)
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 60 })

      Row() {
        Button('退出')
          .width(120)
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.bg_card'))
          .fontColor($r('app.color.text_primary'))
          .onClick(async () => {
            await this.exitGame();
          })

        Button('继续')
          .width(120)
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.button_primary'))
          .margin({ left: 16 })
          .onClick(async () => {
            await this.continueSession();
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(40)
  }
}

