import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { SongItem } from 'lib_music_api';
import { Logger } from '../../../../Index';

export interface RecommendItem {
  id: string;
  title: string;
  singer: string;
}

@ObservedV2
export class SearchModel {
  private static _instance: SearchModel;

  public static get instance() {
    if (!SearchModel._instance) {
      SearchModel._instance = new SearchModel();
    }
    return SearchModel._instance;
  }

  // 搜索框更新回调
  private searchInputUpdateCallback?: (searchText: string) => void;
  @Trace searchCondition: string = '';
  @Trace musicSearchResult: Array<SongItem> = [];
  @Trace isShowResult: boolean = false;
  @Trace currentTab: number = 0; // 0:综合 1:在线 2:本地
  // 分页相关变量
  @Trace currentPage: number = 1;
  @Trace pageSize: number = 10;
  @Trace isLoading: boolean = false;
  @Trace hasMoreData: boolean = true;
  @Trace allSearchResults: Array<SongItem> = []; // 存储所有搜索结果
  // 热门搜索 - 使用真实歌曲数据
  @Trace hotSearch: Array<string> = [];
  // 完整的搜索历史（不限制数量）
  private fullHistorySearch: Array<string> = [];
  // 显示的搜索历史（限制10条）
  @Trace historySearch: Array<string> = [];
  // 猜你喜欢推荐列表
  @Trace recommendList: Array<RecommendItem> = [];

  // 设置搜索框更新回调
  setSearchInputUpdateCallback(callback: (searchText: string) => void) {
    this.searchInputUpdateCallback = callback;
  }

  // 更新搜索条件并通知搜索框
  updateSearchCondition(searchText: string) {
    this.searchCondition = searchText;
    if (this.searchInputUpdateCallback) {
      this.searchInputUpdateCallback(searchText);
    }
  }

  updateHistorySearch(content: string) {
    // 在完整历史记录中查找
    let index: number = this.fullHistorySearch.indexOf(content);
    if (index === -1) {
      // 新搜索词，添加到完整历史记录的开头
      this.fullHistorySearch.unshift(content);
    } else {
      // 已存在的搜索词，移到完整历史记录的开头
      this.fullHistorySearch.splice(index, 1);
      this.fullHistorySearch.unshift(content);
    }
    // 更新显示的搜索历史记录（限制10条）
    this.updateDisplayHistory();
  }

  // 更新显示的搜索历史记录
  private updateDisplayHistory() {
    this.historySearch = this.fullHistorySearch.slice(0, 10);
  }

  // 删除指定的历史记录
  deleteHistoryItem(index: number) {
    // 从完整历史记录中删除
    this.fullHistorySearch.splice(index, 1);
    // 更新显示的搜索历史记录
    this.updateDisplayHistory();
  }

  // 清空所有搜索历史
  clearAllHistory() {
    this.fullHistorySearch = [];
    this.historySearch = [];
  }

  // 生成热门搜索数据
  generateHotSearch(songData: Array<SongItem>) {
    if (songData.length === 0) {
      this.hotSearch = [];
      return;
    }

    // 从歌曲数据中提取歌曲名和歌手名作为热门搜索
    const hotSearchItems: string[] = [];

    // 添加歌曲名
    songData.forEach((song: SongItem) => {
      if (song.title && !hotSearchItems.includes(song.title)) {
        hotSearchItems.push(song.title);
      }
    });

    // 添加歌手名
    songData.forEach((song: SongItem) => {
      if (song.singer && !hotSearchItems.includes(song.singer)) {
        hotSearchItems.push(song.singer);
      }
    });

    // 随机打乱并取前10个作为热门搜索
    const shuffleds = [...hotSearchItems].sort(() => {
      return this.getSecurityRandom() - 0.5;
    });
    this.hotSearch = shuffleds.slice(0, 10);
  }

  // 从songData中随机返回9首歌曲
  generateRecommendList(songData: Array<SongItem>) {
    if (songData.length === 0) {
      this.recommendList = [];
      return;
    }

    // 创建副本并随机打乱数组
    const shuffledSongs = [...songData].sort(() => {
      return this.getSecurityRandom() - 0.5;
    });

    // 获取前9首歌曲
    this.recommendList = shuffledSongs.slice(0, 9).map((song: SongItem): RecommendItem => {
      return {
        id: song.id,
        singer: song.singer,
        title: song.title
      }
    })
  }

  // 随机返回0-1的随机数据
  getSecurityRandom(): number {
    return cryptoFramework.createRandom().generateRandomSync(1).data[0] / 255;
  }


  // 刷新推荐列表
  refreshRecommendList(songData: Array<SongItem>) {
    this.generateRecommendList(songData);
  }


  // 搜索音乐
  searchMusic(query: string, allSongs: Array<SongItem>) {
    if (!query.trim()) {
      this.musicSearchResult = [];
      this.allSearchResults = [];
      this.resetPagination();
      return;
    }

    // 开始新搜索时，先清空上一次的可见结果，避免短暂显示旧结果
    this.musicSearchResult = [];
    this.isLoading = true;

    const filteredSongs = allSongs.filter((song: SongItem) => {
      const titleMatch = song.title.toLowerCase().includes(query.toLowerCase());
      const singerMatch = song.singer.toLowerCase().includes(query.toLowerCase());
      return titleMatch || singerMatch;
    });

    // 存储所有搜索结果
    this.allSearchResults = filteredSongs;
    // 重置分页
    this.resetPagination();
    // 加载第一页数据
    this.loadMoreData();
  }

  // 重置分页状态
  resetPagination() {
    this.currentPage = 1;
    this.hasMoreData = true;
    this.isLoading = false;
  }

  // 加载更多数据
  loadMoreData() {
    if (this.isLoading || !this.hasMoreData) {
      return;
    }

    this.isLoading = true;

    // 模拟网络延迟
    setTimeout(() => {
      const startIndex = (this.currentPage - 1) * this.pageSize;
      const endIndex = startIndex + this.pageSize;
      const newData = this.allSearchResults.slice(startIndex, endIndex);

      if (this.currentPage === 1) {
        // 第一页，替换数据
        this.musicSearchResult = newData;
      } else {
        // 后续页，追加数据
        this.musicSearchResult = [...this.musicSearchResult, ...newData];
      }

      // 检查是否还有更多数据
      this.hasMoreData = endIndex < this.allSearchResults.length;
      this.currentPage++;
      this.isLoading = false;
    }, 500); // 500ms延迟模拟网络请求
  }

  // 根据标签页过滤搜索结果
  getFilteredSearchResult(): Array<SongItem> {
    switch (this.currentTab) {
      case 0: // 综合
        return this.musicSearchResult;
      case 1: // 在线
        return this.musicSearchResult.filter((song: SongItem) => !song.isLocal);
      case 2: // 本地
        return this.musicSearchResult.filter((song: SongItem) => song.isLocal);
      default:
        return this.musicSearchResult;
    }
  }

  // 切换标签页
  switchTab(tabIndex: number) {
    if (this.currentTab !== tabIndex) {
      this.currentTab = tabIndex;
      // 切换标签页时重新加载数据
      // 先清空现有可见结果并置为加载中，避免短暂显示旧数据
      this.musicSearchResult = [];
      this.resetPagination();
      this.loadMoreData();
    }
  }
}