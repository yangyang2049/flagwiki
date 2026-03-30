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
import { getCountryStateData, StateInfo } from '../../utils/StateFlagData';
import { getPaintLevel, getFlagPaintInfo, getTotalLevels, PaintLevel } from './PaintGameData';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { PreferencesManager } from '../../utils/PreferencesManager';
import { SoundEffectUtil, SoundType } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { LocalizationUtil } from '../../utils/LocalizationUtil';
import fs from '@ohos.file.fs';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import UiConstants from '../../utils/UiConstants';
import { FlagSvgAssets } from '../../utils/FlagSvgAssets';
import { getStateFlagImageResource, isStateFlagsModuleReady } from '../../utils/RegionAssetsUtil';
import { MODULE_STATE_FLAGS, refreshOptionalModuleStatus } from '../../utils/OptionalModuleHelper';

interface RouterParams {
  categoryId: string;
  levelId: number;
}

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

    await refreshOptionalModuleStatus(MODULE_STATE_FLAGS);
    if (this.categoryId === 'us' && !isStateFlagsModuleReady()) {
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.optional_module_missing_message').id,
          this.context.resourceManager.getStringSync($r('app.string.optional_module_state_flags_title').id)),
        duration: 2500
      });
      setTimeout(() => {
        router.back();
      }, 400);
      return;
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

    if (this.levelId === 1) {
      const tutorialTimer = setTimeout((): void => {
        void this.maybeShowPaintTutorialFirstLevel();
      }, 450);
      this.timeoutIds.push(tutorialTimer);
    }
  }

  /** 第一关首次进入时弹出玩法说明（按分类分别记录） */
  private async maybeShowPaintTutorialFirstLevel(): Promise<void> {
    if (this.levelId !== 1) {
      return;
    }
    try {
      const prefs = await PreferencesManager.getPreferences('app_settings');
      const prefKey = `paint_howto_seen_${this.categoryId}`;
      const seen = await prefs.get(prefKey, false) as boolean;
      if (seen) {
        return;
      }
      const rm = this.context.resourceManager;
      const msg = [
        rm.getStringSync($r('app.string.paint_instruction_1').id),
        rm.getStringSync($r('app.string.paint_instruction_2').id),
        rm.getStringSync($r('app.string.paint_instruction_3').id),
        rm.getStringSync($r('app.string.paint_instruction_4').id)
      ].join('\n\n');
      promptAction.showDialog({
        title: rm.getStringSync($r('app.string.paint_instructions_title').id),
        message: msg,
        buttons: [
          { text: rm.getStringSync($r('app.string.got_it').id), color: $r('app.color.button_primary') }
        ]
      }).then(async () => {
        await prefs.put(prefKey, true);
        await prefs.flush();
      }).catch((err: Error) => {
        console.error(`[PaintPlayPage] tutorial dialog: ${err.message}`);
      });
    } catch (e) {
      console.error(`[PaintPlayPage] maybeShowPaintTutorialFirstLevel: ${JSON.stringify(e)}`);
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
      const path = FlagSvgAssets.getPaintFlagFilePath(countryCode);
      const stat = fs.statSync(path);
      const handle = fs.openSync(path, fs.OpenMode.READ_ONLY);
      const buf = new ArrayBuffer(stat.size);
      fs.readSync(handle.fd, buf);
      fs.closeSync(handle);
      const uint8Array = new Uint8Array(buf);
      const base64Helper = new util.Base64Helper();
      return base64Helper.encodeToStringSync(uint8Array);
    } catch (e) {
      console.error('Failed to load SVG:', e);
      return '';
    }
  }

  private getFlagDisplayName(code: string): string {
    const isEnglish = LocalizationUtil.isEnglish(this.currentLanguage);
    const rm = this.context.resourceManager;
    
    // 先尝试从资源文件获取州名（适用于美国州）
    const stateKey = `state_${code}`;
    try {
      const stateName = rm.getStringSync($r(`app.string.${stateKey}`).id);
      return stateName;
    } catch (e) {
      // 如果资源查找失败，尝试从 StateFlagData 获取州名
      // 检查是否为美国州旗（涂鸦游戏中的美国州代码格式）
      const usStateData = getCountryStateData('us');
      if (usStateData) {
        // 将代码格式转换为 StateFlagData 中的格式
        // 例如：california -> California, new_york -> New York, district_of_columbia -> District of Columbia
        const words = code.split('_');
        const normalizedCode = words.map((word: string) => 
          word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
        ).join(' ');
        
        // 查找匹配的州信息（不区分大小写）
        const stateInfo = usStateData.states.find((s: StateInfo) => 
          s.code.toLowerCase() === normalizedCode.toLowerCase()
        );
        if (stateInfo) {
          return isEnglish ? stateInfo.name : stateInfo.nameCN;
        }
        
        // 如果找不到，可能是 District of Columbia（在 StateFlagData 中可能不存在）
        // 尝试使用资源文件中的 fallback
        if (code === 'district_of_columbia') {
          // District of Columbia 可能不在 StateFlagData 中，返回资源文件中的值或英文名称
          return isEnglish ? 'District of Columbia' : '华盛顿特区';
        }
      }
      
      // 如果不是州旗，则尝试获取国家本地化名称
      const country = getCountryByCode(code);
      return country ? getLocalizedCountryName(country, this.currentLanguage) : code;
    }
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

  /** 关卡内任意国旗 code：州旗动态模块优先，否则解压后的 paint_flags / flags */
  private getCompletionFlagImageSrc(code: string): string | Resource {
    if (this.categoryId === 'us') {
      if (isStateFlagsModuleReady()) {
        const modRes = getStateFlagImageResource('us', code);
        if (modRes !== null) {
          return modRes;
        }
      }
      return FlagSvgAssets.getPaintFlagFileUri(code);
    }
    return FlagSvgAssets.getUriForRelativePath(`flags/${code}.svg`);
  }

  private getHintFlagImageSrc(): string | Resource {
    const code = this.currentLevel?.flags[this.currentFlagIndex] ?? '';
    return this.getCompletionFlagImageSrc(code);
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          if (this.levelCompleted) {
            this.LevelCompleteView()
          } else {
            // Core elements container - limited to 600vp width
            Column() {
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
                  .position({ x: 0, y: 0 })

                // 提示国旗显示
                if (this.showHint) {
                  Column() {
                    Image(this.getHintFlagImageSrc())
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

                // 浮动按钮区域（延迟显示）
                if (this.showNextButton) {
                  Button(this.currentFlagIndex < (this.currentLevel?.flags.length || 0) - 1
                    ? this.context.resourceManager.getStringSync($r('app.string.next').id)
                    : this.context.resourceManager.getStringSync($r('app.string.complete').id))
                    .constraintSize({ minWidth: 320 })
                    .height(48)
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor($r('app.color.button_primary'))
                    .opacity(this.showNextButtonAnimated ? 1 : 0)
                    .scale({ x: this.showNextButtonAnimated ? 1 : 0.8, y: this.showNextButtonAnimated ? 1 : 0.8 })
                    .animation({
                      duration: 300,
                      curve: Curve.EaseOut
                    })
                    .onClick(async () => {
                      await this.onNext();
                    })
                    .position({ x: '50%', y: '100%' })
                    .translate({ x: '-50%', y: '-100%' })
                    .margin({ bottom: 32 })
                    .shadow({
                      radius: 8,
                      color: 'rgba(0, 0, 0, 0.2)',
                      offsetX: 0,
                      offsetY: 2
                    })
                }
              }
              .width('100%')
              .height('100%')
            }
            .height('100%')
            .constraintSize({ maxWidth: 600 })
          }
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .mode(NavigationMode.Stack)
  }

  @Builder
  LevelCompleteView() {
    Column() {
      // 内容区域（从底部向上滑入）
      Column() {
        Text(UiConstants.CELEBRATION)
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
            Image(this.getCompletionFlagImageSrc(code))
              .width(80)
              .height(50)
              .objectFit(ImageFit.Contain)
              .shadow({
                radius: 4,
                color: 'rgba(0, 0, 0, 0.1)',
                offsetX: 0,
                offsetY: 2
              })
          }, (code: string) => code)
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
            .constraintSize({ minWidth: 320 })
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
            .onClick(() => {
              if (this.levelId < getTotalLevels(this.categoryId)) {
                this.onNextLevel();
              } else {
                // 完美收官，退出
                SoundEffectUtil.playButton();
                VibratorUtil.vibrateTap();
                router.back();
              }
            })

          // 返回按钮
          Button(this.context.resourceManager.getStringSync($r('app.string.back').id))
            .constraintSize({ minWidth: 320 })
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
            .onClick(() => {
              SoundEffectUtil.playButton();
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
