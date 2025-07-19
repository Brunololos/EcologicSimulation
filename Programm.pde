class Programm extends Screen {
  Welt W;
  Tiere T;
  float TLX;                        //X-Koordinate des Bildschirmmittelpunkts
  float TLY;                        //Y-Koordinate des Bildschirmmittelpunkts
  float TLX0;                       //X-Koordinate der oberen rechten Bildschirmecke
  float TLY0;                       //Y-Koordinate der oberen rechten Bildschirmecke
  float Z;                          //Zoomwert

  ///////WELTGENERATION///////
  int Awdec = 200;
  float fdec = 0.015;
  float edec = 1.25;
  int nLdec = 6;
  float falloffdec = 0.5;

  ///////Miscellaneous///////
  long date = 0;
  /*int enter_frameCount = -1;
  int leave_frameCount = -1;*/
  Tier_Info TI;

  Programm() {
    super();

    W = new Welt(Awdec, fdec, edec, nLdec, falloffdec);
    T = new Tiere(Awdec * Awdec / 5, Awdec);
    TI = new Tier_Info(width-190, 750);   //Old width-190, 500
    Z = ceil(float(width)/float(W.Aw));        //Zoomwert     //Grösse der Darstellung
    TLX = width/2;                            //Werte der Verschiebung         //Geben Bildschirmmitte an
    TLY = height/2;
    TLX0 = 0;
    TLY0 = 0;


    ArrayList<UI_Element> temp = new ArrayList<UI_Element>();
    //Zurück Button
    temp.add(new Simple_Button("Zurück",50,15,100,30,0,0,50,0) {
      @ Override public void function() {
        I.screen = 1;
      }
    });
    ui_elements.add(new Composite(0, 0, temp) {
      @ Override public void updateFeed() {
        setX(TLX0);
        setY(TLY0);
        setscreenXshift(TLX0);
        setscreenYshift(TLY0);
      }
    });
  }

  void update() {
    translate((-TLX)+width/2,(-TLY)+height/2);      //Bewegung der Kamera um einen Absolutwert
    if(!pause) {
      date++;
      W.update();
    }

  }

  void display() {

    // TODO: this decoupling of render, pause could be done cleaner
    int tiere_displayed = 0;
    if(render) { W.display(); }
    if(!pause) { T.update(); }
    if(render) { tiere_displayed += T.display(); }
    if(!pause) { T.cleanup(); }

    stroke(0);
    strokeWeight(1);
    line(TLX-10,TLY,TLX+10,TLY);      //Fadenkreuz
    line(TLX,TLY-10,TLX,TLY+10);

    for(UI_Element ui_element : ui_elements) {
      ui_element.updateUI();
      ui_element.displayUI();
    }

    if(debug) {
      noStroke();
      fill(250, 150);
      rectMode(CENTER);
      rect(TLX+width/2-190, TLY-height/2+90, 380, 180, 0, 0, 0, 50);
      fill(0);
      textSize(32);
      textAlign(CENTER, CENTER);
      text("Datum:", TLX+width/2-260, TLY-height/2+20);
      text("Population:", TLX+width/2-260, TLY-height/2+20+40);
      text("Seed:", TLX+width/2-260, TLY-height/2+20+80);
      text("FPS:", TLX+width/2-260, TLY-height/2+20+120);

      textAlign(RIGHT, CENTER);
      text((((date%360)%30)+1)+"."+floor((date%360)/30+1)+"."+int(date/360), TLX+width/2-20, TLY-height/2+20);   // Jahre haben der Einfachheit halber 360 Tage
      text(I.P.T.tiere.size(), TLX+width/2-20, TLY-height/2+20+40);
      text(I.P.W.seed, TLX+width/2-20, TLY-height/2+20+80);
      text("~"+int(frameRate), TLX+width/2-20, TLY-height/2+20+120);

      TI.display();
    }
    if(pause) {
      fill(0);
      textSize(32);
      textAlign(CENTER, CENTER);
      text("~pausiert~", TLX, TLY+height/2-40);
    }
    // TODO:
    int x_rend_tiles = min(ceil((I.P.TLX0+width)/I.P.Z), I.P.W.Aw) - floor(I.P.TLX0/I.P.Z);
    int y_rend_tiles = min(ceil((I.P.TLY0+height)/I.P.Z), I.P.W.Aw) - floor(I.P.TLY0/I.P.Z);

    // TODO: remove/refactor later
    if(!pause && do_logging && frameCount % 25 == 0) { logData(data_logger, frameRate, I.P.T.tiere.size(), I.P.W.Aw * I.P.W.Aw, tiere_displayed, x_rend_tiles * y_rend_tiles); }
  }



}
