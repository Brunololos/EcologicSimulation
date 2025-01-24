class Tile_Editor extends Screen {
  UI_List tiles;
  Tile selected = null;
  Simple_Button remove_button;
  Composite red_slider;
  Composite blue_slider;
  Composite green_slider;
  Interval_Split_Selector tile_interval_selector;

  Tile_Editor() {
    super();

    // Selected
    selected = new Tile(width/2, height/2, color(100, 200, 150, 0), 0, 1000);

    // Zurück Button
    ui_elements.add(new Simple_Button("Zurück",50,15,100,30,0,0,50,0) {
      @ Override public void function() {
        // TODO: At present the biomes are only updated when leaving the Tile Editor through this button
        ArrayList<Biome> biomes = new ArrayList<Biome>();
        for(UI_Element ui_e : tiles.list.components) {
          if(((Tile) ui_e).empty) { continue; }
          biomes.add(((Tile) ui_e).toBiome());
        }
        I.P.W.B.set(biomes);
        println(I.P.W.B.count());
        I.screen = 2;
      }
    });

    // Remove Button
    remove_button = new Simple_Button("Remove",width/2,height/2+200,100,30,50,50,50,50) {
      @ Override public void function() {
        // TODO: forbid removing the last section (hide when #sections == 1 and display if #section > 1)
        tile_interval_selector.remove_section(tiles.selected_index);
        tiles.remove_selected();
        println(tiles.list.components.size());
        if(tiles.list.components.size() == 2) {
          remove_button.setActive(false);
          remove_button.setVisible(false);
        }
      }
    };
    ui_elements.add(remove_button);

    // Reset Button
    ui_elements.add(new Simple_Button("Reset",width/2,height/2+250,100,30,50,50,50,50) {
      @ Override public void function() {
        reset_tiles();
        remove_button.setActive(true);
        remove_button.setVisible(true);
      }
    });

    // Blue Slider
    blue_slider = new Composite(width-350, 520);
    blue_slider.add( new Standard_Slider(150,0, 300.0,5, 0,255,127, false) {
      @ Override public void function() {
        if(selected != null) { selected.c = (selected.c & ~255) | round(CurVal); }
        // TODO: this paradigm is just plain terrible
        // colors of the biome and ui elements both have to be updated as well as the zillions of references to biomes and hardcoded biome initializations in the code
        ((Tile) tiles.list.components.get(tiles.selected_index)).c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~255 ) | round(CurVal);
        ((Tile) tiles.list.components.get(tiles.selected_index)).biome.c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~255 ) | round(CurVal);
        tile_interval_selector.colors.set(tiles.selected_index, (tile_interval_selector.colors.get(tiles.selected_index) & ~255) | round(CurVal));
      }
    });
    blue_slider.add(new Simple_Textbox("Blau", -100, 0, 100, 25));
    ui_elements.add(blue_slider);

    // Green Slider
    green_slider = new Composite(width-350, 480);
    green_slider.add( new Standard_Slider(150,0, 300.0,5, 0,255,127, false) {
      @ Override public void function() {
        if(selected != null) { selected.c = (selected.c & ~(255 << 8)) | (round(CurVal) << 8); }
        ((Tile) tiles.list.components.get(tiles.selected_index)).c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~(255 << 8) ) | (round(CurVal) << 8);
        ((Tile) tiles.list.components.get(tiles.selected_index)).biome.c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~(255 << 8) ) | (round(CurVal) << 8);
        tile_interval_selector.colors.set(tiles.selected_index, (tile_interval_selector.colors.get(tiles.selected_index) & ~(255 << 8)) | (round(CurVal) << 8));
      }
    });
    green_slider.add(new Simple_Textbox("Grün", -100, 0, 100, 25));
    ui_elements.add(green_slider);

    // Red Slider
    red_slider = new Composite(width-350, 440);
    red_slider.add( new Standard_Slider(150,0, 300.0,5, 0,255,127, false) {
      @ Override public void function() {
        if(selected != null) { selected.c = (selected.c & ~(255 << 16)) | (round(CurVal) << 16); }
        ((Tile) tiles.list.components.get(tiles.selected_index)).c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~(255 << 16) ) | (round(CurVal) << 16);
        ((Tile) tiles.list.components.get(tiles.selected_index)).biome.c = (((Tile) tiles.list.components.get(tiles.selected_index)).c & ~(255 << 16) ) | (round(CurVal) << 16);
        tile_interval_selector.colors.set(tiles.selected_index, (tile_interval_selector.colors.get(tiles.selected_index) & ~(255 << 16)) | (round(CurVal) << 16));
      }
    });
    red_slider.add(new Simple_Textbox("Rot", -100, 0, 100, 25));
    ui_elements.add(red_slider);

    tile_interval_selector = new Interval_Split_Selector(75, height/2, 500, 50, color(154, 186, 244), 0.0, 1000.0, 1.0, true) {
      @Override public void function() {
        Tile t;
        for(int i=0; i<borders.size()-1; i++) {
          t = (Tile) tiles.list.components.get(i);
          t.setHeights(borders.get(i), borders.get(i+1));
        }
        t = (Tile) tiles.list.components.get(borders.size()-1);
        t.setHeights(borders.get(borders.size()-1), 1000);
      }
    };
    ui_elements.add(tile_interval_selector);

    tiles = new UI_List(width/2, height-75) {
      @ Override public void on_add() {
        Tile t = ((Tile) list.components.get(list.components.size()-2));
        tile_interval_selector.add_section(t.c, t.minHeight);
        remove_button.setActive(true);
        remove_button.setVisible(true);
      };
    };
    /* Initialize Tile List */
    colorMode(HSB);
    // TODO: Write Config file parser
    /*ArrayList<Biome> biomes = BiomeSettings.getStandardBiomes();*/  // TODO: create file reader instead
/*     tiles.add(color(154, 186, 244), 0, biomes.get(0).upperElevationBorder, biomes.get(0));
    tiles.add(color(154, 131, 255), 400, 450, I.P.W.B.get(1));
    tiles.add(color(39, 169, 239), 450, 500, I.P.W.B.get(2));
    tiles.add(color(64, 189, 232-15), 500, 625, I.P.W.B.get(3));
    tiles.add(color(85, 193, 139-25), 625, 725, I.P.W.B.get(4));
    tiles.add(color(52, 15, 221), 725, 765, I.P.W.B.get(5));
    tiles.add(color(0, 0, 128), 765, 825, I.P.W.B.get(6));
    tiles.add(color(0, 0, 255), 825, 1000, I.P.W.B.get(7)); */
    //selected = new Tile(width/2, height/2, color(0, 0, 255), 825, 1000, biomes.get(7));
    tiles.add(color(154, 186, 244), 0, 400, new Biome(color(154, 186, 244), 400, 0, 1, 1));
    tiles.add(color(154, 131, 255), 400, 450, new Biome(color(154, 131, 255), 450, 0, 5, 5));
    tiles.add(color(39, 169, 239), 450, 500, new Biome(color(39, 169, 239), 500, 0, 10, 10));
    tiles.add(color(64, 189, 232-15), 500, 625, new Biome(color(64, 189, 232-15), 625, 0.25, 30, 20));
    tiles.add(color(85, 193, 139-25), 625, 725, new Biome(color(85, 193, 139-25), 725, 0.5, 50, 25));
    tiles.add(color(52, 15, 221), 725, 765, new Biome(color(52, 15, 221), 765, 0, 5, 5));
    tiles.add(color(0, 0, 128), 765, 825, new Biome(color(0, 0, 128), 825, 0, 3, 3));
    tiles.add(color(0, 0, 255), 825, 1000, new Biome(color(0, 0, 255), 1000, 0, 2, 2));
    selected = new Tile(width/2, height/2, color(0, 0, 255), 825, 1000, new Biome(color(0, 0, 255), 1000, 0, 2, 2));

    ui_elements.add(tiles);
  }

  void reset_tiles() {
    /* Initialize Tile List */
    colorMode(HSB);
    tiles.clear();
/*     tiles.add(color(154, 186, 244), 0, 400, 0, 1, 1);
    tiles.add(color(154, 131, 255), 400, 450, 0, 5, 5);
    tiles.add(color(39, 169, 239), 450, 500, 0, 10, 10);
    tiles.add(color(64, 189, 232-15), 500, 625, 0.25, 30, 20);
    tiles.add(color(85, 193, 139-25), 625, 725, 0.5, 50, 25);
    tiles.add(color(52, 15, 221), 725, 765, 0, 5, 5);
    tiles.add(color(0, 0, 128), 765, 825, 0, 3, 3);
    tiles.add(color(0, 0, 255), 825, 1000, 0, 2, 2); */

    tile_interval_selector.clear();
    tile_interval_selector.add_section(color(154, 186, 244), 0);
    tile_interval_selector.add_section(color(154, 131, 255), 400);
    tile_interval_selector.add_section(color(39, 169, 239), 450);
    tile_interval_selector.add_section(color(64, 189, 232), 500);
    tile_interval_selector.add_section(color(85, 193, 139), 625);
    tile_interval_selector.add_section(color(52, 15, 221), 725);
    tile_interval_selector.add_section(color(0, 0, 128), 765);
    tile_interval_selector.add_section(color(0, 0, 255), 825);
  }

  void update() {
    tiles.updateUI();
  }

  void display() {
    colorMode(HSB);
    background(209, 153, 102);
    fill(255);
    textSize(50);
    text("Feld Editor",width/2,70);

    for(UI_Element ui_element : ui_elements) {
      ui_element.updateUI();
      ui_element.displayUI();
    }

    if(selected != null) {
      selected.display(5);  // TODO: Normally we'd like to call .displayUI istead, but it can't be passed parameters.
    }
  }

}
