import { Action } from 'redux_ark';
import { MagnifierFilter } from '../../model/magnifier/MagnifierUIModel';

export default class MagnifierAction {
  public static ZoomChange(zoomRatio: number): MagnifierZoomChangeAction {
    return new MagnifierZoomChangeAction(zoomRatio);
  }

  public static FilterChange(filter: MagnifierFilter): MagnifierFilterChangeAction {
    return new MagnifierFilterChangeAction(filter);
  }

  public static TorchToggle(): MagnifierTorchToggleAction {
    return new MagnifierTorchToggleAction();
  }

  public static FreezeCapture(): MagnifierFreezeCaptureAction {
    return new MagnifierFreezeCaptureAction();
  }

  public static ResumeLive(): MagnifierResumeLiveAction {
    return new MagnifierResumeLiveAction();
  }

  public static RecognitionRequest(): MagnifierRecognitionRequestAction {
    return new MagnifierRecognitionRequestAction();
  }

  public static RecognitionStart(): MagnifierRecognitionStartAction {
    return new MagnifierRecognitionStartAction();
  }

  public static RecognitionSuccess(text: string): MagnifierRecognitionSuccessAction {
    return new MagnifierRecognitionSuccessAction(text);
  }

  public static RecognitionFailure(message: string): MagnifierRecognitionFailureAction {
    return new MagnifierRecognitionFailureAction(message);
  }

  public static SpeechToggleRequest(): MagnifierSpeechToggleRequestAction {
    return new MagnifierSpeechToggleRequestAction();
  }

  public static SpeechToggle(): MagnifierSpeechToggleAction {
    return new MagnifierSpeechToggleAction();
  }

  public static SpeechRateChange(speechRate: number): MagnifierSpeechRateChangeAction {
    return new MagnifierSpeechRateChangeAction(speechRate);
  }
}

export class MagnifierZoomChangeAction implements Action<'MagnifierZoomChange'> {
  type: 'MagnifierZoomChange' = 'MagnifierZoomChange';
  zoomRatio: number;

  constructor(zoomRatio: number) {
    this.zoomRatio = zoomRatio;
  }
}

export class MagnifierFilterChangeAction implements Action<'MagnifierFilterChange'> {
  type: 'MagnifierFilterChange' = 'MagnifierFilterChange';
  filter: MagnifierFilter;

  constructor(filter: MagnifierFilter) {
    this.filter = filter;
  }
}

export class MagnifierTorchToggleAction implements Action<'MagnifierTorchToggle'> {
  type: 'MagnifierTorchToggle' = 'MagnifierTorchToggle';
}

export class MagnifierFreezeCaptureAction implements Action<'MagnifierFreezeCapture'> {
  type: 'MagnifierFreezeCapture' = 'MagnifierFreezeCapture';
}

export class MagnifierResumeLiveAction implements Action<'MagnifierResumeLive'> {
  type: 'MagnifierResumeLive' = 'MagnifierResumeLive';
}

export class MagnifierRecognitionRequestAction implements Action<'MagnifierRecognitionRequest'> {
  type: 'MagnifierRecognitionRequest' = 'MagnifierRecognitionRequest';
}

export class MagnifierRecognitionStartAction implements Action<'MagnifierRecognitionStart'> {
  type: 'MagnifierRecognitionStart' = 'MagnifierRecognitionStart';
}

export class MagnifierRecognitionSuccessAction implements Action<'MagnifierRecognitionSuccess'> {
  type: 'MagnifierRecognitionSuccess' = 'MagnifierRecognitionSuccess';
  text: string;

  constructor(text: string) {
    this.text = text;
  }
}

export class MagnifierRecognitionFailureAction implements Action<'MagnifierRecognitionFailure'> {
  type: 'MagnifierRecognitionFailure' = 'MagnifierRecognitionFailure';
  message: string;

  constructor(message: string) {
    this.message = message;
  }
}

export class MagnifierSpeechToggleRequestAction implements Action<'MagnifierSpeechToggleRequest'> {
  type: 'MagnifierSpeechToggleRequest' = 'MagnifierSpeechToggleRequest';
}

export class MagnifierSpeechToggleAction implements Action<'MagnifierSpeechToggle'> {
  type: 'MagnifierSpeechToggle' = 'MagnifierSpeechToggle';
}

export class MagnifierSpeechRateChangeAction implements Action<'MagnifierSpeechRateChange'> {
  type: 'MagnifierSpeechRateChange' = 'MagnifierSpeechRateChange';
  speechRate: number;

  constructor(speechRate: number) {
    this.speechRate = speechRate;
  }
}
