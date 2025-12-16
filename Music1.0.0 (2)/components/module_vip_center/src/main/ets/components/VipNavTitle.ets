import { BaseTextStyleModifier } from 'module_base_apis'

@ComponentV2
export struct VipNavTitle {
  @Param title: ResourceStr = ''
  @Param routerModule: NavPathStack = new NavPathStack()
  @Param bg: ResourceStr | Color = ''

  build() {
    Row({ space: 8 }) {
      Row() {
        Image($r('app.media.left')).width(24).height(24)
      }
      .width(40)
      .justifyContent(FlexAlign.Center)
      .height(40)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius('50%')

      Text(this.title)
        .attributeModifier(new BaseTextStyleModifier(`font_primary/Title_S/Bold`))
    }
    .height(102)
    .width('100%')
    .onClick(() => {
      this.routerModule.pop()
    })
    .backgroundColor(this.bg)
    .padding({ top: Number(AppStorage.get('topRectHeight')), left: 16, right: 16 })
  }
}