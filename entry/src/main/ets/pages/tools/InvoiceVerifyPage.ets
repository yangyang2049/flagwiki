import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Want } from '@kit.AbilityKit';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct InvoiceVerifyPage {
  private context = getContext(this) as common.UIAbilityContext;

  @State showError: boolean = false;
  @State errorMessage: string = '';

  private async openInvoiceWebsite(): Promise<void> {
    // 先显示确认对话框
    try {
      await promptAction.showDialog({
        title: '跳转到外部网站',
        message: '即将跳转到国家税务总局发票查验平台（官方网站）。是否继续？',
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '前往', color: $r('app.color.button_primary') }
        ]
      }).then((result) => {
        // 用户点击"前往"按钮（索引为1）
        if (result.index === 1) {
          this.doOpenInvoiceWebsite();
        }
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async doOpenInvoiceWebsite(): Promise<void> {
    const url = 'https://inv-veri.chinatax.gov.cn';
    
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
        // 如果都失败，显示错误提示和手动输入选项
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

          // 官方查验入口
          Column() {
            Text('🔍')
              .fontSize(48)
              .margin({ bottom: 16 })
            Text('国家税务总局')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Text('全国增值税发票查验平台')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 8 })

            Button('前往查验')
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.button_primary'))
              .fontColor($r('app.color.text_white'))
              .fontSize(16)
              .width(200)
              .height(48)
              .borderRadius(24)
              .margin({ top: 24 })
              .onClick(() => {
                this.openInvoiceWebsite();
              })

            Row() {
              Text('https://inv-veri.chinatax.gov.cn')
                .fontSize(12)
                .fontColor($r('app.color.text_tertiary'))
              Text('（点击复制）')
                .fontSize(11)
                .fontColor($r('app.color.button_primary'))
                .margin({ left: 8 })
            }
            .margin({ top: 12 })
            .onClick(() => {
              // 复制到剪贴板
              const systemPasteboard = pasteboard.getSystemPasteboard();
              const data: pasteboard.PasteData = pasteboard.createPlainTextData('https://inv-veri.chinatax.gov.cn');
              systemPasteboard.setPasteData(data).then(() => {
                try {
                  promptAction.showToast({
                    message: '网址已复制到剪贴板',
                    duration: 2000
                  });
                } catch (err) {
                  console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
                }
              }).catch(() => {
                try {
                  promptAction.showToast({
                    message: '复制失败，请手动输入网址',
                    duration: 2000
                  });
                } catch (err) {
                  console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
                }
              });
            })
          }
          .width('100%')
          .padding(40)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 0, left: 16, right: 16 })

          // 查验说明
          Column() {
            Text('查验须知')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            this.InfoItem('1', '准备发票代码、发票号码、开票日期、校验码后6位')
            this.InfoItem('2', '每张发票每天可查验5次')
            this.InfoItem('3', '支持增值税专用发票、普通发票、电子发票等')
            this.InfoItem('4', '查验结果仅供参考，以税务机关认定为准')
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .margin({ top: 16, left: 16, right: 16 })

          // 其他查验渠道
          Column() {
            Text('其他查验渠道')
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 16 })

            this.ChannelItem('微信小程序', '搜索"票大侠"或"发票助手"')
            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
            this.ChannelItem('支付宝', '搜索"发票管家"')
            Divider().color($r('app.color.gray_border')).margin({ top: 12, bottom: 12 })
            this.ChannelItem('各省电子税务局', '登录当地电子税务局网站')
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
    .title('发票真伪查询')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  InfoItem(num: string, text: string) {
    Row() {
      Text(num)
        .fontSize(12)
        .fontColor($r('app.color.text_white'))
        .backgroundColor($r('app.color.button_primary'))
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

  @Builder
  ChannelItem(title: string, desc: string) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontColor($r('app.color.text_primary'))
      Text(desc)
        .fontSize(13)
        .fontColor($r('app.color.text_tertiary'))
        .margin({ top: 4 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

