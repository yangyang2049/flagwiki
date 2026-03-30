// 国旗制作知识数据

export interface ManufacturingSection {
   title: string;
   titleEN: string;
   content: string;
   contentEN: string;
}

export const flagManufacturingContent: ManufacturingSection[] = [
   {
      title: '制作流程',
      titleEN: 'Manufacturing Process',
      content: `国旗制作是一个严谨的过程，需要经过多个步骤：

1. 设计阶段
   - 根据国旗法规定，确定国旗的尺寸比例（通常为3:2或2:1）
   - 精确绘制国旗图案，确保所有元素位置准确
   - 确定颜色标准，使用国际通用的颜色代码（如Pantone色卡）

2. 材料准备
   - 选择符合标准的布料（通常为尼龙、聚酯纤维或棉质）
   - 准备所需颜色的染料或印刷油墨
   - 准备缝纫线和加固材料

3. 裁剪与缝制
   - 按照设计图纸精确裁剪布料
   - 使用专业缝纫设备进行拼接
   - 确保接缝牢固，不易开线

4. 图案制作
   - 对于复杂图案，使用丝网印刷或数码印刷
   - 确保图案清晰、颜色准确
   - 对于刺绣图案，使用专业绣花机

5. 质量检验
   - 检查尺寸是否符合标准
   - 验证颜色是否准确
   - 测试耐候性和色牢度
   - 确保无瑕疵后包装出厂`,
      contentEN: `Flag manufacturing is a rigorous process that requires multiple steps:

1. Design Phase
   - Determine flag dimensions according to flag law (typically 3:2 or 2:1 ratio)
   - Precisely draw flag patterns, ensuring all element positions are accurate
   - Determine color standards using internationally recognized color codes (such as Pantone)

2. Material Preparation
   - Select standard-compliant fabrics (typically nylon, polyester, or cotton)
   - Prepare dyes or printing inks in required colors
   - Prepare sewing threads and reinforcement materials

3. Cutting and Sewing
   - Precisely cut fabric according to design drawings
   - Use professional sewing equipment for joining
   - Ensure seams are strong and won't unravel

4. Pattern Production
   - Use screen printing or digital printing for complex patterns
   - Ensure patterns are clear and colors accurate
   - Use professional embroidery machines for embroidered patterns

5. Quality Inspection
   - Check dimensions meet standards
   - Verify color accuracy
   - Test weather resistance and colorfastness
   - Ensure no defects before packaging`
   },
   {
      title: '制作材料',
      titleEN: 'Manufacturing Materials',
      content: `国旗制作使用的材料直接影响其质量和寿命：

1. 布料材料
   - 尼龙：轻便、耐用、快干，适合户外使用
   - 聚酯纤维：抗紫外线、不易褪色，适合长期悬挂
   - 棉质：传统材料，手感好但易褪色
   - 丝绸：高档材料，用于特殊场合

2. 染料与油墨
   - 使用环保型染料，符合环保标准
   - 颜色必须符合国旗法规定的标准色
   - 使用高色牢度染料，确保长期不褪色
   - 对于特殊图案，使用专用印刷油墨

3. 缝纫材料
   - 高强度缝纫线，确保接缝牢固
   - 加固条带，用于旗杆连接处
   - 金属或塑料扣环，用于悬挂

4. 特殊材料
   - 反光材料：用于夜间可见的国旗
   - 防水涂层：提高耐候性
   - 防火材料：用于特殊安全要求`,
      contentEN: `Materials used in flag manufacturing directly affect quality and lifespan:

1. Fabric Materials
   - Nylon: Lightweight, durable, quick-drying, suitable for outdoor use
   - Polyester: UV-resistant, fade-resistant, suitable for long-term display
   - Cotton: Traditional material, good feel but prone to fading
   - Silk: Premium material for special occasions

2. Dyes and Inks
   - Use eco-friendly dyes meeting environmental standards
   - Colors must comply with flag law standard colors
   - Use high colorfastness dyes to ensure long-term color retention
   - Use specialized printing inks for special patterns

3. Sewing Materials
   - High-strength sewing threads for strong seams
   - Reinforcement strips for pole connection points
   - Metal or plastic grommets for hanging

4. Special Materials
   - Reflective materials for night-visible flags
   - Waterproof coatings to improve weather resistance
   - Fire-resistant materials for special safety requirements`
   },
   {
      title: '制作工艺',
      titleEN: 'Manufacturing Techniques',
      content: `国旗制作需要精湛的工艺技术：

1. 印刷工艺
   - 丝网印刷：适合大批量生产，颜色饱满
   - 数码印刷：适合小批量定制，图案精细
   - 热转印：适合复杂图案，色彩丰富
   - 刺绣工艺：用于高档国旗，立体感强

2. 缝制工艺
   - 平缝：用于布料拼接
   - 锁边：防止布料边缘脱线
   - 加固缝：在关键部位加强
   - 包边：美化边缘，提高耐用性

3. 质量控制
   - 尺寸精度控制在±2mm以内
   - 颜色偏差控制在标准范围内
   - 接缝强度测试，确保不易撕裂
   - 耐候性测试，模拟各种天气条件

4. 特殊工艺
   - 防水处理：提高户外使用耐久性
   - 防紫外线处理：延缓褪色
   - 阻燃处理：用于特殊安全要求`,
      contentEN: `Flag manufacturing requires skilled techniques:

1. Printing Techniques
   - Screen printing: Suitable for mass production, rich colors
   - Digital printing: Suitable for small batch customization, fine patterns
   - Heat transfer: Suitable for complex patterns, rich colors
   - Embroidery: For premium flags, strong three-dimensional effect

2. Sewing Techniques
   - Flat seam: For fabric joining
   - Edge locking: Prevents fabric edge unraveling
   - Reinforcement seam: Strengthens key areas
   - Edge binding: Beautifies edges, improves durability

3. Quality Control
   - Dimensional accuracy within ±2mm
   - Color deviation within standard range
   - Seam strength testing to ensure tear resistance
   - Weather resistance testing simulating various conditions

4. Special Techniques
   - Waterproof treatment: Improves outdoor durability
   - UV protection treatment: Delays fading
   - Flame retardant treatment: For special safety requirements`
   },
   {
      title: '制作工厂',
      titleEN: 'Manufacturing Facilities',
      content: `专业的国旗制作工厂需要具备以下条件：

1. 资质要求
   - 获得国旗制作许可证
   - 通过质量管理体系认证
   - 符合环保生产标准
   - 具备安全生产资质

2. 设备配置
   - 大型裁剪设备，确保精确裁剪
   - 专业缝纫设备，提高生产效率
   - 印刷设备，支持多种印刷工艺
   - 质量检测设备，确保产品质量

3. 生产环境
   - 无尘生产车间，确保产品洁净
   - 恒温恒湿环境，保证材料稳定性
   - 充足的光照，便于颜色检验
   - 良好的通风，确保生产安全

4. 知名工厂
   - 中国：拥有多家专业国旗制作企业
   - 美国：大型旗帜制造商，技术先进
   - 欧洲：传统工艺与现代技术结合
   - 日本：注重细节和品质控制

5. 质量控制体系
   - 原材料检验，确保材料符合标准
   - 生产过程监控，及时发现问题
   - 成品检验，确保每面国旗合格
   - 质量追溯系统，可追溯生产全过程`,
      contentEN: `Professional flag manufacturing facilities require the following:

1. Qualification Requirements
   - Obtain flag manufacturing license
   - Pass quality management system certification
   - Comply with environmental production standards
   - Have safety production qualifications

2. Equipment Configuration
   - Large cutting equipment for precise cutting
   - Professional sewing equipment to improve efficiency
   - Printing equipment supporting multiple printing techniques
   - Quality inspection equipment to ensure product quality

3. Production Environment
   - Dust-free production workshops for clean products
   - Constant temperature and humidity for material stability
   - Adequate lighting for color inspection
   - Good ventilation for production safety

4. Well-Known Facilities
   - China: Multiple professional flag manufacturing enterprises
   - United States: Large flag manufacturers with advanced technology
   - Europe: Combining traditional craftsmanship with modern technology
   - Japan: Attention to detail and quality control

5. Quality Control System
   - Raw material inspection to ensure standards compliance
   - Production process monitoring to detect issues promptly
   - Finished product inspection to ensure each flag is qualified
   - Quality traceability system tracking entire production process`
   },
   {
      title: '质量标准',
      titleEN: 'Quality Standards',
      content: `国旗制作必须符合严格的质量标准：

1. 尺寸标准
   - 严格按照国旗法规定的比例制作
   - 标准尺寸：长宽比为3:2或2:1
   - 允许误差：±2mm
   - 特殊尺寸需按比例缩放

2. 颜色标准
   - 使用标准色卡（如Pantone）确定颜色
   - 颜色偏差控制在允许范围内
   - 确保在不同光照下颜色一致
   - 长期使用不褪色或褪色在允许范围内

3. 材料标准
   - 布料强度符合使用要求
   - 耐候性测试通过标准
   - 色牢度达到规定等级
   - 环保材料，符合安全标准

4. 工艺标准
   - 接缝牢固，不易开线
   - 图案清晰，位置准确
   - 边缘整齐，无毛边
   - 整体平整，无皱褶

5. 检验标准
   - 外观检验：无瑕疵、无污渍
   - 尺寸检验：符合标准要求
   - 颜色检验：与标准色卡对比
   - 强度检验：接缝和材料强度测试`,
      contentEN: `Flag manufacturing must meet strict quality standards:

1. Dimensional Standards
   - Strictly follow flag law proportions
   - Standard dimensions: 3:2 or 2:1 length-to-width ratio
   - Allowable error: ±2mm
   - Special sizes must be proportionally scaled

2. Color Standards
   - Use standard color charts (such as Pantone) to determine colors
   - Color deviation within allowable range
   - Ensure color consistency under different lighting
   - Long-term use without fading or fading within acceptable range

3. Material Standards
   - Fabric strength meets usage requirements
   - Weather resistance tests pass standards
   - Colorfastness reaches specified grade
   - Eco-friendly materials meeting safety standards

4. Process Standards
   - Strong seams that won't unravel
   - Clear patterns with accurate positioning
   - Neat edges without fraying
   - Overall flatness without wrinkles

5. Inspection Standards
   - Appearance inspection: No defects or stains
   - Dimensional inspection: Meets standard requirements
   - Color inspection: Comparison with standard color chart
   - Strength inspection: Seam and material strength testing`
   },
   {
      title: '制作成本',
      titleEN: 'Manufacturing Costs',
      content: `国旗制作成本受多种因素影响：

1. 材料成本
   - 布料价格：根据材质和数量确定
   - 染料成本：颜色数量和工艺复杂度
   - 辅料成本：缝纫线、扣环等
   - 特殊材料：反光、防水等特殊处理

2. 工艺成本
   - 印刷成本：根据图案复杂度
   - 缝制成本：根据制作数量
   - 特殊工艺：刺绣、热转印等
   - 质量控制：检验和测试成本

3. 规模效应
   - 大批量生产：单位成本降低
   - 小批量定制：单位成本较高
   - 标准化生产：成本可控
   - 个性化定制：成本增加

4. 质量等级
   - 标准级：满足基本使用要求
   - 高级：使用优质材料和工艺
   - 专业级：用于特殊场合
   - 收藏级：限量版或纪念版

5. 市场价格
   - 普通国旗：几十到几百元不等
   - 专业级国旗：数百到数千元
   - 定制国旗：根据需求定价
   - 特殊规格：价格相应调整`,
      contentEN: `Flag manufacturing costs are influenced by various factors:

1. Material Costs
   - Fabric prices: Determined by material type and quantity
   - Dye costs: Number of colors and process complexity
   - Auxiliary material costs: Sewing threads, grommets, etc.
   - Special materials: Reflective, waterproof, and other special treatments

2. Process Costs
   - Printing costs: Based on pattern complexity
   - Sewing costs: Based on production quantity
   - Special processes: Embroidery, heat transfer, etc.
   - Quality control: Inspection and testing costs

3. Scale Effects
   - Mass production: Lower unit costs
   - Small batch customization: Higher unit costs
   - Standardized production: Controllable costs
   - Personalized customization: Increased costs

4. Quality Grades
   - Standard grade: Meets basic usage requirements
   - Premium grade: Uses high-quality materials and processes
   - Professional grade: For special occasions
   - Collector grade: Limited edition or commemorative

5. Market Prices
   - Regular flags: Vary from tens to hundreds of yuan
   - Professional grade flags: Hundreds to thousands of yuan
   - Custom flags: Priced according to requirements
   - Special specifications: Prices adjusted accordingly`
   }
];

export function getManufacturingContent(): ManufacturingSection[] {
   return flagManufacturingContent;
}

// 获取本地化的制作内容
export function getLocalizedManufacturingContent(language: string): ManufacturingSection[] {
   const isEnglish = language === 'en' || (language.length > 3 && language.substring(0, 3) === 'en-');
   return flagManufacturingContent.map((section): ManufacturingSection => ({
      title: isEnglish ? section.titleEN : section.title,
      titleEN: section.titleEN,
      content: isEnglish ? section.contentEN : section.content,
      contentEN: section.contentEN
   }));
}










