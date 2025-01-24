class Interval_Split_Selector extends UI_Element {
  float l;    // length of Range_Selector - length in direction of the interval
  float w;    // width of Range_Selector - length perpendicular to the direction of the interval
  float min;   // lowest possible Value
  float max;   // highest possible Value
  float step = 1.0;  // Stepsize between adjustable Values
  Boolean vert = false; // vertical/horizontal alignment of Interval_Split_Selector
  IntList colors; // List of colors/sections the interval is divided into
  ArrayList<Float> borders; // List of values at which sections start

  float sep_w = 10.0;    // Width of interval separator
  int over_sep = 0;   // index of the separator the mouse is currently (hovering) over

  Interval_Split_Selector(float x_, float y_, float l_, float w_, color c_, float min_, float max_, float step_, Boolean vert_) {
      super(x_, y_);
      l = l_;
      w = w_;
      colors = new IntList();
      borders = new ArrayList<Float>();
      min = min_;
      max = max_;
      step = step_;
      vert = vert_;
  }

  void clear() {
    colors.clear();
    borders.clear();
  }

  void add_section(color c, float lower_border) {
    // TODO: handle lower_border larger than max
    println(lower_border);
    if(lower_border % step != 0) { return; }   // border not aligned to stepsize
    if(borders.size() > 0 && lower_border <= borders.get(borders.size()-1)) { print(lower_border+" smaller than border: "+borders.get(borders.size()-1)+"\n"); return; }   // border too low
    colors.append(c);
    borders.add(lower_border);
  }

  void remove_section(int index) {
    colors.remove(index);
    borders.remove(index);
    // in case the lowest border is deleted set the next lowest to begin at 0
    if(index == 0) {
      borders.set(0, 0.0);
    }
  }

  //Updates all runtimesensitive variables from Animations and alike
  void update() {
    if(!mousePressed) { Pressed = false; }  //sets Pressed to false if the mouse is not pressed

    updateActiveSeparator();
    if(Pressed) { activate(); }
  }

  // Draws a visual representation of the Interval_Split_Selector
  void display() {
    noStroke();
    fill(125);
    rectMode(CENTER);

    float range = (max-min);
    if(!vert) {
      rect(absX(), absY()+25, w, l);

      for(int i=0; i<colors.size(); i++) {
        fill(colors.get(i));
        rect(absX() - l*((borders.get(i)-min)/range)*0.5, absY(), l*(1 - ((borders.get(i)-min)/range)), w);
      }
      // TODO: Implement horizontal

    } else {
      fill(200);
      rect(absX()+25, absY(), w, l);
      for(int i=0; i<colors.size(); i++) {
        color c = colors.get(i);
        fill(colors.get(i));
        // Sections
        rect(absX(), absY() - l*((borders.get(i)-min)/range)*0.5, w, l*(1 - ((borders.get(i)-min)/range)));

        float h = hue(c);
        float s = saturation(c);
        float b = brightness(c);
        colorMode(HSB, 255);
        // Separators
        fill(color(h, s, b-15));
        rect(absX(), absY() - l*((borders.get(i)-min)/range) + l/2, w, sep_w, 25);
        colorMode(RGB, 255);
      }
      fill(colors.get(colors.size()-1));
      rect(absX(), absY() - l/2, w, 10, 25);
    }
  }

  void updateActiveSeparator() {
    if(!Pressed) { return; }
    float ppv = (max-min)/l;   // pixel per value
    // Calculate a value between min and max from mouseY value
    float value = ((absY() + l/2 - (mouseY - screenyshift))*(max-min))/l + min;
    value = value - value % step;   // value is constrained to step
    value = constrain(value, min+over_sep*step*ppv*sep_w,
                             max-(borders.size()-over_sep-1)*step*ppv*sep_w);
    borders.set(over_sep, value);
    // push downward
    for(int i=over_sep-1; i>0; i--) {
      if(borders.get(i) < borders.get(i+1)-step*ppv*sep_w) { break; }
      borders.set(i, borders.get(i+1)-step*ppv*sep_w);
    }
    // push upward
    for(int i=over_sep+1; i<borders.size(); i++) {
      if(borders.get(i) > borders.get(i-1)+step*ppv*sep_w) { break; }
      borders.set(i, borders.get(i-1)+step*ppv*sep_w);
    }
  }

  void onRelease() { activate(); }

  // Activated when mousePressed() is called
  void listenPressed() {
    if(MouseIsOver()) {
      Pressed = true;
    }
  }

  // Activated when mouseReleased() is called
  void listenReleased() {
    if(Pressed) { onRelease(); }
    Pressed = false;
  }

  boolean MouseIsOver() {
    if(!vert) {
      // going through borders and checking whether the mouse is above any separator
      if(mouseY + screenyshift <= absY() + w/2 && mouseY + screenyshift >= absY() - w/2) {
        for(int i=1; i<borders.size(); i++) {
          if(mouseX + screenxshift <= absX() + l/2 + sep_w/2 - l*((borders.get(i)-min)/(max-min))
          && mouseX + screenxshift >= absX() + l/2 - sep_w/2 - l*((borders.get(i)-min)/(max-min))) {
            over_sep = i;
            return true;
          }
        }
      }
    } else {
      if(mouseX + screenxshift <= absX() + w/2 && mouseX + screenxshift >= absX() - w/2) {
        for(int i=1; i<borders.size(); i++) {
          if(mouseY + screenyshift <= absY() + l/2 + sep_w/2 - l*((borders.get(i)-min)/(max-min))
          && mouseY + screenyshift >= absY() + l/2 - sep_w/2 - l*((borders.get(i)-min)/(max-min))) {
            over_sep = i;
            return true;
          }
        }
      }
    }
    return false;
  }
}
