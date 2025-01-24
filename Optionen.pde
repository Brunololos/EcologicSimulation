class Optionen extends Screen {
  Composite c;
  WeltVorschau WV;

  Optionen() {
    super();

    // Zurück Button
    ui_elements.add(new Simple_Button("Zurück",50,15,100,30,0,0,50,0) {
      @ Override public void function() {
        I.screen = 1;
      }
    });

    // Generieren Button
    ui_elements.add(new Simple_Button("Generieren",450,1000,300,50) {
      @ Override public void function() {
        I.P.date = 0;
        I.P.W.xo = WV.xo*WV.k;
        I.P.W.yo = WV.yo*WV.k;
        I.P.W.regenerate();
        I.P.T = new Tiere(I.P.W.Aw * I.P.W.Aw / 40, I.P.W.Aw);
        I.P.Z = ceil(float(width)/float(I.P.W.Aw));
        I.P.TLX = width/2;
        I.P.TLY = height/2;
        I.P.TLX0 = 0;
        I.P.TLY0 = 0;
        I.screen = 0;
      }
    });

    // Neuer Seed Button
    ui_elements.add(new Simple_Button("Neuer Seed",450,940,200,45) {
      @ Override public void function() {
        I.P.W.seed = int(random(0,1000));
        noiseSeed(I.P.W.seed);        //sorgt für unterschiedlichen Seed vor jedem generieren
        WV.regenerate();                  //aktualisieren der Vorschauanzeige
      }
    });

    // Feld-Editor Button
   ui_elements.add(new Simple_Button("Feld-Editor",450,500,200,40) {
      @ Override public void function() {
        I.screen = 5;
      }
    });

    // Falloff Slider
    c = new Composite(300, 440);
    c.add( new Standard_Slider(150,0, 300.0,10, 0.25,0.65,0.5, false) {
      @ Override public void function() {
        if(WV.falloff != CurVal) {
          I.P.W.falloff = CurVal;
          WV.falloff = CurVal;
          WV.regenerate();
        }
      }
    });
    ((Standard_Slider) c.get(0)).setdc(2);
    c.add(new Simple_Textbox("Falloff", -150, 0, 200, 30));
    ui_elements.add(c);

    // Noiseebenen Slider
    c = new Composite(300, 380);
    c.add( new Standard_Slider(150,0, 300.0,10, 1.0,15.0,6.0, false ) {
      @ Override public void function() {
        if(WV.nL != CurVal) {
          I.P.W.nL = int(CurVal);
          WV.nL = int(CurVal);
          WV.regenerate();
        }
      }
    });
    c.add(new Simple_Textbox("Noiseebenen", -150, 0, 200, 30));
    ui_elements.add(c);

    // Exponent Slider
    c = new Composite(300, 320);
    c.add( new Standard_Slider(150,0, 300.0,10, 1.00,2.0,1.25, false ) {
      @ Override public void function() {
        if(WV.e != CurVal) {
          I.P.W.e = CurVal;
          WV.e = CurVal;
          WV.regenerate();
        }
      }
    });
    ((Standard_Slider) c.get(0)).setdc(2);
    c.add(new Simple_Textbox("Exponent", -150, 0, 200, 30));
    ui_elements.add(c);

    // Schrittweite Slider
    c = new Composite(300, 260);
    c.add( new Standard_Slider(150,0, 300.0,10, 0.001,0.1,0.015, false ) {
      @ Override public void function() {
        if(WV.f != CurVal) {
          I.P.W.f = CurVal;
          WV.f = CurVal;
          WV.regenerate();
        }
      }
    });
    ((Standard_Slider) c.get(0)).setdc(3);
    c.add(new Simple_Textbox("Schrittweite", -150, 0, 200, 30));
    ui_elements.add(c);

    // Weltbreite Slider
    c = new Composite(300, 200);
    c.add( new Standard_Slider(150,0, 300.0,10, 50.0,1000.0,200.0, false ) {
      @ Override public void function() {
        if(WV.Aw != CurVal) {                              //Optimierung - nur Zuweisung von Werten und generieren neuer Welt bei unterschiedlichen Wert
          I.P.W.Aw = int(CurVal);
          WV.Aw = int(CurVal);
          WV.regenerate();
        }
      }
    });
    c.add(new Simple_Textbox("Weltbreite", -150, 0, 200, 30));
    ui_elements.add(c);

    WV = new WeltVorschau(450, 750, 200, 200, 0.015, 1.25, 10);
    ui_elements.add(WV);
  }


  void update() {

  }

  void display() {
    background(115,175,100);
    fill(255);
    textSize(50);
    text("Welt",450,70);
    text("Tiere",width-450,70);

    for(UI_Element ui_element : ui_elements) {
      ui_element.updateUI();
      ui_element.displayUI();
    }
  }



}
