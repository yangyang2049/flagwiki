// 国名 国旗 国徽 国歌专题知识数据

export interface CountrySymbolsSection {
  title: string;
  titleEN: string;
  content: string;
  contentEN: string;
}

export const countrySymbolsContent: CountrySymbolsSection[] = [
  {
    title: '国家象征概述',
    titleEN: 'National Symbols Overview',
    content: `国家象征是一个国家的重要标志，通常包括国名、国旗、国徽和国歌。这些象征代表着一个国家的历史、文化、价值观和民族精神。

1. 国家象征的意义
   - 体现国家主权和独立
   - 传承历史文化传统
   - 凝聚民族认同感
   - 展示国家形象

2. 四大国家象征
   - 国名：国家的正式名称
   - 国旗：国家的旗帜标志
   - 国徽：国家的徽章标志
   - 国歌：国家的音乐标志

3. 象征的法律地位
   - 大多数国家通过法律保护国家象征
   - 禁止侮辱、毁损国家象征
   - 规范国家象征的使用场合和方式

4. 国际影响
   - 国家象征在国际交往中发挥重要作用
   - 体现国家的国际地位和形象
   - 促进文化交流和理解`,
    contentEN: `National symbols are important emblems of a country, typically including the country name, flag, coat of arms, and anthem. These symbols represent a nation's history, culture, values, and national spirit.

1. Significance of National Symbols
   - Reflect national sovereignty and independence
   - Inherit historical and cultural traditions
   - Foster national identity
   - Showcase national image

2. Four Major National Symbols
   - Country Name: The official name of the country
   - Flag: The flag emblem of the country
   - Coat of Arms: The heraldic emblem of the country
   - Anthem: The musical emblem of the country

3. Legal Status of Symbols
   - Most countries protect national symbols through law
   - Prohibit insulting or damaging national symbols
   - Regulate the occasions and methods of using national symbols

4. International Impact
   - National symbols play an important role in international exchanges
   - Reflect the country's international status and image
   - Promote cultural exchange and understanding`
  },
  {
    title: '国名',
    titleEN: 'Country Name',
    content: `国名是一个国家的正式名称，通常有官方名称和常用名称之分。

1. 国名的类型
   - 官方全称：如"中华人民共和国"、"美利坚合众国"
   - 简称：如"中国"、"美国"
   - 英文名称：国际通用的英文名称
   - 历史名称：历史上的不同称呼

2. 国名的特点
   - 体现国家性质：如"共和国"、"王国"、"联邦"
   - 反映地理特征：如"岛国"、"内陆国"
   - 承载历史记忆：如"联合"、"民主"

3. 国名的使用
   - 正式文件使用官方全称
   - 日常交流使用简称
   - 国际场合使用英文名称
   - 尊重各国的国名选择

4. 国名的变化
   - 政治体制变化可能导致国名改变
   - 国家合并或分裂会改变国名
   - 历史事件影响国名的演变`,
    contentEN: `A country name is the official name of a country, usually with official and common names.

1. Types of Country Names
   - Official Full Name: Such as "People's Republic of China", "United States of America"
   - Short Name: Such as "China", "United States"
   - English Name: Internationally recognized English name
   - Historical Names: Different names in history

2. Characteristics of Country Names
   - Reflect national nature: Such as "Republic", "Kingdom", "Federation"
   - Reflect geographical features: Such as "Island Nation", "Landlocked Country"
   - Carry historical memory: Such as "United", "Democratic"

3. Usage of Country Names
   - Official documents use official full names
   - Daily communication uses short names
   - International occasions use English names
   - Respect each country's choice of name

4. Changes in Country Names
   - Political system changes may lead to name changes
   - Country mergers or splits will change names
   - Historical events influence the evolution of names`
  },
  {
    title: '国旗',
    titleEN: 'National Flag',
    content: `国旗是一个国家最重要的视觉象征，代表国家的主权和尊严。

1. 国旗的设计
   - 颜色选择：通常有特定的象征意义
   - 图案设计：体现国家特色和文化
   - 比例规范：各国国旗有标准比例
   - 设计原则：简洁、醒目、易识别

2. 国旗的象征意义
   - 颜色象征：红色代表革命、蓝色代表海洋、绿色代表自然等
   - 图案象征：星星、月亮、太阳、动物等各有含义
   - 历史意义：反映国家的历史传统

3. 国旗的使用
   - 升挂场合：政府机构、学校、重要活动
   - 使用规范：不得倒挂、不得污损
   - 国际礼仪：尊重他国国旗
   - 降半旗：表示哀悼

4. 国旗的历史
   - 现代国旗起源于17-18世纪
   - 许多国旗设计有悠久历史
   - 部分国家国旗经历过多次变更
   - 国旗演变反映国家历史`,
    contentEN: `The national flag is the most important visual symbol of a country, representing national sovereignty and dignity.

1. Flag Design
   - Color Selection: Usually has specific symbolic meaning
   - Pattern Design: Reflects national characteristics and culture
   - Proportion Standards: Each country's flag has standard proportions
   - Design Principles: Simple, eye-catching, easily recognizable

2. Symbolic Meaning of Flags
   - Color Symbolism: Red represents revolution, blue represents ocean, green represents nature, etc.
   - Pattern Symbolism: Stars, moon, sun, animals, etc. have different meanings
   - Historical Significance: Reflects the country's historical traditions

3. Flag Usage
   - Occasions: Government institutions, schools, important events
   - Usage Standards: Cannot be hung upside down, cannot be defaced
   - International Etiquette: Respect other countries' flags
   - Half-mast: Sign of mourning

4. Flag History
   - Modern flags originated in the 17th-18th centuries
   - Many flag designs have a long history
   - Some countries' flags have changed multiple times
   - Flag evolution reflects national history`
  },
  {
    title: '国徽',
    titleEN: 'Coat of Arms',
    content: `国徽是一个国家的徽章标志，通常用于正式文件和重要场合。

1. 国徽的设计
   - 盾形徽章：欧洲传统设计
   - 圆形徽章：亚洲常见设计
   - 动物图案：狮子、鹰、龙等
   - 植物图案：橄榄枝、月桂等
   - 文字元素：国家格言、名称

2. 国徽的象征元素
   - 动物象征：力量、勇气、智慧
   - 植物象征：和平、繁荣、生命
   - 几何图案：秩序、稳定、团结
   - 历史元素：反映国家历史

3. 国徽的使用
   - 政府文件：正式文件使用国徽
   - 官方建筑：重要建筑悬挂国徽
   - 货币图案：部分国家货币使用国徽
   - 护照封面：许多国家护照使用国徽

4. 国徽的历史
   - 起源于中世纪的纹章学
   - 现代国徽设计更加简洁
   - 部分国家有多个版本的国徽
   - 国徽演变反映政治变化`,
    contentEN: `The coat of arms is the heraldic emblem of a country, usually used in official documents and important occasions.

1. Coat of Arms Design
   - Shield Emblem: Traditional European design
   - Circular Emblem: Common Asian design
   - Animal Patterns: Lions, eagles, dragons, etc.
   - Plant Patterns: Olive branches, laurel, etc.
   - Text Elements: National mottos, names

2. Symbolic Elements of Coat of Arms
   - Animal Symbolism: Strength, courage, wisdom
   - Plant Symbolism: Peace, prosperity, life
   - Geometric Patterns: Order, stability, unity
   - Historical Elements: Reflect national history

3. Usage of Coat of Arms
   - Government Documents: Official documents use coat of arms
   - Official Buildings: Important buildings display coat of arms
   - Currency Patterns: Some countries use coat of arms on currency
   - Passport Covers: Many countries use coat of arms on passports

4. History of Coat of Arms
   - Originated from medieval heraldry
   - Modern coat of arms designs are more concise
   - Some countries have multiple versions of coat of arms
   - Coat of arms evolution reflects political changes`
  },
  {
    title: '国歌',
    titleEN: 'National Anthem',
    content: `国歌是一个国家的音乐象征，在重要场合演奏，体现国家精神和民族情感。

1. 国歌的特点
   - 旋律庄严：体现国家尊严
   - 歌词深刻：表达国家理想
   - 易于传唱：便于民众学习
   - 情感共鸣：激发爱国情怀

2. 国歌的创作
   - 历史背景：反映创作时代背景
   - 作者信息：词曲作者和创作时间
   - 创作目的：纪念历史事件或表达理想
   - 音乐风格：各国国歌风格各异

3. 国歌的使用
   - 重要场合：国庆、体育赛事、外交活动
   - 演奏规范：完整演奏或演奏片段
   - 礼仪要求：起立、脱帽、肃立
   - 国际场合：尊重他国国歌

4. 国歌的历史
   - 现代国歌起源于18-19世纪
   - 许多国歌有悠久历史
   - 部分国家国歌经历过变更
   - 国歌演变反映国家发展`,
    contentEN: `The national anthem is the musical symbol of a country, played on important occasions, reflecting national spirit and national sentiment.

1. Characteristics of National Anthems
   - Solemn Melody: Reflects national dignity
   - Profound Lyrics: Expresses national ideals
   - Easy to Sing: Convenient for people to learn
   - Emotional Resonance: Inspires patriotic feelings

2. Creation of National Anthems
   - Historical Background: Reflects the era of creation
   - Author Information: Lyricist, composer, and creation time
   - Purpose of Creation: Commemorate historical events or express ideals
   - Musical Style: Different countries have different anthem styles

3. Usage of National Anthems
   - Important Occasions: National Day, sports events, diplomatic activities
   - Performance Standards: Full performance or excerpts
   - Etiquette Requirements: Stand, remove hats, stand solemnly
   - International Occasions: Respect other countries' anthems

4. History of National Anthems
   - Modern anthems originated in the 18th-19th centuries
   - Many anthems have a long history
   - Some countries' anthems have changed
   - Anthem evolution reflects national development`
  }
];

// 获取本地化的内容
export function getLocalizedCountrySymbolsContent(language: string): CountrySymbolsSection[] {
  const isEnglish = language === 'en' || (language.length > 3 && language.substring(0, 3) === 'en-');
  
  const result: CountrySymbolsSection[] = [];
  for (let i = 0; i < countrySymbolsContent.length; i++) {
    const section = countrySymbolsContent[i];
    result.push({
      title: isEnglish ? section.titleEN : section.title,
      titleEN: section.titleEN,
      content: isEnglish ? section.contentEN : section.content,
      contentEN: section.contentEN
    });
  }
  return result;
}

