import {
  MagnifierFilter,
  MagnifierMode
} from '../../model/magnifier/MagnifierUIModel';
import { MagnifierViewModel } from '../../viewmodel/MagnifierViewModel';

@ComponentV2
export struct MagnifierPage {
  private viewModel: MagnifierViewModel = new MagnifierViewModel();

  aboutToAppear(): void {
    this.viewModel.start();
  }

  aboutToDisappear(): void {
    this.viewModel.onCleared();
  }

  @Builder
  LabelRowBuilder(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#2A211A')

      Blank()

      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17130F')
    }
    .width('100%')
    .padding({ top: 4 })
  }

  @Builder
  CameraPreviewBuilder() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [
            ['#2A3437', 0],
            ['#111719', 0.52],
            ['#72817A', 1]
          ]
        })

      Column({ space: 8 }) {
        Text('营养成分')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17130F')

        Divider().color('#1A000000')
        this.LabelRowBuilder('能量', '1720 kJ')
        Divider().color('#1A000000')
        this.LabelRowBuilder('蛋白质', '8.5g')
        Divider().color('#1A000000')
        this.LabelRowBuilder('钠', '380 mg')
        Divider().color('#1A000000')
        this.LabelRowBuilder('日期', '2026.09.02')
      }
      .width(246)
      .padding(18)
      .borderRadius(10)
      .backgroundColor('#F6F1DF')
      .rotate({ angle: -6 })
      .shadow({
        radius: 36,
        offsetY: 18,
        color: '#59000000'
      })

      Stack()
        .width(150)
        .height(150)
        .border({
          width: 1.5,
          color: '#B8FFFFFF',
          radius: 38
        })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  GlassIconButtonBuilder(accessibilityText: string, label: string, action: () => void) {
    Button(label)
      .width(48)
      .height(48)
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
      .backgroundColor('#8A111719')
      .borderRadius(24)
      .accessibilityText(accessibilityText)
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .onClick(action)
  }

  @Builder
  TopBarBuilder(title: string, subtitle: string) {
    Row() {
      Column({ space: 4 }) {
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Text(subtitle)
          .fontSize(12)
          .fontColor('#B8FFFFFF')
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      if (this.viewModel.mode === MagnifierMode.Frozen) {
        this.GlassIconButtonBuilder('返回实时放大', '‹', () => {
          this.viewModel.onResumeLive();
        })
      }

      this.GlassIconButtonBuilder('更多设置', '···', () => {
      })
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 56 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  ZoomPanelBuilder() {
    Column({ space: 10 }) {
      Row() {
        Text('缩放')
          .fontSize(13)
          .fontColor('#C0FFFFFF')

        Blank()

        Text(this.viewModel.zoomText)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }

      Slider({
        value: this.viewModel.zoomRatio,
        min: 1,
        max: 8,
        step: 0.1,
        style: SliderStyle.OutSet
      })
        .selectedColor('#38E6B4')
        .trackColor('#33FFFFFF')
        .onChange((value: number) => {
          this.viewModel.onZoomChange(value);
        })
    }
    .padding(14)
    .width('100%')
    .borderRadius(26)
    .backgroundColor('#B0121719')
  }

  @Builder
  LiveControlsBuilder() {
    Column({ space: 10 }) {
      this.ZoomPanelBuilder()

      Row() {
        Row({ space: 8 }) {
          this.GlassIconButtonBuilder(this.viewModel.isTorchOn ? '关闭手电筒' : '打开手电筒', '☼', () => {
            this.viewModel.onTorchToggle();
          })

          this.GlassIconButtonBuilder('切换高对比滤镜', '◐', () => {
            this.viewModel.onFilterChange(MagnifierFilter.HighContrast);
          })
        }
        .padding(7)
        .borderRadius(31)
        .backgroundColor('#8A111719')

        Blank()

        Button('⏸')
          .width(82)
          .height(82)
          .fontSize(29)
          .fontWeight(FontWeight.Bold)
          .fontColor('#06120F')
          .backgroundColor('#38E6B4')
          .borderRadius(41)
          .accessibilityText('定格画面')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .onClick(() => {
            this.viewModel.onFreezeCapture();
          })

        Blank()

        Row({ space: 8 }) {
          this.GlassIconButtonBuilder('对焦', '⌖', () => {
          })

          this.GlassIconButtonBuilder('定格后识别文字', '文', () => {
            this.viewModel.onFreezeCapture();
          })
        }
        .padding(7)
        .borderRadius(31)
        .backgroundColor('#8A111719')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ left: 12, right: 12, bottom: 12 })
  }

  @Builder
  FilterButtonBuilder(title: string, filter: MagnifierFilter) {
    Column({ space: 6 }) {
      Text(' ')
        .width(28)
        .height(20)
        .backgroundColor(this.viewModel.filter === filter ? '#38E6B4' : '#FFFFFFFF')
        .borderRadius(10)

      Text(title)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .layoutWeight(1)
    .height(62)
    .justifyContent(FlexAlign.Center)
    .borderRadius(18)
    .backgroundColor(this.viewModel.filter === filter ? '#2638E6B4' : '#17FFFFFF')
    .onClick(() => {
      this.viewModel.onFilterChange(filter);
    })
  }

  @Builder
  FrozenSheetBuilder() {
    Column({ space: 14 }) {
      Row() {
        Text('查看与增强')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Blank()

        Text(this.viewModel.zoomText)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('#D0FFFFFF')
          .padding({ left: 12, right: 12, top: 7, bottom: 7 })
          .backgroundColor('#1AFFFFFF')
          .borderRadius(16)
      }

      Row({ space: 8 }) {
        this.FilterButtonBuilder('原图', MagnifierFilter.Original)
        this.FilterButtonBuilder('反色', MagnifierFilter.Invert)
        this.FilterButtonBuilder('高亮', MagnifierFilter.HighContrast)
        this.FilterButtonBuilder('清晰', MagnifierFilter.Clarity)
      }

      Button(this.viewModel.isRecognizing ? '识别中...' : '识别文字')
        .width('100%')
        .height(57)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#06120F')
        .backgroundColor('#38E6B4')
        .borderRadius(20)
        .accessibilityText('识别定格画面中的文字')
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick(() => {
          this.viewModel.onRecognizeText();
        })

      Row({ space: 9 }) {
        Button('继续看')
          .layoutWeight(1)
          .height(48)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#1AFFFFFF')
          .borderRadius(17)
          .onClick(() => {
            this.viewModel.onResumeLive();
          })

        Button('分享')
          .layoutWeight(1)
          .height(48)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#1AFFFFFF')
          .borderRadius(17)

        Button('保存')
          .layoutWeight(1)
          .height(48)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#1AFFFFFF')
          .borderRadius(17)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 40, bottom: 24 })
    .borderRadius({ topLeft: 31, topRight: 31 })
    .backgroundColor('#F014191B')
  }

  @Builder
  ReaderBuilder() {
    Column() {
      Row() {
        this.GlassIconButtonBuilder('返回定格页', '‹', () => {
          this.viewModel.onFreezeCapture();
        })

        Blank()

        Column() {
          Text('阅读器')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#171512')

          Text('识别到 5 行文字')
            .fontSize(12)
            .fontColor('#6B5841')
        }

        Blank()

        this.GlassIconButtonBuilder('文字样式', 'Aa', () => {
        })
      }
      .width('100%')
      .padding({ top: 56, left: 16, right: 16 })

      Column({ space: 18 }) {
        Column({ space: 4 }) {
          Text('原图核对')
            .fontSize(13)
            .fontColor('#6B5841')

          Text('能量 1720 kJ · 蛋白质 8.5g · 钠 380 mg')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#382B20')
        }
        .width('100%')
        .padding(14)
        .borderRadius(19)
        .backgroundColor('#99FFFFFF')

        Text(this.viewModel.recognizedText || '每 100g 含量\n能量 1720 kJ\n蛋白质 8.5g\n钠 380 mg')
          .fontSize(31)
          .fontWeight(FontWeight.Bold)
          .fontColor('#171512')
          .lineHeight(42)
          .width('100%')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18 })

      Blank()

      Column({ space: 12 }) {
        Row() {
          Text(this.viewModel.isSpeaking ? '正在朗读' : '准备朗读')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#171512')

          Blank()

          Text('0:12 / 0:31')
            .fontSize(13)
            .fontColor('#6B5841')
        }

        Progress({ value: 43, total: 100, type: ProgressType.Linear })
          .width('100%')
          .color('#FFCF7A')

        Row({ space: 8 }) {
          Button('A−')
            .layoutWeight(1)
          Button('↶')
            .layoutWeight(1)
          Button(this.viewModel.isSpeaking ? 'Ⅱ' : '▶')
            .layoutWeight(2)
            .onClick(() => {
              this.viewModel.onSpeechToggle();
            })
          Button('↷')
            .layoutWeight(1)
          Button(this.viewModel.speechRateText)
            .layoutWeight(1)
            .onClick(() => {
              this.viewModel.onSpeechRateChange();
            })
        }
      }
      .padding(15)
      .margin({ left: 13, right: 13, bottom: 13 })
      .borderRadius(28)
      .backgroundColor('#CFFFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFAF0')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.viewModel.mode === MagnifierMode.Reader) {
        this.ReaderBuilder()
      } else {
        this.CameraPreviewBuilder()
        this.TopBarBuilder(this.viewModel.mode === MagnifierMode.Live ? '放大器' : '已定格',
          this.viewModel.mode === MagnifierMode.Live ? '近距 · 自动对焦' : '拖动查看细节')

        if (this.viewModel.mode === MagnifierMode.Live) {
          this.LiveControlsBuilder()
        } else {
          this.FrozenSheetBuilder()
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#07090A')
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}
