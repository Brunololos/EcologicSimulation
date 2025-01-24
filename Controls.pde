class Controls extends Screen {

  Controls() {
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
    background(0,90,64);
    for(UI_Element ui_element : ui_elements) {
      ui_element.updateUI();
      ui_element.displayUI();
    }
  }



}
