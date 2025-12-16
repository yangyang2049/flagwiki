import { RouterMap } from 'lib_common';

/**
 * 我的GridItem类型
 */
export interface MineGridItem {
  icon: ResourceStr;
  label: ResourceStr;
  routerName: RouterMap;
}

/**
 * 消息菜单类型
 */
export enum MineMsgMenuType {
  Comment = 1,
  IM,
  Fan,
  System,
}