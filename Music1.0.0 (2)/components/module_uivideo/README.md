# 视频 UIVideo

## 简介

UIVideo是基于open harmony基础组件开发的视频组件，支持横屏显示，以及音量、亮度和进度调节。

## 快速开始

### 安装

```
ohpm install @hw-agconnect/ui-video
```

### 使用

```
// 组件在同一页面仅支持单个视频组件使用。
// 引入组件
import { UIVideo } from '@hw-agconnect/ui-video';
```

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。
2. HarmonyOS系统：HarmonyOS 5.0.1 Release及以上。
3. DevEco Studio版本：DevEco Studio 5.0.1 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 5.0.1 Release SDK及以上。

## 子组件

无

## 接口

### UIVideo(options: UIVideoOptions)

**UIVideoOptions对象说明**

| <div style="width:200px" align="left">参数</div> | <div style="width:200px" align="left">类型</div> | <div style="width:80px" align="left">必填</div> | <div style="width:200px" align="left">说明</div> |
|:-----------------------------------------------|:-----------------------------------------------|:----------------------------------------------|:-----------------------------------------------|
| videoData                                      | IVideoData[]                                   | 是                                             | 视频信息                                           |
| style                                          | VolumnAndBrightStyle                           | 否                                             | 音量和亮度进度条类型                                     |
| controller                                     | VideoController                                | 否                                             | 视频控制器，可以控制视频的播放状态                              |   
| customTopRegion                                | CustomBuilder                                  | 否                                             | 视频自定义顶部状态信息栏                                   | 
| customBottomRegion                             | CustomBuilder                                  | 否                                             | 视频自定义底部状态信息栏                                   |
| componentController                            | ComponentController                            | 否                                             | 组件控制器，控制全屏退出                                   |

**VideoController对象说明**

| <div style="width:200px" align="left">参数</div> | <div style="width:200px" align="left">类型</div> | <div style="width:200px" align="left">说明</div> |
|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|
| playerModel                                    | PlayerModel                                    | 播放器音量等数据                                       |
| release                                        | ()=>void                                       | 销毁播放资源                                         |
| pause                                          | ()=>void                                       | 暂停播放                                           |
| setLoop                                        | ()=>void                                       | 设置循环播放,第二次点击时取消                                |
| setSpeed                                       | (playSpeed: media.PlaybackSpeed)=>void         | 设置播放速度，同鸿蒙                                     |
| previousVideo                                  | ()=>void                                       | 播放上一个视频                                        |
| nextVideo                                      | ()=>void                                       | 播放下一个视频                                        |
| switchPlayOrPause                              | ()=>void                                       | 播放切换为暂停、暂停切换为播放                                |
| setSeekTime                                    | (value: number, mode: SliderChangeMode)=>void  | 调整播放进度，SliderChangeMode同鸿蒙                     |
| setBright                                      | (value:number)=>void                           | 调整亮度，同鸿蒙                                       |
| setVolume                                      | (value:number)=>void                           | 调整音量，同鸿蒙                                       |

**ComponentController对象说明**

| <div style="width:200px" align="left">参数</div> | <div style="width:200px" align="left">类型</div> | <div style="width:200px" align="left">说明</div> |
|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|
| onBack                                         | ()=>boolean                                    | 全屏时，视频退出全屏状态，需要配合onBackPress使用                                    |

**PlayerModel对象说明**

| <div style="width:200px" align="left">参数</div> | <div style="width:200px" align="left">类型</div> | <div style="width:200px" align="left">说明</div> |
|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|
| playSpeed                                      | number                                         | 播放速度                                           |
| volume                                         | number                                         | 播放音量                                           |
| bright                                         | number                                         | 屏幕亮度                                           |
| currentTime                                    | string                                         | 当前的播放时间                                        |
| totalTime                                      | string                                         | 播放总时长                                          |
| progressVal                                    | number                                         | slider滑块的进度值                                   |

**volumnAndBrightStyle枚举说明**

| <div style="width:200px" align="left">名称</div> | <div style="width:200px" align="left">描述</div> |
|:-----------------------------------------------|:-----------------------------------------------|
| CIRCLE                                         | 设置音量、亮度、播放进度为圆形                                |
| CAPSULE                                        | 设置音量、亮度、播放进度为胶囊                                |

**IVideoData对象说明**

| <div style="width:200px" align="left">参数</div> | <div style="width:200px" align="left">类型</div> | <div style="width:80px" align="left">必填</div> | <div style="width:200px" align="left">说明</div> |
|:-----------------------------------------------|:-----------------------------------------------|:----------------------------------------------|:-----------------------------------------------|
| name                                           | string                                         | 是                                             | 视频名称                                           |
| type                                           | string                                         | 是                                             | 视频类型                                           |
| isLocal                                        | boolean                                        | 是                                             | 是否为本地视频                                        |   
| src                                            | string                                         | 否                                             | 网络视频URL地址                                      | 
| episode                                        | string                                         | 否                                             | 视频集数                                           |

## 使用限制

无

## 示例

### 示例1

```
import { UIVideo, VideoController, IVideoData, ComponentController } from '@hw-agconnect/ui-video';

@Entry
@ComponentV2
struct FullVideoSample {
  @Local controller: VideoController = new VideoController();
  @Local componentController: ComponentController = new ComponentController();
  @Local speedText: string = "";
  @Local brightText: string = "";
  @Local volumeText: string = "";
  @Local SliderChangeModeNumber: number = SliderChangeMode.Begin;
  @Local SeekTimeNumber: number = 0;
  @Local styleNumber: number = 1;
  @Local scroller: Scroller = new Scroller;
  @Local videoData: IVideoData[] = [
    {
      name: 'video',
      type: 'mp4',
      isLocal: true
    }
  ]

  onBackPress() {
    return this.componentController.onBack()
  }

  build() {
    Column() {
      UIVideo({
        videoData: this.videoData,
        controller: this.controller,
        componentController: this.componentController,
      })
      Scroll(this.scroller) {
        Column() {
          Row() {
            Button('pause')
              .onClick(() => {
                this.controller.pause()
              })
            Button('setLoop')
              .onClick(() => {
                this.controller.setLoop()
              })
            Button('previousVideo')
              .onClick(() => {
                this.controller.previousVideo()
              })
          }.padding({ top: 5 })

          Row() {
            Button('nextVideo')
              .onClick(() => {
                this.controller.nextVideo()
              })
            Button('switchPlayOrPause')
              .onClick(() => {
                this.controller.switchPlayOrPause()
              })
          }.padding({ top: 5 })

          Row() {
            Column() {
              Text("设置播放速度")
              Text("setspeed")
            }

            Text("：")
            TextInput()
              .width(100)
              .height(50)
              .onChange((value: string) => {
                this.speedText = value

              })
              .cancelButton({
                style: CancelButtonStyle.CONSTANT,
                icon: {
                  size: 30,
                  src: $r('app.media.ic_public_expand'),
                  color: Color.Blue
                }
              })
            Button('确定')
              .onClick(() => {
                this.controller.setSpeed(Number(this.speedText))
              }).width(60)

          }.justifyContent(FlexAlign.Start).padding({ top: 5 })

          Row() {
            Column() {
              Text("设置音量")
              Text("setVolume")
            }

            Text("：")
            TextInput()
              .width(100)
              .height(50)
              .onChange((value: string) => {
                this.volumeText = value
              })
              .cancelButton({
                style: CancelButtonStyle.CONSTANT,
                icon: {
                  size: 30,
                  src: $r('app.media.ic_public_expand'),
                  color: Color.Blue
                }
              })
            Button('确定')
              .onClick(() => {
                this.controller.setVolume(Number(this.volumeText))
              }).width(60)

          }.justifyContent(FlexAlign.Start).padding({ top: 5 })

          Row() {
            Column() {
              Text("设置亮度")
              Text("setBright")
            }

            Text("：")
            TextInput()
              .width(100)
              .height(50)
              .onChange((value: string) => {
                this.brightText = value
              })
              .cancelButton({
                style: CancelButtonStyle.CONSTANT,
                icon: {
                  size: 30,
                  src: $r('app.media.ic_public_expand'),
                  color: Color.Blue
                }
              })
            Button('确定')
              .onClick(() => {
                this.controller.setBright(Number(this.brightText))
              }).width(60)

          }.justifyContent(FlexAlign.Start).padding({ top: 5 })
        }
        .height('100%')
        .width('100%')
      }
    }
  }
}

```

![视频](https://agc-storage-drcn.platform.dbankcloud.cn/v0/cloud-urahf/IMG_609.gif?token=a07a8c0c-2cd5-454f-aead-ab56e11525fe)



