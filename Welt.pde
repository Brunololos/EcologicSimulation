class Welt {
  int Aw;                  //Breite der Welt
  int[][] Welt;            //Die Welt als Liste ausgedrückt
  int[][] heightMap;       //Die Höhenniveaus der Welt
  int[][] satMap;          //Das Nahrungsaufgebot verschiedener Punkte
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
    satMap = new int[Aw][Aw];
    f = f_;
    e = e_;
    for(int i=0; i<Aw; i++){
      for(int j=0; j<Aw; j++){
        heightMap[i][j] = round(pow(constrain(noise((i+xo)*f, (j+yo)*f), 0, 1), e)*1000);

        if(heightMap[i][j] <= B.get(0).upperElevationBorder){                                                                 //tiefes Wasser
          Welt[i][j] = 1;
          satMap[i][j] = B.get(0).calculateInitalSaturation();
        } else {
          for(int k=1; k<B.count(); k++){
            if(heightMap[i][j] > B.get(k-1).upperElevationBorder && heightMap[i][j] <= B.get(k).upperElevationBorder) {            //Middle layers
              Welt[i][j] = k+1;
              satMap[i][j] = B.get(k).calculateInitalSaturation();
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
    satMap = new int[Aw][Aw];
    for(int i=0; i<Aw; i++){
      for(int j=0; j<Aw; j++){
        heightMap[i][j] = round(pow(constrain(noise((i+xo)*f, (j+yo)*f), 0, 1), e)*1000);

        if(heightMap[i][j] <= B.get(0).upperElevationBorder){                                                                 //tiefes Wasser
          Welt[i][j] = 1;
          satMap[i][j] = B.get(0).calculateInitalSaturation();
        } else {
          for(int k=1; k<B.count(); k++){
            if(heightMap[i][j] > B.get(k-1).upperElevationBorder && heightMap[i][j] <= B.get(k).upperElevationBorder) {            //Middle layers
              Welt[i][j] = k+1;
              satMap[i][j] = B.get(k).calculateInitalSaturation();
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
    return satMap[i][j];
  }

  int remsat(int i, int j, int amount) {
    int sat = satMap[i][j];
    satMap[i][j] = constrain(sat - amount,0,25);
    return min(sat, amount);
  }

  void update() {                                                             //vermutlich besser und performanter update nicht jedes Frame aufzurufen
    for(int i=0; i<Aw; i++){
        for(int j=0; j<Aw; j++){
          for(int k=1; k<B.count()+2; k++){
            if(Welt[i][j] == k){                    //tiefes Wasser
              Biome biome = B.get(k-1);        // TODO: better not identify the biomes by order in ArrayList
              if(biome.shouldGrow()){
                satMap[i][j] = constrain(satMap[i][j] + biome.calculateGrowth(),0,biome.maxSat);
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
              int lightnessOffset = satMap[i][j] & 0xFF;
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
