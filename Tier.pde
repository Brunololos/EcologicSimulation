class Tier {
  Genome G;

  ///////General///////
  String name;
  long birthday = 0;
  float health;
  float hunger;
  boolean dead = false;

  ///////Movement///////
  PVector pos;
  PVector vel;
  PVector acc;
  float rot;                        //Rechts=360/0 Oben=270 Links=180 Unten=90

  ///////Perception///////
  float[] Perception = new float[7];       //1: standOn height, 2: watchR height, 3: watchL height, 4: Health, 5: Hunger, 6: rhythm, 7: constant
  //float standOn = 1;
  float watchR = 1;
  float watchL = 1;

  ///////Behaviour///////
  float[] Hidden1;
  float[] Hidden2;
  float[] Action = new float[5];            //1: Forward-Move 2: Sideward-Move 3: Turn 4: Eat 5: Birth

  ///////Reproduction///////
  long lastBirthed = 0;

  ///////Modifiers///////
  float[] turn = {0, 1, 0.75, 0.5, 0.25};
  float[] frontal_speed = {0, 0.75, 0.375, 1, 0.25};
  float[] lateral_speed = {0, 0.125, 0.375, 0.05, 0};

  ///////Miscellaneous///////
  boolean isSelected = false;

  Tier(PVector pos_) {
    G = new Genome(Perception.length, Action.length);
    G.generate();
    name = Name_Generator.generate();
    birthday = (I != null && I.P != null) ? I.P.date : 1;
    health = G.healthMax;
    hunger = floor(G.hungerMax*0.25);
    pos = pos_;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    rot = random(0,360);
    Perception[6] = 1;
  }

  Tier(PVector pos_, Genome genome) {
    G = genome;
    name = Name_Generator.generate();
    birthday = I.P.date;
    health = G.healthMax;
    hunger = floor(G.hungerMax*0.25);
    pos = pos_;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    rot = random(0,360);
    Perception[6] = 1;
  }

  void perceive() {
    Perception[0] = (I.P.W.heightMap[constrain(floor(pos.x), 0,I.P.W.Aw-1)][constrain(floor(pos.y), 0,I.P.W.Aw-1)]-400)/425.0;
    Perception[1] = (I.P.W.heightMap[constrain(floor(pos.x+cos(radians(rot+30))*2), 0,I.P.W.Aw-1)][constrain(floor(pos.y+sin(radians(rot+30))*2), 0,I.P.W.Aw-1)]-400)/425.0;
    Perception[2] = (I.P.W.heightMap[constrain(floor(pos.x+cos(radians(rot-30))*2), 0,I.P.W.Aw-1)][constrain(floor(pos.y+sin(radians(rot-30))*2), 0,I.P.W.Aw-1)]-400)/425.0;
    Perception[3] = health/G.healthMax;
    Perception[4] = hunger/G.hungerMax;
    Perception[5] = (sin((I.P.date-birthday)*G.rhythm_factor)+1)/2;
    // Perception[6] = 1; // Constant input node doesnt need to get reset, since it doesnt change
  }

  void think() {
    float brain_activation = 0; // TODO: Figure out how to penalize large brainsss

    Hidden1 = MatrixMult.Multiply(G.InputWeights, Perception, G.numHidden1, Perception.length, 1);
    for(int i=0; i<Hidden1.length; i++) { brain_activation += abs(Hidden1[i]); Hidden1[i] = activate( Hidden1[i] /* / Perception.length */ ); }
    Hidden2 = MatrixMult.Multiply(G.Weights1, Hidden1, G.numHidden2, G.numHidden1, 1);
    for(int i=0; i<Hidden2.length; i++) { brain_activation += abs(Hidden2[i]); Hidden2[i] = activate( Hidden2[i] /* / Hidden1.length */ ); }
    Action = MatrixMult.Multiply(G.Weights2, Hidden2, Action.length, G.numHidden2, 1);
    for(int i=0; i<Action.length; i++) { Action[i] = constrain(Action[i], -1, 1); brain_activation += abs(Action[i]); }

    // Hungerkosten des Denkens
    hunger(max(0, 0.025*brain_complexity() - 0.5));
  }

  void act() {
    age();
    move();
    eat();
  }

  void age() {
    // TODO: Die of old age n' stuff
  }

  void move() {
    switch(G.movementType) {
      case 1:
        Movement.bipedal(this, I.P.W);
        break;
      case 2:
        Movement.tripedal(this, I.P.W);
        break;
      case 3:
        Movement.quadrupedal(this, I.P.W);
        break;
      default:
        break;
    }
  }

  void birth() {
    if(hunger >= floor(G.hungerMax*0.5) && Action[4] > 0 && I.P.date - lastBirthed >= 300) {  //TODO: magic number (time since last birth, birthingcost)
      float xo = random(-0.5, 0.5);
      float yo = random(-0.5, 0.5);
      I.P.T.tiere.add(new Tier(new PVector(pos.x + xo, pos.y + yo), G.replicate()));
      hunger -= floor(G.hungerMax*0.5);
      lastBirthed = I.P.date;
    }
  }

  void eat() {
    if(Action[3] <= 0) { return; }
    PVector tile = I.P.W.getTile(pos.x, pos.y);
    if(I.P.W.Welt[int(tile.x)][int(tile.y)] <= 3 || I.P.W.Welt[int(tile.x)][int(tile.y)] >= 6) { return; } //keine Nahrung im Wasser, Strand und Gebirgen
    int amt = I.P.W.remsat(int(tile.x), int(tile.y), ceil(Action[3]*5));
    hunger = min(hunger+amt, G.hungerMax);
  }

  void hunger() {   //Hungern und Vitalitätsverringerung
    hunger -= G.hungerLoss;
    if(hunger <= 0){
      health += hunger - 1;
      if(health <= 0){
        dead = true;
      }
    }
  }

  void hunger(float hungerLoss) {   //Hungern und Vitalitätsverringerung
    hunger -= hungerLoss;
    if(hunger <= 0){
      health += hunger - 1;
      if(health <= 0){
        dead = true;
      }
    }
  }

  void die(int x) {
    if(dead){
      I.P.W.getTile(pos.x, pos.y);
      I.P.T.tiere.remove(x);
      if(isSelected) {
        I.P.TI.T = null;
      }
    }
  }

  void display(){
    colorMode(RGB);
    if(debug){
      stroke(255,0,0);
      strokeWeight(0.0625*I.P.Z);
      line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot))*2*I.P.Z);
      stroke(0);
      line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot+30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot+30))*2*I.P.Z);
      line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot-30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot-30))*2*I.P.Z);

      if(isSelected) {
        strokeWeight(1);
        stroke(0);
        fill(0, 0);
        ellipse(pos.x*I.P.Z,pos.y*I.P.Z,I.P.Z*4,I.P.Z*4);
      }
    }
    noStroke();
    fill(G.c);
    ellipse(pos.x*I.P.Z,pos.y*I.P.Z,G.size*I.P.Z,G.size*I.P.Z);
  }

  // Node activation function
  float activate(float v) {
    return 1 / (1 + exp(-v));
  }

  float activateReLU(float v) {
    if(v > 0) { return min(1, v); }
    return 0;
  }

  float brain_complexity() {
    float complexity_sum = 0;
    for(int i=0; i<G.InputWeights.length; i++) { complexity_sum += abs(G.InputWeights[i]); }
    for(int i=0; i<G.Weights1.length; i++) { complexity_sum += abs(G.Weights1[i]); }
    for(int i=0; i<G.Weights2.length; i++) { complexity_sum += abs(G.Weights2[i]); }
    return complexity_sum;
  }

}
