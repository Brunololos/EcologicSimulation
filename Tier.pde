class Tier {
  Genome G;
  Tier_Body B;
  Tier_Cognition C;

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
  // float[] Perception = new float[7];       //1: standOn height, 2: watchR height, 3: watchL height, 4: Health, 5: Hunger, 6: rhythm, 7: constant
  // float standOn = 1;
  // float watchR = 1;
  // float watchL = 1;

  ///////Behaviour///////
  // float[] Hidden1;
  // float[] Hidden2;
  // float[] Action = new float[5];            //1: Forward-Move 2: Sideward-Move 3: Turn 4: Eat 5: Birth

  ///////Reproduction///////
  long lastBirthed = 0;

  ///////Modifiers///////
  // float[] turn = {0, 1, 0.75, 0.5, 0.25};
  // float[] frontal_speed = {0, 0.75, 0.375, 1, 0.25};
  // float[] lateral_speed = {0, 0.125, 0.375, 0.05, 0};

  ///////Miscellaneous///////
  boolean isSelected = false;

  Tier(PVector pos_) {
    G = new Genome();
    B = new Tier_Body();
    C = new Tier_Cognition(B);
    name = Name_Generator.generate();
    birthday = (I != null && I.P != null) ? I.P.date : 1;
    health = B.healthMax;
    hunger = floor(B.hungerMax*0.25);
    pos = pos_;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    rot = random(0, 360);
    if (C.hasp("Const")) { C.Perception[C.pidx("Const")] = 1; }
  }

  Tier(PVector pos_, Genome genome, Tier_Body body, Tier_Cognition cognition) {
    G = genome;
    B = body;
    C = cognition;
    name = Name_Generator.generate();
    birthday = I.P.date;
    health = B.healthMax;
    hunger = floor(B.hungerMax*0.25);
    pos = pos_;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    rot = random(0,360);
    if (C.hasp("Const")) { C.Perception[C.pidx("Const")] = 1; }
  }

  void perceive() {
    // TODO: replace with recursive call to Tier_Body
    if (C.hasp("StandOn")) { C.Perception[C.pidx("StandOn")] = (I.P.W.heightMap[constrain(floor(pos.x), 0,I.P.W.Aw-1)][constrain(floor(pos.y), 0,I.P.W.Aw-1)]-400)/425.0; }
    if (C.hasp("Watch0")) { C.Perception[C.pidx("Watch0")] = (I.P.W.heightMap[constrain(floor(pos.x+cos(radians(rot+30))*2), 0,I.P.W.Aw-1)][constrain(floor(pos.y+sin(radians(rot+30))*2), 0,I.P.W.Aw-1)]-400)/425.0; }
    if (C.hasp("Watch1")) { C.Perception[C.pidx("Watch1")] = (I.P.W.heightMap[constrain(floor(pos.x+cos(radians(rot-30))*2), 0,I.P.W.Aw-1)][constrain(floor(pos.y+sin(radians(rot-30))*2), 0,I.P.W.Aw-1)]-400)/425.0; }
    if (C.hasp("Health")) { C.Perception[C.pidx("Health")] = health/B.healthMax; }
    if (C.hasp("Hunger")) { C.Perception[C.pidx("Hunger")] = hunger/B.hungerMax; }
    if (C.hasp("Heartbeat0")) { C.Perception[C.pidx("Heartbeat0")] = (sin((I.P.date-birthday)*G.rhythm_factor)+1)/2; }
    // C.Perception[6] = 1; // Constant input node doesnt need to get reset, since it doesnt change
  }

  void think() {
    float brain_activation = 0; // TODO: Figure out how to penalize large brainsss

    if (C.num_hidden_layers == 0)
    {
      C.Action = MatrixMult.Multiply(C.weights.get(0), C.Perception, C.num_actions, C.num_perceptions, 1);
      for(int i=0; i<C.num_actions; i++) { brain_activation += abs(C.Action[i]); C.Action[i] = activate(C.Action[i]); }
    }
    else
    {
      float[] Hidden0 = C.Hidden.get(0);
      Hidden0 = MatrixMult.Multiply(C.weights.get(0), C.Perception, C.hidden_layer_dims[0], C.num_perceptions, 1);
      for(int i=0; i<C.hidden_layer_dims[0]; i++) { brain_activation += abs(Hidden0[i]); Hidden0[i] = activate(Hidden0[i]); }
      C.Hidden.set(0, Hidden0);
      for (int layer=0; layer<C.num_hidden_layers-1; layer++)
      {
        float[] Hiddeni = C.Hidden.get(layer);
        float[] Hiddenii = C.Hidden.get(layer+1);
        Hiddenii = MatrixMult.Multiply(C.weights.get(layer+1), Hiddeni, C.hidden_layer_dims[layer+1], C.hidden_layer_dims[layer], 1);
        for(int i=0; i<C.hidden_layer_dims[layer+1]; i++) { brain_activation += abs(Hiddenii[i]); Hiddenii[i] = activate(Hiddenii[i]); }
        C.Hidden.set(layer+1, Hiddenii);
      }
      float[] Hiddenn = C.Hidden.get(C.num_hidden_layers-1);
      C.Action = MatrixMult.Multiply(C.weights.get(C.weights.size()-1), Hiddenn, C.num_actions, C.hidden_layer_dims[C.num_hidden_layers-1], 1);
      for(int i=0; i<C.Action.length; i++) { brain_activation += abs(C.Action[i]); C.Action[i] = activate(C.Action[i]); }
    }

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
    switch(B.movementType) {
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
    if(hunger >= floor(B.hungerMax*0.5) && C.geta("Birth0") > 0 && I.P.date - lastBirthed >= 300) {  //TODO: magic number (time since last birth, birthingcost)
      float xo = random(-0.5, 0.5);
      float yo = random(-0.5, 0.5);

      Genome Go = G.replicate();
      Tier_Body Bo = B.replicate();
      Tier_Cognition Co = C.replicate_for(Bo);

      I.P.T.tiere.add(new Tier(new PVector(pos.x + xo, pos.y + yo), Go, Bo, Co));
      hunger -= floor(B.hungerMax*0.5);
      lastBirthed = I.P.date;
    }
  }

  void eat() {
    if(C.geta("Eat0") <= 0) { return; }
    PVector tile = I.P.W.getTile(pos.x, pos.y);
    if(I.P.W.Welt[int(tile.x)][int(tile.y)] <= 3 || I.P.W.Welt[int(tile.x)][int(tile.y)] >= 6) { hunger = max(hunger - 0.25, 0); return; } //keine Nahrung im Wasser, Strand und Gebirgen //TODO: later change small penalty for trying to eat, when not possible
    int amt = I.P.W.remsat(int(tile.x), int(tile.y), ceil(C.geta("Eat0")*5));
    hunger = min(hunger+amt, B.hungerMax);
  }

  void heal() {   //Vitalitätsregeneration
    if(hunger == B.hungerMax) {
      health += 1.0;
    }
  }

  void hunger() {   //Hungern und Vitalitätsverringerung
    hunger -= B.upkeep;
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

  void display() {
    B.display(pos, rot, isSelected);
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
    for (int i=0; i<C.weights.size(); i++) {
      float[] weight_layer = C.weights.get(i);
      for (int j=0; j<weight_layer.length; j++) {
        complexity_sum += abs(weight_layer[j]);
      }
    }
    return complexity_sum;
  }

}
