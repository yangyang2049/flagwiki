/**
 * 主题信息
 */
export interface IThemeInfo {
  id: number;
  label: string; // 主题名称
  pics: string[]; // 主题图片
  colors: string[]; // 颜色值
  desc: string; // 描述
  isVip: boolean; // 是否为会员专享
  isDownload: boolean; //是否下载
}