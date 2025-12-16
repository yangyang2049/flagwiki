import ImageUtils from 'module_musicplay/src/main/ets/utils/ImageUtils';
import { getMusicModel, MediaService, MusicModel, SongItem } from 'module_musicplay';
import { PlaylistModel, ResManager } from 'lib_common';

export interface PlaylistCard {
  id: string;
  title: string;
  subtitle: string;
  bgColor: string;
  coverImage: string | Resource;
}

@ComponentV2
export struct PlaylistCardComponent {
  @Param card: PlaylistCard = {
    id: '',
    title: '',
    subtitle: '',
    bgColor: '',
    coverImage: ''
  };
  @Param onCardClick: (card: PlaylistCard) => void = () => {
  };
  // 全局音乐模型（用于联动图标与点击逻辑）
  @Local musicModel: MusicModel = getMusicModel();
  // 该卡片关联的实际歌单（用于一次性替换播放列表）
  @Param playlistModel: PlaylistModel | undefined = undefined;
  @Local overlayColor: string = 'rgba(0,0,0,1)';

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

  @Monitor('card')
  updateOverlayColor() {
    // 无论封面是字符串路径还是资源，统一按资源方式提取主色
    ImageUtils.getImageDealData(getContext(this), this.card.coverImage).then((data) => {
      this.overlayColor = data.imageColor;
    })
  }

  aboutToAppear(): void {
    this.updateOverlayColor();
  }

  private adjustAlpha(color: string, alpha: number): string {
    if (color.startsWith('rgba(')) {
      const parts: string[] = color.replace('rgba(', '').replace(')', '').split(',');
      if (parts.length >= 3) {
        const r: string = parts[0].trim();
        const g: string = parts[1].trim();
        const b: string = parts[2].trim();
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
      }
    }
    return color;
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Row() {
          Image(ResManager.getPic(this.card.coverImage))
            .width('100%')
            .height('100%')
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        }
        .width('100%')
        .height('100%')
        .borderRadius(8)

        // 添加蒙层效果（颜色随封面主色变化）
        Column()
          .width('100%')
          .height(60)
          .linearGradient({
            direction: GradientDirection.Top,
            colors: [
              [this.adjustAlpha(this.overlayColor, 0.5), 0.0],
              [this.adjustAlpha(this.overlayColor, 0.7), 0.5],
              [this.adjustAlpha(this.overlayColor, 0.9), 1.0]
            ]
          })
          .borderRadius({
            bottomLeft: 8,
            bottomRight: 8
          })
          .align(Alignment.Bottom)

        Row() {
          Column() {
            Text(this.card.title)
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            Text(this.card.subtitle)
              .fontSize(12)
              .fontColor('rgba(255,255,255,0.9)')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          // 封面右下角播放/播放中图标（与全局播放状态联动，并判断是否当前歌单）
          Image((this.musicModel.isPlay && this.isSameList(this.musicModel.songList, this.playlistModel?.songList)) ?
          $r('app.media.ic_public_pause') : $r('app.media.ic_public_play'))
            .width(31)
            .height(31)
            .fillColor(Color.White)
            .onClick(() => {
              // 若这张卡对应的歌单就是当前播放列表，则切换播放/暂停；否则替换列表并开始播放
              if (this.playlistModel && this.playlistModel.songList && this.playlistModel.songList.length > 0) {
                if (this.isSameList(this.musicModel.songList, this.playlistModel.songList)) {
                  MediaService.getInstance().playAndPause();
                } else {
                  MediaService.getInstance().playAllSongs(this.playlistModel.songList);
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
    .width(160)
    .height(220)
    .onClick(() => {
      this.onCardClick(this.card);
    })
  }
}
