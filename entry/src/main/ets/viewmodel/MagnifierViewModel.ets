import { common } from '@kit.AbilityKit'
import { Action, Store, StoreSubscriber, StoreSubscription } from 'redux_ark'
import { MagnifierAction } from '../redux/magnifier/MagnifierAction'
import { MagnifierMapper } from '../redux/magnifier/MagnifierMapper'
import { MagnifierState } from '../redux/magnifier/MagnifierState'
import { MagnifierStoreProvider } from '../redux/magnifier/MagnifierStoreProvider'

@ObservedV2
export class MagnifierViewModel implements StoreSubscriber {
  private store: Store<MagnifierState, Action> = MagnifierStoreProvider.create()
  @Trace public state: MagnifierState = this.store.getState()
  private subscription?: StoreSubscription

  start(): void {
    if (this.subscription === undefined) {
      this.subscription = this.store.subscribe(this)
    }
  }

  onStateChanged(): void {
    this.state = this.store.getState()
  }

  getPreviewSurfaceRect(displayWidth: number, displayHeight: number): SurfaceRect {
    return MagnifierMapper.toPreviewSurfaceRect(displayWidth, displayHeight)
  }

  changeZoom(zoomRatio: number, smooth: boolean): void {
    this.store.dispatch(MagnifierAction.changeZoom(zoomRatio, smooth))
  }

  zoomOut(): void {
    this.store.dispatch(MagnifierAction.zoomOut())
  }

  zoomIn(): void {
    this.store.dispatch(MagnifierAction.zoomIn())
  }

  onCleared(): void {
    if (this.subscription !== undefined) {
      this.subscription.unsubscribe()
      this.subscription = undefined
    }
    this.store.dispatch(MagnifierAction.stopPreview())
  }

  onSurfaceReady(context: common.UIAbilityContext, surfaceId: string): void {
    this.store.dispatch(MagnifierAction.openPreview(context, surfaceId))
  }

  onSurfaceDestroyed(): void {
    this.store.dispatch(MagnifierAction.stopPreview())
  }
}
