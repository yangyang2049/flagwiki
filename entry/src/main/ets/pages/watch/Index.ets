import { ArcSwiper, ArcSwiperAttribute, ArcSwiperController, ArcDotIndicator } from '@kit.ArkUI'
import { LearnPage } from './LearnPage'
import { PracticePage } from './PracticePage'
import { SettingsPage } from './SettingsPage'

@Entry
@Component
struct Index {
  @State currentTab: number = 0
  private arcSwiperController: ArcSwiperController = new ArcSwiperController()

  build() {
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
}
