import { MagnifierPage } from '../magnifier/MagnifierPage';

@ComponentV2
export struct MainPage {
  build() {
    Stack() {
      MagnifierPage()
    }
    .width(LayoutPolicy.matchParent)
    .height(LayoutPolicy.matchParent)
    .backgroundColor('#07090A')
  }
}
