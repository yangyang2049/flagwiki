import { CommonConstants } from '../constants/CommonConstants';
import { PlayConstants } from '../constants/PlayConstants';

@ObservedV2
export class PlayerModel {
  @Trace videoHeight: string = PlayConstants.PLAY_PLAYER_HEIGHT;
  @Trace videoWidth: string = CommonConstants.FULL_PERCENT;
  @Trace videoMargin: string = PlayConstants.MARGIN_ZERO;
  @Trace videoPosition: FlexAlign = FlexAlign.Center;
  @Trace playSpeed: number = PlayConstants.PLAY_SPEED;
  @Trace volume: number = PlayConstants.VOLUME;
  @Trace volumeShow: boolean = PlayConstants.VOLUME_SHOW;
  @Trace bright: number = PlayConstants.BRIGHT;
  @Trace brightShow: boolean = PlayConstants.BRIGHT_SHOW;
  @Trace currentTime: string = PlayConstants.PROGRESS_CURRENT_TIME;
  @Trace totalTime: string = PlayConstants.PROGRESS_TOTAL_TIME;
  @Trace progressVal: number = PlayConstants.PROGRESS_PROGRESS_VAL;
}