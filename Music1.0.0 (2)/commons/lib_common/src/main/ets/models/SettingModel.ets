/**
 * 全局设置
 */
@ObservedV2
export class SettingModel {
  // 未成年模式
  @Trace teenagersSwitch: boolean = false;
  // 开始登录时间
  @Trace startLoginTime: number = 0;
  // 下载品质
  @Trace qualitySwitch: number = 0;
  // 边听边存
  @Trace storageSwitch: boolean = false;
  // 边听边存
  @Trace cachePath: string = '/music';
  // 通知开关
  @Trace pushSwitch: boolean = false;
  // 深色模式
  @Trace darkSwitch: boolean = false;
  // 字体大小
  @Trace fontSizeRatio: number = 1;
  // 隐私设置-个性化推荐
  @Trace personalizedPush: boolean = true;
  // 播放与网络设置
  @Trace network: SettingNetworkModel = new SettingNetworkModel();
  // 默认主题id
  @Trace themeId: number = 0;
  // 主题色
  @Trace themeColor: string = '#FF1949';
  // 主题色['主题色'，'播放条色‘，’播放条歌曲名色‘，'tab未选中色']
  @Trace themeColors: string[] = [];
  //主题背景
  @Trace themePic: string = '';
  @Trace fontSecondary: string = '#000000';
  // 用于校验密码
  @Trace teenagersPassword: string = '8888';
}

@ObservedV2
export class SettingNetworkModel {
  // 非WLAN网络流量
  @Trace downloadWithoutWlan: number = 0;
  // 非WLAN网络播放提醒
  @Trace remindWithoutWlan: number = 0;
  // 非WLAN网络下自动播放直播
  @Trace liveAutoplayWithoutWlan: boolean = true;
  // 使用移动网络改善内容浏览体验
  @Trace optimizeWith4G: boolean = true;
  // 视频自动下滑
  @Trace autoPlayNext: boolean = true;
  // 推荐频道自动播放视频
  @Trace autoPlayTabRecommend: boolean = true;
}