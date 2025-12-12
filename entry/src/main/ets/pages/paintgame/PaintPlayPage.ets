/**
 * 涂鸦游戏页面
 * 使用Web组件加载HTML涂鸦游戏
 */
import router from '@ohos.router';
import web_webview from '@ohos.web.webview';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import curves from '@ohos.curves';
import { getCountryByCode, Country, getLocalizedCountryName } from '../../utils/countryData';
import { getPaintLevel, getFlagPaintInfo, getTotalLevels, PaintLevel } from './PaintGameData';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil, SoundType } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { LocalizationUtil } from '../../utils/LocalizationUtil';

interface RouterParams {
  categoryId: string;
  levelId: number;
}

// 美国州名中文映射
const US_STATE_NAMES_CN: Record<string, string> = {
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

// 美国州名英文映射
const US_STATE_NAMES_EN: Record<string, string> = {
  'alabama': 'Alabama',
  'alaska': 'Alaska',
  'arizona': 'Arizona',
  'arkansas': 'Arkansas',
  'california': 'California',
  'colorado': 'Colorado',
  'connecticut': 'Connecticut',
  'delaware': 'Delaware',
  'district_of_columbia': 'District of Columbia',
  'florida': 'Florida',
  'georgia': 'Georgia',
  'hawaii': 'Hawaii',
  'idaho': 'Idaho',
  'illinois': 'Illinois',
  'indiana': 'Indiana',
  'iowa': 'Iowa',
  'kansas': 'Kansas',
  'kentucky': 'Kentucky',
  'louisiana': 'Louisiana',
  'maine': 'Maine',
  'maryland': 'Maryland',
  'massachusetts': 'Massachusetts',
  'michigan': 'Michigan',
  'minnesota': 'Minnesota',
  'mississippi': 'Mississippi',
  'missouri': 'Missouri',
  'montana': 'Montana',
  'nebraska': 'Nebraska',
  'nevada': 'Nevada',
  'new_hampshire': 'New Hampshire',
  'new_jersey': 'New Jersey',
  'new_mexico': 'New Mexico',
  'new_york': 'New York',
  'north_carolina': 'North Carolina',
  'north_dakota': 'North Dakota',
  'ohio': 'Ohio',
  'oklahoma': 'Oklahoma',
  'oregon': 'Oregon',
  'pennsylvania': 'Pennsylvania',
  'rhode_island': 'Rhode Island',
  'south_carolina': 'South Carolina',
  'south_dakota': 'South Dakota',
  'tennessee': 'Tennessee',
  'texas': 'Texas',
  'utah': 'Utah',
  'vermont': 'Vermont',
  'virginia': 'Virginia',
  'washington': 'Washington',
  'west_virginia': 'West Virginia',
  'wisconsin': 'Wisconsin',
  'wyoming': 'Wyoming'
};

@Entry
@Component
  struct PaintPlayPage {
  @State categoryId: string = 'world';
  @State levelId: number = 1;
  @State currentLevel: PaintLevel | undefined = undefined;
  @State currentFlagIndex: number = 0;
  @State showNextButton: boolean = false;
  @State showNextButtonAnimated: boolean = false; // 按钮动画状态
  @State showHint: boolean = false;
  @State levelCompleted: boolean = false;
  @State isWebReady: boolean = false;
  @State currentFlagPath: string = 'flags/us.svg';
  @State webOpacity: number = 0; // Web 组件透明度，用于渐显动画
  @State contentTranslateY: number = 0; // 内容向上移动的距离
  @State showButtons: boolean = false; // 按钮是否显示
  @StorageLink('currentLanguage') currentLanguage: string = 'zh';

  private get isEnglish(): boolean {
    return LocalizationUtil.isEnglish(this.currentLanguage);
  }

  private webController: web_webview.WebviewController = new web_webview.WebviewController();
  private context = getContext(this) as common.UIAbilityContext;
  private timeoutIds: number[] = []; // 存储所有setTimeout的ID，用于清理

  async aboutToAppear() {
    // 初始化音效播放器和振动工具
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    const params = router.getParams() as RouterParams;
    if (params) {
      this.categoryId = params.categoryId || 'world';
      this.levelId = params.levelId || 1;
    }
    
    // 检查关卡是否有效
    const totalLevels = getTotalLevels(this.categoryId);
    if (this.levelId > totalLevels) {
      // 关卡超出范围，返回首页
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.level_not_found').id),
        duration: 2000
      });
      setTimeout(() => {
        router.back();
      }, 500);
      return;
    }
    
    this.currentLevel = getPaintLevel(this.categoryId, this.levelId);
    if (!this.currentLevel) {
      // 关卡数据不存在，返回首页
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.level_data_load_failed').id),
        duration: 2000
      });
      setTimeout(() => {
        router.back();
      }, 500);
      return;
    }
    this.updateCurrentFlagPath();
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
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    
    // 先尝试获取美国州名
    if (US_STATE_NAMES_EN[code] || US_STATE_NAMES_CN[code]) {
      // 这是美国州旗，直接返回州名
      if (isEnglish) {
        return US_STATE_NAMES_EN[code];
      } else {
        return US_STATE_NAMES_CN[code];
      }
    }
    
    // 否则尝试获取国家本地化名称
    const country = getCountryByCode(code);
    return country ? getLocalizedCountryName(country, this.currentLanguage) : code;
  }


  private async setupGame(): Promise<void> {
    if (!this.currentLevel || !this.isWebReady) {
      return;
    }

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

    // 调用JS设置游戏
    try {
      const escapedDisplayName = displayName.replace(/'/g, "\\'").replace(/"/g, '\\"');
      const setupGameCode = `if (typeof setupPaintGame === 'function') { setupPaintGame('${countryCode}', '${escapedDisplayName}', ${colorsJson}, '${svgBase64}'); }`;
      await this.webController.runJavaScript(setupGameCode);
    } catch (e) {
      console.error('Failed to setup game:', e);
    }
  }

  private async onNext(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();
    
    this.showNextButton = false;
    this.showNextButtonAnimated = false;
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
      'us': GameType.PAINT_US
    };
    return gameTypeMap[this.categoryId] || GameType.PAINT_WORLD;
  }

  private async onLevelComplete(): Promise<void> {
    // 播放恭喜音效和振动
    await SoundEffectUtil.playCongrats();
    VibratorUtil.vibrateWin();
    
    // 保存进度（防止溢出）
    await GameProgressManager.init(this.context);
    const gameType = this.getGameType();
    const totalLevels = getTotalLevels(this.categoryId);
    
    // 只有在未完成所有关卡时才解锁下一关（防止溢出）
    if (this.levelId < totalLevels) {
      await GameProgressManager.unlockNextLevel(gameType, this.levelId, totalLevels);
    } else {
      // 已完成所有关卡，确保进度不超过总关卡数
      await GameProgressManager.setUnlockedLevel(gameType, totalLevels);
    }

    // 设置完成状态，内容从底部开始（初始位置在屏幕下方）
    this.levelCompleted = true;
    this.contentTranslateY = 200; // 初始位置在屏幕下方200px
    
    // 延迟一帧后触发向上移动动画（从底部向上滑入）
    const id1 = setTimeout(() => {
      animateTo({
        duration: 1200,
        curve: Curve.EaseOut
      }, () => {
        this.contentTranslateY = 0; // 移动到最终位置（原始位置）
      });
      // 移除已执行的定时器ID
      const index1 = this.timeoutIds.indexOf(id1);
      if (index1 > -1) {
        this.timeoutIds.splice(index1, 1);
      }
    }, 50);
    this.timeoutIds.push(id1);

    // 延迟显示按钮（在动画和音效播放后）
    const id2 = setTimeout(() => {
      this.showButtons = true;
      // 移除已执行的定时器ID
      const index2 = this.timeoutIds.indexOf(id2);
      if (index2 > -1) {
        this.timeoutIds.splice(index2, 1);
      }
    }, 1300);
    this.timeoutIds.push(id2);
  }

  private async onNextLevel(): Promise<void> {
    // 播放按钮点击音效和振动
    await SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();
    
    // 重置动画状态
    this.contentTranslateY = 0;
    this.showButtons = false;
    
    const totalLevels = getTotalLevels(this.categoryId);
    
    // 防止关卡溢出
    if (this.levelId >= totalLevels) {
      // 所有关卡完成，返回首页
      router.back();
      return;
    }
    
    // 进入下一关（确保不超过总关卡数）
    const nextLevel = this.levelId + 1;
    if (nextLevel <= totalLevels) {
      this.levelId = nextLevel;
      this.currentLevel = getPaintLevel(this.categoryId, this.levelId);
      if (!this.currentLevel) {
        // 关卡数据不存在，返回首页
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.level_data_load_failed').id),
          duration: 2000
        });
        router.back();
        return;
      }
      this.currentFlagIndex = 0;
      this.levelCompleted = false;
      this.showNextButton = false;
      this.showNextButtonAnimated = false;
      await this.setupGame();
    } else {
      // 所有关卡完成
      router.back();
    }
  }

  private async onHintTapped(): Promise<void> {
    // 播放提示音效和振动
    await SoundEffectUtil.playSound(SoundType.HINT);
    VibratorUtil.vibrateTap();
    this.showHint = !this.showHint;
  }

  private getFlagImagePath(code: string): string {
    // 美国州旗使用 state_flags/us/ 目录
    if (US_STATE_NAMES_CN[code]) {
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
              .backgroundColor($r('app.color.bg_page'))
              .opacity(this.webOpacity)
              .transition(TransitionEffect.OPACITY.animation({ duration: 400, curve: curves.cubicBezier(0.42, 0, 0.58, 1) }))
              .onPageEnd(() => {
                this.isWebReady = true;
                // 等待 HTML 和 JavaScript 函数加载完成
                const id = setTimeout(() => {
                  this.setupGame().then(() => {
                    // 使用动画渐显
                    animateTo({
                      duration: 300,
                      curve: curves.cubicBezier(0.42, 0, 0.58, 1)
                    }, () => {
                      this.webOpacity = 1;
                    });
                  }).catch(() => {
                    // 即使出错也显示
                    animateTo({
                      duration: 300,
                      curve: curves.cubicBezier(0.42, 0, 0.58, 1)
                    }, () => {
                      this.webOpacity = 1;
                    });
                  });
                  // 移除已执行的定时器ID
                  const index = this.timeoutIds.indexOf(id);
                  if (index > -1) {
                    this.timeoutIds.splice(index, 1);
                  }
                }, 150);
                this.timeoutIds.push(id);
              })
              .onConsole((event) => {
                if (event) {
                  console.info('WebConsole:', event.message.getMessage());
                }
                return false;
              })
              .javaScriptProxy({
                object: {
                  onPaintCorrect: async () => {
                    // 播放正确答案音效和振动
                    await SoundEffectUtil.playCorrect();
                    VibratorUtil.vibrateCorrect();
                    // 延迟显示按钮（在音效播放后）
                    this.showNextButton = true;
                    const id1 = setTimeout(() => {
                      this.showNextButtonAnimated = true;
                      // 移除已执行的定时器ID
                      const index1 = this.timeoutIds.indexOf(id1);
                      if (index1 > -1) {
                        this.timeoutIds.splice(index1, 1);
                      }
                    }, 400);
                    this.timeoutIds.push(id1);
                  },
                  onPaintIncorrect: async () => {
                    // 播放错误答案音效和振动
                    await SoundEffectUtil.playIncorrect();
                    VibratorUtil.vibrateIncorrect();
                    // 错误时重置游戏
                    const id2 = setTimeout(() => {
                      this.setupGame();
                      // 移除已执行的定时器ID
                      const index2 = this.timeoutIds.indexOf(id2);
                      if (index2 > -1) {
                        this.timeoutIds.splice(index2, 1);
                      }
                    }, 2000);
                    this.timeoutIds.push(id2);
                  },
                  onPaintSound: async () => {
                    // 播放填色音效
                    await SoundEffectUtil.playSound(SoundType.TAP);
                  }
                },
                name: 'NativeInterface',
                methodList: ['onPaintCorrect', 'onPaintIncorrect', 'onPaintSound'],
                controller: this.webController
              })
              .width('100%')
              .layoutWeight(1)

            // 底部按钮区域（延迟显示）
            if (this.showNextButton) {
              Button(this.currentFlagIndex < (this.currentLevel?.flags.length || 0) - 1 
                ? this.context.resourceManager.getStringSync($r('app.string.next').id)
                : this.context.resourceManager.getStringSync($r('app.string.complete').id))
                .width('80%')
                .height(48)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.button_primary'))
                .margin({ bottom: 32 })
                .opacity(this.showNextButtonAnimated ? 1 : 0)
                .scale({ x: this.showNextButtonAnimated ? 1 : 0.8, y: this.showNextButtonAnimated ? 1 : 0.8 })
                .animation({
                  duration: 300,
                  curve: Curve.EaseOut
                })
                .onClick(async () => {
                  await this.onNext();
                })
            }
          }
          .width('100%')
            .height('100%')
            .backgroundColor($r('app.color.bg_page'))
            .transition(TransitionEffect.OPACITY.animation({ duration: 600, curve: curves.cubicBezier(0.4, 0.0, 0.2, 1.0) }))

          // 顶部状态栏
          Row() {
            // 返回按钮
            Image($r('app.media.icon_back'))
              .width(24)
              .height(24)
              .onClick(async () => {
                await SoundEffectUtil.playButton();
                VibratorUtil.vibrateTap();
                router.back();
              })

            // 关卡信息
            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, this.levelId.toString()))
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
      // 内容区域（从底部向上滑入）
      Column() {
        Text('🎉')
          .fontSize(72)
          .margin({ top: 80 })

        Text($r('app.string.congratulations'))
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 24 })

        Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, this.levelId.toString()))
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
      }
      .width('100%')
        .translate({ y: this.contentTranslateY })
        .animation({
          duration: 1200,
          curve: Curve.EaseOut
        })

      Blank()

      // 按钮区域（延迟显示）
      if (this.showButtons) {
        Column() {
          // 下一关按钮
          Button(this.levelId < getTotalLevels(this.categoryId) 
            ? this.context.resourceManager.getStringSync($r('app.string.next_level').id)
            : this.context.resourceManager.getStringSync($r('app.string.perfect_finish').id))
            .width('80%')
            .height(48)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .backgroundColor($r('app.color.button_primary'))
            .margin({ bottom: 16 })
            .opacity(this.showButtons ? 1 : 0)
            .scale({ x: this.showButtons ? 1 : 0.8, y: this.showButtons ? 1 : 0.8 })
            .animation({
              duration: 300,
              curve: Curve.EaseOut
            })
            .onClick(async () => {
              if (this.levelId < getTotalLevels(this.categoryId)) {
                await this.onNextLevel();
              } else {
                // 完美收官，退出
                await SoundEffectUtil.playButton();
                VibratorUtil.vibrateTap();
                router.back();
              }
            })

          // 返回按钮
          Button(this.context.resourceManager.getStringSync($r('app.string.back').id))
            .width('80%')
            .height(48)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.button_primary'))
            .backgroundColor(Color.Transparent)
            .border({ width: 1, color: $r('app.color.button_primary') })
            .margin({ bottom: 32 })
            .opacity(this.showButtons ? 1 : 0)
            .scale({ x: this.showButtons ? 1 : 0.8, y: this.showButtons ? 1 : 0.8 })
            .animation({
              duration: 300,
              curve: Curve.EaseOut,
              delay: 100
            })
            .onClick(async () => {
              await SoundEffectUtil.playButton();
              VibratorUtil.vibrateTap();
              router.back();
            })
        }
        .width('100%')
      }
    }
    .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
  }
}

