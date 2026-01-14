import router from '@ohos.router'
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
struct NameToFlagPage {
  @StorageLink('currentLanguage') currentLanguage: string = 'zh'
  @State currentCountry: Country | null = null
  @State choices: Country[] = []
  @State selectedIndex: number = -1
  @State isAnswered: boolean = false
  @State questionIndex: number = 0
  @State totalQuestions: number = 10
  @State correctCount: number = 0
  @State optionsToken: number = 0
  @State promptOpacity: number = 0
  @State showOptions: boolean = false
  @State contentOpacity: number = 1
  @State autoNext: boolean = true
  @State vibrationEnabled: boolean = true
  @State soundEnabled: boolean = true
  @State difficulty: Difficulty = 'medium'
  @State isTransitioning: boolean = false
  @State showResults: boolean = false

  private prefs: preferences.Preferences | null = null
  private countryPool: Country[] = []
  private timeoutIds: number[] = []
  private context: common.UIAbilityContext | null = null

  async aboutToAppear() {
    this.ensureContext()
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
      console.error('[WatchNameToFlagPage] Failed to init preferences:', error)
    }
  }

  private async loadSettings(): Promise<void> {
    try {
      if (!this.prefs) {
        return
      }
      this.difficulty = await this.prefs.get('difficulty', 'medium') as Difficulty
      this.totalQuestions = await this.prefs.get('question_count', 10) as number
      this.autoNext = true
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean
      this.soundEnabled = await this.prefs.get('sound_enabled', true) as boolean
    } catch (error) {
      console.error('[WatchNameToFlagPage] Failed to load settings:', error)
    }
  }

  private initSoundManager(): void {
    if (!this.soundEnabled) {
      return
    }
    try {
      this.ensureContext()
      if (this.context) {
        void WatchSoundManager.initialize(this.context)
      }
    } catch (error) {
      console.error('[WatchNameToFlagPage] Failed to init sound manager:', error)
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
    this.promptOpacity = 0
    this.contentOpacity = 1
    this.currentCountry = null
    this.choices = []

    const contentSwapDelay = 30
    const promptFadeDelay = 80
    const optionsRevealDelay = 320

    this.addTimer(() => {
      this.pickQuestion()
    }, contentSwapDelay)

    this.addTimer(() => {
      this.promptOpacity = 1
    }, promptFadeDelay)

    this.addTimer(() => {
      this.showOptions = true
      this.isTransitioning = false
    }, optionsRevealDelay)
  }

  private pickQuestion(): void {
    const pool = this.countryPool.length >= 4 ? this.countryPool : Countries
    const randomIndex = Math.floor(Math.random() * pool.length)
    this.currentCountry = pool[randomIndex]
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

    this.isTransitioning = true

    this.addTimer(() => {
      this.showOptions = false
      this.contentOpacity = 0
    }, 400)

    this.addTimer(() => {
      if (this.questionIndex + 1 >= this.totalQuestions) {
        // Show results screen instead of auto-restarting
        this.showResults = true
      } else {
        this.questionIndex += 1
        this.startQuestion()
      }
    }, 900)
  }

  private startNextRound(): void {
    this.showResults = false
    this.questionIndex = 0
    this.correctCount = 0
    this.startQuestion(true)
  }

  private exitGame(): void {
    router.back()
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


  private getPromptText(): string {
    if (!this.currentCountry) {
      return ''
    }
    return getLocalizedCountryName(this.currentCountry, this.currentLanguage)
  }

  private ensureContext(): void {
    if (!this.context) {
      this.context = this.getUIContext()?.getHostContext() as common.UIAbilityContext
    }
  }

  private getResultScoreText(): string {
    this.ensureContext()
    if (!this.context) {
      return ''
    }
    return this.context.resourceManager.getStringSync(
      $r('app.string.watch_result_score').id,
      this.correctCount.toString(),
      this.totalQuestions.toString()
    )
  }

  private getResultRatingText(): string {
    this.ensureContext()
    if (!this.context) {
      return ''
    }
    const ratio = this.totalQuestions > 0 ? this.correctCount / this.totalQuestions : 0
    let ratingRes = $r('app.string.watch_result_work_better')
    if (ratio >= 1) {
      ratingRes = $r('app.string.watch_result_perfect')
    } else if (ratio >= 0.9) {
      ratingRes = $r('app.string.watch_result_excellent')
    } else if (ratio >= 0.75) {
      ratingRes = $r('app.string.watch_result_good')
    } else if (ratio >= 0.6) {
      ratingRes = $r('app.string.watch_result_soso')
    } else if (ratio >= 0.4) {
      ratingRes = $r('app.string.watch_result_not_good')
    }
    return this.context.resourceManager.getStringSync(ratingRes.id)
  }

  private vibrateCorrect(): void {
    try {
      vibrator.vibrate(50, (error: BusinessError) => {
        if (error) {
          console.error('[WatchNameToFlagPage] Vibrate correct failed:', error)
        }
      })
      this.addTimer(() => {
        vibrator.vibrate(50, (error: BusinessError) => {
          if (error) {
            console.error('[WatchNameToFlagPage] Vibrate correct (2) failed:', error)
          }
        })
      }, 90)
    } catch (error) {
      console.error('[WatchNameToFlagPage] Vibrate correct failed:', error)
    }
  }

  private vibrateIncorrect(): void {
    try {
      vibrator.vibrate(250, (error: BusinessError) => {
        if (error) {
          console.error('[WatchNameToFlagPage] Vibrate incorrect failed:', error)
        }
      })
    } catch (error) {
      console.error('[WatchNameToFlagPage] Vibrate incorrect failed:', error)
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
  private FlagGridItem(country: Country, index: number) {
    Column() {
      Image($rawfile(`flags/${country.code}.svg`))
        .width(52)
        .height(36)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.getOptionBackgroundColor(index))
    .borderRadius(8)
    .onClick(() => {
      this.selectOption(index)
    })
  }

  build() {
    Column() {
      if (this.showResults) {
        // Results screen
        Column() {
          Text(this.getResultScoreText())
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 16 })

          Text(this.getResultRatingText())
            .fontSize(16)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 32 })

          Button($r('app.string.watch_next_round'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor($r('app.color.button_primary'))
            .borderRadius(8)
            .height(44)
            .width('60%')
            .margin({ bottom: 12 })
            .onClick(() => {
              this.startNextRound()
            })

          Button($r('app.string.watch_exit'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .borderRadius(8)
            .height(44)
            .width('60%')
            .onClick(() => {
              this.exitGame()
            })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#000000')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // Game screen
        Column() {
          Blank()
            .height(12)

          Column() {
            Column() {
              Text(this.getPromptText())
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .textAlign(TextAlign.Center)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('80%')
                .margin({ bottom: 4 })
            }
            .opacity(this.promptOpacity)
            .animation({ duration: 240, curve: Curve.EaseOut })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Grid() {
              ForEach(this.choices, (country: Country, index: number) => {
                GridItem() {
                  this.FlagGridItem(country, index)
                }
              }, (country: Country, index: number) => `${this.optionsToken}-${country.code}-${index}`)
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .columnsGap(4)
            .rowsGap(4)
            .width('85%')
            .height(140)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 12, bottom: 2 })
          .opacity(this.showOptions ? 1 : 0)
          .animation({ duration: 200, curve: Curve.EaseOut })
        }
      .
      width('100%')
        .height('100%')
        .padding({
          left: 16,
          right: 16,
          bottom: 16,
          top: 24
        })
        .backgroundColor('#000000')
    }
  }}}
