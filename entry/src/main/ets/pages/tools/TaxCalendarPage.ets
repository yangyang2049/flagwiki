interface TaxDeadline {
    name: string;
    deadline: string;
    frequency: string;
    important: boolean;
    month?: number; // 月份（1-12）
    day?: number; // 日期（1-31）
}

interface AdjustedDate {
    year: number;
    month: number;
    day: number;
}

@Entry
@Component
    struct TaxCalendarPage {
    @State currentMonth: number = 1;
    @State currentDay: number = 1;
    @State currentYear: number = 2025;
    @State nextDeadline: string = '';
    @State nextDeadlineDays: number = 0;

    private deadlines: TaxDeadline[] = [
        { name: '增值税申报', deadline: '次月15日', frequency: '月度/季度', important: true },
        { name: '企业所得税预缴', deadline: '次月15日', frequency: '季度', important: true },
        { name: '个人所得税扣缴', deadline: '次月15日', frequency: '月度', important: true },
        { name: '城建税及附加', deadline: '次月15日', frequency: '月度/季度', important: false },
        { name: '印花税申报', deadline: '次月15日', frequency: '月度/季度', important: false },
        { name: '房产税', deadline: '4月/10月', frequency: '半年', important: false },
        { name: '城镇土地使用税', deadline: '4月/10月', frequency: '半年', important: false },
        { name: '企业所得税汇算清缴', deadline: '5月31日', frequency: '年度', important: true, month: 5, day: 31 },
        { name: '个人所得税汇算清缴', deadline: '6月30日', frequency: '年度', important: true, month: 6, day: 30 },
        { name: '工商年报', deadline: '6月30日', frequency: '年度', important: true, month: 6, day: 30 },
        { name: '残保金申报', deadline: '各地不同', frequency: '年度', important: false }
    ];

    aboutToAppear(): void {
        const now = new Date();
        this.currentYear = now.getFullYear();
        this.currentMonth = now.getMonth() + 1;
        this.currentDay = now.getDate();
        this.calculateNextDeadline();
    }

    private isWeekend(month: number, day: number, year: number): boolean {
        const date = new Date(year, month - 1, day);
        const dayOfWeek = date.getDay();
        return dayOfWeek === 0 || dayOfWeek === 6; // 0=周日, 6=周六
    }

    private adjustForWeekend(month: number, day: number, year: number): AdjustedDate {
        let adjustedYear = year;
        let adjustedMonth = month;
        let adjustedDay = day;

        // 如果截止日是周末，顺延到下一个工作日
        while (this.isWeekend(adjustedMonth, adjustedDay, adjustedYear)) {
            adjustedDay++;
            // 处理月末跨月
            const daysInMonth = new Date(adjustedYear, adjustedMonth, 0).getDate();
            if (adjustedDay > daysInMonth) {
                adjustedDay = 1;
                adjustedMonth++;
                if (adjustedMonth > 12) {
                    adjustedMonth = 1;
                    adjustedYear++;
                }
            }
        }
        const result: AdjustedDate = {
            year: adjustedYear,
            month: adjustedMonth,
            day: adjustedDay
        };
        return result;
    }

    /**
     * 计算下一个截止日期
     * 综合考虑月度申报（次月15日）和年度节点（如5/31、6/30等）
     */
    private calculateNextDeadline(): void {
        const now = new Date();
        const currentYear = now.getFullYear();
        const currentMonth = now.getMonth() + 1;
        const currentDay = now.getDate();
        const today = new Date(currentYear, currentMonth - 1, currentDay);

        let nearestDeadline: Date | null = null;
        let nearestDeadlineText = '';
        let nearestDays = Infinity;

        // 遍历所有截止日期节点
        for (const deadline of this.deadlines) {
            let candidateDates: Date[] = [];

            if (deadline.month && deadline.day) {
                // 年度或半年度节点（如5/31、6/30、4/15、10/15等）
                // 计算今年的日期
                const thisYearDate = new Date(currentYear, deadline.month - 1, deadline.day);
                if (thisYearDate >= today) {
                    const adjusted = this.adjustForWeekend(deadline.month, deadline.day, currentYear);
                    candidateDates.push(new Date(adjusted.year, adjusted.month - 1, adjusted.day));
                }
                
                // 如果今年的已经过了，计算明年的
                if (candidateDates.length === 0) {
                    const adjusted = this.adjustForWeekend(deadline.month, deadline.day, currentYear + 1);
                    candidateDates.push(new Date(adjusted.year, adjusted.month - 1, adjusted.day));
                }
            } else if (deadline.deadline === '次月15日') {
                // 月度申报节点
                // 判断是本月15日还是次月15日
                let targetMonth: number;
                let targetYear: number;
                if (currentDay <= 15) {
                    targetMonth = currentMonth;
                    targetYear = currentYear;
                } else {
                    targetMonth = currentMonth + 1;
                    targetYear = currentYear;
                    if (targetMonth > 12) {
                        targetMonth = 1;
                        targetYear++;
                    }
                }
                const adjusted = this.adjustForWeekend(targetMonth, 15, targetYear);
                candidateDates.push(new Date(adjusted.year, adjusted.month - 1, adjusted.day));
            }

            // 找到最近的日期
            for (const candidateDate of candidateDates) {
                const diffTime = candidateDate.getTime() - today.getTime();
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                
                if (diffDays >= 0 && diffDays < nearestDays) {
                    nearestDays = diffDays;
                    nearestDeadline = candidateDate;
                    const month = candidateDate.getMonth() + 1;
                    const day = candidateDate.getDate();
                    nearestDeadlineText = `${month}月${day}日`;
                }
            }
        }

        this.nextDeadline = nearestDeadlineText || '暂无';
        this.nextDeadlineDays = nearestDays === Infinity ? 0 : nearestDays;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 本月重要提醒
                    Column() {
                        Row() {
                            Text('📅')
                                .fontSize(20)
                                .margin({ right: 8 })
                            Text('本月申报截止')
                                .fontSize(17)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                        }
            .width('100%')
                            .margin({ bottom: 16 })

                        Row() {
                            Column() {
                                Text(String(this.nextDeadlineDays > 0 ? this.nextDeadlineDays : 0))
                                    .fontSize(36)
                                    .fontWeight(FontWeight.Bold)
                                    .fontColor($r('app.color.color_red'))
                                Text('天后截止')
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                            }
                            .width(100)
                            .padding(16)
                            .backgroundColor($r('app.color.bg_blue_light'))
                            .borderRadius(12)

                            Column() {
                                Text(`下次申报截止：${this.nextDeadline}`)
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_primary'))
                                    .fontWeight(FontWeight.Medium)
                                Text('增值税、企业所得税预缴')
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ top: 4 })
                                Text('个人所得税扣缴申报')
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ top: 2 })
                                Text('附加税费申报')
                                    .fontSize(13)
                                    .fontColor($r('app.color.text_secondary'))
                                    .margin({ top: 2 })
                            }
                            .alignItems(HorizontalAlign.Start)
                            .layoutWeight(1)
                            .margin({ left: 20 })
                        }
            .width('100%')

                        Text(`* 当前日期：${this.currentYear}年${this.currentMonth}月${this.currentDay}日，遇节假日顺延`)
                            .fontSize(12)
                            .fontColor($r('app.color.text_tertiary'))
                            .margin({ top: 12 })
                    }
                    .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                    // 申报日历列表
                    Column() {
                        Text('申报日历')
                            .fontSize(17)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.text_primary'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 16 })

                        ForEach(this.deadlines, (item: TaxDeadline, index: number) => {
                            Row() {
                                Column() {
                                    Row() {
                                        if (item.important) {
                                            Text('重要')
                                                .fontSize(10)
                                                .fontColor($r('app.color.text_white'))
                                                .backgroundColor($r('app.color.color_red'))
                                                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                                                .borderRadius(4)
                                                .margin({ right: 8 })
                                        }
                                        Text(item.name)
                                            .fontSize(15)
                                            .fontColor($r('app.color.text_primary'))
                                    }
                                    Row() {
                                        Text(item.frequency)
                                            .fontSize(12)
                                            .fontColor($r('app.color.text_tertiary'))
                                        Text(' | ')
                                            .fontSize(12)
                                            .fontColor($r('app.color.light_gray'))
                                        Text(`截止：${item.deadline}`)
                                            .fontSize(12)
                                            .fontColor($r('app.color.button_primary'))
                                    }
                  .margin({ top: 4 })
                                }
                .alignItems(HorizontalAlign.Start)
                                    .layoutWeight(1)
                            }
              .width('100%')
                                .padding({ top: 12, bottom: 12 })

                            if (index < this.deadlines.length - 1) {
                                Divider().color($r('app.color.gray_border'))
                            }
                        })
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16 })

                    // 提示
                    Column() {
                        Text('💡 温馨提示')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor($r('app.color.color_orange'))
                            .alignSelf(ItemAlign.Start)
                            .margin({ bottom: 12 })
                        Text('• 申报截止日如遇法定节假日，顺延至下一工作日')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 各地区可能有差异，请以当地税务机关通知为准')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 4 })
                        Text('• 建议提前2-3天完成申报，避免系统拥堵')
                            .fontSize(13)
                            .fontColor($r('app.color.text_secondary'))
                    }
          .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_yellow_light'))
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                }
            }
      .layoutWeight(1)
                .scrollBar(BarState.Off)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title('税务日历')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }
}

