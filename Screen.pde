abstract class Screen {
  ArrayList<UI_Element> ui_elements;

  Screen() {
    ui_elements = new ArrayList<UI_Element>();
  }

  /*Override*/
  //Generic update function
  public void update() {}

  /*Override*/
  //Generic display function
  public void display() {}

}
