import deviceInfo from '@ohos.deviceInfo'

/**
 * 设备类型检测工具
 */
export class DeviceHelper {
  /**
   * 检查是否为手表设备
   */
  static isWearable(): boolean {
    try {
      return deviceInfo.deviceType === 'wearable'
    } catch (error) {
      console.error('[DeviceHelper] Error getting device type:', error)
      return false
    }
  }

  /**
   * 检查是否为平板设备
   */
  static isTablet(): boolean {
    try {
      return deviceInfo.deviceType === 'tablet'
    } catch (error) {
      console.error('[DeviceHelper] Error getting device type:', error)
      return false
    }
  }

  /**
   * 检查是否为 2-in-1 设备
   */
  static is2in1(): boolean {
    try {
      return deviceInfo.deviceType === '2in1'
    } catch (error) {
      console.error('[DeviceHelper] Error getting device type:', error)
      return false
    }
  }

  /**
   * 检查是否为平板或 2-in-1 设备（需限制内容宽度、居中布局）
   */
  static isPadOr2in1(): boolean {
    return DeviceHelper.isTablet() || DeviceHelper.is2in1()
  }

  /**
   * 获取设备类型
   */
  static getDeviceType(): string {
    try {
      return deviceInfo.deviceType
    } catch (error) {
      console.error('[DeviceHelper] Error getting device type:', error)
      return 'phone'
    }
  }

  /**
   * 是否为模拟器环境（用于跳过依赖 HMS TextReader HSP 等能力，避免 LoadJSPandaFile 失败导致进程 abort）
   */
  static isLikelyEmulator(): boolean {
    try {
      const haystack = `${deviceInfo.productModel}|${deviceInfo.marketName}|${deviceInfo.softwareModel}`.toLowerCase()
      return haystack.includes('emulator') || haystack.includes('simulator')
    } catch (_e) {
      return false
    }
  }
}
