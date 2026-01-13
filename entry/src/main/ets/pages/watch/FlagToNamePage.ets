import vibrator from '@ohos.vibrator'
import { BusinessError } from '@kit.BasicServicesKit'
import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import { Countries, Country, getLocalizedCountryName } from '../../utils/countryData'
import { PreferencesManager } from '../../utils/PreferencesManager'
import { WatchSoundManager } from '../../utils/WatchSoundManager'

type Difficulty = 'easy' | 'medium' | 'hard'

@Entry
@Component
struct FlagToNamePage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State currentCountry: Country | null = null
  @State choices: Country[] = []
  @State selectedIndex: number = -1
  @State isAnswered: boolean = false
  @State questionIndex: number = 0
  @State totalQuestions: number = 10
  @State correctCount: number = 0
  @State optionsToken: number = 0
  @State promptToken: number = 0
  @State promptScale: number = 1
  @State promptOffsetY: number = 0
  @State promptAnimating: boolean = false
  @State contentOpacity: number = 1
  @State showOptions: boolean = false
  @State autoNext: boolean = true
  @State vibrationEnabled: boolean = true
  @State soundEnabled: boolean = true
  @State difficulty: Difficulty = 'medium'
  @State isTransitioning: boolean = false

  private prefs: preferences.Preferences | null = null
  private countryPool: Country[] = []
  private timeoutIds: number[] = []
  private context: common.UIAbilityContext | null = null

  async aboutToAppear() {
    await this.initPreferences()
    await this.loadSettings()
    this.buildCountryPool()
    this.initSoundManager()
    this.startQuestion(true)
  }

  aboutToDisappear() {
    this.clearTimers()
  }

  private async initPreferences(): Promise<void> {
    if (this.prefs) {
      return
    }
    try {
      this.prefs = await PreferencesManager.getPreferences('watch_settings')
    } catch (error) {
      console.error('[WatchFlagToNamePage] Failed to init preferences:', error)
    }
  }

  private async loadSettings(): Promise<void> {
    try {
      if (!this.prefs) {
        return
      }
      this.difficulty = await this.prefs.get('difficulty', 'medium') as Difficulty
      this.totalQuestions = await this.prefs.get('question_count', 10) as number
      this.autoNext = await this.prefs.get('auto_next', true) as boolean
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean
      this.soundEnabled = await this.prefs.get('sound_enabled', true) as boolean
    } catch (error) {
      console.error('[WatchFlagToNamePage] Failed to load settings:', error)
    }
  }

  private initSoundManager(): void {
    if (!this.soundEnabled) {
      return
    }
    try {
      if (!this.context) {
        this.context = this.getUIContext()?.getHostContext() as common.UIAbilityContext
      }
      if (this.context) {
        void WatchSoundManager.initialize(this.context)
      }
    } catch (error) {
      console.error('[WatchFlagToNamePage] Failed to init sound manager:', error)
    }
  }

  private buildCountryPool(): void {
    const sorted = [...Countries].sort((a, b) => b.population - a.population)
    if (this.difficulty === 'easy') {
      this.countryPool = sorted.slice(0, 30)
    } else if (this.difficulty === 'medium') {
      this.countryPool = sorted.slice(0, 80)
    } else {
      this.countryPool = [...Countries]
    }
  }

  private startQuestion(resetProgress: boolean = false): void {
    if (resetProgress) {
      this.questionIndex = 0
      this.correctCount = 0
    }
    this.clearTimers()
    this.selectedIndex = -1
    this.isAnswered = false
    this.isTransitioning = true
    this.showOptions = false
    this.promptAnimating = false
    this.promptScale = 2.4
    this.promptOffsetY = 0
    this.contentOpacity = 1
    this.currentCountry = null
    this.choices = []

    const contentSwapDelay = 30
    const promptMoveDelay = 240
    const optionsRevealDelay = 820

    this.addTimer(() => {
      this.pickQuestion()
    }, contentSwapDelay)

    this.addTimer(() => {
      this.promptAnimating = true
      this.promptScale = 1
      this.promptOffsetY = -16
    }, promptMoveDelay)

    this.addTimer(() => {
      this.showOptions = true
      this.isTransitioning = false
    }, optionsRevealDelay)
  }

  private pickQuestion(): void {
    const pool = this.countryPool.length >= 4 ? this.countryPool : Countries
    const randomIndex = Math.floor(Math.random() * pool.length)
    this.currentCountry = pool[randomIndex]
    this.promptToken += 1
    this.choices = this.generateChoices(this.currentCountry, pool)
    this.optionsToken += 1
  }

  private generateChoices(correct: Country, pool: Country[]): Country[] {
    const choices: Country[] = [correct]
    const available = pool.filter(item => item.code !== correct.code)
    while (choices.length < 4 && available.length > 0) {
      const index = Math.floor(Math.random() * available.length)
      choices.push(available[index])
      available.splice(index, 1)
    }
    return choices.sort(() => Math.random() - 0.5)
  }

  private selectOption(index: number): void {
    if (this.isAnswered || this.isTransitioning || !this.showOptions) {
      return
    }
    this.selectedIndex = index
    this.isAnswered = true

    const isCorrect = index === this.getCorrectIndex()
    if (isCorrect) {
      this.correctCount += 1
    }

    if (this.vibrationEnabled) {
      if (isCorrect) {
        this.vibrateCorrect()
      } else {
        this.vibrateIncorrect()
      }
    }
    if (this.soundEnabled) {
      void WatchSoundManager.play(isCorrect ? 'correct' : 'incorrect')
    }

    if (!this.autoNext) {
      return
    }

    this.isTransitioning = true

    this.addTimer(() => {
      this.showOptions = false
      this.contentOpacity = 0
    }, 400)

    this.addTimer(() => {
      if (this.questionIndex + 1 >= this.totalQuestions) {
        this.questionIndex = 0
        this.correctCount = 0
      } else {
        this.questionIndex += 1
      }
      this.startQuestion()
    }, 900)
  }

  private goNextQuestion(): void {
    if (this.isTransitioning) {
      return
    }
    if (this.questionIndex + 1 >= this.totalQuestions) {
      this.questionIndex = 0
      this.correctCount = 0
    } else {
      this.questionIndex += 1
    }
    this.startQuestion()
  }

  private getCorrectIndex(): number {
    if (!this.currentCountry) {
      return -1
    }
    return this.choices.findIndex(item => item.code === this.currentCountry?.code)
  }

  private getOptionBackgroundColor(index: number): string {
    if (!this.isAnswered) {
      return 'rgba(255, 255, 255, 0.1)'
    }
    const correctIndex = this.getCorrectIndex()
    if (index === correctIndex) {
      return '#2E7D32'
    }
    if (index === this.selectedIndex) {
      return '#C62828'
    }
    return 'rgba(255, 255, 255, 0.1)'
  }

  private getOptionBorderColor(index: number): string {
    if (!this.isAnswered) {
      return 'rgba(255, 255, 255, 0.2)'
    }
    const correctIndex = this.getCorrectIndex()
    if (index === correctIndex) {
      return '#4CAF50'
    }
    if (index === this.selectedIndex) {
      return '#EF5350'
    }
    return 'rgba(255, 255, 255, 0.2)'
  }

  private getOptionTextColor(index: number): string {
    if (!this.isAnswered) {
      return '#FFFFFF'
    }
    const correctIndex = this.getCorrectIndex()
    if (index === correctIndex) {
      return '#FFFFFF'
    }
    if (index === this.selectedIndex) {
      return '#FFFFFF'
    }
    return 'rgba(255, 255, 255, 0.7)'
  }

  private vibrateCorrect(): void {
    try {
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error('[WatchFlagToNamePage] Vibrate correct failed:', error)
        }
      })
      this.addTimer(() => {
        vibrator.vibrate(50, (error: BusinessError) => {
          if (error) {
            console.error('[WatchFlagToNamePage] Vibrate correct (2) failed:', error)
          }
        })
      }, 90)
    } catch (error) {
      console.error('[WatchFlagToNamePage] Vibrate correct failed:', error)
    }
  }

  private vibrateIncorrect(): void {
    try {
      vibrator.vibrate(250, (error: BusinessError) => {
        if (error) {
          console.error('[WatchFlagToNamePage] Vibrate incorrect failed:', error)
        }
      })
    } catch (error) {
      console.error('[WatchFlagToNamePage] Vibrate incorrect failed:', error)
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

  @Builder
  private NameOptionButton(country: Country, index: number) {
    Row() {
      Text(getLocalizedCountryName(country, this.currentLanguage))
        .fontSize(14)
        .fontColor(this.getOptionTextColor(index))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('80%')
    .height(36)
    .padding({ left: 10, right: 10 })
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.getOptionBackgroundColor(index))
    .borderRadius(8)
    .border({ width: 1, color: this.getOptionBorderColor(index) })
    .margin({ bottom: 4 })
    .onClick(() => {
      this.selectOption(index)
    })
  }

  build() {
    Column() {
      Column() {
        Blank()
          .height(4)

        Column() {
          Column() {
            if (this.currentCountry) {
              Image($rawfile(`flags/${this.currentCountry.code}.svg`))
                .key(`${this.promptToken}-${this.currentCountry.code}`)
                .width(64)
                .height(40)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 4 })
            }
          }
          .scale({ x: this.promptScale, y: this.promptScale })
          .translate({ x: 0, y: this.promptOffsetY })
          .animation({ duration: this.promptAnimating ? 520 : 0, curve: Curve.EaseOut })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Column() {
            ForEach(this.choices, (country: Country, index: number) => {
              this.NameOptionButton(country, index)
            }, (country: Country, index: number) => `${this.optionsToken}-${country.code}-${index}`)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)

          if (this.isAnswered && !this.autoNext) {
            Button($r('app.string.watch_next_question'))
              .fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor($r('app.color.button_primary'))
              .borderRadius(8)
              .height(36)
              .width('80%')
              .margin({ top: 4 })
              .onClick(() => {
                this.goNextQuestion()
              })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 12, bottom: 2 })
        .opacity(this.showOptions ? 1 : 0)
        .animation({ duration: 200, curve: Curve.EaseOut })
      }
      .width('100%')
      .height('100%')
      .opacity(this.contentOpacity)
      .animation({ duration: 200, curve: Curve.EaseOut })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, bottom: 16, top: 24 })
    .backgroundColor('#000000')
  }
}
