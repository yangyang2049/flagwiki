import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import { PreferencesManager } from '../../utils/PreferencesManager'
import { WatchSoundManager } from '../../utils/WatchSoundManager'
import { WatchLayout } from '../../utils/WatchUiConstants'

@Component
export struct SettingsPage {
  @State vibrationEnabled: boolean = true
  @State soundEnabled: boolean = true

  private prefs: preferences.Preferences | null = null
  private context: common.UIAbilityContext | null = null

  async aboutToAppear() {
    await this.initPreferences()
    await this.loadSettings()
  }

  private async initPreferences(): Promise<void> {
    if (this.prefs) {
      return
    }
    try {
      this.prefs = await PreferencesManager.getPreferences('watch_settings')
    } catch (error) {
      console.error('[WatchSettingsPage] Failed to init preferences:', error)
    }
  }

  private async loadSettings(): Promise<void> {
    try {
      if (!this.prefs) {
        return
      }
      this.vibrationEnabled = await this.prefs.get('vibration_enabled', true) as boolean
      this.soundEnabled = await this.prefs.get('sound_enabled', true) as boolean
    } catch (error) {
      console.error('[WatchSettingsPage] Failed to load settings:', error)
    }
  }

  private async saveSetting(key: string, value: string | number | boolean): Promise<void> {
    try {
      if (!this.prefs) {
        return
      }
      await this.prefs.put(key, value)
      await this.prefs.flush()
    } catch (error) {
      console.error(`[WatchSettingsPage] Failed to save ${key}:`, error)
    }
  }

  build() {
    Column() {
      Text($r('app.string.watch_settings'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.button_primary'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 8, bottom: 8 })

      Scroll() {
        Column() {
          Row() {
            Text($r('app.string.sound'))
              .fontSize(14)
              .fontColor('#FFFFFF')

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.soundEnabled })
              .selectedColor($r('app.color.button_primary'))
              .onChange(async (isOn: boolean) => {
                this.soundEnabled = isOn
                await this.saveSetting('sound_enabled', isOn)
                if (isOn) {
                  if (!this.context) {
                    this.context = this.getUIContext()?.getHostContext() as common.UIAbilityContext
                  }
                  if (this.context) {
                    void WatchSoundManager.initialize(this.context)
                  }
                }
              })
          }
          .width('100%')
          .height(44)
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .backgroundColor('rgba(255, 255, 255, 0.1)')
          .borderRadius(8)
          .margin({ top: WatchLayout.listItemCompactGap, bottom: WatchLayout.listItemCompactGap })

          Row() {
            Text($r('app.string.watch_vibration_feedback'))
              .fontSize(14)
              .fontColor('#FFFFFF')

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.vibrationEnabled })
              .selectedColor($r('app.color.button_primary'))
              .onChange(async (isOn: boolean) => {
                this.vibrationEnabled = isOn
                await this.saveSetting('vibration_enabled', isOn)
              })
          }
          .width('100%')
          .height(44)
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .backgroundColor('rgba(255, 255, 255, 0.1)')
          .borderRadius(8)
          .margin({ top: WatchLayout.listItemCompactGap, bottom: WatchLayout.listItemCompactGap })

          Column() {
            Text($r('app.string.watch_phone_version_richer'))
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.6)')
              .textAlign(TextAlign.Center)
              .margin({ top: 16, bottom: 8 })

            Text($r('app.string.watch_company_name'))
              .fontSize(11)
              .fontColor('rgba(255, 255, 255, 0.5)')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .margin({ top: WatchLayout.listItemGap })
        }
        .width('80%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 4, bottom: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .focusable(true)
      .defaultFocus(true)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#000000')
  }
}
