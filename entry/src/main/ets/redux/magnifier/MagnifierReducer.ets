import { Reducer, Action } from 'redux_ark';
import {
  MagnifierUIModel,
  MagnifierFilter,
  MagnifierMode
} from '../../model/magnifier/MagnifierUIModel';
import {
  MagnifierFilterChangeAction,
  MagnifierRecognitionFailureAction,
  MagnifierRecognitionSuccessAction,
  MagnifierSpeechRateChangeAction,
  MagnifierZoomChangeAction
} from './MagnifierAction';
import { MagnifierState } from './MagnifierState';

function copyModel(model: MagnifierUIModel): MagnifierUIModel {
  return new MagnifierUIModel(
    model.mode,
    model.zoomRatio,
    model.filter,
    model.isTorchOn,
    model.isFrozen,
    model.isRecognizing,
    model.recognizedText,
    model.isSpeaking,
    model.speechRate,
    model.errorMessage
  );
}

function createState(model: MagnifierUIModel): MagnifierState {
  return new MagnifierState(model);
}

export class MagnifierReducer implements Reducer<MagnifierState> {
  reduce(state: MagnifierState | undefined, action: Action): MagnifierState {
    const currentState = state === undefined ? new MagnifierState() : state;
    const currentModel = currentState.uiModel;
    const nextModel = copyModel(currentModel);

    switch (action.type) {
      case 'MagnifierZoomChange':
        nextModel.zoomRatio = (action as MagnifierZoomChangeAction).zoomRatio;
        return createState(nextModel);
      case 'MagnifierFilterChange':
        nextModel.filter = (action as MagnifierFilterChangeAction).filter as MagnifierFilter;
        return createState(nextModel);
      case 'MagnifierTorchToggle':
        nextModel.isTorchOn = !currentModel.isTorchOn;
        return createState(nextModel);
      case 'MagnifierFreezeCapture':
        nextModel.mode = MagnifierMode.Frozen;
        nextModel.isFrozen = true;
        nextModel.isRecognizing = false;
        nextModel.errorMessage = '';
        return createState(nextModel);
      case 'MagnifierResumeLive':
        nextModel.mode = MagnifierMode.Live;
        nextModel.isFrozen = false;
        nextModel.isRecognizing = false;
        nextModel.isSpeaking = false;
        nextModel.errorMessage = '';
        return createState(nextModel);
      case 'MagnifierRecognitionStart':
        nextModel.isRecognizing = true;
        nextModel.errorMessage = '';
        return createState(nextModel);
      case 'MagnifierRecognitionSuccess':
        nextModel.mode = MagnifierMode.Reader;
        nextModel.isRecognizing = false;
        nextModel.recognizedText = (action as MagnifierRecognitionSuccessAction).text;
        return createState(nextModel);
      case 'MagnifierRecognitionFailure':
        nextModel.isRecognizing = false;
        nextModel.errorMessage = (action as MagnifierRecognitionFailureAction).message;
        return createState(nextModel);
      case 'MagnifierSpeechToggle':
        nextModel.isSpeaking = !currentModel.isSpeaking;
        return createState(nextModel);
      case 'MagnifierSpeechRateChange':
        nextModel.speechRate = (action as MagnifierSpeechRateChangeAction).speechRate;
        return createState(nextModel);
      default:
        return currentState;
    }
  }
}
