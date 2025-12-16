/**
 * 音乐播放模式
 */
export enum MusicPlayMode {
  SINGLE_CYCLE = 0, // 单曲循环
  ORDER = 1, // 顺序播放
  RANDOM = 2 // 随机播放
}

/**
 * 音频播放器状态
 */
export enum AudioPlayerState {
  IDLE,
  INITIALIZED,
  LOAD,
  PREPARED,
  PLAY,
  PAUSE,
  STOP,
  ERROR,
  COMPLETED,
  RELEASED,
  UNKNOWN
}

