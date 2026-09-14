import { MagnifierViewModel } from '../../viewmodel/MagnifierViewModel'

@ComponentV2
export struct MagnifierZoomPanel {
  @Param @Require viewModel: MagnifierViewModel

  build() {
    Column() {
      Row({ space: 8 }) {
        Button() {
          SymbolGlyph($r('sys.symbol.minus'))
            .fontSize(28)
            .fontWeight(FontWeight.Medium)
            .fontColor([Color.White])
        }
        .type(ButtonType.Circle)
        .width(48)
        .height(48)
        .backgroundColor(Color.Transparent)
        .enabled(this.viewModel.state.uiModel.canZoomOut)
        .opacity(this.viewModel.state.uiModel.canZoomOut ? 1 : 0.38)
        .accessibilityText($r('app.string.magnifier_zoom_out'))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick(() => {
          this.viewModel.zoomOut()
        })

        Slider({
          value: this.viewModel.state.uiModel.zoomRatio,
          min: this.viewModel.state.uiModel.minZoomRatio,
          max: this.viewModel.state.uiModel.maxZoomRatio,
          step: 0.01,
          style: SliderStyle.OutSet
        })
          .layoutWeight(1)
          .trackThickness(5)
          .trackColor('#929796')
          .selectedColor('#F4F5F5')
          .blockColor('#FFC400')
          .blockBorderColor(Color.White)
          .blockBorderWidth(4)
          .blockSize({ width: 30, height: 30 })
          .sliderInteractionMode(SliderInteraction.SLIDE_AND_CLICK)
          .enabled(this.viewModel.state.uiModel.canZoom)
          .accessibilityText($r('app.string.magnifier_zoom_slider'))
          .onChange((value: number, mode: SliderChangeMode) => {
            if (mode === SliderChangeMode.Moving) {
              this.viewModel.changeZoom(value, false)
            } else if (mode === SliderChangeMode.Click) {
              this.viewModel.changeZoom(value, true)
            }
          })

        Button() {
          SymbolGlyph($r('sys.symbol.plus'))
            .fontSize(28)
            .fontWeight(FontWeight.Medium)
            .fontColor([Color.White])
        }
        .type(ButtonType.Circle)
        .width(48)
        .height(48)
        .backgroundColor(Color.Transparent)
        .enabled(this.viewModel.state.uiModel.canZoomIn)
        .opacity(this.viewModel.state.uiModel.canZoomIn ? 1 : 0.38)
        .accessibilityText($r('app.string.magnifier_zoom_in'))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick(() => {
          this.viewModel.zoomIn()
        })
      }
      .width('100%')
      .height(72)
      .padding({ left: 10, right: 10 })
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#D94B504F')
      .borderRadius(36)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#E6212524')
    .borderRadius(44)
    .shadow({ radius: 28, color: '#52000000', offsetY: 12 })
  }
}
