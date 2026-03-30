import { common } from '@kit.AbilityKit';

export interface AnthemSongItem {
  id: string;
  title: string;
  singer: string;
  src: string;
  isLocal: boolean;
  label: string | Resource;
  isCollected: boolean;
  isVip: boolean;
  collectedCount: number;
  playlistCount: number;
  downloadCount: number;
  shareCount: number;
}

export interface AnthemMusicModel {
  isPlay: boolean;
  songList: AnthemSongItem[];
  currentSong: AnthemSongItem | undefined;
  totalTime: string;
  progressMax: number;
  progress: number;
  selectIndex: number;
  currentTime: string;
  playMode: number;
  isShowPlay: boolean;
  themeColor: string;
}

export interface AnthemMediaService {
  initAudioPlayer(songList: AnthemSongItem[], currentSong: AnthemSongItem): void;
  playPrevious(): void;
  playAndPause(): void;
  playNext(): void;
  seek(ms: number): void;
}

export interface AnthemMediaServiceClass {
  getInstance(): AnthemMediaService;
}

export interface AnthemFeatureModule {
  initAnthemCache(context: common.UIAbilityContext): Promise<void>;
  hasAnthemFile(countryCode: string): boolean;
  getAnthemFilePath(countryCode: string): string;
  getAnthemNameEN(countryCode: string): string;
  getAnthemNameCN(countryCode: string): string;
  hasAnthemName(countryCode: string): boolean;
  getMusicModel(): AnthemMusicModel;
  MediaService: AnthemMediaServiceClass;
}

let anthemFeatureModuleCache: AnthemFeatureModule | null = null;
let anthemFeatureModulePromise: Promise<AnthemFeatureModule> | null = null;

export async function loadAnthemFeatureModule(): Promise<AnthemFeatureModule> {
  if (anthemFeatureModuleCache) {
    return anthemFeatureModuleCache;
  }
  if (!anthemFeatureModulePromise) {
    anthemFeatureModulePromise = import('anthem').then((module: Object) => {
      anthemFeatureModuleCache = module as AnthemFeatureModule;
      return anthemFeatureModuleCache;
    }).catch((error: Object) => {
      anthemFeatureModulePromise = null;
      throw (error instanceof Error ? error : new Error(String(error)));
    });
  }
  return anthemFeatureModulePromise;
}

export function getLoadedAnthemFeatureModule(): AnthemFeatureModule | null {
  return anthemFeatureModuleCache;
}

export function createAnthemSongItem(): AnthemSongItem {
  return {
    id: '',
    title: '',
    singer: '',
    src: '',
    isLocal: false,
    label: $r('app.media.icon_tab_home'),
    isCollected: false,
    isVip: false,
    collectedCount: 0,
    playlistCount: 0,
    downloadCount: 0,
    shareCount: 0
  };
}
