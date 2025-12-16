import { AppStorageV2 } from '@kit.ArkUI';
import { FeedbackModel } from '../common/FeedbackModel';
import { FeedbackService } from '../services/FuncService';
import { FeedbackResponseParams } from '../services/ResponseModel';

@ObservedV2
export class RecordListVM {
  @Trace feedbackModel: FeedbackModel = AppStorageV2.connect(FeedbackModel, () => new FeedbackModel())!;
  @Trace list: FeedbackResponseParams[] = [];
  @Trace loading: boolean = false;

  constructor() {
    this.queryListInfo();
  }

  queryListInfo() {
    this.loading = true;
    FeedbackService.queryFeedbackList().then((resp) => {
      this.list = resp;
    }).finally(() => {
      this.loading = false;
    });
  }
}
