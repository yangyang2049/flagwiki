import { media } from '@kit.MediaKit'
import { audio } from '@kit.AudioKit'
import { common } from '@kit.AbilityKit'

export class WatchSoundManager {
  private static soundPool: media.SoundPool | null = null
  private static loadedSounds: Map<string, number> = new Map()
  private static context: common.UIAbilityContext | null = null
  private static isInitializing: boolean = false

  static async initialize(context: common.UIAbilityContext): Promise<void> {
    if (WatchSoundManager.soundPool || WatchSoundManager.isInitializing) {
      return
    }

    WatchSoundManager.isInitializing = true
    WatchSoundManager.context = context

    try {
      const audioRendererInfo: audio.AudioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
        rendererFlags: 1
      }

      WatchSoundManager.soundPool = await media.createSoundPool(4, audioRendererInfo)

      await WatchSoundManager.loadSound('correct.mp3')
      await WatchSoundManager.loadSound('incorrect.mp3')
    } catch (err) {
      console.error('[WatchSoundManager] Failed to create SoundPool:', err)
      WatchSoundManager.soundPool = null
    } finally {
      WatchSoundManager.isInitializing = false
    }
  }

  static async release(): Promise<void> {
    try {
      if (WatchSoundManager.soundPool) {
        WatchSoundManager.soundPool.release()
      }
    } catch (err) {
      console.error('[WatchSoundManager] Failed to release SoundPool:', err)
    } finally {
      WatchSoundManager.soundPool = null
      WatchSoundManager.loadedSounds.clear()
      WatchSoundManager.context = null
      WatchSoundManager.isInitializing = false
    }
  }

  private static async loadSound(fileName: string): Promise<number> {
    if (!WatchSoundManager.soundPool || !WatchSoundManager.context) {
      return -1
    }

    const existing = WatchSoundManager.loadedSounds.get(fileName)
    if (existing && existing > 0) {
      return existing
    }

    try {
      const resourceManager = WatchSoundManager.context.resourceManager
      const fileDescriptor = resourceManager.getRawFdSync(fileName)

      const soundId = await WatchSoundManager.soundPool.load(
        fileDescriptor.fd,
        fileDescriptor.offset,
        fileDescriptor.length
      )

      if (soundId > 0) {
        WatchSoundManager.loadedSounds.set(fileName, soundId)
      }

      return soundId
    } catch (err) {
      console.error(`[WatchSoundManager] Failed to load ${fileName}:`, err)
      return -1
    }
  }

  static async play(soundType: 'correct' | 'incorrect'): Promise<void> {
    let waitCount = 0
    const maxWait = 20

    while (WatchSoundManager.isInitializing && waitCount < maxWait) {
      await new Promise<void>(resolve => setTimeout(resolve, 50))
      waitCount++
    }

    if (waitCount >= maxWait) {
      console.warn('[WatchSoundManager] Initialization timeout after 1 second')
      return
    }

    if (!WatchSoundManager.soundPool) {
      if (WatchSoundManager.context) {
        await WatchSoundManager.initialize(WatchSoundManager.context)
      } else {
        return
      }
    }

    if (!WatchSoundManager.soundPool) {
      console.warn('[WatchSoundManager] SoundPool not available after initialization')
      return
    }

    const fileName = soundType === 'incorrect' ? 'incorrect.mp3' : 'correct.mp3'

    try {
      let soundId = WatchSoundManager.loadedSounds.get(fileName)
      if (soundId === undefined || soundId <= 0) {
        soundId = await WatchSoundManager.loadSound(fileName)
        if (soundId === undefined || soundId <= 0) {
          return
        }
      }

      const playParameters: media.PlayParameters = {
        loop: 0,
        rate: audio.AudioRendererRate.RENDER_RATE_NORMAL,
        leftVolume: 1.0,
        rightVolume: 1.0,
        priority: 0
      }

      await WatchSoundManager.soundPool.play(soundId, playParameters)
    } catch (err) {
      console.error(`[WatchSoundManager] Failed to play ${soundType}:`, err)
    }
  }
}
