import {
  Action,
  Store,
  applyMiddleware,
  createConcurrentStore
} from 'redux_ark';
import { MagnifierReducer } from './MagnifierReducer';
import { MagnifierSideEffect } from './MagnifierSideEffect';
import { MagnifierState } from './MagnifierState';

export class MagnifierStoreProvider {
  static create(): Store<MagnifierState, Action> {
    return createConcurrentStore<MagnifierState, Action>(
      new MagnifierReducer(),
      new MagnifierState(),
      applyMiddleware<MagnifierState, Action>(new MagnifierSideEffect())
    );
  }
}
