import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import { getCountryByCode } from '../../utils/countryData';
import { MemoryLevel, getMemoryLevel, getAllMemoryLevels } from './MemoryLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { SoundEffectUtil } from '../../utils/SoundEffectUtil';
import { VibratorUtil } from '../../utils/VibratorUtil';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import UiConstants from '../../utils/UiConstants';

interface RouterParams {
  levelId: number;
}

interface Card {
  id: number;
  code: string;
  isFlipped: boolean;
  isMatched: boolean;
}

@Entry
@Component
  struct MemoryPlayPage {
  @State level: MemoryLevel | undefined = undefined;
  @State cards: Card[] = [];
  @State firstCard: Card | null = null;
  @State secondCard: Card | null = null;
  @State moves: number = 0;
  @State matchedPairs: number = 0;
  @State isProcessing: boolean = false;
  @State timeRemaining: number = 0;
  @State showResult: boolean = false;
  @State isWin: boolean = false;
  @State flippingCardId: number = -1;  // 正在翻转的卡片ID
  @State flipAngles: Map<number, number> = new Map();  // 每张卡片的翻转角度
  private timerId: number | undefined = undefined;
  private context = getContext(this) as common.UIAbilityContext;
  private timeoutIds: number[] = []; // 存储所有setTimeout的ID，用于清理

  async aboutToAppear() {
    // 初始化音效播放器
    await SoundEffectUtil.init(this.context);
    await VibratorUtil.init(this.context);

    const params = router.getParams() as RouterParams;
    if (params) {
      const levelId = params.levelId || 1;
      this.loadLevel(levelId);
    }
  }

  private loadLevel(levelId: number): void {
    // 清理之前的定时器
    this.clearAllTimeouts();
    this.level = getMemoryLevel(levelId);
    if (this.level) {
      this.timeRemaining = this.level.timeLimit;
      this.cards = [];
      this.firstCard = null;
      this.secondCard = null;
      this.moves = 0;
      this.matchedPairs = 0;
      this.isProcessing = false;
      this.showResult = false;
      this.isWin = false;
      this.flippingCardId = -1;
      this.flipAngles = new Map();
      this.stopTimer();
      this.initCards();
      this.startTimer();
    }
  }

  aboutToDisappear() {
    this.stopTimer();
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

  private initCards(): void {
    if (!this.level) return;

    const tempCards: Card[] = [];
    let id = 0;

    // 创建配对卡片
    for (const code of this.level.countries) {
      tempCards.push({ id: id++, code, isFlipped: false, isMatched: false });
      tempCards.push({ id: id++, code, isFlipped: false, isMatched: false });
    }

    // 洗牌
    this.shuffleArray(tempCards);
    this.cards = tempCards;
  }

  private shuffleArray<T>(array: T[]): void {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  private startTimer(): void {
    if (!this.level || this.level.timeLimit === 0) return;
    // 防止重复启动定时器
    if (this.timerId !== undefined) return;

    this.timerId = setInterval(() => {
      if (this.timeRemaining > 0) {
        this.timeRemaining--;
        if (this.timeRemaining === 0) {
          this.stopTimer();
          this.gameOver(false);
        }
      }
    }, 1000);
  }

  private stopTimer(): void {
    if (this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
  }

  private flipCard(card: Card): void {
    if (this.isProcessing || card.isFlipped || card.isMatched || this.flippingCardId !== -1) return;

    // 点击振动反馈
    VibratorUtil.vibrateTap();

    const index = this.cards.findIndex(c => c.id === card.id);
    if (index === -1) return;

    // 开始翻转动画
    this.flippingCardId = card.id;
    this.flipAngles.set(card.id, 180);

    // 动画中途更新卡片状态（翻转到一半时显示正面）
    const id1 = setTimeout(() => {
      this.cards[index] = this.createCard(card.id, card.code, true, card.isMatched);
      // 移除已执行的定时器ID
      const index1 = this.timeoutIds.indexOf(id1);
      if (index1 > -1) {
        this.timeoutIds.splice(index1, 1);
      }
    }, 200);
    this.timeoutIds.push(id1);

    // 动画结束后处理逻辑
    const id2 = setTimeout(() => {
      this.flippingCardId = -1;

      if (!this.firstCard) {
        this.firstCard = this.cards[index];
      } else if (!this.secondCard) {
        this.secondCard = this.cards[index];
        this.moves++;
        this.isProcessing = true;

        // 检查是否匹配
        const id3 = setTimeout(async () => {
          await this.checkMatch();
          // 移除已执行的定时器ID
          const index3 = this.timeoutIds.indexOf(id3);
          if (index3 > -1) {
            this.timeoutIds.splice(index3, 1);
          }
        }, 500);
        this.timeoutIds.push(id3);
      }
      // 移除已执行的定时器ID
      const index2 = this.timeoutIds.indexOf(id2);
      if (index2 > -1) {
        this.timeoutIds.splice(index2, 1);
      }
    }, 400);
    this.timeoutIds.push(id2);
  }

  private createCard(id: number, code: string, isFlipped: boolean, isMatched: boolean): Card {
    return { id: id, code: code, isFlipped: isFlipped, isMatched: isMatched };
  }

  private async checkMatch(): Promise<void> {
    if (!this.firstCard || !this.secondCard) return;

    const firstIndex = this.cards.findIndex(c => c.id === this.firstCard!.id);
    const secondIndex = this.cards.findIndex(c => c.id === this.secondCard!.id);
    const firstId = this.firstCard.id;
    const secondId = this.secondCard.id;

    if (this.firstCard.code === this.secondCard.code) {
      // 匹配成功 - 播放正确音效和振动
      await SoundEffectUtil.playCorrect();
      VibratorUtil.vibrateCorrect();

      const first = this.cards[firstIndex];
      const second = this.cards[secondIndex];
      this.cards[firstIndex] = this.createCard(first.id, first.code, first.isFlipped, true);
      this.cards[secondIndex] = this.createCard(second.id, second.code, second.isFlipped, true);
      this.matchedPairs++;

      this.firstCard = null;
      this.secondCard = null;
      this.isProcessing = false;

      // 检查是否完成
      if (this.matchedPairs === this.level?.pairs) {
        this.stopTimer();
        const id = setTimeout(async () => {
          await SoundEffectUtil.playCongrats();
          VibratorUtil.vibrateWin();
          this.gameOver(true);
          // 移除已执行的定时器ID
          const index = this.timeoutIds.indexOf(id);
          if (index > -1) {
            this.timeoutIds.splice(index, 1);
          }
        }, 500);
        this.timeoutIds.push(id);
      }
    } else {
      // 不匹配，翻回去 - 播放错误音效和振动
      await SoundEffectUtil.playIncorrect();
      VibratorUtil.vibrateIncorrect();

      this.flipAngles.set(firstId, 0);
      this.flipAngles.set(secondId, 0);

      // 动画中途更新卡片状态
      const id1 = setTimeout(() => {
        const first = this.cards[firstIndex];
        const second = this.cards[secondIndex];
        this.cards[firstIndex] = this.createCard(first.id, first.code, false, first.isMatched);
        this.cards[secondIndex] = this.createCard(second.id, second.code, false, second.isMatched);
        // 移除已执行的定时器ID
        const index1 = this.timeoutIds.indexOf(id1);
        if (index1 > -1) {
          this.timeoutIds.splice(index1, 1);
        }
      }, 200);
      this.timeoutIds.push(id1);

      // 动画结束后重置状态
      const id2 = setTimeout(() => {
        this.flipAngles.delete(firstId);
        this.flipAngles.delete(secondId);
        this.firstCard = null;
        this.secondCard = null;
        this.isProcessing = false;
        // 移除已执行的定时器ID
        const index2 = this.timeoutIds.indexOf(id2);
        if (index2 > -1) {
          this.timeoutIds.splice(index2, 1);
        }
      }, 400);
      this.timeoutIds.push(id2);
    }
  }

  private async gameOver(win: boolean): Promise<void> {
    this.isWin = win;
    this.showResult = true;

    // 如果失败，播放结束音效
    if (!win) {
      await SoundEffectUtil.playOver();
    }

    // 如果获胜，解锁下一关
    if (win && this.level) {
      await GameProgressManager.init(this.context);
      await GameProgressManager.unlockNextLevel(GameType.MEMORY, this.level.id);
    }
  }

  private restartGame(): void {
    this.cards = [];
    this.firstCard = null;
    this.secondCard = null;
    this.moves = 0;
    this.matchedPairs = 0;
    this.isProcessing = false;
    this.showResult = false;
    this.isWin = false;
    this.flippingCardId = -1;
    this.flipAngles = new Map();

    if (this.level) {
      this.timeRemaining = this.level.timeLimit;
      this.stopTimer();
      this.initCards();
      this.startTimer();
    }
  }

  private formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
  }

  private getGridColumns(): string {
    // 根据关卡配置的列数生成模板
    const columns = this.level?.columns || 2;
    const arr: string[] = [];
    for (let i = 0; i < columns; i++) {
      arr.push('1fr');
    }
    return arr.join(' ');
  }

  private getGridRows(): string {
    // 根据卡片数量和列数计算行数
    if (!this.level) return '1fr 1fr 1fr 1fr';
    const totalCards = this.level.pairs * 2;
    const columns = this.level.columns;
    const rows = Math.ceil(totalCards / columns);
    const arr: string[] = [];
    for (let i = 0; i < rows; i++) {
      arr.push('1fr');
    }
    return arr.join(' ');
  }

  private getQuestionMarkSize(): number {
    // 根据列数调整问号字体大小
    const columns = this.level?.columns || 2;
    if (columns <= 2) return 36;
    if (columns <= 3) return 28;
    if (columns <= 4) return 24;
    return 20;
  }

  private getCardBorderRadius(): number {
    // 根据列数调整圆角大小
    const columns = this.level?.columns || 2;
    if (columns <= 2) return 12;
    if (columns <= 4) return 8;
    return 6;
  }

  build() {
    Stack() {
      Navigation() {
        Row() {
          Column() {
            // 顶部状态栏
            Row() {
            // 步数
            Column() {
              Text($r('app.string.moves'))
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
              Text(`${this.moves}`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
            }
            .layoutWeight(1)

            // 时间（放在中间）
            if (this.level && this.level.timeLimit > 0) {
              Column() {
                Text($r('app.string.time'))
                  .fontSize(11)
                  .fontColor($r('app.color.text_secondary'))
                Text(this.formatTime(this.timeRemaining))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.timeRemaining <= 10 ? $r('app.color.color_red') : $r('app.color.text_primary'))
              }
              .layoutWeight(1)
            }

            // 配对进度
            Column() {
              Text($r('app.string.pairs'))
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
              Text(this.context.resourceManager.getStringSync($r('app.string.progress_indicator').id, this.matchedPairs.toString(), (this.level?.pairs || 0).toString()))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
            }
            .layoutWeight(1)
          }
          .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })

          // 卡片网格 - 限制在屏幕内不滚动
          Grid() {
            ForEach(this.cards, (card: Card) => {
              GridItem() {
                this.CardItem(card)
              }
            })
          }
          .columnsTemplate(this.getGridColumns())
            .rowsTemplate(this.getGridRows())
            .columnsGap(4)
            .rowsGap(4)
            .width('100%')
            .layoutWeight(1)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
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

      // 结果弹窗
      if (this.showResult) {
        this.ResultDialog()
      }
    }
    .width('100%')
      .height('100%')
  }

  @Builder
  CardItem(card: Card) {
    Column() {
      if (card.isFlipped || card.isMatched) {
        // 显示国旗 - 应用反向旋转以抵消卡片翻转
        Image($rawfile(`flags/${card.code}.svg`))
          .width('75%')
          .height('75%')
          .objectFit(ImageFit.Contain)
          .rotate({
            x: 0,
            y: 1,
            z: 0,
            angle: -this.getCardRotateAngle(card),
            centerX: '50%',
            centerY: '50%'
          })
          .animation({
            duration: 400,
            curve: curves.springMotion(0.4, 0.8)
          })
      } else {
        // 显示卡片背面 - 白色背景，旗帜emoji
        Column() {
          Text(UiConstants.FLAG_EMOJI)
            .fontSize(this.getQuestionMarkSize())
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(card.isMatched ? $r('app.color.bg_green_light') :
        (card.isFlipped ? $r('app.color.bg_secondary') : Color.White))
      .borderRadius(this.getCardBorderRadius())
      .border({
        width: card.isMatched ? 2 : 1,
        color: card.isMatched ? $r('app.color.color_green') : $r('app.color.gray_border')
      })
      .shadow(card.isFlipped || card.isMatched ? {
        radius: 8,
        color: 'rgba(0, 0, 0, 0.1)',
        offsetX: 0,
        offsetY: 2
      } : {
        radius: 0,
        color: 'rgba(0, 0, 0, 0)',
        offsetX: 0,
        offsetY: 0
      })
      .rotate({
        x: 0,
        y: 1,
        z: 0,
        angle: this.getCardRotateAngle(card),
        centerX: '50%',
        centerY: '50%'
      })
      .scale({
        x: card.isFlipped || card.isMatched ? 1 : 0.95,
        y: card.isFlipped || card.isMatched ? 1 : 0.95
      })
      .animation({
        duration: 400,
        curve: curves.springMotion(0.4, 0.8)
      })
      .onClick(() => {
        this.flipCard(card);
      })
  }

  private getCardRotateAngle(card: Card): number {
    // 如果卡片正在翻转动画中
    if (this.flippingCardId === card.id) {
      return 180;
    }
    // 如果卡片需要翻回去
    if (this.flipAngles.has(card.id)) {
      return this.flipAngles.get(card.id) || 0;
    }
    // 正常状态
    return card.isFlipped || card.isMatched ? 180 : 0;
  }

  @Builder
  ResultDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.6)')

      // 对话框
      Column() {
        Text(this.isWin ? UiConstants.CELEBRATION : UiConstants.CLOCK)
          .fontSize(56)
          .margin({ top: 24 })

        Text(this.isWin ? $r('app.string.congratulations') : $r('app.string.time_up'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 16 })

        Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, (this.level?.id || 1).toString()))
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 8 })

        // 统计信息
        Column() {
          Row() {
            Text($r('app.string.total_moves'))
              .fontSize(15)
              .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`${this.moves}`)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .width('100%')
            .padding({ top: 12, bottom: 12 })

          Divider().color($r('app.color.gray_very_light'))

          Row() {
            Text($r('app.string.pairs_completed'))
              .fontSize(15)
              .fontColor($r('app.color.text_secondary'))
            Blank()
            Text(`${this.matchedPairs} / ${this.level?.pairs}`)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .width('100%')
            .padding({ top: 12, bottom: 12 })
        }
        .width('100%')
          .padding({ left: 20, right: 20 })
          .margin({ top: 20 })
          .backgroundColor($r('app.color.bg_secondary'))
          .borderRadius(12)

        // 按钮
        Row({ space: 12 }) {
          Button(this.context.resourceManager.getStringSync($r('app.string.back').id))
            .layoutWeight(1)
            .height(44)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.button_primary'))
            .backgroundColor(Color.Transparent)
            .border({ width: 1, color: $r('app.color.button_primary') })
            .onClick(() => {
              router.back();
            })

          Button(this.isWin 
            ? (this.level && this.level.id < getAllMemoryLevels().length 
              ? this.context.resourceManager.getStringSync($r('app.string.next_level').id)
              : this.context.resourceManager.getStringSync($r('app.string.perfect_finish').id))
            : this.context.resourceManager.getStringSync($r('app.string.restart').id))
            .layoutWeight(1)
            .height(44)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .backgroundColor($r('app.color.button_primary'))
            .onClick(async () => {
              await SoundEffectUtil.playButton();
              VibratorUtil.vibrateTap();
              if (this.isWin) {
                // 胜利：下一关或退出
                if (this.level && this.level.id < getAllMemoryLevels().length) {
                  // 下一关 - 在当前页面重新加载数据
                  await GameProgressManager.init(this.context);
                  await GameProgressManager.unlockNextLevel(GameType.MEMORY, this.level.id);
                  this.loadLevel(this.level.id + 1);
                } else {
                  // 完美收官，退出
                  router.back();
                }
              } else {
                // 失败：重新开始
                this.restartGame();
              }
            })
        }
        .width('100%')
          .padding({ left: 20, right: 20 })
          .margin({ top: 24, bottom: 24 })
      }
      .width('85%')
        .constraintSize({ maxWidth: 320 })
        .backgroundColor($r('app.color.bg_card'))
        .borderRadius(20)
    }
    .width('100%')
      .height('100%')
  }
}
