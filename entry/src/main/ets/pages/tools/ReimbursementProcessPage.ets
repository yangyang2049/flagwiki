interface ProcessStep {
  step: number;
  title: string;
  role: string;
  details: string[];
  color: string;
}

@Entry
@Component
  struct ReimbursementProcessPage {
  private steps: ProcessStep[] = [
    {
      step: 1,
      title: '提交报销申请',
      role: '员工',
      details: ['填写报销单', '粘贴原始票据', '提交系统或纸质单据'],
      color: '#1677FF'
    },
    {
      step: 2,
      title: '部门审批',
      role: '部门负责人',
      details: ['审核费用合理性', '确认业务真实性', '批准或退回'],
      color: '#52C41A'
    },
    {
      step: 3,
      title: '财务审核',
      role: '财务人员',
      details: ['审核发票真伪', '检查费用合规性', '核对预算', '确认支付方式'],
      color: '#FA8C16'
    },
    {
      step: 4,
      title: '财务付款',
      role: '财务人员',
      details: ['录入支付信息', '银行转账/现金支付', '记录支付台账'],
      color: '#FA541C'
    },
    {
      step: 5,
      title: '会计入账',
      role: '会计人员',
      details: ['制作会计凭证', '费用分类归集', '处理税务抵扣'],
      color: '#722ED1'
    },
    {
      step: 6,
      title: '凭证归档',
      role: '会计人员',
      details: ['装订原始凭证', '匹配凭证编号', '归档保存'],
      color: '#13C2C2'
    }
  ];

  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 流程说明
          Column() {
            Text('报销流程说明')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 12 })

            Text('报销涉及财务审核付款和会计入账归档两个阶段，两者配合保证费用真实、支付合规、账务准确。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
          }
          .width('100%')
            .padding(20)
            .backgroundColor($r('app.color.bg_card'))
            .margin({ top: 16, left: 16, right: 16 })
            .alignItems(HorizontalAlign.Start)

          // 流程步骤
          ForEach(this.steps, (step: ProcessStep) => {
            Column() {
              Row() {
                // 步骤编号
                Stack() {
                  Circle()
                    .width(40)
                    .height(40)
                    .fill(step.color)
                  Text(`${step.step}`)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_white'))
                }
                .margin({ right: 16 })

                // 步骤信息
                Column() {
                  Row() {
                    Text(step.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_primary'))
                      .layoutWeight(1)
                    Text(step.role)
                      .fontSize(12)
                      .fontColor($r('app.color.text_white'))
                      .backgroundColor(step.color)
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(4)
                      .alignSelf(ItemAlign.Center)
                  }
                  .width('100%')
                    .alignItems(VerticalAlign.Center)
                    .margin({ bottom: 8 })

                  ForEach(step.details, (detail: string) => {
                    Row() {
                      Text('•')
                        .fontSize(14)
                        .fontColor(step.color)
                        .margin({ right: 8 })
                      Text(detail)
                        .fontSize(13)
                        .fontColor($r('app.color.text_secondary'))
                        .layoutWeight(1)
                    }
                    .width('100%')
                      .margin({ bottom: 4 })
                  })
                }
                .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
              }
              .width('100%')
                .alignItems(VerticalAlign.Center)

              // 连接线（除了最后一步）
              if (step.step < this.steps.length) {
                Column() {
                  Column()
                    .width(2)
                    .height(20)
                    .backgroundColor($r('app.color.harmony_dark'))
                }
                .width('100%')
                  .alignItems(HorizontalAlign.Center)
                  .margin({ top: 8, bottom: 8 })
              }
            }
            .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.bg_card'))
              .margin({ top: step.step === 1 ? 16 : 0, left: 16, right: 16 })
              .alignItems(HorizontalAlign.Start)
          })

          // 职责分工说明
          Column() {
            Text('财务 vs 会计职责分工')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            Row() {
              Column() {
                Text('财务职责')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.color_orange_red'))
                  .margin({ bottom: 12 })
                Text('• 审核发票真伪')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 审核费用合规性')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 控制预算')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 办理付款')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
              }
              .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .padding(16)
                .backgroundColor($r('app.color.bg_red_light'))
                .borderRadius(8)

              Column() {
                Text('会计职责')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.color_purple'))
                  .margin({ bottom: 12 })
                Text('• 制作会计凭证')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 费用分类归集')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 税务处理')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ bottom: 6 })
                Text('• 凭证归档')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
              }
              .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .padding(16)
                .backgroundColor($r('app.color.bg_yellow_light'))
                .borderRadius(8)
                .margin({ left: 12 })
            }
            .width('100%')
          }
          .width('100%')
            .padding(20)
            .backgroundColor($r('app.color.bg_card'))
            .margin({ top: 16, left: 16, right: 16, bottom: 16 })
            .alignItems(HorizontalAlign.Start)
        }
      }
      .layoutWeight(1)
        .scrollBar(BarState.Off)
        .backgroundColor($r('app.color.bg_page'))
    }
    .title('报销流程')
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor($r('app.color.bg_page'))
  }
}

