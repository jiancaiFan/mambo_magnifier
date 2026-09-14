import { Action, Dispatch, Middleware, MiddlewareAPI } from 'redux_ark'
import { MagnifierRuntimeService } from '../../services/magnifier/MagnifierRuntimeService'
import {
  MagnifierAction,
  MagnifierPreviewOpenAction,
  MagnifierZoomChangeAction
} from './MagnifierAction'
import { MagnifierMapper } from './MagnifierMapper'
import { MagnifierState } from './MagnifierState'

export class MagnifierSideEffect implements Middleware<MagnifierState> {
  private runtimeService: MagnifierRuntimeService

  constructor(runtimeService: MagnifierRuntimeService) {
    this.runtimeService = runtimeService
  }

  dispatch(store: MiddlewareAPI<MagnifierState>, next: Dispatch<Action>, action: Action): Action {
    const result = next.dispatch(action)

    switch (action.type) {
      case 'MagnifierPreviewOpen':
        this.openPreview(store, action as MagnifierPreviewOpenAction)
        break
      case 'MagnifierPreviewStop':
        this.stopPreview()
        break
      case 'MagnifierZoomChange':
        this.changeZoom(store, (action as MagnifierZoomChangeAction).smooth)
        break
      case 'MagnifierZoomStep':
        this.changeZoom(store, true)
        break
      default:
        break
    }

    return result
  }

  private async openPreview(
    store: MiddlewareAPI<MagnifierState>,
    action: MagnifierPreviewOpenAction
  ): Promise<void> {
    try {
      this.runtimeService.bindPreviewSurface(action.context, action.surfaceId)
      await this.runtimeService.startPreview()
      const zoomRatioRange = this.runtimeService.getZoomRatioRange()
      const zoomRatio = this.runtimeService.getZoomRatio()
      store.dispatch(MagnifierAction.zoomReady(MagnifierMapper.toUIModel(zoomRatioRange, zoomRatio)))
    } catch (error) {
    }
  }

  private async stopPreview(): Promise<void> {
    this.runtimeService.clearPreviewSurface()
    await this.runtimeService.stopPreview()
  }

  private changeZoom(store: MiddlewareAPI<MagnifierState>, smooth: boolean): void {
    const zoomRatio = store.getState().uiModel.zoomRatio
    if (smooth) {
      this.runtimeService.setSmoothZoomRatio(zoomRatio)
    } else {
      this.runtimeService.setZoomRatio(zoomRatio)
    }
  }
}
