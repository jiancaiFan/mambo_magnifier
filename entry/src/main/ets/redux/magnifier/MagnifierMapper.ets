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
}
