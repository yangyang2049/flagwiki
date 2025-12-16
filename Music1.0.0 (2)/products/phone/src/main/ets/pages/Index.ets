import { RouterUtils } from 'lib_common';
import { IndexVM } from '../viewmodels/IndexVM';

@Entry
@ComponentV2
struct Index {
  vm: IndexVM = new IndexVM();

  aboutToAppear(): void {
    this.vm.refreshTheme()
    this.vm.initSongData()
    this.vm.initMyPlayList()
    this.vm.setInterception();
    this.vm.navDestinationListener()
    this.vm.windowStageEventListener()
    this.vm.registerBreakpointListener(this.getUIContext());
    this.vm.redirect();
  }

  aboutToDisappear(): void {
    this.vm.unregisterBreakpointListener();
  }

  build() {
    Navigation(RouterUtils.getStack()) {
    }
    .hideNavBar(true)
    .hideTitleBar(true)
  }
}