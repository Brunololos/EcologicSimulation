class Credits extends Screen {

  Credits() {
    super();

    //Zurück Button
    ui_elements.add(new Simple_Button("Zurück",50,15,100,30,0,0,50,0) {
      @ Override public void function() {
        I.screen = 1;
      }
    });
  }

  void update() {

  }

  void display() {
    background(180,210,190);
    textSize(80);
    //text("Andreas Paul Bruno Lönne", width/2,height/2);

    for(UI_Element ui_element : ui_elements) {
      ui_element.updateUI();
      ui_element.displayUI();
    }
  }




































}
