import { ThemeController } from 'module_theme';
import { getMusicModel, MediaService, MusicModel, SongItem } from 'module_musicplay';
import { PlaylistModel, ResManager, RouterMap, RouterUtils } from 'lib_common';

@ComponentV2
export struct PlaylistSection {
  @Param title: string = '';
  @Param playlists: PlaylistModel[] = [];
  @Param onSongClick: (song: SongItem) => void = () => {
  };
  @Local musicModel: MusicModel = getMusicModel();

  private isSameList(a?: SongItem[], b?: SongItem[]): boolean {
    if (!a || !b) {
      return false;
    }
    if (a.length !== b.length) {
      return false;
    }
    for (let i = 0; i < a.length; i++) {
      const idA = (a[i] && a[i].id) ? a[i].id : '';
      const idB = (b[i] && b[i].id) ? b[i].id : '';
      if (idA !== idB) {
        return false;
      }
    }
    return true;
  }

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontColor(ThemeController.theme.themeColors[2])
          .fontWeight(FontWeight.Bold)
        Blank()
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 20,
        bottom: 12
      })

      Scroll() {
        Row({ space: 12 }) {
          ForEach(this.playlists, (playlist: PlaylistModel) => {
            Column() {
              Stack({ alignContent: Alignment.Bottom }) {
                Row() {
                  Image(ResManager.getPic(playlist.cover))
                    .width('100%')
                    .height('100%')
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)
                }
                .width('100%')
                .height('100%')
                .borderRadius(8)

                Row() {
                  Column() {
                    Text(playlist.title)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                    Text(playlist.subTitle)
                      .fontSize(12)
                      .fontColor(Color.White)
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)

                  Image((this.musicModel.isPlay && this.isSameList(this.musicModel.songList, playlist.songList)) ?
                  $r('app.media.ic_public_pause') : $r('app.media.ic_public_play'))
                    .width(28)
                    .height(28)
                    .fillColor(Color.White)
                    .onClick(() => {
                      if (playlist.songList && playlist.songList.length > 0) {
                        if (this.isSameList(this.musicModel.songList, playlist.songList)) {
                          MediaService.getInstance().playAndPause();
                        } else {
                          MediaService.getInstance().playAllSongs(playlist.songList);
                        }
                      }
                    })
                }
                .padding({ bottom: 12, left: 12, right: 12 })
                .height(50)
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Bottom)
              }
            }
            .width('40%')
            .aspectRatio(1)
            .onClick(() => {
              RouterUtils.pushPathByName(RouterMap.SONG_LIST_PAGE, playlist);
            })
          }, (playlist: PlaylistModel, index: number) => `playlist-${index}`)
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
  }
}
