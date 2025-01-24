class Composite extends UI_Element {
  private ArrayList<UI_Element> components;

  Composite(float x_, float y_) {
    super(x_, y_);
    components = new ArrayList<UI_Element>();
  }

  Composite(float x_, float y_, ArrayList<UI_Element> components_) {
    super(x_, y_);
    components = components_;
    for(UI_Element element : components) { element.setXshift(x); element.setYshift(y); }
  }

  //Update the internal logic of all components of the Composite Object
  void update() {
    for(UI_Element element : components) { element.update(); }
  }

  //Listen for user input for every Component of the Composite Object
  void listenPressed() {
    for(UI_Element element : components) { element.listenPressed(); }
  }

  //Listen for user input for every Component of the Composite Object
  void listenReleased() {
    for(UI_Element element : components) { element.listenReleased(); }
  }

  //Display all components of the Composite Object
  void display() {
    //Translation of the Coordinate-System, so that the components are drawn relative to the Position of the Composite Object
    //This is done in order to have all components positions be dependent on the Composite Objects position,
    //without changing the way the components positioning works when they are not part of a Composite Object
    //The Positions ((x,y) coordinates) specified in the components are thus only used for spacing them out correctly as parts of the Composite Object
    for(UI_Element element : components) { element.display(); }
  }

  //Get a new element of the Composite Object
  UI_Element get(int index) {
    return components.get(index);
  }

  //Add a new element to the Composite Object
  void add(UI_Element newelement) {
    newelement.setXshift(x);
    newelement.setYshift(y);
    components.add(newelement);
  }

  //Add a new element to the Composite Object
  void addAt(UI_Element newelement, int i) {
    newelement.setXshift(x);
    newelement.setYshift(y);
    components.add(i, newelement);
  }

  void setX(float newx) {
    for(UI_Element element : components) { element.setXshift(newx); }
    x = newx;
  }

  void setY(float newy) {
    for(UI_Element element : components) { element.setYshift(newy); }
    y = newy;
  }

  void setscreenXshift(float newscreenxshift) {
    for(UI_Element element : components) { element.setscreenXshift(newscreenxshift); }
  }

  void setscreenYshift(float newscreenyshift) {
    for(UI_Element element : components) { element.setscreenYshift(newscreenyshift); }
  }
}
