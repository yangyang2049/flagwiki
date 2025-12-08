import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

interface ChecklistItem {
  category: string;
  items: string[];
  color: string;
}

@Entry
@Component
  struct ReimbursementChecklistPage {
  @State checkedItems: Set<string> = new Set();
  @State checklists: ChecklistItem[] = [];
  @State isEditMode: boolean = false;
  @State editingItemIndex: number = -1;
  @State editingCategoryIndex: number = -1;
  @State newItemText: string = '';
  @State newCategoryName: string = '';
  @State newCategoryColor: string = '#1677FF';

  private prefs: preferences.Preferences | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  private defaultChecklists: ChecklistItem[] = [
    {
      category: '发票审核',
      color: '#1677FF',
      items: [
        '发票真伪验证（扫码/查验平台）',
        '发票类型是否正确（专票/普票）',
        '发票抬头与公司名称一致',
        '发票金额与报销单一致',
        '发票日期在合理范围内',
        '发票专用章清晰完整',
        '是否为重复报销',
        '电子发票是否已打印归档'
      ]
    },
    {
      category: '费用合规性审核',
      color: '#52C41A',
      items: [
        '费用属于业务发生的真实费用',
        '费用在预算范围内',
        '费用符合公司报销制度',
        '不存在不合理支出（娱乐、个人消费）',
        '差旅费标准符合规定（住宿、交通）',
        '业务招待费符合限额要求',
        '是否需要领导或额外审批'
      ]
    },
    {
      category: '预算控制',
      color: '#FA8C16',
      items: [
        '同类费用占比是否合理',
        '部门费用耗用情况',
        '是否超预算',
        '超预算是否需要升级审批',
        '月度/季度预算执行情况'
      ]
    },
    {
      category: '支付审核',
      color: '#FA541C',
      items: [
        '报销人信息准确',
        '收款账户信息正确',
        '支付金额与审核金额一致',
        '支付方式选择合理（转账/现金）',
        '支付台账记录完整'
      ]
    }
  ];

  async aboutToAppear() {
    try {
      this.prefs = await preferences.getPreferences(this.context, 'app_settings');
      await this.loadChecklists();
    } catch (err) {
      console.error(`Failed to init: ${JSON.stringify(err)}`);
      this.checklists = [...this.defaultChecklists];
    }
  }

  private async loadChecklists(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await preferences.getPreferences(this.context, 'app_settings');
      }
      const savedData: string = await this.prefs.get('checklists', '') as string;
      if (savedData && savedData !== '') {
        this.checklists = JSON.parse(savedData) as ChecklistItem[];
      } else {
        this.checklists = [...this.defaultChecklists];
      }
    } catch (err) {
      console.error(`Failed to load checklists: ${JSON.stringify(err)}`);
      this.checklists = [...this.defaultChecklists];
    }
  }

  private async saveChecklists(): Promise<void> {
    try {
      if (!this.prefs) {
        this.prefs = await preferences.getPreferences(this.context, 'app_settings');
      }
      // 过滤掉没有条目的分类
      const validChecklists = this.checklists.filter((checklist: ChecklistItem) => {
        return checklist.items.length > 0;
      });
      await this.prefs.put('checklists', JSON.stringify(validChecklists));
      await this.prefs.flush();
      // 更新本地数据，移除空分类
      this.checklists = validChecklists;
      promptAction.showToast({
        message: '已保存',
        duration: 2000
      });
    } catch (err) {
      console.error(`Failed to save checklists: ${JSON.stringify(err)}`);
      promptAction.showToast({
        message: '保存失败',
        duration: 2000
      });
    }
  }

  private toggleItem(item: string) {
    if (this.checkedItems.has(item)) {
      this.checkedItems.delete(item);
    } else {
      this.checkedItems.add(item);
    }
  }

  private clearAll() {
    this.checkedItems.clear();
  }

  private checkAllInSection(checklist: ChecklistItem) {
    const allChecked = checklist.items.every((item: string) => this.checkedItems.has(item));
    if (allChecked) {
      // 如果已全选，则取消全选
      checklist.items.forEach((item: string) => {
        this.checkedItems.delete(item);
      });
    } else {
      // 如果未全选，则全选
      checklist.items.forEach((item: string) => {
        this.checkedItems.add(item);
      });
    }
  }

  private isSectionAllChecked(checklist: ChecklistItem): boolean {
    return checklist.items.length > 0 && checklist.items.every((item: string) => this.checkedItems.has(item));
  }

  private addItem(categoryIndex: number): void {
    if (!this.newItemText || this.newItemText.trim() === '') {
      promptAction.showToast({
        message: '请输入条目内容',
        duration: 2000
      });
      return;
    }
    this.checklists[categoryIndex].items.push(this.newItemText.trim());
    this.newItemText = '';
    this.editingItemIndex = -1;
    this.saveChecklists();
  }

  private deleteItem(categoryIndex: number, itemIndex: number): void {
    const item = this.checklists[categoryIndex].items[itemIndex];
    this.checklists[categoryIndex].items.splice(itemIndex, 1);
    this.checkedItems.delete(item);
    this.saveChecklists();
  }

  private editItem(categoryIndex: number, itemIndex: number): void {
    this.editingCategoryIndex = categoryIndex;
    this.editingItemIndex = itemIndex;
    this.newItemText = this.checklists[categoryIndex].items[itemIndex];
  }

  private saveEditItem(): void {
    if (this.editingCategoryIndex >= 0 && this.editingItemIndex >= 0) {
      if (!this.newItemText || this.newItemText.trim() === '') {
        promptAction.showToast({
          message: '请输入条目内容',
          duration: 2000
        });
        return;
      }
      const oldItem = this.checklists[this.editingCategoryIndex].items[this.editingItemIndex];
      this.checklists[this.editingCategoryIndex].items[this.editingItemIndex] = this.newItemText.trim();
      if (this.checkedItems.has(oldItem)) {
        this.checkedItems.delete(oldItem);
        this.checkedItems.add(this.newItemText.trim());
      }
      this.editingItemIndex = -1;
      this.editingCategoryIndex = -1;
      this.newItemText = '';
      this.saveChecklists();
    }
  }

  private cancelEdit(): void {
    this.editingItemIndex = -1;
    this.editingCategoryIndex = -1;
    this.newItemText = '';
  }

  private addCategory(): void {
    if (!this.newCategoryName || this.newCategoryName.trim() === '') {
      promptAction.showToast({
        message: '请输入分类名称',
        duration: 2000
      });
      return;
    }
    this.checklists.push({
      category: this.newCategoryName.trim(),
      color: this.newCategoryColor,
      items: []
    });
    this.newCategoryName = '';
    // 不立即保存，等用户添加条目后再保存
  }

  private deleteCategory(categoryIndex: number): void {
    const category = this.checklists[categoryIndex];
    category.items.forEach((item: string) => {
      this.checkedItems.delete(item);
    });
    this.checklists.splice(categoryIndex, 1);
    this.saveChecklists();
  }

  @Builder
  MenuBuilder() {
    Row() {
      if (this.isEditMode) {
        Image($r('app.media.icon_done'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.isEditMode = false;
            this.cancelEdit();
            this.saveChecklists();
          })
      } else {
        Image($r('app.media.icon_edit'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.isEditMode = true;
          })
      }
    }
    .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: 16 })
  }

  build() {
    Navigation() {
      Column() {
        Scroll() {
          Column() {
            // 说明
            Column() {
              Text('财务审核 Checklist')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Text('财务人员在审核报销时需要逐项检查以下内容，确保费用真实、合规、准确。')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .lineHeight(22)
            }
          .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.bg_card'))
              .margin({ top: 0, left: 16, right: 16 })
              .alignItems(HorizontalAlign.Start)

            // 审核清单
            ForEach(this.checklists, (checklist: ChecklistItem, categoryIndex: number) => {
              Column() {
                Row() {
                  Text(checklist.category)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(checklist.color)
                    .layoutWeight(1)

                  if (!this.isEditMode) {
                    Text(this.isSectionAllChecked(checklist) ? '取消全选' : '全选')
                      .fontSize(12)
                      .fontColor(checklist.color)
                      .onClick(() => {
                        this.checkAllInSection(checklist);
                      })
                  } else {
                    Text('删除分类')
                      .fontSize(12)
                      .fontColor($r('app.color.color_red'))
                      .onClick(() => {
                        this.deleteCategory(categoryIndex);
                      })
                  }
                }
              .width('100%')
                  .margin({ bottom: 12 })

                ForEach(checklist.items, (item: string, itemIndex: number) => {
                  if (this.isEditMode && this.editingCategoryIndex === categoryIndex && this.editingItemIndex === itemIndex) {
                    // 编辑模式
                    Row() {
                      TextInput({ text: this.newItemText, placeholder: '请输入条目内容' })
                        .layoutWeight(1)
                        .onChange((val: string) => {
                          this.newItemText = val;
                        })
                      Button('保存')
                        .type(ButtonType.Normal)
                        .fontSize(12)
                        .height(32)
                        .borderRadius(4)
                        .margin({ left: 8 })
                        .onClick(() => {
                          this.saveEditItem();
                        })
                      Button('取消')
                        .type(ButtonType.Normal)
                        .fontSize(12)
                        .height(32)
                        .borderRadius(4)
                        .margin({ left: 8 })
                        .onClick(() => {
                          this.cancelEdit();
                        })
                    }
                  .width('100%')
                      .padding({ top: 12, bottom: 12 })
                      .margin({ bottom: 8 })
                  } else {
                    // 正常显示模式
                    Row() {
                      if (!this.isEditMode) {
                        Checkbox()
                          .select(this.checkedItems.has(item))
                          .selectedColor(checklist.color)
                          .onChange((checked: boolean) => {
                            if (checked) {
                              this.checkedItems.add(item);
                            } else {
                              this.checkedItems.delete(item);
                            }
                          })
                          .margin({ right: 12 })
                      } else {
                        Blank()
                          .width(28)
                          .height(28)
                      }

                      Text(item)
                        .fontSize(14)
                        .fontColor(this.checkedItems.has(item) ? $r('app.color.text_tertiary') : $r('app.color.text_primary'))
                        .decoration({ type: this.checkedItems.has(item) ? TextDecorationType.LineThrough : TextDecorationType.None })
                        .layoutWeight(1)

                      if (this.isEditMode) {
                        Row() {
                          Text('编辑')
                            .fontSize(12)
                            .fontColor($r('app.color.button_primary'))
                            .margin({ right: 12 })
                            .onClick(() => {
                              this.editItem(categoryIndex, itemIndex);
                            })
                          Text('删除')
                            .fontSize(12)
                            .fontColor($r('app.color.color_red'))
                            .onClick(() => {
                              this.deleteItem(categoryIndex, itemIndex);
                            })
                        }
                      }
                    }
                  .width('100%')
                      .padding({ top: 12, bottom: 12 })
                      .borderRadius(8)
                      .backgroundColor(this.checkedItems.has(item) ? $r('app.color.bg_secondary') : $r('app.color.bg_card'))
                      .margin({ bottom: 8 })
                      .onClick(() => {
                        if (!this.isEditMode) {
                          this.toggleItem(item);
                        }
                      })
                  }
                })

                // 添加新条目
                if (this.isEditMode) {
                  Row() {
                    TextInput({ text: this.newItemText, placeholder: '输入新条目' })
                      .layoutWeight(1)
                      .onChange((val: string) => {
                        this.newItemText = val;
                      })
                    Button('添加')
                      .type(ButtonType.Normal)
                      .fontSize(12)
                      .height(32)
                      .borderRadius(4)
                      .margin({ left: 8 })
                      .onClick(() => {
                        this.addItem(categoryIndex);
                      })
                  }
                .width('100%')
                    .margin({ top: 8 })
                }
              }
            .width('100%')
                .padding(20)
                .backgroundColor($r('app.color.bg_card'))
                .margin({ top: 16, left: 16, right: 16 })
                .alignItems(HorizontalAlign.Start)
            })

            // 添加新分类
            if (this.isEditMode) {
              Column() {
                Text('添加新分类')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_primary'))
                  .alignSelf(ItemAlign.Start)
                  .margin({ bottom: 12 })

                TextInput({ text: this.newCategoryName, placeholder: '输入分类名称' })
                  .width('100%')
                  .height(44)
                  .backgroundColor($r('app.color.bg_secondary'))
                  .borderRadius(8)
                  .onChange((val: string) => {
                    this.newCategoryName = val;
                  })
                  .margin({ bottom: 12 })

                Button('添加分类')
                  .type(ButtonType.Normal)
                  .fontSize(14)
                  .width('100%')
                  .height(44)
                  .borderRadius(8)
                  .onClick(() => {
                    this.addCategory();
                  })
              }
            .width('100%')
                .padding(20)
                .backgroundColor($r('app.color.bg_card'))
                .margin({ top: 16, left: 16, right: 16 })
                .alignItems(HorizontalAlign.Start)
            }

            // 操作按钮
            Button('清空所有')
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.button_primary'))
              .fontColor($r('app.color.text_white'))
              .fontSize(14)
              .width('80%')
              .constraintSize({ maxWidth: 320 })
              .height(44)
              .borderRadius(8)
              .enabled(this.checkedItems.size > 0)
              .margin({ left: 16, right: 16, top: 16, bottom: 16 })
              .onClick(() => {
                this.clearAll();
              })
          }
        }
        .layoutWeight(1)
          .scrollBar(BarState.Off)
          .backgroundColor($r('app.color.bg_page'))
      }
      .width('100%')
        .height('100%')
    }
    .title('财务审核清单')
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor($r('app.color.bg_page'))
      .menus(this.MenuBuilder)
      .onTitleModeChange((titleMode: NavigationTitleMode) => {
        // 处理标题栏模式变化
      })
  }

  // onBackPress(): boolean {
  //   return true;
  // }
}

