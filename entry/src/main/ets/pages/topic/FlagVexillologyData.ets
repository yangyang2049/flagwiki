// 旗帜学（国旗学）知识数据

export interface VexillologySection {
   title: string;
   titleEN: string;
   content: string;
   contentEN: string;
}

export const flagVexillologyContent: VexillologySection[] = [
   {
      title: '旗帜学概述',
      titleEN: 'Vexillology Overview',
      content: `旗帜学（Vexillology）是研究旗帜的学科，专门研究旗帜的设计、历史、象征意义和使用。

1. 学科定义
   - 旗帜学是研究旗帜的专门学科
   - 英文Vexillology来自拉丁文vexillum（旗帜）和希腊文logos（研究）
   - 1960年代由美国旗帜学家Whitney Smith创立

2. 研究范围
   - 国旗、州旗、市旗等各类旗帜
   - 旗帜的设计原则和美学
   - 旗帜的历史演变
   - 旗帜的象征意义
   - 旗帜的使用规范

3. 学科特点
   - 跨学科研究：涉及历史、设计、政治、文化等
   - 理论与实践结合
   - 国际性学科，全球学者共同研究
   - 既有学术研究，也有实践应用

4. 学科意义
   - 保护旗帜文化遗产
   - 促进旗帜设计的科学性
   - 传承旗帜文化传统
   - 增进国际理解与交流`,
      contentEN: `Vexillology is the study of flags, specifically researching flag design, history, symbolism, and usage.

1. Discipline Definition
   - Vexillology is a specialized discipline studying flags
   - The English term "Vexillology" comes from Latin "vexillum" (flag) and Greek "logos" (study)
   - Established in the 1960s by American vexillologist Whitney Smith

2. Research Scope
   - National flags, state flags, city flags, and various flag types
   - Flag design principles and aesthetics
   - Historical evolution of flags
   - Symbolic meanings of flags
   - Flag usage standards

3. Discipline Characteristics
   - Interdisciplinary research: involving history, design, politics, culture, etc.
   - Combining theory and practice
   - International discipline studied by scholars worldwide
   - Both academic research and practical applications

4. Discipline Significance
   - Preserving flag cultural heritage
   - Promoting scientific flag design
   - Inheriting flag cultural traditions
   - Enhancing international understanding and exchange`
   },
   {
      title: '旗帜分类',
      titleEN: 'Flag Classification',
      content: `旗帜学将旗帜按照不同标准进行分类：

1. 按用途分类
   - 国旗：代表国家的旗帜
   - 州旗/省旗：代表行政区域的旗帜
   - 市旗：代表城市的旗帜
   - 军旗：军队使用的旗帜
   - 组织旗：国际组织、企业等的旗帜

2. 按设计分类
   - 纯色旗：单一颜色的旗帜
   - 条纹旗：由条纹组成的旗帜（如三色旗）
   - 十字旗：带有十字图案的旗帜
   - 星条旗：带有星星和条纹的旗帜
   - 徽章旗：带有徽章或图案的旗帜

3. 按图案分类
   - 几何图案：圆形、三角形、方形等
   - 自然图案：太阳、月亮、星星、动物等
   - 文字图案：带有文字的旗帜
   - 抽象图案：象征性图案

4. 按历史分类
   - 传统旗帜：历史悠久、设计稳定
   - 现代旗帜：20世纪后设计的旗帜
   - 历史旗帜：已不再使用的旗帜
   - 临时旗帜：特殊场合使用的旗帜`,
      contentEN: `Vexillology classifies flags according to different standards:

1. By Purpose
   - National flags: Representing countries
   - State/Provincial flags: Representing administrative regions
   - City flags: Representing cities
   - Military flags: Used by armed forces
   - Organizational flags: International organizations, corporations, etc.

2. By Design
   - Solid color flags: Single color flags
   - Striped flags: Flags composed of stripes (such as tricolor flags)
   - Cross flags: Flags with cross patterns
   - Star and stripe flags: Flags with stars and stripes
   - Emblem flags: Flags with emblems or patterns

3. By Pattern
   - Geometric patterns: Circles, triangles, squares, etc.
   - Natural patterns: Sun, moon, stars, animals, etc.
   - Text patterns: Flags with text
   - Abstract patterns: Symbolic patterns

4. By History
   - Traditional flags: Long history, stable design
   - Modern flags: Designed after the 20th century
   - Historical flags: No longer in use
   - Temporary flags: Used for special occasions`
   },
   {
      title: '设计原则',
      titleEN: 'Design Principles',
      content: `旗帜设计遵循一定的原则和规范：

1. 简洁性原则
   - 设计应简单明了，易于识别
   - 避免过于复杂的图案
   - 远距离也能清晰辨认
   - 儿童能够绘制

2. 象征性原则
   - 颜色具有象征意义
   - 图案代表特定含义
   - 整体设计体现国家/地区特色
   - 传达文化价值观

3. 色彩原则
   - 使用标准颜色（如Pantone色卡）
   - 颜色对比鲜明，易于区分
   - 避免使用过多颜色（通常3-5种）
   - 考虑不同光照条件下的效果

4. 比例原则
   - 遵循标准的宽高比（如2:3、1:2）
   - 图案位置和大小协调
   - 保持视觉平衡
   - 考虑不同尺寸下的显示效果

5. 独特性原则
   - 与其他旗帜有明显区别
   - 避免与已有旗帜过于相似
   - 体现独特性
   - 避免混淆`,
      contentEN: `Flag design follows certain principles and standards:

1. Simplicity Principle
   - Design should be simple and clear, easy to recognize
   - Avoid overly complex patterns
   - Clearly recognizable from a distance
   - Can be drawn by children

2. Symbolism Principle
   - Colors have symbolic meanings
   - Patterns represent specific meanings
   - Overall design reflects national/regional characteristics
   - Conveys cultural values

3. Color Principle
   - Use standard colors (such as Pantone color chart)
   - Colors should be distinct and easily distinguishable
   - Avoid using too many colors (typically 3-5)
   - Consider effects under different lighting conditions

4. Proportion Principle
   - Follow standard aspect ratios (such as 2:3, 1:2)
   - Pattern position and size should be coordinated
   - Maintain visual balance
   - Consider display effects at different sizes

5. Uniqueness Principle
   - Clearly distinct from other flags
   - Avoid being too similar to existing flags
   - Reflect uniqueness
   - Avoid confusion`
   },
   {
      title: '历史演变',
      titleEN: 'Historical Evolution',
      content: `旗帜的历史演变反映了人类文明的发展：

1. 古代旗帜
   - 最早的旗帜可追溯到古代中国和古埃及
   - 主要用于军事和标识
   - 设计简单，多为纯色或简单图案
   - 材料以丝绸、布料为主

2. 中世纪旗帜
   - 欧洲骑士使用纹章旗帜
   - 十字军东征促进了旗帜发展
   - 旗帜成为身份和地位的象征
   - 设计更加复杂和精美

3. 近代旗帜
   - 18-19世纪民族国家兴起
   - 国旗成为国家象征
   - 三色旗等经典设计出现
   - 旗帜设计趋于标准化

4. 现代旗帜
   - 20世纪后新国家大量出现
   - 旗帜设计更加多样化
   - 注重象征意义和文化内涵
   - 使用现代材料和工艺

5. 当代发展
   - 数字化设计工具的应用
   - 环保材料的使用
   - 旗帜文化的全球化
   - 在线旗帜数据库的建立`,
      contentEN: `The historical evolution of flags reflects the development of human civilization:

1. Ancient Flags
   - Earliest flags date back to ancient China and Egypt
   - Mainly used for military and identification purposes
   - Simple designs, mostly solid colors or simple patterns
   - Materials primarily silk and fabric

2. Medieval Flags
   - European knights used heraldic flags
   - Crusades promoted flag development
   - Flags became symbols of identity and status
   - Designs became more complex and exquisite

3. Modern Flags
   - Rise of nation-states in the 18th-19th centuries
   - National flags became national symbols
   - Classic designs like tricolor flags emerged
   - Flag design became standardized

4. Contemporary Flags
   - Many new nations emerged after the 20th century
   - Flag designs became more diverse
   - Emphasis on symbolic meaning and cultural connotation
   - Use of modern materials and techniques

5. Current Development
   - Application of digital design tools
   - Use of eco-friendly materials
   - Globalization of flag culture
   - Establishment of online flag databases`
   },
   {
      title: '研究方法',
      titleEN: 'Research Methods',
      content: `旗帜学研究采用多种方法：

1. 历史研究法
   - 查阅历史文献和档案
   - 研究旗帜的演变过程
   - 分析历史背景和原因
   - 考证旗帜的起源

2. 比较研究法
   - 比较不同旗帜的设计
   - 分析设计元素的异同
   - 研究设计的影响和传承
   - 发现设计规律

3. 实地调查法
   - 实地观察旗帜的使用
   - 拍摄和记录旗帜
   - 调查旗帜的制作工艺
   - 了解旗帜的使用规范

4. 文献研究法
   - 收集旗帜相关文献
   - 研究旗帜学理论
   - 分析设计案例
   - 总结设计经验

5. 数字化方法
   - 建立旗帜数据库
   - 使用图像处理技术
   - 进行数据统计分析
   - 利用网络资源研究`,
      contentEN: `Vexillology research employs various methods:

1. Historical Research Method
   - Review historical documents and archives
   - Study flag evolution processes
   - Analyze historical backgrounds and reasons
   - Verify flag origins

2. Comparative Research Method
   - Compare different flag designs
   - Analyze similarities and differences in design elements
   - Study design influences and inheritance
   - Discover design patterns

3. Field Survey Method
   - Observe flag usage in person
   - Photograph and document flags
   - Investigate flag manufacturing techniques
   - Understand flag usage standards

4. Literature Research Method
   - Collect flag-related literature
   - Study vexillology theory
   - Analyze design cases
   - Summarize design experience

5. Digital Methods
   - Establish flag databases
   - Use image processing technology
   - Conduct statistical data analysis
   - Utilize online resources for research`
   },
   {
      title: '著名学者',
      titleEN: 'Famous Scholars',
      content: `旗帜学领域有许多著名学者：

1. Whitney Smith（1934-2016）
   - 美国旗帜学家，旗帜学学科创始人
   - 1961年创立旗帜学（Vexillology）一词
   - 1962年创办《旗帜学》杂志
   - 建立了系统的旗帜学理论

2. 其他著名学者
   - 欧洲：多位学者研究欧洲旗帜传统
   - 亚洲：研究亚洲旗帜文化特色
   - 非洲：研究非洲旗帜设计特点
   - 拉美：研究拉美旗帜历史演变

3. 国际组织
   - 国际旗帜学协会（FIAV）
   - 各国旗帜学学会
   - 旗帜博物馆和研究机构
   - 在线旗帜学社区

4. 学术贡献
   - 建立旗帜分类体系
   - 制定旗帜设计规范
   - 保护旗帜文化遗产
   - 促进国际交流合作

5. 当代发展
   - 年轻学者不断加入
   - 研究方法不断创新
   - 数字化研究工具应用
   - 跨学科研究增多`,
      contentEN: `There are many famous scholars in the field of vexillology:

1. Whitney Smith (1934-2016)
   - American vexillologist, founder of the discipline
   - Coined the term "Vexillology" in 1961
   - Founded "The Flag Bulletin" magazine in 1962
   - Established systematic vexillology theory

2. Other Famous Scholars
   - Europe: Multiple scholars studying European flag traditions
   - Asia: Researching Asian flag cultural characteristics
   - Africa: Studying African flag design features
   - Latin America: Researching Latin American flag historical evolution

3. International Organizations
   - International Federation of Vexillological Associations (FIAV)
   - National vexillological societies
   - Flag museums and research institutions
   - Online vexillology communities

4. Academic Contributions
   - Established flag classification systems
   - Developed flag design standards
   - Protected flag cultural heritage
   - Promoted international exchange and cooperation

5. Contemporary Development
   - Young scholars continuously joining
   - Research methods constantly innovating
   - Application of digital research tools
   - Increase in interdisciplinary research`
   },
   {
      title: '旗帜象征',
      titleEN: 'Flag Symbolism',
      content: `旗帜的象征意义是旗帜学的重要研究内容：

1. 颜色象征
   - 红色：革命、勇气、牺牲、热情
   - 蓝色：和平、自由、忠诚、海洋
   - 白色：纯洁、和平、正义、光明
   - 绿色：自然、希望、农业、生命
   - 黄色/金色：财富、智慧、太阳、荣耀
   - 黑色：力量、决心、哀悼、土地

2. 图案象征
   - 星星：统一、希望、指引
   - 月亮：伊斯兰文化、新生
   - 太阳：光明、力量、生命
   - 十字：基督教、方向、保护
   - 动物：国家特色、力量、智慧
   - 植物：自然、生命、繁荣

3. 设计象征
   - 条纹：统一、平等、团结
   - 圆形：完整、和谐、永恒
   - 三角形：稳定、力量、方向
   - 对称：平衡、秩序、稳定

4. 文化象征
   - 体现民族文化特色
   - 传承历史传统
   - 表达价值观念
   - 展现国家形象

5. 政治象征
   - 代表国家主权
   - 象征民族独立
   - 体现政治制度
   - 表达政治理念`,
      contentEN: `The symbolic meaning of flags is an important research area in vexillology:

1. Color Symbolism
   - Red: Revolution, courage, sacrifice, passion
   - Blue: Peace, freedom, loyalty, ocean
   - White: Purity, peace, justice, light
   - Green: Nature, hope, agriculture, life
   - Yellow/Gold: Wealth, wisdom, sun, glory
   - Black: Strength, determination, mourning, land

2. Pattern Symbolism
   - Stars: Unity, hope, guidance
   - Moon: Islamic culture, new life
   - Sun: Light, power, life
   - Cross: Christianity, direction, protection
   - Animals: National characteristics, strength, wisdom
   - Plants: Nature, life, prosperity

3. Design Symbolism
   - Stripes: Unity, equality, solidarity
   - Circles: Completeness, harmony, eternity
   - Triangles: Stability, strength, direction
   - Symmetry: Balance, order, stability

4. Cultural Symbolism
   - Reflects national cultural characteristics
   - Inherits historical traditions
   - Expresses values
   - Shows national image

5. Political Symbolism
   - Represents national sovereignty
   - Symbolizes national independence
   - Reflects political systems
   - Expresses political ideals`
   }
];

export function getVexillologyContent(): VexillologySection[] {
   return flagVexillologyContent;
}

// 获取本地化的旗帜学内容
export function getLocalizedVexillologyContent(language: string): VexillologySection[] {
   const isEnglish = language === 'en' || (language.length > 3 && language.substring(0, 3) === 'en-');
   return flagVexillologyContent.map((section): VexillologySection => ({
      title: isEnglish ? section.titleEN : section.title,
      titleEN: section.titleEN,
      content: isEnglish ? section.contentEN : section.content,
      contentEN: section.contentEN
   }));
}





