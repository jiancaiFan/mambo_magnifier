export class MagnifierUIModel {
  zoomRatio: number
  minZoomRatio: number
  maxZoomRatio: number
  canZoom: boolean
  canZoomOut: boolean
  canZoomIn: boolean

  constructor(
    zoomRatio: number = 1,
    minZoomRatio: number = 1,
    maxZoomRatio: number = 1,
    canZoom: boolean = false,
    canZoomOut: boolean = false,
    canZoomIn: boolean = false
  ) {
    this.zoomRatio = zoomRatio
    this.minZoomRatio = minZoomRatio
    this.maxZoomRatio = maxZoomRatio
    this.canZoom = canZoom
    this.canZoomOut = canZoomOut
    this.canZoomIn = canZoomIn
  }
}
