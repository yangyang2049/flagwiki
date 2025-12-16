import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { NetworkModel } from '../models/NetworkModel';
import { Logger } from './Logger';

const TAG = '[NetworkUtil]'

export class NetworkUtil {
  private static instance?: NetworkUtil
  private networkModel: NetworkModel = NetworkModel.getInstance()
  // 创建网络NetConnection对象
  private netCon: connection.NetConnection = connection.createNetConnection();

  public static getInstance(): NetworkUtil {
    if (!NetworkUtil.instance) {
      NetworkUtil.instance = new NetworkUtil()
    }
    return NetworkUtil.instance
  }

  init() {
    // 获取默认网络
    this.getNetwork();
    // 获取网络的连接信息
    this.getConnectNetAddress()
    // 订阅指定网络状态变化的通知。
    this.registerNet()
  }

  getNetwork() {
    let netHandle = connection.getDefaultNetSync();
    this.networkModel.netHandle = netHandle
    // 是否有网络
    if (netHandle.netId >= 100) {
      this.networkModel.hasNet = true;
      // 获取netHandle对应网络的能力信息
      let capInfo = connection.getNetCapabilitiesSync(netHandle)
      if (capInfo.bearerTypes[0] === 0) {
        this.networkModel.isCellular = true
        this.networkModel.isWiFi = false
      } else if (capInfo.bearerTypes[0] === 1) {
        this.networkModel.isCellular = false
        this.networkModel.isWiFi = true
      }
    } else {
      this.networkModel.hasNet = false;
      this.networkModel.isCellular = false
      this.networkModel.isWiFi = false
    }

    Logger.info(TAG, `getDefaultNetSync: ${JSON.stringify(netHandle)}`)
  }

  getConnectNetAddress() {
    let netHandle = connection.getDefaultNetSync();
    // 是否有网络
    if (netHandle.netId >= 100) {
      const connectInfo = connection.getConnectionPropertiesSync(netHandle);
      if (connectInfo.dnses.length > 0) {
        this.networkModel.netAddress = connectInfo.dnses.map((item: connection.NetAddress) => item.address)
      }
    }
    Logger.info(TAG, `getConnectNetAddress, get current netAddress is: ${JSON.stringify(this.networkModel.netAddress)}`)
  }

  registerNet() {
    this.netCon.register((error: BusinessError) => {
      Logger.error(TAG, `network register error: ${JSON.stringify(error)}`)
    });
    // 订阅网络可用事件。调用register后，才能接收到此事件通知。
    this.netCon.on('netAvailable', (data: connection.NetHandle) => {
      Logger.info(TAG, `netAvailable, get data: ${JSON.stringify(data)}`)
    });
    // 订阅网络阻塞状态事件。调用register后，才能接收到此事件通知。
    this.netCon.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
      Logger.info(TAG, `netBlockStatusChange, get data: ${JSON.stringify(data)}`)
    });
    // 订阅网络能力变化事件。调用register后，才能接收到此事件通知。
    this.netCon.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      Logger.info(TAG, `netCapabilitiesChange, get data: ${JSON.stringify(data)}`)
      this.networkModel.netHandle = data.netHandle

      if (data.netHandle.netId >= 100) {
        this.networkModel.hasNet = true;
        // 蜂窝网络
        if (data.netCap.bearerTypes[0] === 0) {
          this.networkModel.isCellular = true
          this.networkModel.isWiFi = false
        } else if (data.netCap.bearerTypes[0] === 1) { // Wi-Fi网络
          this.networkModel.isCellular = false
          this.networkModel.isWiFi = true
        }
        // 有网络时，重置状态
        this.networkModel.hasOfflineTip = false;
      } else {
        this.networkModel.hasNet = false;
        this.networkModel.isCellular = false
        this.networkModel.isWiFi = false
      }
    });
    // 订阅网络连接信息变化事件。调用register后，才能接收到此事件通知。
    this.netCon.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      const connectionProperties = data.connectionProperties;
      const dnses = connectionProperties.dnses;
      this.networkModel.netAddress = dnses.map((item: connection.NetAddress) => item.address);
      Logger.info(TAG,
        `netConnectionPropertiesChange, get current netAddress is: ${JSON.stringify(this.networkModel.netAddress)}`)
    });
    // 订阅网络丢失事件。调用register后，才能接收到此事件通知。
    this.netCon.on('netLost', (data: connection.NetHandle) => {
      Logger.info(TAG, `netLost, get data: ${JSON.stringify(data)}`)
      this.networkModel.hasNet = false;
      this.networkModel.isCellular = false
      this.networkModel.isWiFi = false
      this.networkModel.netHandle = undefined
    });
  }

  unregister() {
    this.netCon.unregister((error: BusinessError) => {
      Logger.error(TAG, `unregister network: ${JSON.stringify(error)}`)
    });
  }
}