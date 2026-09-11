import { common } from '@kit.AbilityKit'
import { MagnifierCameraService } from '../camera/MagnifierCameraService'
import { MagnifierPermissionService } from '../permission/MagnifierPermissionService'

export class MagnifierRuntimeService {
  private cameraService: MagnifierCameraService = new MagnifierCameraService()
  private permissionService: MagnifierPermissionService = new MagnifierPermissionService()
  private abilityContext?: common.UIAbilityContext
  private surfaceId: string = ''

  bindPreviewSurface(context: common.UIAbilityContext, surfaceId: string): void {
    this.abilityContext = context
    this.surfaceId = surfaceId
  }

  clearPreviewSurface(): void {
    this.surfaceId = ''
  }

  async startPreview(): Promise<void> {
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
    await this.cameraService.stopPreview()
  }
}
