/**
 * 涂鸦游戏首页
 * 显示世界和各国州旗分类选项
 */
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import display from '@ohos.display';
import { paintCategories, PaintCategory, getTotalLevels } from './PaintGameData';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';

@CustomDialog
struct HowToPlayDialog {
  controller: CustomDialogController;

  build() {
    Column() {
      Row() {
        Text('🎨')
          .fontSize(28)
        Text(' 涂鸦说明')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .margin({ bottom: 20 })

      Column() {
        Text('1. 从调色板选择颜色')
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text('2. 用手指点击或拖动国旗区域进行填色')
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text('3. 按照正确的颜色顺序完成涂鸦')
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 10 })

        Text('4. 每关包含多个国旗或州旗，全部正确即可过关')
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')

      Button('知道了')
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

@Component
export struct PaintHomePage {
  @State unlockedLevels: Map<string, number> = new Map();
  @State screenWidth: number = 360;
  @State screenHeight: number = 780;
  private context = getContext(this) as common.UIAbilityContext;
  private howToPlayDialogController: CustomDialogController = new CustomDialogController({
    builder: HowToPlayDialog(),
    alignment: DialogAlignment.Center,
    customStyle: true
  });

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
      const level = await GameProgressManager.getUnlockedLevel(key);
      this.unlockedLevels.set(category.id, level);
    }
    // 触发UI更新
    this.unlockedLevels = new Map(this.unlockedLevels);
  }

  private getGameType(categoryId: string): GameType {
    const gameTypeMap: Record<string, GameType> = {
      'world': GameType.PAINT_WORLD,
      'us': GameType.PAINT_US,
      'de': GameType.PAINT_DE,
      'it': GameType.PAINT_IT,
      'br': GameType.PAINT_BR
    };
    return gameTypeMap[categoryId] || GameType.PAINT_WORLD;
  }

  private getUnlockedLevel(categoryId: string): number {
    return this.unlockedLevels.get(categoryId) || 1;
  }

  private navigateToGame(category: PaintCategory): void {
    const currentLevel = this.getUnlockedLevel(category.id);
    // 直接进入当前关卡
    router.pushUrl({
      url: 'pages/paintgame/PaintPlayPage',
      params: {
        categoryId: category.id,
        levelId: currentLevel
      }
    });
  }

  private showHowToPlayDialog(): void {
    this.howToPlayDialogController.open();
  }

  build() {
    Scroll() {
      Column() {
        // 世界涂鸦 - 大卡片 (高度占屏幕1/2)
        Stack({ alignContent: Alignment.TopEnd }) {
          // 中心内容
          Column() {
            Text('🌍')
              .fontSize(56)
              .margin({ bottom: 12 })

            Text('世界')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('世界各国国旗涂鸦')
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
              value: this.getUnlockedLevel('world') - 1,
              total: getTotalLevels('world'),
              type: ProgressType.Ring
            })
              .width(52)
              .height(52)
              .style({ strokeWidth: 2 })
              .color('#69B4FF')
              .backgroundColor('rgba(0, 0, 0, 0.06)')

            Text(`${this.getUnlockedLevel('world')}/${getTotalLevels('world')}`)
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

              Text(category.name)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Text(category.description)
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
                value: this.getUnlockedLevel(category.id) - 1,
                total: getTotalLevels(category.id),
                type: ProgressType.Ring
              })
                .width(48)
                .height(48)
                .style({ strokeWidth: 2 })
                .color('#69B4FF')
                .backgroundColor('rgba(0, 0, 0, 0.06)')

              Text(`${this.getUnlockedLevel(category.id)}/${getTotalLevels(category.id)}`)
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
          Text('🎨')
            .fontSize(20)
          Text(' 涂鸦说明')
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
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .backgroundColor($r('app.color.bg_page'))
  }
}

