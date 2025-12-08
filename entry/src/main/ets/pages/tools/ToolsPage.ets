import router from '@ohos.router';

interface ToolItem {
    name: string;
    desc: string;
    pageUrl: string;
    icon: Resource;
}

interface ToolSection {
    title: string;
    icon: string;
    color: string;
    tools: ToolItem[];
}

@Component
export struct ToolsPage {
    @Prop layoutMode: 'grid' | 'list' = 'grid';

    private sections: ToolSection[] = [
        {
            title: '税务计算器',
            icon: '🧮',
            color: '#1677FF',
            tools: [
                { name: '个税计算器（工资）', desc: '计算工资薪金个人所得税', pageUrl: 'pages/tools/SalaryTaxPage', icon: $r('app.media.icon_tool_salary') },
                { name: '个税计算器（年终奖）', desc: '年终奖单独计税或合并计税', pageUrl: 'pages/tools/BonusTaxPage', icon: $r('app.media.icon_tool_bonus') },
                { name: '五险一金计算', desc: '社保公积金缴纳金额测算', pageUrl: 'pages/tools/InsurancePage', icon: $r('app.media.icon_tool_insurance') },
                { name: '小规模纳税人增值税', desc: '3%征收率增值税计算', pageUrl: 'pages/tools/SmallVatPage', icon: $r('app.media.icon_tool_small_vat') },
                { name: '一般纳税人增值税', desc: '含进项抵扣的VAT计算', pageUrl: 'pages/tools/GeneralVatPage', icon: $r('app.media.icon_tool_general_vat') },
                { name: '个体户核定征收', desc: '个体工商户税额计算', pageUrl: 'pages/tools/IndividualTaxPage', icon: $r('app.media.icon_tool_individual') },
                { name: '企业所得税', desc: '查账征收/核定征收', pageUrl: 'pages/tools/CorporateTaxPage', icon: $r('app.media.icon_tool_corporate') },
                { name: '附加税计算', desc: '城建税、教育附加等', pageUrl: 'pages/tools/SurtaxPage', icon: $r('app.media.icon_tool_surtax') },
                { name: '印花税计算', desc: '合同类型印花税率', pageUrl: 'pages/tools/StampTaxPage', icon: $r('app.media.icon_tool_stamp_tax') },
                { name: '股权分红税', desc: '个人/企业分红税计算', pageUrl: 'pages/tools/DividendTaxPage', icon: $r('app.media.icon_tool_dividend') },
                { name: '税款滞纳金', desc: '计算税款滞纳金', pageUrl: 'pages/tools/TaxPenaltyPage', icon: $r('app.media.icon_tool_tax_calendar') }
            ]
        },
        {
            title: '财务与经营计算',
            icon: '📱',
            color: '#52C41A',
            tools: [
                { name: '盈亏平衡点', desc: '计算保本销售量/金额', pageUrl: 'pages/tools/BreakEvenPage', icon: $r('app.media.icon_tool_breakeven') },
                { name: '毛利/净利率', desc: '利润率快速计算', pageUrl: 'pages/tools/ProfitMarginPage', icon: $r('app.media.icon_tool_profit_margin') },
                { name: '贷款计算器', desc: '等额本息/等额本金', pageUrl: 'pages/tools/LoanCalcPage', icon: $r('app.media.icon_tool_loan') },
                { name: '折旧摊销', desc: '直线法折旧计算', pageUrl: 'pages/tools/DepreciationPage', icon: $r('app.media.icon_tool_depreciation') },
                { name: '加班费计算', desc: '工作日/周末/节假日', pageUrl: 'pages/tools/OvertimePage', icon: $r('app.media.icon_tool_overtime') },
                { name: '离职补偿金', desc: '经济补偿金测算', pageUrl: 'pages/tools/SeverancePage', icon: $r('app.media.icon_tool_severance') },
                { name: '人民币大写', desc: '金额转中文大写', pageUrl: 'pages/tools/RmbUpperCasePage', icon: $r('app.media.icon_tool_exchange_rate') },
                { name: '投资收益计算', desc: '单利/复利收益计算', pageUrl: 'pages/tools/InvestmentReturnPage', icon: $r('app.media.icon_tool_profit_margin') },
                { name: '复利计算器', desc: '复利终值精确计算', pageUrl: 'pages/tools/CompoundInterestPage', icon: $r('app.media.icon_tool_profit_margin') }
            ]
        },
        {
            title: '发票与合规',
            icon: '📄',
            color: '#FA8C16',
            tools: [
                { name: '发票真伪查询', desc: '跳转税务总局查验', pageUrl: 'pages/tools/InvoiceVerifyPage', icon: $r('app.media.icon_tool_invoice_verify') },
                { name: '发票类型说明', desc: '专票/普票区别详解', pageUrl: 'pages/tools/InvoiceTypePage', icon: $r('app.media.icon_tool_invoice_type') },
                { name: '开票税点列表', desc: '各行业税率速查', pageUrl: 'pages/tools/TaxRateListPage', icon: $r('app.media.icon_tool_tax_rate_list') },
                { name: '纳税人身份', desc: '小规模vs一般纳税人', pageUrl: 'pages/tools/TaxpayerTypePage', icon: $r('app.media.icon_tool_taxpayer_type') },
                { name: '税务日历', desc: '申报截止日期提醒', pageUrl: 'pages/tools/TaxCalendarPage', icon: $r('app.media.icon_tool_tax_calendar') },
                { name: '会计科目汇总', desc: '常用会计科目查询', pageUrl: 'pages/tools/AccountingSubjectPage', icon: $r('app.media.icon_tool_tax_rate_list') },
                { name: '财税法规库', desc: '财税法规查询索引', pageUrl: 'pages/tools/TaxLawLibraryPage', icon: $r('app.media.icon_tool_tax_rate_list') },
                { name: '税务违法举报', desc: '举报税收违法行为', pageUrl: 'pages/tools/ReportPage', icon: $r('app.media.icon_tool_invoice_verify') },
                { name: '计算器', desc: '基础计算工具', pageUrl: 'pages/tools/CalculatorPage', icon: $r('app.media.icon_tool_exchange_rate') }
            ]
        },
        {
            title: '报销管理',
            icon: '💰',
            color: '#EB2F96',
            tools: [
                { name: '报销流程', desc: '完整报销流程图', pageUrl: 'pages/tools/ReimbursementProcessPage', icon: $r('app.media.icon_tool_invoice_verify') },
                { name: '财务审核清单', desc: '发票费用预算审核', pageUrl: 'pages/tools/ReimbursementChecklistPage', icon: $r('app.media.icon_tool_invoice_type') },
                { name: '会计分录模板', desc: '差旅办公招待费等', pageUrl: 'pages/tools/ReimbursementEntryPage', icon: $r('app.media.icon_tool_tax_rate_list') }
            ]
        }
    ];

    private getGridColumns(): string {
        // 固定使用3列布局
        return '1fr 1fr 1fr';
    }

    private handleNavigation(pageUrl: string): void {
        router.pushUrl({ url: pageUrl }).catch((err: Error) => {
            // 导航失败时在控制台记录，可以后续添加UI提示
            console.error(`Navigation failed: ${err.message}`);
        });
    }

    build() {
        Scroll() {
            Column() {
                // 工具列表
                ForEach(this.sections, (section: ToolSection, sectionIndex: number) => {
                    Column() {
                        // Section Header
                        Row() {
                            Text(section.title)
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                        }
                            .width('100%')
                            .padding({ left: 16, right: 16, top: 16, bottom: 12 })

                        // Tools - Grid or List
                        if (this.layoutMode === 'grid') {
                            this.buildGridLayout(section, sectionIndex, this.getGridColumns(), (url: string) => {
                                this.handleNavigation(url);
                            })
                        } else {
                            this.buildListLayout(section, (url: string) => {
                                this.handleNavigation(url);
                            })
                        }
                    }
                })
            }
                .width('100%')
                .padding({ top: 8, bottom: 16 })
        }
            .width('100%')
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.Spring)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    buildGridLayout(section: ToolSection, sectionIndex: number, columnsTemplate: string, handleNav: (url: string) => void) {
        Grid() {
            ForEach(section.tools, (tool: ToolItem) => {
                GridItem() {
                    Column() {
                        Image(tool.icon)
                            .width(24)
                            .height(24)
                            .margin({ bottom: 8 })
                        Text(tool.name)
                            .fontSize(13)
                            .fontWeight(FontWeight.Medium)
                            .fontColor($r('app.color.text_primary'))
                            .textAlign(TextAlign.Start)
                            .maxLines(sectionIndex === 0 ? 2 : 1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)
                        .alignItems(HorizontalAlign.Start)
                        .padding(12)
                        .onClick(() => {
                            handleNav(tool.pageUrl);
                        })
                }
            })
        }
            .columnsTemplate(columnsTemplate)
            .rowsGap(8)
            .columnsGap(8)
            .width('100%')
            .padding(12)
            .backgroundColor($r('app.color.bg_card'))
            .margin({ left: 16, right: 16, bottom: 16 })
    }

    @Builder
    buildListLayout(section: ToolSection, handleNav: (url: string) => void) {
        Column() {
            ForEach(section.tools, (tool: ToolItem) => {
                Row() {
                    Image(tool.icon)
                        .width(24)
                        .height(24)
                        .margin({ right: 12 })
                    Column() {
                        Text(tool.name)
                            .fontSize(15)
                            .fontWeight(FontWeight.Medium)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                        Text(tool.desc)
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ top: 4 })
                            .alignSelf(ItemAlign.Start)
                    }
                        .layoutWeight(1)
                        .alignItems(HorizontalAlign.Start)
                    Image($r('app.media.icon_arrow_right'))
                        .width(16)
                        .height(16)
                }
                    .width('100%')
                    .padding(16)
                    .backgroundColor($r('app.color.bg_card'))
                    .borderRadius(8)
                    .margin({ bottom: 8 })
                    .onClick(() => {
                        handleNav(tool.pageUrl);
                    })
            })
        }
            .width('100%')
            .padding(12)
            .backgroundColor($r('app.color.bg_card'))
            .margin({ left: 16, right: 16, bottom: 16 })
    }

}
