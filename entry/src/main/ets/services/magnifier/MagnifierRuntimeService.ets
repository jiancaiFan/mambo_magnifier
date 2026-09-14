import { common } from '@kit.AbilityKit'
import { MagnifierCameraService } from '../camera/MagnifierCameraService'
import { MagnifierPermissionService } from '../permission/MagnifierPermissionService'

export class MagnifierRuntimeService {
  private cameraService: MagnifierCameraService = new MagnifierCameraService()
  private permissionService: MagnifierPermissionService = new MagnifierPermissionService()
  private abilityContext?: common.UIAbilityContext
  private surfaceId: string = ''

  async startPreview(context: common.UIAbilityContext, surfaceId: string): Promise<void> {
    this.abilityContext = context
    this.surfaceId = surfaceId
    if (this.abilityContext === undefined || this.surfaceId.length === 0) {
      throw new Error('相机预览 Surface 未就绪')
    }

    const isPermissionGranted = await this.permissionService.requestCameraPermission(this.abilityContext)
    if (!isPermissionGranted) {
      throw new Error('需要相机权限才能使用放大镜')
    }

    await this.cameraService.startPreview(this.abilityContext, this.surfaceId)
  }

  async stopPreview(): Promise<void> {
    this.surfaceId = ''
    await this.cameraService.stopPreview()
  }

  getZoomRatioRange(): Array<number> {
    return this.cameraService.getZoomRatioRange()
  }

  getZoomRatio(): number {
    return this.cameraService.getZoomRatio()
  }

  setZoomRatio(zoomRatio: number): boolean {
    return this.cameraService.setZoomRatio(zoomRatio)
  }

  setSmoothZoomRatio(zoomRatio: number): boolean {
    return this.cameraService.setSmoothZoomRatio(zoomRatio)
  }
}
