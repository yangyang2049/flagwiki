import { ResManager, RouterMap, RouterUtils, scanSandboxMusicFiles, SearchModel } from 'lib_common';
import { LengthMetrics } from '@kit.ArkUI';
import { getMusicModel, MediaService, MusicModel, SongItem } from 'module_musicplay';
import { common } from '@kit.AbilityKit';
import { SearchComponent } from '../components/SearchComponent';
import { HomeViewModel } from '../viewmodels/HomeViewModel';
import { SongServiceApi } from 'lib_music_api';

@Builder
export function SearchPageBuilder() {
  SearchPage()
}

@ComponentV2
struct SearchPage {
  @Local vm: HomeViewModel = new HomeViewModel();
  stack: NavPathStack = RouterUtils.getStack();
  @Provider('appPathStack') appPathStack: NavPathStack = RouterUtils.getStack();
  private searchController: SearchModel = SearchModel.instance;
  @Local searchKey: string = '';
  @Local textWidth: number = 0;
  @Local musicModel: MusicModel = getMusicModel();
  @Local initialKeyword: string = '';

  aboutToAppear() {
    const params = RouterUtils.getParamByName<Record<string, string>>(RouterMap.SEARCH_PAGE);
    this.initialKeyword = params?.initialKeyword ?? '';
  }

  build() {
    NavDestination() {
      Column() {
        SearchComponent({
          appPathStack: this.appPathStack,
          initialPlaceholder: this.initialKeyword,
          hotSearchBuilder: this.hotSearch.bind(this),
          historySearchBuilder: this.historySearch.bind(this),
          searchResultBuilder: this.searchResult.bind(this),
          getSearchResult: this.getSearchResult.bind(this),
        });
      }
      .margin({ top: 30 })
      .width('100%')
      .height('100%')
      .padding({
        top: 30,
        left: 15,
        right: 15
      })
      .backgroundColor('#f2f4f5')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .padding({
      bottom: this.vm.windowModel.windowBottomPadding
    })
    .onBackPressed(() => {
      this.searchController.isShowResult = false;
      this.appPathStack.pop();
      return true;
    });
  }

  @Builder
  hotSearch() {
    Column() {
      Row() {
        Text('热搜榜').fontSize(16).fontColor('rgba(0,0,0,0.90)');
      }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 17 }).width('100%');

      Column() {
        ForEach(this.searchController.hotSearch.slice(0, 10), (item: string, index: number) => {
          Row() {
            Text((index + 1).toString())
              .fontSize(16)
              .fontColor(index < 3 ? '#f2364b' : '#c1c1c1')
              .width(24)
              .textAlign(TextAlign.Center)

            Text(item)
              .fontSize(15)
              .fontColor('rgba(0,0,0,0.90)')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          }
          .width('100%')
          .height(36)
          .padding({ left: 12, right: 12 })
          .onClick(() => {
            this.searchController.updateSearchCondition(item);
            this.searchController.isShowResult = true;
            this.searchController.updateHistorySearch(item);
            this.getSearchResult();
          })
        }, (item: string, index: number) => item+index)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .padding({ top: 8, bottom: 8 })
    }.margin({ bottom: 20 })
  }

  @Builder
  historySearch() {
    Column() {
      Row() {
        Text('历史搜索').fontSize(16).fontColor('rgba(0,0,0,0.90)');

        Blank();

        Image($r('app.media.trash'))
          .width(20)
          .height(20)
          .onClick(() => {
            AlertDialog.show({
              title: '',
              message: '确定要清空搜索历史吗?',
              primaryButton: {
                value: '取消',
                fontColor: '#333333',
                backgroundColor: Color.Transparent,
                action: () => {
                }
              },
              secondaryButton: {
                value: '确定',
                fontColor: '#FF3B30',
                backgroundColor: Color.Transparent,
                action: () => {
                  this.searchController.clearAllHistory();
                }
              },
              alignment: DialogAlignment.Center,
              gridCount: 2,
              autoCancel: true,
              width: '80%',
              height: 150
            });
          });
      }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 12 }).width('100%');

      Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(8), cross: LengthMetrics.vp(8) } }) {
        ForEach(this.searchController.historySearch, (item: string, index: number) => {
          Row() {
            Text(item)
              .fontSize(14)
              .fontColor('rgba(0,0,0,0.60)')
              .maxLines(1)
              .margin({ right: 5 })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .onClick(() => {
                this.searchController.updateSearchCondition(item);
                this.searchController.isShowResult = true;
                this.searchController.updateHistorySearch(item);
                this.getSearchResult();
              });
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontSize(15)
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
              .fontColor([Color.Black])
              .onClick(() => {
                this.searchController.deleteHistoryItem(index);
              })
          }
          .padding({
            top: 6,
            bottom: 6,
            left: 12,
            right: 6
          })
          .backgroundColor('#e5e7e9')
          .borderRadius(15)
          .alignItems(VerticalAlign.Center);
        }, (item: string) => JSON.stringify(item));
      }
      .margin({ bottom: 20 })
      .width('100%');
    }
  }

  @Builder
  searchResult() {
    Column() {
      Row() {
        ForEach(['综合', '在线', '本地'], (tab: string, index: number) => {
          Text(tab)
            .fontSize(16)
            .fontColor(this.searchController.currentTab === index ? '#007AFF' : '#666666')
            .fontWeight(this.searchController.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
            .padding({
              top: 12,
              bottom: 12,
              left: 16,
              right: 16
            })
            .onClick(() => {
              this.searchController.switchTab(index);
            })
        }, (item: string) => item);
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor('#f2f4f5')

      if (this.searchController.getFilteredSearchResult().length === 0) {
        Column() {
          Image($r('app.media.no_search_result_found'))
            .width(120)
            .height(120)
          Text('暂无相关歌曲')
            .fontSize(14)
            .fontColor('rgba(0,0,0,0.40)')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.searchController.getFilteredSearchResult(), (song: SongItem) => {
            ListItem() {
              Row() {
                Image(ResManager.getPic(song.label))
                  .width(48)
                  .height(48)
                  .borderRadius(4)
                  .backgroundColor('#F5F5F5')

                Column() {
                  // 标题关键词高亮
                  Text() {
                    this.buildHighlightSpans(song.title, this.searchController.searchCondition, 16, '#333333')
                  }
                  .fontSize(16)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')

                  Row() {
                    // 标识：本地 > VIP（非VIP不显示）
                    if (song.isLocal) {
                      Image($r('app.media.ic_local'))
                        .height(16)
                        .width(25)
                        .margin({ right: 4 })
                    } else if (song.isVip) {
                      Image($r('app.media.ic_vip'))
                        .height(16)
                        .width(25)
                        .margin({ right: 4 })
                    }
                    // 歌手关键词高亮
                    Text() {
                      this.buildHighlightSpans(song.singer, this.searchController.searchCondition, 14, '#666666')
                    }
                    .fontSize(14)
                    .maxLines(1)
                    .margin({ left: 5 })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  }
                  .width('100%')
                  .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })

                Image(
                  this.musicModel.isPlay && (
                    (this.musicModel.currentSong?.src && this.musicModel.currentSong?.src === (song.src ?? '')) ||
                      (!this.musicModel.currentSong?.src && (this.musicModel.currentSong?.id ?? '') === (song.id ?? ''))
                  ) ? $r('app.media.zhibozhong') : $r('app.media.bofang')
                )
                  .width(20)
                  .height(20)
                  .onClick(() => {
                    const currentId: string = this.musicModel.currentSong?.id ?? '';
                    const currentSrc: string = this.musicModel.currentSong?.src ?? '';
                    const isCurrent: boolean = (currentSrc && currentSrc === (song.src ?? '')) ||
                      (!currentSrc && currentId !== '' && currentId === (song.id ?? ''));
                    if (isCurrent) {
                      MediaService.getInstance().playAndPause()
                    } else {
                      MediaService.getInstance().playSong(song);
                    }
                  })
              }
              .width('100%')
              .height(64)
              .padding({ left: 16, right: 16 })
              .backgroundColor('#f2f4f5')
            }
            .onClick(() => {
              // 播放音乐并打开播放页
              MediaService.getInstance().playSong(song, true);
            })
          }, (song: SongItem) => JSON.stringify(song));

          if (this.searchController.isLoading) {
            ListItem() {
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#007AFF')
                Text('正在加载中...')
                  .fontSize(14)
                  .fontColor('#999999')
                  .margin({ left: 8 })
              }
              .width('100%')
              .height(50)
              .justifyContent(FlexAlign.Center)
            }
          }
        }
        .margin({ bottom: 60 })
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          const totalItems = this.searchController.getFilteredSearchResult().length;
          if (lastIndex >= totalItems - 2 && this.searchController.hasMoreData && !this.searchController.isLoading) {
            this.searchController.loadMoreData();
          }
        })
      }
    }
    .layoutWeight(1)
    .backgroundColor('#f2f4f5')
  }

  @Builder
  buildHighlightSpans(text: string, query: string, baseFontSize: number = 14, normalColor: string = '#333333') {
    if (!query || query.trim() === '') {
      Span(text)
        .fontSize(baseFontSize)
        .fontColor(normalColor)
    } else {
      ForEach(this.splitTextForHighlight(text, query), (part: string) => {
        if (part.toLowerCase() === query.toLowerCase()) {
          Span(part)
            .fontSize(baseFontSize)
            .fontColor('#dc374a')
            .fontWeight(FontWeight.Bold)
        } else {
          Span(part)
            .fontSize(baseFontSize)
            .fontColor(normalColor)
        }
      }, (part: string, index: number) => `${part}-${index}`)
    }
  }

  private splitTextForHighlight(text: string, query: string): string[] {
    try {
      const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      const regex = new RegExp(`(${escaped})`, 'gi');
      return text.split(regex);
    } catch (_) {
      return [text];
    }
  }

  getSearchResult() {
    const ctx = getContext(this) as common.UIAbilityContext;
    const onlineSongs: Array<SongItem> = SongServiceApi.queryAllSongList();
    scanSandboxMusicFiles(ctx).then((localSongs: Array<SongItem>) => {
      this.searchController.searchMusic(this.searchController.searchCondition, [...localSongs, ...onlineSongs]);
    }).catch(() => {
      this.searchController.searchMusic(this.searchController.searchCondition, onlineSongs);
    });
  }
}
