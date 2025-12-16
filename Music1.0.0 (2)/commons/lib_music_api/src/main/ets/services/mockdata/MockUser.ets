import { MyAuthor } from '../../database/AuthorType';

/**
 * User Mock数据
 */
export class MockUser {
  // 本人模型
  static myself: MyAuthor = {
    authorId: '001',
    authorNickName: '华为用户',
    authorIcon: '',
    authorDesc: '在自己的小世界里，做一个快乐的普通人，把节奏放慢，享受生活！十六岁的青春张扬 十八岁的未来可期，携零零碎碎的美好奔赴未知的将来！',
    authorPhone: '177******96',
    authorIp: '南京',
    watchers: ['author_1', 'author_2', 'author_6', 'author_7'],
    followers: ['author_1', 'author_2', 'author_3', 'author_4', 'author_5'],
    likeNum: 12,
    myLikes: ['author_1', 'author_3', 'video1', 'post_1'],
    myMarks: ['author_2', 'author_4', 'video2', 'post_1'],
    myComments: [],
    myHistory: ['author_1', 'video1', 'post_1'],
  };
}