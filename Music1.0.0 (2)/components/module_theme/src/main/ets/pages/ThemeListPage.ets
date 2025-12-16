import { CommonHeader } from '../components/CommonHeader';
import { THEME_LIST } from '../constants/Constants';
import { IThemeInfo } from '../types/Types';
import { ThemeController, ThemeModel } from '../utils/ThemeController';
import { WindowUtil } from '../utils/WindowUtil';
import { PersistenceV2 } from '@kit.ArkUI';

@ComponentV2
export struct ThemeListPage {
  @Local stack: NavPathStack | undefined;
  @Local theme: ThemeModel = PersistenceV2.connect(ThemeModel, 'theme', () => new ThemeModel())!;

  aboutToAppear(): void {
    //判断是否默认皮肤
    if (ThemeController.theme.isDefaultTheme) {
      ThemeController.change(0);
    }
  }

  build() {
    NavDestination() {
      CommonHeader({ title: '个性主题', stack: this.stack })

      Scroll() {
        Column() {
          Grid() {
            ForEach(THEME_LIST, (theme: IThemeInfo) => {
              GridItem() {
                Column({ space: 8 }) {
                  Image($r(`app.media.${theme.pics[1]}`))
                    .width('100%')
                    .height(280)
                    .borderRadius(16)
                    .onClick(() => {
                      this.stack?.pushPathByName('ThemeDetail', theme.id);
                    })

                  Row() {
                    Text(theme.label)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_secondary'))
                      .fontSize($r('sys.float.Body_S'))
                    Image($r('app.media.ic_vip'))
                      .width(25)
                      .height(16)
                      .fillColor('#DAAC58')
                      .visibility(theme.isVip ? Visibility.Visible : Visibility.Hidden)

                    Text(ThemeController.getThemeId() === theme.id ? '使用中' : '下载并使用')
                      .fontWeight(FontWeight.Medium)
                      .fontColor(Color.White)
                      .fontSize($r('sys.float.Body_S'))
                      .width(75)
                      .height(28)
                      .borderRadius('50%')
                      .textAlign(TextAlign.Center)
                      .backgroundColor('#FFFA2840')
                      .visibility(ThemeController.getThemeId() === theme.id ? Visibility.Visible : Visibility.Hidden)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                }
              }
            }, (theme: IThemeInfo, index) => JSON.stringify(theme) + '_' + index)
          }
          .columnsTemplate(this.theme.breakpoint !== 'md' ? '1fr 1fr' : '1fr 1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .scrollBar(BarState.Off)
          .padding({ top: 24, bottom: WindowUtil.getAvoidArea().bottom })

          Blank().layoutWeight(1)
        }
      }
      .layoutWeight(1)
      .padding({ left: 16, right: 16, bottom: 68 })
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .margin({ bottom: WindowUtil.getAvoidArea().bottom })
    .onReady(res => {
      this.stack = res.pathStack;
      const breakpoint = (this.stack.getParamByName('ThemeList') as string[]).pop()!;
      this.theme.breakpoint = breakpoint;
    })
  }
}


@Builder
export function themeListPageBuilder() {
  ThemeListPage()
}