import { Action } from 'redux_ark'

export class MagnifierPreviewOpenAction implements Action<'MagnifierPreviewOpen'> {
  type: 'MagnifierPreviewOpen' = 'MagnifierPreviewOpen'
}

export class MagnifierPreviewStopAction implements Action<'MagnifierPreviewStop'> {
  type: 'MagnifierPreviewStop' = 'MagnifierPreviewStop'
}

export class MagnifierAction {
  static openPreview(): MagnifierPreviewOpenAction {
    return new MagnifierPreviewOpenAction()
  }

  static stopPreview(): MagnifierPreviewStopAction {
    return new MagnifierPreviewStopAction()
  }
}
