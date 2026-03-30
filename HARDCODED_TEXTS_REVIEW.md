# Hardcoded Texts Review

**Document Version:** 2.0  
**Last Updated:** 2026-01-22  
**Review Coverage:** 100% of ETS files  
**Total Hardcoded Strings:** ~190

This document provides a comprehensive analysis of all hardcoded text strings found in the HarmonyOS FlagWiki application, organized by priority and implementation requirements.

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Priority Classification](#priority-classification)
3. [Detailed Findings by Page](#detailed-findings-by-page)
4. [Implementation Roadmap](#implementation-roadmap)
5. [Technical Recommendations](#technical-recommendations)

---

## 🎯 Executive Summary

### **App Navigation Structure**
- **5 Main Tabs**: Home, Gallery, Paint, Explore, Profile
- **Additional Pages**: Detail pages, Game pages, Watch pages, Dialogs

### **Key Statistics**
- **Total Hardcoded Strings**: ~190 across all files
- **Critical Priority**: 30 strings (user-facing content)
- **Medium Priority**: 80 strings (UI elements)
- **Low Priority**: 80 strings (symbols/debug)

### **Primary Issues**
1. **Fun Facts Arrays** (20 strings) - Multilingual content hardcoded in component
2. **Region Mappings** (10 strings) - Geographic translations in utility objects
3. **Dialog Content** (15+ strings) - About/Feedback/Share text in ProfilePage
4. **Game Instructions** (35+ strings) - Country names and game text in Paint/Explore tabs

---

## 🚨 Priority Classification

| **Priority** | **Impact Level** | **Timeline** | **Description** |
|-------------|------------------|--------------|-----------------|
| 🔴 **Critical** | High - User Content | Immediate | User-facing text that must be localized |
| 🟡 **Medium** | Medium - UI Elements | Next Sprint | Interface text affecting UX consistency |
| 🟢 **Low** | Low - Technical | Future | Symbols and debug messages |

### **Critical Priority Items (Immediate Action Required)**
- Fun facts arrays (HomePage.ets)
- Region name mappings (HomePage.ets)
- Dialog content (ProfilePage.ets)
- Error messages (ProfilePage.ets)

### **Medium Priority Items (UI Consistency)**
- Game instructions (Paint/Explore tabs)
- Button labels (Detail pages)
- Progress indicators (Game pages)

### **Low Priority Items (Technical Polish)**
- Emoji symbols (Game pages)
- UI separators (Navigation elements)
- Console messages (Debug logs)

---

## 📋 Detailed Findings by Page

### **1. Home Tab (HomePage.ets)** - 🔴 Critical

#### **Fun Facts Arrays** (20 strings)
```typescript
// File: entry/src/main/ets/pages/home/HomePage.ets
private funFactsCN: string[] = [
  '🇳🇵 尼泊尔是世界上唯一非矩形的国旗，由两个三角形组成！',
  '🇨🇭 瑞士和梵蒂冈是世界上仅有的两个正方形国旗！',
  '🇯🇵 日本国旗上的红色圆形代表太阳，日本被称为"日出之国"！',
  '🇱🇾 利比亚在1977-2011年使用过世界上唯一的纯色国旗（绿色）！',
  '🇲🇨 摩纳哥和印度尼西亚的国旗几乎相同，只是尺寸比例不同！',
  '🇩🇰 丹麦国旗是世界上使用时间最长的国旗，自1219年开始使用！',
  '🇧🇷 巴西国旗上的27颗星星代表26个州和1个联邦区！',
  '🇺🇸 美国国旗的50颗星代表50个州，13道条纹代表最初的13个殖民地！',
  '🇨🇦 加拿大国旗上的枫叶有11个尖角，这是经过风洞测试最清晰的设计！',
  '🇬🇧 英国国旗"米字旗"由英格兰、苏格兰和爱尔兰的旗帜组合而成！'
];

private funFactsEN: string[] = [
  '🇳🇵 Nepal has the world\'s only non-rectangular flag, made of two triangles!',
  '🇨🇭 Switzerland and Vatican City are the only two countries with square flags!',
  '🇯🇵 The red circle on Japan\'s flag represents the sun, Japan is called the "Land of the Rising Sun"!',
  '🇱🇾 Libya used the world\'s only solid-color flag (green) from 1977-2011!',
  '🇲🇨 Monaco and Indonesia have almost identical flags, differing only in aspect ratio!',
  '🇩🇰 Denmark\'s flag is the world\'s oldest flag, in use since 1219!',
  '🇧🇷 Brazil\'s flag has 27 stars representing 26 states and 1 federal district!',
  '🇺🇸 The US flag has 50 stars for 50 states, and 13 stripes for the original 13 colonies!',
  '🇨🇦 Canada\'s maple leaf has 11 points, designed for maximum clarity in wind tunnel tests!',
  '🇬🇧 The UK\'s "Union Jack" combines the flags of England, Scotland, and Ireland!'
];
```

#### **Region Name Mappings** (10 strings)
```typescript
// File: entry/src/main/ets/pages/home/HomePage.ets
const regionMapCN: Record<string, string> = {
  'Asia': '亚洲', 'Europe': '欧洲', 'Africa': '非洲',
  'Americas': '美洲', 'Oceania': '大洋洲'
};

const regionMapEN: Record<string, string> = {
  'Asia': 'Asia', 'Europe': 'Europe', 'Africa': 'Africa',
  'Americas': 'Americas', 'Oceania': 'Oceania'
};
```

### **2. Gallery Tab (GalleryPage.ets)** - ✅ Good (Uses Resources)

*Note: This page properly uses resource strings (`$r('app.string.xxx')`) for all text content.*

### **3. Paint Tab (PaintHomePage.ets)** - 🟡 Medium

#### **Game Instructions** (3 strings)
```typescript
Text('🎨 国旗涂色')
Text('选择一张国旗开始涂色吧！')
Text('涂色完成后可以保存到相册')
```

#### **Country Names** (12 strings)
```typescript
Text('🇨🇳 中国'), Text('🇺🇸 美国'), Text('🇯🇵 日本'),
Text('🇬🇧 英国'), Text('🇫🇷 法国'), Text('🇩🇪 德国'),
Text('🇮🇹 意大利'), Text('🇰🇷 韩国'), Text('🇷🇺 俄罗斯'),
Text('🇦🇺 澳大利亚'), Text('🇨🇦 加拿大'), Text('🇧🇷 巴西')
```

#### **Action Buttons** (3 strings)
```typescript
Text('开始涂色'), Text('随机选择'), Text('查看进度')
```

#### **Status Messages** (4 strings)
```typescript
Text('简单'), Text('中等'), Text('困难')
Text('未开始'), Text('进行中'), Text('已完成')
```

### **4. Explore Tab (ExplorePage.ets)** - 🟡 Medium

#### **Game Categories** (5 strings)
```typescript
Text('🧠 思维游戏'), Text('🎯 国旗猜猜'), Text('🧩 国旗拼图'),
Text('🎪 国旗马戏团'), Text('🏆 国旗挑战')
```

#### **Game Descriptions** (5 strings)
```typescript
Text('通过逻辑推理找出正确答案')
Text('猜猜这是哪个国家的国旗')
Text('将散落的国旗碎片重新拼合')
Text('体验精彩的国旗马戏表演')
Text('接受各种国旗知识挑战')
```

#### **Action Buttons** (3 strings)
```typescript
Text('开始游戏'), Text('继续游戏'), Text('查看排名')
```

#### **Status Indicators** (3 strings)
```typescript
Text('未解锁'), Text('已完成'), Text('最佳成绩')
```

### **5. Profile Tab (ProfilePage.ets)** - 🔴 Critical

#### **Theme Labels** (3 strings)
```typescript
private getThemeText(): string {
  case COLOR_MODE_LIGHT: return '浅色';
  case COLOR_MODE_DARK: return '深色';
  default: return '跟随系统';
}
```

#### **Error Messages** (4 strings)
```typescript
promptAction.showToast({ message: '保存失败' });
promptAction.showToast({ message: '分享失败' });
promptAction.showToast({ message: '无法打开应用市场' });
promptAction.showToast({ message: '无法打开应用市场，请手动前往应用市场评分' });
```

#### **Dialog Content** (5+ strings)
```typescript
// About dialog
promptAction.showDialog({
  title: '关于应用',
  message: '国旗小百科 v2.0.0\\n\\n一款有趣的国旗知识应用...',
  buttons: [{ text: '确定' }]
});

// Feedback dialog
promptAction.showDialog({
  title: '意见反馈',
  message: '如有建议或问题，可通过应用商店评论...',
  buttons: [{ text: '好的' }]
});

// Share text
const shareText = `国旗小百科 - 一款有趣的国旗知识应用...`;
```

### **6. Detail Pages** - 🟡 Medium

#### **FlagDetailPage.ets & StateFlagDetailPage.ets**
```typescript
// Loading states
Text('加载中...'), Text('暂无数据')

// Button labels
Text('收藏'), Text('已收藏'), Text('下载')

// Section headers
Text('基本信息'), Text('关于这面国旗'), Text('国徽')
```

### **7. Game Play Pages** - 🟢 Low

#### **All Game Pages (Quiz, Trivia, Memory, etc.)**
```typescript
// Emojis and symbols
Text('❤️'), Text('🖤'), Text('🎉'), Text('⏰')
Text('✓'), Text('✗'), Text('🔥'), Text('🏳️')

// Progress patterns
Text(`${current}/${total}`), Text(`${moves}`), Text(`${lives} ❤️`)
```

---

## 🛠️ Implementation Roadmap

### **Phase 1: Critical User Content** (Week 1-2)
- [ ] Extract `funFactsCN`/`funFactsEN` arrays to `data/funFacts.ts`
- [ ] Create `RegionMapping.ts` utility with resource references
- [ ] Move About/Feedback dialog content to `strings.json`
- [ ] Update ProfilePage error messages to use resources

### **Phase 2: UI Consistency** (Week 3-4)
- [ ] Create `EmojiConstants.ts` for game symbols
- [ ] Extract Paint tab country names and instructions
- [ ] Extract Explore tab game categories and descriptions
- [ ] Standardize progress text patterns with resource strings

### **Phase 3: Technical Polish** (Week 5-6)
- [ ] Update detail page button labels and headers
- [ ] Create symbol constants for arrows/separators
- [ ] Test all language switches across features
- [ ] Update resource files for complete coverage

### **Phase 4: Testing & Validation** (Week 7)
- [ ] Comprehensive testing of all language variants
- [ ] Verify no user-facing hardcoded strings remain
- [ ] Performance testing with additional language resources
- [ ] Documentation updates

---

## 🔧 Technical Recommendations

### **1. Resource File Structure**
```
resources/
├── base/element/
│   └── strings.json          # Default (Chinese)
├── en_US/element/
│   └── strings.json          # English
└── zh_TW/element/
    └── strings.json          # Traditional Chinese (future)
```

### **2. Data File Structure**
```
data/
├── funFacts.ts               # Fun facts arrays by language
├── regionMappings.ts         # Geographic name mappings
├── gameContent.ts            # Game-specific text content
└── uiContent.ts              # UI labels and messages
```

### **3. Constants Structure**
```
constants/
├── emojis.ts                 # Emoji constants
├── symbols.ts                # UI symbol constants
└── patterns.ts               # Text pattern constants
```

### **4. Implementation Example**
```typescript
// Before (hardcoded)
private funFactsCN: string[] = ['🇳🇵 尼泊尔是世界上唯一...'];

// After (resource-based)
import { getFunFacts } from '../data/funFacts';
private get funFacts(): string[] {
  return getFunFacts(this.currentLanguage);
}
```

### **5. Best Practices**
- Use resource references: `$r('app.string.xxx')`
- Create data utilities for complex content
- Implement fallback mechanisms for missing resources
- Test with multiple language configurations
- Document all new resource keys

---

## 📊 Metrics & Tracking

| **Category** | **Current Count** | **Target (Phase 1)** | **Target (Phase 2)** | **Target (Final)** |
|-------------|-------------------|---------------------|---------------------|-------------------|
| **Fun Facts** | 20 | 0 | 0 | 0 |
| **Region Names** | 10 | 0 | 0 | 0 |
| **Dialog Content** | 15+ | 0 | 0 | 0 |
| **UI Labels** | ~45 | ~20 | ~10 | 0 |
| **Game Content** | ~35 | ~35 | ~10 | 0 |
| **Emojis/Symbols** | ~20 | ~20 | ~10 | 0 |
| **Progress Text** | ~10 | ~10 | ~5 | 0 |

---

## 📝 Notes

- **Coverage**: 100% of ETS files reviewed across the entire application
- **Methodology**: Systematic grep search + manual code review
- **Priority**: Based on user impact and internationalization requirements
- **Timeline**: Estimated 7 weeks for complete implementation
- **Testing**: Requires comprehensive language switching validation

---

*Document Version 2.0 - Comprehensive Hardcoded Text Analysis*  
*HarmonyOS FlagWiki Application*  
*Prepared: 2026-01-22*

---

## 6. Detail Pages (FlagDetailPage.ets, StateFlagDetailPage.ets)

### Hardcoded Texts Found:

#### FlagDetailPage.ets
```typescript
// Loading and empty states
Text('加载中...')
  .fontSize(14)

// Button texts
Text('收藏')
  .fontSize(15)
Text('已收藏')
  .fontSize(15)
Text('下载')
  .fontSize(15)

// Section headers
Text('基本信息')
  .fontSize(16)
Text('关于这面国旗')
  .fontSize(16)
Text('国徽')
  .fontSize(16)

// Empty state
Text('暂无数据')
  .fontSize(14)
```

#### StateFlagDetailPage.ets
```typescript
// Section headers
Text('基本信息')
  .fontSize(17)

// Button texts
Text('收藏')
  .fontSize(15)
Text('已收藏')
  .fontSize(15)
Text('下载')
  .fontSize(15)

// Empty state
Text('暂无数据')
  .fontSize(14)
```

---

## 7. Game Play Pages

### Hardcoded Texts Found:

#### Various Game Pages (Quiz, Trivia, Memory, etc.)
```typescript
// Emojis and symbols used in UI
Text('❤️')  // Hearts for lives
Text('🖤')  // Black hearts for lost lives
Text('🎉')  // Celebration emoji
Text('⏰')  // Time up emoji
Text('✓')   // Check mark for correct
Text('✗')   // X mark for incorrect
Text('🔥')  // Fire emoji for combos
Text('🏳️')  // Flag emoji for questions

// Progress indicators
Text(`${this.currentIndex + 1} / ${this.questions.length}`)
Text(`${this.moves}`)
Text(`${this.lives} ❤️`)
Text(`${this.matchedPairs}/${this.level?.pairs || 0}`)
```

#### SaveFlagDialog.ets
```typescript
Text('保存国旗图片到相册')
  .fontSize(15)
```

---

## 8. Watch Pages (Wearable-specific)

### Hardcoded Texts Found:

#### Various Watch Pages
```typescript
// UI symbols and separators
Text('›')  // Arrow separator
Text(' / ') // Progress separator
Text(' · ') // Level separator

// Loading states
Text('加载中...')
Text('暂无数据')
```

---

## Summary (Updated)

### Total Hardcoded Texts by Category (Updated Count):

1. **Fun Facts**: 20 strings (10 Chinese + 10 English) - **UNCHANGED**
2. **Region Names**: 10 strings (5 Chinese + 5 English) - **UNCHANGED**
3. **UI Labels**: ~80 strings across all tabs - **INCREASED from ~50**
4. **Game Content**: ~40 strings - **INCREASED from ~30**
5. **Status Messages**: ~20 strings - **INCREASED from ~15**
6. **Instructions**: ~15 strings - **INCREASED from ~10**
7. **Emojis/Symbols**: ~15 strings - **NEW CATEGORY**
8. **Button Labels**: ~10 strings - **NEW CATEGORY**

### New Findings from Detailed Review:
- **Detail pages** have several hardcoded section headers and button texts
- **Game play pages** extensively use hardcoded emojis and symbols
- **Save dialogs** contain hardcoded confirmation texts
- **Progress indicators** use hardcoded separators and formats
- **Loading states** use hardcoded "加载中..." text

### Recommendations (Updated):

1. **Move all hardcoded strings to resource files** (`strings.json`)
2. **Create separate resource files** for different languages
3. **Use resource references** (`$r('app.string.xxx')`) instead of hardcoded strings
4. **Centralize game content** in data files rather than UI components
5. **Create emoji/symbol constants** for consistent usage
6. **Standardize progress indicators** with resource strings
7. **Implement proper localization** for all user-facing text

---

*This review was conducted on: 2026-01-22*
*Total hardcoded text strings identified: ~170 (Updated from ~135)*

---

## 3. Paint Tab (PaintHomePage.ets)

### Hardcoded Texts Found:

#### Game Instructions
```typescript
Text('🎨 国旗涂色')
Text('选择一张国旗开始涂色吧！')
Text('涂色完成后可以保存到相册')
```

#### Game Mode Options
```typescript
Text('🇨🇳 中国')  // Country selection
Text('🇺🇸 美国')
Text('🇯🇵 日本')
Text('🇬🇧 英国')
Text('🇫🇷 法国')
Text('🇩🇪 德国')
Text('🇮🇹 意大利')
Text('🇰🇷 韩国')
Text('🇷🇺 俄罗斯')
Text('🇦🇺 澳大利亚')
Text('🇨🇦 加拿大')
Text('🇧🇷 巴西')

Text('开始涂色')  // Action buttons
Text('随机选择')
Text('查看进度')
```

#### Difficulty Levels
```typescript
Text('简单')
Text('中等')
Text('困难')
```

#### Status Messages
```typescript
Text('未开始')
Text('进行中')
Text('已完成')
```

---

## 4. Explore Tab (ExplorePage.ets)

### Hardcoded Texts Found:

#### Game Categories
```typescript
Text('🧠 思维游戏')
Text('🎯 国旗猜猜')
Text('🧩 国旗拼图')
Text('🎪 国旗马戏团')
Text('🏆 国旗挑战')
```

#### Game Descriptions
```typescript
Text('通过逻辑推理找出正确答案')
Text('猜猜这是哪个国家的国旗')
Text('将散落的国旗碎片重新拼合')
Text('体验精彩的国旗马戏表演')
Text('接受各种国旗知识挑战')
```

#### Action Buttons
```typescript
Text('开始游戏')
Text('继续游戏')
Text('查看排名')
```

#### Status Indicators
```typescript
Text('未解锁')
Text('已完成')
Text('最佳成绩')
```

---

## 5. Profile Tab (ProfilePage.ets)

### Hardcoded Texts Found:

#### Theme Settings
```typescript
// Theme option labels (hardcoded in getThemeText method)
private getThemeText(): string {
  switch (this.colorMode) {
    case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
      return '浅色';  // Light
    case ConfigurationConstant.ColorMode.COLOR_MODE_DARK:
      return '深色';  // Dark
    case ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET:
    default:
      return '跟随系统';  // Follow system
  }
}
```

#### Error Messages
```typescript
// Error messages (hardcoded in toast and dialog)
promptAction.showToast({
  message: '保存失败',  // Save failed
  duration: 2000
});

promptAction.showToast({
  message: '分享失败',  // Share failed
  duration: 2000
});

promptAction.showToast({
  message: '无法打开应用市场',  // Unable to open app market
  duration: 2000
});

promptAction.showToast({
  message: '无法打开应用市场，请手动前往应用市场评分',  // Unable to open app market, please manually go to app market for rating
  duration: 2000
});
```

#### Dialog Content
```typescript
// About dialog (hardcoded)
promptAction.showDialog({
  title: '关于应用',  // About app
  message: '国旗小百科 v2.0.0\n\n一款有趣的国旗知识应用，带你探索世界各国国旗的故事与历史。',
  buttons: [{ text: '确定', color: $r('app.color.button_primary') }]  // OK
});

// Feedback dialog (hardcoded)
promptAction.showDialog({
  title: '意见反馈',  // Feedback
  message: '如有建议或问题，可通过应用商店评论，或者发邮件到 ssz2048@163.com 反馈。感谢您的支持。',
  buttons: [{ text: '好的', color: $r('app.color.button_primary') }]  // OK
});

// Share text (hardcoded)
const shareText = `国旗小百科 - 一款有趣的国旗知识应用，带你探索世界各国国旗的故事与历史。\n\n下载链接：${appGalleryUrl}`;
```

#### Menu Items
```typescript
Text('⭐ 我的收藏')  // My favorites
Text('📊 数据统计')  // Data statistics
Text('🎯 游戏进度')  // Game progress
Text('⚙️ 设置')  // Settings
Text('ℹ️ 关于')  // About
```

#### Statistics Labels
```typescript
Text('已完成 ')  // Completed
Text(' / ')  // separator
Text(' 关')  // levels
Text('探索进度')  // Exploration progress
```

---

## Summary

### **📊 Final Comprehensive Analysis**

#### **✅ Pages with GOOD Practices (Using Resources):**
- **Index.ets** - Main navigation (uses `$r('app.string.xxx')`)
- **GalleryPage.ets** - Gallery view (uses `$r()` extensively)
- **DataInfoPage.ets** - Data information (uses `$r()`)
- **SaveFlagDialog.ets** - Save dialog (uses `$r()`)
- **Most game play pages** - Quiz, Trivia, Memory, Connections (use `$r()`)
- **Toast messages** - All use resource strings
- **Dialog messages** - All use resource strings

#### **⚠️ Pages with HARDCODED Texts (Need Attention):**

##### **Critical Priority (User-Facing Text):**
1. **HomePage.ets** - Fun facts arrays (20 strings)
2. **ProfilePage.ets** - Theme labels, dialog content
3. **PaintHomePage.ets** - Game instructions, country names
4. **ExplorePage.ets** - Game categories, descriptions

##### **Medium Priority (UI Symbols):**
- **All game pages** - Emojis and symbols (✓, ✗, ❤️, 🎉, etc.)
- **Navigation elements** - Arrow separators (›)

##### **Low Priority (Debug/Console):**
- **Console messages** - Debug logs (not user-facing)

### **📈 Total Hardcoded Texts by Category (Final Count):**

| Category | Count | Priority | Impact |
|----------|-------|----------|--------|
| **Fun Facts** | 20 strings | 🔴 Critical | High - User content |
| **Region Names** | 10 strings | 🔴 Critical | High - Geographic data |
| **UI Labels** | ~45 strings | 🟡 Medium | Medium - Interface text |
| **Game Content** | ~35 strings | 🟡 Medium | Medium - Game text |
| **Emojis/Symbols** | ~20 strings | 🟢 Low | Low - Visual elements |
| **Progress Indicators** | ~10 strings | 🟢 Low | Low - Technical |
| **Console Messages** | ~50 strings | ⚪ None | Debug only |

### **🎯 Actionable Recommendations (Prioritized):**

#### **🔴 HIGH PRIORITY (Immediate Action Required):**
1. **Extract Fun Facts Arrays** - Move to external JSON/TS data files
2. **Create Region Mapping Utility** - Replace hardcoded region objects
3. **Move Dialog Content** - Extract About/Feedback dialog text to resources

#### **🟡 MEDIUM PRIORITY (Next Sprint):**
1. **Standardize Emojis** - Create emoji constants for consistency
2. **Progress Indicators** - Use resource strings for "1/10" patterns
3. **Game Instructions** - Extract paint game text to resources

#### **🟢 LOW PRIORITY (Future Enhancement):**
1. **Console Messages** - Consider i18n for error messages if needed
2. **UI Symbols** - Create symbol constants for arrows/separators

### **📋 Implementation Roadmap:**

#### **Phase 1: Critical User Content**
- [ ] Extract `funFactsCN` and `funFactsEN` arrays to data files
- [ ] Create `RegionMapping.ts` utility with resource-based mappings
- [ ] Move hardcoded dialog content to `strings.json`

#### **Phase 2: UI Consistency**
- [ ] Create `EmojiConstants.ts` for game symbols
- [ ] Standardize progress text patterns
- [ ] Extract remaining game instructions

#### **Phase 3: Polish & Testing**
- [ ] Test all language switches
- [ ] Verify no hardcoded strings remain in user-facing text
- [ ] Update string resource files for completeness

### **🔧 Technical Implementation Notes:**

1. **Resource File Structure:**
   ```
   resources/
   ├── base/element/strings.json    # Default (Chinese)
   └── en_US/element/strings.json   # English
   ```

2. **Data File Structure:**
   ```
   data/
   ├── funFacts.ts                  # Fun facts arrays
   ├── regionMappings.ts            # Geographic mappings
   └── gameContent.ts               # Game-specific text
   ```

3. **Constants Structure:**
   ```
   constants/
   ├── emojis.ts                    # Emoji constants
   └── symbols.ts                   # UI symbols
   ```

---

*This comprehensive review was conducted on: 2026-01-22*
*Total hardcoded text strings identified: ~190 (Complete final count)*
*Coverage: 100% of ETS files reviewed*
