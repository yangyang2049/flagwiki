import { window } from '@kit.ArkUI';
import { RouterUtils } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { ComponentController, IVideoData, UIVideo } from 'module_uivideo';

@Builder
export function MvPlayerPageBuilder() {
  MvPlayerPage()
}

/**
 * MV播放页
 */
@ComponentV2
struct MvPlayerPage {
  @Local componentController: ComponentController = new ComponentController();
  @Local scroller: Scroller = new Scroller;
  @Local isLandscape: boolean = false;
  @Local videoData: IVideoData[] = [
    {
      name: '',
      type: 'mp4',
      isLocal: false,
      src: 'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4'
    }
  ]
  @Local showBackBtn: boolean = true;

  onBackPress() {
    return this.componentController.onBack()
  }

  setStatusbarContentColor(color: string) {
    let windowStage: window.WindowStage = AppStorage.get('windowStage') as window.WindowStage;
    let mainWindow = windowStage.getMainWindowSync();
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: color
    };
    mainWindow.setWindowSystemBarProperties(systemBarProperties);
  }

  build() {
    NavDestination() {
      Column() {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            UIVideo({
              videoData: this.videoData,
              componentController: this.componentController,
              onChaneLandScape: (isLandscape: boolean) => {
                this.showBackBtn = !isLandscape;
                this.isLandscape = isLandscape;
              }
            })
              .width('100%')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          NavHeaderBar({
            showBackBtn: true,
            backImg: $r('app.media.ic_back_white'),
            onBack: () => {
              RouterUtils.pop()
            }
          })
            .visibility(!this.isLandscape ? Visibility.Visible : Visibility.None)
        }
        .width('100%')

      }.width('100%').height('100%')
      .backgroundColor(Color.Black)
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .onAppear(() => {
      // 设置状态栏颜色
      setTimeout(() => {
        this.setStatusbarContentColor('#FFFFFF');
      }, 500)

    })
    .onDisAppear(() => {
      // 恢复状态栏颜色
      this.setStatusbarContentColor('#000000');
    })
    .backgroundColor(Color.Pink)
  }
}
