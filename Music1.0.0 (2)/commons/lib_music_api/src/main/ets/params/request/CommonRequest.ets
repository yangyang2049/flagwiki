import { PostImgList } from '../base/BaseModel'

/**
 * 发布动态请求字段
 */
export interface PostRequest {
  // 正文
  postBody: string
  // 图片、视频链接
  postImgList?: PostImgList[]
}

/**
 * 修改个人信息
 */
export interface ModifyPersonalInfoRequest {
  authorIcon?: string
  authorNickName?: string
  authorPhone?: string
  authorDesc?: string
}