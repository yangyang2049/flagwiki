# 变更日志

## [1.0.5] - 2025-12-08

### 代码审查 (Code Review)
- **全面代码审查**：重新进行了完整的代码审查和评测
  - 创建了 `CODE_REVIEW_2025-12-08.md` 完整审查报告
  - 审查范围：所有页面组件、工具类、数据管理和配置文件
  - 发现 8 个 Bug（高:2 中:4 低:2）
  - 发现 12 个优化建议（中:7 低:5）
  - 发现 3 个未完成功能（中:2 低:1）
  - 发现 10 个不一致性问题（低优先级）
  - 代码质量评分：3.5/5.0
  - 重点关注：定时器管理、资源清理、代码一致性

## [1.0.4] - 2025-12-08

### 新增功能 (Added)
- **州旗详情页朗读和分享功能**：为州旗详情页添加了朗读和分享功能
  - 在导航栏添加了朗读和分享按钮（参考国际组织详情页的设计）
  - 实现了 `onReadClick()` 方法，支持朗读州旗信息
  - 实现了 `onShareClick()` 方法，支持分享州旗信息到其他应用
  - 添加了 `getReadContent()` 方法，生成朗读内容
  - 添加了 `buildShareText()` 方法，生成分享文本
  - 朗读内容包括：州名、所属国家、首府、地区等信息
  - 分享内容包括：州名、所属国家、首府、地区等信息

### 修复 (Fixed)
- **编译错误修复**：修复了 ArkTS 编译错误
  - 修复了 `GameProgressManager.ets` 中 `throw` 语句的类型问题
  - 修复了 `ScreenshotManager.ets` 中 `throw` 语句的类型问题
  - ArkTS 要求 `throw` 必须是 `Error` 类型，已添加类型检查和转换

## [1.0.3] - 2025-12-08

### 代码审查 (Code Review)
- **全面代码审查**：完成了对整个项目的全面代码审查，生成了详细的审查报告
  - 创建了 `CODE_REVIEW_2025-12-08_FULL.md` 完整审查报告
  - 审查范围：所有页面组件、工具类、数据管理和配置文件
  - 发现 6 个 Bug（高:2 中:3 低:1）
  - 发现 15 个优化建议（中:8 低:7）
  - 发现 4 个未完成功能（中:3 低:1）
  - 发现 12 个不一致性问题（低优先级）
  - 提供了详细的修复建议和优先级分类
  - 代码质量评分：3.3/5

### 修复 (Fixed) - Bug 修复
- **FlagDetailPage doSaveFlag 缺少国际组织支持**：修复了保存国际组织旗帜时抛出错误的问题
  - `doSaveFlag()` 方法现在同时支持国家和国际组织
  - 修复后可以正常保存国际组织旗帜到相册

- **SaveFlagDialog 自动关闭时未释放 PixelMap**：修复了对话框自动关闭时 PixelMap 未释放的问题
  - 在 `handleClose()` 中确保调用 `onClose` 回调释放 PixelMap
  - 避免长时间使用导致的内存泄漏

- **MemoryPlayPage 定时器可能重复启动**：修复了定时器重复启动的问题
  - 在 `startTimer()` 中添加了检查，防止重复启动
  - 避免定时器重复执行导致的时间倒计时异常

- **GameProgressManager 初始化竞态条件**：修复了初始化失败后无法重试的问题
  - 在 `doInit` 失败时重置 `initPromise`，允许后续重试
  - 提升了初始化的健壮性

- **FavoritesManager 缺少错误重试机制**：改进了错误处理和重试逻辑
  - 在 `isFavorite()` 中添加了更好的错误处理和日志记录
  - 初始化失败后允许重试，提升用户体验

- **ScreenshotManager 文件描述符可能泄漏**：修复了文件描述符可能未正确关闭的问题
  - 使用更安全的资源管理模式，确保在所有情况下都能正确关闭文件描述符
  - 在写入成功后立即关闭，写入失败时也在 catch 中关闭
  - 避免大量保存操作导致文件描述符耗尽

### 优化 (Optimizations)
- **创建 PreferencesManager 减少重复初始化**：创建了统一的 Preferences 管理器
  - 新增 `PreferencesManager.ets` 工具类，提供统一的 Preferences 管理
  - 使用 Map 缓存已创建的 Preferences 实例，避免重复初始化
  - 更新了 `EntryAbility`、`ProfilePage` 和 `Index` 使用 PreferencesManager
  - 减少了 Preferences 的重复初始化，提升了性能和代码一致性

- **优化内存使用**：优化了 PixelMap 释放和大数组查找性能
  - 在 `FlagDetailPage.aboutToDisappear()` 中添加 PixelMap 释放，确保页面销毁时释放资源
  - 在 `onDownloadClick()` 中添加对话框关闭检查，避免重复创建对话框
  - 优化 `countryData.ets` 的查找性能：使用 Map 缓存替代数组查找（从 O(n) 优化到 O(1)）
  - 优化 `getCountryByCode()` 和 `getInternationalOrgByCode()` 的查找性能
  - 确保所有 PixelMap 在使用后正确释放，避免内存泄漏

### 修复 (Fixed)
- **ProfilePage 进度读取不一致**：修复了"我的"页面游戏进度显示始终为默认值1的问题
  - ProfilePage 现在使用 GameProgressManager 统一读取进度，而不是从错误的 preferences 文件读取
  - 修复后游戏进度能正确显示实际解锁的关卡数

- **FavoritesManager 初始化时序问题**：在 EntryAbility 中统一初始化收藏管理器和游戏进度管理器
  - 避免了在未初始化时调用导致的静默失败问题
  - 确保应用启动时所有管理器都已正确初始化

- **FlagDetailPage 内存泄漏风险**：修复了下载国旗时可能的内存泄漏
  - 在创建新的 PixelMap 之前先释放旧的 PixelMap
  - 避免用户多次点击下载导致的内存累积

- **TopicData 不存在的国家代码**：移除了北欧旗帜专题中不存在的国家代码
  - 移除了 'fo' (法罗群岛) 和 'ax' (奥兰群岛)，这些代码在 countryData 中不存在
  - 修复后专题详情页不再显示空白旗帜

- **PaintPlayPage 州旗图片路径**：修复了涂鸦游戏完成页面的州旗图片路径错误
  - LevelCompleteView 现在使用 getFlagImagePath() 方法获取正确的图片路径
  - 美国州旗正确使用 state_flags/us/ 目录

- **MemoryPlayPage timerId 类型**：修复了定时器 ID 类型不匹配的问题
  - 将 timerId 类型从 `number` 改为 `number | undefined`
  - 使用 `undefined` 替代 `-1` 作为未初始化状态

- **我的收藏入口无效**：修复了"我的"页面"我的收藏"菜单项点击无响应的问题
  - 添加了跳转到 FavoritesPage 的路由逻辑

- **下载图标深色模式不可见**：修复了下载图标在深色模式下不可见的问题
  - 创建了 `dark/media/icon_download.svg`，使用白色（#FFFFFF）描边

- **州旗详情页添加收藏和下载按钮**：优化了州旗详情页的用户体验
  - 在页面底部添加了收藏和下载按钮，与国旗详情页保持一致
  - 移除了顶部标题栏的下载按钮，简化界面
  - 收藏的州旗可以在"我的收藏"页面查看和跳转
  - 更新了 FavoritesPage 以支持州旗类型的收藏展示和导航

### 删除 (Removed)
- **清理财会相关未使用文件**：删除了与国旗小百科主题无关的财会工具页面和相关文件
  - 删除了 tools/ 目录下的所有37个财会工具页面（个税计算、五险一金、增值税、发票等）
  - 删除了 knowledge/ 目录下的知识库页面（内容为财会知识，与国旗无关）
  - 删除了 profile/ 目录下的 CityEditPage 和 InvoiceInfoPage
  - 删除了 components/ 目录下的 AmountInput 和 PageSeparatorSettings 组件
  - 删除了 utils/ 目录下的 cityData、invoiceInfoStore、knowledgeData、numberFormatter、pageSettings、provincesData 工具类
  - 更新了 main_pages.json，移除了已删除页面的路由配置
  - 更新了 FavoritesPage，移除了对知识库的依赖

## [1.0.2] - 2025-12-08

### 新增 (Added)
- **国旗涂鸦功能**：新增第三个Tab"涂鸦"，从 Flutter 项目移植国旗涂鸦游戏
  - `PaintGameData.ets` - 涂鸦游戏数据配置，包含国旗颜色信息和关卡配置
  - `PaintHomePage.ets` - 涂鸦首页，展示世界和各国州旗分类
  - `PaintPlayPage.ets` - 涂鸦游戏页面，使用 Web 组件加载 HTML 游戏
  - `paint_game.html` - HTML5 涂鸦游戏，支持颜色选择和区域填充
  - 支持分类：世界（20关）、美国、德国、意大利、巴西
  - 直接进入最新关卡，无需关卡选择页面
  - 每关包含3个国旗涂鸦任务
  - 支持提示功能（显示正确国旗参考）
  - 关卡进度自动保存

### 变更 (Changed)
- 更新 `Index.ets`：底部导航栏从4个Tab增加到5个Tab（首页、画廊、涂鸦、探索、我的）
- 更新 `GameProgressManager.ets`：新增涂鸦游戏类型枚举（PAINT_WORLD、PAINT_US等）
- 新增图标资源：`icon_tab_paint.svg`、`icon_tab_paint_selected.svg`、`icon_back.svg`、`icon_hint.svg`

## [1.0.1] - 2025-12-08

### 新增 (Added)
- **本周国旗功能**：首页新增"本周国旗"模块
  - `WeeklyFlagData.ets` - 每周国旗数据配置，包含最近10周的国庆日国旗
  - 根据当前周数自动展示对应国庆日的国家国旗
  - 展示国家名称、国庆日日期和描述
  - 点击可跳转至国旗详情页

## [1.0.0] - 2024-12-08

### 新增 (Added)
- **知识问答功能**：从 Flutter 项目移植知识问答游戏
  - `TriviaLevels.ets` - 关卡配置和问题数据（10关，每关10题）
  - `TriviaLevelsPage.ets` - 关卡选择页面
  - `TriviaPlayPage.ets` - 答题游戏页面
  - 问题类型涵盖国旗形状、颜色、图案、历史等趣味知识
  - 支持生命值系统、进度追踪、结果展示

- **专题功能**：新增国旗专题分类浏览
  - `TopicData.ets` - 专题数据配置
  - `TopicListPage.ets` - 专题列表页面
  - `TopicDetailPage.ets` - 专题详情页面（展示该专题下的所有国旗）
  - 内置专题：北欧旗帜、三色旗、泛阿拉伯旗帜、泛非洲旗帜、国旗上的动物
  - 首页添加专题推荐区域（横向滚动卡片）

### 重大变更 (Breaking Changes)
- **应用转型为国旗小百科**：将财会工具箱应用完全改造为国旗小百科应用
  - 更新应用名称为"国旗小百科"
  - 更新应用描述为"探索世界各国国旗的奥秘"
  - 更新底部导航栏：首页、画廊、探索、我的
  - 创建新的 GalleryPage（画廊页面）和 ExplorePage（探索页面）
  - 重写 HomePage 为国旗主题内容，包含：
    - 欢迎卡片（国旗小百科主题）
    - 快捷入口（全部国旗、按洲分类、国旗猜猜、收藏夹）
    - 热门国旗列表（中国、美国、日本、英国、法国）
    - 趣味小知识（10条国旗趣味知识）
  - 精简 ProfilePage，移除财会相关设置
  - 保留原有的颜色资源、工具类和应用结构

### 新增 (Added)
- **国旗画廊功能**：实现完整的国旗画廊页面
  - 从 flagame 项目复制了 195 个国家的国旗 SVG 文件到 `rawfile/flags/` 目录
  - 创建了 `countryData.ets` 数据文件，包含完整的国家信息（代码、中英文名称、首都、地区、人口、面积）
  - 实现洲际筛选功能：全部、亚洲、欧洲、非洲、美洲、大洋洲
  - 国旗网格展示（3列布局）
  - 点击国旗显示详情对话框，包含：国家名称、国旗大图、首都、地区、人口、面积
  - 人口和面积自动格式化显示（亿/万）

- **新增标签页图标**：使用 IconPark 图标包更新底部导航图标
  - 首页：home-two 图标
  - 画廊：picture-one 图标
  - 探索：compass-one 图标
  - 我的：user 图标
  - 每个图标都有普通（灰色 #8E8E93）和选中（蓝色 #1677FF + 浅蓝填充）两个版本
  - 同时创建了深色模式版本（普通白色，选中蓝色 + 深蓝填充）

---
