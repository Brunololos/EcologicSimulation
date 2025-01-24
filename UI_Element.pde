abstract class UI_Element {
  float x;  //x-position of a UI_Element
  float y;  //y-position of a UI_Element

  //Change based on current work setup
  float xinRange = 1920;  //Upper bound of the displayWidth the absolute position is initially defined on (then scaled to any other widths)
  float yinRange = 1080;  //Upper bound of the displayHeight the absolute position is initially defined on (then scaled to any other heights)

  //Since in Composite Objects the Component-UI_Elements are meant to be aligned
  //around the position of the Composite Object,
  //the x/yshift variables are the x/y coordinates of a potential parent Composite Object
  //In that case the UI_Elements x/y coordinates are merely used
  //to align said UI_Element relative to the Composite Object
  //And thus the x/yshift variables are used to account for the displacement of UI_Elements
  //that are part of Composite Objects, such that functions like (mouseIsOver()) work regardless
  //of the UI_Element being part or not being part of a Composite Object
  //If the x/yshift remains set to 0, it has no influence on calculations
  float xshift = 0;  //xshift of UI_Elements that are part of a Composite Object
  float yshift = 0;  //yshift of UI_Elements that are part of a Composite Object

  //Variables to account for the displacement of the displayed Screen from the origin of processings canvas coordinate system
  float screenxshift = 0;
  float screenyshift = 0;

  //Whether an UI Element is currently set to be updated
  boolean Active = true;
  
  //Whether an UI Element is currently set to be rendered
  boolean Visible = true;

  //Whether an UI Element is currently being pressed
  boolean Pressed = false;

  UI_Element(float x_, float y_) {
    x = map(x_, 0, xinRange, 0, width);
    y = map(y_, 0, yinRange, 0, height);
  }

  //General Function to update the internal logic of any UI Element over time
  final void updateUI() {
    if(!Active) { return; }
    if(!mousePressed) { Pressed = false; }
    if(Pressed) { onHold(); }
    updateFeed();
    update();
  }

  /*Override*/
  //General Function to update the internal logic of any UI Element over time
  void update() {}

  /*Override*/
  //General Function for continous updates on an UI Element (for example: Dependence of UI Element positions on runtime variables outside the UI Element)
  void updateFeed() {}

  //General Function to display any UI Element given it is set to be visible
  final void displayUI() {
    if(!Visible) { return; }
    display();
  }

  /*Override*/
  //General Function to draw any UI Element according to its state on screen
  void display() {}

  //Execution of onPress
  void listenPressed() {
    if(!Active) { return; }
    if(MouseIsOver()) {
      Pressed = true;
      onPress();
    }
  }

  //Execution of onRelease
  void listenReleased() {
    if(!Active) { return; }
    if(Pressed) { onRelease(); }
    Pressed = false;
  }

  /*Override*/
  //General Function to incorporate UI Interactivity, when first pressed
  void onPress() {}

  /*Override*/
  //General Function to incorporate UI Interactivity, when held down
  void onHold() {}

  /*Override*/
  //General Function to incorporate UI Interactivity, when released after being pressed
  void onRelease() {}

  //Activation of the function (call somewhere in subclass)
  final void activate() { function(); }

  /*Override*/
  //General Function for implementation of UI logic, that that impacts other things than the UI
  void function() {}

  //General Function to determine whether the mouse is positioned over an UI Element
  boolean MouseIsOver() { return false; }

  //Get/Set x,y
  float getX() { return x; }
  float getY() { return y; }
  void setX(float newx) { x = map(newx, 0, xinRange, 0, width); }
  void setY(float newy) { y = map(newy, 0, yinRange, 0, height); }

  //Get/Set x/yshift
  float getXshift() { return xshift; }
  float getYshift() { return yshift; }
  void setXshift(float newxshift) { xshift = newxshift; }
  void setYshift(float newyshift) { yshift = newyshift; }

  void setscreenXshift(float newscreenxshift) { screenxshift = newscreenxshift; }
  void setscreenYshift(float newscreenyshift) { screenyshift = newscreenyshift; }

  //Get the abolute x,y values
  float absX() { return x + xshift; }
  float absY() { return y + yshift; }

  void setVisible(boolean newVisible) { Visible = newVisible; };
  void setActive(boolean newActive) { Active = newActive; };
}
