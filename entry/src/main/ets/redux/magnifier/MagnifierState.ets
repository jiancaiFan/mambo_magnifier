import { MagnifierUIModel } from '../../model/magnifier/MagnifierUIModel'

export class MagnifierState {
  uiModel: MagnifierUIModel

  constructor(uiModel: MagnifierUIModel = new MagnifierUIModel()) {
    this.uiModel = uiModel
  }
}

export function createMagnifierState(): MagnifierState {
  return new MagnifierState()
}
