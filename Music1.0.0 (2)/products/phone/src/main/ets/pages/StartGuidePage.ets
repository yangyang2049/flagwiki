import { CommonConstants, PreferenceUtils, RouterMap, RouterUtils } from 'lib_common';
import { ISFIRST_GUIDE } from '../common/Constants';

/**
 * 首次安装引导页
 */
@Builder
export function StartGuidePageBuilder() {
  StartGuidePage()
}

@ComponentV2
struct StartGuidePage {
  @Local currentIndex: number = 0;
  // 预制轮播 图数组
  @Local imageList: Resource[] = [
    $r('app.media.im_guide1'),
    $r('app.media.im_guide2'),
    $r('app.media.im_guide3')
  ]

  aboutToAppear(): void {
    PreferenceUtils.getInstance().put(ISFIRST_GUIDE, true);
  }

  build() {
    NavDestination() {
      Stack() {
        //实现3张图片全屏轮播引导
        Column() {
          Column() {
            // 轮播图实现
            Swiper() {
              ForEach(this.imageList, (imageResource: Resource) => {
                Image(imageResource)
                  .objectFit(ImageFit.Fill)
              }, (imageResource: Resource, index: number) => `${imageResource.id}-${index}`)
            }
            .height('82%')
            .index(0) // 初始显示第一张图片
            .loop(true) // 支持循环滑动
            .duration(3000) // 自动播放间隔时间(毫秒)
            .vertical(false) // 水平滑动
            .interval(5000) // 轮播间隔时间
            .autoPlay(true)
            .indicator(new DotIndicator()
              .color($r('sys.color.comp_background_secondary'))
              .itemWidth(6)
              .itemHeight(6)
            )
            .onChange((index: number) => {
              this.currentIndex = index;
            })
          }
          .width('100%')
          .height('88%')
          .padding({ left: CommonConstants.PADDING_L, right: CommonConstants.PADDING_L })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Row() {
            Button('进入应用')
              .width(150)
              .fontSize($r('sys.float.Body_L'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
              .backgroundColor($r('app.color.app_theme'))
              .margin({
                top: CommonConstants.PADDING_M,
                bottom: CommonConstants.PADDING_S,
              })
              .onClick(() => {
                RouterUtils.clearStack();
                RouterUtils.replacePathByName(RouterMap.INDEX_PAGE);
              })
          }
          .width('100%')
          .height('12%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(Color.White)
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.background_secondary'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .hideTitleBar(true)
  }
}
