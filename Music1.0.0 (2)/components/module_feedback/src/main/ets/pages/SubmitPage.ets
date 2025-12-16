import { ImagePreview, PreviewVerticalAlign } from 'module_imagepreview';
import { NavHeaderBar } from '../components/NavHeaderBar';
import { Constants } from '../common/Constants';
import { SubmitVM } from '../viewmodels/SubmitVM';

@Builder
export function SubmitPageBuilder() {
  SubmitPage()
}

@ComponentV2
export struct SubmitPage {
  @Provider() stack: NavPathStack = new NavPathStack();
  @Local vm: SubmitVM = new SubmitVM();

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({ title: '反馈问题' })
        this.customDivider()
        Scroll() {
          Column() {
            this.textInfo()
            this.imageInfo()
            this.customDivider()
            this.contactInfo()
          }
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)
        }
        .width(Constants.FULL_PERCENT)
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)

        this.btnInfo()
      }
    }
    .hideTitleBar(true)
    .padding({
      bottom: this.vm.feedbackModel.windowBottomPadding,
    })
    .onReady((context) => {
      this.stack = context.pathStack;
      this.vm.stack = this.stack;
    })
  }

  @Builder
  textInfo() {
    Column() {
      TextArea({
        placeholder: '请详细描述您的问题（必填）',
        text: $$this.vm.body,
      })
        .fontSize(16 * this.vm.feedbackModel.fontSizeRatio)
        .placeholderColor($r('sys.color.font_tertiary'))
        .placeholderFont({ size: 16 * this.vm.feedbackModel.fontSizeRatio })
        .backgroundColor(Color.Transparent)
        .maxLength(100)
        .showCounter(true)
        .height(140)
        .borderRadius(0)
        .padding({
          left: 0,
          right: 0,
          top: Constants.PADDING_S,
          bottom: Constants.PADDING_S,
        })
    }
    .padding({
      left: Constants.PADDING_PAGE,
      right: Constants.PADDING_PAGE,
      top: Constants.PADDING_L,
    })
  }

  @Builder
  imageInfo() {
    Column() {
      Grid() {
        if (this.vm.imgArr.length < Constants.MAX_IMG_COUNT) {
          GridItem() {
            this.uploadBox()
          }
        }

        ForEach(this.vm.imgArr, (v: string, index: number) => {
          GridItem() {
            this.imageBox(v, index)
          }
        }, (v: string) => v)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(12)
      .rowsGap(8)
      .maxCount(Constants.MAX_IMG_COUNT)
      .constraintSize({ maxHeight: '50%' })
      .scrollBar(BarState.Off)

      Text(`${this.vm.imgArr.length}/${Constants.MAX_IMG_COUNT}`)
        .fontSize($r('sys.float.Caption_M'))
        .fontColor($r('sys.color.font_tertiary'))
        .width(Constants.FULL_PERCENT)
        .textAlign(TextAlign.End)
        .margin({ top: Constants.PADDING_M })
    }
    .padding({
      left: Constants.PADDING_PAGE,
      right: Constants.PADDING_PAGE,
      bottom: Constants.PADDING_L,
    })
    .margin({
      top: Constants.PADDING_M,
    })
  }

  @Builder
  contactInfo() {
    Column() {
      Text('联系方式（选填）')
        .fontSize(14 * this.vm.feedbackModel.fontSizeRatio)
        .fontColor($r('sys.color.font_primary'))
      Stack() {
        TextInput({
          text: $$this.vm.contactPhone,
          placeholder: '请填写联系手机',
        })
          .type(InputType.PhoneNumber)
          .width(Constants.FULL_PERCENT)
          .height(Constants.TEXT_INPUT_HEIGHT)
          .padding(0)
          .fontSize(16 * this.vm.feedbackModel.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .placeholderColor($r('sys.color.font_tertiary'))
          .placeholderFont({ size: 12 * this.vm.feedbackModel.fontSizeRatio })
          .backgroundColor(Color.Transparent)
          .borderRadius(0)
          .borderWidth({ bottom: 0.5 })
          .borderColor($r('sys.color.comp_divider'))
        Image($r('app.media.ic_public_close_circle'))
          .width(Constants.ICON_WIDTH)
          .draggable(false)
          .visibility(this.vm.contactPhone ? Visibility.Visible : Visibility.Hidden)
          .onClick(() => {
            this.vm.contactPhone = '';
          })
      }
      .alignContent(Alignment.End)

    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: Constants.PADDING_PAGE,
      right: Constants.PADDING_PAGE,
      top: Constants.PADDING_L,
    })
  }

  @Builder
  btnInfo() {
    Column() {
      Button() {
        Row({ space: 4 }) {
          LoadingProgress()
            .width(16)
            .aspectRatio(1)
            .color($r('sys.color.font_on_primary'))
            .visibility(this.vm.loading ? Visibility.Visible : Visibility.None)
          Text(this.vm.loading ? '正在提交反馈...' : '提交反馈')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
        }
      }
      .width(Constants.FULL_PERCENT)
      .height(Constants.BTN_HEIGHT)
      .enabled(!this.vm.loading)
      .onClick(() => {
        this.vm.submit();
      })
    }
    .padding({
      top: Constants.PADDING_S,
      bottom: Constants.PADDING_S,
      left: Constants.PADDING_PAGE,
      right: Constants.PADDING_PAGE,
    })
  }

  @Builder
  uploadBox() {
    Column({ space: 4 }) {
      Image($r('app.media.ic_plus2'))
        .width(Constants.ICON_WIDTH)
        .aspectRatio(1)
        .draggable(false)
        .fillColor($r('sys.color.icon_secondary'))
    }
    .width(Constants.FULL_PERCENT)
    .aspectRatio(1)
    .justifyContent(FlexAlign.Center)
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .onClick(async () => {
      this.vm.selectPhoto();
    })
  }

  @Builder
  imageBox(v: string, index: number) {
    Stack() {
      Image(v)
        .width(Constants.FULL_PERCENT)
        .aspectRatio(1)
      Image($r('app.media.ic_public_close_circle'))
        .width(Constants.ICON_WIDTH)
        .aspectRatio(1)
        .draggable(false)
        .borderRadius(16)
        .margin({
          top: Constants.SPACE_8,
          right: Constants.SPACE_8,
        })
        .onClick(() => {
          this.vm.imgArr.splice(index, 1);
        })
    }
    .borderRadius(16)
    .alignContent(Alignment.TopEnd)
    .clip(true)
    .onClick(() => {
      ImagePreview.show(this.vm.imgArr, {
        startIndex: index,
        showIndex: true,
        loop: false,
        isBasicMode: true,
        indexPosition: PreviewVerticalAlign.Top,
      })
    })
  }

  @Builder
  customDivider() {
    Row().width(Constants.FULL_PERCENT).height(8).backgroundColor($r('sys.color.background_secondary'))
  }
}