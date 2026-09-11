import { common } from '@kit.AbilityKit'
import { camera } from '@kit.CameraKit'

const PREVIEW_FRAME_RATE: number = 60
const PREVIEW_WIDTH: number = 1920
const PREVIEW_HEIGHT: number = 1080

export class MagnifierCameraService {
  private cameraInput?: camera.CameraInput
  private previewOutput?: camera.PreviewOutput
  private videoSession?: camera.VideoSession
  private isPreviewStarted: boolean = false

  async startPreview(context: common.UIAbilityContext, surfaceId: string): Promise<void> {
    if (surfaceId.length === 0) {
      throw new Error('相机预览 Surface 未就绪')
    }

    try {
      await this.stopPreview()

      const cameraManager: camera.CameraManager = camera.getCameraManager(context)
      const cameraDevice: camera.CameraDevice = this.selectBackCamera(cameraManager.getSupportedCameras())
      const outputCapability: camera.CameraOutputCapability =
        cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO)
      const previewProfile = outputCapability.previewProfiles.find((profile: camera.Profile): boolean => {
        return profile.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP &&
          profile.size.width === PREVIEW_WIDTH &&
          profile.size.height === PREVIEW_HEIGHT
      })
      if (previewProfile === undefined) {
        throw new Error('当前后置相机不支持 1920x1080 YUV 预览规格')
      }

      this.cameraInput = cameraManager.createCameraInput(cameraDevice)
      await this.cameraInput.open()

      this.previewOutput = cameraManager.createPreviewOutput(previewProfile, surfaceId)
      this.videoSession = cameraManager.createSession<camera.VideoSession>(camera.SceneMode.NORMAL_VIDEO)
      this.videoSession.beginConfig()
      this.videoSession.addInput(this.cameraInput)
      if (!this.videoSession.canAddOutput(this.previewOutput)) {
        throw new Error('当前录像会话无法添加 1080p 预览输出')
      }
      this.videoSession.addOutput(this.previewOutput)
      await this.videoSession.commitConfig()

      this.configurePreviewFrameRate()
      this.configureContinuousFocus()
      await this.videoSession.start()
      this.isPreviewStarted = true
    } catch (error) {
      await this.stopPreview()
      throw new Error(this.toErrorMessage(error))
    }
  }

  async stopPreview(): Promise<void> {
    if (this.videoSession !== undefined) {
      try {
        if (this.isPreviewStarted) {
          await this.videoSession.stop()
        }
      } catch (error) {
        console.warn(`MagnifierCameraService stop session failed: ${JSON.stringify(error)}`)
      }
    }

    if (this.previewOutput !== undefined) {
      try {
        await this.previewOutput.release()
      } catch (error) {
        console.warn(`MagnifierCameraService release preview failed: ${JSON.stringify(error)}`)
      }
    }

    if (this.cameraInput !== undefined) {
      try {
        await this.cameraInput.close()
      } catch (error) {
        console.warn(`MagnifierCameraService close input failed: ${JSON.stringify(error)}`)
      }
    }

    if (this.videoSession !== undefined) {
      try {
        await this.videoSession.release()
      } catch (error) {
        console.warn(`MagnifierCameraService release session failed: ${JSON.stringify(error)}`)
      }
    }

    this.videoSession = undefined
    this.previewOutput = undefined
    this.cameraInput = undefined
    this.isPreviewStarted = false
  }

  private selectBackCamera(cameraDevices: Array<camera.CameraDevice>): camera.CameraDevice {
    if (cameraDevices.length === 0) {
      throw new Error('当前设备未发现可用相机')
    }

    const backCamera = cameraDevices.find((device: camera.CameraDevice) => {
      return device.cameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK
    })

    return backCamera === undefined ? cameraDevices[0] : backCamera
  }

  private configurePreviewFrameRate(): void {
    if (this.previewOutput === undefined) {
      throw new Error('相机预览输出未就绪')
    }

    try {
      const supportedFrameRates = this.previewOutput.getSupportedFrameRates()
      const supportsSixtyFps = supportedFrameRates.some((frameRateRange: camera.FrameRateRange): boolean => {
        return frameRateRange.min <= PREVIEW_FRAME_RATE && frameRateRange.max >= PREVIEW_FRAME_RATE
      })

      if (!supportsSixtyFps) {
        throw new Error('当前 1080p 预览规格不支持 60fps')
      }

      this.previewOutput.setFrameRate(PREVIEW_FRAME_RATE, PREVIEW_FRAME_RATE)
      const activeFrameRate = this.previewOutput.getActiveFrameRate()
      if (activeFrameRate.min !== PREVIEW_FRAME_RATE || activeFrameRate.max !== PREVIEW_FRAME_RATE) {
        throw new Error('1080p 预览未能启用固定 60fps')
      }
    } catch (error) {
      throw new Error(this.toErrorMessage(error as Object))
    }
  }

  private configureContinuousFocus(): void {
    if (this.videoSession === undefined) {
      return
    }

    try {
      if (this.videoSession.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO)) {
        this.videoSession.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO)
      }
    } catch (error) {
      console.warn(`MagnifierCameraService configure focus failed: ${JSON.stringify(error)}`)
    }
  }

  private toErrorMessage(error: Object): string {
    if (error instanceof Error) {
      return error.message
    }
    return JSON.stringify(error)
  }
}
