# 代码审查问题清单

## 2025-12-07 审查问题

### 已修复 ✅

1. ~~BonusTaxPage.ets 合并计税计算错误（高）~~ **已修复**
- **位置**: `entry/src/main/ets/pages/tools/BonusTaxPage.ets`
- **问题**: 合并计税分支直接用"总收入+年终奖"的档位税率和速算扣除数去计算工资税额与合计税额，随后相减；当年终奖把综合收入推入更高档位时，工资部分实际应该按原档位计税，当前算法会高估或低估税额。
- **修复方案**: 
  - 创建了 `calculateAnnualTax()` 辅助方法，正确计算年度应纳税额
  - 分别计算"工资-起征点"和"工资+年终奖-起征点"的税额，再取差值
  - 确保每个收入档使用各自对应的税率和速算扣除数
  - 修复了税率档位跨越时的计算错误

2. ~~SalaryTaxPage.ets 预扣逻辑与累计预扣法不符（高）~~ **已修复**
- **位置**: `entry/src/main/ets/pages/tools/SalaryTaxPage.ets`
- **问题**: 税额用"当月应税额×12"套年度税表后再除12，未考虑累计月份、已预扣税额和减除费用累计，且社保/公积金费率与封顶值固定为北京口径。实际按累计预扣会在中高收入、多月场景产生明显偏差。
- **修复方案**:
  - 添加了"当前月份"输入字段（1-12月）
  - 创建了 `calculateTaxFromAnnualBrackets()` 辅助方法
  - 实现了正确的累计预扣公式：当月应预扣税额 = 累计应纳税额 - 累计已预扣税额
  - 根据当前月份计算累计应纳税所得额（假设每月收入相同）
  - 添加了说明文字："使用累计预扣法计算，假设每月收入相同"
  - 社保/公积金封顶值已随城市配置动态加载

4. ~~InputValidator.validateIntegerInput 无法保持空值（低）~~ **已修复**
- **位置**: `entry/src/main/ets/utils/inputValidator.ets`
- **问题**: 清空整数输入时会返回 '0'，导致贷款期限、滞纳天数等字段无法真正置空，用户删除内容后立即变成0，既触发校验错误又影响输入体验。
- **修复方案**:
  - 添加了 `allowEmpty` 参数（默认为 true）
  - 当允许空值时，空字符串直接返回，不强制填充0
  - 用户可以正常清空整数输入字段
  - 上层逻辑可以自行决定是否必填

3. ~~TaxCalendarPage.ets 数据与计算脱节（中）~~ **已修复**
- **位置**: `entry/src/main/ets/pages/tools/TaxCalendarPage.ets`
- **问题**: 页面仅计算"本月或下月15日"倒计时，`deadlines` 列表中 5/31 汇算、6/30 个税年报等节点没有参与计算；周末顺延只应用在15日，年度节点/半年度节点未校正，导致显示的"下次申报截止"与实际常用节点不符。
- **修复方案**:
  - 重写了 `calculateNextDeadline()` 方法，遍历所有 deadlines 数据
  - 支持月度申报（次月15日）和年度节点（month + day）的综合计算
  - 对所有节点统一应用周末顺延逻辑
  - 支持跨年计算，年度节点过期后自动计算下一年度的日期
  - 选择距离当前日期最近的截止日期作为"下次申报截止"显示
  - 用户可以看到准确的倒计时天数和截止日期

### 待修复

## 2025-12-07 二次审查（全局覆盖）

### 高优先级
- **年终奖合并计税误差**（BonusTaxPage.ets）：同上条，需重算逻辑并提示口径。
- **工资个税累计预扣缺失**（SalaryTaxPage.ets）：未按累计预扣法、城市费率/封顶配置计算，结果偏差大。
- **税务日历截止节点不准确**（TaxCalendarPage.ets）：仅处理15日，未使用年度/半年度节点，跨年顺延缺失。

### 中优先级
- **收藏初始化易空指针**（FavoritesPage.ets / favoritesManager.ets）：部分页面可能在未 init 时调用 `isFavorite`，虽有兜底但 context 为空即返回 false，导致收藏状态不可靠。建议强制在入口统一 init 或在工具函数中延迟初始化并抛错。
- **工具导航缺少用户提示**（ToolsPage.ets 及各工具页）：导航失败仅 console.error，无 Toast。需统一导航失败反馈。
- **输入必填校验覆盖不足**（多工具页，如 ProfitMarginPage.ets、LoanCalcPage.ets、BreakEvenPage.ets）：空输入被当作0直接计算，结果误导。应在计算前阻断并提示。
- **静态参数缺口径说明**（DividendTaxPage.ets、SurtaxPage.ets、IndividualTaxPage.ets 等）：税率、核定率写死且无数据来源/日期。需在UI标注来源时间或允许配置。
- **金额/结果未统一格式化**（ProfitMarginPage.ets 等）：未使用分位格式化，影响可读性，建议复用 NumberFormatter。

### 低优先级
- **整数输入清空即变0**（InputValidator.validateIntegerInput）：影响多个整数字段的输入体验，建议允许空值。
- **多处无障碍/空状态缺失**：部分列表或加载流程无空态提示（除 FavoritesPage 有处理）。建议统一添加。
- **配置硬编码仍存在**：如 ProfilePage 的 bundleId、分享文案等未提取常量。可后续资源化。

## 一、硬编码问题

### 1. 颜色值硬编码
多处页面存在直接使用颜色值而非资源引用：

#### 1.1 SalaryTaxPage.ets
- `#F5F6F7` (第317行、322行)
- `#1A1A1A` (第270行、394行)
- `#666666` (第346行、398行、413行、422行)
- `#F5F5F5` (第296行、351行)
- `#1677FF` (第417行)
- `#FA5151` (第255行)
- `#F0F0F0` (第254行、256行)

#### 1.2 InvoiceInfoPage.ets
- `#8E8E93` (第157行)
- `#1677FF` (第171行)
- `#F5F6F8` (第188行)
- `#333333` (第196行、205行)

#### 1.3 GeneralVatPage.ets
- `#1A1A1A` (第71行)
- `#666666` (第86行)
- `#FFFFFF` (第99行)

#### 1.4 KnowledgePage.ets
- `#8E8E93` (第285行)
- `#FFFFFF` (第291行)
- `#33FFFFFF` (第21行)

#### 1.5 CalculatorPage.ets
- `#1F000000` (第340行)

#### 1.6 HomePage.ets
- `#69B1FF` (第174行)

### 4. 数字常量硬编码
多处存在硬编码的数字常量：

#### 4.1 Index.ets
- 征期日期硬编码为15日 (第94行)
- Toast 持续时间硬编码为2000ms (第135行)

#### 4.2 SalaryTaxPage.ets
- 起征点硬编码为5000 (第97行)
- 税率表数据硬编码 (第40-47行)
- 专项附加扣除年度上限硬编码为96000 (第80行)
- 五险一金上限比例硬编码为0.5 (第69行)

#### 4.3 TaxCalendarPage.ets
- 年份硬编码为2025 (第20行)
- 征期日期硬编码为15日 (多处)

#### 4.4 ProfilePage.ets
- Bundle名称硬编码为 'com.douhua.flag' (第223行、260行)
- 应用版本号硬编码为 'v1.0.0' (第207行)

### 5. 字符串硬编码
多处存在硬编码的提示文本和错误信息：

#### 5.1 错误提示信息
- SalaryTaxPage.ets 中所有错误提示信息均为硬编码字符串
- InvoiceInfoPage.ets 中所有验证错误信息均为硬编码字符串
- GeneralVatPage.ets 中所有错误提示均为硬编码字符串

#### 5.2 页面标题和描述
- 多处页面的标题、描述文本直接写在代码中，未使用资源文件

## 三、不一致的地方（8个）

### 6. 页面背景色不一致
- **SettingsPage.ets**: 使用 `#F1F3F5` (第132行、137行)
- **ProfilePage.ets**: 使用 `$r('app.color.bg_page')` (第414行)
- **HomePage.ets**: 使用 `$r('app.color.bg_page')` (第288行)
- **SalaryTaxPage.ets**: 使用 `#F5F6F7` (第317行、322行)
- **InvoiceInfoPage.ets**: 使用 `#F5F6F8` (第188行)
- **问题**: 不同页面使用了不同的背景色值，应统一使用资源文件中的颜色

### 7. 按钮样式不一致
- **SettingsPage.ets**: 按钮使用硬编码颜色 `#1677FF` (第215行)
- **ProfilePage.ets**: 按钮使用资源颜色 `$r('app.color.button_primary')` (第495行、590行)
- **HomePage.ets**: 按钮使用资源颜色 `$r('app.color.button_primary')` (第495行)
- **问题**: 部分页面使用硬编码颜色，部分使用资源颜色

### 8. 对话框遮罩层透明度不一致
- **SettingsPage.ets**: `rgba(0, 0, 0, 0.5)` (第195行)
- **ProfilePage.ets**: `rgba(0, 0, 0, 0.5)` (第569行、649行、728行)
- **HomePage.ets**: `rgba(0, 0, 0, 0.5)` (第420行)
- **一致**: 遮罩层透明度一致，但应提取为常量

### 9. Toast 持续时间不一致
- **SettingsPage.ets**: 未使用 Toast
- **ProfilePage.ets**: 1500ms (第157行)、2000ms (多处)
- **HomePage.ets**: 2000ms (第593行、602行)
- **InvoiceInfoPage.ets**: 2000ms (多处)
- **问题**: Toast 持续时间不统一，应提取为常量

### 10. 字体大小不一致
- **SettingsPage.ets**: 标题使用 18px (第203行)，内容使用 16px (第247行)
- **ProfilePage.ets**: 标题使用 18px (第577行、657行、738行)，内容使用 16px (第700行)
- **HomePage.ets**: 标题使用 18px (第429行)，内容使用 14px (第442行)
- **问题**: 相同类型的文本在不同页面使用不同字体大小

### 11. 间距值不一致
- **SettingsPage.ets**: padding 使用 20px (第229行)
- **ProfilePage.ets**: padding 使用 24px (第603行、682行、806行)
- **HomePage.ets**: padding 使用 24px (第537行)
- **问题**: 相同组件的内边距在不同页面不一致

### 12. 错误处理方式不一致
- **SettingsPage.ets**: 部分错误仅 console.error，无用户提示
- **ProfilePage.ets**: 错误处理包含 console.error 和 Toast 提示
- **HomePage.ets**: 错误处理包含 console.error 和 Toast 提示
- **问题**: 错误处理策略不统一

### 13. 导航失败处理不一致
- **HomePage.ets**: 导航失败时仅 console.error (第232行、255行、278行、399行)
- **ProfilePage.ets**: 导航失败时 console.error (第312行)
- **FavoritesPage.ets**: 导航失败时 console.error + Toast 提示 (第48行、72行、89行)
- **问题**: 导航失败时的用户反馈不一致

## 四、可优化的点

### 14. 代码重复
#### 14.1 Toast 调用重复
多处页面存在相同的 Toast 调用代码：
```typescript
promptAction.showToast({
  message: 'xxx',
  duration: 2000
});
```
**建议**: 封装为工具函数，统一管理 Toast 消息

#### 14.2 错误处理重复
多处存在相同的错误处理模式：
```typescript
try {
  // ...
} catch (err) {
  console.error(`Failed to xxx: ${JSON.stringify(err)}`);
  try {
    promptAction.showToast({
      message: 'xxx',
      duration: 2000
    });
  } catch (toastErr) {
    console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
  }
}
```
**建议**: 封装为统一的错误处理函数

#### 14.3 Preferences 初始化重复
多个页面都有类似的 Preferences 初始化代码：
```typescript
if (!this.prefs) {
  this.prefs = await preferences.getPreferences(this.context, 'app_settings');
}
```
**建议**: 封装为工具函数或使用单例模式

### 15. 性能优化
#### 15.1 不必要的状态更新
- **HomePage.ets**: `aboutToUpdate()` 中每次 refreshKey 变化都会重新加载数据，可能导致不必要的渲染
- **建议**: 使用更细粒度的状态管理，避免全量刷新

#### 15.2 计算属性未缓存
- **SalaryTaxPage.ets**: 税率表数据每次计算都会重新创建数组
- **建议**: 将税率表数据提取为常量或使用缓存

### 16. 类型安全
#### 16.1 缺少类型定义
- **SettingsPage.ets**: 部分函数参数缺少类型定义
- **建议**: 为所有函数参数和返回值添加明确的类型定义

#### 16.2 使用 any 类型
- 检查代码中是否存在 `any` 类型的使用
- **建议**: 避免使用 any，使用明确的类型定义

### 17. 代码组织
#### 17.1 组件过大
- **HomePage.ets**: 文件超过600行，包含多个 Builder 函数
- **ProfilePage.ets**: 文件超过800行
- **建议**: 将大型组件拆分为更小的子组件

#### 17.2 魔法数字
- 多处存在魔法数字，如 `5000`、`96000`、`0.5` 等
- **建议**: 提取为有意义的常量

### 18. 用户体验
#### 18.1 加载状态缺失
- 多个页面在加载数据时没有显示加载状态
- **建议**: 添加 Loading 指示器

#### 18.2 空状态处理
- **FavoritesPage.ets**: 有空状态处理
- **其他页面**: 部分页面缺少空状态处理
- **建议**: 统一添加空状态处理

### 19. 可访问性
#### 19.1 缺少无障碍标签
- 多个按钮和交互元素缺少无障碍标签
- **建议**: 为所有交互元素添加无障碍标签

### 20. 资源管理
#### 20.1 字符串资源未提取
- 大量文本直接写在代码中，未使用资源文件
- **建议**: 将用户可见的文本提取到资源文件中，支持国际化

#### 20.2 图标资源使用不一致
- 部分页面使用 emoji 作为图标（如 SettingsPage.ets 第98行、105行、112行、119行）
- 部分页面使用资源文件中的图标
- **建议**: 统一使用资源文件中的图标

## 五、建议的改进措施

### 优先级高
1. **统一颜色管理**: 将所有硬编码颜色值替换为资源引用
2. **提取常量**: 将魔法数字和字符串提取为常量
3. **统一错误处理**: 封装统一的错误处理函数
4. **完成未实现功能**: 实现通知设置和深色模式功能（或移除重复功能）

### 优先级中
5. **代码重构**: 拆分大型组件，提取公共逻辑
6. **类型安全**: 完善类型定义，避免使用 any
7. **资源提取**: 将用户可见文本提取到资源文件

### 优先级低
8. **性能优化**: 优化状态更新和计算属性缓存
9. **用户体验**: 添加加载状态和空状态处理
10. **可访问性**: 添加无障碍标签

## 六、总结

本次审查共发现：
- **未完成功能**: 2个
- **硬编码问题**: 颜色值、数字常量、字符串多处
- **不一致问题**: 8个主要不一致点
- **可优化点**: 7个主要优化方向

建议优先处理硬编码和一致性问题，然后逐步完成未实现功能，最后进行代码优化和重构。

