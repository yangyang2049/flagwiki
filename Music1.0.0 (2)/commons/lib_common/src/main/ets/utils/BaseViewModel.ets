import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { TabModel } from '../models/TabModel';
import { UserInfoModel } from '../models/UserInfoModel';
import { WindowModel } from '../models/WindowModel';
import { SettingModel } from '../models/SettingModel';
import { NavRouteModel } from '../models/NavRouteModel';
import { WindowStageModel } from '../models/WindowStageModel';
import { BreakpointModel } from '../models/BreakpointModel';
import { NetworkModel } from '../models/NetworkModel';
import { MyPlayListModel } from '../models/MyPlayListModel';

/**
 * 所有ViewModel的基类，支持UI动态观测
 */
@ObservedV2
export abstract class BaseViewModel {
  @Trace windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Trace userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace tabModel: TabModel = AppStorageV2.connect(TabModel, () => new TabModel())!;
  @Trace navRouteModel: NavRouteModel = AppStorageV2.connect(NavRouteModel, () => new NavRouteModel())!;
  @Trace settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;
  @Trace windowStageModel: WindowStageModel = AppStorageV2.connect(WindowStageModel, () => new WindowStageModel())!;
  @Trace breakPointModel: BreakpointModel = AppStorageV2.connect(BreakpointModel, () => new BreakpointModel())!;
  @Trace networkModel: NetworkModel = AppStorageV2.connect(NetworkModel, () => NetworkModel.getInstance())!;
  @Trace myPlayListModel: MyPlayListModel = AppStorageV2.connect(MyPlayListModel, () => new MyPlayListModel())!;
}