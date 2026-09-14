import { Action, Reducer } from 'redux_ark'
import { MagnifierZoomChangeAction, MagnifierZoomReadyAction, MagnifierZoomStepAction } from './MagnifierAction'
import { MagnifierMapper } from './MagnifierMapper'
import { createMagnifierState, MagnifierState } from './MagnifierState'

export class MagnifierReducer implements Reducer<MagnifierState> {
  reduce(state: MagnifierState | undefined, action: Action): MagnifierState {
    const currentState = state === undefined ? createMagnifierState() : state

    switch (action.type) {
      case 'MagnifierZoomReady':
        return new MagnifierState((action as MagnifierZoomReadyAction).uiModel)
      case 'MagnifierZoomChange':
        return new MagnifierState(MagnifierMapper.withZoomRatio(
          currentState.uiModel, (action as MagnifierZoomChangeAction).zoomRatio
        ))
      case 'MagnifierZoomStep':
        return new MagnifierState(MagnifierMapper.zoomBy(
          currentState.uiModel, (action as MagnifierZoomStepAction).step
        ))
      default:
        return currentState
    }
  }
}
