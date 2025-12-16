import { PlaylistModel, ResManager, RouterMap, RouterUtils } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { MusicPlayController, SongItem } from 'module_musicplay';
import { ThemeController } from 'module_theme';
import { SelectPlayList } from '../constants/SelectPlayList';
import { MyPlatListVM } from '../viewmodels/MyPlatListVM';

@Builder
export function MineMusicPageBuilder() {
  MineMusicPage()
}

@Extend(Row)
function onPressedRow() {
  .stateStyles({
    normal: { .backgroundColor('#ffffff')
    },
    pressed: { .backgroundColor('#efefef')
    },
  })
}

@ComponentV2
struct MineMusicPage {
  @Local song: SongItem[] = []
  @Local editAllMusic: boolean = false
  @Local isShow: boolean = false
  @Local vm: MyPlatListVM = new MyPlatListVM();
  @Local isSelectIndex: number = 0
  @Local selectList?: SelectPlayList
  // 选择的布尔集合
  @Local selectedFlags: Array<boolean> = [];
  // 自定义返回事件
  @Event onBack: () => void = () => {
    RouterUtils.pop()
  };

  aboutToAppear() {
    this.selectedFlags = new Array(this.vm.myPlayListModel.playList.length).fill(false);
  }

  @Builder
  myBuilder() {
    Column() {
      // 编辑歌单信息
      Row() {
        Image($r('app.media.edit_music_name'))
          .height(20)
          .padding({ left: 30 })
        Text('编辑歌单信息')
          .fontSize(14)
          .padding({ left: 10 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .margin({ top: 8 })
      .onPressedRow()
      .onClick(() => {
        // 进入编辑歌单页面
        RouterUtils.pushPathByName(RouterMap.ADD_ONE_PLAY_LIST, this.selectList);
        this.isShow = false
      })

      // 删除歌单
      Row() {
        Image($r('app.media.delete_music_info'))
          .height(20)
          .padding({ left: 30 })
        Text('删除歌单')
          .fontSize(14)
          .padding({ left: 10 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        this.vm.myPlayListModel.playList = this.vm.deleteOnePlayList(this.isSelectIndex)
        // 删除操作
        this.getUIContext().getPromptAction().showToast({ message: '删除成功' });
        this.isShow = false

      })
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 标题
        NavHeaderBar({
          title: '我的歌单',
          bgColor: '#f2f4f5',
        })

        // 添加行
        Row() {
          Stack() {
            Column() {
            }
            .width(50)
            .height(50)
            .backgroundColor('#e5e7e9')
            .borderRadius(5)

            Image($r('app.media.jiahao'))
              .width(20)
          }.margin({ left: 20 })

          Text('新建歌单')
            .fontSize(16)
            .margin({ left: 20 })
        }
        .width('100%')
        .height(80)
        .onClick(() => {
          RouterUtils.pushPathByName(RouterMap.ADD_ONE_PLAY_LIST);
        })

        //
        List() {
          ForEach(this.vm.myPlayListModel.playList, (v: PlaylistModel, index: number) => {
            ListItem() {
              Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                // 歌单1
                Row() {
                  Image(ResManager.getPic(v.cover))
                    .width(50)
                    .height(50)
                    .margin({ left: 20 })
                  Column() {
                    Text(v.title)
                      .fontSize(15)
                    Text() {
                      Span(`${v.songList.length}首`)
                      Span(' | ')
                      Span(v.subTitle)
                    }.fontColor('#a7a7a7')
                    .fontSize(13)
                    .margin({ top: 10 })
                  }
                  .margin({ left: 10 })
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)

                  Blank()

                  Column() {
                    Image($r('app.media.liangdian'))
                      .width(25)
                  }
                  .backgroundColor('#e6e8ea')
                  .width(30)
                  .height(30)
                  .borderRadius('50%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .margin({ right: 15 })
                  .onClick(() => {
                    this.isShow = true
                    this.isSelectIndex = index
                    this.selectList = new SelectPlayList(v, index)
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .height(80)
                .onClick(() => {
                  let thisSelect: SelectPlayList = new SelectPlayList(v, index)
                  RouterUtils.pushPathByName(RouterMap.MINE_ONE_PLAY_LIST, thisSelect);
                })
              }
            }
          }, (v: SongItem) => JSON.stringify(v))
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        Blank()
        MusicPlayController()
      }.height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor('#f2f4f5')
    .bindSheet($$this.isShow, this.myBuilder(), {
      height: 115,
      backgroundColor: Color.White,
      showClose: false
    })
    .padding({
      bottom: this.vm.windowModel.windowBottomPadding
    })

  }
}