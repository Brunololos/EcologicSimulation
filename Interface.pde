class Interface {
  ArrayList<Screen> screens;
  int screen = 1;     //0-Programm 1-Startbildschirm 2-Optionen 3-Controls 4-Credits 5-Tile_Editor
  Programm P;
  Optionen O;

  Interface() {
    screens = new ArrayList<Screen>();
    screens.add(new Programm());
    screens.add(new Startbildschirm());
    screens.add(new Optionen());
    screens.add(new Controls());
    screens.add(new Credits());
    screens.add(new Tile_Editor());
    P = (Programm) screens.get(0);
    O = (Optionen) screens.get(2);
  }






  void show() {  //Allumfassende Darstellungsfunktion
      screens.get(screen).update();
      screens.get(screen).display();
  }

}
