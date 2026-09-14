import { MagnifierUIModel } from '../../model/magnifier/MagnifierUIModel'

const PORTRAIT_PREVIEW_RATIO: number = 9 / 16

export class MagnifierMapper {
  static toPreviewSurfaceRect(displayWidth: number, displayHeight: number): SurfaceRect {
    const displayRatio = displayWidth / displayHeight
    let surfaceWidth = displayWidth
    let surfaceHeight = displayHeight

    if (displayRatio > PORTRAIT_PREVIEW_RATIO) {
      surfaceHeight = Math.ceil(displayWidth / PORTRAIT_PREVIEW_RATIO)
    } else {
      surfaceWidth = Math.ceil(displayHeight * PORTRAIT_PREVIEW_RATIO)
    }

    return {
      offsetX: (displayWidth - surfaceWidth) / 2,
      offsetY: (displayHeight - surfaceHeight) / 2,
      surfaceWidth: surfaceWidth,
      surfaceHeight: surfaceHeight
    }
  }

  static toUIModel(zoomRatioRange: Array<number>, zoomRatio: number): MagnifierUIModel {
    if (zoomRatioRange.length < 2) {
      return new MagnifierUIModel()
    }

    const minZoomRatio = zoomRatioRange[0]
    const maxZoomRatio = zoomRatioRange[1]
    return MagnifierMapper.createUIModel(zoomRatio, minZoomRatio, maxZoomRatio)
  }

  static withZoomRatio(uiModel: MagnifierUIModel, zoomRatio: number): MagnifierUIModel {
    return MagnifierMapper.createUIModel(zoomRatio, uiModel.minZoomRatio, uiModel.maxZoomRatio)
  }

  static zoomBy(uiModel: MagnifierUIModel, step: number): MagnifierUIModel {
    return MagnifierMapper.withZoomRatio(uiModel, uiModel.zoomRatio + step)
  }

  private static clampZoomRatio(zoomRatio: number, minZoomRatio: number, maxZoomRatio: number): number {
    const clampedZoomRatio = Math.min(Math.max(zoomRatio, minZoomRatio), maxZoomRatio)
    return Math.round(clampedZoomRatio * 100) / 100
  }

  private static createUIModel(
    zoomRatio: number,
    minZoomRatio: number,
    maxZoomRatio: number
  ): MagnifierUIModel {
    const clampedZoomRatio = MagnifierMapper.clampZoomRatio(zoomRatio, minZoomRatio, maxZoomRatio)
    return new MagnifierUIModel(
      clampedZoomRatio,
      minZoomRatio,
      maxZoomRatio,
      maxZoomRatio > minZoomRatio,
      clampedZoomRatio > minZoomRatio,
      clampedZoomRatio < maxZoomRatio
    )
  }
}
