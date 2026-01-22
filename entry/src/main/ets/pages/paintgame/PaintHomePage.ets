/**
 * 涂鸦游戏首页
 * 显示世界和各国州旗分类选项
 */
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import display from '@ohos.display';
import promptAction from '@ohos.promptAction';
import { paintCategories, PaintCategory, getTotalLevels } from './PaintGameData';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import UiConstants from '../../utils/UiConstants';

@CustomDialog
struct HowToPlayDialog {
  controller: CustomDialogController;
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Text(UiConstants.PAINT_PALETTE)
          .fontSize(28)
        Text(` ${this.context.resourceManager.getStringSync($r('app.string.paint_instructions_title').id)}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .margin({ bottom: 20 })

      Column() {
        Text(this.context.resourceManager.getStringSync($r('app.string.paint_instruction_1').id))
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text(this.context.resourceManager.getStringSync($r('app.string.paint_instruction_2').id))
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text(this.context.resourceManager.getStringSync($r('app.string.paint_instruction_3').id))
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text(this.context.resourceManager.getStringSync($r('app.string.paint_instruction_4').id))
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')

      Button(this.context.resourceManager.getStringSync($r('app.string.got_it').id))
        .width('100%')
        .height(44)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .backgroundColor($r('app.color.button_primary'))
        .margin({ top: 24 })
        .onClick(() => {
          this.controller.close();
        })
    }
    .width(320)
    .padding(24)
    .backgroundColor($r('app.color.bg_card'))
    .borderRadius(20)
  }
}

@CustomDialog
struct AllLevelsCompletedDialog {
  controller: CustomDialogController;
  completionMessage: string = '';
  onRestart?: () => void;
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Text(UiConstants.CELEBRATION)
          .fontSize(28)
        Text(` ${this.context.resourceManager.getStringSync($r('app.string.congratulations').id)}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .margin({ bottom: 20 })

      Text(this.completionMessage)
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: 8 })

      Text(this.context.resourceManager.getStringSync($r('app.string.restart_question').id))
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: 24 })

      Row() {
        Button(this.context.resourceManager.getStringSync($r('app.string.cancel').id))
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.bg_secondary'))
          .fontColor($r('app.color.text_primary'))
          .margin({ right: 8 })
          .onClick(() => {
            this.controller.close();
          })

        Button(this.context.resourceManager.getStringSync($r('app.string.restart').id))
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_white'))
          .margin({ left: 8 })
          .onClick(() => {
            this.controller.close();
            if (this.onRestart) {
              this.onRestart();
            }
          })
      }
      .width('100%')
    }
    .width(320)
    .padding(24)
    .backgroundColor($r('app.color.bg_card'))
    .borderRadius(20)
  }
}

@Component
export struct PaintHomePage {
  @State unlockedLevels: Map<string, number> = new Map();
  @State screenWidth: number = 360;
  @State screenHeight: number = 780;
  @State dialogCategoryName: string = '';
  private context = getContext(this) as common.UIAbilityContext;
  private howToPlayDialogController: CustomDialogController = new CustomDialogController({
    builder: HowToPlayDialog(),
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  private allLevelsCompletedDialogController: CustomDialogController | null = null;
  private currentCategoryForRestart: PaintCategory | null = null;

  async aboutToAppear() {
    // 获取屏幕尺寸
    const displayInfo = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(displayInfo.width);
    this.screenHeight = px2vp(displayInfo.height);

    await GameProgressManager.init(this.context);
    await this.loadProgress();
  }

  private async loadProgress(): Promise<void> {
    // 为每个分类加载进度
    for (const category of paintCategories) {
      const key = this.getGameType(category.id);
      let level = await GameProgressManager.getUnlockedLevel(key);
      const totalLevels = getTotalLevels(category.id);
      
      // 如果进度超过总关卡数，限制为总关卡数（处理之前有更多关卡的情况）
      if (level > totalLevels) {
        level = totalLevels;
        // 自动修复进度
        await GameProgressManager.setUnlockedLevel(key, totalLevels);
      }
      
      this.unlockedLevels.set(category.id, level);
    }
    // 触发UI更新
    this.unlockedLevels = new Map(this.unlockedLevels);
  }

  private getGameType(categoryId: string): GameType {
    const gameTypeMap: Record<string, GameType> = {
      'world': GameType.PAINT_WORLD,
      'us': GameType.PAINT_US
    };
    return gameTypeMap[categoryId] || GameType.PAINT_WORLD;
  }

  private getUnlockedLevel(categoryId: string): number {
    return this.unlockedLevels.get(categoryId) || 1;
  }

  private navigateToGame(category: PaintCategory): void {
    const currentLevel = this.getUnlockedLevel(category.id);
    const totalLevels = getTotalLevels(category.id);
    
    // 检查是否所有关卡都已完成（包括等于的情况，即17/17）
    if (currentLevel >= totalLevels) {
      // 显示全部完成对话框
      this.showAllLevelsCompletedDialog(category);
      return;
    }
    
    // 直接进入当前关卡
    router.pushUrl({
      url: 'pages/paintgame/PaintPlayPage',
      params: {
        categoryId: category.id,
        levelId: currentLevel
      }
    });
  }

  private showAllLevelsCompletedDialog(category: PaintCategory): void {
    this.currentCategoryForRestart = category;
    this.dialogCategoryName = this.context.resourceManager.getStringSync(category.nameResId.id);
    const completionMessage = this.context.resourceManager.getStringSync($r('app.string.all_levels_completed').id, this.dialogCategoryName);
    
    // 创建控制器
    this.allLevelsCompletedDialogController = new CustomDialogController({
      builder: AllLevelsCompletedDialog({
        completionMessage: completionMessage,
        onRestart: () => {
          if (this.currentCategoryForRestart) {
            this.restartGame(this.currentCategoryForRestart);
          }
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true
    });
    this.allLevelsCompletedDialogController.open();
  }

  private async restartGame(category: PaintCategory): Promise<void> {
    try {
      const gameType = this.getGameType(category.id);
      // 重置进度到第1关
      await GameProgressManager.setUnlockedLevel(gameType, 1);
      // 更新本地状态
      this.unlockedLevels.set(category.id, 1);
      this.unlockedLevels = new Map(this.unlockedLevels);
      
      // 进入第1关
      router.pushUrl({
        url: 'pages/paintgame/PaintPlayPage',
        params: {
          categoryId: category.id,
          levelId: 1
        }
      });
    } catch (err) {
      console.error('Failed to restart game:', err);
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.paint_reset_failed').id),
        duration: 2000
      });
    }
  }

  private showHowToPlayDialog(): void {
    this.howToPlayDialogController.open();
  }

  build() {
    Scroll() {
      Row() {
        Column() {
          // 世界涂鸦 - 大卡片 (高度占屏幕1/2)
        Stack({ alignContent: Alignment.TopEnd }) {
          // 中心内容
          Column() {
            Text(UiConstants.WORLD_EMOJI)
              .fontSize(56)
              .margin({ bottom: 12 })

            Text($r('app.string.paint_category_world'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.paint_category_world_desc'))
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)

          // 右上角浮动圆环进度
          Stack() {
            Progress({
              value: Math.min(this.getUnlockedLevel('world'), getTotalLevels('world')),
              total: getTotalLevels('world'),
              type: ProgressType.Ring
            })
              .width(52)
              .height(52)
              .style({ strokeWidth: 2 })
              .color('#69B4FF')
              .backgroundColor('rgba(0, 0, 0, 0.06)')

            Text(`${Math.min(this.getUnlockedLevel('world'), getTotalLevels('world'))}/${getTotalLevels('world')}`)
              .fontSize(11)
              .fontColor($r('app.color.text_secondary'))
          }
          .width(52)
          .height(52)
          .margin({ top: 16, right: 16 })
        }
        .width('100%')
        .height(this.screenHeight / 2 - 60)
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(24)
        .shadow({
          radius: 12,
          color: 'rgba(0, 80, 188, 0.08)',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => {
          const worldCategory = paintCategories.find(c => c.id === 'world');
          if (worldCategory) {
            this.navigateToGame(worldCategory);
          }
        })

        // 其他分类 - 全宽卡片（带浮动圆环进度）
        ForEach(paintCategories.filter(c => c.id !== 'world'), (category: PaintCategory) => {
          Stack({ alignContent: Alignment.TopEnd }) {
            // 中心内容
            Column() {
              Text(category.emoji)
                .fontSize(48)
                .margin({ bottom: 10 })

              Text(this.context.resourceManager.getStringSync(category.nameResId.id))
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Text(this.context.resourceManager.getStringSync(category.descResId.id))
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 6 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)

            // 右上角浮动圆环进度
            Stack() {
              Progress({
                value: Math.min(this.getUnlockedLevel(category.id), getTotalLevels(category.id)),
                total: getTotalLevels(category.id),
                type: ProgressType.Ring
              })
                .width(48)
                .height(48)
                .style({ strokeWidth: 2 })
                .color('#69B4FF')
                .backgroundColor('rgba(0, 0, 0, 0.06)')

              Text(`${Math.min(this.getUnlockedLevel(category.id), getTotalLevels(category.id))}/${getTotalLevels(category.id)}`)
                .fontSize(10)
                .fontColor($r('app.color.text_secondary'))
            }
            .width(48)
            .height(48)
            .margin({ top: 14, right: 14 })
          }
          .width('100%')
          .height(180)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .margin({ top: 16 })
          .shadow({
            radius: 8,
            color: 'rgba(0, 80, 188, 0.06)',
            offsetX: 0,
            offsetY: 3
          })
          .onClick(() => {
            this.navigateToGame(category);
          })
        })

        // 涂鸦说明 Banner
        Row() {
          Text(UiConstants.PAINT_PALETTE)
            .fontSize(20)
          Text(` ${this.context.resourceManager.getStringSync($r('app.string.paint_instructions_banner').id)}`)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Blank()

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(52)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(12)
        .alignItems(VerticalAlign.Center)
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          this.showHowToPlayDialog();
        })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 })
        .constraintSize({ maxWidth: getContentMaxWidth() })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .backgroundColor($r('app.color.bg_page'))
  }
}

