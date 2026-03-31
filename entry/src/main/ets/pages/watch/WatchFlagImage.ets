import { image } from '@kit.ImageKit'
import { getFlagImageSource } from '../../utils/countryData'

/**
 * 手表端国旗：国际组织为包内 PNG（Resource）；国家为解压后的 SVG（file URI）。
 * 若 ImageKit 能将 SVG 栅格化为 PixelMap 则优先显示位图；否则与 Flashcard 等页一致，仅用 Image(uri)。
 * 不在解码失败时用占位图替换 URI，避免 wearable 上 createPixelMap(SVG) 常失败却 Image(uri) 仍可用的情况。
 */
@Component
export struct WatchFlagImage {
  @Prop code: string = ''
  @Prop flagWidth: number | string = '100%'
  @Prop flagHeight: number = 44
  @State private raster: image.PixelMap | null = null

  aboutToAppear(): void {
    this.releaseRaster()
    const src = getFlagImageSource(this.code)
    if (typeof src === 'string') {
      void this.rasterizeSvgUriToPixelMap(src)
    }
  }

  aboutToDisappear(): void {
    this.releaseRaster()
  }

  private releaseRaster(): void {
    if (this.raster) {
      try {
        this.raster.release()
      } catch (_) {
        // ignore
      }
      this.raster = null
    }
  }

  private async rasterizeSvgUriToPixelMap(uri: string): Promise<void> {
    try {
      const imgSource = image.createImageSource(uri)
      const pm = await imgSource.createPixelMap({ desiredSize: { width: 512, height: 384 } })
      this.raster = pm
    } catch (e) {
      // 穿戴端常无法将 SVG 解码为 PixelMap，回退分支使用 Image(uri)，与 Continent/Flashcard 一致
      console.info('[WatchFlagImage] SVG PixelMap unavailable, using Image(uri):', e)
    }
  }

  @Builder
  private FlagLayerWithSrc(src: Resource | string) {
    if (typeof src !== 'string') {
      Image(src)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (this.raster !== null) {
      Image(this.raster)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else {
      Image(src)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.FlagLayerWithSrc(getFlagImageSource(this.code))
    }
    .width(this.flagWidth)
      .height(this.flagHeight)
  }
}
