import router from '@ohos.router';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { CITY_DATA, CityData } from '../../utils/cityData';
import { AmountInput } from '../../components/AmountInput';
import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
export struct CityEditPage {
    @State currentCity: string = '北京';
    @State currentMaxBase: string = '';
    @State searchText: string = '';
    @State filteredCities: CityData[] = [];
    @State isCustom: boolean = false;
    @State showCityDialog: boolean = false;
    private allCities: CityData[] = [];
    private prefs: preferences.Preferences | null = null;
    private context = getContext(this) as common.UIAbilityContext;

    async aboutToAppear() {
        this.allCities = CITY_DATA;
        this.filteredCities = this.allCities;
        await this.loadCurrentCity();
    }

    private async loadCurrentCity(): Promise<void> {
        try {
            this.prefs = await preferences.getPreferences(this.context, 'app_settings');
            const savedCity: string = await this.prefs.get('selectedCity', '北京') as string;
            const savedMaxBase: string = await this.prefs.get('currentCityMaxBase', '') as string;
            
            this.currentCity = savedCity;
            
            // 如果有保存的基数，使用保存的
            if (savedMaxBase) {
                this.currentMaxBase = savedMaxBase;
                this.isCustom = true;
            } else {
                // 否则查找城市的默认基数
                const cityData = this.allCities.find(c => c.city === savedCity);
                if (cityData) {
                    this.currentMaxBase = cityData.maxBase.toString();
                    this.isCustom = false;
                }
            }
        } catch (err) {
            console.error(`Failed to load city: ${JSON.stringify(err)}`);
        }
    }

    private onSearchChange(value: string): void {
        this.searchText = value;
        if (!value || value.trim() === '') {
            this.filteredCities = this.allCities;
            return;
        }
        
        const searchLower = value.toLowerCase().trim();
        this.filteredCities = this.allCities.filter((cityData: CityData) => {
            return cityData.city.includes(value) || cityData.city.toLowerCase().includes(searchLower);
        });
    }

    private selectCity(cityData: CityData): void {
        this.currentCity = cityData.city;
        // 如果是从列表选择的城市，先填入默认基数，但允许编辑
        this.currentMaxBase = cityData.maxBase.toString();
        this.searchText = '';
        this.filteredCities = this.allCities;
        this.isCustom = false; // 标记为非自定义，但用户可以修改
    }

    private async saveCity(): Promise<void> {
        if (!this.currentCity || this.currentCity.trim() === '') {
            promptAction.showToast({
                message: '请输入城市名称',
                duration: 2000
            });
            return;
        }

        if (!this.currentMaxBase || this.currentMaxBase.trim() === '') {
            promptAction.showToast({
                message: '请输入缴费基数上限',
                duration: 2000
            });
            return;
        }

        const maxBase = parseFloat(this.currentMaxBase);
        if (isNaN(maxBase) || maxBase <= 0) {
            promptAction.showToast({
                message: '请输入有效的缴费基数',
                duration: 2000
            });
            return;
        }

        try {
            if (!this.prefs) {
                this.prefs = await preferences.getPreferences(this.context, 'app_settings');
            }

            await this.prefs.put('selectedCity', this.currentCity);
            await this.prefs.put('currentCityMaxBase', this.currentMaxBase);
            await this.prefs.flush();

            promptAction.showToast({
                message: '保存成功',
                duration: 1500
            });

            // 延迟返回，让用户看到成功提示
            setTimeout(() => {
                router.back();
            }, 500);
        } catch (err) {
            console.error(`Failed to save city: ${JSON.stringify(err)}`);
            promptAction.showToast({
                message: '保存失败',
                duration: 2000
            });
        }
    }

    build() {
        Stack() {
            Navigation() {
                Scroll() {
                    Column() {
                        // 城市
                        Column() {
                            Text('城市')
                                .fontSize(14)
                                .fontColor($r('app.color.text_secondary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 8 })
                            
                            Row() {
                                TextInput({ text: this.currentCity, placeholder: '请输入城市名称' })
                                    .layoutWeight(1)
                                    .height(48)
                                    .backgroundColor($r('app.color.bg_secondary'))
                                    .borderRadius(8)
                                    .onChange((value: string) => {
                                        this.currentCity = value;
                                    })
                                
                                Image($r('app.media.icon_arrow_right'))
                                    .width(20)
                                    .height(20)
                                    .margin({ left: 12 })
                                    .onClick(() => {
                                        this.showCityDialog = true;
                                    })
                            }
                            .width('100%')
                            .alignItems(VerticalAlign.Center)
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                        // 缴费基数上限
                        Column() {
                            AmountInput({
                                label: '缴费基数上限（元/月）',
                                placeholder: '请输入缴费基数上限',
                                value: this.currentMaxBase,
                                onChange: (value: string) => {
                                    this.currentMaxBase = value;
                                    this.isCustom = true;
                                }
                            })
                            
                            Text('* 可修改预设城市的缴费基数')
                                .fontSize(12)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ top: 8 })
                                .alignSelf(ItemAlign.Start)
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16 })

                        // 保存按钮
                        Button('保存')
                            .type(ButtonType.Normal)
                            .backgroundColor($r('app.color.button_primary'))
                            .fontColor($r('app.color.text_white'))
                            .fontSize(16)
                            .width('80%')
                            .constraintSize({ maxWidth: 320 })
                            .height(48)
                            .borderRadius(8)
                            .margin({ top: 24, bottom: 24 })
                            .onClick(() => {
                                this.saveCity();
                                inputMethod.getController().stopInputSession();
                            })

                        // 使用说明
                        Column() {
                            Text('使用说明')
                                .fontSize(15)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .alignSelf(ItemAlign.Start)
                                .margin({ bottom: 12 })
                            Text('• 可以直接输入城市名称，或从预设列表中选择')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ bottom: 4 })
                                .alignSelf(ItemAlign.Start)
                            Text('• 缴费基数上限用于五险一金计算时的验证')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .margin({ bottom: 4 })
                                .alignSelf(ItemAlign.Start)
                            Text('• 即使选择预设城市，也可以修改缴费基数')
                                .fontSize(13)
                                .fontColor($r('app.color.text_secondary'))
                                .alignSelf(ItemAlign.Start)
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16, bottom: 16 })
                        .alignItems(HorizontalAlign.Start)
                    }
                    .width('100%')
                    .alignItems(HorizontalAlign.Center)
                }
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.Spring)
                .backgroundColor($r('app.color.bg_page'))
            }
            .title('当前城市')
            .titleMode(NavigationTitleMode.Mini)
            .hideBackButton(false)
            .backgroundColor($r('app.color.bg_page'))

            // 城市选择对话框
            if (this.showCityDialog) {
                this.CitySelectionDialog()
            }
        }
        .width('100%')
        .height('100%')
    }

    @Builder
    CitySelectionDialog() {
        Stack({ alignContent: Alignment.Center }) {
            // 遮罩层
            Column()
                .width('100%')
                .height('100%')
                .backgroundColor('rgba(0, 0, 0, 0.5)')
                .onClick(() => {
                    this.showCityDialog = false;
                    this.searchText = '';
                    this.filteredCities = this.allCities;
                })

            // 对话框
            Column() {
                Text('选择城市')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ bottom: 16 })

                // 搜索框
                Row() {
                    TextInput({ placeholder: '搜索城市...', text: this.searchText })
                        .layoutWeight(1)
                        .height(40)
                        .backgroundColor($r('app.color.bg_secondary'))
                        .borderRadius(20)
                        .padding({ left: 16, right: 16 })
                        .fontColor($r('app.color.text_primary'))
                        .onChange((value: string) => {
                            this.onSearchChange(value);
                        })
                    if (this.searchText) {
                        Button('清除')
                            .type(ButtonType.Normal)
                            .fontSize(12)
                            .fontColor($r('app.color.text_secondary'))
                            .backgroundColor(Color.Transparent)
                            .height(32)
                            .margin({ left: 8 })
                            .onClick(() => {
                                this.searchText = '';
                                this.onSearchChange('');
                            })
                    }
                }
                    .width('100%')
                    .margin({ bottom: 16 })

                // 城市列表
                if (this.filteredCities.length === 0 && this.searchText) {
                    Column() {
                        Text('🔍')
                            .fontSize(48)
                            .margin({ bottom: 16 })
                        Text('未找到相关城市')
                            .fontSize(16)
                            .fontColor($r('app.color.text_secondary'))
                            .margin({ bottom: 8 })
                        Text('请尝试其他关键词')
                            .fontSize(14)
                            .fontColor($r('app.color.text_tertiary'))
                    }
                        .width('100%')
                        .height(200)
                        .justifyContent(FlexAlign.Center)
                        .alignItems(HorizontalAlign.Center)
                } else {
                    Scroll() {
                        Column() {
                            ForEach(this.filteredCities, (cityData: CityData) => {
                                this.CityOption(cityData)
                            }, (cityData: CityData) => cityData.city)
                        }
                            .width('100%')
                    }
                        .width('100%')
                        .constraintSize({ maxHeight: 400 })
                        .layoutWeight(1)
                }
            }
            .width('90%')
                .constraintSize({ maxWidth: 400, maxHeight: 600 })
                .padding({ left: 24, right: 24, top: 24, bottom: 24 })
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius(16)
                .shadow({
                    radius: 20,
                    color: $r('app.color.shadow'),
                    offsetX: 0,
                    offsetY: 4
                })
        }
        .width('100%')
            .height('100%')
    }

    @Builder
    CityOption(cityData: CityData) {
        Row() {
            Column() {
                Text(cityData.city)
                    .fontSize(16)
                    .fontColor($r('app.color.text_primary'))
                    .alignSelf(ItemAlign.Start)
                Text(`缴费基数上限：${cityData.maxBase}元/月`)
                    .fontSize(12)
                    .fontColor($r('app.color.text_tertiary'))
                    .margin({ top: 4 })
                    .alignSelf(ItemAlign.Start)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            if (this.currentCity === cityData.city) {
                Text('✓')
                    .fontSize(18)
                    .fontColor($r('app.color.button_primary'))
                    .fontWeight(FontWeight.Bold)
            }
        }
        .width('100%')
            .padding({ top: 16, bottom: 16, left: 16, right: 16 })
            .borderRadius(8)
            .backgroundColor(this.currentCity === cityData.city ? $r('app.color.bg_blue_light') : $r('app.color.bg_secondary'))
            .margin({ bottom: 12 })
            .onClick(() => {
                this.selectCity(cityData);
                this.showCityDialog = false;
                this.searchText = '';
                this.filteredCities = this.allCities;
            })
    }
}

