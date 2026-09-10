export enum MagnifierMode {
  Live = 'live',
  Frozen = 'frozen',
  Reader = 'reader'
}

export enum MagnifierFilter {
  Original = 'original',
  HighContrast = 'highContrast',
  Invert = 'invert',
  Clarity = 'clarity'
}

@ObservedV2
export class MagnifierUIModel {
  @Trace mode: MagnifierMode;
  @Trace zoomRatio: number;
  @Trace filter: MagnifierFilter;
  @Trace isTorchOn: boolean;
  @Trace isFrozen: boolean;
  @Trace isRecognizing: boolean;
  @Trace recognizedText: string;
  @Trace isSpeaking: boolean;
  @Trace speechRate: number;
  @Trace errorMessage: string;

  public static Empty: MagnifierUIModel = new MagnifierUIModel();

  constructor(
    mode: MagnifierMode = MagnifierMode.Live,
    zoomRatio: number = 3.4,
    filter: MagnifierFilter = MagnifierFilter.Original,
    isTorchOn: boolean = false,
    isFrozen: boolean = false,
    isRecognizing: boolean = false,
    recognizedText: string = '',
    isSpeaking: boolean = false,
    speechRate: number = 1,
    errorMessage: string = ''
  ) {
    this.mode = mode;
    this.zoomRatio = zoomRatio;
    this.filter = filter;
    this.isTorchOn = isTorchOn;
    this.isFrozen = isFrozen;
    this.isRecognizing = isRecognizing;
    this.recognizedText = recognizedText;
    this.isSpeaking = isSpeaking;
    this.speechRate = speechRate;
    this.errorMessage = errorMessage;
  }
}
