class Triangle_Button extends UI_Element {
    float x1, x2, x3;
    float y1, y2, y3;
    int sW = 3;   //strokeWeight

  Triangle_Button(float x_, float y_, float x1_, float y1_, float x2_, float y2_, float x3_, float y3_) {
    super(x_, y_);
    x1 = x_ + x1_;
    x2 = x_ + x2_;
    x3 = x_ + x3_;
    y1 = y_ + y1_;
    y2 = y_ + y2_;
    y3 = y_ + y3_;
  }

  void onRelease() {
    activate();
  }

  void update() {    //Farbänderung wenn der Mauszeiger über dem Knopf ist
    //if(!mousePressed) { Pressed = false; }
  }


  void display() {                       //Darstellung des Buttons
    fill(218);
    if(MouseIsOver()) { fill(200); }
    if(Pressed) { fill(170); }
    strokeWeight(sW);
    stroke(141);
    triangle(x1 + absX(), y1 + absY(), x2 + absX(), y2 + absY(), x3 + absX(), y3 + absY());
  }


  float sign(float px1, float py1, float px2, float py2, float px3, float py3) {
    return (px1 - px3) * (py2 - py3) - (px2 - px3) * (py1 - py3);
  }

  @ Override
  boolean MouseIsOver() {                        //ermittelt ob Mauszeiger über einem Button ist
    boolean has_neg, has_pos;
    float d1, d2, d3;

    d1 = sign(mouseX + screenxshift, mouseY + screenyshift, x1 + absX() + screenxshift, y1 + absY() + screenyshift, x2 + absX() + screenxshift, y2 + absY() + screenyshift);
    d2 = sign(mouseX + screenxshift, mouseY + screenyshift, x2 + absX() + screenxshift, y2 + absY() + screenyshift, x3 + absX() + screenxshift, y3 + absY() + screenyshift);
    d3 = sign(mouseX + screenxshift, mouseY + screenyshift, x3 + absX() + screenxshift, y3 + absY() + screenyshift, x1 + absX() + screenxshift, y1 + absY() + screenyshift);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);
    return !(has_neg &&  has_pos);
  }



}
