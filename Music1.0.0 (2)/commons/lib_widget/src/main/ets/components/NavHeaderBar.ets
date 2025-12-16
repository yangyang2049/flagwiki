import { AppStorageV2 } from '@kit.ArkUI';
import { CommonConstants, RouterUtils, WindowModel } from 'lib_common';

/**
 * 通用页面标题栏
 */
@ComponentV2
export struct NavHeaderBar {
  @Param title: ResourceStr = '';
  @Param showBackBtn: boolean = false;
  @Param bgColor: ResourceColor = '#00000000';
  @Param fontColor: ResourceColor = $r('sys.color.font_primary');
  @Param backImg: ResourceStr = $r('app.media.ic_back');
  @Param isSubTitle: boolean = true;
  @BuilderParam rightPartBuilder: () => void;
  // 自定义返回事件
  @Event onBack: () => void = () => {
    RouterUtils.pop()
  };
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Consumer() isCommentInModalDialog: boolean = false

  build() {
    Column() {
      Row() {
        // 显示返回按钮：主动设置或者二级标题
        if (this.showBackBtn || this.isSubTitle) {
          Image(this.backImg)
            .width($r('app.float.head_icon_width'))
            .aspectRatio(1)
            .draggable(false)
            .margin({ right: CommonConstants.SPACE_S })
            .borderRadius(CommonConstants.HALF_PERCENT)
            .stateStyles({
              normal: { .backgroundColor(Color.Transparent)
              },
              pressed: { .backgroundColor($r('sys.color.interactive_pressed'))
              },
            })
            .onClick(() => {
              this.onBack();
            })
        }
        if (this.title) {
          Text(this.title)
            .fontSize(this.isSubTitle ? $r('sys.float.Title_S') : $r('sys.float.Title_M'))
            .fontColor(this.fontColor)
            .fontWeight(FontWeight.Bold)
        }
        if (this.rightPartBuilder) {
          this.rightPartBuilder()
        }
      }
      .height($r('app.float.nav_header_height'))
      .width(CommonConstants.FULL_PERCENT)
    }
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      top: this.isCommentInModalDialog ? CommonConstants.PADDING_S : this.windowModel.windowTopPadding,
    })
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor(this.bgColor)
  }
}