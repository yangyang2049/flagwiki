import { AppStorageV2 } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { CommonConstants, WindowModel } from 'lib_common';

@Builder
export function ProtocolWebViewBuilder() {
  ProtocolWebView()
}

@ComponentV2
struct ProtocolWebView {
  @Local content: string = '';
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  webViewController: webview.WebviewController = new webview.WebviewController();
  mode: WebDarkMode = WebDarkMode.Auto;
  stack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(40)
            .draggable(false)
            .borderRadius(CommonConstants.HALF_PERCENT)
            .stateStyles({
              normal: { .backgroundColor(Color.Transparent)
              },
              pressed: { .backgroundColor($r('sys.color.interactive_pressed'))
              },
            })
            .onClick(() => {
              this.stack.pop(true);
            })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(56)
        .margin({
          top: this.windowModel.windowTopPadding,
          left: CommonConstants.PADDING_PAGE
        })

        Web({
          src: 'www.example.com',
          controller: this.webViewController,
        })
          .fileAccess(false)
          .geolocationAccess(false)
          .darkMode(this.mode)
          .forceDarkAccess(true)
          .verticalScrollBarAccess(false)
          .backgroundColor($r('sys.color.background_secondary'))
          .layoutWeight(1)
          .onControllerAttached(() => {
            setTimeout(() => {
              this.webViewController.loadData(
                this.content,
                'text/html',
                'UTF-8',
                '',
                '',
              );
            }, 100)
          })
      }
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        bottom: this.windowModel.windowBottomPadding,
      })
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.stack = context.pathStack;
      this.content = context.pathInfo.param as string ?? '';
    })
  }
}
