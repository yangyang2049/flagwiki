import { promptAction } from '@kit.ArkUI';
import { RecommendItem, SearchModel } from 'lib_common';
import { SongServiceApi } from 'lib_music_api';
import { getMusicModel, MusicModel, MusicPlayController, SongItem } from 'module_musicplay';

@ComponentV2
export struct SearchComponent {
  private searchController: SearchModel = SearchModel.instance;
  @Param @Require appPathStack: NavPathStack;
  @Param initialPlaceholder: string = '';
  @Local searchCondition: string = '';
  @BuilderParam hotSearchBuilder: VoidCallback;
  @BuilderParam historySearchBuilder: VoidCallback;
  @BuilderParam searchResultBuilder: VoidCallback;
  @Param @Require getSearchResult: VoidCallback;
  @Local textWidth: number = 0;
  @Local showSuggestions: boolean = false;
  @Local searchSuggestions: string[] = [];
  @Local songData: Array<SongItem> = [];
  @Local musicModel: MusicModel = getMusicModel();
  private debounceTimer: number = -1;

  aboutToAppear() {
    this.songData = SongServiceApi.queryAllSongList()
    this.searchController.generateRecommendList(this.songData);
    this.searchController.setSearchInputUpdateCallback((searchText: string) => {
      this.searchCondition = searchText;
    });
  }

  aboutToDisappear() {
    this.clearDebounceTimer();
  }

  clearDebounceTimer() {
    if (this.debounceTimer !== -1) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = -1;
    }
  }

  debouncedGenerateSuggestions(query: string) {
    this.clearDebounceTimer();
    this.debounceTimer = setTimeout(() => {
      this.generateSearchSuggestions(query);
    }, 300);
  }

  generateSearchSuggestions(query: string) {
    if (!query.trim()) {
      this.searchSuggestions = [];
      this.showSuggestions = false;
      return;
    }

    let suggestions: string[] = [];

    this.songData.forEach((song: SongItem) => {
      if (song.title.toLowerCase().includes(query.toLowerCase())) {
        suggestions.push(song.title);
      }
    });

    this.songData.forEach((song: SongItem) => {
      if (song.singer.toLowerCase().includes(query.toLowerCase())) {
        suggestions.push(song.singer);
      }
    });

    const uniqueSuggestions = suggestions.filter((item, index) => suggestions.indexOf(item) === index);
    this.searchSuggestions = uniqueSuggestions.sort((a, b) => {
      return a.localeCompare(b, 'en', { numeric: true });
    }).slice(0, 10);

    this.showSuggestions = this.searchSuggestions.length > 0;
  }

  @Builder
  highlightText(text: string, query: string) {
    if (!query.trim()) {
      Text(text)
        .fontSize(14)
        .fontColor('#333333')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    } else {
      Text() {
        this.buildHighlightSpans(text, query)
      }
      .fontSize(14)
      .layoutWeight(1)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }

  @Builder
  buildHighlightSpans(text: string, query: string) {
    ForEach(this.splitTextForHighlight(text, query), (part: string) => {
      if (part.toLowerCase() === query.toLowerCase()) {
        Span(part)
          .fontSize(14)
          .fontColor('#dc374a')
          .fontWeight(FontWeight.Bold)
      } else {
        Span(part)
          .fontSize(14)
          .fontColor('#333333')
      }
    }, (item: string) => item)
  }

  private splitTextForHighlight(text: string, query: string): string[] {
    const regex = new RegExp(`(${query})`, 'gi');
    return text.split(regex);
  }

  build() {
    Column() {
      this.SearchBuilder()

      if (this.showSuggestions && !this.searchController.isShowResult) {
        Column() {
          ForEach(this.searchSuggestions, (suggestion: string) => {
            Row() {
              Image($r('app.media.search'))
                .width(16)
                .height(16)
                .margin({ right: 12 })
                .fillColor('#000')

              this.highlightText(suggestion, this.searchCondition)
            }
            .width('100%')
            .height(44)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.searchCondition = suggestion;
              this.searchController.searchCondition = suggestion;
              this.searchController.isShowResult = true;
              this.searchController.updateHistorySearch(suggestion);
              this.getSearchResult();
              this.showSuggestions = false;
            })
          }, (item: string) => item)
        }
        .margin({ top: 8 })
      }

      if (!this.searchController.isShowResult) {
        Scroll() {
          Column() {
            if (!this.showSuggestions) {
              if (this.searchController.historySearch.length > 0) {
                this.historySearchBuilder()
              }
              this.loveSearchBuilder()
              this.hotSearchBuilder()
            }
          }
          .width('100%')
          .padding({ top: 20, bottom: 10 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .width('100%')
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })

      } else {
        this.searchResultBuilder();
      }
      // 播放条
      MusicPlayController()
        .margin({ bottom: 50 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SearchBuilder() {
    Row() {
      Image($r('app.media.back'))
        .width(35)
        .height(35)
        .borderRadius(30)
        .padding(8)
        .backgroundColor('#e5e7e9')
        .onClick(() => {
          if (this.searchController.isShowResult) {
            this.searchController.isShowResult = false;
            this.showSuggestions = false;
            this.searchCondition = '';
            this.searchController.searchCondition = '';
          } else {
            this.appPathStack.pop();
          }
        });
      Blank();

      Search({
        placeholder: this.initialPlaceholder || this.searchController.hotSearch[0] || '请输入关键字查询',
        value: $$this.searchCondition,
      })
        .placeholderFont({ size: 14 })
        .placeholderColor('rgba(0,0,0,0.60)')
        .layoutWeight(1)
        .height(40)
        .backgroundColor('#e5e7e9')
        .borderRadius(20)
        .padding({ left: 16, right: 16 })
        .margin({
          left: '4%',
          right: '4%',
        })
        .onChange((searchCondition: string) => {
          this.searchCondition = searchCondition;
          if (searchCondition === '') {
            this.searchController.isShowResult = false;
            this.searchController.searchCondition = '';
            this.showSuggestions = false;
          } else {
            this.generateSearchSuggestions(searchCondition);
          }
        })
        .onSubmit((searchCondition: string) => {
          let keyword: string = searchCondition?.trim() || this.initialPlaceholder?.trim() || '';
          if (keyword === '') {
            promptAction.showToast({
              message: '请输入搜索内容',
              duration: 1000,
            });
            return;
          }

          this.searchCondition = keyword;
          this.searchController.isShowResult = true;
          this.searchController.updateHistorySearch(keyword);
          this.searchController.searchCondition = keyword;
          this.getSearchResult();
          this.showSuggestions = false;
        });

      Blank();

      Text('搜索')
        .fontSize(14)
        .fontColor('rgba(0,0,0,0.90)')
        .onClick(() => {
          let keyword: string = this.searchCondition?.trim() || this.initialPlaceholder?.trim() || '';
          if (keyword === '') {
            promptAction.showToast({
              message: '请输入搜索内容',
              duration: 1000,
            });
            return;
          }
          this.searchCondition = keyword;
          this.searchController.isShowResult = true;
          this.searchController.searchCondition = keyword;
          this.searchController.updateHistorySearch(keyword);
          this.getSearchResult();
          this.showSuggestions = false;
        });
    }

    .width('100%');
  }

  @Builder
  loveSearchBuilder() {
    Column() {
      Row() {
        Text('猜你喜欢').fontSize(16).fontColor('rgba(0,0,0,0.90)');
        Blank();
        SymbolGlyph($r('sys.symbol.arrow_clockwise'))
          .fontSize(16)
          .onClick(() => {
            this.searchController.refreshRecommendList(this.songData);
          });
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 12 })
      .width('100%');

      Grid() {
        ForEach(this.searchController.recommendList, (item: RecommendItem) => {
          GridItem() {
            Column() {
              Text(item.title)
                .fontSize(14)
                .fontColor('rgba(0,0,0,0.90)')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')
                .textAlign(TextAlign.Start);

              Text(item.singer)
                .fontSize(12)
                .fontColor('rgba(0,0,0,0.60)')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 4 });
            }
            .width('100%')
            .padding({
              top: 8,
              bottom: 8,
              left: 4,
              right: 4
            })
            .onClick(() => {
              this.searchCondition = item.title;
              this.searchController.searchCondition = item.title;
              this.searchController.isShowResult = true;
              this.searchController.updateHistorySearch(item.title);
              this.getSearchResult();
              this.showSuggestions = false;
            });
          };
        }, (item: RecommendItem) => item.id);
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap(8)
      .columnsGap(8)
      .width('100%');
    }
    .height(220)
  }
}
