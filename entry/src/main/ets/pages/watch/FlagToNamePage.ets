import router from '@ohos.router'
import display from '@ohos.display'
import vibrator from '@ohos.vibrator'
import { BusinessError } from '@kit.BasicServicesKit'
import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import { Countries, Country, getLocalizedCountryName } from '../../utils/countryData'
import { PreferencesManager } from '../../utils/PreferencesManager'
import { WatchSoundManager } from '../../utils/WatchSoundManager'

type Difficulty = 'easy' | 'medium' | 'hard'
interface ReviewItem {
  country: Country
  delayRounds: number
}

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
  @State optionTextWidth: number = 200
  @State autoNext: boolean = true
  @State vibrationEnabled: boolean = true
  @State soundEnabled: boolean = true
  @State difficulty: Difficulty = 'medium'
  @State isTransitioning: boolean = false
  @State showResults: boolean = false

  private prefs: preferences.Preferences | null = null
  private countryPool: Country[] = []
  private sessionPlan: Country[] = []
  private sessionCursor: number = 0
  private pendingReviews: ReviewItem[] = []
  private activeReviews: Country[] = []
  private timeoutIds: number[] = []
  private context: common.UIAbilityContext | null = null
  private hasStarted: boolean = false

  async aboutToAppear() {
    this.ensureContext()
    this.updateOptionMetrics()
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
      this.ensureContext()
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

  private buildSessionPlan(): void {
    const pool = this.countryPool.length > 0 ? this.countryPool : Countries
    const sorted = [...pool].sort((a, b) => b.population - a.population)
    const total = Math.min(this.totalQuestions, sorted.length)
    const plan: Country[] = []
    const used = new Set<string>()
    if (total <= 0) {
      this.sessionPlan = []
      this.sessionCursor = 0
      return
    }
    for (let i = 0; i < total; i++) {
      const start = Math.floor((i * sorted.length) / total)
      const end = Math.max(start, Math.floor(((i + 1) * sorted.length) / total) - 1)
      const bucket = sorted.slice(start, end + 1).filter(item => !used.has(item.code))
      let pick: Country | undefined = undefined
      if (bucket.length > 0) {
        pick = bucket[Math.floor(Math.random() * bucket.length)]
      } else {
        pick = sorted.find(item => !used.has(item.code))
      }
      if (pick) {
        plan.push(pick)
        used.add(pick.code)
      }
    }
    if (this.activeReviews.length > 0 && plan.length > 0) {
      const indices = plan.map((_, index) => index)
      const remaining: ReviewItem[] = []
      for (const review of this.activeReviews) {
        if (used.has(review.code)) {
          continue
        }
        if (indices.length === 0) {
          remaining.push({ country: review, delayRounds: 1 })
          continue
        }
        const pickIndex = Math.floor(Math.random() * indices.length)
        const replaceIndex = indices.splice(pickIndex, 1)[0]
        const replaced = plan[replaceIndex]
        if (replaced) {
          used.delete(replaced.code)
        }
        plan[replaceIndex] = review
        used.add(review.code)
      }
      if (remaining.length > 0) {
        this.pendingReviews = [...this.pendingReviews, ...remaining]
      }
    }
    this.activeReviews = []
    this.sessionPlan = plan
    this.sessionCursor = 0
  }

  private getNextCountry(pool: Country[]): Country | null {
    if (this.sessionCursor < this.sessionPlan.length) {
      const next = this.sessionPlan[this.sessionCursor]
      this.sessionCursor += 1
      return next
    }
    if (pool.length === 0) {
      return null
    }
    return pool[Math.floor(Math.random() * pool.length)] ?? null
  }

  private scheduleReview(country: Country): void {
    const exists = this.pendingReviews.some(item => item.country.code === country.code) ||
      this.activeReviews.some(item => item.code === country.code)
    if (exists) {
      return
    }
    const delayRounds = Math.random() < 0.5 ? 1 : 2
    const item: ReviewItem = { country, delayRounds }
    this.pendingReviews.push(item)
  }

  private advanceReviewRounds(): void {
    if (this.pendingReviews.length === 0) {
      this.activeReviews = []
      return
    }
    const nextPending: ReviewItem[] = []
    const ready: Country[] = []
    for (const item of this.pendingReviews) {
      const remaining = item.delayRounds - 1
      if (remaining <= 0) {
        ready.push(item.country)
      } else {
        nextPending.push({ country: item.country, delayRounds: remaining })
      }
    }
    this.pendingReviews = nextPending
    this.activeReviews = ready
  }

  private startQuestion(resetProgress: boolean = false): void {
    if (resetProgress) {
      this.questionIndex = 0
      this.correctCount = 0
      if (!this.hasStarted) {
        this.hasStarted = true
        this.pendingReviews = []
        this.activeReviews = []
      } else {
        this.advanceReviewRounds()
      }
      this.buildSessionPlan()
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
    const nextCountry = this.getNextCountry(pool)
    if (!nextCountry) {
      return
    }
    this.currentCountry = nextCountry
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
    } else if (this.currentCountry) {
      this.scheduleReview(this.currentCountry)
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

    const answerHoldDelay = 400
    const answerGapDelay = 400

    this.addTimer(() => {
      this.showOptions = false
      this.contentOpacity = 0
      this.currentCountry = null
      this.choices = []
    }, answerHoldDelay)

    this.addTimer(() => {
      if (this.questionIndex + 1 >= this.totalQuestions) {
        // Show results screen instead of auto-restarting
        this.showResults = true
      } else {
        this.questionIndex += 1
        this.startQuestion()
      }
    }, answerHoldDelay + answerGapDelay)
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
      return '#34C759'
    }
    if (index === this.selectedIndex) {
      return '#FF453A'
    }
    return 'rgba(255, 255, 255, 0.1)'
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

  private updateOptionMetrics(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync()
      const screenWidth = px2vp(displayInfo.width)
      const containerPadding = 32
      const optionRowWidth = Math.max(0, (screenWidth - containerPadding) * 0.8)
      this.optionTextWidth = Math.max(0, optionRowWidth - 20)
    } catch (error) {
      console.error('[WatchFlagToNamePage] Failed to get display info:', error)
    }
  }

  private getOptionName(country: Country): string {
    return getLocalizedCountryName(country, this.currentLanguage)
  }

  private estimateTextUnits(text: string): number {
    let units = 0
    for (const char of text) {
      if (char === ' ' || char === '-' || char === '.' || char === ',' || char === '\'') {
        units += 0.5
      } else {
        units += 1
      }
    }
    return units
  }

  private getMaxUnitsForFont(fontSize: number): number {
    if (this.optionTextWidth <= 0) {
      return 0
    }
    const averageCharWidth = fontSize * 0.56
    const perLine = Math.floor(this.optionTextWidth / averageCharWidth)
    return Math.max(1, perLine * 2)
  }

  private getOptionFontSize(country: Country): number {
    const name = this.getOptionName(country)
    const units = this.estimateTextUnits(name)
    const maxUnits = this.getMaxUnitsForFont(14)
    if (units > maxUnits) {
      return 12
    }
    return 14
  }

  private getOptionLineHeight(country: Country): number {
    return this.getOptionFontSize(country) + 2
  }

  @Builder
  private NameOptionButton(country: Country, index: number) {
    Row() {
      Text(this.getOptionName(country))
        .fontSize(this.getOptionFontSize(country))
        .fontColor(this.getOptionTextColor(index))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .lineHeight(this.getOptionLineHeight(country))
    }
    .width('80%')
    .height(36)
    .padding({ left: 10, right: 10 })
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.getOptionBackgroundColor(index))
    .borderRadius(8)
    .margin({ bottom: 4 })
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
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 12, bottom: 2 })
          .opacity(this.showOptions ? 1 : 0)
          .animation({ duration: 200, curve: Curve.EaseOut })
        }
        .opacity(this.contentOpacity)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, bottom: 16, top: 24 })
    .backgroundColor('#000000')
  }
}
