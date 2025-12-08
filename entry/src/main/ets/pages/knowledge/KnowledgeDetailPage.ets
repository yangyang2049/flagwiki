import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { TextReaderUtil } from '../../utils/TextReaderUtil';
import { FavoritesManager, FavoriteItem } from '../../utils/favoritesManager';
import promptAction from '@ohos.promptAction';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

interface ContentItem {
    type: 'blank' | 'title' | 'subtitle' | 'bullet' | 'text';
    text: string;
}

@Entry
@Component
export struct KnowledgeDetailPage {
    @State title: string = '';
    @State category: string = '';
    @State content: string = '';
    @State isFavorite: boolean = false;
    @State isReading: boolean = false;
    private context = getContext(this) as common.UIAbilityContext;
    private pageUrl: string = '';

    async aboutToAppear() {
        const params = router.getParams() as Record<string, string>;
        if (params) {
            this.title = params['title'] || '';
            this.category = params['category'] || '';
            this.content = params['content'] || '';
            this.pageUrl = `knowledge:${this.title}`;
        }
        
        // 初始化 FavoritesManager
        try {
            await FavoritesManager.init(this.context);
        } catch (err) {
            console.error(`Failed to init FavoritesManager: ${JSON.stringify(err)}`);
        }
        
        // 初始化 TextReader
        try {
            await TextReaderUtil.init(this.context);
            TextReaderUtil.setEventListener();
            TextReaderUtil.setActionListener();
        } catch (err) {
            console.error(`Failed to init TextReader: ${JSON.stringify(err)}`);
        }
        
        // 检查收藏状态
        try {
            this.isFavorite = await FavoritesManager.isFavorite(this.pageUrl);
        } catch (err) {
            console.error(`Failed to check favorite status: ${JSON.stringify(err)}`);
            this.isFavorite = false;
        }
    }

    parseContent(): ContentItem[] {
        const lines = this.content.split('\n');
        const result: ContentItem[] = [];

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i];
            if (line.trim() === '') {
                // 空行 - 只在非首尾位置添加
                if (i > 0 && i < lines.length - 1) {
                    result.push({ type: 'blank', text: '' });
                }
            } else if (this.isTitleLine(line)) {
                // 标题行
                result.push({ type: 'title', text: line });
            } else if (this.isSubTitleLine(line)) {
                // 子标题行
                result.push({ type: 'subtitle', text: line });
            } else if (this.isBulletPoint(line)) {
                // 列表项
                result.push({ type: 'bullet', text: line.trim().substring(1).trim() });
            } else {
                // 普通段落
                result.push({ type: 'text', text: line });
            }
        }
        return result;
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    // 分类标签和操作按钮
                    if (this.category !== '') {
                        Row() {
                            Text(this.category)
                                .fontSize(12)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.button_primary'))
                                .backgroundColor($r('app.color.bg_blue_light'))
                                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                                .borderRadius(4)
                            
                            Blank()
                            
                            // 朗读按钮
                            Image($r('app.media.icon_voice'))
                                .width(20)
                                .height(20)
                                .colorFilter(this.isReading ? $r('app.color.button_primary') : $r('app.color.text_primary'))
                                .onClick(() => {
                                    this.onReadClick();
                                })
                                .margin({ left: 20 })
                            
                            // 分享按钮
                            Image($r('app.media.icon_share'))
                                .width(20)
                                .height(20)
                                .colorFilter($r('app.color.text_secondary'))
                                .onClick(() => {
                                    this.onShareClick();
                                })
                                .margin({ left: 20 })
                            
                            // 收藏按钮
                            Image(this.isFavorite ? $r('app.media.icon_favorite_selected') : $r('app.media.icon_favorite'))
                                .width(20)
                                .height(20)
                                .onClick(() => {
                                    this.onFavoriteClick();
                                })
                                .margin({ left: 20, right: 16 })
                        }
                            .width('100%')
                            .height(40)
                            .justifyContent(FlexAlign.SpaceBetween)
                            .alignItems(VerticalAlign.Center)
                            .margin({ bottom: 16 })
                    }

                    // 内容 - 格式化显示
                    this.formatContent()
                }
                    .width('100%')
                    .constraintSize({ maxWidth: 400 })
                    .margin({ left: 8, right: 8 })
                    .alignSelf(ItemAlign.Center)
                    .alignItems(HorizontalAlign.Start)
                    .padding(16)
            }
      .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
        }
    .title(this.title)
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))
    }

    @Builder
    formatContent() {
        Column() {
            ForEach(this.parseContent(), (item: ContentItem, index: number) => {
                if (item.type === 'blank') {
                    Blank()
                        .height(8)
                } else if (item.type === 'title') {
                    Text(item.text)
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .fontColor($r('app.color.text_primary'))
                        .lineHeight(26)
                        .alignSelf(ItemAlign.Start)
                        .margin({ top: 16, bottom: 8 })
                } else if (item.type === 'subtitle') {
                    Text(item.text)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor($r('app.color.text_dark'))
                        .lineHeight(24)
                        .alignSelf(ItemAlign.Start)
                        .margin({ top: 12, bottom: 4, left: 16 })
                } else if (item.type === 'bullet') {
                    Row() {
                        Text('•')
                            .fontSize(16)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ right: 8 })
                        Text(item.text)
                            .fontSize(16)
                            .fontColor($r('app.color.text_primary'))
                            .lineHeight(24)
                            .layoutWeight(1)
                    }
                        .margin({ left: 16, bottom: 4 })
                } else {
                    Text(item.text)
                        .fontSize(16)
                        .fontColor($r('app.color.text_primary'))
                        .lineHeight(24)
                        .alignSelf(ItemAlign.Start)
                        .margin({ bottom: 4 })
                }
            })
        }
            .alignItems(HorizontalAlign.Start)
    }

    isTitleLine(line: string): boolean {
        // 标题特征：以中文冒号结尾，且前面没有太多内容
        const trimmed = line.trim();
        return trimmed.endsWith('：') && !trimmed.includes('•') &&
            (trimmed.length <= 20 || /^\d+\.\s/.test(trimmed));
    }

    isSubTitleLine(line: string): boolean {
        // 子标题：以数字开头且包含冒号
        const trimmed = line.trim();
        return /^\d+\.\s.*：$/.test(trimmed) ||
            (trimmed.endsWith('：') && trimmed.length > 20 && !this.isTitleLine(line));
    }

    isBulletPoint(line: string): boolean {
        // 列表项：以 • 开头
        return line.trim().startsWith('•');
    }

    private async onReadClick(): Promise<void> {
        if (this.isReading) {
            TextReaderUtil.stopRead();
            this.isReading = false;
            promptAction.showToast({
                message: '已停止朗读',
                duration: 2000
            });
        } else {
            try {
                await TextReaderUtil.startRead(this.context, this.title, this.content);
                this.isReading = true;
                promptAction.showToast({
                    message: '开始朗读',
                    duration: 2000
                });
            } catch (err) {
                console.error(`Failed to start read: ${JSON.stringify(err)}`);
                promptAction.showToast({
                    message: '朗读功能暂不可用',
                    duration: 2000
                });
            }
        }
    }

    private async onShareClick(): Promise<void> {
        try {
            const shareText = `${this.title}\n\n${this.content}`;
            
            // 创建分享数据
            const shareData: systemShare.SharedData = new systemShare.SharedData({
                utd: uniformTypeDescriptor.UniformDataType.TEXT,
                content: shareText,
                title: this.title,
                description: '知识库内容'
            });

            // 创建分享控制器
            const controller: systemShare.ShareController = new systemShare.ShareController(shareData);

            // 显示分享面板
            await controller.show(this.context, {
                selectionMode: systemShare.SelectionMode.SINGLE,
                previewMode: systemShare.SharePreviewMode.DEFAULT
            });

            console.info('Share panel opened successfully');
        } catch (err) {
            const error = err as BusinessError;
            console.error(`Failed to share: code: ${error?.code}, message: ${error?.message}`);
            promptAction.showToast({
                message: '分享失败',
                duration: 2000
            });
        }
    }

    private async onFavoriteClick(): Promise<void> {
        try {
            // 确保 FavoritesManager 已初始化
            await FavoritesManager.init(this.context);
            
            const favoriteItem: FavoriteItem = {
                name: this.title,
                pageUrl: this.pageUrl
            };
            
            const success = await FavoritesManager.toggleFavorite(favoriteItem);
            if (success) {
                this.isFavorite = !this.isFavorite;
                promptAction.showToast({
                    message: this.isFavorite ? '已收藏' : '已取消收藏',
                    duration: 2000
                });
            } else {
                promptAction.showToast({
                    message: '操作失败',
                    duration: 2000
                });
            }
        } catch (err) {
            console.error(`Failed to toggle favorite: ${JSON.stringify(err)}`);
            promptAction.showToast({
                message: '操作失败',
                duration: 2000
            });
        }
    }
}
