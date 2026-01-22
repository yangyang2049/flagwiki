import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
import router from '@ohos.router';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

// 总关卡数
const QUIZ_TOTAL_LEVELS = 10;
const FAKE_FLAG_TOTAL_LEVELS = 10;
const INPUT_TOTAL_LEVELS = 39;
const TRIVIA_TOTAL_LEVELS = 10;

interface ChallengeProgress {
  name: string;
  emoji: string;
  current: number;
  total: number;
  color: Resource;
}

@Component
export struct ProfilePage {
  @State colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @State showThemeDialog: boolean = false;
  @State vibrationEnabled: boolean = true; // 振动反馈开关，默认启用
  @Prop @Watch('onRefreshKeyChanged') refreshKey: number = 0;
  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  // 游戏进度状态
  @State quizLevel: number = 1;
  @State fakeFlagLevel: number = 1;
  @State inputLevel: number = 1;
  @State triviaLevel: number = 1;

  async aboutToAppear() {
    await this.loadColorMode();
    await this.loadGameProgress();
    await this.loadVibrationPreference();
    await VibratorUtil.init(this.context);
  }

  private onRefreshKeyChanged(): void {
    this.loadColorMode();
    this.loadGameProgress();
    this.loadVibrationPreference();
  }

  private async loadGameProgress(): Promise<void> {
    try {
      // 使用 GameProgressManager 统一读取进度
      await GameProgressManager.init(this.context);
      this.quizLevel = await GameProgressManager.getUnlockedLevel(GameType.QUIZ);
      this.fakeFlagLevel = await GameProgressManager.getUnlockedLevel(GameType.FAKE_FLAG);
      this.inputLevel = await GameProgressManager.getUnlockedLevel(GameType.INPUT);
      this.triviaLevel = await GameProgressManager.getUnlockedLevel(GameType.TRIVIA);
    } catch (err) {
      console.error(`Failed to load game progress: ${JSON.stringify(err)}`);
    }
  }

  private async loadColorMode(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      const saved: number = await this.prefs.get('colorMode', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
      this.colorMode = saved as ConfigurationConstant.ColorMode;
      this.applyColorMode();
    } catch (err) {
      console.error(`Failed to load color mode: ${JSON.stringify(err)}`);
    }
  }

  private async saveColorMode(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('colorMode', this.colorMode);
      await this.prefs.flush();
      this.applyColorMode();
    } catch (err) {
      console.error(`Failed to save color mode: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: '保存失败',
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private applyColorMode(): void {
    try {
      this.context.getApplicationContext().setColorMode(this.colorMode);
    } catch (err) {
      console.error(`Failed to apply color mode: ${JSON.stringify(err)}`);
    }
  }

  private showThemeSettings(): void {
    this.showThemeDialog = true;
  }

  private getThemeText(): string {
    switch (this.colorMode) {
      case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
        return '浅色';
      case ConfigurationConstant.ColorMode.COLOR_MODE_DARK:
        return '深色';
      case ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET:
      default:
        return '跟随系统';
    }
  }

  private async loadVibrationPreference(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean;
    } catch (err) {
      console.error(`Failed to load vibration preference: ${JSON.stringify(err)}`);
      this.vibrationEnabled = true; // 默认启用
    }
  }

  private async saveVibrationPreference(enabled: boolean): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await PreferencesManager.getPreferences('app_settings');
      }
      await this.prefs.put('vibration_enabled', enabled);
      await this.prefs.flush();
      this.vibrationEnabled = enabled;
      await VibratorUtil.setEnabled(enabled);
    } catch (err) {
      console.error(`Failed to save vibration preference: ${JSON.stringify(err)}`);
    }
  }

  private showAboutApp(): void {
    try {
      promptAction.showDialog({
        title: '关于应用',
        message: '国旗小百科 v1.1.0\n\n一款有趣的国旗知识应用，带你探索世界各国国旗的故事与历史。',
        buttons: [
          { text: '确定', color: $r('app.color.button_primary') }
        ]
      }).then(() => {
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private showFeedback(): void {
    try {
      promptAction.showDialog({
        title: '意见反馈',
        message: '如有建议或问题，可通过应用商店评论，或者发邮件到 ssz2048@163.com 反馈。感谢您的支持。',
        buttons: [
          { text: '好的', color: $r('app.color.button_primary') }
        ]
      }).then(() => {
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async shareApp(): Promise<void> {
    try {
      const bundleName = 'com.douhua.flag';
      const appGalleryUrl = `https://appgallery.huawei.com/app/detail?id=${bundleName}&channelId=SHARE&source=appshare`;
      const shareText = `国旗小百科 - 一款有趣的国旗知识应用，带你探索世界各国国旗的故事与历史。\n\n下载链接：${appGalleryUrl}`;

      const shareData: systemShare.SharedData = new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.TEXT,
        content: shareText,
        title: '国旗小百科',
        description: '探索世界国旗的奥秘'
      });

      const controller: systemShare.ShareController = new systemShare.ShareController(shareData);

      await controller.show(this.context, {
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DEFAULT
      });

      console.info('Share panel opened successfully');
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to share: code: ${error?.code}, message: ${error?.message}`);
      try {
        promptAction.showToast({
          message: '分享失败',
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private async rateApp(): Promise<void> {
    const bundleName = 'com.douhua.flag';
    try {
      const want: Want = {
        action: 'ohos.want.action.viewData',
        uri: `appmarket://details?id=${bundleName}`
      };

      try {
        await this.context.startAbility(want);
      } catch (err) {
        try {
          const fallbackWant: Want = {
            action: 'ohos.want.action.viewData',
            bundleName: 'com.huawei.appmarket',
            uri: `appmarket://details?id=${bundleName}`
          };
          await this.context.startAbility(fallbackWant);
        } catch (fallbackErr) {
          console.error(`Failed to open app market: ${JSON.stringify(fallbackErr)}`);
          promptAction.showToast({
            message: '无法打开应用市场，请手动前往应用市场评分',
            duration: 2000
          });
        }
      }
    } catch (err) {
      console.error(`Failed to open app market: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: '无法打开应用市场',
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private getTotalCompletedLevels(): number {
    return (this.quizLevel - 1) + (this.fakeFlagLevel - 1) + (this.inputLevel - 1) + (this.triviaLevel - 1);
  }


  private getTotalLevels(): number {
    return QUIZ_TOTAL_LEVELS + FAKE_FLAG_TOTAL_LEVELS + INPUT_TOTAL_LEVELS + TRIVIA_TOTAL_LEVELS;
  }

  private getChallengeProgressList(): ChallengeProgress[] {
    return [
      {
        name: '国旗猜猜',
        emoji: '🎯',
        current: this.quizLevel - 1,
        total: QUIZ_TOTAL_LEVELS,
        color: $r('app.color.button_primary')
      },
      {
        name: '假旗找茬',
        emoji: '🔍',
        current: this.fakeFlagLevel - 1,
        total: FAKE_FLAG_TOTAL_LEVELS,
        color: $r('app.color.color_green')
      },
      {
        name: '拼写挑战',
        emoji: '⌨️',
        current: this.inputLevel - 1,
        total: INPUT_TOTAL_LEVELS,
        color: $r('app.color.color_orange')
      },
      {
        name: '知识问答',
        emoji: '🧩',
        current: this.triviaLevel - 1,
        total: TRIVIA_TOTAL_LEVELS,
        color: $r('app.color.color_purple')
      }
    ];
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          Column() {
            // 统计 Banner
            Column() {
              // 顶部总览
              Row() {
                Column() {
                  Text('🏆')
                    .fontSize(40)
                }
                .width(64)
                  .height(64)
                  .backgroundColor($r('app.color.bg_yellow_light'))
                  .borderRadius(32)
                  .justifyContent(FlexAlign.Center)

                Column() {
                  Text('探索进度')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))

                  Row() {
                    Text(`已完成 `)
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                    Text(`${this.getTotalCompletedLevels()}`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.button_primary'))
                    Text(` / ${this.getTotalLevels()} 关`)
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                  .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                  .margin({ left: 16 })
              }
              .width('100%')
                .margin({ bottom: 20 })

              // 各项进度
              ForEach(this.getChallengeProgressList(), (game: ChallengeProgress) => {
                Row() {
                  Text(game.emoji)
                    .fontSize(20)
                    .width(32)

                  Text(game.name)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .width(72)

                  // 进度条
                  Stack({ alignContent: Alignment.Start }) {
                    // 背景
                    Row()
                      .width('100%')
                      .height(8)
                      .backgroundColor($r('app.color.bg_secondary'))
                      .borderRadius(4)

                    // 进度
                    Row()
                      .width(`${(game.current / game.total) * 100}%`)
                      .height(8)
                      .backgroundColor(game.color)
                      .borderRadius(4)
                  }
                  .layoutWeight(1)
                    .margin({ left: 12, right: 12 })

                  Text(`${game.current}/${game.total}`)
                    .fontSize(13)
                    .fontColor($r('app.color.text_tertiary'))
                    .width(50)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
                  .margin({ bottom: 12 })
              })
            }
            .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(16)
              .margin({ top: 16 })

            // 我的收藏
            Column() {
              this.settingItem($r('app.media.icon_favorite'), '我的收藏', '', () => {
                router.pushUrl({ url: 'pages/profile/FavoritesPage' })
                  .catch((err: Error) => {
                    console.error(`Failed to navigate to FavoritesPage: ${err.message}`);
                  });
              })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 16, bottom: 0 })

            // 设置项
            Column() {
              this.settingItemWithValue($r('app.media.icon_theme'), '深色模式', () => this.getThemeText(), () => {
                this.showThemeSettings();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItemWithToggle($r('app.media.icon_vibration'), '振动反馈', this.vibrationEnabled, (enabled: boolean) => {
                this.saveVibrationPreference(enabled);
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_star'), '应用评分', '', () => {
                this.rateApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_share'), '分享应用', '', () => {
                this.shareApp();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_feedback'), '意见反馈', '', () => {
                this.showFeedback();
              })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              Divider()
                .strokeWidth(0.5)
                .color($r('app.color.gray_border'))
                .margin({ left: 16, right: 16 })
              this.settingItem($r('app.media.icon_about'), '关于应用', '', () => {
                this.showAboutApp();
              })
            }
            .width('100%')
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius(12)
              .margin({ top: 12, bottom: 0 })

            // 应用信息
            Text($r('app.string.profile_watch_launched'))
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .textAlign(TextAlign.Center)
              .margin({ top: 40, bottom: 40 })
          }
          .width('100%')
            .constraintSize({ maxWidth: getContentMaxWidth() })
            .padding({ left: 20, right: 20, bottom: 16 })
        }
        .width('100%')
          .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .focusable(true)
      .defaultFocus(true)

      // 主题设置对话框
      if (this.showThemeDialog) {
        this.ThemeDialog()
      }
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  settingItem(icon: Resource, title: string, value: string, onClick?: () => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      if (value !== '') {
        Row() {
          Text(value)
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
          Text('›')
            .fontSize(20)
            .fontColor($r('app.color.gray_disabled'))
            .margin({ left: 8 })
        }
      } else {
        Text('›')
          .fontSize(20)
          .fontColor($r('app.color.gray_disabled'))
      }
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        if (onClick) {
          onClick();
        }
      })
  }

  @Builder
  settingItemWithValue(icon: Resource, title: string, valueGetter: () => string, onClick?: () => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      if (valueGetter() !== '') {
        Row() {
          Text(valueGetter())
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('›')
            .fontSize(20)
            .fontColor($r('app.color.gray_disabled'))
            .margin({ left: 8 })
        }
      } else {
        Text('›')
          .fontSize(20)
          .fontColor($r('app.color.gray_disabled'))
      }
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        if (onClick) {
          onClick();
        }
      })
  }

  @Builder
  settingItemWithToggle(icon: Resource, title: string, enabled: boolean, onToggle: (enabled: boolean) => void) {
    Row() {
      Row() {
        Image(icon)
          .width(16)
          .height(16)
          .margin({ right: 12 })
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .selectedColor($r('app.color.button_primary'))
        .switchPointColor($r('app.color.white'))
        .onChange((isOn: boolean) => {
          onToggle(isOn);
        })
    }
    .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
  }

  @Builder
  ThemeDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.showThemeDialog = false;
        })

      // 对话框
      Column() {
        Text('深色模式')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 20 })

        this.ThemeOption('跟随系统', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
        this.ThemeOption('浅色', ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
        this.ThemeOption('深色', ConfigurationConstant.ColorMode.COLOR_MODE_DARK)

        Button('确定')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.white'))
          .fontSize(16)
          .width('100%')
          .height(48)
          .borderRadius(8)
          .margin({ top: 20 })
          .onClick(async () => {
            await this.saveColorMode();
            this.showThemeDialog = false;
          })
      }
      .width('80%')
        .constraintSize({ maxWidth: 320 })
        .padding({ left: 24, right: 24, top: 24, bottom: 24 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(16)
        .shadow({
          radius: 20,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  ThemeOption(label: string, value: ConfigurationConstant.ColorMode) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)

      if (this.colorMode === value) {
        Text('✓')
          .fontSize(18)
          .fontColor($r('app.color.button_primary'))
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
      .padding({ top: 16, bottom: 16, left: 16, right: 16 })
      .borderRadius(8)
      .backgroundColor(this.colorMode === value ? $r('app.color.bg_blue_light') : $r('app.color.bg_secondary'))
      .margin({ bottom: 12 })
      .onClick(() => {
        this.colorMode = value;
      })
  }
}
