import router from '@ohos.router';
import { TopicItem, getTopicById } from './TopicData';
import { getCountryByCode, Country, getFlagImageSource, getInternationalOrgByCode, InternationalOrg, isInternationalOrg } from '../../utils/countryData';

interface RouterParams {
  topicId: string;
}

interface DisplayItem {
  code: string;
  nameCN: string;
  name: string;
}

@Entry
@Component
struct TopicDetailPage {
  @State topic: TopicItem | undefined = undefined;
  @State countries: Country[] = [];
  @State displayItems: DisplayItem[] = [];
  @State isLoading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as RouterParams;
    if (params && params.topicId) {
      this.topic = getTopicById(params.topicId);
      if (this.topic) {
        this.loadCountries();
      }
    }
  }

  private loadCountries(): void {
    if (!this.topic) return;
    
    // 显示loading
    this.isLoading = true;
    
    // 同步加载国家数据（移除不必要的延迟）
      const countryList: Country[] = [];
      const displayList: DisplayItem[] = [];
      
    for (const code of this.topic.countryCodes) {
        if (isInternationalOrg(code)) {
          const org = getInternationalOrgByCode(code);
          if (org) {
            displayList.push({
              code: org.code,
              nameCN: org.nameCN,
              name: org.name
            });
          }
        } else {
          const country = getCountryByCode(code);
          if (country) {
            countryList.push(country);
            displayList.push({
              code: country.code,
              nameCN: country.nameCN,
              name: country.name
            });
          }
        }
      }
      this.countries = countryList;
      this.displayItems = displayList;
      this.isLoading = false;
  }

  build() {
    Navigation() {
      if (this.topic) {
        Column() {
          // 专题介绍卡片 - 无圆角
          Column() {
            Text(this.topic.emoji)
              .fontSize(48)
              .margin({ bottom: 12 })

            Text(this.topic.name)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.topic.description)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 8 })
              .textAlign(TextAlign.Center)

            Text(`共 ${this.displayItems.length} 个${this.topic.id === 'international' ? '组织' : '国家'}`)
              .fontSize(13)
              .fontColor($r('app.color.text_tertiary'))
              .margin({ top: 8 })
          }
          .width('100%')
          .padding(24)
          .backgroundColor($r('app.color.bg_card'))

          // 国旗列表
          if (this.isLoading) {
            Column() {
              LoadingProgress()
                .width(40)
                .height(40)
                .color($r('app.color.button_primary'))
              Text('加载中...')
                .fontSize(14)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 12 })
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            Grid() {
              ForEach(this.displayItems, (item: DisplayItem, index: number) => {
                GridItem() {
                  this.FlagGridItem(item)
                }
              }, (item: DisplayItem, index: number) => `${item.code}_${index}`)
            }
            .columnsTemplate('1fr 1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .width('100%')
            .layoutWeight(1)
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .cachedCount(9)
          }
        }
        .width('100%')
        .height('100%')
      } else {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text('加载中...')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .title(this.topic?.name || '专题详情')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.bg_page'))
  }

  @Builder
  FlagGridItem(item: DisplayItem) {
    Column() {
      Image(getFlagImageSource(item.code))
        .width('100%')
        .height(60)
        .objectFit(ImageFit.Contain)
        .borderRadius(4)

      Text(item.nameCN)
        .fontSize(13)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding(12)
    .backgroundColor($r('app.color.bg_card'))
    .borderRadius(12)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/gallery/FlagDetailPage',
        params: { countryCode: item.code }
      }).catch((err: Error) => {
        console.error(`Navigation failed: ${err.message}`);
      });
    })
  }
}
