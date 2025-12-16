import { VideoController } from '../controller/VideoController';
import { PlayConstants } from '../common/constants/PlayConstants';
import { PlayerModel } from '../common/model/PlayerModel';
import { VideoItem } from '../viewmodel/VideoItem';

@ComponentV2
export struct PlayPlayer {
  @Consumer() playVideoModel: VideoController = new VideoController();
  @Consumer() videoList: VideoItem[] = []
  @Consumer() playerModel?: PlayerModel;
  @Consumer() xComponentWidth: number = 0
  @Consumer() xComponentHeight: number = 0
  @Consumer() videoWidth: number = 0
  @Consumer() videoHeight: number = 0
  @Consumer() isLandscape: boolean = false;
  @Local aspect: number = 9 / 16;
  private xComponentController: XComponentController = new XComponentController();
  private surfaceID: string = '';

  getComponentHeight(): string {
    if (this.isLandscape) {
      return '100%'
    } else {
      return vp2px(this.xComponentHeight) + 'px'
    }
  }

  getVideoHeight(): string {
    return vp2px(this.videoHeight) + 'px'
  }

  build() {
    Row() {
      XComponent({
        id: PlayConstants.PLAYER_ID,
        type: PlayConstants.PLAYER_TYPE,
        controller: this.xComponentController,
      })
        .onLoad(async () => {
          this.xComponentController.setXComponentSurfaceRect({
            surfaceWidth: PlayConstants.PLAYER_SURFACE_WIDTH,
            surfaceHeight: PlayConstants.PLAYER_SURFACE_HEIGHT
          });
          this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          if (this.videoList.length > 0) {
            this.playVideoModel!.firstPlay(this.videoList, this.surfaceID);
          }
        })
        .width(vp2px(this.videoWidth) + 'px')
        .height(this.getVideoHeight())
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}