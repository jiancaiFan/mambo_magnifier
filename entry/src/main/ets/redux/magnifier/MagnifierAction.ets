import { common } from '@kit.AbilityKit'
import { Action } from 'redux_ark'
import { MagnifierUIModel } from '../../model/magnifier/MagnifierUIModel'

const ZOOM_BUTTON_STEP: number = 0.5

export class MagnifierPreviewOpenAction implements Action<'MagnifierPreviewOpen'> {
  type: 'MagnifierPreviewOpen' = 'MagnifierPreviewOpen'
  context: common.UIAbilityContext
  surfaceId: string

  constructor(context: common.UIAbilityContext, surfaceId: string) {
    this.context = context
    this.surfaceId = surfaceId
  }
}

export class MagnifierPreviewStopAction implements Action<'MagnifierPreviewStop'> {
  type: 'MagnifierPreviewStop' = 'MagnifierPreviewStop'
}

export class MagnifierZoomReadyAction implements Action<'MagnifierZoomReady'> {
  type: 'MagnifierZoomReady' = 'MagnifierZoomReady'
  uiModel: MagnifierUIModel

  constructor(uiModel: MagnifierUIModel) {
    this.uiModel = uiModel
  }
}

export class MagnifierZoomChangeAction implements Action<'MagnifierZoomChange'> {
  type: 'MagnifierZoomChange' = 'MagnifierZoomChange'
  zoomRatio: number
  smooth: boolean

  constructor(zoomRatio: number, smooth: boolean) {
    this.zoomRatio = zoomRatio
    this.smooth = smooth
  }
}

export class MagnifierZoomStepAction implements Action<'MagnifierZoomStep'> {
  type: 'MagnifierZoomStep' = 'MagnifierZoomStep'
  step: number

  constructor(step: number) {
    this.step = step
  }
}

export class MagnifierAction {
  static openPreview(context: common.UIAbilityContext, surfaceId: string): MagnifierPreviewOpenAction {
    return new MagnifierPreviewOpenAction(context, surfaceId)
  }

  static stopPreview(): MagnifierPreviewStopAction {
    return new MagnifierPreviewStopAction()
  }

  static zoomReady(uiModel: MagnifierUIModel): MagnifierZoomReadyAction {
    return new MagnifierZoomReadyAction(uiModel)
  }

  static changeZoom(zoomRatio: number, smooth: boolean): MagnifierZoomChangeAction {
    return new MagnifierZoomChangeAction(zoomRatio, smooth)
  }

  static zoomIn(): MagnifierZoomStepAction {
    return new MagnifierZoomStepAction(ZOOM_BUTTON_STEP)
  }

  static zoomOut(): MagnifierZoomStepAction {
    return new MagnifierZoomStepAction(-ZOOM_BUTTON_STEP)
  }
}
