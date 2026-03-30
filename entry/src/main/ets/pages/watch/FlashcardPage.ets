import { common } from '@kit.AbilityKit'
import vibrator from '@ohos.vibrator'
import promptAction from '@ohos.promptAction'
import curves from '@ohos.curves'
import { BusinessError } from '@kit.BasicServicesKit'
import { preferences } from '@kit.ArkData'
import { Countries, Country, getLocalizedCountryName } from '../../utils/countryData'
import { FavoritesManager } from '../../utils/favoritesManager'
import { PreferencesManager } from '../../utils/PreferencesManager'

@Entry
@Component
struct FlashcardPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State currentCountry: Country | null = null
  @State sessionCountries: Country[] = []
  @State currentIndex: number = 0
  @State isFlipped: boolean = false
  @State isFlipping: boolean = false
  @State flipAngle: number = 0
  @State isFavorite: boolean = false
  @State hasShownIntro: boolean = false
  @State vibrationEnabled: boolean = true

  private context: common.UIAbilityContext | null = null
  private prefs: preferences.Preferences | null = null
  private timeoutIds: number[] = []

  async aboutToAppear() {
    this.ensureContext()
    if (this.context) {
      await FavoritesManager.init(this.context)
    }
    await this.initPreferences()
    await this.loadSettings()
    this.startSession()
    this.loadIntroState()
    this.showIntroToast()
  }

  aboutToDisappear() {
    this.clearTimers()
  }

  private ensureContext(): void {
    if (!this.context) {
      this.context = this.getUIContext()?.getHostContext() as common.UIAbilityContext
    }
  }

  private showIntroToast(): void {
    if (this.hasShownIntro) {
      return
    }
    this.ensureContext()
    if (!this.context) {
      return
    }
    try {
      promptAction.showToast({
        message: this.context.resourceManager.getStringSync($r('app.string.watch_flashcards_flip_hint').id),
        duration: 2000
      })
      this.hasShownIntro = true
      AppStorage.set('watchFlashcardsIntroShown', true)
    } catch (error) {
      console.error('[WatchFlashcardPage] Failed to show intro toast:', error)
    }
  }

  private async initPreferences(): Promise<void> {
    if (this.prefs) {
      return
    }
    try {
      this.prefs = await PreferencesManager.getPreferences('watch_settings')
    } catch (error) {
      console.error('[WatchFlashcardPage] Failed to init preferences:', error)
    }
  }

  private async loadSettings(): Promise<void> {
    try {
      if (!this.prefs) {
        return
      }
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean
    } catch (error) {
      console.error('[WatchFlashcardPage] Failed to load settings:', error)
    }
  }

  private loadIntroState(): void {
    const stored = AppStorage.get<boolean>('watchFlashcardsIntroShown')
    this.hasShownIntro = stored === true
  }

  private startSession(): void {
    this.clearTimers()
    const shuffled = [...Countries].sort(() => Math.random() - 0.5)
    this.sessionCountries = shuffled.slice(0, 10)
    this.currentIndex = 0
    this.currentCountry = this.sessionCountries[0] ?? null
    this.isFlipped = false
    this.isFlipping = false
    this.flipAngle = 0
    void this.updateFavoriteStatus()
  }

  private async updateFavoriteStatus(): Promise<void> {
    if (!this.currentCountry) {
      this.isFavorite = false
      return
    }
    const pageUrl = `flag:${this.currentCountry.code}`
    this.isFavorite = await FavoritesManager.isFavorite(pageUrl)
  }

  private getCountryName(): string {
    if (!this.currentCountry) {
      return ''
    }
    return getLocalizedCountryName(this.currentCountry, this.currentLanguage)
  }

  private handleFlip(): void {
    if (!this.currentCountry || this.isFlipping) {
      return
    }
    const targetFlipped = !this.isFlipped
    this.isFlipping = true
    this.flipAngle = targetFlipped ? 180 : 0
    this.addTimer(() => {
      this.isFlipped = targetFlipped
    }, 160)
    this.addTimer(() => {
      this.isFlipping = false
    }, 320)
  }

  private handleNext(): void {
    if (this.sessionCountries.length === 0) {
      this.startSession()
      return
    }
    if (this.currentIndex + 1 >= this.sessionCountries.length) {
      this.startSession()
      return
    }
    this.clearTimers()
    this.isFlipped = false
    this.isFlipping = false
    this.flipAngle = 0
    this.currentIndex += 1
    this.currentCountry = this.sessionCountries[this.currentIndex] ?? null
    void this.updateFavoriteStatus()
  }

  private async toggleFavorite(): Promise<void> {
    if (!this.currentCountry) {
      return
    }
    this.vibrateTap()
    const pageUrl = `flag:${this.currentCountry.code}`
    if (this.isFavorite) {
      await FavoritesManager.removeFavorite(pageUrl)
      this.isFavorite = false
    } else {
      await FavoritesManager.addFavorite({
        name: this.currentCountry.nameCN,
        pageUrl: pageUrl
      })
      this.isFavorite = true
    }
  }

  private vibrateTap(): void {
    if (!this.vibrationEnabled) {
      return
    }
    try {
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error('[WatchFlashcardPage] Vibrate tap failed:', error)
        }
      })
    } catch (error) {
      console.error('[WatchFlashcardPage] Vibrate tap failed:', error)
    }
  }

  private addTimer(callback: () => void, delay: number): number {
    const id = setTimeout(() => {
      callback()
      this.timeoutIds = this.timeoutIds.filter(item => item !== id)
    }, delay)
    this.timeoutIds.push(id)
    return id
  }

  private clearTimers(): void {
    this.timeoutIds.forEach(id => clearTimeout(id))
    this.timeoutIds = []
  }

  build() {
    Column() {
      Column() {
        Column() {
          if (this.currentCountry) {
            if (this.isFlipped) {
              Text(this.getCountryName())
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: 12, right: 12 })
                .rotate({
                  x: 0,
                  y: 1,
                  z: 0,
                  angle: -this.flipAngle,
                  centerX: '50%',
                  centerY: '50%'
                })
                .animation({
                  duration: 320,
                  curve: curves.springMotion(0.4, 0.8)
                })
            } else {
              Image($rawfile(`flags/${this.currentCountry.code}.svg`))
                .width(110)
                .height(72)
                .objectFit(ImageFit.Contain)
                .rotate({
                  x: 0,
                  y: 1,
                  z: 0,
                  angle: -this.flipAngle,
                  centerX: '50%',
                  centerY: '50%'
                })
                .animation({
                  duration: 320,
                  curve: curves.springMotion(0.4, 0.8)
                })
            }
          }
        }
        .width('80%')
        .height(110)
        .backgroundColor('rgba(255, 255, 255, 0.08)')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .rotate({
          x: 0,
          y: 1,
          z: 0,
          angle: this.flipAngle,
          centerX: '50%',
          centerY: '50%'
        })
        .animation({
          duration: 320,
          curve: curves.springMotion(0.4, 0.8)
        })
        .onClick(() => {
          this.handleFlip()
        })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Row() {
        Image(this.isFavorite ? $r('app.media.icon_heart_filled') : $r('app.media.icon_heart'))
          .width(24)
          .height(24)
          .fillColor(this.isFavorite ? $r('app.color.button_primary') : Color.Transparent)
          .onClick(() => {
            void this.toggleFavorite()
          })

        Blank()
          .layoutWeight(1)

        Image($r('app.media.icon_next'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.handleNext()
          })
      }
      .width('80%')
      .height(40)
      .margin({ bottom: 12 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, bottom: 16, top: 24 })
    .backgroundColor('#000000')
  }
}
