class WeltVorschau extends UI_Element {
  //float x;                 //middle x-position of the preview window
  //float y;                 //middle y-position of the preview window
  float w;                 //width of the preview window
  int Aw;                  //Breite der realen Welt
  int aw;                  //Breite der Vorschauwelt
  int k;                   //Komprimierungsfaktor Bsp. bei k = 10 wird nur jedes 10. Feld berechnet
  int[][] Welt;            //Die Welt als Liste ausgedrückt
  float f;                 //Wert für die Frequenz/Schrittweite der noise Funktion
  float e;                 //Wert des Exponenten
  int nL = 6;              //noiseLayers
  float falloff = 0.5;     //Falloff of strength of noiseLayers
  int[] t = {400, 450, 500, 625, 725, 765, 825};   //Werte für die Biomübergänge

  int xo = 0;              //x-offset for the world generation
  int yo = 0;              //y-offset for the world generation

  Triangle_Button MN;
  Triangle_Button MS;
  Triangle_Button MW;
  Triangle_Button ME;

  WeltVorschau(float x_, float y_, float w_, int Aw_, float f_, float e_, int k_) {
    super(x_, y_);
    w = round(w_);
    noiseDetail(nL,falloff);
    Aw = Aw_;
    k = k_;
    aw = round(Aw/k);
    Welt = new int[aw][aw];
    f = f_;
    e = e_;
    int val;
    for(int i=0; i<aw; i++){
      for(int j=0; j<aw; j++){
        val = round(pow(noise((i+xo)*k*f, (j+yo)*k*f), e)*1000);

        if(val < t[0]){                                             //tiefes Wasser
          Welt[i][j] = 1;
        } else if(val >= t[0] && val < t[1]) {            //flaches Wasser
          Welt[i][j] = 2;
        } else if(val >= t[1] && val < t[2]) {            //Strand
          Welt[i][j] = 3;
        } else if(val >= t[2] && val < t[3]) {            //Wiese
          Welt[i][j] = 4;
        } else if(val >= t[3] && val < t[4]) {            //Wald
          Welt[i][j] = 5;
        } else if(val >= t[4]) {
          if(val >= t[6]) {                                         //Schnee
            Welt[i][j] = 8;
          } else if(val >= t[5]) {                                  //Gebirge - hoch
            Welt[i][j] = 7;
          } else if(val >= t[4]) {                                  //Gebirge - tief
            Welt[i][j] = 6;
          }
        }
      }
    }

    setupOB();
  }

  void regenerate() {
    aw = round(Aw/k);
    Welt = new int[aw][aw];
    noiseDetail(nL,falloff);
    int val;
    for(int i=0; i<aw; i++){
      for(int j=0; j<aw; j++){
        val = round(pow(noise((i+xo)*k*f, (j+yo)*k*f), e)*1000);

        if(val < t[0]){                                             //tiefes Wasser
          Welt[i][j] = 1;
        } else if(val >= t[0] && val < t[1]) {            //flaches Wasser
          Welt[i][j] = 2;
        } else if(val >= t[1] && val < t[2]) {            //Strand
          Welt[i][j] = 3;
        } else if(val >= t[2] && val < t[3]) {            //Wiese
          Welt[i][j] = 4;
        } else if(val >= t[3] && val < t[4]) {            //Wald
          Welt[i][j] = 5;
        } else if(val >= t[4]) {
          if(val >= t[6]) {                                         //Schnee
            Welt[i][j] = 8;
          } else if(val >= t[5]) {                                  //Gebirge - hoch
            Welt[i][j] = 7;
          } else if(val >= t[4]) {                                  //Gebirge - tief
            Welt[i][j] = 6;
          }
        }
      }
    }
  }

  void display() {
    stroke(100);
    strokeWeight(5);
    fill(125);
    rectMode(CENTER);
    rect(x, y, w+20, w+20);
    noStroke();
    fill(154,186,244);
    rect(x, y, w, w);
    colorMode(HSB);
    rectMode(CORNER);
    for(int i=0; i < aw; i++){              //verbessert Performance weil vieles garnicht erst geI.P.Zeichnet werden muss
      for(int j=0; j < aw; j++){
          if(Welt[i][j] == 2) {                                    //flaches Wasser
            fill(154,131,255);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 3) {                                    //Strand
            fill(39,169,239);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 4) {                                    //Wiese
            fill(64,189,232);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 5) {                                    //Wald
            fill(85,193,139);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 6) {                                    //Gebirge - tief
            fill(52,15,221);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 7) {                                    //Gebirge - hoch
            fill(0,0,128);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          } else if(Welt[i][j] == 8) {                                    //Schnee
            fill(0,0,255);
            rect(x-w/2+i*w/aw, y-w/2+j*w/aw, w/aw, w/aw);
          }
      }
    }

    drawOB();
  }

  //Setup the offset Buttons
  void setupOB() {
    MN = new Triangle_Button(0, -w/2+30,        -35, 15,    0, -15,    35, 15) {
      @ Override public void function() {
        yo--;
        regenerate();
      }
    };
    MN.setXshift(x);
    MN.setYshift(y);
    MS = new Triangle_Button(0, w/2-30,        -35, -15,    0, 15,    35, -15) {
      @ Override public void function() {
        yo++;
        regenerate();
      }
    };
    MS.setXshift(x);
    MS.setYshift(y);
    MW = new Triangle_Button(-w/2+30, 0,        15, -35,    -15, 0,    15, 35) {
      @ Override public void function() {
        xo--;
        regenerate();
      }
    };
    MW.setXshift(x);
    MW.setYshift(y);
    ME = new Triangle_Button(w/2-30, 0,        -15, -35,    15, 0,    -15, 35) {
      @ Override public void function() {
        xo++;
        regenerate();
      }
    };
    ME.setXshift(x);
    ME.setYshift(y);
  }

  //Updates the offset Buttons
  void updateOB() {
    MN.update();
    MS.update();
    MW.update();
    ME.update();
  }

  //Draws the offset Buttons
  void drawOB() {
    MN.updateUI();
    MS.updateUI();
    MW.updateUI();
    ME.updateUI();
    MN.displayUI();
    MS.displayUI();
    MW.displayUI();
    ME.displayUI();
  }

  //Activated when mousePressed() is called
  void listenPressed() {
    // passing the calls down
    MN.listenPressed();
    MS.listenPressed();
    MW.listenPressed();
    ME.listenPressed();
  }

  //Activated when mouseReleased() is called
  void listenReleased() {
    // passing the calls down
    MN.listenReleased();
    MS.listenReleased();
    MW.listenReleased();
    ME.listenReleased();
  }
}
