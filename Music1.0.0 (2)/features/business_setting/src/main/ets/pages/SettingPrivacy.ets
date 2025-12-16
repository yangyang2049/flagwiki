import { CommonConstants } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { SettingCard } from '../components/SettingCard';
import { SettingPrivacyVM } from '../viewmodels/SettingPrivacyVM';

@Builder
export function SettingPrivacyBuilder() {
  SettingPrivacy()
}

@ComponentV2
struct SettingPrivacy {
  @Local vm: SettingPrivacyVM = new SettingPrivacyVM();

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '隐私管理 ',
        })
        Scroll() {
          Column({ space: CommonConstants.SPACE_M }) {
            SettingCard({ list: this.vm.list1 })
            SettingCard({ list: this.vm.list4 })
            SettingCard({ list: this.vm.list2 })
            SettingCard({ list: this.vm.list3 })
          }
          .padding({
            left: CommonConstants.PADDING_PAGE,
            right: CommonConstants.PADDING_PAGE,
            top: CommonConstants.PADDING_M,
          })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}