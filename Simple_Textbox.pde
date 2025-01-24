class Simple_Textbox extends UI_Element {
  String label;  //String to be displayed in Textbox
  int size;  //Size of the displayed Text
  float w;  //Width of the Textbox
  float h;  //Height of the Textbox
  int o;  //Opacity
  int sw = 5; //StrokeWeight

  Simple_Textbox(String label_, float x_, float y_, float w_, float h_) {
    super(x_, y_);
    label = label_;
    w = w_;
    h = h_;
    o = 255;

    size = int(h);
    fixlength();
  }

  void display() {
    stroke(120, o);                                           //Drawing the Box of the Textbox
    strokeWeight(sw);
    fill(200, o);
    rectMode(CENTER);
    rect(absX(), absY(), w, h, 20);

    fill(30, o);                                              //Drawing the Label
    textAlign(CENTER, CENTER);
    textSize(size/1.5);
    text(label, absX(), absY()-((int) h/10));
  }

  //Trims Strings with to many characters into shorter ones
  void fixlength() {
    textSize(size/1.5);                                             //textSize is required, so textWidth evaluates correctly !!!
    if(textWidth(label)+5 >= w) {                         //Testing whether the Label of set textSize fits within the boundaries of the Textbox
      while(textWidth(label)+textWidth("...")+5 >= w) {          //Until the Label, that is appended by "..." fits into the textBox, the Label is shortened by a character
        if(label.length() <= 0) {label = ""; return;}                //If not even the String "..." fits within the TextBox, Label is set to an empty String and fixlength returns
        label = label.substring(0, label.length()-1);
      }
      label = (label+"...");                                          //"..." is appended to Label
    }
  }

  //Get the label
  String getLabel() {return label;}

  //Set the label
  void setLabel(String newLabel) {label = newLabel;}

  //Get Opacity
  int getOpacity() {return o;}

  //Set Opacity
  void setOpacity(int newo) {o = constrain(newo, 0, 255);}

  //Set StrokeWeight
  void setSW(int newsw) {sw = newsw;}
}
