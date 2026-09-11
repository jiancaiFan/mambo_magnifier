import { Action, Reducer } from 'redux_ark'
import { createMagnifierState, MagnifierState } from './MagnifierState'

export class MagnifierReducer implements Reducer<MagnifierState> {
  reduce(state: MagnifierState | undefined, action: Action): MagnifierState {
    if (state === undefined) {
      return createMagnifierState()
    }
    return state
  }
}
