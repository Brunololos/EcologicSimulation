class UI_List extends UI_Element {
  Composite list;
  int limit = 20;               // maximum number of elements
  float element_offset = 75;
  float element_select_offset = 25;

  int selected_index = -1;
  boolean addTile = false;

  UI_List(float xpos, float ypos) {
    super(xpos, ypos);
    list = new Composite(xpos, ypos);
    list.add(new Tile(0, 0) {
      @ Override public void function() {
        float lower_bound = list.components.size() > 1 ? ((Tile) list.components.get(list.components.size()-2)).minHeight + 25 /*25 Magic Number*/ : 500;
        ((Tile) list.components.get(list.components.size()-2)).maxHeight = 900;
        // TODO: Handle insertion with correct lower bound
        ((Tile_Editor) I.screens.get(5)).selected = new Tile(width/2, height/2, color(100, 200, 150), lower_bound, 1000);
        addTile = true;
      }
    });
  }

  void listenPressed() {
    if(MouseIsOver()) {
      Pressed = true;
      onPress();
    }
    list.listenPressed();
  }

  void listenReleased() {
    if(Pressed) { onRelease(); }
    Pressed = false;
    list.listenReleased();
  }

  void on_add() {};

  void clear() {
    int n = list.components.size()-1;
    for(int i=0; i<n; i++) {
      list.components.remove(0);
    }
    list.components.get(0).x = 0;
    selected_index = -1;
  }

  void add(color c, float minHeight, float maxHeight) {
    int n = list.components.size()-1;
    if(n < limit) {
      list.addAt(new Tile((element_offset*n)/2, 0, c, minHeight, maxHeight) {
        @ Override public void function() {
          select(list.components.indexOf(this));
        }
      }, n);

      for(UI_Element ui_e : list.components) { ui_e.x -= element_offset/2; }
      list.components.get(n+1).x = list.components.get(n+1).x + element_offset;

      select(n);
      addTile = false;
    }
    on_add();
  }

  void add(color c, float minHeight, float maxHeight, Biome biome) {
    int n = list.components.size()-1;
    if(n < limit) {
      list.addAt(new Tile((element_offset*n)/2, 0, c, minHeight, maxHeight, biome) {
        @ Override public void function() {
          select(list.components.indexOf(this));
        }
      }, n);

      for(UI_Element ui_e : list.components) { ui_e.x -= element_offset/2; }
      list.components.get(n+1).x = list.components.get(n+1).x + element_offset;

      select(n);
      addTile = false;
    }
    on_add();
  }

  void remove_selected() {
    // print(selected_index+"\n");
    if(list.components.size() > 2) {
      list.components.remove(selected_index);
      selected_index = -1;
      int n = list.components.size()-1;

      for(int i = 0; i<list.components.size(); i++) {
        UI_Element ui_e = list.components.get(i);
        ui_e.x = element_offset*i - element_offset*((float) n/2);
      }

      select(n-1);   // last element is add Tile
    } else if(list.components.size() == 2) {
      list.components.remove(selected_index);
      selected_index = -1;
      list.components.get(0).x = 0;
      ((Tile) ((Tile_Editor) I.screens.get(5)).selected).c = color(100, 100, 100, 0);
    }
  }

  void select(int i) {
    if(selected_index != -1) { list.components.get(selected_index).y += element_select_offset; }
    selected_index = i;
    list.components.get(selected_index).y -= element_select_offset;

    if(I != null) {
      // set slider values to corresponding color
      ((Standard_Slider) ((Tile_Editor) I.screens.get(5)).red_slider.get(0)).CurVal = red(((Tile) list.components.get(selected_index)).c);
      ((Standard_Slider) ((Tile_Editor) I.screens.get(5)).green_slider.get(0)).CurVal = green(((Tile) list.components.get(selected_index)).c);
      ((Standard_Slider) ((Tile_Editor) I.screens.get(5)).blue_slider.get(0)).CurVal = blue(((Tile) list.components.get(selected_index)).c);
      // update selected Tile color in Tile_Editor
      ((Tile) ((Tile_Editor) I.screens.get(5)).selected).c = ((Tile) list.components.get(selected_index)).c;
    }
  }

  void update() {
    list.update();
    int n = list.components.size()-1;
    if(addTile && n < limit) {
      //Tile s = ((Tile_Editor) I.screens.get(5)).selected;
      Tile tn = ((Tile) list.components.get(n-1));
      list.addAt(new Tile((element_offset*n)/2, 0, tn.c, tn.maxHeight, 1000, new Biome(tn.c, tn.maxHeight, 0.5, 15, 30)) {
        @ Override public void function() {
          select(list.components.indexOf(this));
        }
      }, n);

      for(UI_Element ui_e : list.components) { ui_e.x -= element_offset/2; }
      list.components.get(n+1).x = list.components.get(n+1).x + element_offset;

      select(n);
      addTile = false;
      on_add();
    }
  }

  void display() {
    list.displayUI();
  }
}
