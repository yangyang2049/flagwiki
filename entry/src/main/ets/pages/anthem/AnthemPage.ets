import { common } from '@kit.AbilityKit';
import {
  Country,
  Continent,
  ContinentNames,
  ContinentNamesEN,
  getCountriesByContinent,
  getAllContinents,
  getFlagImageSource,
  getLocalizedCountryName
} from '../../utils/countryData';
import { LocalizationUtil } from '../../utils/LocalizationUtil';
import { getAnthemFilePath, hasAnthemFile, initAnthemCache } from '../../utils/AnthemUtil';
import { getAnthemNameEN, getAnthemNameCN, hasAnthemName } from '../../utils/AnthemData';
import { SongItem } from '../../utils/music/SongItem';
import { getMusicModel, MusicModel } from '../../utils/music/MusicModel';
import { MediaService } from '../../utils/music/MediaService';
import { AnthemPlayer } from '../../components/AnthemPlayer';

@Component
export struct AnthemPage {
  @State countries: Country[] = [];
  @State filteredCountries: Country[] = [];
  @State allCountries: Country[] = []; // 存储所有国家（包括没有国歌的）
  @State selectedContinent: Continent = 'World';
  @State searchText: string = '';
  @State isLoading: boolean = true;
  @Prop @Watch('onSearchExpandedChanged') isSearchExpanded: boolean = false;
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') systemLanguage: string = 'zh';
  @Prop context?: common.UIAbilityContext;
  private appContext = getContext(this) as common.UIAbilityContext;
  private musicModel: MusicModel = getMusicModel();
  private mediaService: MediaService = MediaService.getInstance();

  async aboutToAppear() {
    const context = this.context || this.appContext;
    await initAnthemCache(context);
    this.loadCountries();
    this.isLoading = false;
  }

  private onLanguageChanged(): void {
    this.loadCountries();
  }

  private onSearchExpandedChanged(): void {
    if (!this.isSearchExpanded) {
      this.searchText = '';
      this.filterCountries();
    }
  }

  private loadCountries(): void {
    // 获取所有国家
    this.allCountries = getCountriesByContinent(this.selectedContinent);
    
    // 过滤出有国歌文件的国家（用于正常列表显示）
    this.countries = this.allCountries.filter((country) => {
      return hasAnthemFile(country.code);
    });
    
    // 前10个热门国家国歌（必须包括中国）
    const top10CountryCodes = ['cn', 'us', 'gb', 'fr', 'de', 'it', 'jp', 'ca', 'ru', 'au'];
    
    // 分离出前10个国家和其他国家
    const top10Countries: Country[] = [];
    const otherCountries: Country[] = [];
    
    for (const country of this.countries) {
      if (top10CountryCodes.includes(country.code.toLowerCase())) {
        top10Countries.push(country);
      } else {
        otherCountries.push(country);
      }
    }
    
    // 按指定顺序排序前10个国家
    top10Countries.sort((a, b) => {
      const indexA = top10CountryCodes.indexOf(a.code.toLowerCase());
      const indexB = top10CountryCodes.indexOf(b.code.toLowerCase());
      return indexA - indexB;
    });
    
    // 其他国家按本地化名称排序
    const isEnglish = LocalizationUtil.isEnglish(this.systemLanguage);
    otherCountries.sort((a, b) => {
      const nameA = getLocalizedCountryName(a, this.systemLanguage);
      const nameB = getLocalizedCountryName(b, this.systemLanguage);
      return isEnglish ? nameA.localeCompare(nameB, 'en') : nameA.localeCompare(nameB, 'zh-CN');
    });
    
    // 合并：前10个国家在前，其他国家在后
    this.countries = [...top10Countries, ...otherCountries];
    
    // 对所有国家也进行排序（用于搜索）
    this.allCountries.sort((a, b) => {
      const nameA = getLocalizedCountryName(a, this.systemLanguage);
      const nameB = getLocalizedCountryName(b, this.systemLanguage);
      return isEnglish ? nameA.localeCompare(nameB, 'en') : nameA.localeCompare(nameB, 'zh-CN');
    });
    
    this.filterCountries();
  }

  private filterCountries(): void {
    if (this.searchText.trim() === '') {
      // 没有搜索时，只显示有国歌的国家
      this.filteredCountries = this.countries;
    } else {
      // 搜索时，从所有国家中搜索（包括没有国歌的）
      const keyword = this.searchText.trim().toLowerCase();
      this.filteredCountries = this.allCountries.filter((country) => {
        const localizedName = getLocalizedCountryName(country, this.systemLanguage).toLowerCase();
        return localizedName.includes(keyword) ||
          country.nameCN.toLowerCase().includes(keyword) ||
          country.name.toLowerCase().includes(keyword) ||
          country.code.toLowerCase().includes(keyword);
      });
    }
  }

  private selectContinent(continent: Continent): void {
    this.selectedContinent = continent;
    this.loadCountries();
  }

  private onSearchChange(value: string): void {
    this.searchText = value;
    this.filterCountries();
  }

  private getAnthemName(countryCode: string): string {
    if (hasAnthemName(countryCode)) {
      const isEnglish = LocalizationUtil.isEnglish(this.systemLanguage);
      return isEnglish ? getAnthemNameEN(countryCode) : getAnthemNameCN(countryCode);
    }
    // 如果没有国歌名称数据，显示通用文本
    return this.appContext.resourceManager.getStringSync($r('app.string.national_anthem').id);
  }

  /**
   * 创建歌曲项（集中化函数）
   * @param country 国家对象
   * @param songIndex 歌曲索引（从1开始，因为MediaService使用parseInt(id) - 1）
   * @returns 如果国家有国歌文件，返回SongItem；否则返回null
   */
  private createSongItem(country: Country, songIndex: number): SongItem | null {
    // 跳过没有国歌文件的国家
    if (!hasAnthemFile(country.code)) {
      return null;
    }
    
    const anthemPath = getAnthemFilePath(country.code);
    const countryName = getLocalizedCountryName(country, this.systemLanguage);
    const song: SongItem = new SongItem();
    song.id = `${songIndex}`; // MediaService使用parseInt(id) - 1，所以从1开始
    song.title = this.getAnthemName(country.code);
    song.singer = countryName;
    song.src = anthemPath;
    song.isLocal = true;
    song.label = getFlagImageSource(country.code);
    return song;
  }

  private playAnthem(country: Country): void {
    // 检查是否有国歌文件
    if (!hasAnthemFile(country.code)) {
      return;
    }
    
    // 创建歌曲列表
    const songList: SongItem[] = [];
    
    // 找到当前国家在过滤列表中的索引
    const currentIndex = this.filteredCountries.findIndex(c => c.code === country.code);
    
    if (currentIndex < 0) {
      return;
    }
    
    let songIndex = 1; // MediaService使用parseInt(id) - 1，所以从1开始
    
    // 首先添加当前国家（索引0）
    const currentSong = this.createSongItem(country, songIndex);
    if (currentSong) {
      songList.push(currentSong);
      songIndex++;
    }
    
    // 添加当前国家之后的所有国家到播放列表（只添加有国歌文件的）
    for (let i = currentIndex + 1; i < this.filteredCountries.length; i++) {
      const c: Country = this.filteredCountries[i];
      const songItem = this.createSongItem(c, songIndex);
      if (songItem) {
        songList.push(songItem);
        songIndex++;
      }
    }
    
    // 添加当前国家之前的所有国家到播放列表（只添加有国歌文件的）
    for (let i = 0; i < currentIndex; i++) {
      const c: Country = this.filteredCountries[i];
      const songItem = this.createSongItem(c, songIndex);
      if (songItem) {
        songList.push(songItem);
        songIndex++;
      }
    }
    
    // 如果列表为空，不播放
    if (songList.length === 0) {
      return;
    }
    
    // 当前播放的SongItem（第一个）
    const songItem = songList[0];
    
    // 初始化播放器
    this.mediaService.initAudioPlayer(songList, songItem);
  }

  build() {
    Stack() {
      Column() {
        // 搜索区域
        if (this.isSearchExpanded) {
          Row() {
            Search({ 
              value: this.searchText, 
              placeholder: this.appContext.resourceManager.getStringSync($r('app.string.search_country').id) 
            })
              .layoutWeight(1)
              .height(40)
              .onChange((value: string) => {
                this.onSearchChange(value);
              })
              .onSubmit((value: string) => {
                this.onSearchChange(value);
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        }

        // 洲际筛选器
        Scroll() {
          Row() {
            ForEach(getAllContinents(), (continent: Continent) => {
              this.ContinentChip(continent)
            })
          }
          .padding({ left: 16, right: 16 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .height(44)
        .backgroundColor($r('app.color.bg_title_bar'))

        // 国歌列表
        if (this.isLoading) {
          Column() {
            Text(this.appContext.resourceManager.getStringSync($r('app.string.loading').id))
              .fontSize(16)
              .fontColor($r('app.color.text_tertiary'))
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else if (this.filteredCountries.length === 0) {
          Column() {
            if (this.searchText.trim() !== '') {
              Text(this.appContext.resourceManager.getStringSync($r('app.string.no_matching_countries').id))
                .fontSize(16)
                .fontColor($r('app.color.text_tertiary'))

              Text(this.appContext.resourceManager.getStringSync($r('app.string.modify_keywords_or_select').id))
                .fontSize(12)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 8 })
                .opacity(0.7)
            } else {
              Text(this.appContext.resourceManager.getStringSync($r('app.string.no_anthem_available').id))
                .fontSize(16)
                .fontColor($r('app.color.text_tertiary'))
            }
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          List() {
            ForEach(this.filteredCountries, (country: Country) => {
              ListItem() {
                this.AnthemItem(country)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ 
            top: 8, 
            bottom: this.musicModel.currentSong ? 100 : 8 
          })
          .edgeEffect(EdgeEffect.Spring)
          .divider({ strokeWidth: 0.5, color: $r('app.color.gray_border'), startMargin: 16, endMargin: 16 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_page'))
      .justifyContent(FlexAlign.Start)
      
      // 音乐播放控制器 - 固定在底部
      if (this.musicModel.currentSong) {
        AnthemPlayer()
          .width('100%')
          .align(Alignment.Bottom)
      }
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.BottomStart)
  }

  @Builder
  ContinentChip(continent: Continent) {
    Text(LocalizationUtil.isEnglish(this.systemLanguage) ? ContinentNamesEN[continent] : ContinentNames[continent])
      .fontSize(14)
      .fontWeight(this.selectedContinent === continent ? FontWeight.Medium : FontWeight.Normal)
      .fontColor(this.selectedContinent === continent ? $r('app.color.white') : $r('app.color.text_secondary'))
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor(this.selectedContinent === continent ? $r('app.color.button_primary') : $r('app.color.bg_secondary'))
      .borderRadius(16)
      .margin({ right: 8 })
      .onClick(() => {
        this.selectContinent(continent);
      })
  }

  @Builder
  AnthemItem(country: Country) {
    Row() {
      // 国旗图标
      Image(getFlagImageSource(country.code))
        .width(48)
        .height(48)
        .objectFit(ImageFit.Contain)
        .borderRadius(4)
        .margin({ right: 12 })

      // 国家信息
      Column() {
        Text(getLocalizedCountryName(country, this.systemLanguage))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        if (hasAnthemFile(country.code)) {
          Text(this.getAnthemName(country.code))
            .fontSize(13)
            .fontColor($r('app.color.text_tertiary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ top: 4 })
        } else {
          Text(this.appContext.resourceManager.getStringSync($r('app.string.no_sound_file').id))
            .fontSize(13)
            .fontColor($r('app.color.text_tertiary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ top: 4 })
            .opacity(0.7)
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 播放按钮（只在有国歌时显示）
      if (hasAnthemFile(country.code)) {
        SymbolGlyph($r('sys.symbol.play'))
          .fontSize(22)
          .fontColor([$r('app.color.text_tertiary')])
          .margin({ left: 8 })
      }
    }
    .width('100%')
    .height(72)
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .onClick(() => {
      if (hasAnthemFile(country.code)) {
        this.playAnthem(country);
      }
    })
  }
}


