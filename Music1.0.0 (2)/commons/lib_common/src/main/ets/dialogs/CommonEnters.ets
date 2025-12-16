import { CommonConstants } from '../constants/CommonConstants'
import { promptAction } from '@kit.ArkUI'
import { PopViewUtils } from '../utils/PopViewUtils'
import { PlayListMV } from '../viewmodels/PlayListMV'
import { CommonEnterDialog } from './CommonEnterDialog'
import { PlaylistModel } from '../models/PlayListModel'
import { ResManager } from '../utils/ResManager'

@ComponentV2
export struct CommonEnters {
  vm: PlayListMV = new PlayListMV();
  @Param @Require songId: string
  // 回调函数
  @Event callback: () => void

  build() {
    Column() {
      // 新增
      Row() {
        // 采用系统资源图片
        Row() {
          SymbolGlyph($r('sys.symbol.plus'))
            .fontSize(28)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
        }
        .width(52)
        .height(52)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('sys.color.background_secondary'))
        .borderRadius(4)

        Text('新建歌单')
          .fontSize($r('sys.float.Body_L'))
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })

      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        bottom: CommonConstants.PADDING_M
      })
      .onClick(() => {
        CommonEnterDialog.show({
          primaryTitle: '创建新歌单',
          content: `我的歌单${this.vm.myPlayListModel.playList.length + 1}`,
          confirm: (value) => {
            //判断歌单是否重名
            if (this.vm.myPlayListModel.playList.some(item => item.title === value)) {
              promptAction.showToast({ message: '已有同名歌单，请重新命名' });
              return;
            }
            this.vm.newPlayList(this.songId, value)
            PopViewUtils.closeSheet();
            this.callback()
          },
          cancel: () => {
            PopViewUtils.closeSheet();
          }
        })
      })

      //歌单列表
      List() {
        ForEach(this.vm.myPlayListModel.playList, (item: PlaylistModel) => {
          ListItem() {
            // 分三列，第一列歌曲封面，第二列歌曲信息（歌曲名和歌曲），第三列播放按钮
            Row() {
              Column() {
                Image(ResManager.getPic(item.cover))
                  .width(48)
                  .height(48)
                  .borderRadius(4)
                  .alignSelf(ItemAlign.Center)
              }
              .width(48)
              .alignItems(HorizontalAlign.Center)
              .padding({
                left: 16,
                right: 16
              })

              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
                Text(`${item.songList.length}首`)
                  .fontSize(12)
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              }
              .padding({
                left: 16,
              })
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .margin({
              left: 16,
              right: 16,
              top: 16,
              bottom: 16
            })
            .onClick(() => {
              // 判断对各歌单中是否存在该歌曲
              if (item.songList.some(item => item.id === this.songId)) {
                PopViewUtils.closePopView();
                promptAction.showToast({ message: '已加入歌单' });
                return;
              }
              this.vm.addSongToPlayList(this.songId, item.title)
              PopViewUtils.closePopView();
              promptAction.showToast({ message: '已加入歌单' });
              this.callback()
            })
          }
        }, (item: PlaylistModel, index) => JSON.stringify(item) + index)
      }
      .width('90%')
      .height(200 + this.vm.myPlayListModel.playList.length * 45)
      .constraintSize({ maxHeight: '85%' })
      .cachedCount(3)
      .divider({
        strokeWidth: 1,
        color: '#E8E8E8',
        startMargin: 48,
        endMargin: 16
      })
      .margin({ bottom: CommonConstants.SPACE_M })
      .scrollBar(BarState.Off)
    }
  }
}