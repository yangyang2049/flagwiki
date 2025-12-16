/**
 * Play constants for all features.
 */
export class PlayConstants {
  /**
   * Playback page constant.
   */
  static readonly PLAY_SPEED: number = 1;
  static readonly VOLUME: number = 0.5;
  static readonly VOLUME_SHOW: boolean = false;
  static readonly BRIGHT: number = 0.5;
  static readonly BRIGHT_SHOW: boolean = false;
  static readonly POSITION_X: number = 0;
  static readonly POSITION_Y: number = 0;
  static readonly HEIGHT: string = '7.2%';
  static readonly PLAY_PLAYER_HEIGHT: string = '25.6%';
  static readonly PLAY_PLAYER_HEIGHT_FULL: string = '75.4%';
  static readonly PLAY_PROGRESS_HEIGHT: string = '7.1%';
  static readonly COLUMN_HEIGHT_ONE: string = '26.9%';
  static readonly COLUMN_HEIGHT_TWO: string = '22.9%';
  static readonly MIN_ANGLE: number = 0;
  static readonly MAX_ANGLE: number = 30;
  static readonly MIN_VALUE: number = 0;
  static readonly MAX_VALUE: number = 1;
  static readonly DISAPPEAR_TIME: number = 200;
  static readonly MARGIN_ZERO: string = '0';
  /**
   * Video playback constant.
   */
  static readonly PLAYER_ID: string = '';
  static readonly PLAYER_TYPE: string = 'surface';
  static readonly PLAYER_SURFACE_WIDTH: number = 1920;
  static readonly PLAYER_SURFACE_HEIGHT: number = 1080;
  static readonly PLAYER_STACK_WIDTH: string = '16.7%';
  static readonly PLAYER_IMAGE_WIDTH: string = '95%';
  static readonly PLAYER_FIRST: number = 0;
  static readonly PLAYER_NEXT: number = 1;
  static readonly PLAYER_DURATION: number = 0;
  /**
   * Video playback control constant.
   */
  static readonly CONTROL_ROW_WIDTH: string = '68.8%';
  static readonly CONTROL_PLAY_START: number = 1;
  static readonly CONTROL_PLAY_PAUSE: number = 2;
  static readonly CONTROL_NEXT: number = 1;
  static readonly CONTROL_FIRST: number = 0;
  /**
   * Progress bar page constant.
   */
  static readonly PROGRESS_CURRENT_TIME: string = '00:00';
  static readonly PROGRESS_TOTAL_TIME: string = '00:00';
  static readonly PROGRESS_PROGRESS_VAL: number = 0;
  static readonly PROGRESS_INTERVAL: number = -1;
  static readonly PROGRESS_STEP: number = 1;
  static readonly PROGRESS_TRACK_THICKNESS: number = 2;
  static readonly PROGRESS_SLIDER_WIDTH: string = '68.9%';
  static readonly PROGRESS_MARGIN_LEFT: string = '2.2%';
  static readonly PROGRESS_SEEK_TIME: number = 0;
  static readonly PROGRESS_ROW_WIDTH: string = '93.4%';
  /**
   * Network video playback error notification duration
   */
  static readonly PLAY_ERROR_TIME: number = 3000;
}