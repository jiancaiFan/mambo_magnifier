import { Action, Dispatch, Middleware, MiddlewareAPI } from 'redux_ark'
import { MagnifierRuntimeService } from '../../services/magnifier/MagnifierRuntimeService'
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
        this.openPreview()
        break
      case 'MagnifierPreviewStop':
        this.stopPreview()
        break
      default:
        break
    }

    return result
  }

  private async openPreview(): Promise<void> {
    try {
      await this.runtimeService.startPreview()
    } catch (error) {
    }
  }

  private async stopPreview(): Promise<void> {
    await this.runtimeService.stopPreview()
  }
}
