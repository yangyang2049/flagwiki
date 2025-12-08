import { NumberSeparator } from '../utils/numberFormatter';
import { PageSettings } from '../utils/pageSettings';

/**
 * 页面分位设置组件
 * 用于在页面右上角显示设置按钮和弹窗
 */
@Component
export struct PageSeparatorSettings {
  @Prop pageName: string = '';
  @Prop showDialog: boolean = false;
  @State currentSeparator: NumberSeparator = NumberSeparator.THOUSAND;
  @State pageSeparator: NumberSeparator | null = null;
  onSeparatorChange?: (separator: NumberSeparator) => void;
  onDialogClose?: () => void;

  aboutToAppear() {
    this.loadSettings();
  }

  async loadSettings() {
    this.currentSeparator = await PageSettings.getEffectiveSeparator(this.pageName);
    this.pageSeparator = await PageSettings.getPageSeparator(this.pageName);
  }

  private getSeparatorText(): string {
    switch (this.currentSeparator) {
      case NumberSeparator.NONE:
        return '不分位';
      case NumberSeparator.HUNDRED:
        return '百分位';
      case NumberSeparator.THOUSAND:
        return '千分位';
      case NumberSeparator.TEN_THOUSAND:
        return '万分位';
      default:
        return '千分位';
    }
  }

  private async saveSeparator(separator: NumberSeparator) {
    await PageSettings.savePageSeparator(this.pageName, separator);
    this.pageSeparator = separator;
    this.currentSeparator = separator;
    this.onSeparatorChange?.(separator);
  }

  build() {
    Stack() {
      if (this.showDialog) {
        this.SettingsDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TitleBarButton() {
    Image($r('app.media.icon_settings'))
      .width(24)
      .height(24)
      .onClick(() => {
        this.showDialog = true;
      })
  }

  @Builder
  SettingsDialog() {
    Stack({ alignContent: Alignment.Center }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          if (this.onDialogClose) {
            this.onDialogClose();
          }
        })

      // 对话框
      Column() {
        Text('数字分位设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ bottom: 8 })

        Text('仅对当前页面生效')
          .fontSize(12)
          .fontColor('#8E8E93')
          .margin({ bottom: 24 })

        this.SeparatorOption('不分位', NumberSeparator.NONE)
        this.SeparatorOption('百分位（每2位）', NumberSeparator.HUNDRED)
        this.SeparatorOption('千分位（每3位）', NumberSeparator.THOUSAND)
        this.SeparatorOption('万分位（每4位）', NumberSeparator.TEN_THOUSAND)

        Row() {
          Button('使用全局设置')
            .type(ButtonType.Normal)
            .backgroundColor('#F5F5F5')
            .fontColor('#666666')
            .fontSize(14)
            .layoutWeight(1)
            .height(44)
            .borderRadius(8)
            .border({ width: 1, color: '#E0E0E0' })
            .onClick(async () => {
              // 清除页面设置，使用全局设置
              const globalSeparator = await PageSettings.getGlobalSeparator();
              await PageSettings.savePageSeparator(this.pageName, null);
              this.pageSeparator = null;
              this.currentSeparator = globalSeparator;
              this.onSeparatorChange?.(globalSeparator);
              this.onDialogClose?.();
            })

          Button('确定')
            .type(ButtonType.Normal)
            .backgroundColor('#1677FF')
            .fontColor('#FFFFFF')
            .fontSize(14)
            .layoutWeight(1)
            .height(44)
            .borderRadius(8)
            .margin({ left: 12 })
            .onClick(() => {
              if (this.onDialogClose) {
                this.onDialogClose();
              }
            })
        }
        .width('100%')
        .margin({ top: 24 })
      }
      .width('100%')
      .constraintSize({ maxWidth: 400 })
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 20,
        color: '#1F000000',
        offsetX: 0,
        offsetY: 4
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SeparatorOption(label: string, value: NumberSeparator) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor('#1A1A1A')
        .layoutWeight(1)

      if (this.currentSeparator === value && this.pageSeparator === value) {
        Text('✓')
          .fontSize(18)
          .fontColor('#1677FF')
          .fontWeight(FontWeight.Bold)
      } else if (this.currentSeparator === value && this.pageSeparator === null) {
        Text('（全局）')
          .fontSize(12)
          .fontColor('#8E8E93')
      }
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
    .borderRadius(8)
    .backgroundColor(this.currentSeparator === value ? '#E6F4FF' : '#F5F5F5')
    .margin({ bottom: 8 })
    .onClick(() => {
      this.saveSeparator(value);
    })
  }
}

