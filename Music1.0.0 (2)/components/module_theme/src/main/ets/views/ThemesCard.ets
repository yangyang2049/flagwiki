import { ThemePage, THEME_LIST } from '../constants/Constants';
import { IThemeInfo } from '../types/Types';

@ComponentV2
export struct ThemesCard {
  @Require @Param stack: NavPathStack;
  @Param bgColor: ResourceColor = $r('sys.color.comp_background_primary');
  @Param radius: Length = 16;
  @Param pad: Padding | Length = {
    left: 12,
    right: 12,
    top: 24,
    bottom: 16,
  };
  @Local themes: IThemeInfo[] = THEME_LIST;

  build() {
    Column({ space: 24 }) {
      Row() {
        Text('个性主题')
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('sys.float.Subtitle_L'))
        Row({ space: 8 }) {
          Text('查看更多')
            .fontColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Body_M'))
          Image($r('app.media.arrow')).width(7).fillColor($r('sys.color.icon_secondary'))
        }
        .onClick(() => {
          this.stack.pushPathByName(ThemePage.THEME_LIST, null);
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      List({ space: 16 }) {
        ForEach(this.themes, (theme: IThemeInfo) => {
          ListItem() {
            Column({ space: 8 }) {
              Image($r(`app.media.${theme.pics[0]}`))
                .width(56)
                .aspectRatio(1)
                .objectFit(ImageFit.Cover)
                .borderRadius('50%')
                .clip(true)
              Text(theme.label)
                .fontColor($r('sys.color.font_primary'))
                .fontSize($r('sys.float.Body_S'))
            }
          }
          .onClick(() => {
            this.stack.pushPathByName(ThemePage.THEME_DETAIL, theme.id);
          })
        }, (theme: IThemeInfo, index) => JSON.stringify(theme) + '_' + index)
      }
      .width('100%')
      .height(80)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .lanes(1)
    }
    .width('100%')
    .backgroundColor(this.bgColor)
    .borderRadius(this.radius)
    .padding(this.pad)
  }
}