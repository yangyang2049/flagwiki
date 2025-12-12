// 国旗礼仪与规范知识数据

export interface EtiquetteSection {
   title: string;
   titleEN: string;
   content: string;
   contentEN: string;
}

export const flagEtiquetteContent: EtiquetteSection[] = [
   {
      title: '升旗流程',
      titleEN: 'Flag Raising Process',
      content: `升旗仪式是展示国旗的重要场合，需要遵循严格的流程：

1. 准备阶段
   - 检查国旗是否完好无损，无破损、褪色
   - 确保旗杆和升旗设备正常
   - 升旗人员应着装整齐，保持庄重

2. 升旗过程
   - 升旗时，国旗应缓缓上升，不得过快或过慢
   - 升旗速度应与国歌节奏相匹配
   - 国旗升至旗杆顶端时，应确保完全展开

3. 降旗流程
   - 降旗时应缓慢下降，不得让国旗触地
   - 降旗后应整齐折叠，妥善保管
   - 雨天或恶劣天气时，应及时降旗保护`,
      contentEN: `Flag raising ceremonies are important occasions for displaying the national flag and must follow strict procedures:

1. Preparation Phase
   - Check that the flag is intact, with no damage or fading
   - Ensure the flagpole and raising equipment are functioning properly
   - Flag raisers should be properly dressed and maintain dignity

2. Raising Process
   - The flag should rise slowly, neither too fast nor too slow
   - The raising speed should match the rhythm of the national anthem
   - When the flag reaches the top, ensure it is fully unfurled

3. Lowering Process
   - Lower the flag slowly, ensuring it does not touch the ground
   - After lowering, fold it neatly and store it properly
   - Lower the flag promptly during rain or severe weather`
   },
   {
      title: '悬挂顺序',
      titleEN: 'Display Order',
      content: `在国际场合，多面旗帜同时悬挂时，需要遵循严格的顺序规则：

1. 主旗位置
   - 主旗（通常是主办国或东道国国旗）应位于最显眼的位置
   - 在横向排列时，主旗位于最左侧（面向观众）
   - 在纵向排列时，主旗位于最高处

2. 多国旗帜排列
   - 按国家名称的字母顺序排列（使用主办国官方语言）
   - 或按国家名称的笔画顺序排列（中文环境）
   - 所有旗帜应保持相同高度和大小

3. 国旗与其他旗帜
   - 国旗应高于其他旗帜（如组织旗帜、企业旗帜）
   - 国旗与其他旗帜同时悬挂时，国旗位于右侧或上方
   - 不得将国旗与其他旗帜交叉悬挂`,
      contentEN: `In international settings, when multiple flags are displayed simultaneously, strict ordering rules must be followed:

1. Main Flag Position
   - The main flag (usually the host country's flag) should be in the most prominent position
   - In horizontal arrangements, the main flag is on the far left (facing the audience)
   - In vertical arrangements, the main flag is at the highest position

2. Multiple National Flags Arrangement
   - Arrange in alphabetical order of country names (using the host country's official language)
   - Or by stroke order in Chinese environments
   - All flags should maintain the same height and size

3. National Flag with Other Flags
   - The national flag should be higher than other flags (such as organizational or corporate flags)
   - When displayed with other flags, the national flag should be on the right or above
   - Do not cross the national flag with other flags`
   },
   {
      title: '悬挂方式',
      titleEN: 'Display Methods',
      content: `国旗的悬挂方式有多种，需要根据场合选择合适的方式：

1. 标准悬挂
   - 国旗应完全展开，不得折叠或遮挡
   - 旗面应保持平整，无皱褶
   - 国旗不得倒挂（除非表示紧急情况）

2. 半旗悬挂
   - 用于哀悼场合，如国家领导人逝世、重大灾难等
   - 先将国旗升至旗杆顶端，然后降至旗杆高度的1/3处
   - 降旗时，先将国旗升至顶端，再降下

3. 交叉悬挂
   - 在国际会议等场合，可将多国国旗交叉悬挂
   - 主旗应位于交叉点的中心位置
   - 所有旗帜应保持相同的倾斜角度`,
      contentEN: `There are various ways to display the national flag, and the appropriate method should be chosen based on the occasion:

1. Standard Display
   - The flag should be fully unfurled, not folded or obscured
   - The flag surface should remain flat, without wrinkles
   - The flag must not be displayed upside down (unless indicating an emergency)

2. Half-Mast Display
   - Used for mourning occasions, such as the death of national leaders or major disasters
   - First raise the flag to the top, then lower it to one-third of the pole height
   - When lowering, first raise to the top, then lower

3. Crossed Display
   - At international conferences and similar occasions, multiple national flags may be displayed crossed
   - The main flag should be at the center of the crossing point
   - All flags should maintain the same angle of inclination`
   },
   {
      title: '使用场合',
      titleEN: 'Usage Occasions',
      content: `国旗的使用场合有严格规定，需要遵守相关法律法规：

1. 正式场合
   - 国家庆典、国际会议、体育赛事等正式场合
   - 政府机构、学校、重要建筑物等场所
   - 外交活动、国事访问等国际交往场合

2. 禁止使用
   - 不得将国旗用于商业广告
   - 不得将国旗用作装饰品或商品包装
   - 不得在私人场合随意悬挂国旗

3. 特殊规定
   - 夜间悬挂国旗应配备照明设备
   - 恶劣天气时应及时降旗保护
   - 破损、褪色的国旗应及时更换`,
      contentEN: `The use of the national flag has strict regulations and must comply with relevant laws:

1. Formal Occasions
   - National celebrations, international conferences, sports events, and other formal occasions
   - Government institutions, schools, important buildings, and other venues
   - Diplomatic activities, state visits, and other international exchanges

2. Prohibited Uses
   - The flag must not be used for commercial advertising
   - The flag must not be used as decoration or product packaging
   - The flag must not be displayed casually in private settings

3. Special Regulations
   - Flags displayed at night should be equipped with lighting
   - Flags should be lowered promptly during severe weather
   - Damaged or faded flags should be replaced promptly`
   },
   {
      title: '礼仪规范',
      titleEN: 'Etiquette Standards',
      content: `在国旗使用过程中，需要遵守以下礼仪规范：

1. 尊重国旗
   - 面对国旗时应保持肃立，脱帽致敬
   - 不得对国旗做出不敬行为
   - 升国旗、奏国歌时，应停止一切活动

2. 保护国旗
   - 不得让国旗触地或沾染污物
   - 不得在国旗上涂写、刻画或附加任何标记
   - 破损的国旗应妥善处理，不得随意丢弃

3. 国际礼仪
   - 在外国访问时，应尊重当地国旗
   - 多国国旗同时悬挂时，应平等对待所有国旗
   - 不得将本国国旗置于明显高于他国国旗的位置（除非是主办国）`,
      contentEN: `When using the national flag, the following etiquette standards must be observed:

1. Respect the Flag
   - Stand at attention and remove hats when facing the flag
   - Do not show disrespect to the flag
   - Stop all activities during flag raising and national anthem playing

2. Protect the Flag
   - Do not let the flag touch the ground or become soiled
   - Do not write, draw, or attach any marks on the flag
   - Damaged flags should be properly disposed of, not discarded casually

3. International Etiquette
   - When visiting foreign countries, respect the local flag
   - When multiple flags are displayed, treat all flags equally
   - Do not place your country's flag significantly higher than others (unless you are the host)`
   },
   {
      title: '常见错误',
      titleEN: 'Common Mistakes',
      content: `在使用国旗时，应避免以下常见错误：

1. 悬挂错误
   - 国旗倒挂（除非表示紧急情况）
   - 国旗与其他旗帜高度不一致
   - 国旗破损、褪色仍继续使用

2. 使用错误
   - 将国旗用于商业目的
   - 在国旗上添加文字或图案
   - 随意丢弃或焚烧国旗

3. 礼仪错误
   - 升国旗时嬉戏打闹
   - 对国旗做出不敬手势
   - 在国旗前进行不当行为

正确使用国旗，不仅是对国家的尊重，也是个人素质的体现。`,
      contentEN: `When using the national flag, the following common mistakes should be avoided:

1. Display Errors
   - Displaying the flag upside down (unless indicating an emergency)
   - Inconsistent height with other flags
   - Continuing to use damaged or faded flags

2. Usage Errors
   - Using the flag for commercial purposes
   - Adding text or patterns to the flag
   - Discarding or burning the flag casually

3. Etiquette Errors
   - Playing or joking during flag raising
   - Making disrespectful gestures toward the flag
   - Engaging in inappropriate behavior in front of the flag

Proper use of the national flag is not only a sign of respect for the country but also a reflection of personal character.`
   }
];

export function getEtiquetteContent(): EtiquetteSection[] {
   return flagEtiquetteContent;
}

// 获取本地化的礼仪内容
export function getLocalizedEtiquetteContent(language: string): EtiquetteSection[] {
   const isEnglish = language === 'en' || (language.length > 3 && language.substring(0, 3) === 'en-');
   return flagEtiquetteContent.map((section): EtiquetteSection => ({
      title: isEnglish ? section.titleEN : section.title,
      titleEN: section.titleEN,
      content: isEnglish ? section.contentEN : section.content,
      contentEN: section.contentEN
   }));
}


