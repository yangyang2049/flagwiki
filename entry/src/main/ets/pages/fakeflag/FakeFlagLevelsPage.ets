import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { FakeFlagLevel, getAllFakeFlagLevels } from './FakeFlagLevels';
import { GameProgressManager, GameType } from '../../utils/GameProgressManager';
import { getContentMaxWidth } from '../../utils/LayoutHelper';

@Entry
@Component
struct FakeFlagLevelsPage {
  @State levels: FakeFlagLevel[] = [];
  @State unlockedLevel: number = 1;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    this.levels = getAllFakeFlagLevels();
    await GameProgressManager.init(this.context);
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.FAKE_FLAG);
  }

  onPageShow() {
    this.refreshUnlockedLevel();
  }

  private async refreshUnlockedLevel(): Promise<void> {
    this.unlockedLevel = await GameProgressManager.getUnlockedLevel(GameType.FAKE_FLAG);
  }

  private isLevelUnlocked(levelId: number): boolean {
    return levelId <= this.unlockedLevel;
  }

  build() {
    Navigation() {
      Row() {
        Column() {
          List() {
            ForEach(this.levels, (level: FakeFlagLevel) => {
              ListItem() {
                Row() {
                  // 关卡图标
                  Column() {
                    Text(`${level.id}`)
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_white') : $r('app.color.text_tertiary'))
                  }
                  .width(48)
                  .height(48)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor(this.isLevelUnlocked(level.id) ? $r('app.color.button_primary') : $r('app.color.bg_tertiary'))
                  .borderRadius(24)

                  // 关卡信息
                  Column() {
                    Text(this.context.resourceManager.getStringSync($r('app.string.level_number').id, level.id.toString()))
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.isLevelUnlocked(level.id) ? $r('app.color.text_primary') : $r('app.color.text_tertiary'))
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 16 })
                  .layoutWeight(1)

                  // 箭头图标（仅已解锁关卡显示）
                  if (this.isLevelUnlocked(level.id)) {
                    Image($r('app.media.icon_arrow_right'))
                      .width(20)
                      .height(20)
                  }
                }
                .width('100%')
                .padding(16)
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(12)
              }
              .margin({ left: 16, right: 16, bottom: 12 })
              .onClick(() => {
                if (this.isLevelUnlocked(level.id)) {
                  router.pushUrl({
                    url: 'pages/fakeflag/FakeFlagPlayPage',
                    params: { levelId: level.id }
                  });
                }
              })
            })
          }
          .width('100%')
          .height('100%')
          .padding({ top: 12 })
          .scrollBar(BarState.Off)
          .backgroundColor($r('app.color.bg_page'))
          .constraintSize({ maxWidth: getContentMaxWidth() })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title($r('app.string.game_fake_flag'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.bg_page'))
  }
}

