// 知识答题关卡配置

export interface TriviaQuestion {
  question: string;
  answer: string;
  options: string[];
}

export interface TriviaLevel {
  id: number;
  name: string;
  questions: TriviaQuestion[];
  lives: number;
}

// 10个关卡，每关10个问题
export const triviaQuestions: TriviaQuestion[][] = [
  // Level 1
  [
    { question: '哪面国旗不是长方形的？', answer: 'np', options: ['np', 'cn', 'in', 'pk'] },
    { question: '哪面国旗的红色最多？', answer: 'cn', options: ['cn', 'vn', 'ch', 'bg'] },
    { question: '哪面国旗的白色最多？', answer: 'jp', options: ['jp', 'fr', 'it', 'ie'] },
    { question: '哪面国旗有月亮？', answer: 'tr', options: ['tr', 'de', 'fr', 'it'] },
    { question: '哪面国旗有太阳？', answer: 'jp', options: ['jp', 'cn', 'kr', 'vn'] },
    { question: '哪面国旗是三色旗？', answer: 'fr', options: ['fr', 'jp', 'cn', 'gb'] },
    { question: '哪面国旗有星星？', answer: 'us', options: ['us', 'de', 'fr', 'it'] },
    { question: '哪面国旗有条纹？', answer: 'us', options: ['us', 'jp', 'cn', 'kr'] },
    { question: '哪面国旗有十字？', answer: 'ch', options: ['ch', 'cn', 'jp', 'kr'] },
    { question: '哪个国家的国旗是红白两色？', answer: 'jp', options: ['jp', 'cn', 'us', 'gb'] },
  ],
  // Level 2
  [
    { question: '哪面国旗有龙的图案？', answer: 'bt', options: ['bt', 'cn', 'jp', 'kr'] },
    { question: '哪面国旗有枫叶？', answer: 'ca', options: ['ca', 'us', 'gb', 'au'] },
    { question: '哪面国旗有米字旗？', answer: 'gb', options: ['gb', 'us', 'fr', 'de'] },
    { question: '哪面国旗有南十字星座？', answer: 'au', options: ['au', 'nz', 'br', 'ar'] },
    { question: '哪面国旗有新月和星星？', answer: 'pk', options: ['pk', 'tr', 'my', 'sg'] },
    { question: '哪面国旗有红色圆形？', answer: 'bd', options: ['bd', 'jp', 'kr', 'cn'] },
    { question: '哪面国旗有雄鹰？', answer: 'al', options: ['al', 'de', 'us', 'mx'] },
    { question: '哪面国旗有狮子？', answer: 'lk', options: ['lk', 'sg', 'gb', 'nl'] },
    { question: '哪面国旗有蛇？', answer: 'mx', options: ['mx', 'br', 'ar', 'co'] },
    { question: '哪面国旗有大卫之星？', answer: 'il', options: ['il', 'eg', 'sa', 'ae'] },
  ],
  // Level 3
  [
    { question: '世界上唯一的正方形国旗是？', answer: 'ch', options: ['ch', 'va', 'np', 'mc'] },
    { question: '哪个国家的国旗有五角星？', answer: 'cn', options: ['cn', 'jp', 'kr', 'vn'] },
    { question: '哪个国家的国旗有绿色？', answer: 'br', options: ['br', 'jp', 'cn', 'fr'] },
    { question: '哪面国旗有三角形？', answer: 'np', options: ['np', 'jp', 'cn', 'kr'] },
    { question: '哪面国旗有太极图案？', answer: 'kr', options: ['kr', 'cn', 'jp', 'vn'] },
    { question: '哪面国旗有双头鹰？', answer: 'rs', options: ['rs', 'al', 'de', 'ru'] },
    { question: '哪面国旗有蓝色条纹？', answer: 'gr', options: ['gr', 'fr', 'de', 'it'] },
    { question: '哪面国旗是纯红色的？', answer: 'cn', options: ['cn', 'jp', 'kr', 'vn'] },
    { question: '哪面国旗有黄色圆形？', answer: 'bd', options: ['bd', 'jp', 'in', 'pk'] },
    { question: '哪面国旗有轮子图案？', answer: 'in', options: ['in', 'pk', 'bd', 'lk'] },
  ],
  // Level 4
  [
    { question: '哪面国旗有锤子和镰刀？', answer: 'kp', options: ['kp', 'cn', 'ru', 'cu'] },
    { question: '法国国旗的颜色顺序是？', answer: '蓝白红', options: ['蓝白红', '红白蓝', '白蓝红', '红蓝白'] },
    { question: '意大利国旗的颜色是？', answer: '绿白红', options: ['绿白红', '红白绿', '白绿红', '绿红白'] },
    { question: '德国国旗的颜色是？', answer: '黑红金', options: ['黑红金', '红黑金', '金红黑', '黑金红'] },
    { question: '比利时国旗的颜色是？', answer: '黑黄红', options: ['黑黄红', '红黄黑', '黄黑红', '黑红黄'] },
    { question: '荷兰国旗的颜色是？', answer: '红白蓝', options: ['红白蓝', '蓝白红', '白红蓝', '蓝红白'] },
    { question: '俄罗斯国旗的颜色是？', answer: '白蓝红', options: ['白蓝红', '红蓝白', '蓝白红', '红白蓝'] },
    { question: '爱尔兰国旗的颜色是？', answer: '绿白橙', options: ['绿白橙', '橙白绿', '白绿橙', '绿橙白'] },
    { question: '匈牙利国旗的颜色是？', answer: '红白绿', options: ['红白绿', '绿白红', '白红绿', '红绿白'] },
    { question: '保加利亚国旗的颜色是？', answer: '白绿红', options: ['白绿红', '红绿白', '绿白红', '白红绿'] },
  ],
  // Level 5
  [
    { question: '哪个国家的国旗有三色横条？', answer: 'de', options: ['de', 'fr', 'it', 'jp'] },
    { question: '哪个国家的国旗有三色竖条？', answer: 'fr', options: ['fr', 'de', 'ru', 'nl'] },
    { question: '美国国旗有多少颗星星？', answer: '50', options: ['50', '48', '51', '52'] },
    { question: '美国国旗有多少条条纹？', answer: '13', options: ['13', '50', '15', '12'] },
    { question: '中国国旗有多少颗星星？', answer: '5', options: ['5', '4', '6', '1'] },
    { question: '澳大利亚国旗上有哪个国家的国旗？', answer: '英国', options: ['英国', '美国', '法国', '荷兰'] },
    { question: '新西兰国旗上有几颗星星？', answer: '4', options: ['4', '5', '6', '3'] },
    { question: '巴西国旗上有多少颗星星？', answer: '27', options: ['27', '26', '25', '28'] },
    { question: '欧盟旗帜上有多少颗星星？', answer: '12', options: ['12', '27', '28', '15'] },
    { question: '土耳其国旗上有什么图案？', answer: '新月和星星', options: ['新月和星星', '十字', '太阳', '月亮'] },
  ],
  // Level 6
  [
    { question: '哪个国家的国旗最复杂？', answer: 'bt', options: ['bt', 'np', 'us', 'gb'] },
    { question: '哪个国家的国旗上有武器图案？', answer: 'mz', options: ['mz', 'us', 'cn', 'ru'] },
    { question: '哪个国家的国旗有AK-47？', answer: 'mz', options: ['mz', 'af', 'iq', 'sy'] },
    { question: '哪个国家的国旗上有地图？', answer: 'cy', options: ['cy', 'tr', 'gr', 'mt'] },
    { question: '哪个国家的国旗上有盾牌？', answer: 'hr', options: ['hr', 'rs', 'si', 'ba'] },
    { question: '哪个国家的国旗上有皇冠？', answer: 'li', options: ['li', 'mc', 'lu', 'be'] },
    { question: '哪个国家的国旗上有船？', answer: 'lr', options: ['lr', 'us', 'gb', 'fr'] },
    { question: '哪个国家的国旗上有鸟？', answer: 'pg', options: ['pg', 'id', 'my', 'ph'] },
    { question: '哪个国家的国旗上有树？', answer: 'lb', options: ['lb', 'sy', 'jo', 'iq'] },
    { question: '哪个国家的国旗上有山？', answer: 'si', options: ['si', 'ch', 'at', 'np'] },
  ],
  // Level 7
  [
    { question: '世界上最古老的国旗是？', answer: 'dk', options: ['dk', 'gb', 'fr', 'nl'] },
    { question: '哪个国家的国旗从未改变过？', answer: 'dk', options: ['dk', 'gb', 'fr', 'us'] },
    { question: '哪两个国家的国旗几乎相同？', answer: '摩纳哥和印度尼西亚', options: ['摩纳哥和印度尼西亚', '法国和荷兰', '意大利和墨西哥', '日本和孟加拉国'] },
    { question: '哪个国家的国旗是世界上唯一有两面的？', answer: 'py', options: ['py', 'br', 'ar', 'uy'] },
    { question: '哪个国家的国旗上有紫色？', answer: 'ni', options: ['ni', 'es', 'pt', 'mx'] },
    { question: '哪个国家的国旗上有棕色？', answer: 'qa', options: ['qa', 'ae', 'sa', 'kw'] },
    { question: '哪个国家的国旗是唯一有五边形的？', answer: 'np', options: ['np', 'ch', 'va', 'bt'] },
    { question: '哪个国家的国旗上有建筑？', answer: 'kh', options: ['kh', 'th', 'mm', 'la'] },
    { question: '哪个国家的国旗上有写字？', answer: 'sa', options: ['sa', 'ir', 'af', 'iq'] },
    { question: '哪个国家的国旗上有剑？', answer: 'sa', options: ['sa', 'om', 'kw', 'qa'] },
  ],
  // Level 8
  [
    { question: '北欧十字旗最早出现在哪个国家？', answer: 'dk', options: ['dk', 'se', 'no', 'fi'] },
    { question: '泛非洲颜色是？', answer: '红绿黄', options: ['红绿黄', '红白蓝', '黑红金', '绿白红'] },
    { question: '泛斯拉夫颜色是？', answer: '红白蓝', options: ['红白蓝', '红绿黄', '黑红金', '绿白红'] },
    { question: '泛阿拉伯颜色是？', answer: '红白黑绿', options: ['红白黑绿', '红绿黄', '红白蓝', '黑红金'] },
    { question: '哪个国家的国旗有鳄鱼？', answer: 'tl', options: ['tl', 'id', 'my', 'ph'] },
    { question: '哪个国家的国旗上有钥匙？', answer: 'va', options: ['va', 'mt', 'sm', 'mc'] },
    { question: '哪个国家的国旗上有锚？', answer: 'fj', options: ['fj', 'nz', 'au', 'pg'] },
    { question: '哪个国家的国旗上有塔？', answer: 'kh', options: ['kh', 'th', 'mm', 'la'] },
    { question: '哪个国家的国旗最简单？', answer: 'jp', options: ['jp', 'bd', 'ly', 'ua'] },
    { question: '哪个国家曾经有纯绿色的国旗？', answer: 'ly', options: ['ly', 'sa', 'pk', 'bd'] },
  ],
  // Level 9
  [
    { question: '哪个国家的国旗上有独角兽？', answer: 'gb', options: ['gb', 'fr', 'de', 'it'] },
    { question: '哪个国家的国旗上有公鸡？', answer: 'fr', options: ['fr', 'pt', 'it', 'es'] },
    { question: '哪个国家的国旗上有熊？', answer: 'ru', options: ['ru', 'fi', 'ca', 'us'] },
    { question: '哪个国家的国旗上有大象？', answer: 'la', options: ['la', 'th', 'in', 'lk'] },
    { question: '哪个国家的国旗上有考拉？', answer: '没有', options: ['没有', '澳大利亚', '新西兰', '巴布亚新几内亚'] },
    { question: '哪个国家的国旗上有袋鼠？', answer: '没有', options: ['没有', '澳大利亚', '新西兰', '巴布亚新几内亚'] },
    { question: '哪个国家的国旗上有河马？', answer: '没有', options: ['没有', '肯尼亚', '坦桑尼亚', '乌干达'] },
    { question: '哪个国家的国旗上有骆驼？', answer: '没有', options: ['没有', '埃及', '沙特阿拉伯', '阿联酋'] },
    { question: '哪个国家的国旗上有孔雀？', answer: 'mm', options: ['mm', 'in', 'lk', 'np'] },
    { question: '哪个国家的国旗上有天堂鸟？', answer: 'pg', options: ['pg', 'id', 'my', 'ph'] },
  ],
  // Level 10
  [
    { question: '哪个国家的国旗比例最特殊？', answer: 'np', options: ['np', 'ch', 'va', 'qa'] },
    { question: '卡塔尔国旗的比例是？', answer: '11:28', options: ['11:28', '1:2', '2:3', '3:5'] },
    { question: '瑞士国旗的比例是？', answer: '1:1', options: ['1:1', '2:3', '3:5', '1:2'] },
    { question: '哪个国家的国旗最窄？', answer: 'qa', options: ['qa', 'np', 'ch', 'va'] },
    { question: '哪个国家的国旗有最多的颜色？', answer: 'za', options: ['za', 'us', 'gb', 'br'] },
    { question: '南非国旗有几种颜色？', answer: '6', options: ['6', '5', '4', '7'] },
    { question: '哪个国家的国旗设计最新？', answer: 'ss', options: ['ss', 'kv', 'me', 'tl'] },
    { question: '南苏丹是哪年独立的？', answer: '2011', options: ['2011', '2010', '2012', '2008'] },
    { question: '哪个国家的国旗变化最多？', answer: 'af', options: ['af', 'ir', 'iq', 'ly'] },
    { question: '联合国旗帜是什么颜色？', answer: '蓝白', options: ['蓝白', '白蓝', '蓝金', '白金'] },
  ],
];

export function getTriviaLevel(levelId: number): TriviaLevel | undefined {
  if (levelId < 1 || levelId > triviaQuestions.length) {
    return undefined;
  }
  return {
    id: levelId,
    name: `第 ${levelId} 关`,
    questions: triviaQuestions[levelId - 1],
    lives: 3
  };
}

export function getTotalTriviaLevels(): number {
  return triviaQuestions.length;
}



