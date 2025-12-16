import { CommonConstants } from '../constants/CommonConstants';
import { GridRowColSetting } from '../constants/GridRowColSetting';
import { PopViewUtils } from '../utils/PopViewUtils';

export interface IEnterDialogParams {
  primaryTitle?: ResourceStr;
  secondaryTitle?: ResourceStr;
  content: ResourceStr;
  priBtnV?: ResourceStr;
  secBtnV?: ResourceStr;
  priBtnFg?: ResourceColor;
  secBtnFg?: ResourceColor;
  confirm?: (value: string) => void;
  cancel?: () => void;
}

class EnterDialogParams implements IEnterDialogParams {
  primaryTitle: ResourceStr = '';
  secondaryTitle: ResourceStr = '';
  content: ResourceStr = '';
  priBtnV: ResourceStr = '取消';
  secBtnV: ResourceStr = '确定';
  priBtnFg: ResourceColor = $r('app.color.app_theme');
  secBtnFg: ResourceColor = $r('app.color.app_theme');
  confirm: (value: string) => void = (value: string) => {
  };
  cancel: () => void = () => {
  };

  constructor(item: IEnterDialogParams) {
    this.content = item.content;
    if (item.primaryTitle) {
      this.primaryTitle = item.primaryTitle;
    }
    if (item.secondaryTitle) {
      this.secondaryTitle = item.secondaryTitle;
    }
    if (item.priBtnV) {
      this.priBtnV = item.priBtnV;
    }
    if (item.secBtnV) {
      this.secBtnV = item.secBtnV;
    }
    if (item.priBtnFg) {
      this.priBtnFg = item.priBtnFg;
    }
    if (item.secBtnFg) {
      this.secBtnFg = item.secBtnFg;
    }
    if (item.confirm) {
      this.confirm = item.confirm;
    }
    if (item.cancel) {
      this.cancel = item.cancel;
    }
  }
}

@Builder
function enterDialogView(params: IEnterDialogParams) {
  Column() {
    Column() {

      //标题头
      Text(params.primaryTitle)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)


      // 输入框
      TextInput({ text: params.content })
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .cancelButton({ style: CancelButtonStyle.INPUT, icon: { size: 16 } })
        .maxLength(20)
        .showCounter(true)
        .height(40)
        .margin({ top: 12 })
        .onChange((value: string) => {
          params.content = value;
        })

      Row() {
        Button('取消')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.app_theme'))
          .backgroundColor(Color.Transparent)
          .width(100)
          .onClick(() => {
            PopViewUtils.closePopView();
          })

        Button('确定')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.app_theme'))
          .backgroundColor(Color.Transparent)
          .width(100)
          .onClick(() => {
            if (params.confirm) {
              // 获取输入框内容
              const value: string = params.content as string;
              params.confirm(value);
            }
            PopViewUtils.closePopView();
          })
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width(CommonConstants.FULL_PERCENT)
    .borderRadius($r('app.float.xxl_radius'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .constraintSize({ maxWidth: GridRowColSetting.DIALOG_MAX_WIDTH })
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      top: CommonConstants.PADDING_PAGE,
      bottom: CommonConstants.PADDING_PAGE
    })
  }
  .width(CommonConstants.FULL_PERCENT)
  .padding({
    left: CommonConstants.PADDING_PAGE,
    right: CommonConstants.PADDING_PAGE,
  })
}

/**
 * 通用确认弹窗
 */
export class CommonEnterDialog {
  /**
   * 打开弹窗
   * @param param
   */
  public static show(param: IEnterDialogParams) {
    PopViewUtils.showPopView<EnterDialogParams>(wrapBuilder(enterDialogView), {}, new EnterDialogParams(param));
  }
}