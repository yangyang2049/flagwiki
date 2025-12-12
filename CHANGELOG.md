# 变更日志

## [未发布]

### 优化 (Optimization)
- **移除语言切换时的 Toast 提示**：在 ProfilePage 中切换语言时不再显示 toast 提示
  - **修改内容**：移除了 `saveLanguage()` 方法中的 `promptAction.showToast()` 调用
  - **效果**：切换语言时界面更加简洁，不会弹出提示消息
  - **注意**：错误情况下的 toast 提示仍然保留

### 重构 (Refactor)
- **重命名文件以避免混淆**：将 `pages/topic/FlagHistoryData.ets` 重命名为 `FiveStarRedFlagHistoryData.ets`
  - **原因**：避免与 `utils/FlagHistoryData.ets`（历史国旗数据工具）混淆
  - **修改内容**：
    - 创建新文件 `FiveStarRedFlagHistoryData.ets`（五星红旗历史知识数据）
    - 更新 `TopicDetailPage.ets` 中的导入路径
    - 删除旧文件 `FlagHistoryData.ets`
  - **效果**：文件名更加明确，避免了与历史国旗数据工具的混淆

### 审查 (Review)
- **重复文件和相似名称文件审查**：完成了对整个项目的重复文件和相似名称文件的全面审查
  - **审查结果**：
    - 发现 2 个完全重复的资源文件（`layered_image.json`），但属于 HarmonyOS 正常的资源层级结构
    - 发现 2 个同名但不同用途的文件（`FlagHistoryData.ets`），建议重命名以避免混淆
    - 发现 2 个测试文件（`List.test.ets`），属于正常的测试文件结构
    - 确认之前审查报告中提到的未使用文件（`CoatOfArmsDownloader.ets`、`CoatOfArmsDatabase.ets`、`download_anthems.py`）已被删除
  - **资源文件层级**：
    - `AppScope` 和 `entry` 下的同名资源文件是 HarmonyOS 的标准资源层级结构
    - `AppScope` 是应用级资源，`entry` 是模块级资源，模块级资源会覆盖应用级资源
    - 这是正常的设计模式，应该保留
  - **建议**：
    - **低优先级**：考虑重命名 `pages/topic/FlagHistoryData.ets` 为 `FlagHistoryContentData.ets` 或 `FiveStarRedFlagHistoryData.ets` 以避免与 `utils/FlagHistoryData.ets` 混淆
  - **详细报告**：见 `docs/DUPLICATE_FILES_REVIEW.md`

### 修复 (Fixed)
- **州旗页面完整本地化及界面优化**：完成了所有州旗相关页面的本地化和界面优化
  - **StateFlagCountryListPage（州旗国家列表页）**：
    - 添加 `@StorageLink('currentLanguage')` 监听语言变化
    - 新增 `getCountryName()` 方法：根据语言返回国家名称（countryName / countryNameCN）
    - 重构 `getStateCountText()` 方法：使用独立的本地化字符串资源
      - 不再使用动态拼接公式，改为为每个国家单独配置本地化字符串
      - 新增 11 组字符串资源（`state_count_jp` 到 `state_count_es`）
      - 中文示例：`47 个都道府县`、`50 个州`、`13 个省`、`17 个行政区`
      - 英文示例：`47 Prefectures`、`50 States`、`13 Provinces`、`17 Administrative Divisions`
      - 不同国家使用正确的行政区划名称：
        - 日本：Prefectures（都道府县）
        - 美国/德国/澳大利亚/巴西：States（州）
        - 加拿大：Provinces（省）
        - 韩国：Administrative Divisions（行政区）
        - 瑞士：Cantons（州）
        - 英国：Countries（地区）
        - 意大利：Regions（大区）
        - 西班牙：Autonomous Communities（自治区）
  - **StateFlagGalleryPage（州旗画廊页）**：
    - 添加 `@StorageLink('currentLanguage')` 监听语言变化
    - 新增本地化辅助方法：
      - `getCountryName()`：国家名称（countryName / countryNameCN）
      - `getStateName()`：州名称（name / nameCN）
      - `getTotalCountText()`：使用独立的本地化字符串资源
    - 本地化顶部区域：
      - 国家名称：`Australia` / `澳大利亚`
      - 总数文本：`Total 9 States` / `共 9 个州`
      - 使用 switch 语句根据国家代码获取对应的本地化字符串
      - 添加"Total"/"共"前缀
    - 本地化网格中所有州名称
    - **保留导航栏但隐藏标题**：使用空字符串 `.title('')` 保留返回按钮，但不显示标题文字
  - **StateFlagDetailPage（州旗详情页）**：
    - 改用 `AppStorage.get('currentLanguage')` 获取应用语言
    - 新增本地化辅助方法：
      - `getStateName()`：州名称（name / nameCN）
      - `getCapitalName()`：首府名称（capital / capitalCN）
      - `getRegionName()`：地区名称（region / regionCN）
      - `getCountryName()`：国家名称（countryName / countryNameCN）
    - 更新所有显示位置使用本地化方法：
      - 标题和州名称显示
      - 基本信息卡片（所属国家、首府、地区）
      - 朗读内容
      - 分享文本
      - 文件名生成
    - **保留导航栏但隐藏标题**：使用空字符串 `.title('')` 保留返回按钮和菜单，但不显示标题文字
  - **效果**：
    - 中文环境：显示 "美国"、"新南威尔士州"、"悉尼" 等中文名称
    - 英文环境：显示 "United States"、"New South Wales"、"Sydney" 等英文名称
    - 州数量格式正确适配语言（使用独立的本地化字符串）
    - 界面更简洁：保留导航栏功能（返回按钮、菜单），但不显示标题文字

- **英文环境下隐藏朗读按钮**：在英文环境下隐藏所有页面的朗读/阅读按钮
  - **原因**：朗读功能主要支持中文，在英文环境下可能无法正常工作或效果不佳
  - **修改的页面**：
    - `FlagDetailPage.ets` - 国旗详情页
    - `StateFlagDetailPage.ets` - 州旗详情页
    - `TopicDetailPage.ets` - 专题详情页
  - **实现方式**：在 `MenuBuilder()` 中添加语言判断
    ```typescript
    if (!LocalizationUtil.isEnglish(this.currentLanguage)) {
      // 只在中文环境下显示朗读按钮
      Image($r('app.media.icon_voice'))
        // ...
    }
    ```
  - **效果**：
    - 中文环境：显示朗读按钮和分享按钮
    - 英文环境：只显示分享按钮，隐藏朗读按钮
    - 界面更加简洁，避免用户尝试使用不支持的功能

- **应用语言初始化优化**：改进了应用首次安装时的语言检测和设置逻辑
  - **首次安装**：自动检测系统语言并设置为应用默认语言
    - 使用 `LocalizationUtil.getSystemLanguage()` 检测系统语言
    - 将检测到的语言保存到 preferences 作为初始偏好
    - 通过 `i18n.System.setAppPreferredLanguage()` 设置应用语言
    - 同步到 `AppStorage` 供全局访问
  - **后续启动**：使用用户保存的语言偏好设置
    - 检查 preferences 中是否存在 'language' 键
    - 如果存在，使用保存的语言偏好
    - 如果不存在（首次安装），检测并保存系统语言
  - **降级处理**：如果检测失败，默认使用中文
  - **效果**：
    - 英文系统用户首次安装后看到英文界面
    - 中文系统用户首次安装后看到中文界面
    - 用户手动切换语言后，应用记住用户的选择
    - 所有页面和组件都能正确响应语言设置

- **Connections 游戏主题本地化**：完成了 Connections 游戏中所有分组主题的完整本地化
  - **问题**：切换应用语言后，分组主题名称仍然显示中文，其他元素正常显示英文
  - **根本原因**：`getLocalizedTheme()` 使用 `resourceManager.getConfigurationSync()` 获取的是系统语言，而不是应用设置的语言
  - **修复内容**：
    - 创建独立的中英文主题名称映射表（`ThemeNamesCN` 和 `ThemeNamesEN`）
    - 修改 `getLocalizedTheme()` 函数，从 `AppStorage.get('currentLanguage')` 获取应用当前语言
    - 根据应用语言设置直接返回对应的主题名称映射
    - 添加 47 个主题的中英文字符串资源（保留在资源文件中以供未来使用）
  - **主题分类**：
    - 地理区域：亚洲、欧洲、美洲、非洲及各子区域（东亚、南亚、北非等）
    - 颜色分类：红色旗帜、绿色旗帜、蓝色旗帜、黄色旗帜
    - 文化分类：盎格鲁-撒克逊旗帜、斯拉夫旗帜、北欧旗帜、阿拉伯旗帜
    - 图案特征：太阳、新月和星星、动物、星星、树木或植物、王冠、武器等
    - 国家特征：岛国、内陆国家、最大国家、小国、社会主义国家
    - 设计特征：水平三色旗、垂直三色旗、对角条纹、双色旗帜、非矩形旗帜等
    - 河流国家：尼罗河国家、亚马逊河国家、湄公河国家、多瑙河国家
  - **效果**：Connections 游戏中的所有分组主题现在完全支持中英文，游戏体验更加国际化

- **全面本地化审查和修复**：逐页、逐组件、逐 toast 审查并修复所有硬编码的中文字符串
  - **FakeFlagPlayPage 本地化修复**：
    - 修复 "加载中..." → 使用 `app.string.loading`
    - 修复 "正确找出" → 使用 `app.string.correct_found`
    - 修复 "剩余生命" → 使用 `app.string.remaining_lives`
    - 修复 "返回关卡列表" → 使用 `app.string.back_to_levels`
  - **QuizPlayPage 本地化修复**：
    - 修复 "加载中..." → 使用 `app.string.loading`
    - 修复 "这是哪个国家的国旗？" → 使用 `app.string.which_country_flag`
    - 修复 "请选择正确的国旗" → 使用 `app.string.select_correct_flag`
  - **StateFlagGalleryPage 本地化修复**：
    - 添加 context 支持
    - 修复 "加载中..." → 使用 `app.string.loading`
    - 修复 "暂无数据" → 使用 `app.string.no_data`
    - 修复标题硬编码 → 使用本地化资源
  - **StateFlagCountryListPage 本地化修复**：
    - 添加 context 支持
    - 修复标题 "各国州旗" → 使用 `app.string.state_flags`
  - **FlagHistoryListPage 本地化修复**：
    - 添加 context 支持
    - 修复 "暂无历史数据" → 使用 `app.string.no_data`
    - 修复标题 "历史国旗" → 使用 `app.string.historical_flags`
  - **InputPlayPage 本地化修复**：
    - 修复 "加载中..." → 使用 `app.string.loading`
  - **TopicDetailPage 本地化修复**：
    - 修复 "专题详情" 硬编码 → 使用 `app.string.details`
  - **效果**：所有页面、组件和 toast 消息现在都完全支持中英文切换，没有硬编码的中文字符串

- **Connections 游戏主题本地化修复**：修复了 Connections 游戏中主题名称的英文本地化问题
  - **问题**：`getLocalizedTheme` 函数只返回中文翻译，在英文环境下无法正确显示英文主题名
  - **修复内容**：
    - 修改 `ConnectionsLevels.ets` 中的 `getLocalizedTheme` 函数，添加对英文环境的支持
    - 创建主题名到本地化资源键的映射（`ThemeResourceKeys`）
    - 函数现在接受 `context` 参数，根据系统语言自动返回对应的本地化字符串
    - 更新 `ConnectionsPlayPage.ets` 中调用 `getLocalizedTheme` 的地方，传入 `context` 参数
  - **效果**：Connections 游戏中的主题名称现在能够根据系统语言正确显示中英文，所有主题名称的单复数形式都已检查并确认为正确（如 "Flags with Weapons"、"Flags with Stars" 等）
- **Input 输入游戏 UI 优化**：改进了确认按钮的显示
  - 将确认按钮的文本从 "确认" / "Confirm" 改为勾号符号 "✓"
  - 增大字体大小（16 → 24）以适配符号显示
  - 效果：界面更简洁直观，符号化的设计更加国际通用

- **Trivia 知识问答游戏完整本地化**：实现了知识问答游戏的中英文双语支持
  - **问题内容本地化**：
    - 将 10 个关卡共 100 个问题全部本地化
    - 中文版本保持原有问题内容
    - 英文版本提供准确的英文翻译
  - **代码重构**：
    - 修改 `TriviaLevels.ets` 创建独立的中英文问题数据集（`triviaQuestionsCN` 和 `triviaQuestionsEN`）
    - `getTriviaLevel()` 函数现在接受 `context` 参数，根据系统语言自动返回对应语言的问题
    - 所有问题的答案选项也完全本地化
  - **UI文本本地化**：
    - "加载中..." 改为使用 `app.string.loading` 资源
    - 关卡名称统一显示为 "Level X"
  - **效果**：知识问答游戏现在完全支持中英文，包括所有问题、选项和答案，为国际用户提供完整的游戏体验

- **Gallery 标签页本地化**：完成了 GalleryPage 和 FlagDetailPage 的完整本地化
  - **添加的字符串资源**：
    - `save_failed_with_error`: "保存失败: %s" / "Save failed: %s"
    - `details`: "详情" / "Details"
    - `flag`: "旗帜" / "Flag"
    - `national_flag`: "国旗" / "National Flag"
    - `flag_default_description`: 默认国旗描述（中英文）
    - 朗读内容相关的字符串资源（also_known_as, headquarters_located, region_is, org_type_is, coverage_population_approx, website_colon, capital_is, region_belongs, population_colon, area_colon, flag_proportion_is, adopted_date_is 及其英文版本）
  - **本地化的内容**：
    - FlagDetailPage Toast 消息：截取图片失败、国旗图片已保存到相册、保存失败、下载失败、已停止朗读、开始朗读、朗读功能暂不可用、正在准备分享...、分享失败
    - FlagDetailPage UI 文本：基本信息、覆盖人口、网站、详情、未知
    - FlagDetailPage 朗读内容：所有朗读文本都已本地化
    - FlagDetailPage 分享文本：分享标题、描述、内容都已本地化
    - GalleryPage：已完全本地化（之前已完成）
  - **效果**：Gallery 标签页下的所有页面、组件和 Toast 消息现在都完全支持中英文切换

- **HomePage 本地化修复**：修复了 HomePage 及其子页面的本地化问题
  - **趣味知识本地化**：将 HomePage 中硬编码的 10 条趣味知识移到本地化资源文件
    - 添加了 `fun_fact_1` 到 `fun_fact_10` 的中英文本地化字符串
    - 现在会根据系统语言自动显示对应语言的趣味知识
  - **日期格式化本地化**：修复了日期显示中的硬编码月份名称
    - 添加了月份名称的本地化资源（`month_jan` 到 `month_dec` 和 `month_1` 到 `month_12`）
    - 添加了日期后缀的本地化资源（`day_suffix`）
    - 英文环境显示 "Jan 1" 格式，中文环境显示 "1月1日" 格式
  - **FavoritesPage 本地化修复**：修复了收藏页面的硬编码字符串
    - 将 "删除" 按钮文本改为使用 `app.string.delete` 本地化资源
    - 将硬编码的 "导航失败" 改为使用 `app.string.navigation_failed` 本地化资源
  - **效果**：现在 HomePage 及其子页面完全支持中英文切换，所有文本都从本地化资源读取

- **Paint 游戏页面本地化修复**：修复了涂鸦游戏（第三个 tab）及其子页面的本地化问题
  - **Toast 消息检查**：所有 Toast 消息都已正确本地化
    - `paint_reset_failed`: "重置失败，请重试" / "Reset failed, please try again"
    - `level_not_found`: "关卡不存在" / "Level not found"
    - `level_data_load_failed`: "关卡数据加载失败" / "Failed to load level data"
  - **硬编码文本修复**：修复了 PaintPlayPage 中硬编码的关卡显示文本
    - 将 `第 ${levelId} 关` 改为使用 `app.string.level_number` 本地化资源
    - 现在会根据系统语言显示 "第 X 关" 或 "Level X"
  - **效果**：现在 Paint 游戏页面完全支持中英文切换，所有文本和 Toast 消息都从本地化资源读取

### 变更 (Changed)
- **游戏名称更新**：将"拼写挑战"（Spelling Challenge）重命名为"输入游戏"（Input）
  - 更新了所有相关的字符串资源
  - 中文：拼写挑战 → 输入游戏
  - 英文：Spelling Challenge → Input
  - 涉及位置：关卡列表、探索页面、ProfilePage、游戏页面标题等

- **假旗找茬游戏名称统一**：修复了探索页面和游戏页面显示不同名称的问题
  - 探索页面英文名称：Find the Fake → **Fake Flag**
  - 现在所有位置统一显示 "Fake Flag"（英文）/ "假旗找茬"（中文）

### 修复 (Fixed)
- **Connections 游戏界面优化**：改进了国旗选择的视觉设计
  - **正常状态**：移除边框，界面更简洁清爽
  - **选中状态**：显示绿色边框和浅绿色背景，清晰标识选中项
  - **提示状态**：保持橙色边框和阴影效果
  - 提升了视觉层次感和交互体验

- **涂鸦游戏美国州旗本地化**：修复了 PaintPlayPage 中美国州旗的语言切换问题，确保正确显示英文或中文州名
  - **修改前**：语言切换时州名可能显示错误的语言
  - **修改后**：
    - 英文环境：Alabama, California, Texas...
    - 中文环境：阿拉巴马州、加利福尼亚州、德克萨斯州...
  - **代码优化**：
    - 重构了 `getFlagDisplayName()` 方法，使逻辑更清晰
    - 直接使用 `LocalizationUtil.isEnglish(this.currentLanguage)` 确保获取最新的语言状态
    - 先检查是否为美国州旗，再根据语言返回相应的州名
  - **效果**：在切换应用语言时，美国州旗名称能正确显示对应语言的州名

- **国旗详情页人口和面积本地化**：修复了 FlagDetailPage 中人口和面积数据的本地化显示问题
  - **问题描述**：之前人口和面积始终使用中文单位（万、亿），在英文环境下显示不正确
  - **修复方案**：修改 `formatPopulation()` 和 `formatArea()` 方法，根据语言环境使用不同的单位
  - **英文格式**：
    - 人口（Population）：
      - ≥ 10亿：X.XX billion（如 1.41 billion）
      - ≥ 100万：X.XX million（如 331.90 million）
      - ≥ 1千：X thousand（如 500 thousand）
      - < 1千：直接显示数字
    - 面积（Area）：
      - ≥ 100万：X.XX million km²（如 9.60 million km²）
      - ≥ 1千：X thousand km²（如 357 thousand km²）
      - < 1千：X km²（如 622 km²）
  - **中文格式**（保持不变）：
    - 人口：X.XX 亿人、X 万人、X 人
    - 面积：X.XX 万平方公里、X 平方公里
  - **效果**：现在英文用户可以看到符合英语习惯的人口和面积数据

- **五星红旗历史专题显示优化**：在英文环境下隐藏"五星红旗历史"专题
  - **修改位置**：
    - TopicData.ets：修改 `getAllTopics()` 函数，接收可选的 `language` 参数
    - HomePage.ets：传递语言参数到 `getAllTopics()`
    - TopicListPage.ets：传递语言参数到 `getAllTopics()`，并添加语言变化监听
  - **过滤逻辑**：
    - 在英文环境下（`language === 'en'` 或 `language.startsWith('en-')`），自动过滤掉 `flag-history` 专题
    - 在中文环境下，正常显示所有专题
  - **效果**：
    - 英文用户在首页和专题列表页不会看到"五星红旗历史"专题
    - 中文用户仍然可以正常访问该专题
  - **动态响应**：添加了 `@Watch` 装饰器，语言切换时自动更新专题列表

- **国旗详情页语言切换问题**：修复了 FlagDetailPage（国旗详情页）在切换语言后，国家信息仍显示原语言的问题
  - **问题原因**：`currentLanguage` 变量使用 `private` 声明，未使用 `@StorageLink` 连接到 AppStorage，导致无法响应语言切换
  - **受影响的信息**：
    - 首都名称（Capital/首都）
    - 大洲名称（Continent/大洲）
    - 组织总部（Headquarters/总部）
    - 国家/组织名称
    - 国旗设计描述
  - **修复方案**：将 `currentLanguage` 改为使用 `@StorageLink('currentLanguage')` 装饰器
  - **效果**：现在切换语言后，详情页的所有信息都会立即更新为对应的语言版本

- **专题详情页国家数量显示问题**：修复了相似旗专题页面显示"零个国家"的问题
  - **问题原因**：`getCountText()` 方法使用 `displayItems.length` 计算数量，但相似旗专题的 `loadSimilarFlags()` 方法没有填充 `displayItems`，只填充了 `similarFlagPairs`
  - **修复方案**：在 `getCountText()` 方法中添加对相似旗专题的特殊处理，使用 `similarFlagPairs.length * 2` 计算国家数量（每个 pair 包含 2 个国家）
  - **效果**：现在相似旗专题正确显示国家数量，例如"16 个国家"而不是"0 个国家"

- **Connections、Input 和 FakeFlag 游戏本地化**：完成了 ConnectionsPlayPage、InputPlayPage 和 FakeFlagPlayPage 的完整本地化
  - **添加的字符串资源**：
    - `try_again`: "再试一次！" / "Try again!"
    - `shuffle`: "打乱" / "Shuffle"
    - `unselect_all`: "取消全选" / "Unselect All"
    - `submit`: "提交" / "Submit"
    - `correct_answer`: "✓ 正确!" / "✓ Correct!"
    - `enter_country_name`: "请输入国家名称" / "Enter country name"
    - `find_fake_flag`: "找出假旗" / "Find the fake flag"
    - `correct_found`: "正确找出" / "Correctly Found"
    - `correct_found_count`: "正确找出了 %s 个假旗" / "Correctly found %s fake flags"
  - **本地化的内容**：
    - ConnectionsPlayPage: 错误提示、按钮文本（打乱、取消全选、提交、下一关）
    - InputPlayPage: 游戏结束对话框、正确提示、输入框占位符、按钮文本、统计信息
    - FakeFlagPlayPage: 游戏结束对话框、提示文本、按钮文本、统计信息
    - 所有硬编码的中文文本都已替换为本地化字符串资源

- **五星红旗历史专题本地化**：修改了专题本地化逻辑，使"五星红旗历史"专题在英文环境下也始终显示中文
  - **修改内容**：
    - 更新了 `getLocalizedTopicName()` 函数，对于 `flag-history` 专题，始终返回中文名称
    - 更新了 `getLocalizedTopicDescription()` 函数，对于 `flag-history` 专题，始终返回中文描述
    - 更新了 HomePage 中的专题显示，使用本地化函数替代直接访问 `nameEN` 属性
  - **效果**：在专题推荐和专题列表中，"五星红旗历史"专题无论系统语言设置为何，都显示中文名称和描述

- **Quiz 和 Trivia 游戏本地化**：完成了 QuizPlayPage 和 TriviaPlayPage 的完整本地化
  - **添加的字符串资源**：
    - `which_country_flag`: "这是哪个国家的国旗？" / "Which country's flag is this?"
    - `select_correct_flag`: "请选择正确的国旗" / "Select the correct flag"
    - `challenge_failed`: "挑战失败" / "Challenge Failed"
    - `correct_answers_count`: "正确回答了 %s 道题" / "Correctly answered %s questions"
    - `correct_answers_count_trivia`: "正确回答了 %s 题" / "Correctly answered %s questions"
    - `max_combo`: "最高连击 %s" / "Max Combo %s"
    - `restart`: "重新开始" / "Restart"
    - `next_question`: "下一题" / "Next Question"
    - `view_results`: "查看结果" / "View Results"
    - `correct_answers`: "正确答题" / "Correct Answers"
    - `correct_answers_label`: "正确回答" / "Correct Answers"
    - `remaining_lives`: "剩余生命" / "Remaining Lives"
    - `share_score`: "分享成绩" / "Share Score"
    - `combo_streak`: "%s 连击！" / "%s Combo!"
    - `correct_answers_share`: "正确答题：%s / %s" / "Correct Answers: %s / %s"
    - `max_combo_share`: "最高连击：%s" / "Max Combo: %s"
    - `remaining_lives_share`: "剩余生命：%s" / "Remaining Lives: %s"
    - `back_to_levels`: "返回关卡列表" / "Back to Levels"
  - **本地化的内容**：
    - QuizPlayPage: 问题提示文本、游戏结束对话框、按钮文本、统计信息、分享文本等
    - TriviaPlayPage: 游戏结束对话框、按钮文本、统计信息、关卡显示等
    - 所有硬编码的中文文本都已替换为本地化字符串资源

- **历史国旗页面标题格式**：修复了 FlagHistoryPage（历史国旗页面）标题中国家名称和后续文本之间缺少空格的问题
  - **修复位置**：
    - ShareContentBuilder：分享截图标题
    - HistoryContentBuilder：页面显示标题
  - **修复效果**：
    - 修改前：`${this.countryName}${flagHistory}`（如 "中国国旗变迁史"）
    - 修改后：`${this.countryName} ${flagHistory}`（如 "中国 国旗变迁史" 或 "China Flag History"）
  - 标题现在在国家名称和后续文本之间有正确的空格，提高了可读性

- **记忆翻牌游戏本地化**：修复了 MemoryPlayPage（记忆翻牌游戏页面）中所有硬编码的中文字符串
  - **添加的字符串资源**：
    - `time`: "时间" / "Time"
    - `moves`: "步数" / "Moves"
    - `pairs`: "配对" / "Pairs"
    - `total_moves`: "总步数" / "Total Moves"
    - `pairs_completed`: "配对完成" / "Pairs Completed"
    - `time_up`: "时间到！" / "Time's Up!"
  - **本地化的UI文本**：
    - 顶部状态栏：步数、时间、配对
    - 结果对话框：恭喜过关、时间到、总步数、配对完成
  - **其他修复**：
    - 移除了结果对话框中的 `level.name` 显示，现在只显示 "第 N 关" 或 "Level N"
    - 所有文本现在根据系统语言自动显示中英文版本

- **首页本地化问题**：修复了首页多个区域的本地化显示问题
  - **专题推荐部分**：
    - 专题名称现在根据应用语言显示中文或英文
    - 添加了文本溢出处理（ellipsis）
  - **每周国旗部分**：
    - 国家名称现在使用 `getLocalizedCountryName()` 根据语言显示
    - 日期格式根据语言环境正确显示：
      - 中文：X月X日（如 "12月25日"）
      - 英文：Month Day（如 "Dec 25"）
    - 修复了日期格式硬编码为中文的问题
  - **实现细节**：
    - 添加了 `formatDate()` 方法处理日期本地化
    - 添加了 `getLocalizedCountryNameByCode()` 方法获取本地化国家名称
    - 导入了 `getLocalizedCountryName` 工具函数

- **游戏关卡页面显示优化**：修复了所有游戏关卡页面中关卡条目显示额外文本的问题
  - **受影响页面**：
    - MemoryLevelsPage：记忆翻牌关卡页面
    - QuizLevelsPage：国旗猜猜关卡页面
    - FakeFlagLevelsPage：假旗找茬关卡页面
    - ConnectionsLevelsPage：分组连线关卡页面
  - **修复内容**：
    - 移除了关卡条目中的 `level.name` 显示（如 "第 N 关 · 关卡名称"）
    - 现在所有关卡条目只显示 "第 N 关" 或 "Level N"
    - 统一了所有页面使用 `context.resourceManager.getStringSync()` 获取本地化字符串资源
    - 确保所有关卡页面显示格式一致

- **QuizSelectPage 本地化问题**：修复了 QuizSelectPage（国旗猜猜选择页）中硬编码中文文本未本地化的问题
  - 添加了缺失的字符串资源：`quiz_flag_to_name_desc`、`quiz_name_to_flag_desc`、`complete_levels_to_unlock`
  - 将所有硬编码文本替换为本地化字符串资源
  - 标题使用 `game_quiz` 资源进行本地化

- **详情页 Snackbar 宽度问题**：修复了 FlagDetailPage 和 StateFlagDetailPage 中复制提示 snackbar 宽度为 100% 的布局问题
  - **受影响页面**：
    - FlagDetailPage：国旗详情页
    - StateFlagDetailPage：州旗详情页
  - **修复内容**：
    - 移除了不必要的外层 Column 容器
    - 去掉了 `width('100%')` 设置，让宽度根据 margin 自动计算
    - 简化了布局结构，直接使用 Row 作为顶层容器
    - 现在 snackbar 宽度正确为：父容器宽度 - 左右 margin (32px)

- **应用语言切换同步问题**：修复了在 ProfilePage 切换语言后，其他页面不能立即更新语言的问题
  - **问题原因**：多个页面使用 `LocalizationUtil.getSystemLanguage()` 获取语言，这只在页面初始化时获取一次，不能响应应用语言切换
  - **修复方案**：将所有页面的语言变量改为使用 `@StorageLink('currentLanguage')` 连接到 `AppStorage`
  - **受影响页面**：
    - GalleryPage：添加 `@Watch('onLanguageChanged')` 监听语言变化并重新加载国家列表
    - HomePage：趣味知识根据语言动态切换
    - HeadsUpPlayPage：国家名称显示根据语言切换
    - PaintPlayPage：美国州名和国家名根据语言显示
    - TopicDetailPage：专题内容根据语言显示
    - TopicListPage：专题列表根据语言显示
    - FlagDetailPage：国旗详情页根据语言显示
    - ProfilePage：配置页使用 @StorageLink 同步语言状态
  - **效果**：现在切换语言后，所有页面都能立即显示正确的语言内容，无需重启应用

- **全面修复英文本地化问题**：逐页、逐组件、逐toast审查并修复所有硬编码的中文字符串
  - **Toast消息本地化**：修复所有toast消息的硬编码中文字符串
    - QuizPlayPage: "正在准备分享..."、"截取图片失败"、"分享失败"
    - TriviaPlayPage: "正在准备分享..."、"截取图片失败"、"分享失败"
    - ConnectionsPlayPage: "分成四组，每组四个。点选，找齐即可过关。"
    - PaintPlayPage: "关卡不存在"、"关卡数据加载失败"
    - FlagDetailPage: "保存失败: ${error.message}"
  - **连接字符串本地化**：修复所有"第 N 关"格式的硬编码字符串
    - ConnectionsPlayPage: 关卡标题显示
    - QuizPlayPage: 关卡标题、分享标题、结果页面
    - InputPlayPage: 关卡标题、结果页面
    - FakeFlagPlayPage: 关卡标题、结果页面
    - TriviaPlayPage: 关卡标题、分享标题、结果页面
    - PaintPlayPage: 关卡标题、结果页面
    - MemoryPlayPage: 结果页面
    - InputLevelsPage: 关卡列表显示
    - TriviaLevelsPage: 关卡列表显示
  - **UI文本本地化**：修复所有硬编码的UI文本
    - GalleryPage: "搜索国家或地区"、"未找到匹配的国家"、"修改关键词或选择\"全部\"或其他大洲"、"加载中..."
    - PaintPlayPage: "下一个"、"完成"、"下一关"、"完美收官"、"返回"
    - TopicDetailPage: "加载中..."、"已停止朗读"、"开始朗读"、"朗读功能暂不可用"、"共 N 个国家/组织"
    - HeadsUpPlayPage: "加载中..."
    - StateFlagDetailPage: "加载中..."、"暂无数据"、"基本信息"、"所属国家"、"首府"、"地区"、"已收藏"、"收藏"、"下载"、"点击各项内容可复制"、"知道了"、"已复制"、"复制失败"、"已取消收藏"、"已添加到收藏"、"正在准备图片..."、"截取图片失败"、"下载失败"、"州旗图片已保存到相册"、"保存失败"、"已停止朗读"、"开始朗读"、"朗读功能暂不可用"、"正在准备分享..."、"分享失败"、"州旗详情"
  - **字符串资源更新**：添加缺失的字符串资源
    - `level_not_found`: "关卡不存在" / "Level not found"
    - `level_data_load_failed`: "关卡数据加载失败" / "Failed to load level data"
    - `next`: "下一个" / "Next"
    - `complete`: "完成" / "Complete"
    - `search_country_or_region`: "搜索国家或地区" / "Search country or region"
    - `no_matching_countries`: "未找到匹配的国家" / "No matching countries found"
    - `modify_keywords_or_select`: "修改关键词或选择\"全部\"或其他大洲" / "Modify keywords or select \"All\" or other continents"
    - `loading`: "加载中..." / "Loading..."
    - `level_challenge_success`: "第%s关挑战成功" / "Level %s challenge completed"
    - `total_countries`: "共 %s 个国家" / "%s countries"
    - `total_organizations`: "共 %s 个组织" / "%s organizations"
    - `favorite_added`: "已添加到收藏" / "Added to favorites"
    - `download_failed`: "下载失败" / "Download failed"
    - `state_flag_saved`: "州旗图片已保存到相册" / "State flag image saved to gallery"
    - `no_data`: "暂无数据" / "No data"
    - `belongs_to_country`: "所属国家" / "Country"
    - `state_flag_detail`: "州旗详情" / "State Flag Details"
    - `state_flag`: "州旗" / "State Flag"
  - **代码改进**：
    - 所有toast消息现在使用 `context.resourceManager.getStringSync()` 获取本地化字符串
    - 所有"第 N 关"格式的字符串现在使用 `level_number` 资源字符串
    - 所有UI文本现在使用资源字符串而不是硬编码中文
    - 确保所有连接字符串（如"第 N 关"）都正确支持本地化
    - StateFlagDetailPage: 朗读内容根据系统语言生成中英文版本

### 新增 (Added)
- **图库页面本地化**：图库页面现在支持中英文切换
  - **国家名称本地化显示**：根据系统语言显示英文或中文国家名称
  - **大洲筛选器本地化**：大洲名称根据系统语言显示相应语言
  - **智能排序**：英文环境按英文字母排序，中文环境按拼音排序
  - **搜索功能增强**：搜索同时支持中英文国家名称
  - **显示优化**：国家名称最多显示1行，超长文本自动省略
  - 使用 `LocalizationUtil` 工具类获取系统语言
  - 使用 `getLocalizedCountryName` 和 `getLocalizedRegionName` 函数进行本地化

- **游戏关卡页面本地化**：所有游戏关卡页面的标题现在支持中英文切换
  - 知识问答 (Trivia Quiz)
  - 拼写挑战 (Spelling Challenge)
  - 假旗找茬 (Flag Detection)
  - 记忆翻牌 (Memory Match)
  - 分组连线 (Connections)

- **HeadsUp游戏本地化支持**：为HeadsUp游戏添加完整的国际化支持
  - **Info对话框本地化**：首次进入游戏时的使用说明对话框现在支持中英文
    - 添加 `headsup_tutorial_title` 资源（中文："使用说明" / 英文："How to Play"）
    - 添加 `headsup_tutorial_message` 资源（中文："• 点击屏幕查看答案\n• 再点下一个\n• 每十个一轮" / 英文："• Tap screen to see answer\n• Tap again for next\n• 10 flags per round"）
  - **游戏结束界面本地化**：完成一轮游戏后的界面文本本地化
    - 添加 `headsup_session_over` 资源（中文："本轮完成！" / 英文："Round Complete!"）
    - 添加 `headsup_session_count` 资源（中文："已完成 %s 轮" / 英文："Completed %s round(s)"）
    - 添加 `headsup_exit` 资源（中文："退出" / 英文："Exit"）
    - 添加 `headsup_continue` 资源（中文："继续" / 英文："Continue"）
  - **国家名称显示优化**：
    - 英文模式下只显示英文国家名称
    - 中文模式下显示中文国家名称（主要）和英文名称（辅助）
  - **代码改进**：
    - 引入 `LocalizationUtil` 工具类检测系统语言
    - 添加 `isEnglish` 状态变量动态控制国家名称显示
    - 使用资源管理器动态获取本地化字符串

- **Paint标签页完整本地化**：为涂鸦游戏添加全面的国际化支持
  - **分类名称和描述本地化**：
    - 添加 `paint_category_world` 资源（中文："世界" / 英文："World"）
    - 添加 `paint_category_world_desc` 资源（中文："世界各国国旗涂鸦" / 英文："Paint world flags"）
    - 添加 `paint_category_us` 资源（中文："美国" / 英文："United States"）
    - 添加 `paint_category_us_desc` 资源（中文："美国各州州旗涂鸦" / 英文："Paint US state flags"）
  - **界面元素本地化**：
    - 添加 `paint_instructions_banner` 资源（中文："涂鸦说明" / 英文："How to Play"）
    - 添加 `paint_reset_failed` 资源（中文："重置失败，请重试" / 英文："Reset failed, please try again"）
  - **美国州名本地化支持**：
    - 添加 `US_STATE_NAMES_EN` 常量，包含所有50个州和华盛顿特区的英文名称
    - 重命名 `US_STATE_NAMES` 为 `US_STATE_NAMES_CN` 以明确区分语言
    - 在PaintPlayPage中添加 `isEnglish` 状态变量
    - 修改 `getFlagDisplayName()` 方法根据系统语言返回对应的州名或国家名
  - **数据结构改进**：
    - 为 `PaintCategory` 接口添加 `nameResId` 和 `descResId` 字段
    - 所有分类配置使用资源ID而非硬编码字符串
  - **页面更新**：
    - PaintHomePage：使用资源ID显示分类名称和描述
    - PaintPlayPage：根据语言环境显示正确的国家名或州名
    - AllLevelsCompletedDialog：完成对话框使用本地化的分类名称

### 修复 (Fixed)
- **ArkTS @Builder 语法错误修复**：修复了 GalleryPage 中 @Builder 函数的编译错误
  - 在 `@Builder` 函数中不能使用 `const`/`let`/`var` 声明变量
  - 将变量声明改为直接在 UI 组件中使用表达式
  - 修复了 `ContinentChip` 和 `FlagItem` 两个 Builder 函数

- **AllLevelsCompletedDialog 类型错误修复**：修复了 PaintHomePage 中对话框的编译错误
  - 将 `categoryName` 属性改为 `completionMessage` 属性
  - 在创建对话框前生成完整的本地化消息
  - 避免在 CustomDialog 中访问不存在的 `context` 属性

- **资源目录命名错误修复**：修复了资源目录命名不符合HarmonyOS规范的问题
  - 删除了使用连字符的 `en-US` 目录（错误命名）
  - 保留使用下划线的 `en_US` 目录（正确命名）
  - HarmonyOS 要求使用下划线格式（如 `en_US`, `zh_CN`）而不是连字符格式

- **ArkTS 编译错误修复**：修复了多个 ArkTS 编译错误
  - **对象字面量类型声明**：为 map 函数的返回值添加明确的类型声明
    - FlagEtiquetteData.ets: `(section): EtiquetteSection => ({...})`
    - FlagManufacturingData.ets: `(section): ManufacturingSection => ({...})`
    - FlagVexillologyData.ets: `(section): VexillologySection => ({...})`
    - FlagHistoryData.ets: `(section): HistorySection => ({...})`
  - **Promise 类型错误**：修复 QuizPlayPage.ets 中的 Promise 类型问题
    - 在调用 `buildShareText()` 时添加 `await`
    - 确保异步方法正确返回 string 而不是 Promise<string>

- **资源重复定义修复**：修复了 string.json 中重复的资源定义
  - 删除了重复的 `next_level` 资源定义
  - 删除了重复的 `perfect_finish` 资源定义
  - 删除了重复的 `congratulations` 资源定义
  - 中英文资源文件现在每个资源只定义一次

### 新增 (Added)
- **专题内容本地化支持**：为所有知识性专题内容添加英文支持
  - **数据结构更新**：
    - 为 `EtiquetteSection`、`ManufacturingSection`、`VexillologySection`、`HistorySection` 接口添加 `titleEN` 和 `contentEN` 字段
    - 所有知识性专题的章节标题和内容现在都支持中英文两种语言
  - **英文内容添加**：
    - **FlagEtiquetteData**：为6个章节（升旗流程、悬挂顺序、悬挂方式、使用场合、礼仪规范、常见错误）添加完整英文内容
    - **FlagManufacturingData**：为6个章节（制作流程、制作材料、制作工艺、制作工厂、质量标准、制作成本）添加完整英文内容
    - **FlagVexillologyData**：为7个章节（旗帜学概述、旗帜分类、设计原则、历史演变、研究方法、著名学者、旗帜象征）添加完整英文内容
    - **FlagHistoryData**：为8个章节（设计背景、设计过程、设计细节、首次升起、法律地位、使用规范、文化意义、历史演变）添加完整英文内容
  - **本地化函数**：
    - 创建 `getLocalizedEtiquetteContent()` 函数
    - 创建 `getLocalizedManufacturingContent()` 函数
    - 创建 `getLocalizedVexillologyContent()` 函数
    - 创建 `getLocalizedFlagHistoryContent()` 函数
    - 所有函数根据系统语言自动返回对应的本地化内容
  - **页面更新**：
    - **TopicDetailPage**：
      - 更新 `loadKnowledgeContent()` 方法使用本地化函数
      - 更新 `getReadContent()` 方法使用本地化的专题名称和描述
      - 更新朗读功能的提示信息为本地化文本
      - 更新相似旗专题的国家名称使用本地化
      - 更新国旗列表中的国家/组织名称使用本地化
      - 所有知识性专题内容（标题和正文）现在都根据系统语言自动显示
    - **TopicListPage**：
      - 更新页面标题使用字符串资源（`$r('app.string.topic_recommendations')`）
      - 专题名称和描述已通过 `getLocalizedTopicName()` 和 `getLocalizedTopicDescription()` 实现本地化
  - 知识性专题现在完全支持中英文切换，所有内容（包括章节标题和正文）都会根据系统语言自动显示相应的语言版本

- **完善国际化支持**：为更多界面元素添加国际化支持
  - **底部标签栏**：首页、画廊、涂鸦、探索、我的
  - **ProfilePage**：
    - 游戏名称：国旗猜猜、假旗找茬、拼写挑战、知识问答
  - **HomePage**：
    - 大洲名称：亚洲、欧洲、非洲、美洲、大洋洲
  - **FavoritesPage**：
    - 我的收藏、暂无收藏、已取消收藏、导航失败
  - **游戏关卡页面**：
    - 看旗猜国名、看名猜国旗
    - 第 N 关 → Level N
  - **游戏页面**：
    - 恭喜过关 → Congratulations
    - 下一关 → Next Level
    - 完美收官 → Perfect Finish
  - 添加所有相关的中英文字符串资源（30+个新字符串）
  - 确保所有 UI 文本都能正确适配中英文语言

- **语言切换功能**：在"我的"页面添加语言切换功能
  - 在深色模式设置下方添加语言选择设置项
  - 支持中文和英文两种语言
  - 点击语言设置项打开语言选择对话框
  - 使用 `i18n.System.setAppPreferredLanguage()` API 设置应用偏好语言
  - 语言设置持久化保存到 Preferences 和 AppStorage
  - 在 EntryAbility 中自动初始化语言设置
  - 参考 morse 项目实现，支持实时语言切换
  - 添加语言相关的字符串资源（中英文）
  - 语言切换后重启应用即可生效

### 修复 (Fixed)
- **ArkTS 编译错误修复**：修复了 ProfilePage 和 LocalizationUtil 中的类型错误
  - **ProfilePage.ets**：
    - 使用 `ResourceWithId` 接口替代 `as unknown as Record<string, number>`
    - 为 `showAboutApp()` 和 `showFeedback()` 方法定义 `DialogButton` 和 `ShowDialogOptions` 接口
    - 移除所有 `as unknown as` 类型断言，改用明确的接口定义
  - **LocalizationUtil.ets**：
    - 定义 `LocaleInfo` 接口替代不存在的 `resourceManager.Locale`
    - 使用 `locale.language !== undefined` 检查替代不支持的 `'language' in locale` 操作符
    - 定义 `ErrorObject` 接口替代对象字面量作为类型声明
    - 移除所有 `as unknown as` 类型断言

### 新增 (Added)
- **元数据英文支持**：为所有元数据（CountryInfo、FlagDesign、InternationalOrg 等）添加英文条目支持
  - 添加 `ContinentNamesEN` 英文洲名称映射
  - 创建本地化工具函数：
    - `getLocalizedCountryName()` - 根据语言获取国家名称
    - `getLocalizedCapital()` - 根据语言获取首都名称
    - `getLocalizedRegionName()` - 根据语言获取地区名称
    - `getLocalizedFlagDesign()` - 根据语言获取标志设计描述
    - `getLocalizedOrgName()` - 根据语言获取国际组织名称
    - `getLocalizedOrgHeadquarters()` - 根据语言获取国际组织总部名称
  - 创建 `LocalizationUtil` 工具类，用于获取系统语言
  - 更新 `FlagDetailPage` 以根据系统语言自动加载相应的元数据显示
  - 所有国家信息、标志设计描述、国际组织信息现在都支持英文和中文两种语言
  - 当应用语言设置为英文时，自动显示英文元数据；设置为中文时，显示中文元数据
  - `StateFlagData` 已包含英文字段，无需额外添加
  - 为 `TopicData` 添加英文支持：
    - 在 `TopicItem` 接口中添加 `nameEN` 和 `descriptionEN` 字段
    - 为所有专题（旗帜学、国旗礼仪、国旗制作、五星红旗历史、相似旗、国际组织等15个专题）添加英文名称和描述
    - 创建 `getLocalizedTopicName()` 和 `getLocalizedTopicDescription()` 本地化函数
    - 更新 `TopicListPage` 和 `TopicDetailPage` 以根据系统语言显示相应的专题名称和描述

- **英文国际化支持**：为应用添加英文语言支持，使用 HarmonyOS 系统国际化方案
  - 创建英文版本的 string.json 资源文件（en-US/element/string.json）
  - 更新中文版本的 string.json，添加所有需要国际化的字符串资源
  - 在 entry 和 AppScope 目录下分别创建英文资源文件
  - 替换代码中的硬编码中文字符串为资源引用（$r('app.string.xxx')）
  - 更新的页面包括：
    - HomePage：欢迎标题、快捷入口、专题推荐、趣味小知识等
    - ExplorePage：所有游戏卡片的标题和描述
    - FlagDetailPage：基本信息、关于国旗、收藏、下载、分享等所有UI文本
    - ProfilePage：设置项、主题对话框、关于应用、意见反馈等
    - PaintHomePage：涂鸦说明对话框、完成对话框等
  - 应用现在可以根据系统语言设置自动切换中英文界面
  - 支持的语言：中文（简体）、英文（美式）

### 优化 (Optimized)
- **ConnectionsPlayPage 提示按钮样式优化**：将提示按钮背景色改为半透明
  - 💡 提示按钮和 ✓ 解答按钮的背景色从纯色改为 `rgba(22, 119, 255, 0.5)`（50%透明度）
  - 半透明效果让按钮看起来更轻盈，与游戏界面更协调
  - 保持按钮的圆形设计和尺寸不变
- **ConnectionsPlayPage 游戏提示优化**：游戏提示 toast 只在会话中显示一次
  - 添加 `hasShownToast` 私有变量跟踪 toast 显示状态
  - 只在第一次加载关卡时显示"分成四组，每组四个。点选，找齐即可过关。"提示
  - 后续关卡不再重复显示提示，减少干扰，提升用户体验
- **ConnectionsPlayPage 移除提交振动反馈**：移除提交按钮点击时的振动反馈
  - 移除 `submitSelection` 方法中的 `VibratorUtil.vibrateTap()` 调用
  - 保留正确答案、错误答案和完成游戏的振动反馈
  - 减少不必要的振动，提升用户体验
- **ExplorePage 列表底部间距优化**：为探索页面列表添加底部内边距，避免最后一张卡片被底部标签栏遮挡
  - 在 Column 组件上添加 `padding: { bottom: 60 }`
  - 将所有游戏卡片的内边距从 20 增加到 24，使卡片内容更宽敞舒适
  - 用户现在可以完整看到最后一张卡片，无需担心被标签栏遮挡

### 修复 (Fixed)
- **ConnectionsPlayPage 硬编码关卡数修复**：修复了最大关卡数硬编码的问题
  - 导入 `getTotalConnectionsLevels()` 函数
  - 使用 `getTotalConnectionsLevels()` 动态获取总关卡数，替代硬编码的 `15`
  - 确保添加新关卡时不需要修改多处代码
- **GameProgressManager 内存泄漏修复**：修复了 initPromise 可能导致的内存泄漏
  - 在成功初始化后将 `initPromise` 设置为 null
  - 避免重复初始化时等待已完成的 Promise
  - 提升内存管理和性能
- **涂鸦游戏数据清理**：移除德国、意大利、巴西涂鸦游戏分类
  - 从 `paintCategories` 数组中移除这三个分类（暂无数据）
  - 从 `GameType` 枚举中移除 `PAINT_DE`、`PAINT_IT`、`PAINT_BR`
  - 从 `PaintHomePage.getGameType()` 方法中移除对应映射
  - 只保留世界和美国两个有完整数据的分类
- **ConnectionsPlayPage 移除胜利界面**：移除胜利对话框，"下一关"按钮直接在当前页面加载下一关
  - 移除 `showWinScreen` 状态变量和相关逻辑
  - 移除 `WinScreen` @Builder 组件（包含遮罩层、胜利内容、已解分组展示等）
  - 移除 `displayWinScreen()` 方法
  - 移除 `handlePlayAgain()` 方法（不再需要"再玩一次"功能）
  - "下一关"按钮点击后直接调用 `handleNextLevel()`，在当前页面加载下一关数据
  - 简化了游戏流程，用户完成关卡后可以直接进入下一关，无需额外的对话框交互
  - 移除 build 方法中的 Stack 和条件判断，直接使用 Navigation 作为根组件
- **ConnectionsPlayPage 下一关按钮宽度问题**：修复了"下一关"按钮宽度超出屏幕的布局问题
  - 问题原因：按钮同时设置了 `width: 100%` 和左右 margin，导致实际宽度超出父容器
  - 修复方式：用 Column 包裹按钮，将 margin 改为 padding 设置在 Column 上
  - 按钮现在正确显示在屏幕内，左右各有16像素的间距
- **ConnectionsPlayPage 已解分组不显示问题**：修复了提交正确分组后，已解分组区域不显示的数据绑定问题
  - 问题原因：在 ArkTS 中，直接修改 `@State` 数组内部对象的属性不会触发 UI 更新
  - 修复方式：在修改分组状态后，使用 `this.groups = [...this.groups]` 重新赋值整个数组来触发 UI 更新
  - 在 `submitSelection` 方法中添加数组重新赋值
  - 在 `useSolve` 方法中添加数组重新赋值和 `this.showGroups = true`
  - 修复后已解分组能够正确显示在页面顶部
- **涂鸦游戏完成对话框崩溃问题**：修复了点击已完成的涂鸦游戏入口时应用崩溃的问题
  - 问题原因：`showAllLevelsCompletedDialog` 方法中尝试使用 `new` 创建 `@CustomDialog` 结构体实例
  - 修复方式：改用 CustomDialogController 的 builder 模式，直接传递参数
  - 将 `onRestart` 回调改为可选参数（`onRestart?: () => void`）
  - 添加 `@State dialogCategoryName: string` 用于传递分类名称到对话框
  - 修复后点击已完成的游戏入口不再崩溃，正确显示完成对话框
- **ConnectionsPlayPage 提交分组后逻辑和UI修复**：修复了提交分组后已解分组不立即显示的问题
  - 在提交分组成功后，如果有已解分组，立即设置 `showGroups = true`，不再等待2秒延迟
  - 移除已解分组区域的固定高度限制（200px），改为根据内容动态调整高度
  - 移除已解分组区域的Scroll组件，改为直接使用Column，与Flutter实现保持一致
  - 参考Flutter实现，确保提交分组后已解分组立即显示在顶部区域
- **ConnectionsPlayPage 提示和解答按钮样式优化**：优化提示和解答按钮的文本大小和居中显示
  - 将按钮文本大小从20减小到16，使按钮更精致
  - 添加文本居中对齐，确保emoji图标在按钮中居中显示
- **ConnectionsPlayPage 下一步按钮优化**：将"下一步"改为"下一关"，并参考QuizPlayPage调整按钮样式
  - 将按钮文本从"下一步"改为"下一关"，与其他游戏页面保持一致
  - 参考QuizPlayPage的实现，调整按钮样式：
    - 字体大小从18调整为17
    - 移除ButtonType.Normal和borderRadius，使用默认样式
    - 保持宽度100%和高度48，与其他游戏页面保持一致
- **ConnectionsPlayPage 游戏完成时隐藏操作按钮**：确保游戏完成时所有操作按钮（包括提示和解答按钮）都被隐藏
  - 所有操作按钮（打乱、取消全选、提交、提示、解答）都在 `if (!this.isGameCompleted())` 条件内
  - 当所有分组都完成时，这些按钮会自动隐藏，只显示"下一关"按钮
  - 与Flutter实现保持一致，提供更好的用户体验
- **ConnectionsPlayPage 提示改为Toast**：将"创建四个四组"提示从页面内横幅改为顶部Toast提示
  - 移除页面内的提示横幅元素（showHintBanner）
  - 在加载关卡时使用 `promptAction.showToast` 在顶部显示提示，持续3秒
  - 设置 `bottom: '80%'` 让 Toast 显示在屏幕顶部
  - 简化页面布局，减少页面内元素，提供更简洁的用户体验
  - 移除相关的状态变量和定时器逻辑
  - 更新提示文本为"分成四组，每组四个。点选，找齐即可过关。"，提供更详细的游戏说明
- **ConnectionsLevelsPage 参考 QuizLevelsPage 样式**：完全参考 QuizLevelsPage 的样式和布局
  - 添加关卡序号图标（圆形背景，显示数字）
  - 保留"第 N 关"文本（不显示名称）
  - 添加箭头图标（仅已解锁关卡显示）
  - 将 onClick 从 ListItem 移到 Row 上
  - 添加 startLevel 方法处理关卡点击，与 QuizLevelsPage 的 startQuiz 方法保持一致
  - 使用相同的颜色、尺寸和间距，确保视觉一致性
- **ConnectionsPlayPage 修复导航栏显示问题**：修复导航栏不显示的问题
  - 将 `.title('')` 改为 `.title('分组连线')`，确保导航栏正常显示
  - 空字符串标题可能导致导航栏不显示，设置非空标题可以解决这个问题
- **ConnectionsPlayPage 移除内部返回按钮**：移除内部UI中的返回按钮，使用导航栏的返回按钮
  - 移除内部顶部栏中的返回按钮图标和点击事件
  - 移除 `.hideBackButton(true)`，恢复导航栏的返回按钮显示
  - 简化内部UI，只保留关卡标题，使用导航栏的标准返回按钮
- **ConnectionsPlayPage UI 优化**：优化分组连线游戏页面的标题和布局显示
  - 移除导航栏标题文本（`.title('')`），只保留返回按钮
  - 在页面内容区域顶部添加关卡标题（"第 N 关"），居中显示
  - 已解分组区域在顶部显示（错误提示下方），方便用户查看已完成的分组
  - 与 Flutter 项目保持一致的布局结构
- **StateFlagDetailPage 对话框崩溃问题**：修复了点击美国州旗下载按钮时应用崩溃的问题
  - 在创建新对话框前先关闭旧的对话框，避免重复创建导致崩溃
  - 在 `aboutToDisappear()` 中添加对话框关闭逻辑，确保页面销毁时正确清理资源
  - 在 `onSaveSuccess` 回调中添加 `releaseFlagPixelMap()` 调用，确保保存成功后释放 PixelMap
  - 参考 FlagDetailPage 的实现方式，保持一致的对话框管理逻辑
- **ConnectionsPlayPage 移除左侧返回按钮**：移除分组连线游戏页面 Navigation 组件的默认左侧返回按钮（chevron）
  - 添加 `.hideBackButton(true)` 隐藏默认返回按钮
  - 页面已有自定义返回按钮，移除默认按钮避免重复
- **编译错误修复**：修复了多个 ArkTS 编译错误
  - **ConnectionsPlayPage.ets**：
    - 修复方法名错误：将 `playButtonTap()` 替换为 `playButton()`，`vibrateSelection()` 替换为 `vibrateTap()`
    - 修复解构赋值问题：将数组解构赋值改为传统循环方式
    - 修复展开运算符问题：将展开运算符改为显式循环复制数组
    - 修复对象字面量类型问题：将展开对象改为显式属性赋值
    - 修复结构类型问题：使用显式类型声明替代结构类型
    - 修复 @Builder 中逻辑代码问题：将逻辑代码移到私有方法 `isFlagSelected()` 和 `isFlagHintHighlighted()` 中，在 @Builder 中直接使用方法调用
    - 修复 FontWeight.SemiBold 不存在问题：改为使用 `FontWeight.Medium`
    - 修复 curves API 问题：将 `curves.easeOut`、`curves.easeOutCubic`、`curves.easeInOut` 改为 `Curve.EaseOut`、`Curve.EaseOut`、`Curve.EaseInOut`
    - 修复 Padding 格式问题：将 `{ vertical: x, horizontal: y }` 改为 `{ top: x, bottom: x, left: y, right: y }`
    - 修复 maxHeight 问题：将 `maxHeight` 改为 `height`
    - 修复重复方法名问题：将 `showWinScreen()` 方法重命名为 `displayWinScreen()`，避免与 `@State showWinScreen` 冲突
    - 修复 icon_error 资源不存在问题：使用文本符号 '✗' 替代图标
    - 修复 includes 方法问题：将 `includes()` 方法改为显式循环查找
    - 修复 FlagTile 接口导入问题：从 ConnectionsLevels 导入 FlagTile 接口，移除本地重复定义
  - **QuizPlayPage.ets**：
    - 修复 build 方法结构问题：将条件分支包装在单一 Column 根节点中，符合 Navigation 的 build 方法要求
    - 修复 Navigation 链式调用位置：将 `.title()`, `.titleMode()` 等链式调用移到 Navigation 块外
  - **TriviaPlayPage.ets**：
    - 修复 build 方法结构问题：将条件分支包装在单一 Column 根节点中，符合 Navigation 的 build 方法要求
    - 修复 Navigation 链式调用位置：将 `.title()`, `.titleMode()` 等链式调用移到 Navigation 块外
    - 修复 @Builder 中逻辑代码问题：将 `const question = this.getCurrentQuestion()` 改为直接在条件判断中使用方法调用

### 新增 (Added)
- **Quiz 和 Trivia 游戏分享功能**：为看旗猜国名和知识问答游戏添加分享功能
  - 在导航栏添加分享按钮，点击可分享当前问题 UI
  - 创建隐藏的分享容器，包含问题内容、选项和关卡信息
  - 使用截图功能将问题 UI 转换为图片并分享
  - 参考 FlagDetailPage 的实现方式，使用相同的图片分享技术
  - 分享图片包含完整的问题信息，方便用户分享到社交媒体

### 修复 (Fixed)
- **ConnectionsPlayPage 路由注册**：为分组连线游戏页面注册路由
  - 在 main_pages.json 中添加 ConnectionsLevelsPage 和 ConnectionsPlayPage 的路由注册
  - 修复了分组连线游戏无法正常跳转的问题
- **ConnectionsPlayPage 返回按钮反馈**：为分组连线游戏页面的返回按钮添加音效和振动反馈
  - 返回按钮点击时播放按钮点击音效和振动反馈
  - 与其他游戏页面保持一致的用户体验
- **Snackbar 边距和样式优化**：修复详情页 Snackbar 的边距和样式问题
  - 为 Snackbar 添加左右边距（16px）和底部边距（16px），避免紧贴屏幕边缘
  - 将圆角从仅顶部圆角改为全圆角（12px），提升视觉效果
  - 修复了 StateFlagDetailPage 和 FlagDetailPage 中的 Snackbar 样式
  - 现在 Snackbar 有适当的边距，符合设计规范
- **涂色游戏关卡恢复**：恢复世界国旗涂色游戏到20关
- **涂色游戏关卡溢出防护**：加强关卡溢出检查，防止解锁或进入超过总关卡数的关卡
  - 在 `onLevelComplete` 中检查关卡数，防止解锁超过总关卡数
  - 在 `onNextLevel` 中检查关卡数，防止进入超过总关卡数的关卡
  - 在 `GameProgressManager.unlockNextLevel` 中添加可选的 `maxLevel` 参数用于防止溢出
  - 在 `aboutToAppear` 中检查关卡有效性，防止进入无效关卡
- **涂色游戏进度显示修复**：修复进度显示超过总关卡数的问题（如18/17）
  - 在加载进度时自动修复超过总关卡数的进度
  - 在进度显示时限制显示值不超过总关卡数
  - 确保进度条和文本显示正确
- **涂色游戏全部完成处理**：当所有关卡完成时，点击游戏入口显示"全部完成"对话框
  - 对话框包含"取消"和"重新开始"按钮
  - 点击"重新开始"会重置进度到第1关并进入游戏
  - 在 GameProgressManager 中添加 `setUnlockedLevel` 方法用于重置进度
- **涂色游戏进度环显示修复**：修复进度环在全部完成时未填满的问题
  - 修复了进度条 value 计算逻辑，当显示 17/17 时进度环会正确填满
  - 将进度条 value 从 `unlockedLevel - 1` 改为 `unlockedLevel`，确保进度显示准确
- **涂色游戏全部完成对话框优化**：使用自定义对话框替代系统对话框，支持深色/浅色模式
  - 创建了 `AllLevelsCompletedDialog` 自定义对话框组件，使用应用颜色资源适配深色/浅色模式
  - 修复了判断逻辑，当进度达到总关卡数（如17/17）时也会显示全部完成对话框
  - 移除了系统对话框 `promptAction.showDialog`，改用应用样式的自定义对话框
  - 在 PaintPlayPage 中添加关卡有效性检查，防止进入超出范围的关卡

### 新增 (Added)
- **分组连线游戏**：从 Flutter 项目移植分组连线（Connections）游戏
  - `ConnectionsLevels.ets` - 关卡数据配置（15关，每关4组，每组4个国旗）
  - `ConnectionsLevelsPage.ets` - 关卡选择页面，支持关卡解锁进度管理
  - `ConnectionsPlayPage.ets` - 游戏主页面，包含完整的游戏逻辑、布局、样式、动画和反馈
  - 游戏功能：
    - 4x4 国旗网格布局，支持选择最多4个国旗
    - 提交验证：检查选择的4个国旗是否属于同一主题分组
    - 已解分组展示：显示已完成的主题分组，包含主题名称和国旗
    - 操作按钮：打乱、取消全选、提交、提示、解答
    - 错误提示：提交错误时显示红色错误提示，3秒后自动消失
    - 游戏提示横幅：显示"创建四个四组！"提示，5秒后自动淡出
    - 提示功能：随机高亮一个未解分组的4个国旗，3秒后取消高亮
    - 解答功能：自动解答所有未解分组
    - 胜利界面：显示所有已解分组和"下一关"、"再玩一次"按钮
    - 关卡进度管理：集成 GameProgressManager，支持关卡解锁和进度保存
  - 动画和反馈：
    - 国旗选择动画：选中时边框变绿、背景变浅绿、轻微放大
    - 提示高亮动画：高亮时边框变橙色、添加阴影效果、轻微放大
    - 错误提示动画：从下方滑入，红色背景
    - 提示横幅淡出动画：5秒后淡出
    - 音效反馈：按钮点击、正确、错误、成功、祝贺音效
    - 震动反馈：选择、正确、错误、成功、胜利震动
  - 主题分组：包含亚洲、欧洲、美洲、非洲、颜色分组、文化分组、地区分组、特殊特征等15个主题
  - 在探索页面添加"分组连线"游戏入口卡片

### 修复 (Fixed)
- **历史国旗页面崩溃问题**：修复了点击历史旗帜时应用崩溃的问题
  - 将排序逻辑从 `build()` 方法移到 `aboutToAppear()` 生命周期方法中
  - 使用 `slice()` 创建数组副本进行排序，避免直接修改原数组
  - 符合 ArkUI 规范：不在 `build()` 方法中执行逻辑操作
- **历史国旗分享功能修复**：修复了分享图片时 "is it a proper image, share type is not supported" 错误
  - 参考 jifen 项目的 ScoreboardRecordDetailPage 实现，采用正确的图片分享方式
  - 使用 `imagePacker.packing()` 方法而不是 `packToData()`，符合 HarmonyOS API 规范
  - 使用同步文件操作（`openSync`, `writeSync`, `closeSync`）简化代码并提高可靠性
  - 将图片格式从 PNG 改为 JPEG，质量设置为 90%（参考 jifen 项目）
  - 使用 `SharePreviewMode.DETAIL` 预览模式，提供更好的分享体验
  - 简化代码逻辑，移除不必要的文件描述符管理和验证步骤
  - 添加详细的日志输出（图片尺寸、文件大小、URI 等），便于调试分享问题
- **国旗详情页分享功能优化**：将文本分享改为图片分享，包含国旗、基本信息和关于这面国旗内容
  - 创建隐藏的分享容器，包含国旗图片、国家名称、基本信息卡片和关于这面国旗卡片
  - 使用图片分享代替文本分享，提供更丰富的视觉体验
  - 参考历史国旗页面的实现方式，使用相同的图片分享技术
  - 分享图片包含完整的国旗信息，方便用户分享到社交媒体
- **州旗详情页分享功能优化**：将文本分享改为图片分享，包含州旗和基本信息内容
  - 创建隐藏的分享容器，包含州旗图片、州名称和基本信息卡片（所属国家、首府、地区）
  - 使用图片分享代替文本分享，提供更丰富的视觉体验
  - 参考国旗详情页的实现方式，使用相同的图片分享技术
  - 分享图片包含完整的州旗信息，方便用户分享到社交媒体
- **国际组织旗帜详情页分享功能优化**：将文本分享改为图片分享，包含旗帜和基本信息内容
  - 创建隐藏的分享容器，包含旗帜图片、组织名称和基本信息卡片（总部、地区、组织类型、覆盖人口、网站、简介）
  - 更新 ShareContentBuilder 以同时支持国家和国际组织
  - 使用图片分享代替文本分享，提供更丰富的视觉体验
  - 分享图片包含完整的组织信息，方便用户分享到社交媒体
- **详情页信息复制功能**：为所有详情页添加点击复制功能
  - 国旗详情页：所有信息项（名称、基本信息、关于这面国旗）可点击复制值
  - 州旗详情页：所有信息项（名称、基本信息）可点击复制值
  - 国际组织详情页：所有信息项（名称、基本信息、简介）可点击复制值
  - 复制后显示"已复制"提示
  - 首次进入任一详情页时显示底部 Snackbar 提示"点击各项内容可复制"，带"知道了"按钮
  - 使用统一的 Preferences key 存储提示显示状态，确保整个应用只显示一次，直到应用卸载
  - 使用 HarmonyOS pasteboard API 实现复制到剪贴板功能
- **涂鸦游戏答案正确时旗帜被遮罩问题**：修复了当所有区域都正确填充后，旗帜看起来被遮罩覆盖的问题
  - 移除了 `#flag-svg.disabled` CSS 样式中的 `opacity: 0.7` 设置
  - 答案正确时旗帜保持清晰可见（opacity: 1），只禁用交互（pointer-events: none）
  - 提升了用户体验，让用户能够清楚看到完成的旗帜效果
- **犹他州涂鸦游戏颜色配置修复**：修复了第11关犹他州的颜色配置问题
  - 将颜色配置从 `['071D49', 'FFFFFF', '071D49']`（蓝色、白色、蓝色）更新为 `['071D49', 'FFFFFF', 'BF0A30']`（蓝色、白色、红色）
  - 现在正确显示为：蓝色顶部、白色中间、红色底部
  - 修复后涂鸦游戏可以正确填充3个颜色区域

### 优化 (Optimized)
- **涂鸦游戏胜利动画速度调整**：将胜利元素（👍）的向上移动动画速度调慢
  - 将成功动画持续时间从 0.5 秒增加到 1 秒
  - 让胜利动画更加优雅和易于观察
- **涂鸦游戏关卡结束动画速度调整**：将关卡完成页面的向上移动动画速度调慢
  - 将关卡完成页面的动画持续时间从 0.5 秒增加到 1.2 秒
  - 将按钮显示延迟从 600ms 调整为 1300ms，确保在动画完成后显示
  - 让关卡完成动画更加优雅和易于观察
- **韩国历史国旗年份修正**：将韩国1912年国旗数据重置为1945年
  - 更新了FlagHistoryData.ets中韩国历史国旗数据，将1912年改为1945年
  - 重命名了对应的PNG文件，从flag_history_kr_1912.png改为flag_history_kr_1945.png
  - 更新了描述文本为"韩国 1945年国旗"
- **朝鲜1948年历史国旗**：将朝鲜当前国旗复制为1948年历史国旗
  - 从朝鲜当前国旗（kp.svg）转换为PNG格式，保存为flag_history_kp_1948.png
  - 补充了朝鲜1948年历史国旗的图片资源（之前数据已存在但缺少图片文件）
- **历史国旗banner显示顺序修复**：修复了国旗详情页历史国旗banner没有显示最早的3个的问题
  - 在FlagDetailPage.ets中，对历史国旗数据按年份升序排序后再取前3个
  - 确保历史国旗banner始终显示最早的3个历史国旗（按年份从早到晚）
- **哥伦比亚1886年历史国旗**：将哥伦比亚当前国旗添加为1886年历史国旗
  - 从哥伦比亚当前国旗（co.svg）转换为PNG格式，保存为flag_history_co_1886.png
  - 在FlagHistoryData.ets中添加1886年的数据条目，标记为"当前"国旗
- **setTimeout定时器资源泄漏修复**：修复了所有游戏页面中setTimeout未清理的问题
  - 为所有游戏页面添加了`timeoutIds`数组和`clearAllTimeouts()`方法
  - 在`aboutToDisappear()`中清理所有未完成的setTimeout
  - 在`loadLevel()`时清理之前的定时器，避免重复执行
  - 修复了以下页面：
    - **QuizPlayPage**：清理selectAnswer、checkAnswer、animateOptions中的setTimeout
    - **TriviaPlayPage**：清理selectOption、checkAnswer、animateOptions中的setTimeout
    - **InputPlayPage**：清理animateFlag、checkAnswer中的setTimeout
    - **FakeFlagPlayPage**：清理selectFlag、checkAnswer、animateFlags中的setTimeout
    - **MemoryPlayPage**：清理flipCard、checkMatch中的setTimeout
    - **PaintPlayPage**：清理onLevelComplete、onPageEnd、onPaintCorrect、onPaintIncorrect中的setTimeout
  - 避免了页面销毁后定时器回调仍然执行导致的潜在崩溃和状态错误
  - 提升了应用的内存管理性能和稳定性

### 删除 (Removed)
- **清理未使用的文件**：删除了项目中未使用的文件和工具类
  - 删除了 `entry/src/main/ets/utils/CoatOfArmsDownloader.ets` - 未使用的国徽下载工具类
  - 删除了 `entry/src/main/ets/utils/CoatOfArmsDatabase.ets` - 未使用的国徽数据库工具类
  - 删除了 `download_anthems.py` - 未使用的Python脚本（根目录）
  - 这些文件的功能已被移除或不再需要（国徽现在从本地资源加载）
  - 详细审查报告已保存到 `docs/FILE_REVIEW.md`

### 新增 (Added)
- **Quiz游戏结果显示图标**：为Quiz游戏添加正确/错误结果显示图标
  - 在选项按钮上添加绿色对勾（✓）显示正确答案
  - 在选项按钮上添加红色叉号（✗）显示错误答案
  - 图标在按钮缩放动画完成后显示（当animatingIndex为-1时）
  - 文字选项的图标显示在右侧，国旗选项的图标显示在左上角
  - 使用Stack布局叠加图标，图标带有圆形背景和淡入动画效果
  - 提升用户对答题结果的视觉反馈体验
- **Trivia游戏结果显示图标**：为Trivia游戏（知识问答）添加正确/错误结果显示图标
  - 在选项按钮上添加绿色对勾（✓）显示正确答案
  - 在选项按钮上添加红色叉号（✗）显示错误答案
  - 添加按钮点击缩放动画效果（点击时放大到1.1倍，然后恢复）
  - 图标在按钮缩放动画完成后显示（当animatingIndex为-1时）
  - 选项图标显示在右侧，使用Stack布局叠加
  - 图标带有圆形背景和淡入动画效果
  - 提升用户对答题结果的视觉反馈体验
- **振动反馈功能**：为所有游戏添加触觉反馈
  - 创建了VibratorUtil工具类，使用HarmonyOS的vibrator API提供振动反馈（参考morse项目实现）
  - 支持四种振动类型：
    - **点击振动（tap）**：轻触反馈，50ms短振
    - **正确答案振动（correct）**：短促两次振动，表示答对
    - **错误答案振动（incorrect）**：中长振动250ms，表示答错
    - **胜利振动（win）**：三次短振，表示完成关卡
  - 为所有游戏页面集成振动反馈：
    - **QuizPlayPage**：选项点击、正确答案、错误答案、按钮点击、完成关卡
    - **MemoryPlayPage**：卡片点击、匹配成功、匹配失败、按钮点击、完成关卡
    - **TriviaPlayPage**：选项点击、正确答案、错误答案、按钮点击、完成关卡
    - **InputPlayPage**：提交答案、正确答案、错误答案、按钮点击、完成关卡
    - **FakeFlagPlayPage**：旗帜点击、正确答案、错误答案、按钮点击、完成关卡
  - 在"我"页面（ProfilePage）添加振动设置开关，默认启用
  - 振动设置使用Preferences持久化存储，可在设置中随时开启/关闭
- **所有游戏音效功能**：为所有游戏添加音效播放功能
  - 从flagame项目复制了14个音效文件（correct、incorrect、button、tap、success、congrats、over等）到rawfile/sfx目录
  - 创建了SoundEffectUtil工具类，使用HarmonyOS的SoundPool API播放音效（参考morse项目实现）
  - 为所有游戏页面集成音效播放：
    - **QuizPlayPage**：正确答案、错误答案、按钮点击、游戏完成、游戏失败
    - **MemoryPlayPage**：卡片匹配成功、匹配失败、游戏完成、游戏失败、按钮点击
    - **TriviaPlayPage**：正确答案、错误答案、按钮点击、游戏完成、游戏失败
    - **InputPlayPage**：正确答案、错误答案、按钮点击、游戏完成、游戏失败
    - **FakeFlagPlayPage**：正确答案、错误答案、按钮点击、游戏完成、游戏失败
    - **PaintPlayPage**：正确答案、错误答案、填色音效、提示音效、按钮点击、关卡完成
  - 所有页面初始化时自动初始化音效播放器，页面销毁时释放资源
  - 移除了轻触音效（tap），避免与结果音效混淆
- **移除游戏反馈Toast**：移除所有游戏页面中的反馈提示toast
  - 移除了TriviaPlayPage中的"✓ 正确!"和"✗ 错误"toast
  - 移除了InputPlayPage中的"✓ 正确!"和"✗ 答案不正确"toast
  - 保留音效反馈，提供更流畅的游戏体验
- **选项逐个出现动画**：为所有有选项的游戏添加选项逐个出现的动画效果
  - **QuizPlayPage**：选项和国旗选项逐个出现，每个选项延迟100ms，使用淡入和缩放动画
  - **TriviaPlayPage**：选项逐个出现，每个选项延迟100ms，使用淡入和缩放动画
  - **FakeFlagPlayPage**：国旗选项逐个出现，每个选项延迟100ms，使用淡入和缩放动画
  - 动画在题目加载和切换到下一题时自动触发，提升视觉体验

### 审查 (Review)
- **项目不一致性审查**：完成项目不一致性审查，发现以下问题
  - **PaintPlayPage缺少VibratorUtil初始化**：涂鸦游戏页面未初始化振动工具，与其他游戏页面不一致
  - **错误处理方式不一致**：使用了5种不同的错误处理方式（JSON.stringify、err.message、类型检查等）
  - **日志记录格式不一致**：使用了多种日志格式（带前缀、模板字符串、混合格式）
  - **路由导航错误处理不一致**：部分页面有错误处理，部分没有
  - **资源初始化顺序不一致**：不同页面的初始化顺序不同
  - **错误变量命名不一致**：使用了err、error、e三种不同的变量名
  - **Promise错误处理不一致**：混用了.catch()和try-catch
  - 详细审查报告已保存到 `docs/INCONSISTENCY_REVIEW.md`
- **项目不完整性审查**：完成项目不完整性审查，发现以下问题
  - **HeadsUpPlayPage缺少音效和振动反馈**：HeadsUp游戏页面未集成音效和振动功能，与其他游戏页面不一致
  - **未使用的音效类型**：SoundEffectUtil中定义了6种未使用的音效类型（POP, KEY, BIP, BER, GUESSED, WRONG）
  - **playSuccess()方法未使用**：方法已实现但从未被调用
  - **资源释放潜在问题**：SoundEffectUtil使用静态单例，多个页面释放资源可能存在竞态条件
  - 详细审查报告已保存到 `docs/INCOMPLETENESS_REVIEW.md`

### 新增 (Added)
- **ProfilePage设置项图标**：为"我"页面的设置项添加图标
  - 为振动反馈设置添加图标（使用`icon_vibration.svg`）
  - 为音效反馈设置添加图标（使用`icon_sound.svg`，从IconPark复制）
  - 为深色模式设置添加动态图标（根据当前模式显示`icon_dark_mode.svg`或`icon_light_mode.svg`）
  - 修改`settingItemWithToggle`方法，添加图标参数支持
  - 添加`getThemeIcon()`方法，根据当前颜色模式返回对应图标
- **音效设置功能**：为SoundEffectUtil添加启用/禁用功能
  - 添加`isEnabled`状态和`prefs`偏好设置存储
  - 添加`setEnabled()`方法设置音效启用状态
  - 添加`isSoundEnabled()`方法检查音效是否启用
  - 在`playSound()`方法中添加启用检查，禁用时不播放音效
  - 在ProfilePage添加音效设置开关，默认启用
  - 音效设置使用Preferences持久化存储，可在设置中随时开启/关闭

### 修复 (Fixed)
- **移除错误的美国1235年国旗数据**：删除FlagHistoryData中错误的美国1235年国旗条目（美国成立于1776年，1235年数据有误），并删除对应的PNG图片文件
- **移除错误的德国1000年国旗数据**：删除FlagHistoryData中错误的德国1000年国旗条目（1000年数据有误），并删除对应的PNG图片文件
- **移除错误的1000年国旗数据**：删除FlagHistoryData中多个国家错误的1000年国旗条目，并删除对应的PNG图片文件
  - 删除的国家包括：安道尔、保加利亚、巴林、布隆迪、巴西、伯利兹、哥斯达黎加、加蓬、英国、格林纳达、圭亚那、海地、吉尔吉斯斯坦、柬埔寨、科摩罗、哈萨克斯坦、列支敦士登、立陶宛、摩纳哥、尼加拉瓜、乌兹别克斯坦
- **PaintPlayPage缺少VibratorUtil初始化**：为涂鸦游戏页面添加振动工具初始化和振动反馈功能
  - 在`aboutToAppear()`中添加`VibratorUtil.init()`初始化
  - 在`onNext()`中添加按钮点击振动反馈
  - 在`onLevelComplete()`中添加关卡完成振动反馈（使用`vibrateWin()`）
  - 在`onNextLevel()`中添加按钮点击振动反馈
  - 在`onHintTapped()`中添加提示按钮点击振动反馈
  - 在返回按钮点击时添加振动反馈
  - 在`onPaintCorrect()`中添加正确答案振动反馈（使用`vibrateCorrect()`）
  - 在`onPaintIncorrect()`中添加错误答案振动反馈（使用`vibrateIncorrect()`）
  - 在完成页面按钮点击时添加振动反馈
  - 现在与其他游戏页面保持一致的用户体验
- **HeadsUpPlayPage缺少音效和振动反馈**：为HeadsUp游戏页面添加音效和振动反馈功能
  - 在`aboutToAppear()`中初始化`SoundEffectUtil`和`VibratorUtil`
  - 在`handleTap()`中添加点击音效和振动反馈
  - 在`continueSession()`和`exitGame()`中添加按钮点击音效和振动反馈
  - 在`aboutToDisappear()`中添加资源释放
  - 现在与其他游戏页面保持一致的用户体验
- **SoundEffectUtil资源释放改进**：使用引用计数机制改进资源管理
  - 添加`refCount`引用计数，跟踪使用`SoundEffectUtil`的组件数量
  - `init()`方法增加引用计数，`release()`方法减少引用计数
  - 只有当引用计数为0时才真正释放资源，避免多个页面同时释放导致的竞态条件
  - 添加详细的日志记录，便于调试和监控资源使用情况
  - 提升了资源管理的健壮性和安全性
- **MemoryPlayPage异步调用bug**：修复记忆游戏页面中缺少await的异步调用问题
  - 修复了`checkMatch()`方法中`SoundEffectUtil.playCorrect()`和`SoundEffectUtil.playIncorrect()`缺少await的问题
  - 将`checkMatch()`方法改为async函数，确保异步调用正确执行
  - 修复了`aboutToDisappear()`中缺少`SoundEffectUtil.release()`的资源释放问题
  - 确保页面销毁时正确释放音效资源，避免资源泄漏
- **记忆游戏国旗翻转问题**：修复记忆游戏中卡片翻转时国旗也被翻转的问题
  - 对国旗图片应用反向旋转，抵消卡片容器的翻转效果
  - 确保国旗在卡片翻转时保持正常方向显示

### 变更 (Changed)
- **游戏页面下一关优化**：所有quiz类游戏页面的"下一关"按钮改为在当前页面重新加载数据，而不是push到新页面
  - 修改了QuizPlayPage、TriviaPlayPage、InputPlayPage、FakeFlagPlayPage、MemoryPlayPage
  - 避免了导航栈过长的问题，提升用户体验
  - 添加了loadLevel方法来统一处理关卡数据的重新加载和状态重置
- **阿富汗历史国旗数据更新**：添加2021年当前国旗，删除1000年数据
  - 从flag folder复制af.svg并转换为PNG格式，保存为flag_history_af_2021.png
  - 在FlagHistoryData.ets中添加2021年的数据条目，标记为"当前"国旗
  - 删除1000年的历史数据条目和对应的PNG文件
- **画廊页面搜索提示优化**：在未找到匹配国家时添加提示文字
  - 在"未找到匹配的国家"下方添加较小的描述文字："修改关键词或选择"全部"或其他大洲"
  - 提示用户可以通过切换chip或修改搜索关键词来查找结果
- **历史国旗资源位置调整**：将所有历史国旗PNG文件移动到rawfile目录
  - 将所有历史国旗PNG文件从 `entry/src/main/resources/base/media/` 移动到 `entry/src/main/resources/rawfile/flag_history/`
  - 更新了 `FlagHistoryPage.ets` 和 `FlagDetailPage.ets`，使用 `$rawfile` 替代 `$r` 来加载历史国旗资源
  - 资源路径格式从 `app.media.flag_history_xx_yyyy` 改为 `flag_history/flag_history_xx_yyyy.png`
  - 更新了 `FLAG_HISTORY_USAGE.md` 文档中的路径说明
- **历史国旗banner优化**：
  - 标题行使用箭头图标（icon_arrow_right），完全复制涂鸦说明banner的样式
  - 整个历史国旗卡片区域可点击，点击后跳转到历史国旗详情页
  - 移除了历史国旗单元格中的年份文本，只显示国旗图片，界面更简洁
  - 移除了单个历史国旗项的点击事件，统一使用卡片点击跳转
- **历史国旗格式转换为PNG**：将所有历史国旗从SVG格式转换为PNG格式
  - 创建了转换脚本 `scripts/convert_flag_history_to_png.js`，使用sharp库将SVG转换为PNG
  - 成功转换2982个历史国旗文件为PNG格式（800x533像素，3:2比例）
  - 删除了所有原始SVG文件，确保只使用PNG格式
  - PNG文件保留在 `entry/src/main/resources/base/media/` 目录，使用 `$r('app.media.${imagePath}')` 加载
- **历史国旗标题添加箭头并支持点击跳转**：在历史国旗标题旁边添加右箭头图标
  - 完全复制涂鸦说明banner的箭头样式（icon_arrow_right），像素级保持一致
  - 整个历史国旗卡片区域可点击，点击后跳转到历史国旗详情页
  - 移除了单个历史国旗项的点击事件，统一使用卡片点击跳转
  - 箭头颜色自动适配明暗模式
- **历史国旗单元格优化**：移除历史国旗单元格中的年份文本，只显示国旗图片，界面更简洁
- **国旗详情页历史国旗显示优化**：优化历史国旗banner的显示
  - 历史国旗只显示一行，最多显示3个项目（前三个）
  - 移除了"查看全部"箭头按钮，界面更简洁
- **国徽资源位置调整**：将所有PNG格式的国徽文件移动到rawfile目录
  - 将198个PNG国徽文件从 `entry/src/main/resources/base/media/` 移动到 `entry/src/main/resources/rawfile/coat_of_arms/`
  - 更新了 `coatOfArmsUtil.ets`，使用 `$rawfile` 替代 `$r` 来加载国徽资源
  - 资源路径格式从 `app.media.coat_of_arms_xx` 改为 `coat_of_arms/coat_of_arms_xx.png`
  - 所有国徽文件（包括之前转换失败的kg、nl、rs）已全部完成转换并移动到rawfile目录
  - 将198个原始SVG国徽文件移动到项目根目录的 `coat of arms svg backup/` 文件夹作为备份
- **国徽格式转换为PNG**：将所有国徽从SVG格式转换为PNG格式
  - 创建了转换脚本 `scripts/convert_coats_to_png.js`，使用sharp库将SVG转换为PNG
  - 转换后的PNG图片尺寸为512x512，保持透明背景
  - FlagDetailPage.ets 已正确支持显示PNG格式的国徽
  - 转换脚本支持多种参数：
    - `--clean`: 转换后删除原SVG文件
    - `--force`: 强制重新转换已存在的PNG文件
    - `--retry`: 只转换之前失败的文件（kg, nl, rs）
  - 改进了转换脚本的错误处理，支持多种转换方法：
    - 自动处理UTF-16编码的SVG文件
    - 对于复杂SVG，自动尝试降低分辨率
    - 提供详细的错误信息和建议
- **历史国旗详情页UI优化**：改进历史国旗详情页的显示效果
  - 在左侧添加时间线效果（竖线和圆点），更清晰地展示时间顺序
  - 将国旗图片宽度调整为60%，使显示更紧凑
  - 减少每个单元格头部的高度（年份标签底部间距从12px减少到8px）
  - 将时间线上的圆点颜色改为主蓝色（button_primary），更加醒目
  - 减少单元格/行的整体高度：
    - 国旗图片高度从200px减少到120px
    - 单元格内边距从16px减少到12px
    - 图片底部间距从20px减少到8px
    - 行之间的间距从16px减少到12px
- **所有游戏关卡完成按钮优化**：将"再来一次"按钮改为"下一关"或"完美收官"
  - Quiz游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - FakeFlag游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - Input游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - Trivia游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - Memory游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - Paint游戏：非最后一关显示"下一关"，最后一关显示"完美收官"，点击退出
  - 点击"下一关"会自动跳转到下一关，点击"完美收官"会退出游戏

### 删除 (Removed)
- **删除无效的anthems目录**：删除了 `entry/src/main/resources/base/media/anthems` 目录（导致编译错误的无效路径）
- **清理未使用和重复文件**：删除了项目根目录下的未使用和重复文件
  - 删除了 `Flag_of_FIAV.svg 1.png`（重复文件，FIAV PNG已正确放置在 `entry/src/main/resources/base/media/flag_fiav.png`）
  - 删除了 `download_anthems.py`（未使用的Python脚本）
  - 删除了 `IconPark - Icons Pack (Community)/` 目录（未使用的图标包，占用11MB空间，项目使用app.media中的图标资源）
  - 删除了临时报告和评估文件：
    - `UNUSED_FILES_REPORT.md`
    - `CODE_REVIEW_2025-12-08_FULL.md`
    - `CODE_REVIEW_2025-12-08.md`
    - `PROJECT_EVALUATION.md`

### 修复
- **州旗列表页顶部区域间距优化**：修复州旗列表页顶部国家信息卡片的间距问题
  - 将顶部卡片的 padding 从 20 调整为 24，与专题详情页保持一致
  - 移除了顶部卡片的底部 margin，统一间距样式
  - 为网格添加顶部 padding（top: 16），修复网格没有顶部间距的问题
  - 参考 TopicDetailPage 的实现，保持页面样式一致性
- **涂鸦游戏WebView渐显效果**：为涂鸦游戏的WebView添加了平滑的渐显动画效果
  - 使用`animateTo` API替代`setTimeout`，实现更平滑的渐显动画
  - 添加了`transition`效果，动画时长400ms，使用`cubicBezier(0.42, 0, 0.58, 1)`缓动曲线（easeInOut效果）
  - WebView初始透明度为0，在页面加载完成并设置好背景色和游戏后，平滑渐显到完全不透明
  - 提升了用户体验，避免了WebView内容的突然出现
  - 修复了编译错误：使用`curves.cubicBezier`替代不存在的`curves.easeInOut`
- **涂鸦游戏深色模式检测优化**：改进了深色模式的检测和背景色处理
  - 新增`detectDarkMode()`方法，单独处理深色模式检测（参考injectSVG的方式）
  - 使用两种方法检测深色模式，按优先级：
    1. 读取保存的主题设置（Preferences）- 最可靠的方法
    2. 通过资源管理器检测系统主题（跟随系统模式时使用）
  - 在WebView页面加载完成时（onPageEnd）重新检测并更新背景色，确保获取最新的颜色模式
  - 根据深色模式正确设置背景色：深色模式使用`#1C1C1E`，浅色模式使用`#F5F6F7`
  - 确保背景色在设置游戏之前正确注入，避免背景色闪烁
  - 修复了编译错误：移除了不存在的`ApplicationContext.getColorMode()`方法调用
  - 添加了详细的调试日志，帮助诊断深色模式检测问题
  - 改进了系统主题检测逻辑，正确处理colorMode为0（浅色）和1（深色）的情况
- **移除探索页面历史国旗功能**：从探索页面移除了历史国旗卡片和相关功能
  - 移除了`hasAnyHistory`导入和`hasHistory`状态变量
  - 移除了历史国旗卡片UI和路由跳转
  - 简化了探索页面，只保留游戏相关功能
- **专题顺序调整**：将国际组织专题移到相似旗专题后面
- **FIAV旗帜显示**：修复旗帜学协会国际联盟（FIAV）旗帜显示问题
  - 修改getFlagImageSource函数，让FIAV使用PNG格式（与其他国际组织一致）
  - 移除了rawfile/flags目录下的fiav.svg文件
  - 添加了`flag_fiav.png`文件到`entry/src/main/resources/base/media/`目录
  - FIAV旗帜现在可以正常显示，不再变形

### 新增
- 在国旗详情页底部（国徽前面）添加历史国旗banner，使用Grid展示历史国旗，点击可进入历史国旗详情页

### 重大更新
- **历史国旗数据全面更新**：重新提取和下载所有历史国旗数据
  - 数据量从249条增加到1411条（增长466%）
  - 国家数量从53个增加到195个（覆盖所有大洲）
  - 包含法国、英国、美国、中国等所有主要国家
  - **修复提取逻辑**：从每个单元格中提取图片和年份（而不是从表头），确保图片和年份正确对应
  - 下载了1411张历史国旗图片（450个新下载，961个已存在，0个失败）
  - 修复了图片和年份不匹配的问题

### 修复
- 修复历史国旗数据加载时机问题，确保在设置国家信息后立即加载历史国旗数据
- 修复历史国旗提取脚本，改进法国和英国的国家名称匹配逻辑，确保能正确识别这些国家
  - 将法国和英国的匹配逻辑提前，优先匹配这些常见国家
- 修复阿联酋历史国旗顺序：将1968年和1200年的顺序调整为正确的历史时间线
- 修复历史国旗提取逻辑：从表格列标题提取年份，而不是从单元格内容中提取，确保图片和年份正确对应

### 优化
- 历史国旗详情页：移除国旗图片的容器和背景，让国旗直接显示，保持原始外观
- 历史国旗详情页：移除每个国旗下方的描述文本，只显示年份和国旗图片
- 历史国旗banner：移除"查看全部"文本，只保留箭头符号，箭头颜色与标题文本颜色一致

## [未发布]

### 修复 (Fixed)
- **国徽下载脚本**：修复下载脚本中缺失的14个国家代码
  - 添加了缺失的国家：ao (安哥拉)、cd (刚果(金))、cf (中非)、cg (刚果(布))、cm (喀麦隆)、cy (塞浦路斯)、dm (多米尼克)、ga (加蓬)、gq (赤道几内亚)、hu (匈牙利)、kn (圣基茨和尼维斯)、ng (尼日利亚)、st (圣多美和普林西比)、td (乍得)
  - 手动下载了dm和kn的国徽（API有数据但脚本未下载）
  - 手动添加了cd (刚果(金))的国徽文件（从项目根目录移动到media文件夹并重命名为coat_of_arms_cd.svg）
  - 当前共有198个国徽文件（195个国家中，195个都有国徽）
- **移除运行时下载功能**：由于所有国徽已预下载到media文件夹，移除了运行时下载相关代码
  - 从 `ProfilePage.ets` 中移除了下载所有国徽的设置项和相关UI
  - 移除了 `CoatOfArmsDownloader` 和 `CoatOfArmsDatabase` 的引用
  - 国徽现在完全通过 `coatOfArmsUtil.ets` 从本地资源加载，无需运行时下载

## [未发布]

### 新增 (Added)
- **旗帜学协会国际联盟**：添加旗帜学协会国际联盟（FIAV）到国际组织列表
  - 组织代码：`fiav`
  - 中文名称：旗帜学协会国际联盟
  - 英文名称：Fédération internationale des associations vexillologiques
  - 总部：休斯顿 / 伦敦
  - 网站：http://www.fiav.org
  - 简介：旗帜学协会国际联盟是致力于旗帜学研究与推广的国际组织，成立于1969年，由惠特尼·史密斯创立。拥有55个成员协会及组织，促进全球旗帜学知识的交流与发展。协会旗帜图案为一个接绳结。
- **国际组织网站信息**：为所有国际组织添加网站信息
  - 在 `InternationalOrg` 接口中添加 `website` 字段（可选）
  - 在国际组织详情页显示网站信息（不可点击的文本）
  - 在朗读内容和分享内容中包含网站信息
  - 已添加网站的组织：联合国、欧盟、奥林匹克、北约、东盟、非盟、阿盟、红十字会、旗帜学协会国际联盟
- **国际组织简介**：为所有国际组织添加简介信息
  - 在 `InternationalOrg` 接口中添加 `description` 字段（可选）
  - 在国际组织详情页显示简介（在网站信息下方）
  - 创建 `DescriptionItem` 方法用于显示多行文本简介
  - 在朗读内容和分享内容中包含简介信息
  - 已为所有9个国际组织添加了详细的简介内容

## [未发布]

### 新增功能 (Added)
- **国旗礼仪专题**：新增国旗礼仪与规范知识专题
  - 在专题列表中添加"国旗礼仪"专题，包含国旗在国际场合的使用规范和礼仪知识
  - 内容包括：升旗流程、悬挂顺序、悬挂方式、使用场合、礼仪规范、常见错误等6个部分
  - 专题详情页支持知识性内容展示，以滚动列表形式展示知识内容
  - 创建 `FlagEtiquetteData.ets` 数据文件，包含完整的国旗礼仪知识内容
  - 扩展专题系统，支持知识性专题（countryCodes为空数组时显示知识内容而非国旗列表）
- **国旗制作专题**：新增国旗制作知识专题
  - 在专题列表中添加"国旗制作"专题，包含国旗制作的完整知识体系
  - 内容包括：制作流程、制作材料、制作工艺、制作工厂、质量标准、制作成本等6个部分
  - 详细介绍国旗从设计到生产的全过程，包括材料选择、工艺技术、工厂资质等
  - 创建 `FlagManufacturingData.ets` 数据文件，包含完整的国旗制作知识内容
  - 优化知识性专题展示逻辑，支持多个知识性专题的展示
- **旗帜学专题**：新增旗帜学（国旗学）知识专题
  - 在专题列表中添加"旗帜学"专题，包含旗帜学的基础知识和研究方法
  - 内容包括：旗帜学概述、旗帜分类、设计原则、历史演变、研究方法、著名学者、旗帜象征等7个部分
  - 系统介绍旗帜学学科的定义、研究范围、分类体系、设计原则等核心内容
  - 创建 `FlagVexillologyData.ets` 数据文件，包含完整的旗帜学知识内容
  - 完善知识性专题系统，支持更多类型的知识内容展示
- **五星红旗历史专题**：新增五星红旗历史知识专题
  - 在专题列表中添加"五星红旗历史"专题，详细介绍五星红旗的历史
  - 内容包括：设计背景、设计过程、设计细节、首次升起、法律地位、使用规范、文化意义、历史演变等8个部分
  - 系统介绍五星红旗从设计到使用的完整历史，包括设计者曾联松、开国大典、国旗法等内容
  - 创建 `FlagHistoryData.ets` 数据文件，包含完整的五星红旗历史知识内容
  - 进一步扩展知识性专题系统，支持更多专题类型
- **蓝船旗专题**：新增蓝船旗（米字旗）专题
  - 在专题列表中添加"蓝船旗"专题，展示使用蓝船旗的英联邦国家
  - 蓝船旗来自英国的民用船旗，米字旗代表前英国殖民地，象征为英联邦成员
  - 包含国家：澳大利亚、新西兰、斐济、图瓦卢
  - 这些国家的国旗都包含英国米字旗（Union Jack）元素，体现其历史渊源
- **泛斯拉夫旗专题**：新增泛斯拉夫旗专题
  - 在专题列表中添加"泛斯拉夫旗"专题，展示采用泛斯拉夫色彩的国旗
  - 泛斯拉夫色彩为红、白、蓝三色，代表斯拉夫民族的团结
  - 包含国家：俄罗斯、塞尔维亚、斯洛伐克、斯洛文尼亚、克罗地亚、捷克
  - 这些国家的国旗都采用红、白、蓝三色组合，体现斯拉夫文化传统
- **泛中美洲联邦色旗专题**：新增泛中美洲联邦色旗专题
  - 在专题列表中添加"泛中美洲联邦色旗"专题，展示采用中美洲联邦色彩的国旗
  - 中美洲联邦国旗，蓝色代表加勒比海和太平洋，白色代表和平
  - 很多前中美洲联邦共和国的成员国采用这种色彩组合
  - 包含国家：萨尔瓦多、洪都拉斯、尼加拉瓜
  - 这些国家的国旗都采用蓝、白、蓝三色条纹设计，体现中美洲联邦的历史传统
- **泛米兰达色旗专题**：新增泛米兰达色旗专题
  - 在专题列表中添加"泛米兰达色旗"专题，展示采用米兰达色彩的国旗
  - 该旗为弗朗西斯科·德·米兰达于南美独立运动所用的旗帜
  - 其中红色代表南美洲，黄色代表西班牙，蓝色代表海
  - 后为前大哥伦比亚共和国的会员国采用
  - 包含国家：哥伦比亚、委内瑞拉、厄瓜多尔
  - 这些国家的国旗都采用黄、蓝、红三色组合，体现南美独立运动的历史渊源
- **相似旗专题**：新增相似旗专题
  - 在专题列表中添加"相似旗"专题，展示相似度较高的国旗
  - 一些国家的国旗相似度较高，仅在比例、颜色深度或细节上有所不同
  - 包含相似国旗组合：
    - 摩纳哥和印尼（红白横条，比例不同：4:5 vs 2:3）
    - 荷兰和卢森堡（红白蓝横条，比例和颜色深度不同）
    - 罗马尼亚和乍得（蓝黄红竖条，蓝色深度不同）
    - 中国和越南（红色底+五角星，星星数量不同）
    - 肯尼亚和南苏丹（色彩相似）
    - 安道尔和摩尔多瓦（竖条+徽章）
    - 伊朗和塔吉克斯坦（横条+徽章）
    - 爱尔兰和科特迪瓦（竖条，颜色顺序不同）
  - 包含国家：摩纳哥、印尼、荷兰、卢森堡、罗马尼亚、乍得、中国、越南、肯尼亚、南苏丹、安道尔、摩尔多瓦、伊朗、塔吉克斯坦、爱尔兰、科特迪瓦

### 优化 (Optimized)
- **专题页面滚动效果**：为专题列表页和专题详情页添加bounce滚动效果
  - 专题列表页（TopicListPage）的List组件添加Spring边缘效果
  - 专题详情页的国旗列表（FlagListView）使用Scroll包裹Grid，添加Spring边缘效果
  - 知识性专题内容列表已支持Spring边缘效果
- **文字类专题朗读功能**：为知识性专题添加朗读功能
  - 在专题详情页导航栏添加朗读按钮（仅知识性专题显示）
  - 支持朗读所有知识性专题内容，包括：国旗礼仪、国旗制作、旗帜学、五星红旗历史
  - 参考国旗详情页面的实现，使用TextReaderUtil进行文本朗读
  - 实现getReadContent方法，将所有章节内容组合为完整文本
  - 页面销毁时自动停止朗读，避免资源泄漏
  - 提供开始/停止朗读的交互反馈
- **国徽预下载和显示功能**：新增国徽预下载和显示功能
  - 创建 `scripts/download_coats_of_arms.js` 脚本，用于批量下载所有国家的国徽到media文件夹
  - 国徽文件保存为 `coat_of_arms_xx.svg` 格式（如 `coat_of_arms_cn.svg`），存储在 `entry/src/main/resources/base/media/` 目录
  - 创建 `coatOfArmsUtil.ets` 工具类，提供 `getCoatOfArmsImageSource()` 方法从media文件夹加载国徽资源
  - 在国旗详情页面顶部显示国徽（仅国家，不包括国际组织）
  - 国徽作为应用资源文件打包，无需运行时下载，提升加载速度
  - 使用 `$r('app.media.coat_of_arms_xx')` 方式引用国徽资源

### 调整 (Changed)
- **专题排序调整**：重新排序专题列表，文字类专题排在前面
  - 第一个：旗帜学
  - 第二个：国旗礼仪
  - 第三个：国旗制作
  - 第四个：五星红旗历史
  - 第五个：相似旗（特殊UI）
  - 其他专题按原有顺序排列
- **相似旗专题UI优化**：为相似旗专题创建独立UI展示
  - 每行显示两个相似国旗的组合
  - 顶部显示"xxx和xxx"的标题（如"摩纳哥和印尼"）
  - 两个国旗并排显示，点击可跳转到对应国旗详情页
  - 包含8组相似国旗：摩纳哥和印尼、荷兰和卢森堡、罗马尼亚和乍得、中国和越南、肯尼亚和南苏丹、安道尔和摩尔多瓦、伊朗和塔吉克斯坦、爱尔兰和科特迪瓦
  - 使用卡片式布局，提升视觉效果和用户体验

### 修复 (Fixed)
- **涂鸦游戏-美国州旗路径ID顺序修复**：修复多个美国州旗关卡无法完成的问题
  - 修正了得克萨斯州SVG文件中路径ID与颜色配置的对应关系
    - 调整了路径结构，使左侧竖条（蓝色）、右侧上半部分（白色）、右侧下半部分（红色）与颜色配置顺序匹配
  - 修正了爱荷华州SVG文件中路径ID顺序
    - 调整了路径结构，使左侧（蓝色）、中间（白色）、右侧（红色）与颜色配置顺序匹配
  - 修正了北卡罗来纳州SVG文件中路径ID顺序
    - 调整了路径结构，使左侧（蓝色）、上半部分（红色）、下半部分（白色）与颜色配置顺序匹配
  - 修正了田纳西州SVG文件中路径ID顺序
    - 添加了缺失的路径ID，使背景（红色）、右侧竖条（白色）、内部竖条（蓝色）与颜色配置顺序匹配
  - 修正了马萨诸塞州颜色配置
    - 更新颜色配置为两个颜色：白色（背景）和蓝色（中心盾牌）
    - SVG文件已包含正确的路径ID顺序（id="1"白色背景，id="2"蓝色中心）
  - 修正了俄亥俄州SVG文件中路径结构
    - 将右侧红色和白色条纹分开，使用group组织路径
    - id="1"包含所有红色部分（左侧三角形+右侧红色条纹）
    - id="2"包含蓝色中心圆形
    - 保持原有颜色配置不变：['BF0A30', 'FFFFFF', '002868']
  - 调整美国第4关配置
    - 从美国第4关移除俄亥俄州，现在只包含2个州旗：伊利诺伊州和密歇根州
  - 调整美国第5关配置
    - 从美国第5关移除北卡罗莱纳州，现在只包含2个州旗：佐治亚州和弗吉尼亚州
  - 调整美国第7关配置
    - 从美国第7关移除田纳西州，现在只包含2个州旗：印第安纳州和密苏里州
  - 调整美国第8关配置
    - 从美国第8关移除马里兰州，现在只包含2个州旗：威斯康星州和明尼苏达州
  - 修正明尼苏达州颜色配置和SVG路径结构
    - 添加白色背景和金色星星，现在包含三个颜色：蓝色、白色、金色
    - 颜色配置更新为：['001F5B', 'FFFFFF', 'FFD700']
    - 调整SVG路径ID顺序：id="1"蓝色三角形，id="2"白色背景，id="3"金色星星

## [1.0.7] - 2025-12-08

### 修复 (Fixed)
- **网络权限问题**：修复朗读功能选择官方声音（男声/女声）时提示"网络未连接"的问题
  - 在 `module.json5` 中添加 `ohos.permission.INTERNET` 网络权限
  - 添加网络权限使用说明字符串资源
  - 允许应用访问网络以下载语音模型和使用在线语音服务

### 优化 (Optimized)
- **涂鸦游戏暗黑模式**：优化涂鸦游戏在暗黑模式下的背景色
  - 暗黑模式下使用深黑色背景（#1C1C1E，非纯黑）
  - 浅色模式下保持灰色背景（#F5F6F7）
  - 根据系统主题自动切换背景色

## [未发布]

### 修复 (Fixed)
- **涂鸦游戏-美国州旗路径ID顺序修复**：修复多个美国州旗关卡无法完成的问题
  - 修正了得克萨斯州SVG文件中路径ID与颜色配置的对应关系
    - 调整了路径结构，使左侧竖条（蓝色）、右侧上半部分（白色）、右侧下半部分（红色）与颜色配置顺序匹配
  - 修正了爱荷华州SVG文件中路径ID顺序
    - 调整了路径结构，使左侧（蓝色）、中间（白色）、右侧（红色）与颜色配置顺序匹配
  - 修正了北卡罗来纳州SVG文件中路径ID顺序
    - 调整了路径结构，使左侧（蓝色）、上半部分（红色）、下半部分（白色）与颜色配置顺序匹配
  - 修正了田纳西州SVG文件中路径ID顺序
    - 添加了缺失的路径ID，使背景（红色）、右侧竖条（白色）、内部竖条（蓝色）与颜色配置顺序匹配

## [1.0.6] - 2025-12-08

### 新增功能 (Added)
- **HeadsUp 功能**：在探索页面新增 HeadsUp 游戏模式
  - 全屏显示，随机展示国旗
  - 点击屏幕查看答案，再次点击进入下一题
  - 每轮包含 10 个题目
  - 完成一轮后显示结束界面，可选择继续或退出
  - 支持多轮游戏，记录完成的轮数
- **专题新增**：在专题列表中添加太阳旗和星月旗专题
  - 太阳旗专题：包含 10 个国旗上绘有太阳图案的国家
  - 星月旗专题：包含 12 个国旗上绘有星月标志的国家

### 调整 (Changed)
- **专题顺序调整**：将太阳旗和星月旗专题移动到国旗上的动物专题之前
- **国旗上的动物专题**：从专题中移除玻利维亚、巴拉圭、秘鲁；添加塞尔维亚、黑山、埃及
- **涂鸦页面背景色优化**：涂鸦页面背景色固定为灰色（#F5F6F7），与页面背景色一致
- **国旗格式调整**：所有国家国旗统一使用SVG格式
  - 画廊页面和国旗详情页已支持PNG和SVG自动切换
  - 首页热门国旗和本周国旗已更新为支持PNG和SVG格式
  - 仅国际组织使用PNG格式，所有国家都使用SVG格式

### 优化 (Optimized)
- **专题详情页性能优化**：优化专题详情页列表渲染性能
  - 移除不必要的 setTimeout 延迟，改为同步加载数据
  - 使用 @Builder 提取 GridItem 内容，减少重复渲染
  - 为 ForEach 添加唯一 key 标识符，提升列表更新效率
  - 添加 Grid 缓存配置（cachedCount），提升滚动性能
  - 添加路由错误处理，提升稳定性

### 调整 (Changed)
- **关卡列表页UI调整**：移除所有关卡列表页中的emoji显示
  - 移除锁定状态的"🔒"emoji显示
  - 已解锁关卡仅显示箭头图标，未解锁关卡不显示任何图标
  - 涉及页面：看旗猜国名/看名猜国旗、知识问答、拼写挑战、记忆翻牌、假旗找茬

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
