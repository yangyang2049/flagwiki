/**
 * 作者-云侧接口响应模型
 */
export interface AuthorResponse {
  // 作者id
  authorId: string
  //作者昵称
  authorNickName: string
  // 作者icon
  authorIcon: string
  //作者简介
  authorDesc: string
  // 作者ip
  authorIp: string
  // 关注的人数
  watchersCount: number
  // 粉丝数量
  followersCount: number
  // 获赞数量
  likeNum: number
  // 关注的人id集合
  watchers?: string[]
  // 粉丝id集合
  followers?: string[]
  // 手机号
  authorPhone?: string
}