import { PlaylistCard, PlaylistCardComponent } from './PlaylistCard';
import { PlaylistModel } from 'lib_common';

@ComponentV2
export struct PlaylistCards {
  @Param playlists: PlaylistModel[] = [];
  @Param onCardClick: (card: PlaylistCard) => void = () => {
  };
  // 当前正在播放的歌单卡id（仅用于视觉切换）
  @Local playingCardId: string = '';

  getPlaylistCards(): Array<PlaylistCard> {
    const colors: string[] = ['#E8F4FD', '#FF8C00', '#007AFF', '#34C759', '#FF2D92', '#AF52DE'];

    return this.playlists.map((playlist: PlaylistModel, index: number): PlaylistCard => {
      const card: PlaylistCard = {
        id: (index + 1).toString(),
        title: playlist.title,
        subtitle: playlist.subTitle + '',
        bgColor: colors[index % colors.length],
        coverImage: playlist.cover
      };
      return card;
    });
  }

  build() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach(this.getPlaylistCards(), (card: PlaylistCard) => {
          PlaylistCardComponent({
            card: card,
            playlistModel: this.playlists[Number(card.id) - 1],
            onCardClick: (clickedCard: PlaylistCard) => this.onCardClick(clickedCard)
          })
        }, (card: PlaylistCard) => `playlist-${card.id}`)
      }
      .padding({ left: 16, right: 16 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
  }
}
