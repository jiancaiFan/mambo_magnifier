import { Action, Store, applyMiddleware, createConcurrentStore } from 'redux_ark'
import { MagnifierRuntimeService } from '../../services/magnifier/MagnifierRuntimeService'
import { MagnifierReducer } from './MagnifierReducer'
import { MagnifierSideEffect } from './MagnifierSideEffect'
import { createMagnifierState, MagnifierState } from './MagnifierState'

export class MagnifierStoreProvider {
  static create(): Store<MagnifierState, Action> {
    const runtimeService = new MagnifierRuntimeService()
    return createConcurrentStore<MagnifierState, Action>(
      new MagnifierReducer(),
      createMagnifierState(),
      applyMiddleware<MagnifierState, Action>(new MagnifierSideEffect(runtimeService))
    )
  }
}
