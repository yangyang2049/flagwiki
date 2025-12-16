import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { Constants, RouterMap } from '../common/Constants';
import { MediaUtils } from '../common/MediaUtils';
import { FeedbackModel } from '../common/FeedbackModel';
import { FeedbackService } from '../services/FuncService';
import { SubmitFeedbackParams } from '../services/RequestModel';

@ObservedV2
export class SubmitVM {
  @Trace feedbackModel: FeedbackModel = AppStorageV2.connect(FeedbackModel, () => new FeedbackModel())!;
  @Trace body: string = '';
  @Trace imgArr: string[] = [];
  @Trace contactPhone: string = '';
  @Trace maxSelectNumber: number = Constants.MAX_IMG_COUNT;
  @Trace stack: NavPathStack = new NavPathStack();
  @Trace loading: boolean = false;

  async selectPhoto() {
    const uriList = await MediaUtils.selectMedia(this.maxSelectNumber);
    this.imgArr.push(...uriList);
  }

  submit() {
    const isValid = this.validInfo();
    if (!isValid) {
      return;
    }
    this.loading = true;
    const cacheImgList = this.imgArr.map((v: string) => {
      return MediaUtils.handleUri(v);
    })
    const params: SubmitFeedbackParams = {
      problemDesc: this.body,
      screenShots: cacheImgList,
      contactPhone: this.contactPhone,
    };
    FeedbackService.addFeedback(params).then(() => {
      promptAction.showToast({ message: '提交成功' });
      setTimeout(() => {
        this.stack.pop();
        this.stack.pushPathByName(RouterMap.FEEDBACK_RECORD_LIST_PAGE, null);
      }, 300);
    }).finally(() => {
      this.loading = false;
    });
  }

  validInfo() {
    if (!this.body) {
      promptAction.showToast({ message: '请描述您的问题' });
      return false;
    }
    if (this.contactPhone && !Constants.PHONE_REG.test(this.contactPhone)) {
      promptAction.showToast({ message: '请输入正确的手机号码' });
      return false;
    }
    return true;
  }
}