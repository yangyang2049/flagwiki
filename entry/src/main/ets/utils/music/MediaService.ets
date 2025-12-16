import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { SongItem } from './SongItem';
import { AudioPlayerState, MusicPlayMode } from './MusicData';
import { getMusicModel, MusicModel } from './MusicModel';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG = 'MediaService';

/**
 * 简化的媒体服务 - 用于播放国歌
 */
export class MediaService {
  private static instance: MediaService;
  private context: common.UIAbilityContext = AppStorage.get('context') as common.UIAbilityContext;
  public avPlayer?: media.AVPlayer;
  private session?: avSession.AVSession;
  private state: AudioPlayerState = AudioPlayerState.IDLE;
  private isFirstLoadAsset: boolean = true;
  private isPrepared: boolean = false;
  private musicIndex: number = 0;
  private changedData: MusicModel = getMusicModel();

  private avPlayerErrorCall = (error: BusinessError) => {
    hilog.error(DOMAIN, TAG, `avPlayerErrorCall error, code is ${error.code}, message is ${error.message}`);
    this.reset();
  };

  private avPlayerTimeUpdateCall = (updateTime: number) => {
    hilog.debug(DOMAIN, TAG, `avPlayerTimeUpdateCall updateTime is ${updateTime}`);
    this.changedData.progress = updateTime;
    this.changedData.currentTime = this.msToCountdownTime(updateTime);
  };

  private avPlayerStateChangeCall = async (state: string) => {
    switch (state) {
      case 'idle':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state idle called.');
        // 首次播放，设置源并准备
        this.state = AudioPlayerState.IDLE;
        this.isPrepared = false;
        this.loadAsset();
        break;
      case 'initialized':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state initialized called.');
        this.state = AudioPlayerState.INITIALIZED;
        this.prepare();
        break;
      case 'prepared':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state prepared called.');
        this.state = AudioPlayerState.PREPARED;
        this.isPrepared = true;
        if (!this.isFirstLoadAsset) {
          this.play();
        }
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer prepared succeeded.');
        break;
      case 'playing':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state playing called.');
        if (this.isFirstLoadAsset) {
          this.isFirstLoadAsset = false;
        }
        this.state = AudioPlayerState.PLAY;
        this.setCallBackData(true);
        break;
      case 'paused':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state paused called.');
        this.state = AudioPlayerState.PAUSE;
        this.setCallBackData(false);
        break;
      case 'completed':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state completed called.');
        this.state = AudioPlayerState.COMPLETED;
        this.playCompleteAuto();
        break;
      case 'stopped':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state stopped called.');
        this.state = AudioPlayerState.STOP;
        this.reset();
        break;
      case 'error':
        hilog.info(DOMAIN, TAG, 'avPlayerStateChangeCall AVPlayer state error called.');
        this.state = AudioPlayerState.ERROR;
        break;
    }
  };

  public static getInstance(): MediaService {
    if (!MediaService.instance) {
      MediaService.instance = new MediaService();
    }
    return MediaService.instance;
  }

  public initAudioPlayer(songList: Array<SongItem>, currentSong: SongItem): void {
    hilog.info(DOMAIN, TAG, 'initAudioPlayer');
    this.changedData.songList = songList;
    
    // 设置为 false，确保准备好后自动播放
    this.isFirstLoadAsset = false;
    
    // 如果已有播放器，先释放再重新创建
    if (this.avPlayer) {
      this.releasePlayer().then(() => {
        this.createAndInitPlayer(currentSong);
      });
    } else {
      this.createAndInitPlayer(currentSong);
    }
  }
  
  private async releasePlayer(): Promise<void> {
    if (this.avPlayer) {
      try {
        await this.avPlayer.release();
        hilog.info(DOMAIN, TAG, 'AVPlayer released successfully');
      } catch (error) {
        const err = error as BusinessError;
        hilog.error(DOMAIN, TAG, `AVPlayer release failed: ${err.code}, ${err.message}`);
      }
      this.avPlayer = undefined;
    }
    if (this.session) {
      try {
        await this.session.destroy();
        hilog.info(DOMAIN, TAG, 'Session destroyed successfully');
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Session destroy failed: ${JSON.stringify(error)}`);
      }
      this.session = undefined;
    }
    this.isPrepared = false;
    this.state = AudioPlayerState.IDLE;
  }
  
  private createAndInitPlayer(currentSong: SongItem): void {
    media.createAVPlayer().then(async avPlayer => {
      if (avPlayer) {
        this.avPlayer = avPlayer;
        this.setAVPlayerCallback();
        this.loadAsset(currentSong);
        this.createSession();

        hilog.info(DOMAIN, TAG, 'initAudioPlayer success');
      }
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, TAG, `initAudioPlayer error, code is ${error.code}, message is ${error.message}`);
    });
  }

  private setAVPlayerCallback(): void {
    if (this.avPlayer) {
      this.avPlayer.on('seekDone', () => {});
      this.avPlayer.on('error', this.avPlayerErrorCall);
      this.avPlayer.on('timeUpdate', this.avPlayerTimeUpdateCall);
      this.avPlayer.on('stateChange', this.avPlayerStateChangeCall);
    }
  }

  private async createSession(): Promise<void> {
    try {
      this.session = await avSession.createAVSession(this.context, 'SESSION_NAME', 'audio');
      this.session.activate();
      hilog.info(DOMAIN, TAG, `session create done : sessionId : ${this.session.sessionId}`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `createSession error: ${JSON.stringify(error)}`);
    }
  }

  private loadAsset(currentSong?: SongItem): void {
    if (currentSong) {
      const index = Number.parseInt(currentSong.id) - 1;
      if (index >= 0 && index < this.changedData.songList.length) {
        this.musicIndex = index;
      }
      hilog.info(DOMAIN, TAG, `loadAsset musicIndex: ${this.musicIndex}`);
    }

    const song = this.changedData.songList[this.musicIndex];
    if (!song) {
      return;
    }

    // 更新当前歌曲
    this.changedData.setCurrentSong(song);
    this.changedData.selectIndex = this.musicIndex;

    // 使用rawfile路径
    this.context.resourceManager.getRawFd(song.src).then((rawfileFd) => {
      if (rawfileFd && this.avPlayer) {
        const avFileDescriptor: media.AVFileDescriptor = {
          fd: rawfileFd.fd,
          offset: rawfileFd.offset,
          length: rawfileFd.length
        };
        this.avPlayer.fdSrc = avFileDescriptor;
        hilog.info(DOMAIN, TAG, `loadAsset avPlayer fdSrc set successfully`);
      } else {
        hilog.error(DOMAIN, TAG, `loadAsset failed: rawfileFd=${rawfileFd}, avPlayer=${this.avPlayer}`);
      }
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, TAG, `loadAsset error: ${error.code}, ${error.message}`);
    });
  }

  private setCallBackData(isPlay: boolean): void {
    this.changedData.currentSong = this.changedData.songList[this.musicIndex];
    this.changedData.isPlay = isPlay;
    this.changedData.selectIndex = this.musicIndex;
    this.changedData.totalTime = this.msToCountdownTime(this.getDuration());
    this.changedData.progressMax = this.getDuration();
  }

  public play(): void {
    if (!this.isPrepared) {
      this.prepare();
    } else {
      this.avPlayer?.play().then(() => {
        hilog.info(DOMAIN, TAG, 'AVPlayer play successfully');
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, `AVPlayer play failed, code is ${error.code}, message is ${error.message}`);
      });
    }
  }

  public pause(): void {
    if (this.isPrepared && this.state === AudioPlayerState.PLAY && this.avPlayer) {
      this.avPlayer.pause().then(() => {
        hilog.info(DOMAIN, TAG, 'AVPlayer pause successfully');
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, `AVPlayer pause failed, code is ${error.code}, message is ${error.message}`);
      });
    }
  }

  public playAndPause(): void {
    if (this.changedData.isPlay) {
      this.pause();
    } else {
      this.isFirstLoadAsset = false;
      this.play();
    }
  }

  public seek(ms: number): void {
    if (this.isPrepared && this.state !== AudioPlayerState.ERROR && this.avPlayer) {
      const seekMode = this.getCurrentTime() < ms ? 0 : 1;
      const realTime = (ms <= 0 ? 0 : (ms >= this.getDuration() ? this.getDuration() : ms));
      this.avPlayer.seek(realTime, seekMode);
    }
  }

  public playNext(): void {
    this.isFirstLoadAsset = false;
    hilog.info(DOMAIN, TAG, `playNext Index: ${this.musicIndex}, songList length: ${this.changedData.songList.length}`);
    if (this.musicIndex === this.changedData.songList.length - 1) {
      this.playByIndex(0);
    } else {
      this.playByIndex(this.musicIndex + 1);
    }
  }

  public playPrevious(): void {
    this.isFirstLoadAsset = false;
    hilog.info(DOMAIN, TAG, `playPrevious Index: ${this.musicIndex}, songList length: ${this.changedData.songList.length}`);
    if (this.musicIndex === 0) {
      this.playByIndex(this.changedData.songList.length - 1);
    } else {
      this.playByIndex(this.musicIndex - 1);
    }
  }

  public async playByIndex(musicIndex: number): Promise<void> {
    if (musicIndex >= this.changedData.songList.length) {
      hilog.error(DOMAIN, TAG, `playByIndex error, index is ${musicIndex} out of songList length ${this.changedData.songList.length}`);
      return;
    }
    this.updateMusicIndex(musicIndex);
    await this.stop();
  }

  private async stop(): Promise<void> {
    if (this.isPrepared && this.avPlayer) {
      this.state = AudioPlayerState.PAUSE;
      this.avPlayer.stop().then(() => {
        hilog.info(DOMAIN, TAG, 'AVPlayer stop succeeded.');
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, `AVPlayer stop failed, code is ${error.code}, message is ${error.message}`);
      });
    }
  }

  private prepare(): void {
    this.avPlayer?.prepare().then(() => {
      hilog.info(DOMAIN, TAG, 'AVPlayer prepare successfully');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, TAG, `AVPlayer prepare failed, code is ${error.code}, message is ${error.message}`);
    });
  }

  private playCompleteAuto(): void {
    if (this.changedData.songList.length === 0) {
      return;
    }
    // 检查循环播放设置（从 AppStorage 读取，默认启用）
    const loopPlaybackEnabled = AppStorage.get('loopPlaybackEnabled') as boolean ?? true;
    
    if (loopPlaybackEnabled) {
      // 循环播放启用时，自动播放下一首
      this.playNext();
    } else {
      // 循环播放禁用时，停止播放，不自动播放下一首
      this.pause();
      this.setCallBackData(false);
    }
  }

  private reset(): void {
    this.avPlayer?.reset().then(() => {
      hilog.info(DOMAIN, TAG, 'AVPlayer reset successfully');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, TAG, `AVPlayer reset failed, code is ${error.code}, message is ${error.message}`);
    });
  }

  private updateMusicIndex(musicIndex: number): void {
    hilog.info(DOMAIN, TAG, `updateMusicIndex: ${musicIndex}`);
    this.musicIndex = musicIndex;
  }

  private getCurrentTime(): number {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.currentTime;
    }
    return 0;
  }

  private getDuration(): number {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.duration;
    }
    return 0;
  }

  private msToCountdownTime(ms: number): string {
    const minutes = Math.floor(ms / 60000);
    const seconds = Math.floor((ms % 60000) / 1000);
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }
}
