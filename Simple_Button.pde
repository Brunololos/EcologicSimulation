class Simple_Button extends UI_Element {
  String label;
  float w;    // width of button
  float h;    // height of button
  float tSize;
  int sW = 5;   //strokeWeight
  int bev1 = 50;
  int bev2 = 50;
  int bev3 = 50;
  int bev4 = 50;
  float US = 0;   //Upshift for Textalignment

  Simple_Button(String labelB, float xpos, float ypos, float widthB, float heightB) {         //gekürzte Button Funktion  //Constructor
    super(xpos, ypos);
    label = labelB;
    w = widthB;
    h = heightB;
    tSize = h/2;
  }

  Simple_Button(String label_, float xpos, float ypos, float widthB, float heightB, int bev1_, int bev2_, int bev3_, int bev4_) {            //ausführliche Button Funktion //Constructor
    super(xpos, ypos);
    label = label_;
    w = widthB;
    h = heightB;
    tSize = h/2;
    bev1 = bev1_;
    bev2 = bev2_;
    bev3 = bev3_;
    bev4 = bev4_;
  }

  void onRelease() {
    activate();
  }

  void update(){    //Farbänderung wenn der Mauszeiger über dem Knopf ist

  }

  void display() {                       //Darstellung des Buttons
    fill(218);
    if(MouseIsOver()) { fill(200); }
    if(Pressed) { fill(170); }

    strokeWeight(sW);
    stroke(141);
    rectMode(CENTER);
    rect(absX(), absY(), w, h, bev1, bev2, bev3, bev4);
    textAlign(CENTER, CENTER);
    textSize(tSize);
    fill(0);
    text(label, absX(), absY()-US);
  }

  boolean MouseIsOver() {                        //ermittelt ob Mauszeiger über einem Button ist
    if(mouseX + screenxshift >= (absX() - w/2) && mouseX + screenxshift <= (absX() + w/2)
    && mouseY + screenyshift >= (absY() - h/2) && mouseY + screenyshift <= (absY() + h/2)) {
      return true;
    }
    return false;
  }
}
