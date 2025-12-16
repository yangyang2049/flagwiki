/**
 * 应用的Tab信息
 */
@ObservedV2
export class TabModel {
  // 当前选择的tab下标
  @Trace selectedIndex: number = 0;
  // 是否展示tab
  @Trace showTabBar: boolean = true;
  // tab的高度
  @Trace tabHeight: Length = '';
  // 视频tab页的头部tab
  @Trace videoCurrentTabIndex: number = 1;
}

