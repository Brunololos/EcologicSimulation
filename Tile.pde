class Tile extends UI_Element {
  boolean empty = false;  // is this tile an empty Tile ?

  /* Tile Settings */
  color c;              // color of tile
  float minHeight;      // upper & lower height bounds of tile "occurance"
  float maxHeight;
  Biome biome;

  /* Display Settings */
  float size = 50;      // sidelength of the rectangle

  Tile(float xpos, float ypos, color c_, float min, float max, Biome biome_) {
    super(xpos, ypos);
    c = c_;
    minHeight = min;
    maxHeight = max;
    biome = biome_;
  }

  Tile(float xpos, float ypos, color c_, float min, float max) {
    super(xpos, ypos);
    c = c_;
    minHeight = min;
    maxHeight = max;
    biome = new Biome(c_, max, 1, 25, 15);
  }

  Tile(float xpos, float ypos) {
    super(xpos, ypos);
    empty = true;
  }

  Biome toBiome() {
    if(empty)
      throw new RuntimeException("Tile is in empty mode and cannot be converted into a Biome.");
    return biome;
  }

  void setHeights(float minHeight_, float maxHeight_) {
    minHeight = minHeight_;
    maxHeight = maxHeight_;
    biome.upperElevationBorder = maxHeight_;
  }

  void onRelease() {
    activate();
  }

  void display() {
    colorMode(HSB);
    if(empty) {
      fill(150);
      if(MouseIsOver()) { fill(200); }
      noStroke();
      rectMode(CENTER);
      rect(absX(), absY(), size, size, 20);

      stroke(60);
      strokeWeight(size/8);
      line(absX()-size/3, absY(),        absX()+size/3, absY());
      line(absX(),        absY()-size/3, absX(),        absY()+size/3);
    } else {
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(absX(), absY(), size, size, 20);
    }
  }

  void display(float s) {
    colorMode(HSB);
    if(empty) {
      fill(150);
      if(MouseIsOver()) { fill(200); }
      noStroke();
      rectMode(CENTER);
      rect(absX(), absY(), size*s, size*s, 20);

      stroke(60);
      strokeWeight(size*s/8);
      line(absX()-size*s/3, absY(),        absX()+size*s/3, absY());
      line(absX(),        absY()-size*s/3, absX(),        absY()+size*s/3);
    } else {
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(absX(), absY(), size*s, size*s, 20);
    }
  }

  boolean MouseIsOver() {                        //ermittelt ob Mauszeiger über einem Button ist
    if(mouseX + screenxshift >= (absX() - size/2) && mouseX + screenxshift <= (absX() + size/2)
    && mouseY + screenyshift >= (absY() - size/2) && mouseY + screenyshift <= (absY() + size/2)) {
      return true;
    }
    return false;
  }
}
