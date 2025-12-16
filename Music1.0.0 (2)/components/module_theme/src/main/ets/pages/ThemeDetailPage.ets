import { CommonHeader } from '../components/CommonHeader';
import { IThemeInfo } from '../types/Types';
import { ThemeController } from '../utils/ThemeController';
import { promptAction } from '@kit.ArkUI';

@ComponentV2
export struct ThemeDetailPage {
  @Local stack: NavPathStack | undefined;
  @Local theme: IThemeInfo | undefined;
  @Local curIndex: number = 0;
  @Local curIndexTheme: IThemeInfo | undefined;
  @Local isLoading: boolean = false;

  /**
   * 使用按钮文案
   * @returns
   */
  @Computed
  get changeLabel() {
    if (this.isLoading) {
      return '下载中...'
    }

    if (ThemeController.getThemeId() === this.theme?.id) {
      return '取消使用'
    }
    if (ThemeController.isDownloaded(this.theme?.id ?? 0)) {
      return '立即使用'
    }
    return '下载并使用'
  }

  /**
   * 点击使用按钮
   */
  onSignUseBtnClick() {
    // 取消
    if (ThemeController.getThemeId() === this.theme?.id) {
      promptAction.showDialog({
        title: '提示',
        message: '确定要取消使用吗？',
        buttons: [
          {
            text: '取消',
            color: '#000'
          },
          {
            text: '确定',
            color: '#000'
          }
        ]
      }).then((data) => {
        if (data.index === 1) {
          ThemeController.change(0);
          promptAction.showToast({ message: '皮肤取消成功' });
        }
      })
      return
    }
    // 立即使用
    if (ThemeController.isDownloaded(this.theme?.id ?? 0)) {
      promptAction.showToast({ message: '皮肤更换成功' });
      ThemeController.change(this.theme!.id)
    }
    this.isLoading = true;

    // 下载使用
    //模拟下载且更换皮肤
    setTimeout(() => {
      ThemeController.change(this.theme!.id)
      promptAction.showToast({ message: '皮肤更换成功' });
      this.isLoading = false;
    }, 3000)
  }

  build() {
    NavDestination() {
      Column() {
        CommonHeader({ title: this.theme?.label, stack: this.stack })
        Column() {
          Image($r(`app.media.${this.theme?.pics[1]}`))
            .borderRadius(16)
            .height('96%')
            .objectFit(ImageFit.Cover)
        }.layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

        Column({ space: 16 }) {
          Text(this.theme?.label)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_secondary'))

          Button() {
            Row({ space: 8 }) {
              LoadingProgress()
                .width(16)
                .aspectRatio(1)
                .color($r('sys.color.font_primary'))
                .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
              Text(this.changeLabel)
                .fontSize($r('sys.float.Body_L'))
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
            }
          }
          .width('calc(100% - 32vp)')
          .height(40)
          .backgroundColor('#FFFA2840')
          .enabled(!this.isLoading)
          .visibility(this.theme?.id === 0 ? Visibility.Hidden : Visibility.Visible)
          .onClick(() => {
            this.onSignUseBtnClick();
          })

          Text(this.theme?.isVip ? 'VIP会员可下载使用' : '皮肤限时免费：1.3M')
            .fontSize(12)
            .fontColor($r('sys.color.font_tertiary'))
        }
        .width('100%')
        .height('20%')
        .backgroundColor(Color.White)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor('#F1F3F5')
    .onReady(res => {
      this.stack = res.pathStack;
      const id = (this.stack.getParamByName('ThemeDetail') as number[]).pop()!;
      this.theme = ThemeController.getThemeById(id);
    })
  }
}

@Builder
export function themeDetailPageBuilder() {
  ThemeDetailPage()
}