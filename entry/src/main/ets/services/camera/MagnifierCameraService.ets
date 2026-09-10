export class MagnifierCameraService {
  public async startPreview(): Promise<void> {
  }

  public async stopPreview(): Promise<void> {
  }

  public async setZoomRatio(ratio: number): Promise<void> {
    console.info(`MagnifierCameraService setZoomRatio ${ratio}`);
  }

  public async toggleTorch(isOn: boolean): Promise<void> {
    console.info(`MagnifierCameraService toggleTorch ${isOn}`);
  }

  public async captureFreezeFrame(): Promise<void> {
  }
}
