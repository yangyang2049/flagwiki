import { SongItem } from 'lib_music_api';

@ObservedV2
export class LocalSongsModel {
  @Trace localSongs: Array<SongItem> = [];
}