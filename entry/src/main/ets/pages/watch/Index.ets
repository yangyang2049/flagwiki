import { ArcSwiper, ArcSwiperAttribute, ArcSwiperController, ArcDotIndicator } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { LearnPage } from './LearnPage'
import { PracticePage } from './PracticePage'
import { SettingsPage } from './SettingsPage'
import { WatchPrivacyAgreement } from './WatchPrivacyAgreement'

PersistentStorage.persistProp('watchPrivacyAgreementAccepted', false)

@Entry
@Component
struct Index {
  @StorageLink('watchPrivacyAgreementAccepted') watchPrivacyAgreementAccepted: boolean = false
  @State private showPrivacyAgreement: boolean = false
  @State currentTab: number = 0
  private innerSelectedIndex: number = 0 // 用于跟踪当前选中的索引，用于手势判断
  private arcSwiperController: ArcSwiperController = new ArcSwiperController()

  aboutToAppear(): void {
    const accepted = AppStorage.get<boolean>('watchPrivacyAgreementAccepted')
    this.showPrivacyAgreement = !accepted
  }

  build() {
    Stack() {
      if (!this.showPrivacyAgreement) {
        ArcSwiper(this.arcSwiperController) {
          LearnPage()
          PracticePage()
          SettingsPage()
        }
        .index(this.currentTab)
        .indicator(new ArcDotIndicator()
          .itemColor('rgba(255, 255, 255, 0.3)')
          .selectedItemColor($r('app.color.button_primary')))
        .onChange((index: number) => {
          this.currentTab = index
          this.innerSelectedIndex = index
        })
        .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
          others: Array<GestureRecognizer>): GestureJudgeResult => {
          if (this.shouldAllowExit(event, current)) {
            console.info('[WatchIndex] Right swipe from left edge on first page, allow exit')
            return GestureJudgeResult.REJECT
          }
          return GestureJudgeResult.CONTINUE
        })
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')
      }

      if (this.showPrivacyAgreement) {
        WatchPrivacyAgreement({
          onConfirmClick: () => {
            this.handlePrivacyConfirm()
          },
          onCancelClick: () => {
            this.handlePrivacyCancel()
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }

  private handlePrivacyConfirm(): void {
    AppStorage.set('watchPrivacyAgreementAccepted', true)
    this.watchPrivacyAgreementAccepted = true
    this.showPrivacyAgreement = false
  }

  private handlePrivacyCancel(): void {
    const context = this.getUIContext()?.getHostContext() as common.UIAbilityContext
    if (context) {
      context.terminateSelf()
    }
  }

  /**
   * 判断是否应该允许右滑退出
   * @param event 手势事件
   * @param current 当前手势识别器
   * @returns 如果在第一个页面向右滑动则返回 true，允许退出
   */
  private shouldAllowExit(event: BaseGestureEvent, current: GestureRecognizer): boolean {
    if (!current || !current.isBuiltIn()) {
      return false
    }

    if (current.getType() !== GestureControl.GestureType.PAN_GESTURE) {
      return false
    }

    const target = current.getEventTargetInfo()
    if (!(target instanceof ScrollableTargetInfo)) {
      return false
    }

    const swiperTarget = target as ScrollableTargetInfo
    const isAtBeginning = swiperTarget.isBegin() || this.innerSelectedIndex === 0
    const panEvent = event as PanGestureEvent
    const isSwipingRight = panEvent?.offsetX > 0

    return isAtBeginning && isSwipingRight
  }
}
