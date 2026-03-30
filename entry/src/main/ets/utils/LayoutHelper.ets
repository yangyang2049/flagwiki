import { DeviceHelper } from './DeviceHelper'

/**
 * 平板/2-in-1 设备内容区最大宽度（vp）
 * 限制内容宽度，避免宽屏拉伸；不采用左右分栏布局
 */
export const CONTENT_MAX_WIDTH_PAD = 600

/**
 * 是否为平板或 2-in-1，需要限制内容宽度并居中
 */
export function isPadOr2in1Layout(): boolean {
  return DeviceHelper.isPadOr2in1()
}

/** 手机端不限制宽度时使用的占位值（vp），实际不会约束 */
const UNLIMITED_WIDTH = 10000

/**
 * 获取内容区最大宽度（vp）；pad/2in1 返回 CONTENT_MAX_WIDTH_PAD，否则返回 UNLIMITED_WIDTH
 */
export function getContentMaxWidth(): number {
  return DeviceHelper.isPadOr2in1() ? CONTENT_MAX_WIDTH_PAD : UNLIMITED_WIDTH
}
