class Tiere {
  ArrayList<Tier> tiere;
  int drawi; int drawj; //Variablen zur Regelung der Arrayiteration


  Tiere(int Anz, int Awdec_) {
    tiere = new ArrayList<Tier>();
    for(int i=0; i<Anz; i++) {
      //tiere.add(new Tier(random(1,200),random(1,200),new PVector(random(0,Awdec_),random(0,Awdec_)),random(0.0625,0.5)));
      tiere.add(new Tier(new PVector(random(0,Awdec_),random(0,Awdec_))));
    }
  }

  void spawn(int Anz) {
    for(int i=0; i<Anz; i++) {
      tiere.add(new Tier(new PVector(random(0,I.P.Awdec),random(0,I.P.Awdec))));
    }
  }

  void select(float x, float y) {
    for(int i=1; i<=tiere.size(); i++) {
      Tier T = tiere.get(tiere.size()-i);
      if(abs(T.pos.x*I.P.Z - (x + I.P.TLX0)) <= T.B.T.size*I.P.Z/2 && abs(T.pos.y*I.P.Z - (y + I.P.TLY0)) <= T.B.T.size*I.P.Z/2) {
        I.P.TI.set_Tier(T);
        return;
      }
    }
  }

  void update() {
    for(Tier T : tiere) {
      T.perceive();
      T.think();
      T.act();
      if(frameCount % 30 == 0) { T.heal(); T.hunger(); }
    }
  }

  void display() {
    for(Tier T : tiere) { T.display(); }
  }

  void cleanup() {
    for(int i=tiere.size()-1;i>=0; i--){
      tiere.get(i).die(i);
    }
    for(int i=tiere.size()-1;i>=0; i--){
      tiere.get(i).birth();
    }
  }
}
