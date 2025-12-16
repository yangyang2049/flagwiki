import { CommonConstants } from '../constants/CommonConstants';
import { GridRowColSetting } from '../constants/GridRowColSetting';
import { MyPlayListModel } from '../models/MyPlayListModel';
import { PopViewUtils } from '../utils/PopViewUtils';
import { AppStorageV2 } from '@kit.ArkUI';
import { CommonEnters } from './CommonEnters';

export interface IPlayListDialogParams {
  confirm?: () => void;
  cancel?: () => void;
  songId?: string;
}

export class PlayListDialogParams implements IPlayListDialogParams {
  vm: MyPlayListModel = AppStorageV2.connect(MyPlayListModel, () => new MyPlayListModel())!;
  songId: string = '';
  confirm: () => void = () => {
  };
  cancel: () => void = () => {
  };

  constructor(item: IPlayListDialogParams) {
    if (item.confirm) {
      this.confirm = item.confirm;
    }
    if (item.cancel) {
      this.cancel = item.cancel;
    }
    if (item.songId) {
      this.songId = item.songId;
    }
  }
}

@Builder
function playListDialogView(params: PlayListDialogParams) {
  Column() {
    Column() {
      Row() {
        Text('添加到歌单')
          .fontSize($r('sys.float.Title_S'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        // 关闭按钮
        Button() {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize(20)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
            .fontColor([Color.Black])
            .onClick(() => {
              // 执行关闭窗口
              PopViewUtils.closePopView()
              params.cancel()
            })
        }
        .width(40)
        .backgroundColor($r('sys.color.background_secondary'))
        .aspectRatio(1)
        .draggable(false)
        .margin({ right: CommonConstants.SPACE_S })
        .borderRadius(CommonConstants.HALF_PERCENT)
      }
      .height(56)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: 18,
        right: 18,
        top: 16,
        bottom: 16
      })

      CommonEnters({ songId: params.songId, callback: params.confirm })
    }
    .width(CommonConstants.FULL_PERCENT)
    .borderRadius({ topLeft: $r('app.float.xxl_radius'), topRight: $r('app.float.xxl_radius') })
    .backgroundColor($r('sys.color.comp_background_primary'))
    .margin({
      top: CommonConstants.SPACE_M,
      left: CommonConstants.SPACE_M,
      right: CommonConstants.SPACE_M
    })
    .constraintSize({ maxWidth: GridRowColSetting.DIALOG_MAX_WIDTH })
  }
  .width(CommonConstants.FULL_PERCENT)
}

/**
 * 弹框加入歌单
 */
export class CommonMyPlayDialog {
  /**
   * 打开弹窗
   * @param param
   */
  public static show(param: IPlayListDialogParams) {
    // 从底部弹窗
    PopViewUtils.showPopView<PlayListDialogParams>(wrapBuilder(playListDialogView),
      { alignment: DialogAlignment.Bottom, showInSubWindow: true }, new PlayListDialogParams(param));
  }
}