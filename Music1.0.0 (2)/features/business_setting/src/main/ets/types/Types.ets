import { RouterMap } from 'lib_common';

export interface ISelectOption {
  id: number;
  label: string;
}

export interface ISettingItem {
  icon?: ResourceStr;
  label: ResourceStr;
  subLabel?: ResourceStr;
  routerName?: RouterMap;
  routerParams?: Object;
  typeSwitch?: boolean;
  typeSelect?: boolean;
  updatelabel?: boolean;
  switchV?: boolean;
  selectV?: number;
  updateV?: string;
  selectOptions?: ISelectOption[];
  selectTitle?: string;
  extraLabel?: string;
  onClick?: (param?: Object) => void;
  onSelect?: (param?: Object) => void;
  isConfirm?: boolean;
  message?: string;
}

/**
 * 设置ListItem类型
 */
@ObservedV2
export class SettingItem implements ISettingItem {
  @Trace icon?: ResourceStr = '';
  @Trace label: ResourceStr = '';
  @Trace subLabel?: ResourceStr = '';
  @Trace routerName?: RouterMap;
  @Trace routerParams?: Object;
  @Trace typeSwitch?: boolean = false;
  @Trace typeSelect?: boolean = false;
  @Trace updatelabel?: boolean = false;
  @Trace switchV?: boolean;
  @Trace selectV?: number;
  @Trace updateV?: string;
  @Trace selectOptions?: ISelectOption[];
  @Trace selectTitle?: string;
  @Trace extraLabel?: string;
  @Trace onClick?: (param?: Object) => void;
  @Trace onSelect?: (param?: Object) => void;
  @Trace isConfirm?: boolean = false;
  @Trace message?: string;

  constructor(item?: ISettingItem) {
    if (!item) {
      return;
    }
    this.icon = item.icon;
    this.label = item.label;
    this.subLabel = item.subLabel;
    this.routerName = item.routerName;
    this.routerParams = item.routerParams;
    this.typeSwitch = item.typeSwitch;
    this.typeSelect = item.typeSelect;
    this.switchV = item.switchV;
    this.selectV = item.selectV;
    this.updateV = item.updateV;
    this.selectOptions = item.selectOptions;
    this.selectTitle = item.selectTitle;
    this.extraLabel = item.extraLabel;
    this.onClick = item.onClick;
    this.onSelect = item.onSelect;
    this.isConfirm = item.isConfirm;
    this.message = item.message;
    this.updatelabel = item.updatelabel;
  }
}