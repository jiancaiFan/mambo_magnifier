import { common } from '@kit.AbilityKit'
import { display } from '@kit.ArkUI'
import { MagnifierViewModel } from '../../viewmodel/MagnifierViewModel'
import { MagnifierZoomPanel } from './MagnifierZoomPanel'

@ComponentV2
export struct MagnifierPage {
  private viewModel: MagnifierViewModel = new MagnifierViewModel()
  private xComponentController: XComponentController = new XComponentController()

  aboutToAppear(): void {
    this.viewModel.start()
  }

  aboutToDisappear(): void {
    this.viewModel.onCleared()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onLoad(() => {
          const surfaceId = this.xComponentController.getXComponentSurfaceId()
          const defaultDisplay = display.getDefaultDisplaySync()
          const surfaceRect = this.viewModel.getPreviewSurfaceRect(defaultDisplay.width, defaultDisplay.height)
          this.xComponentController.setXComponentSurfaceRect(surfaceRect)
          this.xComponentController.setXComponentSurfaceRotation({ lock: true })
          this.viewModel.onSurfaceReady(
            this.getUIContext().getHostContext() as common.UIAbilityContext,
            surfaceId
          )
        })
        .onDestroy(() => {
          this.viewModel.onSurfaceDestroyed()
        })

      Row() {
        MagnifierZoomPanel({ viewModel: this.viewModel })
      }
      .width('calc(100% - 16vp)')
      .margin({ bottom: 8 })
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
