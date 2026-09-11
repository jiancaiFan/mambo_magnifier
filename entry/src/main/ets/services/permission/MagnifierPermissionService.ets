import {
  abilityAccessCtrl,
  common,
  Permissions
} from '@kit.AbilityKit';

export class MagnifierPermissionService {
  private readonly cameraPermission: Permissions = 'ohos.permission.CAMERA';

  public async requestCameraPermission(context: common.UIAbilityContext): Promise<boolean> {
    try {
      const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const grantResult = await atManager.requestPermissionsFromUser(context, [this.cameraPermission]);
      return grantResult.authResults.length > 0 &&
        grantResult.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (error) {
      console.error(`MagnifierPermissionService request camera permission failed: ${JSON.stringify(error)}`);
      return false;
    }
  }
}
