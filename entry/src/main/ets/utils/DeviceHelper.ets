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
}
