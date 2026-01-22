import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import { getCountryByCode, getFlagImageSource } from '../../utils/countryData';
import { ConnectionsLevel, getConnectionsLevel, FlagGroup, FlagTile, getLocalizedTheme, getTotalConnectionsLevels } from './ConnectionsLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

interface RouterParams {
  levelId: number;
}

@Entry
@Component
struct ConnectionsPlayPage {
  @State level: ConnectionsLevel | undefined = undefined;
  @State allFlags: FlagTile[] = [];
  @State groups: FlagGroup[] = [];
  @State selectedCountryCodes: string[] = [];
  @State errorMessage: string | null = null;
  @State showNextButton: boolean = false;
  @State hintGroupCodes: string[] = [];
  @State showGroups: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private timeoutIds: number[] = [];
  private hasShownToast: boolean = false;

  async aboutToAppear() {
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    const params = router.getParams() as RouterParams;
    if (params) {
      const levelId = params.levelId || 1;
      this.loadLevel(levelId);
    }
  }

  aboutToDisappear() {
    this.clearAllTimeouts();
    SoundEffectUtil.release();
  }

  private clearAllTimeouts(): void {
    for (const id of this.timeoutIds) {
      clearTimeout(id);
    }
    this.timeoutIds = [];
  }

  private loadLevel(levelId: number): void {
    this.clearAllTimeouts();
    this.level = getConnectionsLevel(levelId);
    if (this.level) {
      // 复制并打乱国旗列表
      const flagsCopy: FlagTile[] = [];
      for (let i = 0; i < this.level.flags.length; i++) {
        flagsCopy.push(this.level.flags[i]);
      }
      this.allFlags = this.shuffleArray(flagsCopy);
      // 复制分组并重置状态
      const groupsCopy: FlagGroup[] = [];
      for (let i = 0; i < this.level.groups.length; i++) {
        const group = this.level.groups[i];
        const newGroup: FlagGroup = {
          countryCodes: group.countryCodes,
          theme: group.theme,
          isSolved: false,
          solvedAt: undefined
        };
        groupsCopy.push(newGroup);
      }
      this.groups = groupsCopy;
      this.selectedCountryCodes = [];
      this.errorMessage = null;
      this.showNextButton = false;
      this.hintGroupCodes = [];
      this.showGroups = false;

      // 显示提示 toast（顶部显示，仅第一次）
      if (!this.hasShownToast) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.connections_hint').id),
          duration: 3000,
          bottom: '80%'
        });
        this.hasShownToast = true;
      }

      // 2秒后显示已解分组
      const id = setTimeout(() => {
        this.showGroups = true;
        const index = this.timeoutIds.indexOf(id);
        if (index > -1) {
          this.timeoutIds.splice(index, 1);
        }
      }, 2000);
      this.timeoutIds.push(id);
    }
  }

  private shuffleArray<T>(array: T[]): T[] {
    const shuffled: T[] = [];
    for (let i = 0; i < array.length; i++) {
      shuffled.push(array[i]);
    }
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  private getSolvedGroups(): FlagGroup[] {
    return this.groups
      .filter(g => g.isSolved)
      .sort((a, b) => (a.solvedAt || 0) - (b.solvedAt || 0));
  }

  private getUnsolvedGroups(): FlagGroup[] {
    return this.groups.filter(g => !g.isSolved);
  }

  private getUnusedFlags(): FlagTile[] {
    const usedCodes = new Set<string>();
    this.getSolvedGroups().forEach(group => {
      group.countryCodes.forEach(code => usedCodes.add(code));
    });
    return this.allFlags.filter(flag => !usedCodes.has(flag.countryCode));
  }

  private isGameCompleted(): boolean {
    return this.groups.every(g => g.isSolved);
  }

  private selectFlag(countryCode: string): void {
    SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    const index = this.selectedCountryCodes.indexOf(countryCode);
    if (index > -1) {
      // 取消选择
      this.selectedCountryCodes.splice(index, 1);
    } else if (this.selectedCountryCodes.length < 4) {
      // 选择
      this.selectedCountryCodes.push(countryCode);
    }
    this.errorMessage = null;
  }

  private clearSelection(): void {
    if (this.selectedCountryCodes.length > 0) {
      SoundEffectUtil.playButton();
      VibratorUtil.vibrateTap();
      this.selectedCountryCodes = [];
      this.errorMessage = null;
    }
  }

  private shuffleFlags(): void {
    SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    // 获取未解决的国旗
    const unsolvedFlags = this.getUnusedFlags();
    const shuffled = this.shuffleArray(unsolvedFlags);

    // 重新构建 allFlags，保持已解决国旗的位置
    const newAllFlags: FlagTile[] = [];
    const solvedCodes = new Set<string>();
    this.getSolvedGroups().forEach(group => {
      group.countryCodes.forEach(code => solvedCodes.add(code));
    });

    let shuffledIndex = 0;
    for (const flag of this.allFlags) {
      if (solvedCodes.has(flag.countryCode)) {
        newAllFlags.push(flag);
      } else {
        newAllFlags.push(shuffled[shuffledIndex++]);
      }
    }

    this.allFlags = newAllFlags;
  }

  private async submitSelection(): Promise<void> {
    if (this.selectedCountryCodes.length !== 4) return;

    SoundEffectUtil.playButton();

    // 查找匹配的分组
    const matchingGroup = this.groups.find(group =>
      this.listEqualsIgnoreOrder(group.countryCodes, this.selectedCountryCodes)
    );

    if (matchingGroup && !matchingGroup.isSolved) {
      // 正确分组
      matchingGroup.isSolved = true;
      matchingGroup.solvedAt = Date.now();

      // 触发 UI 更新：重新赋值整个 groups 数组
      this.groups = [...this.groups];

      this.selectedCountryCodes = [];
      this.errorMessage = null;

      // 如果有已解分组，立即显示已解分组区域
      if (this.getSolvedGroups().length > 0) {
        this.showGroups = true;
      }

      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();

      // 检查是否完成
      if (this.isGameCompleted()) {
        const id = setTimeout(async () => {
          await SoundEffectUtil.playCongrats();
          VibratorUtil.vibrateWin();
          this.showNextButton = true;
          const index = this.timeoutIds.indexOf(id);
          if (index > -1) {
            this.timeoutIds.splice(index, 1);
          }
        }, 1200);
        this.timeoutIds.push(id);
      }
    } else {
      // 错误分组
      this.errorMessage = this.context.resourceManager.getStringSync($r('app.string.try_again').id);
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();

      // 3秒后清除错误信息
      const id = setTimeout(() => {
        this.errorMessage = null;
        const index = this.timeoutIds.indexOf(id);
        if (index > -1) {
          this.timeoutIds.splice(index, 1);
        }
      }, 3000);
      this.timeoutIds.push(id);
    }
  }

  private listEqualsIgnoreOrder(a: string[], b: string[]): boolean {
    const aSorted = [...a].sort();
    const bSorted = [...b].sort();
    return aSorted.join(',') === bSorted.join(',');
  }

  private useHint(): void {
    const unsolvedGroups = this.getUnsolvedGroups();
    if (unsolvedGroups.length === 0) return;

    SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    // 随机选择一个未解分组
    const randomGroup = unsolvedGroups[Math.floor(Math.random() * unsolvedGroups.length)];
    const hintCodes: string[] = [];
    for (let i = 0; i < randomGroup.countryCodes.length; i++) {
      hintCodes.push(randomGroup.countryCodes[i]);
    }
    this.hintGroupCodes = hintCodes;

    // 3秒后取消高亮
    const id = setTimeout(() => {
      this.hintGroupCodes = [];
      const index = this.timeoutIds.indexOf(id);
      if (index > -1) {
        this.timeoutIds.splice(index, 1);
      }
    }, 3000);
    this.timeoutIds.push(id);
  }

  private useSolve(): void {
    const unsolvedGroups = this.getUnsolvedGroups();
    if (unsolvedGroups.length === 0) return;

    SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    // 自动解答所有未解分组
    const now = Date.now();
    unsolvedGroups.forEach(group => {
      group.isSolved = true;
      group.solvedAt = now;
    });

    // 触发 UI 更新：重新赋值整个 groups 数组
    this.groups = [...this.groups];
    this.showGroups = true;

    SoundEffectUtil.playSuccess();
    VibratorUtil.vibrateWin();

    // 等待2秒后显示Next按钮
    const id = setTimeout(() => {
      this.showNextButton = true;
      const index = this.timeoutIds.indexOf(id);
      if (index > -1) {
        this.timeoutIds.splice(index, 1);
      }
    }, 2000);
    this.timeoutIds.push(id);
  }

  private async handleNextLevel(): Promise<void> {
    SoundEffectUtil.playButton();
    VibratorUtil.vibrateTap();

    if (this.level) {
      // 更新游戏进度
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.CONNECTIONS, this.level.id);

      // 检查是否是最后一关
      const totalLevels = getTotalConnectionsLevels();
      if (this.level.id >= totalLevels) {
        promptAction.showToast({
          message: this.context.resourceManager.getStringSync($r('app.string.congratulations').id),
          duration: 2000
        });
        router.back();
        return;
      }

      // 直接加载下一关
      this.loadLevel(this.level.id + 1);
    }
  }

  private isFlagSelected(countryCode: string): boolean {
    for (let i = 0; i < this.selectedCountryCodes.length; i++) {
      if (this.selectedCountryCodes[i] === countryCode) {
        return true;
      }
    }
    return false;
  }

  private isFlagHintHighlighted(countryCode: string): boolean {
    for (let i = 0; i < this.hintGroupCodes.length; i++) {
      if (this.hintGroupCodes[i] === countryCode) {
        return true;
      }
    }
    return false;
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          // 关卡标题
            Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 0).toString()))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 12, bottom: 8 })

            // 错误提示
            if (this.errorMessage) {
              Row() {
                Text('✗')
                  .fontSize(16)
                  .fontColor(Color.White)
                  .margin({ right: 8 })
                Text(this.errorMessage)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
              }
              .width('100%')
              .padding({ top: 12, bottom: 12, left: 16, right: 16 })
              .backgroundColor('#DC2626')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .margin({ left: 16, right: 16, top: 8 })
              .transition(TransitionEffect.OPACITY.animation({
                duration: 250,
                curve: Curve.EaseOut
              }))
            }

            // 已解分组区域（在顶部显示）
            if (this.showGroups && this.getSolvedGroups().length > 0) {
              Column() {
                ForEach(this.getSolvedGroups(), (group: FlagGroup) => {
                  Column() {
                    // 主题横幅
                    Row() {
                      Text(getLocalizedTheme(group.theme, this.context).toUpperCase())
                        .fontSize(15)
                        .fontWeight(FontWeight.Bold)
                        .fontColor($r('app.color.button_primary'))
                    }
                    .width('100%')
                    .padding({ top: 8, bottom: 8, left: 12, right: 12 })
                    .backgroundColor('#E0F2FE')
                    .justifyContent(FlexAlign.Center)

                    // 国旗行
                    Grid() {
                      ForEach(group.countryCodes, (code: string) => {
                        GridItem() {
                          Image(getFlagImageSource(code))
                            .width('100%')
                            .height('100%')
                            .objectFit(ImageFit.Contain)
                        }
                      })
                    }
                    .columnsTemplate('1fr 1fr 1fr 1fr')
                    .columnsGap(8)
                    .rowsGap(16)
                    .width('100%')
                    .height(80)
                    .padding({ top: 8, bottom: 8 })
                  }
                  .width('100%')
                  .border({
                    width: 1,
                    color: '#93C5FD',
                    style: BorderStyle.Solid
                  })
                  .margin({ bottom: 8 })
                })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .margin({ top: this.errorMessage ? 8 : 8 })
            }

            // 主内容区域
            Column() {
              // 国旗网格
              Scroll() {
                Grid() {
                  ForEach(this.getUnusedFlags(), (flag: FlagTile) => {
                    GridItem() {
                      Column() {
                        Image(getFlagImageSource(flag.countryCode))
                          .width('100%')
                          .height('100%')
                          .objectFit(ImageFit.Contain)
                      }
                      .width('100%')
                      .height(80)
                      .backgroundColor(Color.Transparent)
                      .border({
                        width: (this.isFlagSelected(flag.countryCode) || this.isFlagHintHighlighted(flag.countryCode)) ? 2 : 0,
                        color: this.isFlagSelected(flag.countryCode) ? '#10B981' : (this.isFlagHintHighlighted(flag.countryCode) ? '#F59E0B' : Color.Transparent),
                        style: BorderStyle.Solid
                      })
                      .borderRadius(0)
                      .shadow(this.isFlagHintHighlighted(flag.countryCode) ? {
                        radius: 8,
                        color: 'rgba(245, 158, 11, 0.3)',
                        offsetX: 0,
                        offsetY: 2
                      } : undefined)
                      .scale({
                        x: (this.isFlagSelected(flag.countryCode) || this.isFlagHintHighlighted(flag.countryCode)) ? 1.05 : 1,
                        y: (this.isFlagSelected(flag.countryCode) || this.isFlagHintHighlighted(flag.countryCode)) ? 1.05 : 1
                      })
                      .animation({
                        duration: 200,
                        curve: Curve.EaseInOut
                      })
                      .onClick(() => {
                        this.selectFlag(flag.countryCode);
                      })
                    }
                  })
                }
                .columnsTemplate('1fr 1fr 1fr 1fr')
                .columnsGap(8)
                .rowsGap(8)
                .width('100%')
                .padding({ left: 16, right: 16 })
              }
              .layoutWeight(1)
              .width('100%')
              .scrollBar(BarState.Off)
              .edgeEffect(EdgeEffect.Spring)

              // 操作按钮（游戏完成时隐藏）
              if (!this.isGameCompleted()) {
                Column() {
                  // 第一行：Shuffle, Unselect All, Submit
                  Row() {
                    Button(this.context.resourceManager.getStringSync($r('app.string.shuffle').id))
                      .type(ButtonType.Normal)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor(Color.Transparent)
                      .fontColor($r('app.color.button_primary'))
                      .border({
                        width: 1,
                        color: $r('app.color.button_primary'),
                        style: BorderStyle.Solid
                      })
                      .borderRadius(8)
                      .layoutWeight(1)
                      .height(40)
                      .onClick(() => {
                        this.shuffleFlags();
                      })

                    Blank()
                      .width(8)

                    Button(this.context.resourceManager.getStringSync($r('app.string.unselect_all').id))
                      .type(ButtonType.Normal)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor(this.selectedCountryCodes.length > 0 ? Color.Transparent : $r('app.color.bg_tertiary'))
                      .fontColor(this.selectedCountryCodes.length > 0 ? $r('app.color.button_primary') : $r('app.color.text_tertiary'))
                      .border({
                        width: 1,
                        color: this.selectedCountryCodes.length > 0 ? $r('app.color.button_primary') : $r('app.color.bg_tertiary'),
                        style: BorderStyle.Solid
                      })
                      .borderRadius(8)
                      .layoutWeight(1)
                      .height(40)
                      .enabled(this.selectedCountryCodes.length > 0)
                      .onClick(() => {
                        this.clearSelection();
                      })

                    Blank()
                      .width(8)

                    Button(this.context.resourceManager.getStringSync($r('app.string.submit').id))
                      .type(ButtonType.Normal)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor(this.selectedCountryCodes.length === 4 ? $r('app.color.button_primary') : $r('app.color.bg_tertiary'))
                      .fontColor(this.selectedCountryCodes.length === 4 ? Color.White : $r('app.color.text_tertiary'))
                      .borderRadius(8)
                      .layoutWeight(1)
                      .height(40)
                      .enabled(this.selectedCountryCodes.length === 4)
                      .onClick(() => {
                        this.submitSelection();
                      })
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16 })
                  .margin({ top: 8 })

                  // 第二行：Hint, Solve
                  Row() {
                    Button(this.context.resourceManager.getStringSync($r('app.string.hint').id))
                      .type(ButtonType.Normal)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor('rgba(22, 119, 255, 0.5)')
                      .fontColor(Color.White)
                      .borderRadius(25)
                      .width(80)
                      .height(50)
                      .onClick(() => {
                        this.useHint();
                      })

                    Blank()
                      .width(20)

                    Button(this.context.resourceManager.getStringSync($r('app.string.solve').id))
                      .type(ButtonType.Normal)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor('rgba(22, 119, 255, 0.5)')
                      .fontColor(Color.White)
                      .borderRadius(25)
                      .width(80)
                      .height(50)
                      .onClick(() => {
                        this.useSolve();
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)
                  .padding({ left: 16, right: 16, top: 12, bottom: 16 })
                }
              }

              // Next按钮
              if (this.showNextButton) {
                Column() {
                  Button(this.context.resourceManager.getStringSync($r('app.string.next_level').id))
                    .width('100%')
                    .height(48)
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor($r('app.color.button_primary'))
                    .onClick(() => {
                      this.handleNextLevel();
                    })
                }
                .width('100%')
                .padding({ left: 16, right: 16, bottom: 16 })
              }
            }
            .layoutWeight(1)
            .width('100%')
          }
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.bg_page'))
          .constraintSize({ maxWidth: getContentMaxWidth() })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .title('')
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
      .backgroundColor($r('app.color.bg_page'))
    }
  }
