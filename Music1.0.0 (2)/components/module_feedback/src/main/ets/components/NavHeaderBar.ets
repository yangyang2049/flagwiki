import { AppStorageV2 } from '@kit.ArkUI';
import { Constants } from '../common/Constants';
import { FeedbackModel } from '../common/FeedbackModel';

@ComponentV2
export struct NavHeaderBar {
  @Param title: ResourceStr = '';
  @Param showBackBtn: boolean = true;
  @Param hasBgColor: boolean = false;
  @Param isSubTitle: boolean = true;
  @Local feedbackModel: FeedbackModel = AppStorageV2.connect(FeedbackModel, () => new FeedbackModel())!;
  @Consumer() stack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .aspectRatio(1)
          .draggable(false)
          .borderRadius(Constants.HALF_PERCENT)
          .stateStyles({
            normal: { .backgroundColor(Color.Transparent)
            },
            pressed: { .backgroundColor($r('sys.color.interactive_pressed'))
            },
          })
          .margin({ right: Constants.SPACE_8 })
          .onClick(() => {
            this.stack.pop();
          })
        if (this.title) {
          Text(this.title)
            .fontSize(this.isSubTitle ? $r('sys.float.Title_S') : $r('sys.float.Title_M'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Bold)
        }
      }
      .height(56)
      .width(Constants.FULL_PERCENT)
    }
    .padding({
      left: Constants.PADDING_PAGE,
      right: Constants.PADDING_PAGE,
      top: this.feedbackModel.windowTopPadding,
    })
    .width(Constants.FULL_PERCENT)
    .backgroundColor(this.hasBgColor ? $r('sys.color.background_primary') : '#00000000')
  }
}