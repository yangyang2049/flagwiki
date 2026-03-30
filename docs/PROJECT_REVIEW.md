# FlagWiki 项目审查报告（缺陷、不完整性与不一致）

**审查日期**：2026-03-30  
**审查方式**：静态代码与配置扫描、与既有文档交叉核对、关键路径抽样阅读  
**仓库状态**：当前工作区非 Git 仓库（若日后纳入版本控制，请特别注意下文「安全与敏感信息」一节）

---

## 1. 执行摘要

| 类别 | 结论 |
|------|------|
| **阻塞级 bug** | 未发现明显会导致必然崩溃的单一逻辑错误（需真机/自动化测试进一步验证） |
| **不完整** | 单元测试近乎占位；部分音效资源已加载但业务未使用；发布混淆未启用 |
| **不一致** | 错误处理与日志风格仍不统一；路由 `pushUrl` 多数无 `.catch()`；旧版 `docs/INCOMPLETENESS_REVIEW.md` / `docs/INCONSISTENCY_REVIEW.md` 与当前代码已不一致 |
| **安全/运维** | `build-profile.json5` 含本机绝对路径与加密密钥材料，不适合公开分发 |

---

## 2. 与既有文档的差异（文档陈旧）

以下文档中的 **具体问题描述已部分过时**，以代码为准：

| 文档 | 说明 |
|------|------|
| `docs/INCOMPLETENESS_REVIEW.md` | 称 `HeadsUpPlayPage` 未集成音效/振动；**当前代码已初始化 `SoundEffectUtil` / `VibratorUtil` 并在交互中调用** |
| `docs/INCONSISTENCY_REVIEW.md` | 称 `PaintPlayPage` 未初始化 `VibratorUtil`；**当前已初始化并在多处调用振动** |
| 上述文档日期占位为 `2025-01-XX` | 建议更新或合并到本报告，避免误导 |

**建议**：将历史审查结论归档为「已修复」或合并为单一 `PROJECT_REVIEW.md`，并标注修复提交或日期。

---

## 3. 缺陷与风险（Bugs / Risks）

### 3.1 发布构建：混淆未启用（与 `BUNDLING_RELEASE_REVIEW.md` 一致）

`entry/build-profile.json5` 中 `release` 的 `arkOptions.obfuscation.ruleOptions.enable` 为 **`false`**，发布包未做 Ark 混淆，不利于体积与逆向防护。

### 3.2 敏感信息暴露在工程配置中

根目录 `build-profile.json5` 包含：

- 本机绝对路径（证书、profile、密钥库）
- 加密存储的密码字段

若工程将上传至公共 Git 或共享给第三方，存在**凭证与路径泄露**风险。建议：使用本地覆盖配置、环境变量或私有 CI 密钥，且勿将真实签名材料提交到公开仓库。

### 3.3 `SoundEffectUtil` 与 `VibratorUtil` 生命周期不对称（低优先级）

- `SoundEffectUtil` 已实现 **引用计数** + `release()`，与多页面进出场景匹配较好。
- `VibratorUtil` **无 `release()`**，各页面重复 `init` 依赖 prefs 重读；当前实现可视为轻量，但若未来在 `init` 中持有需释放的资源，需再对齐生命周期。

---

## 4. 不完整（Incompleteness）

### 4.1 单元测试

`entry/src/test/LocalUnit.test.ets` 仍为 Hypium 模板级示例（`assertContain` 等），**未覆盖业务逻辑**（数据解析、游戏进度、路由、工具类等）。

### 4.2 音效枚举与资源

`SoundEffectUtil` 加载了 `POP`、`KEY`、`BIP`、`BER`、`GUESSED`、`WRONG` 等类型，但工程内 **除加载列表外几乎无 `playSound(SoundType.xxx)` 调用**（实际播放以 `CORRECT`/`BUTTON`/`HINT`/`TAP` 等为主，`playSuccess()` 在 `ConnectionsPlayPage` 等有使用）。

影响：略增启动加载与内存；若长期不用可考虑删减枚举与 rawfile，或补全使用场景。

### 4.3 国际化与硬编码文案

`HARDCODED_TEXTS_REVIEW.md`（2026-01-22）已系统列出约 190 处硬编码字符串，**首页趣味事实、地区映射、个人页对话框等仍以中文资源或代码内字符串为主**，与完整 `en_US` 资源并行的工程化目标仍有差距。

---

## 5. 不一致（Inconsistencies）

### 5.1 错误与日志格式

仍存在多种风格并存，例如：

- `JSON.stringify(err)`、`err.message`、`err instanceof Error ? … : String(err)`、`BusinessError` 的 `code`/`message` 混用。

不利于日志检索与崩溃分析；`docs/INCONSISTENCY_REVIEW.md` 中的统一建议仍然适用。

### 5.2 路由错误处理

`router.pushUrl` 在部分页面使用 `.catch()` 记录失败，**多数调用处无 Promise 捕获**，导航失败时用户可能无感知。是否全局封装导航工具函数，可按产品优先级决定。

### 5.3 设备与模块

- `module.json5` 中 `deviceTypes` 含 **wearable**，手机与手表共用 `entry` 模块；`EntryAbility` 通过 `DeviceHelper.isWearable()` 加载 `pages/watch/Index` 或 `pages/Index`，设计清晰。
- 手表端 `LearnPage` / `PracticePage` / `SettingsPage` / `WatchPrivacyAgreement` 作为 **子组件** 嵌入手表 `Index`，无需全部列入 `main_pages.json`，与当前 `main_pages.json` 中仅注册需 **独立路由** 的页面一致。

---

## 6. 已核对项（当前代码与历史问题对照）

以下历史问题 **在当前代码中已不存在或已缓解**，审查时已确认：

- `HeadsUpPlayPage`：已集成音效与振动（见 `HeadsUpPlayPage.ets`）。
- `PaintPlayPage`：已初始化 `VibratorUtil` 并多处调用。
- `SoundEffectUtil`：已使用引用计数；`playSuccess()` 至少在 `ConnectionsPlayPage` 中使用。
- 所有调用 `SoundEffectUtil.init` 的游玩页均对应有 `SoundEffectUtil.release`（8 处成对出现）。

---

## 7. 建议优先级

| 优先级 | 项 |
|--------|-----|
| 高 | 若对外发布：处理签名与密钥路径，避免泄露；评估开启 release 混淆。 |
| 中 | 统一错误/日志规范；为关键导航补充失败处理或统一封装。 |
| 中 | 按 `HARDCODED_TEXTS_REVIEW.md` 路线图推进 i18n，减少硬编码。 |
| 低 | 清理未使用音效类型或补全使用场景；补充真实单元测试。 |
| 低 | 更新或合并 `docs/INCOMPLETENESS_REVIEW.md`、`docs/INCONSISTENCY_REVIEW.md`，标注过时结论。 |

---

## 8. 参考文档索引

| 文件 | 用途 |
|------|------|
| `HARDCODED_TEXTS_REVIEW.md` | 硬编码字符串与国际化路线图 |
| `BUNDLING_RELEASE_REVIEW.md` | 打包、混淆与发布项 |
| `docs/DUPLICATE_FILES_REVIEW.md` | 资源重复与命名说明 |
| `docs/FILE_REVIEW.md` | 其他文件级说明（若存在） |

---

*本报告基于当前工作区快照生成；行为级 bug 需结合 DevEco 运行、HarmonyOS 版本与真机/模拟器回归验证。*
