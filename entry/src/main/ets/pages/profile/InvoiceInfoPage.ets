import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { saveInvoiceInfo, getInvoiceInfo, deleteInvoiceInfo, InvoiceInfo, formatInvoiceInfoForDisplay } from '../../utils/invoiceInfoStore';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import pasteboard from '@ohos.pasteboard';
import { InputValidator } from '../../utils/inputValidator';

@Entry
@Component
export struct InvoiceInfoPage {
  @State companyName: string = '';
  @State taxNumber: string = '';
  @State address: string = '';
  @State phone: string = '';
  @State bankName: string = '';
  @State bankAccount: string = '';
  @State savedInfo: InvoiceInfo | null = null;
  @State isModified: boolean = false;
  @State isLoading: boolean = true;
  private context: common.UIAbilityContext | null = null;

  async aboutToAppear() {
    // 确保 context 已初始化
    if (!this.context) {
      this.context = getContext(this) as common.UIAbilityContext;
    }
    await this.loadInvoiceInfo();
    this.isLoading = false;
  }

  private async loadInvoiceInfo(): Promise<void> {
    // 确保 context 已初始化
    if (!this.context) {
      this.context = getContext(this) as common.UIAbilityContext;
    }

    if (!this.context) {
      console.error('Context is not available');
      return;
    }

    try {
      const info = await getInvoiceInfo(this.context);
      console.info(`Loaded invoice info: ${JSON.stringify(info)}`);

      if (info) {
        // 先更新 savedInfo，再更新各个字段，确保状态一致性
        this.savedInfo = {
          companyName: info.companyName || '',
          taxNumber: info.taxNumber || '',
          address: info.address || '',
          phone: info.phone || '',
          bankName: info.bankName || '',
          bankAccount: info.bankAccount || ''
        };
        // 同步更新所有状态变量，确保 UI 刷新
        this.companyName = this.savedInfo.companyName;
        this.taxNumber = this.savedInfo.taxNumber;
        this.address = this.savedInfo.address;
        this.phone = this.savedInfo.phone;
        this.bankName = this.savedInfo.bankName;
        this.bankAccount = this.savedInfo.bankAccount;
        // 检查修改状态
        this.checkModified();
        console.info(`Invoice info loaded successfully, companyName: ${this.companyName}`);
      } else {
        // 如果没有保存的信息，清空所有字段
        console.info('No saved invoice info found');
        this.savedInfo = null;
        this.companyName = '';
        this.taxNumber = '';
        this.address = '';
        this.phone = '';
        this.bankName = '';
        this.bankAccount = '';
        this.isModified = false;
      }
    } catch (err) {
      console.error(`Failed to load invoice info: ${JSON.stringify(err)}`);
      this.savedInfo = null;
      this.companyName = '';
      this.taxNumber = '';
      this.address = '';
      this.phone = '';
      this.bankName = '';
      this.bankAccount = '';
      this.isModified = false;
    }
  }

  private checkModified(): void {
    if (!this.savedInfo) {
      this.isModified = true;
      return;
    }

    const currentInfo: InvoiceInfo = {
      companyName: this.companyName.trim(),
      taxNumber: this.taxNumber.trim().toUpperCase(),
      address: this.address.trim(),
      phone: this.phone.trim(),
      bankName: this.bankName.trim(),
      bankAccount: this.bankAccount.trim()
    };

    this.isModified =
      currentInfo.companyName !== this.savedInfo.companyName ||
      currentInfo.taxNumber !== this.savedInfo.taxNumber ||
      currentInfo.address !== this.savedInfo.address ||
      currentInfo.phone !== this.savedInfo.phone ||
      currentInfo.bankName !== this.savedInfo.bankName ||
      currentInfo.bankAccount !== this.savedInfo.bankAccount;
  }

  private validateCompanyName(name: string): string | null {
    const trimmed = name.trim();
    if (trimmed.length === 0) {
      return '公司抬头不能为空';
    }
    if (trimmed.length > 100) {
      return '公司抬头不能超过100个字符';
    }
    return null;
  }

  private validateTaxNumber(taxNumber: string): string | null {
    const trimmed = taxNumber.trim();
    if (trimmed.length === 0) {
      return '纳税人识别号不能为空';
    }
    // 统一社会信用代码：18位，由数字和大写字母组成
    // 旧的纳税人识别号：15位或18位数字
    if (trimmed.length !== 15 && trimmed.length !== 18) {
      return '纳税人识别号应为15位或18位';
    }
    // 统一社会信用代码格式：前17位为数字或大写字母，最后一位为数字或大写字母
    const creditCodePattern = /^[0-9A-Z]{18}$/;
    // 旧的纳税人识别号格式：15位或18位数字
    const oldTaxNumberPattern = /^[0-9]{15}$|^[0-9]{18}$/;
    if (!creditCodePattern.test(trimmed) && !oldTaxNumberPattern.test(trimmed)) {
      return '纳税人识别号格式不正确，应为15位或18位数字，或18位统一社会信用代码（数字和大写字母）';
    }
    return null;
  }

  private validateAddress(address: string): string | null {
    const trimmed = address.trim();
    if (trimmed.length === 0) {
      return '注册地址不能为空';
    }
    if (trimmed.length > 200) {
      return '注册地址不能超过200个字符';
    }
    return null;
  }

  private validatePhone(phone: string): string | null {
    const trimmed = phone.trim();
    if (trimmed.length === 0) {
      return '注册电话不能为空';
    }
    if (trimmed.length > 20) {
      return '注册电话不能超过20个字符';
    }

    // 提取所有数字
    const digits = trimmed.replace(/\D/g, '');
    const digitCount = digits.length;

    // 手机号：11位数字，以1开头，第二位为3-9
    const mobilePattern = /^1[3-9]\d{9}$/;

    if (mobilePattern.test(digits)) {
      // 验证手机号格式：只能包含数字和空格
      const cleaned = trimmed.replace(/\s/g, '');
      if (cleaned !== digits) {
        return '手机号格式不正确，只能包含数字和空格';
      }
      return null;
    } else {
      // 座机号验证：可以包含数字、横线、空格、括号
      const landlinePattern = /^[\d\s\-()]+$/;
      if (!landlinePattern.test(trimmed)) {
        return '座机号格式不正确，只能包含数字、横线、空格和括号';
      }
      // 座机号：7-11位数字（含区号）
      if (digitCount < 7 || digitCount > 11) {
        return '座机号应为7-11位数字（含区号）';
      }
      return null;
    }
  }

  private validateBankName(bankName: string): string | null {
    const trimmed = bankName.trim();
    if (trimmed.length === 0) {
      return '开户行不能为空';
    }
    if (trimmed.length > 100) {
      return '开户行不能超过100个字符';
    }
    return null;
  }

  private validateBankAccount(account: string): string | null {
    const trimmed = account.trim();
    if (trimmed.length === 0) {
      return '银行账号不能为空';
    }
    if (trimmed.length < 10) {
      return '银行账号至少应为10位数字';
    }
    if (trimmed.length > 30) {
      return '银行账号不能超过30位数字';
    }
    // 银行账号应为纯数字
    const accountPattern = /^[0-9]+$/;
    if (!accountPattern.test(trimmed)) {
      return '银行账号只能包含数字';
    }
    return null;
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          if (this.isLoading) {
            // 加载状态
            Row() {
              LoadingProgress()
                .width(24)
                .height(24)
                .color($r('app.color.button_primary'))
              Text('加载中...')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ left: 8 })
            }
            .width('100%')
              .height(200)
              .justifyContent(FlexAlign.Center)
          } else {
            Column() {
              Text('填写或编辑您的开票信息，保存后可在首页快速查看。')
                .fontSize(13)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ bottom: 12 })
                .alignSelf(ItemAlign.Start)

              this.inputField('公司抬头', '请输入公司全称', this.companyName, (v: string) => {
                this.companyName = v;
                this.checkModified();
              }, InputType.Normal, 100)
              this.inputField('纳税人识别号', '请输入统一社会信用代码（18位）', this.taxNumber, (v: string) => {
                this.taxNumber = v;
                this.checkModified();
              }, InputType.Normal, 18)
              this.inputField('注册地址', '如：北京市xx路xx号', this.address, (v: string) => {
                this.address = v;
                this.checkModified();
              }, InputType.Normal, 200)
              this.inputField('注册电话', '如：010-12345678', this.phone, (v: string) => {
                this.phone = v;
                this.checkModified();
              }, InputType.PhoneNumber, 20)
              this.inputField('开户行', '如：xx银行xx支行', this.bankName, (v: string) => {
                this.bankName = v;
                this.checkModified();
              }, InputType.Normal, 100)
              this.inputField('银行账号', '如：1234567890', this.bankAccount, (v: string) => {
                this.bankAccount = v;
                this.checkModified();
              }, InputType.Number, 30)

              // 根据保存状态和修改状态显示不同按钮
              if (this.savedInfo && !this.isModified) {
                // 已保存且未修改：显示复制和编辑按钮

                // 温馨提示
                Row() {
                  Text('温馨提示：开票信息涉密，可使用系统自带应用锁保护。')
                    .fontSize(12)
                    .fontColor($r('app.color.color_orange'))
                    .layoutWeight(1)
                }
                .width('100%')
                  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                  .backgroundColor($r('app.color.bg_orange_light'))
                  .borderRadius(8)
                  .margin({ top: 16, bottom: 12 })

                Row() {
                  Button('复制')
                    .type(ButtonType.Normal)
                    .backgroundColor($r('app.color.button_primary'))
                    .fontColor($r('app.color.text_white'))
                    .fontSize(16)
                    .layoutWeight(1)
                    .height(44)
                    .borderRadius(8)
                    .onClick(() => {
                      this.copyInvoiceInfo();
                    })

                  Blank().width(12)

                  Button('编辑')
                    .type(ButtonType.Normal)
                    .backgroundColor($r('app.color.gray_very_light'))
                    .fontColor($r('app.color.text_dark'))
                    .fontSize(16)
                    .layoutWeight(1)
                    .height(44)
                    .borderRadius(8)
                    .onClick(() => {
                      // 点击编辑后，允许修改，按钮会变为保存
                      this.isModified = true;
                    })

                  Blank().width(12)

                  Button('删除')
                    .type(ButtonType.Normal)
                    .backgroundColor($r('app.color.gray_very_light'))
                    .fontColor($r('app.color.color_red'))
                    .fontSize(16)
                    .layoutWeight(1)
                    .height(44)
                    .borderRadius(8)
                    .onClick(() => {
                      this.showDeleteConfirmDialog();
                    })
                }
                .width('100%')
                  .margin({ top: 0 })
              } else {
                // 未保存或已修改：显示保存按钮
                Button('保存')
                  .width('100%')
                  .height(44)
                  .backgroundColor($r('app.color.button_primary'))
                  .fontColor($r('app.color.text_white'))
                  .borderRadius(8)
                  .margin({ top: 16 })
                  .onClick(() => {
                    this.saveInfo();
                  })
              }
            }
            .width('100%')
              .alignItems(HorizontalAlign.Start)
              .key(`invoice_form_${this.companyName}_${this.isLoading}`)
          }
        }
        .width('100%')
          .padding(16)
          .alignItems(HorizontalAlign.Start)
      }
      .edgeEffect(EdgeEffect.Spring)
    }
    .title('开票信息')
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor($r('app.color.bg_page_alt'))
  }

  private showDeleteConfirmDialog(): void {
    try {
      promptAction.showDialog({
        title: '删除开票信息',
        message: '确定要删除已保存的开票信息吗？此操作不可恢复。',
        buttons: [
          { text: '取消', color: $r('app.color.text_secondary') },
          { text: '删除', color: $r('app.color.color_red') }
        ]
      }).then((result) => {
        // 用户点击"删除"按钮（索引为1）
        if (result.index === 1) {
          this.deleteInfo();
        }
      }).catch((err: Error) => {
        console.error(`Failed to show dialog: ${err.message}`);
      });
    } catch (err) {
      console.error(`Failed to show dialog: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  private async deleteInfo(): Promise<void> {
    // 确保 context 已初始化
    if (!this.context) {
      this.context = getContext(this) as common.UIAbilityContext;
    }

    if (!this.context) {
      promptAction.showToast({
        message: '系统错误，请稍后再试',
        duration: 2000
      });
      return;
    }

    try {
      await deleteInvoiceInfo(this.context);

      // 强制刷新：先显示加载状态，然后重新加载数据
      this.isLoading = true;

      // 清空所有字段
      this.savedInfo = null;
      this.companyName = '';
      this.taxNumber = '';
      this.address = '';
      this.phone = '';
      this.bankName = '';
      this.bankAccount = '';
      this.isModified = false;

      // 短暂延迟后重新加载，确保 UI 刷新
      setTimeout(async () => {
        await this.loadInvoiceInfo();
        this.isLoading = false;
      }, 200);

      try {
        promptAction.showToast({
          message: '已删除开票信息',
          duration: 2000
        });
      } catch (err) {
        console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
      }
    } catch (err) {
      console.error(`Failed to delete invoice info: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: '删除失败，请稍后再试',
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  @Builder
  private inputField(label: string, placeholder: string, value: string, onChange: (v: string) => void, inputType?: InputType, maxLength?: number) {
    Column() {
      Text(label)
        .fontSize(13)
        .fontColor($r('app.color.text_dark'))
        .margin({ bottom: 6 })
        .alignSelf(ItemAlign.Start)

      TextInput({ text: value, placeholder: placeholder })
        .width('100%')
        .height(44)
        .padding({ left: 12, right: 12 })
        .backgroundColor($r('app.color.bg_card'))
        .fontColor($r('app.color.text_dark'))
        .borderRadius(8)
        .type(inputType || InputType.Normal)
        .maxLength(maxLength || -1)
        .onChange((newValue: string) => {
          // 根据输入类型进行验证
          let validatedValue = newValue;
          if (inputType === InputType.Number) {
            validatedValue = InputValidator.validateBankAccount(newValue);
          } else if (inputType === InputType.PhoneNumber) {
            validatedValue = InputValidator.validatePhone(newValue);
          }
          onChange(validatedValue);
        })
    }
    .width('100%')
      .margin({ bottom: 12 })
      .alignItems(HorizontalAlign.Start)
  }

  private async saveInfo(): Promise<void> {
    // 确保 context 已初始化
    if (!this.context) {
      this.context = getContext(this) as common.UIAbilityContext;
    }

    if (!this.context) {
      promptAction.showToast({
        message: '系统错误，请稍后再试',
        duration: 2000
      });
      return;
    }

    // 校验各项字段
    const companyNameError = this.validateCompanyName(this.companyName);
    if (companyNameError) {
      promptAction.showToast({
        message: companyNameError,
        duration: 2000
      });
      return;
    }

    const taxNumberError = this.validateTaxNumber(this.taxNumber);
    if (taxNumberError) {
      promptAction.showToast({
        message: taxNumberError,
        duration: 2000
      });
      return;
    }

    const addressError = this.validateAddress(this.address);
    if (addressError) {
      promptAction.showToast({
        message: addressError,
        duration: 2000
      });
      return;
    }

    const phoneError = this.validatePhone(this.phone);
    if (phoneError) {
      promptAction.showToast({
        message: phoneError,
        duration: 2000
      });
      return;
    }

    const bankNameError = this.validateBankName(this.bankName);
    if (bankNameError) {
      promptAction.showToast({
        message: bankNameError,
        duration: 2000
      });
      return;
    }

    const bankAccountError = this.validateBankAccount(this.bankAccount);
    if (bankAccountError) {
      promptAction.showToast({
        message: bankAccountError,
        duration: 2000
      });
      return;
    }

    try {
      const info: InvoiceInfo = {
        companyName: this.companyName.trim(),
        taxNumber: this.taxNumber.trim().toUpperCase(), // 统一社会信用代码转为大写
        address: this.address.trim(),
        phone: this.phone.trim(),
        bankName: this.bankName.trim(),
        bankAccount: this.bankAccount.trim()
      };

      await saveInvoiceInfo(this.context, info);
      console.info(`Invoice info saved: ${JSON.stringify(info)}`);

      // 更新保存的信息和修改状态
      this.savedInfo = info;
      this.isModified = false;

      try {
        promptAction.showToast({
          message: '已保存开票信息',
          duration: 2000
        });
      } catch (err) {
        console.error(`Failed to show toast: ${err instanceof Error ? err.message : String(err)}`);
      }
      // 保存后不退出页面，允许继续编辑
    } catch (err) {
      console.error(`Failed to save invoice info: ${JSON.stringify(err)}`);
      try {
        promptAction.showToast({
          message: '保存失败，请稍后再试',
          duration: 2000
        });
      } catch (toastErr) {
        console.error(`Failed to show toast: ${toastErr instanceof Error ? toastErr.message : String(toastErr)}`);
      }
    }
  }

  private async copyInvoiceInfo(): Promise<void> {
    if (!this.savedInfo) {
      return;
    }

    try {
      const content = formatInvoiceInfoForDisplay(this.savedInfo);
      const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
      const pasteData: pasteboard.PasteData = pasteboard.createPlainTextData(content);
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
      console.error(`Failed to copy to clipboard: ${err instanceof Error ? err.message : String(err)}`);
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
}
