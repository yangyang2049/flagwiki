import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { getContentMaxWidth } from '../../utils/LayoutHelper';
import UiConstants from '../../utils/UiConstants';

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
export struct ExplorePage {
  @Prop @Watch('onRefreshKeyChanged') refreshKey: number = 0;
  @State quizLevel: number = 1;
  @State fakeFlagLevel: number = 1;
  @State inputLevel: number = 1;
  @State triviaLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear(): Promise<void> {
    await this.loadGameProgress();
  }

  private onRefreshKeyChanged(): void {
    void this.loadGameProgress();
  }

  private async loadGameProgress(): Promise<void> {
    try {
      await GameProgressManager.init(this.context);
      this.quizLevel = await GameProgressManager.getUnlockedLevel(GameType.QUIZ);
      this.fakeFlagLevel = await GameProgressManager.getUnlockedLevel(GameType.FAKE_FLAG);
      this.inputLevel = await GameProgressManager.getUnlockedLevel(GameType.INPUT);
      this.triviaLevel = await GameProgressManager.getUnlockedLevel(GameType.TRIVIA);
    } catch (err) {
      console.error(`[ExplorePage] loadGameProgress: ${JSON.stringify(err)}`);
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
        name: this.context.resourceManager.getStringSync($r('app.string.game_flag_quiz').id),
        emoji: '🎯',
        current: this.quizLevel - 1,
        total: QUIZ_TOTAL_LEVELS,
        color: $r('app.color.button_primary')
      },
      {
        name: this.context.resourceManager.getStringSync($r('app.string.game_fake_flag').id),
        emoji: '🔍',
        current: this.fakeFlagLevel - 1,
        total: FAKE_FLAG_TOTAL_LEVELS,
        color: $r('app.color.color_green')
      },
      {
        name: this.context.resourceManager.getStringSync($r('app.string.game_spelling_challenge').id),
        emoji: '⌨️',
        current: this.inputLevel - 1,
        total: INPUT_TOTAL_LEVELS,
        color: $r('app.color.color_orange')
      },
      {
        name: this.context.resourceManager.getStringSync($r('app.string.game_trivia').id),
        emoji: '🧩',
        current: this.triviaLevel - 1,
        total: TRIVIA_TOTAL_LEVELS,
        color: $r('app.color.color_purple')
      }
    ];
  }

  build() {
    Scroll() {
      Row() {
        Column() {
        // 探索进度（与「我的」页原逻辑一致，汇总四个玩法关卡）
        Column() {
          Row() {
            Column() {
              Text(UiConstants.TROPHY)
                .fontSize(40)
            }
            .width(64)
              .height(64)
              .backgroundColor($r('app.color.bg_yellow_light'))
              .borderRadius(32)
              .justifyContent(FlexAlign.Center)

            Column() {
              Text(this.context.resourceManager.getStringSync($r('app.string.exploration_progress').id))
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Row() {
                Text(`${this.context.resourceManager.getStringSync($r('app.string.completed').id)} `)
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                Text(`${this.getTotalCompletedLevels()}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.button_primary'))
                Text(`${this.context.resourceManager.getStringSync($r('app.string.levels_separator').id)}${this.getTotalLevels()}${this.context.resourceManager.getStringSync($r('app.string.levels_unit').id)}`)
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

          ForEach(this.getChallengeProgressList(), (game: ChallengeProgress) => {
            Row() {
              Text(game.emoji)
                .fontSize(20)
                .width(32)

              Text(game.name)
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
                .width(72)

              Stack({ alignContent: Alignment.Start }) {
                Row()
                  .width('100%')
                  .height(8)
                  .backgroundColor($r('app.color.bg_secondary'))
                  .borderRadius(4)

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
          .margin({ left: 16, right: 16, top: 16 })

        // 国旗猜猜卡片
        Row() {
          Column() {
            Text(UiConstants.TARGET)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_flag_quiz'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_flag_quiz_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/quiz/QuizSelectPage' });
          })

        // 假旗找茬卡片
        Row() {
          Column() {
            Text(UiConstants.MAGNIFYING_GLASS)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_fake_flag'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_fake_flag_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/fakeflag/FakeFlagLevelsPage' });
          })

        // 拼写挑战卡片
        Row() {
          Column() {
            Text(UiConstants.KEYBOARD)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_spelling'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_spelling_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/inputgame/InputLevelsPage' });
          })

        // 知识问答卡片
        Row() {
          Column() {
            Text(UiConstants.PUZZLE_PIECE)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_trivia'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_trivia_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/trivia/TriviaLevelsPage' });
          })

        // 记忆翻牌卡片
        Row() {
          Column() {
            Text(UiConstants.JOKER_CARD)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_memory'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_memory_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/memory/MemoryLevelsPage' });
          })

        // 分组连线卡片
        Row() {
          Column() {
            Text(UiConstants.LINK_EMOJI)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_connections'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_connections_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/connections/ConnectionsLevelsPage' });
          })

        // HeadsUp 卡片
        Row() {
          Column() {
            Text(UiConstants.EYES_EMOJI)
              .fontSize(40)
          }
        .width(72)
            .height(72)
            .backgroundColor($r('app.color.bg_blue_light'))
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.explore_headsup'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text($r('app.string.explore_headsup_desc'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
        .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .layoutWeight(1)

          Image($r('app.media.icon_arrow_right'))
            .width(20)
            .height(20)
        }
      .padding(24)
          .margin({ left: 16, right: 16, top: 16 })
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius(20)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/explore/HeadsUpPlayPage' });
          })
        }
        .width('100%')
        .padding({ bottom: 60 })
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
