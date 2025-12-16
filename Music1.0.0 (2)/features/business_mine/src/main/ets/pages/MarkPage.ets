import { CommonConstants } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { MarkViewModel } from '../viewmodels/MarkVM';
import { CollectedMusic } from '../components/CollectedMusic';
import { MusicPlayController } from 'module_musicplay';

@Builder
export function MarkPageBuilder() {
  MarkPage()
}

@ComponentV2
struct MarkPage {
  @Local vm: MarkViewModel = new MarkViewModel();

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '我的喜欢',
        })
        CollectedMusic()

        MusicPlayController()
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        bottom: this.vm.windowModel.windowBottomPadding
      })
    }
    .hideTitleBar(true)
  }
}