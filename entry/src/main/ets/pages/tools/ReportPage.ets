import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Want } from '@kit.AbilityKit';
import promptAction from '@ohos.promptAction';

interface ReportType {
  name: string;
  desc: string;
}

@Entry
@Component
struct ReportPage {
  private context = getContext(this) as common.UIAbilityContext;
  
  @State reportTypes: ReportType[] = [
    { name: '偷税漏税', desc: '企业或个人故意少缴、不缴税款' },
    { name: '虚开发票', desc: '虚开增值税专用发票或其他发票' },
    { name: '假发票', desc: '使用假发票、伪造发票' },
    { name: '会计造假', desc: '伪造会计凭证、账簿、报表' },
    { name: '骗取出口退税', desc: '以假报出口等方式骗取出口退税' },
    { name: '其他税收违法', desc: '其他税收违法行为' }
  ];

  @State showError: boolean = false;
  @State errorMessage: string = '';

  private async openReportWebsite(): Promise<void> {
    // 先显示确认对话框
    try {
      await promptAction.showDialog({
        title: '跳转到外部网站',
        message: '即将跳转到国家税务总局税收违法行为举报平台（官方网站）。是否继续？',
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '前往', color: $r('app.color.button_primary') }
        ]
      }).then((result) => {
        // 用户点击"前往"按钮（索引为1）
        if (result.index === 1) {
          this.doOpenReportWebsite();
        }
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async doOpenReportWebsite(): Promise<void> {
    const url = 'https://fgk.chinatax.gov.cn/jzxx2023/wfjj2023.html';
    
    // 优先尝试使用通用 Intent 打开 URL
    const want: Want = {
      action: 'ohos.want.action.viewData',
      uri: url,
      type: 'text/html'
    };

    try {
      await this.context.startAbility(want);
    } catch (err) {
      // 如果通用 Intent 失败，尝试华为浏览器
      try {
        await this.context.startAbility({
          bundleName: 'com.huawei.hmos.browser',
          abilityName: 'com.huawei.hmos.browser.MainAbility',
          uri: url,
          parameters: {
            url: url
          }
        });
      } catch (browserErr) {
        // 如果都失败，显示错误提示
        this.errorMessage = '无法自动打开浏览器，请手动复制网址到浏览器访问';
        this.showError = true;
        setTimeout(() => {
          this.showError = false;
        }, 5000);
      }
    }
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 错误提示
          if (this.showError) {
            Row() {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor($r('app.color.text_white'))
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            }
              .width('100%')
              .backgroundColor($r('app.color.color_red'))
              .justifyContent(FlexAlign.Center)
              .margin({ top: 0, left: 16, right: 16 })
          }

          // 举报说明
          Column() {
            Text('🚨')
              .fontSize(48)
              .margin({ bottom: 16 })
            Text('税收违法行为举报')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })
            Text('维护税收秩序，打击税收违法')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Button('前往国家税务总局举报')
              .type(ButtonType.Normal)
              .fontSize(16)
              .fontColor($r('app.color.text_white'))
              .backgroundColor($r('app.color.color_red'))
              .width('80%')
              .constraintSize({ maxWidth: 280 })
              .height(48)
              .borderRadius(24)
              .margin({ top: 24 })
              .onClick(() => {
                this.openReportWebsite();
              })
          }
          .width('100%')
          .padding(32)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 0, left: 16, right: 16 })

          // 举报类型
          Column() {
            Text('常见举报类型')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            ForEach(this.reportTypes, (type: ReportType) => {
              Column() {
                Row() {
                  Text('•')
                    .fontSize(20)
                    .fontColor($r('app.color.color_red'))
                    .margin({ right: 8 })
                  Column() {
                    Text(type.name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('app.color.text_primary'))
                      .alignSelf(ItemAlign.Start)
                    Text(type.desc)
                      .fontSize(13)
                      .fontColor($r('app.color.text_tertiary'))
                      .margin({ top: 4 })
                      .alignSelf(ItemAlign.Start)
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding({ top: 12, bottom: 12 })
              }
              .width('100%')
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 16, left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)

          // 举报方式
          Column() {
            Text('举报方式')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            this.ReportMethodItem('📱', '12366纳税服务热线', '拨打当地12366纳税服务热线')
            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
            this.ReportMethodItem('💻', '网上举报', '登录国家税务总局或当地税务局网站')
            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
            this.ReportMethodItem('✉️', '信函举报', '向当地税务机关邮寄举报信')
            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
            this.ReportMethodItem('🏢', '现场举报', '前往当地税务机关现场举报')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 16, left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)

          // 举报须知
          Column() {
            Text('⚠️ 举报须知')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.color_orange'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            this.NoticeItem('1', '实名举报优先受理，匿名举报也会依法处理')
            this.NoticeItem('2', '提供具体线索和证据，提高办理效率')
            this.NoticeItem('3', '举报人信息依法保密，保护举报人权益')
            this.NoticeItem('4', '不得诬告陷害他人，否则承担法律责任')
            this.NoticeItem('5', '举报属实的，可依规定获得奖励')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_orange_light'))
          .margin({ top: 16, left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)

          // 联系方式
          Column() {
            Text('📞 举报咨询')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            Row() {
              Column() {
                Text('全国统一热线')
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                Text('12366')
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.button_primary'))
                  .margin({ top: 8 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Column() {
                Text('举报中心')
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                Text('010-63417425')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.button_primary'))
                  .margin({ top: 8 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')

            Text('• 工作时间：周一至周五 9:00-17:00')
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .margin({ top: 16 })
              .alignSelf(ItemAlign.Start)
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
    .title('税务违法举报')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  ReportMethodItem(icon: string, title: string, desc: string) {
    Row() {
      Text(icon)
        .fontSize(24)
        .margin({ right: 12 })
      Column() {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .alignSelf(ItemAlign.Start)
        Text(desc)
          .fontSize(13)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 4 })
          .alignSelf(ItemAlign.Start)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }

  @Builder
  NoticeItem(num: string, text: string) {
    Row() {
      Text(num)
        .fontSize(12)
        .fontColor($r('app.color.text_white'))
        .backgroundColor($r('app.color.color_orange'))
        .width(20)
        .height(20)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
      Text(text)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ left: 12 })
        .layoutWeight(1)
    }
    .width('100%')
    .margin({ bottom: 12 })
  }
}

