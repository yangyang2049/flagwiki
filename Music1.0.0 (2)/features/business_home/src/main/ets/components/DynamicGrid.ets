import { SongItem } from 'module_musicplay';
import { SongItemComponent } from './SongItemComponent';

@ComponentV2
export struct DynamicGrid {
  @Param songs: SongItem[] = [];
  @Param uniqueKey: string = '';
  @Param onSongClick: (song: SongItem) => void = () => {
  };
  // 非按钮区域点击：用于打开播放页
  @Param onSongAreaClick: (song: SongItem) => void = () => {
  };
  // 当前播放歌曲id与播放状态，由上层传入控制每一项的图标展示
  @Param currentSongId: string = '';
  @Param currentSongSrc: string = '';
  @Param isPlaying: boolean = false;

  @Builder
  buildColumn(songs: Array<SongItem>, startIndex: number, uniqueKey: string, columnIndex: number) {
    Column({ space: 0 }) {
      ForEach(songs.slice(startIndex, startIndex + 3), (song: SongItem) => {
        SongItemComponent({
          song: song,
          onSongClick: (clickedSong: SongItem) => this.onSongClick(clickedSong),
          onSongAreaClick: (clickedSong: SongItem) => this.onSongAreaClick(clickedSong)
        })
      }, (song: SongItem, index: number) => `${uniqueKey}-col${columnIndex}-${song.id}-${index}`)
    }
    .width('85%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }

  build() {
    Scroll() {
      Row({ space: 20 }) {
        // 使用条件渲染来动态显示列
        this.buildColumn(this.songs, 0, this.uniqueKey, 1)

        if (this.songs.length > 3) {
          this.buildColumn(this.songs, 3, this.uniqueKey, 2)
        }

        if (this.songs.length > 6) {
          this.buildColumn(this.songs, 6, this.uniqueKey, 3)
        }

        Row() {
        }
        .width('15%')
        .height(240)
      }
      .alignItems(VerticalAlign.Top)
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}
