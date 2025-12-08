import router from '@ohos.router';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

interface ExcelFormula {
    name: string;
    syntax: string;
    description: string;
    example: string;
    category: string;
}

@Entry
@Component
struct ExcelFormulasPage {
    @State selectedCategory: string = '全部';

    private categories: string[] = ['全部', '数学统计', '文本处理', '日期时间', '查找引用', '逻辑判断', '财务会计'];

    private formulas: ExcelFormula[] = [
        // 财务会计类别 - 放在最前面
        {
            name: '流动比率',
            syntax: '流动资产/流动负债',
            description: '衡量企业短期偿债能力，反映企业流动资产对流动负债的保障程度',
            example: '=A1/B1 (A1为流动资产，B1为流动负债)',
            category: '财务会计'
        },
        {
            name: '速动比率',
            syntax: '(流动资产-存货)/流动负债',
            description: '衡量企业立即偿债能力，排除存货后的短期偿债能力',
            example: '=(A1-B1)/C1 (A1为流动资产，B1为存货，C1为流动负债)',
            category: '财务会计'
        },
        {
            name: '资产负债率',
            syntax: '负债总额/资产总额',
            description: '反映企业资产中有多少是通过负债筹集的，衡量企业长期偿债能力',
            example: '=A1/B1 (A1为负债总额，B1为资产总额)',
            category: '财务会计'
        },
        {
            name: '毛利率',
            syntax: '(营业收入-营业成本)/营业收入',
            description: '反映企业产品或服务的盈利能力，毛利率越高说明盈利能力越强',
            example: '=(A1-B1)/A1 (A1为营业收入，B1为营业成本)',
            category: '财务会计'
        },
        {
            name: '净利率',
            syntax: '净利润/营业收入',
            description: '反映企业最终盈利能力，表示每元营业收入能带来多少净利润',
            example: '=A1/B1 (A1为净利润，B1为营业收入)',
            category: '财务会计'
        },
        {
            name: '净资产收益率(ROE)',
            syntax: '净利润/平均股东权益',
            description: '反映股东权益的收益水平，衡量企业运用自有资本的效率',
            example: '=A1/B1 (A1为净利润，B1为平均股东权益)',
            category: '财务会计'
        },
        {
            name: '总资产收益率(ROA)',
            syntax: '净利润/平均资产总额',
            description: '反映企业资产综合利用效果，衡量企业全部资产的盈利能力',
            example: '=A1/B1 (A1为净利润，B1为平均资产总额)',
            category: '财务会计'
        },
        {
            name: '应收账款周转率',
            syntax: '营业收入/平均应收账款',
            description: '反映应收账款周转速度，周转率越高说明回款越快',
            example: '=A1/B1 (A1为营业收入，B1为平均应收账款)',
            category: '财务会计'
        },
        {
            name: '存货周转率',
            syntax: '营业成本/平均存货',
            description: '反映存货周转速度，周转率越高说明存货管理效率越高',
            example: '=A1/B1 (A1为营业成本，B1为平均存货)',
            category: '财务会计'
        },
        {
            name: '固定资产折旧(直线法)',
            syntax: '(原值-残值)/使用年限',
            description: '按直线法计算固定资产年折旧额，每年折旧额相等',
            example: '=(A1-B1)/C1 (A1为原值，B1为残值，C1为使用年限)',
            category: '财务会计'
        },
        {
            name: '复利终值',
            syntax: '本金*(1+利率)^期数',
            description: '计算复利情况下的终值，考虑利息再投资',
            example: '=A1*(1+B1)^C1 (A1为本金，B1为利率，C1为期数)',
            category: '财务会计'
        },
        {
            name: '复利现值',
            syntax: '终值/(1+利率)^期数',
            description: '计算未来金额的现值，用于折现计算',
            example: '=A1/(1+B1)^C1 (A1为终值，B1为利率，C1为期数)',
            category: '财务会计'
        },
        {
            name: '等额本息月还款额',
            syntax: '本金*利率*(1+利率)^期数/((1+利率)^期数-1)',
            description: '计算等额本息还款方式下的月还款额，每月还款额相等',
            example: '=A1*B1*(1+B1)^C1/((1+B1)^C1-1) (A1为本金，B1为月利率，C1为月数)',
            category: '财务会计'
        },
        {
            name: '盈亏平衡点(销售额)',
            syntax: '固定成本/(1-变动成本率)',
            description: '计算企业达到盈亏平衡所需的销售额，固定成本/(1-变动成本/销售额)',
            example: '=A1/(1-B1) (A1为固定成本，B1为变动成本率)',
            category: '财务会计'
        },
        {
            name: '盈亏平衡点(销售量)',
            syntax: '固定成本/(单价-单位变动成本)',
            description: '计算企业达到盈亏平衡所需的销售量',
            example: '=A1/(B1-C1) (A1为固定成本，B1为单价，C1为单位变动成本)',
            category: '财务会计'
        },
        {
            name: '成本加成定价',
            syntax: '成本*(1+加成率)',
            description: '基于成本加成的定价方法，在成本基础上加上预期利润率',
            example: '=A1*(1+B1) (A1为成本，B1为加成率)',
            category: '财务会计'
        },
        {
            name: '增值税计算',
            syntax: '含税金额/(1+税率)',
            description: '从含税金额中计算不含税金额，用于增值税计算',
            example: '=A1/(1+B1) (A1为含税金额，B1为税率)',
            category: '财务会计'
        },
        {
            name: '增值税税额',
            syntax: '不含税金额*税率',
            description: '计算增值税税额，不含税金额乘以税率',
            example: '=A1*B1 (A1为不含税金额，B1为税率)',
            category: '财务会计'
        },
        {
            name: '年化收益率',
            syntax: '(期末价值/期初价值)^(1/年数)-1',
            description: '计算投资的年化收益率，将多期收益率转换为年化收益率',
            example: '=(A1/B1)^(1/C1)-1 (A1为期末价值，B1为期初价值，C1为年数)',
            category: '财务会计'
        },
        // 其他类别
        {
            name: 'SUM',
            syntax: 'SUM(数值1, 数值2, ...)',
            description: '计算指定单元格区域中所有数字的总和',
            example: '=SUM(A1:A10)',
            category: '数学统计'
        },
        {
            name: 'AVERAGE',
            syntax: 'AVERAGE(数值1, 数值2, ...)',
            description: '计算指定单元格区域中所有数字的平均值',
            example: '=AVERAGE(A1:A10)',
            category: '数学统计'
        },
        {
            name: 'MAX',
            syntax: 'MAX(数值1, 数值2, ...)',
            description: '返回指定单元格区域中的最大值',
            example: '=MAX(A1:A10)',
            category: '数学统计'
        },
        {
            name: 'MIN',
            syntax: 'MIN(数值1, 数值2, ...)',
            description: '返回指定单元格区域中的最小值',
            example: '=MIN(A1:A10)',
            category: '数学统计'
        },
        {
            name: 'COUNT',
            syntax: 'COUNT(值1, 值2, ...)',
            description: '统计指定单元格区域中包含数字的单元格个数',
            example: '=COUNT(A1:A10)',
            category: '数学统计'
        },
        {
            name: 'SUMIF',
            syntax: 'SUMIF(条件区域, 条件, 求和区域)',
            description: '对满足条件的单元格求和',
            example: '=SUMIF(A1:A10, ">100", B1:B10)',
            category: '数学统计'
        },
        {
            name: 'ROUND',
            syntax: 'ROUND(数值, 小数位数)',
            description: '将数值四舍五入到指定的小数位数',
            example: '=ROUND(A1, 2)',
            category: '数学统计'
        },
        {
            name: 'VLOOKUP',
            syntax: 'VLOOKUP(查找值, 表格数组, 列索引号, 精确匹配)',
            description: '在表格数组的第一列中查找值，并返回该行中指定列的值',
            example: '=VLOOKUP(A1, D1:F10, 2, FALSE)',
            category: '查找引用'
        },
        {
            name: 'IF',
            syntax: 'IF(条件, 真值, 假值)',
            description: '根据条件判断返回不同的值',
            example: '=IF(A1>60, "及格", "不及格")',
            category: '逻辑判断'
        },
        {
            name: 'AND',
            syntax: 'AND(条件1, 条件2, ...)',
            description: '所有条件都为真时返回TRUE，否则返回FALSE',
            example: '=AND(A1>0, A1<100)',
            category: '逻辑判断'
        },
        {
            name: 'OR',
            syntax: 'OR(条件1, 条件2, ...)',
            description: '任一条件为真时返回TRUE，否则返回FALSE',
            example: '=OR(A1>100, B1>100)',
            category: '逻辑判断'
        },
        {
            name: 'CONCATENATE',
            syntax: 'CONCATENATE(文本1, 文本2, ...)',
            description: '将多个文本字符串连接成一个字符串',
            example: '=CONCATENATE(A1, " ", B1)',
            category: '文本处理'
        },
        {
            name: 'LEFT',
            syntax: 'LEFT(文本, 字符数)',
            description: '从文本字符串的左侧提取指定数量的字符',
            example: '=LEFT(A1, 3)',
            category: '文本处理'
        },
        {
            name: 'RIGHT',
            syntax: 'RIGHT(文本, 字符数)',
            description: '从文本字符串的右侧提取指定数量的字符',
            example: '=RIGHT(A1, 3)',
            category: '文本处理'
        },
        {
            name: 'MID',
            syntax: 'MID(文本, 起始位置, 字符数)',
            description: '从文本字符串的指定位置提取指定数量的字符',
            example: '=MID(A1, 2, 3)',
            category: '文本处理'
        },
        {
            name: 'TODAY',
            syntax: 'TODAY()',
            description: '返回当前日期',
            example: '=TODAY()',
            category: '日期时间'
        },
        {
            name: 'NOW',
            syntax: 'NOW()',
            description: '返回当前日期和时间',
            example: '=NOW()',
            category: '日期时间'
        },
        {
            name: 'YEAR',
            syntax: 'YEAR(日期)',
            description: '返回日期中的年份',
            example: '=YEAR(A1)',
            category: '日期时间'
        },
        {
            name: 'MONTH',
            syntax: 'MONTH(日期)',
            description: '返回日期中的月份',
            example: '=MONTH(A1)',
            category: '日期时间'
        },
        {
            name: 'DAY',
            syntax: 'DAY(日期)',
            description: '返回日期中的天数',
            example: '=DAY(A1)',
            category: '日期时间'
        }
    ];

    private getFilteredFormulas(): ExcelFormula[] {
        if (this.selectedCategory === '全部') {
            return this.formulas;
        }
        return this.formulas.filter((formula: ExcelFormula) => formula.category === this.selectedCategory);
    }

    private async copyToClipboard(text: string): Promise<void> {
        try {
            const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
            const pasteData: pasteboard.PasteData = pasteboard.createPlainTextData(text);
            await systemPasteboard.setData(pasteData);
            try {
                promptAction.showToast({
                    message: '已复制到剪贴板',
                    duration: 2000
                });
            } catch (toastErr) {
                console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
            }
        } catch (err) {
            const error = err as Error;
            console.error(`Failed to copy to clipboard: ${error.message}`);
            try {
                promptAction.showToast({
                    message: '复制失败',
                    duration: 2000
                });
            } catch (toastErr) {
                console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
            }
        }
    }

    build() {
        Navigation() {
            Column() {
                // 分类筛选
                Scroll() {
                    Row() {
                        ForEach(this.categories, (category: string) => {
                            Button(category)
                                .type(ButtonType.Normal)
                                .fontSize(13)
                                .fontColor(this.selectedCategory === category ? $r('app.color.text_white') : $r('app.color.text_secondary'))
                                .backgroundColor(this.selectedCategory === category ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
                                .borderRadius(16)
                                .height(32)
                                .margin({ right: 8 })
                                .onClick(() => {
                                    this.selectedCategory = category;
                                })
                        })
                    }
                    .padding({ left: 16, right: 16 })
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .margin({ bottom: 8 })

                // 公式列表
                Scroll() {
                    Column() {
                        ForEach(this.getFilteredFormulas(), (formula: ExcelFormula) => {
                            Column() {
                                Row() {
                                    Text(formula.name)
                                        .fontSize(17)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.button_primary'))
                                    Blank()
                                    Image($r('app.media.icon_copy'))
                                        .width(20)
                                        .height(20)
                                        .colorFilter($r('app.color.gray_disabled'))
                                        .onClick(() => {
                                            this.copyToClipboard(formula.example);
                                        })
                                }
                                .width('100%')
                                .margin({ bottom: 16 })

                                Text(formula.description)
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                    .lineHeight(22)
                                    .margin({ bottom: 16 })

                                Column() {
                                    Text('语法')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ bottom: 8 })
                                    Text(formula.syntax)
                                        .fontSize(13)
                                        .fontColor($r('app.color.text_primary'))
                                        .fontFamily('monospace')
                                        .margin({ bottom: 16 })
                                    Text('示例')
                                        .fontSize(12)
                                        .fontColor($r('app.color.text_tertiary'))
                                        .margin({ bottom: 8 })
                                    Text(formula.example)
                                        .fontSize(13)
                                        .fontColor($r('app.color.button_primary'))
                                        .fontFamily('monospace')
                                }
                                .width('100%')
                                .padding({ left: 16, top: 16, right: 16, bottom: 16 })
                                .backgroundColor($r('app.color.bg_tertiary'))
                                .borderRadius(8)
                            }
                            .width('100%')
                            .padding({ left: 20, top: 20, right: 20, bottom: 20 })
                            .backgroundColor($r('app.color.bg_card'))
                            .margin({ left: 16, right: 16, bottom: 16 })
                        })
                    }
                    .padding({ top: 8, bottom: 16 })
                }
                .layoutWeight(1)
                .scrollBar(BarState.Off)
            }
            .width('100%')
            .height('100%')
            .backgroundColor($r('app.color.bg_page'))
        }
        .title('常用公式')
        .titleMode(NavigationTitleMode.Mini)
        .hideBackButton(false)
        .backgroundColor($r('app.color.bg_page'))
    }
}

