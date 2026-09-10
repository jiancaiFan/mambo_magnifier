import { MagnifierUIModel } from '../../model/magnifier/MagnifierUIModel';

export class MagnifierState {
  uiModel: MagnifierUIModel;

  constructor(uiModel: MagnifierUIModel = MagnifierUIModel.Empty) {
    this.uiModel = uiModel;
  }
}
