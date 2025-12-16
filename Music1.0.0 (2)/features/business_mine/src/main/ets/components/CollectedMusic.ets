/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CollectedSongItem } from './CollectedSongItem';
import { MarkViewModel } from '../viewmodels/MarkVM';
import { promptAction } from '@kit.ArkUI';
import { EventBus, SongItem } from 'lib_common';
import { MediaService } from 'module_musicplay';

@ComponentV2
export struct CollectedMusic {
  @Local vm: MarkViewModel = new MarkViewModel();

  build() {
    Column() {
      Row({ space: 8 }) {
        SymbolGlyph($r('sys.symbol.play_round_triangle_fill'))
          .fontSize(32)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
          .fontColor([$r('app.color.app_theme')])
        Text($r('app.string.play_all', this.vm.num))
          .fontWeight(700)
          .fontSize(18)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .height(48)
      .alignSelf(ItemAlign.Start)
      .padding({
        left: 16,
        right: 16
      })
      .onClick(() => {
        MediaService.getInstance().playAllSongs(this.vm.sondDataSource.originDataArray, true);
      })

      List() {
        LazyForEach(this.vm.sondDataSource, (item: SongItem, index: number) => {
          ListItem() {
            CollectedSongItem({
              item: item,
              index: index,
              sources: 'mark',
              onOperationCallback: (value: SongItem) => {
                item.isCollected = false;
                promptAction.showToast({ message: '取消我喜欢' });
                EventBus.send('updateCollect', { 'songId': item.id, 'state': item.isCollected ? '1' : '0' })
              }
            })
          }
        }, (item: SongItem) => JSON.stringify(item))
      }
      .width('100%')
      .cachedCount(3)
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: '#E8E8E8',
        startMargin: 16,
        endMargin: 16
      })
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .layoutWeight(1)
  }
}