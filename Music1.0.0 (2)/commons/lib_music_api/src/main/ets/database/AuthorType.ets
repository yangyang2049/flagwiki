/**
 * 用户数据库字段
 */
export interface BaseAuthor {
  // 作者id
  authorId: string
  //作者昵称
  authorNickName: string
  // 作者icon
  authorIcon: string
  //作者简介
  authorDesc: string
  // 手机号
  authorPhone?: string
  // 作者ip
  authorIp: string
  // 关注的人
  watchers: string[]
  // 粉丝
  followers: string[]
  // 获赞数量
  likeNum: number
}

/**
 * 本人数据库字段
 */
export interface MyAuthor extends BaseAuthor {
  // 我的点赞
  myLikes: string[]
  // 我的收藏
  myMarks: string[]
  // 我的评论
  myComments: string[]
  // 阅读历史
  myHistory: string[]
}