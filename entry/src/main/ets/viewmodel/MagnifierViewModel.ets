import {
  MagnifierFilter,
  MagnifierMode
} from '../model/magnifier/MagnifierUIModel';
import {
  Action,
  Store,
  StoreSubscriber,
  StoreSubscription
} from 'redux_ark';
import MagnifierAction from '../redux/magnifier/MagnifierAction';
import { MagnifierState } from '../redux/magnifier/MagnifierState';
import { MagnifierStoreProvider } from '../redux/magnifier/MagnifierStoreProvider';
import { MagnifierCameraService } from '../services/camera/MagnifierCameraService';
import { MagnifierSpeechService } from '../services/speech/MagnifierSpeechService';

@ObservedV2
export class MagnifierViewModel implements StoreSubscriber {
  private store: Store<MagnifierState, Action> = MagnifierStoreProvider.create();
  @Trace public state: MagnifierState = this.store.getState();
  private subscription?: StoreSubscription;
  private cameraService: MagnifierCameraService = new MagnifierCameraService();
  private speechService: MagnifierSpeechService = new MagnifierSpeechService();

  public start(): void {
    if (this.subscription === undefined) {
      this.subscription = this.store.subscribe(this);
    }
    this.startPreview();
  }

  public onStateChanged(): void {
    this.state = this.store.getState();
  }

  public onCleared(): void {
    if (this.subscription !== undefined) {
      this.subscription.unsubscribe();
      this.subscription = undefined;
    }
    this.stopPreview();
  }

  public get mode(): MagnifierMode {
    return this.state.uiModel.mode;
  }

  public get zoomRatio(): number {
    return this.state.uiModel.zoomRatio;
  }

  public get zoomText(): string {
    return `${this.zoomRatio.toFixed(1)}×`;
  }

  public get filter(): MagnifierFilter {
    return this.state.uiModel.filter;
  }

  public get isTorchOn(): boolean {
    return this.state.uiModel.isTorchOn;
  }

  public get isRecognizing(): boolean {
    return this.state.uiModel.isRecognizing;
  }

  public get recognizedText(): string {
    return this.state.uiModel.recognizedText;
  }

  public get isSpeaking(): boolean {
    return this.state.uiModel.isSpeaking;
  }

  public get speechRateText(): string {
    return `${this.state.uiModel.speechRate}×`;
  }

  public async startPreview(): Promise<void> {
    await this.cameraService.startPreview();
  }

  public async stopPreview(): Promise<void> {
    await this.cameraService.stopPreview();
  }

  public onZoomChange(value: number): void {
    const nextValue = Math.max(1, Math.min(8, value));
    this.store.dispatch(MagnifierAction.ZoomChange(nextValue));
    this.cameraService.setZoomRatio(nextValue);
  }

  public onFilterChange(filter: MagnifierFilter): void {
    this.store.dispatch(MagnifierAction.FilterChange(filter));
  }

  public onTorchToggle(): void {
    const nextTorchState = !this.isTorchOn;
    this.store.dispatch(MagnifierAction.TorchToggle());
    this.cameraService.toggleTorch(nextTorchState);
  }

  public async onFreezeCapture(): Promise<void> {
    await this.cameraService.captureFreezeFrame();
    this.store.dispatch(MagnifierAction.FreezeCapture());
  }

  public onResumeLive(): void {
    this.store.dispatch(MagnifierAction.ResumeLive());
  }

  public onRecognizeText(): void {
    this.store.dispatch(MagnifierAction.RecognitionRequest());
  }

  public async onSpeechToggle(): Promise<void> {
    if (this.isSpeaking) {
      await this.speechService.stop();
    } else {
      await this.speechService.speak(this.recognizedText, this.state.uiModel.speechRate);
    }
    this.store.dispatch(MagnifierAction.SpeechToggleRequest());
  }

  public onSpeechRateChange(): void {
    const currentRate = this.state.uiModel.speechRate;
    const nextRate = currentRate >= 1.5 ? 1 : currentRate + 0.25;
    this.store.dispatch(MagnifierAction.SpeechRateChange(nextRate));
  }
}
