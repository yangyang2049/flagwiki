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
}
