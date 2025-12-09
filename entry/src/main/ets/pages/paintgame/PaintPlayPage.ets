/**
 * 涂鸦游戏页面
 * 使用Web组件加载HTML涂鸦游戏
 */
import router from '@ohos.router';
import web_webview from '@ohos.web.webview';
import common from '@ohos.app.ability.common';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import curves from '@ohos.curves';
import { getCountryByCode, Country } from '../../utils/countryData';
import { getPaintLevel, getFlagPaintInfo, getTotalLevels, PaintLevel } from './PaintGameData';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { PreferencesManager } from '../../utils/PreferencesManager';

interface RouterParams {
  categoryId: string;
  levelId: number;
}

// 美国州名中文映射
const US_STATE_NAMES: Record<string, string> = {
  'alabama': '阿拉巴马州',
  'alaska': '阿拉斯加州',
  'arizona': '亚利桑那州',
  'arkansas': '阿肯色州',
  'california': '加利福尼亚州',
  'colorado': '科罗拉多州',
  'connecticut': '康涅狄格州',
  'delaware': '特拉华州',
  'district_of_columbia': '华盛顿特区',
  'florida': '佛罗里达州',
  'georgia': '佐治亚州',
  'hawaii': '夏威夷州',
  'idaho': '爱达荷州',
  'illinois': '伊利诺伊州',
  'indiana': '印第安纳州',
  'iowa': '艾奥瓦州',
  'kansas': '堪萨斯州',
  'kentucky': '肯塔基州',
  'louisiana': '路易斯安那州',
  'maine': '缅因州',
  'maryland': '马里兰州',
  'massachusetts': '马萨诸塞州',
  'michigan': '密歇根州',
  'minnesota': '明尼苏达州',
  'mississippi': '密西西比州',
  'missouri': '密苏里州',
  'montana': '蒙大拿州',
  'nebraska': '内布拉斯加州',
  'nevada': '内华达州',
  'new_hampshire': '新罕布什尔州',
  'new_jersey': '新泽西州',
  'new_mexico': '新墨西哥州',
  'new_york': '纽约州',
  'north_carolina': '北卡罗来纳州',
  'north_dakota': '北达科他州',
  'ohio': '俄亥俄州',
  'oklahoma': '俄克拉荷马州',
  'oregon': '俄勒冈州',
  'pennsylvania': '宾夕法尼亚州',
  'rhode_island': '罗德岛州',
  'south_carolina': '南卡罗来纳州',
  'south_dakota': '南达科他州',
  'tennessee': '田纳西州',
  'texas': '德克萨斯州',
  'utah': '犹他州',
  'vermont': '佛蒙特州',
  'virginia': '弗吉尼亚州',
  'washington': '华盛顿州',
  'west_virginia': '西弗吉尼亚州',
  'wisconsin': '威斯康星州',
  'wyoming': '怀俄明州'
};

@Entry
@Component
  struct PaintPlayPage {
  @State categoryId: string = 'world';
  @State levelId: number = 1;
  @State currentLevel: PaintLevel | undefined = undefined;
  @State currentFlagIndex: number = 0;
  @State showNextButton: boolean = false;
  @State showHint: boolean = false;
  @State levelCompleted: boolean = false;
  @State isWebReady: boolean = false;
  @State currentFlagPath: string = 'flags/us.svg';
  @State backgroundColorStr: string = '#F5F6F7'; // 默认浅色背景
  @State webOpacity: number = 0; // Web 组件透明度，用于渐显动画

  private webController: web_webview.WebviewController = new web_webview.WebviewController();
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params) {
      this.categoryId = params.categoryId || 'world';
      this.levelId = params.levelId || 1;
    }
    this.currentLevel = getPaintLevel(this.categoryId, this.levelId);
    this.updateCurrentFlagPath();
    await this.updateBackgroundColor();
  }

  private async updateBackgroundColor(): Promise<void> {
    try {
      // 读取保存的主题设置
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const savedColorMode: number = await prefs.get('colorMode', ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
      const colorMode = savedColorMode as ConfigurationConstant.ColorMode;

      let isDarkMode = false;

      if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        // 明确设置为暗黑模式
        isDarkMode = true;
      } else if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
        // 跟随系统，尝试检测系统主题
        // 通过检查资源管理器当前使用的资源类型来判断
        try {
          const resourceManager = this.context.resourceManager;
          const config = await resourceManager.getConfiguration();
          // 如果 colorMode 为 1，表示暗黑模式
          if (config.colorMode === 1) {
            isDarkMode = true;
          }
        } catch (e) {
          // 如果检测失败，默认使用浅色
          console.error(`Failed to detect system theme: ${JSON.stringify(e)}`);
        }
      }

      // 设置背景色
      if (isDarkMode) {
        // 暗黑模式使用深黑色（非纯黑）
        this.backgroundColorStr = '#1C1C1E';
      } else {
        // 浅色模式使用灰色
        this.backgroundColorStr = '#F5F6F7';
      }

      // 如果 Web 已经准备好，立即注入背景色
      if (this.isWebReady) {
        await this.injectBackgroundColor();
      }
    } catch (err) {
      console.error(`Failed to update background color: ${JSON.stringify(err)}`);
      // 默认使用浅色背景
      this.backgroundColorStr = '#F5F6F7';
      if (this.isWebReady) {
        await this.injectBackgroundColor();
      }
    }
  }


  private updateCurrentFlagPath(): void {
    if (this.currentLevel) {
      const code = this.currentLevel.flags[this.currentFlagIndex];
      this.currentFlagPath = this.getFlagImagePath(code);
    }
  }

  private getCurrentCountry(): Country | undefined {
    if (!this.currentLevel) return undefined;
    const code = this.currentLevel.flags[this.currentFlagIndex];
    return getCountryByCode(code);
  }

  private getCurrentFlagColors(): string[] {
    if (!this.currentLevel) return [];
    const code = this.currentLevel.flags[this.currentFlagIndex];
    const info = getFlagPaintInfo(code);
    return info ? info.colors : [];
  }

  private async loadSvgAsBase64(countryCode: string): Promise<string> {
    try {
      const resourceManager = this.context.resourceManager;
      const svgPath = `paint_flags/${countryCode}.svg`;
      const uint8Array = await resourceManager.getRawFileContent(svgPath);
      // 使用 Base64 编码
      const base64Helper = new util.Base64Helper();
      return base64Helper.encodeToStringSync(uint8Array);
    } catch (e) {
      console.error('Failed to load SVG:', e);
      return '';
    }
  }

  private getFlagDisplayName(code: string): string {
    // 先尝试获取美国州名
    if (US_STATE_NAMES[code]) {
      return US_STATE_NAMES[code];
    }
    // 否则尝试获取国家名称
    const country = getCountryByCode(code);
    return country ? country.nameCN : code;
  }

  private async injectBackgroundColor(): Promise<void> {
    try {
      if (!this.isWebReady) {
        return;
      }
      // 直接调用 HTML 中的 setBackgroundColor 函数
      await this.webController.runJavaScript(
        `if (typeof setBackgroundColor === 'function') { setBackgroundColor('${this.backgroundColorStr}'); }`
      );
    } catch (e) {
      console.error('Failed to inject background color:', e);
    }
  }

  private async setupGame(): Promise<void> {
    if (!this.currentLevel || !this.isWebReady) return;

    const countryCode = this.currentLevel.flags[this.currentFlagIndex];
    const colors = this.getCurrentFlagColors();

    if (colors.length === 0) {
      console.error('No colors found for:', countryCode);
      return;
    }

    // 更新当前旗帜路径（用于提示显示）
    this.updateCurrentFlagPath();

    const colorsJson = JSON.stringify(colors);
    const displayName = this.getFlagDisplayName(countryCode);

    // 加载 SVG 内容（Base64 编码）
    const svgBase64 = await this.loadSvgAsBase64(countryCode);

    // 调用JS设置游戏，传入 Base64 编码的 SVG 内容
    try {
      // 先设置背景色
      await this.injectBackgroundColor();
      // 然后设置游戏
      await this.webController.runJavaScript(
        `if (typeof setupPaintGame === 'function') { setupPaintGame('${countryCode}', '${displayName}', ${colorsJson}, '${svgBase64}'); }`
      );
    } catch (e) {
      console.error('Failed to setup game:', e);
    }
  }

  private async onNext(): Promise<void> {
    this.showNextButton = false;
    this.showHint = false;

    if (!this.currentLevel) return;

    if (this.currentFlagIndex < this.currentLevel.flags.length - 1) {
      // 下一个国旗
      this.currentFlagIndex++;
      await this.setupGame();
    } else {
      // 关卡完成
      await this.onLevelComplete();
    }
  }

  private getGameType(): GameType {
    const gameTypeMap: Record<string, GameType> = {
      'world': GameType.PAINT_WORLD,
      'us': GameType.PAINT_US,
      'de': GameType.PAINT_DE,
      'it': GameType.PAINT_IT,
      'br': GameType.PAINT_BR
    };
    return gameTypeMap[this.categoryId] || GameType.PAINT_WORLD;
  }

  private async onLevelComplete(): Promise<void> {
    // 保存进度
    await GameProgressManager.init(this.context);
    const gameType = this.getGameType();
    await GameProgressManager.unlockNextLevel(gameType, this.levelId);

    this.levelCompleted = true;
  }

  private async onNextLevel(): Promise<void> {
    const totalLevels = getTotalLevels(this.categoryId);
    if (this.levelId < totalLevels) {
      this.levelId++;
      this.currentLevel = getPaintLevel(this.categoryId, this.levelId);
      this.currentFlagIndex = 0;
      this.levelCompleted = false;
      this.showNextButton = false;
      await this.setupGame();
    } else {
      // 所有关卡完成
      router.back();
    }
  }

  private onHintTapped(): void {
    this.showHint = !this.showHint;
  }

  private getFlagImagePath(code: string): string {
    // 美国州旗使用 state_flags/us/ 目录
    if (US_STATE_NAMES[code]) {
      return `state_flags/us/${code}.svg`;
    }
    // 其他国旗使用 flags/ 目录
    return `flags/${code}.svg`;
  }

  build() {
    Navigation() {
      if (this.levelCompleted) {
        this.LevelCompleteView()
      } else {
        Stack({ alignContent: Alignment.TopStart }) {
          // Web游戏区域
          Column() {
            Web({
              src: $rawfile('paint_game.html'),
              controller: this.webController
            })
              .javaScriptAccess(true)
              .domStorageAccess(true)
              .opacity(this.webOpacity)
              .onPageEnd(() => {
                this.isWebReady = true;
                // 页面加载完成后，先设置背景色，再设置游戏，然后渐显
                // 先保存背景色到 window，让 HTML 在 DOMContentLoaded 时就能应用
                this.webController.runJavaScript(
                  `window.savedBackgroundColor = '${this.backgroundColorStr}';`
                ).then(() => {
                  return this.injectBackgroundColor();
                }).then(() => {
                  return this.setupGame();
                }).then(() => {
                  // 背景色和游戏都设置好后，延迟一点再渐显，确保背景色已应用
                  setTimeout(() => {
                    this.webOpacity = 1;
                  }, 200);
                }).catch(() => {
                  console.error('Failed to setup game');
                  // 即使出错也显示
                  this.webOpacity = 1;
                });
              })
              .onConsole((event) => {
                if (event) {
                  console.info('WebConsole:', event.message.getMessage());
                }
                return false;
              })
              .javaScriptProxy({
                object: {
                  onPaintCorrect: () => {
                    this.showNextButton = true;
                  },
                  onPaintIncorrect: () => {
                    // 错误时重置游戏
                    setTimeout(() => {
                      this.setupGame();
                    }, 2000);
                  },
                  onPaintSound: () => {
                    // 播放填色音效（可选）
                  }
                },
                name: 'NativeInterface',
                methodList: ['onPaintCorrect', 'onPaintIncorrect', 'onPaintSound'],
                controller: this.webController
              })
              .width('100%')
              .layoutWeight(1)

            // 底部按钮区域
            if (this.showNextButton) {
              Button(this.currentFlagIndex < (this.currentLevel?.flags.length || 0) - 1 ? '下一个' : '完成')
                .width('80%')
                .height(48)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .margin({ bottom: 32 })
                .onClick(() => {
                  this.onNext();
                })
            }
          }
          .width('100%')
            .height('100%')
            .backgroundColor(this.backgroundColorStr as ResourceColor)
            .transition(TransitionEffect.OPACITY.animation({ duration: 600, curve: curves.cubicBezier(0.4, 0.0, 0.2, 1.0) }))

          // 顶部状态栏
          Row() {
            // 返回按钮
            Image($r('app.media.icon_back'))
              .width(24)
              .height(24)
              .onClick(() => {
                router.back();
              })

            // 关卡信息
            Column() {
              Text(`第 ${this.levelId} 关`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.button_primary'))

              // 进度指示器
              Row({ space: 4 }) {
                ForEach(Array.from({ length: this.currentLevel?.flags.length || 3 }), (_: undefined, index: number) => {
                  Circle()
                    .width(8)
                    .height(8)
                    .fill(index <= this.currentFlagIndex ? '#1677FF' : '#B3E5FC')
                })
              }
              .margin({ top: 4 })
            }
            .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)

            // 提示按钮
            Image($r('app.media.icon_hint'))
              .width(24)
              .height(24)
              .onClick(() => {
                this.onHintTapped();
              })
          }
          .width('100%')
            .height(56)
            .padding({ left: 16, right: 16 })
            .backgroundColor(Color.Transparent)

          // 提示国旗显示
          if (this.showHint) {
            Column() {
              Image($rawfile(this.currentFlagPath))
                .width(140)
                .height(90)
                .objectFit(ImageFit.Contain)
            }
            .width(160)
              .height(110)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .shadow({
                radius: 8,
                color: 'rgba(0, 0, 0, 0.2)',
                offsetX: 0,
                offsetY: 3
              })
              .position({ x: '50%', y: 70 })
              .translate({ x: '-50%' })
          }
        }
        .width('100%')
          .height('100%')
      }
    }
    .hideTitleBar(true)
      .hideBackButton(true)
  }

  @Builder
  LevelCompleteView() {
    Column() {
      Text('🎉')
        .fontSize(72)
        .margin({ top: 80 })

      Text('恭喜过关！')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 24 })

      Text(`第 ${this.levelId} 关`)
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 8 })

      // 完成的国旗展示
      Row({ space: 12 }) {
        ForEach(this.currentLevel?.flags || [], (code: string) => {
          Image($rawfile(this.getFlagImagePath(code)))
            .width(80)
            .height(50)
            .objectFit(ImageFit.Contain)
            .shadow({
              radius: 4,
              color: 'rgba(0, 0, 0, 0.1)',
              offsetX: 0,
              offsetY: 2
            })
        })
      }
      .margin({ top: 32 })

      Blank()

      // 下一关按钮
      Button(this.levelId < getTotalLevels(this.categoryId) ? '下一关' : '返回')
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.button_primary'))
        .margin({ bottom: 16 })
        .onClick(() => {
          this.onNextLevel();
        })

      // 返回按钮
      Button('返回')
        .width('80%')
        .height(48)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .backgroundColor(Color.Transparent)
        .border({ width: 1, color: $r('app.color.button_primary') })
        .margin({ bottom: 32 })
        .onClick(() => {
          router.back();
        })
    }
    .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
  }
}

