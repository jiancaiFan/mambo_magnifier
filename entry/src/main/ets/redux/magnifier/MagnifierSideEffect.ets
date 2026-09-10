import {
  Action,
  Dispatch,
  Middleware,
  MiddlewareAPI
} from 'redux_ark';
import MagnifierAction from './MagnifierAction';
import { MagnifierState } from './MagnifierState';

export class MagnifierSideEffect implements Middleware<MagnifierState> {
  dispatch(store: MiddlewareAPI<MagnifierState>, next: Dispatch<Action>, action: Action): Action {
    const result = next.dispatch(action);

    switch (action.type) {
      case 'MagnifierRecognitionRequest':
        store.dispatch(MagnifierAction.RecognitionStart());
        setTimeout(() => {
          store.dispatch(MagnifierAction.RecognitionSuccess('每 100g 含量\n能量 1720 kJ\n蛋白质 8.5g\n钠 380 mg'));
        }, 300);
        break;
      case 'MagnifierSpeechToggleRequest':
        store.dispatch(MagnifierAction.SpeechToggle());
        break;
      default:
        break;
    }

    return result;
  }
}
