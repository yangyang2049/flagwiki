import { ResManager, singleClick } from 'lib_common';
import { SongItem } from 'lib_music_api/src/main/ets/params/response/SongItem';
import { MarkViewModel } from '../viewmodels/MarkVM';

@ComponentV2
export struct CollectedSongItem {
  @Param @Require item: SongItem;
  @Param @Require index: number = 0;
  @Local vm: MarkViewModel = new MarkViewModel();
  @Local selectedSong: SongItem = new SongItem(); // 用于存储选中的歌曲信息
  @Local isCollected: boolean = false;
  @Param sources: string = 'mark'; //mark:收藏 local:本地
  @Event onBackCall: Function;
  // 操作回调函数
  @Event onOperationCallback: (value: SongItem) => void = () => {
  }

  aboutToAppear(): void {
    this.isCollected = this.item.isCollected;
  }

  /**
   * 收藏监听
   * @param value
   */
  @Monitor('item.isCollected')
  collectedMonitor(value: boolean) {
    this.isCollected = value;
  }

  build() {
    Column() {
      Row() {
        Column() {
          Image(ResManager.getPic(this.item.label ?? 'ic_dream'))
            .width(48)
            .height(48)
            .borderRadius(4)
            .alignSelf(ItemAlign.Center)
        }
        .width(48)
        .alignItems(HorizontalAlign.Center)
        .padding({
          left: 16,
          right: 16
        })

        Column() {
          Text(this.item.title)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          Row({ space: 4 }) {
            Image($r('app.media.ic_local'))
              .width(25)
              .height(16)
              .visibility(this.item.isLocal ? Visibility.Visible : Visibility.None)
            Image($r('app.media.ic_vip'))
              .width(25)
              .height(16)
              .visibility(this.item.isVip ? Visibility.Visible : Visibility.None)
            Text(this.item.singer)
              .fontSize(12)
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          }
        }
        .padding({
          left: 16,
        })
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        if (this.sources === 'mark') {
          SymbolGlyph($r('sys.symbol.heart_fill'))
            .fontSize(28)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
            .fontColor([$r('app.color.app_theme')])
            .onClick(() => {
              this.onOperationCallback(this.item)
            })
        } else if (this.sources === 'local') {
          Column() {
            SymbolGlyph($r('sys.symbol.trash'))
              .fontSize(25)
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
          }
          .width(38)
          .height(38)
          .backgroundColor('#0D000000')
          .borderRadius(50)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(singleClick(() => {
            this.onOperationCallback(this.item)
          }))
        }
      }
      .margin({
        left: 16,
        right: 16,
        top: 16,
        bottom: 16
      })
      .onClick(() => {
        this.selectedSong = this.item;
        this.vm.mediaService.playSong(this.item as SongItem, true)
      })
    }
    .width('100%')
  }
}

