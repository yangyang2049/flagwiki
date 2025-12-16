import { PlaylistModel, ResManager, RouterMap, RouterUtils } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { MyPlatListVM } from '../viewmodels/MyPlatListVM';
import { SelectPlayList } from '../constants/SelectPlayList';
import { promptAction } from '@kit.ArkUI';

const TAG = 0x0000;

@Builder
export function AddOnePlayListBuilder() {
  AddOnePlayList()
}

@ComponentV2
struct AddOnePlayList {
  private context: Context = this.getUIContext().getHostContext()!;
  @Local selectUris: Array<string> = [];
  @Local currentUri: string = '';
  @Local playlistModel: PlaylistModel =
    new PlaylistModel('我的歌单', '简单介绍主题可以让人更了解你的歌单', $r('app.media.ic_moren'), []);
  @Local addList: boolean = false;
  @Local vm: MyPlatListVM = new MyPlatListVM();
  @Local selectList?: SelectPlayList;
  @Local textInput?: string = '';
  @Local title?: string = '';

  aboutToAppear() {
    const param = RouterUtils.getParamByName<SelectPlayList>(RouterMap.ADD_ONE_PLAY_LIST);
    if (param) {
      this.selectList = param
      this.playlistModel = param.playlistModel
      this.textInput = this.selectList.playlistModel.title
      this.title = '编辑歌单'
    } else {
      this.addList = true
      this.textInput = '我的歌单' + (this.vm.myPlayListModel.playList.length + 1)
      this.title = '新增歌单'
    }
  }

  // 获取存入沙箱的背景图地址
  getUri(): string {
    let fileName = ''
    try {
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.isEditSupported = false;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then(async (result: photoAccessHelper.PhotoSelectResult) => {
        if (result.photoUris.length > 0) {
          this.selectUris.push(result.photoUris[0]);
          this.currentUri = result.photoUris[0];
          if (this.selectUris.length > 0) {
            let file: fs.File | null = null;
            let file2: fs.File | null = null;
            try {
              // 存入沙箱
              file = fs.openSync(this.currentUri, fs.OpenMode.READ_ONLY)

              let fileName = this.context.filesDir + '/' + Date.now() + 'picture.jpg'

              file2 = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)

              fs.copyFileSync(file.fd, file2.fd)

              fileName = 'file://' + fileName;

              if (this.selectList) {
                this.selectList.playlistModel.cover = fileName
              } else {
                this.playlistModel.cover = fileName
              }
            } catch (error) {
              let err: BusinessError = error as BusinessError;
              hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
            } finally {
              if (file) {
                fs.closeSync(file);
              }
              if (file2) {
                fs.closeSync(file2);
              }
            }
          }
        }
      }).catch((err: BusinessError) => {
        hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(TAG, 'PhotoViewPicker', `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
    return fileName
  }

  build() {
    NavDestination() {
      Column() {
        // 标题
        NavHeaderBar({
          title: this.title,
          bgColor: '#f2f4f5',
        })
        // 封面图片
        Image(ResManager.getPic(this.selectList ? this.selectList.playlistModel.cover : $r('app.media.song_default')))
          .width(150)
          .height(150)
          .borderRadius(10)
        // 上传封面
        Button('上传封面')
          .fontColor(Color.Red)
          .backgroundColor('#ffffff')
          .height(35)
          .width(110)
          .margin({ top: 10 })
          .type(ButtonType.Normal)
          .borderRadius(20)
          .onClick(() => {
            this.getUri()
          })

        Column() {
          Row() {
            Text('歌单名称')
              .fontSize(15)
              .padding({
                left: 15
              })
          }.width('100%')
          .justifyContent(FlexAlign.Start)
          .margin({ top: 10 })

          TextInput({ text: this.textInput })
            .height(40)
            .maxLength(10)
            .showCounter(true)
            .fontSize(13)
            .backgroundColor('#ffffff')// 设置下划线
            .outline({
              width: { bottom: 1 },
              color: '#f2f4f5',
            })
            .onChange((value) => {
              this.playlistModel.title = value
            })
          Row() {
            Text('简介')
              .fontSize(15)
              .padding({
                left: 15
              })
          }.width('100%')
          .justifyContent(FlexAlign.Start)
          .margin({ top: 15 })

          if (this.selectList) {
            TextInput({ text: this.playlistModel.subTitle })
              .fontSize(13)
              .fontColor('#ff757171')
              .height(40)
              .maxLength(20)
              .backgroundColor('#ffffff')
              .onChange((value) => {
                this.playlistModel.subTitle = value
              })
          } else {
            TextInput({ placeholder: '简单介绍主题可以让人更了解你的歌单' })
              .fontSize(13)
              .fontColor('#ff757171')
              .height(40)
              .maxLength(20)
              .backgroundColor('#ffffff')
              .onChange((value) => {
                this.playlistModel.subTitle = value
              })
          }
        }
        .backgroundColor('#ffffff')
        .height(140)
        .width('90%')
        .borderRadius(10)
        .margin({ top: 20 })

        Blank()
        Row() {
          Button('取消')
            .fontColor('#646464')
            .backgroundColor('#ffffff')
            .height(50)
            .width(160)
            .margin({ bottom: 20, left: 10 })
            .type(ButtonType.Normal)
            .borderRadius(20)
            .onClick(() => {
              // 返回
              RouterUtils.pop()
            })
          Blank()
          Button('保存')
            .fontColor(Color.White)
            .backgroundColor('#fb2840')
            .height(50)
            .width(160)
            .margin({ bottom: 20, right: 10 })
            .type(ButtonType.Normal)
            .borderRadius(20)
            .onClick(() => {
              if (this.playlistModel && this.addList) {
                if (this.vm.addMusicList(this.playlistModel)) {
                  RouterUtils.pop()
                } else {
                  promptAction.showToast({ message: '歌单已经存在' })
                }
              } else {
                if (this.selectList) {
                  if (this.vm.updateMusicListInfo(this.selectList)) {
                    RouterUtils.pop()
                  } else {
                    promptAction.showToast({ message: '歌单已经存在' })
                  }
                }
              }
            })
        }.width('100%')
      }
      .height('100%')
      .backgroundColor('#f2f4f5')
      .padding({
        bottom: this.vm.windowModel.windowBottomPadding
      })
    }.hideTitleBar(true)
  }
}