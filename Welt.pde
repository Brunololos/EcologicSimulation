class Welt {
  int Aw;                  //Breite der Welt
  int[][] Welt;            //Die Welt als Liste ausgedrückt
  int[][] heightMap;       //Die Höhenniveaus der Welt
  int[][] satMap_odd;      //Das Nahrungsaufgebot verschiedener Punkte
  int[][] satMap_even;     //Das Nahrungsaufgebot verschiedener Punkte
  boolean odd_sat = false; //Which satMap is used this simulation step
  float f;                 //Wert für die Frequenz/Schrittweite der noise Funktion
  float e;                 //Wert des Exponenten
  int nL;                  //noiseLayers
  float falloff;           //Falloff of strength of the noiseLayers
  /////// BIOMES ///////
  Biomes B = new Biomes();  //Biomes of the world

  int xo = 0;              //x-offset for the world generation
  int yo = 0;              //y-offset for the world generation

  int seed;

  Welt(int Aw_, float f_, float e_, int nL_, float falloff_) {
    seed = int(random(1000));
    noiseSeed(seed);
    nL = nL_;
    falloff = falloff_;
    noiseDetail(nL,falloff);
    Aw = Aw_;

    colorMode(HSB, 255);                                              //66,131,244

    Welt = new int[Aw][Aw];
    heightMap = new int[Aw][Aw];
    satMap_odd = new int[Aw][Aw];
    satMap_even = new int[Aw][Aw];
    odd_sat = false;
    f = f_;
    e = e_;
    for(int i=0; i<Aw; i++){
      for(int j=0; j<Aw; j++){
        heightMap[i][j] = round(pow(constrain(noise((i+xo)*f, (j+yo)*f), 0, 1), e)*1000);

        if(heightMap[i][j] <= B.get(0).upperElevationBorder){                                                                 //tiefes Wasser
          Welt[i][j] = 1; int init_sat = B.get(0).calculateInitialSaturation();
          satMap_odd[i][j] = init_sat;
          satMap_even[i][j] = init_sat;
        } else {
          for(int k=1; k<B.count(); k++){
            if(heightMap[i][j] > B.get(k-1).upperElevationBorder && heightMap[i][j] <= B.get(k).upperElevationBorder) {            //Middle layers
              Welt[i][j] = k+1; int init_sat = B.get(k).calculateInitialSaturation();
              satMap_odd[i][j] = init_sat;
              satMap_even[i][j] = init_sat;
              break;
            }
          }
        }
      }
    }
  }

  void regenerate() {
    B = new Biomes();
    noiseDetail(nL,falloff);
    Welt = new int[Aw][Aw];
    heightMap = new int[Aw][Aw];
    satMap_odd = new int[Aw][Aw];
    satMap_even = new int[Aw][Aw];
    odd_sat = false;
    for(int i=0; i<Aw; i++){
      for(int j=0; j<Aw; j++){
        heightMap[i][j] = round(pow(constrain(noise((i+xo)*f, (j+yo)*f), 0, 1), e)*1000);

        if(heightMap[i][j] <= B.get(0).upperElevationBorder){                                                                 //tiefes Wasser
          Welt[i][j] = 1; int init_sat = B.get(0).calculateInitialSaturation();
          satMap_odd[i][j] = init_sat;
          satMap_even[i][j] = init_sat;
        } else {
          for(int k=1; k<B.count(); k++){
            if(heightMap[i][j] > B.get(k-1).upperElevationBorder && heightMap[i][j] <= B.get(k).upperElevationBorder) {            //Middle layers
              Welt[i][j] = k+1; int init_sat = B.get(k).calculateInitialSaturation();
              satMap_odd[i][j] = init_sat;
              satMap_even[i][j] = init_sat;
              break;
            }
          }
        }
      }
    }
    colorMode(HSB, 255);                           //66,131,244
  }

  PVector getTile(float x, float y) {
    return new PVector(constrain(floor(x), 0, Aw-1), constrain(floor(y), 0, Aw-1));
    //return new PVector(ceil(x/I.P.Z), ceil(y/I.P.Z));        //hoffentlich passt das mit der int Umwandlung
  }

  int getsat(int i, int j) {
    if (odd_sat) {
      return satMap_odd[i][j];
    } else {
      return satMap_even[i][j];
    }
  }

  int addsat(int i, int j, int amount) {
    int sat;
    if (odd_sat) {
      sat = satMap_odd[i][j];
      satMap_odd[i][j] = constrain(sat + amount,0,25);
    } else {
      sat = satMap_even[i][j];
      satMap_even[i][j] = constrain(sat + amount,0,25);
    }
    return min(B.get(Welt[i][j]-1).maxSat - sat, amount);
  }

  int remsat(int i, int j, int amount) {
    int sat;
    if (odd_sat) {
      sat = satMap_odd[i][j];
      satMap_odd[i][j] = constrain(sat - amount,0,25);
    } else {
      sat = satMap_even[i][j];
      satMap_even[i][j] = constrain(sat - amount,0,25);
    }
    return min(sat, amount);
  }

  // TODO: Use different function than shoudlGrow hack? to decide, whether to add sat to tiles
  // that are supposed or not supposed to gain it. E.g. not mountains, sand & water
  // distribute saturation to neighbors
  int sprinklesat(int i, int j, int amount) {
    int remaining = amount;
    for(int n=0; remaining > 0 && n<5; n++) {
      int neighbor = floor(random(1, 4.999));
      int k;
      switch(neighbor) {
        default:
        case 1:
          if (i-1 < 0) { break; }
          k = Welt[i-1][j];
          if(B.get(k-1).shouldGrow())  { remaining -= addsat(i-1, j, remaining); }
          break;
        case 2:
          if (j-1 < 0) { break; }
          k = Welt[i][j-1];
          if(B.get(k-1).shouldGrow())  { remaining -= addsat(i, j-1, remaining); }
          break;
        case 3:
          if (i+1 >= Aw) { break; }
          k = Welt[i+1][j];
          if(B.get(k-1).shouldGrow()) { remaining -= addsat(i+1, j, remaining); }
          break;
        case 4:
          if (j+1 >= Aw) { break; }
          k = Welt[i][j+1];
          if(B.get(k-1).shouldGrow()) { remaining -= addsat(i, j+1, remaining); }
          break;
      }
    }
    return remaining;
  }

  void update() {                                                             //vermutlich besser und performanter update nicht jedes Frame aufzurufen
    odd_sat = !odd_sat;
    for(int i=0; i<Aw; i++){
      for(int j=0; j<Aw; j++){
          for(int k=1; k<B.count()+2; k++){
            if(Welt[i][j] == k){                    //tiefes Wasser
              Biome biome = B.get(k-1);        // TODO: better not identify the biomes by order in ArrayList
              if(biome.shouldGrow()){
                int growth = biome.calculateGrowth();
                int prev_sat;
                if (odd_sat) {
                  prev_sat = satMap_odd[i][j];
                  satMap_odd[i][j] = constrain(satMap_even[i][j] + growth,0,biome.maxSat);
                } else {
                  prev_sat = satMap_even[i][j];
                  satMap_even[i][j] = constrain(satMap_odd[i][j] + growth,0,biome.maxSat);
                }
                // if (prev_sat + growth > biome.maxSat) {
                //   sprinklesat(i, j, prev_sat + growth - biome.maxSat);
                // }
                if (biome.shouldSprinkle(min(prev_sat + growth, biome.maxSat))) { sprinklesat(i, j, biome.calculateSprinkle()); }
                // sprinklesat(i, j, biome.calculateSprinkle());
              } else {
                if (odd_sat) {
                  satMap_odd[i][j] = satMap_even[i][j];
                } else {
                  satMap_even[i][j] = satMap_odd[i][j];
                }
              }
            }
          }
      }
    }
  }

  void display() {
    colorMode(HSB, 255);
    background(B.get(0).c);  // tiefes Wasser
    for(int i=floor(I.P.TLX0/I.P.Z); i<ceil((I.P.TLX0+width)/I.P.Z) && i < Aw; i++){              //verbessert Performance weil vieles garnicht erst gezeichnet werden muss
      for(int j=floor(I.P.TLY0/I.P.Z); j<ceil((I.P.TLY0+height)/I.P.Z) && j < Aw; j++){
          for(int k=1; k<B.count()+2; k++){
            if(Welt[i][j] == k+1) {
              int lightnessOffset = getsat(i, j) & 0xFF;
              int baseColor = B.get(k).c;
              fill(color(hue(baseColor), saturation(baseColor), brightness(baseColor) + lightnessOffset));
              rectangle(i, j);
              break;
            }
          }
      }
    }
  }

  void rectangle(int i, int j) {
    if(I.P.Z>1) {
      noStroke();                   //verursacht Striche... verbessert Performance
      rectMode(CORNER);             //Striche entstehen nur bei I.P.Z % 3 != 0
      rect(i*I.P.Z, j*I.P.Z, I.P.Z+0.7, I.P.Z+0.7);  //0.7 ist ein ekeliger Fix der Striche, da sie anscheinend 0.66 nicht übersteigen
    } else {
      point(i,j);
    }
  }
}
