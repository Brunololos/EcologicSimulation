class Startbildschirm extends Screen {

  Startbildschirm() {
    super();

    //Start Button
    ui_elements.add(new Simple_Button("Start", 960, 200, 600, 75) {
      @ Override public void function() { I.screen = 0; } });

    //Optionen Button
    ui_elements.add(new Simple_Button("Optionen", 960, 285, 600, 75) {
      @ Override public void function() { I.screen = 2; } });

    //Controls Button
    ui_elements.add(new Simple_Button("Controls", 960, 370, 600, 75) {
      @ Override public void function() { I.screen = 3; } });

    //Credits Button
    ui_elements.add(new Simple_Button("Credits", 960, 455, 600, 75) {
      @ Override public void function() { I.screen = 4; } });
  }

  void update() {

  }

  void display() {
    colorMode(HSB);
    background(135,206,100);                                            //light sky blue   135,206,250
    textSize(height/30);

    fill(255);
    textSize(height/20);
    text("Biotop", width/2, height/10);

    for(UI_Element element : ui_elements) {
        element.updateUI();
        element.displayUI();
    }
  }
}
