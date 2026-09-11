import { common } from '@kit.AbilityKit'
import { Action, Store, StoreSubscriber, StoreSubscription } from 'redux_ark'
import { MagnifierAction } from '../redux/magnifier/MagnifierAction'
import { MagnifierMapper } from '../redux/magnifier/MagnifierMapper'
import { MagnifierState } from '../redux/magnifier/MagnifierState'
import { MagnifierStoreProvider } from '../redux/magnifier/MagnifierStoreProvider'
import { MagnifierRuntimeService } from '../services/magnifier/MagnifierRuntimeService'

@ObservedV2
export class MagnifierViewModel implements StoreSubscriber {
  private runtimeService: MagnifierRuntimeService = new MagnifierRuntimeService()
  private store: Store<MagnifierState, Action> = MagnifierStoreProvider.create(this.runtimeService)
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

  onCleared(): void {
    if (this.subscription !== undefined) {
      this.subscription.unsubscribe()
      this.subscription = undefined
    }
    this.store.dispatch(MagnifierAction.stopPreview())
  }

  onSurfaceReady(context: common.UIAbilityContext, surfaceId: string): void {
    this.runtimeService.bindPreviewSurface(context, surfaceId)
    this.store.dispatch(MagnifierAction.openPreview())
  }

  onSurfaceDestroyed(): void {
    this.runtimeService.clearPreviewSurface()
    this.store.dispatch(MagnifierAction.stopPreview())
  }
}
