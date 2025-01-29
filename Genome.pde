class Genome {

  ///////General///////
  // color c;                        //color of creature
  // int bodyType = 0;               // 0: Sphere
  // float size;                     //width of creature

  ///////Life///////
  // float healthMax;
  // float hungerMax;
  // float hungerLoss = 1;            //how much to hunger by each frame

  ///////Movement///////
  // int movementType;  // 0: Static, 1: Bipedal, 2: Tripedal, 3: Quadrupedal, 4: Slithering, 5: Swimming
  // float turn_speed;                //turning speed
  // float frontal_speed;             //forward movement speed
  // float lateral_speed;             //sideward movement speed

  ///////Cognition///////
  float[] InputWeights;
  float[] Weights1;
  float[] Weights2;
  int numPerceptions;
  int numHidden1;                  //number of nodes in first hidden layer
  int numHidden2;                  //number of nodes in the second hidden layer
  int numActions;

  float rhythm_factor;

  Genome(int numPerceptions_, int numActions_) {
    numPerceptions = numPerceptions_;
    numActions = numActions_;
    generate();
  }

  public void generate() {
    ///////General///////
    // c = color(random(0, 255), random(0, 255), random(0, 255));
    // size = random(0.25, 0.75);

    ///////Life///////
    // healthMax = floor(random(10, 100));
    // hungerMax = floor(random(20, 100));
    // hungerLoss = floor(random(1, 5));    //how much to hunger by each frame

    ///////Movement///////
    // movementType = floor(random(0, 4.9));
    // turn_speed = random(15.0, 30.0/* 0.01, 1 */);       //turning speed
    // frontal_speed = random(0.01, 1);    //forward movement speed
    // lateral_speed = random(0.01, 1);    //sideward movement speed

    ///////Cognition///////
    numHidden1 = ceil(random(2, 5));
    numHidden2 = ceil(random(2, 5));
    InputWeights = new float[numPerceptions*numHidden1];
    Weights1 = new float[numHidden1*numHidden2];
    Weights2 = new float[numHidden2*numActions];
    for(int i=0; i<InputWeights.length; i++) { InputWeights[i] = float(int(random(-1,1)*100))/100; }
    for(int i=0; i<Weights1.length; i++) { Weights1[i] = float(int(random(-1,1)*100))/100; }                //number of nodes in the first hidden layer
    for(int i=0; i<Weights2.length; i++) { Weights2[i] = float(int(random(-1,1)*100))/100; }                //number of nodes in the second hidden layer

    rhythm_factor = random(0.05, 1);
  }

  public Genome replicate() {
    Genome G = new Genome(numPerceptions, numActions);

    ///////General///////
    // G.c = color(red(c) + random(-10, 10), green(c) + random(-10, 10), blue(c) + random(-10, 10));
    // G.size = constrain(size + random(-0.05, 0.05), 0.25, 0.75);

    ///////Life///////
    // G.healthMax = constrain(healthMax + random(-5, 5), 10, 100);
    // G.hungerMax = constrain(hungerMax + random(-5, 5), 10, 100);
    // G.hungerLoss = constrain(hungerLoss + random(-0.05, 0.05), 1, 5);    //how much to hunger by each frame

    ///////Movement///////
    // G.movementType = (random(0, 1) >= 0.1) ? movementType : floor(random(0, 4.9));
    // G.turn_speed = constrain(turn_speed + random(-0.05, 0.05), 15.0, 30.0/* 0.25, 1.5 */);        //turning speed
    // G.frontal_speed = constrain(frontal_speed + random(-0.05, 0.05), 0.01, 1);    //forward movement speed
    // G.lateral_speed = constrain(lateral_speed + random(-0.05, 0.05), 0.01, 1);    //sideward movement speed

    ///////Cognition///////
    G.numHidden1 = constrain(numHidden1 + int(random(-2,2)), 1, 10);
    G.numHidden2 = constrain(numHidden2 + int(random(-2,2)), 1, 10);
    G.InputWeights = new float[G.numPerceptions*G.numHidden1];
    G.Weights1 = new float[G.numHidden1*G.numHidden2];
    G.Weights2 = new float[G.numHidden2*G.numActions];
    for(int i=0; i<G.InputWeights.length; i++) { G.InputWeights[i] = constrain(InputWeights[i%InputWeights.length] + float(int(random(-0.1,0.1)*100))/100, -1, 1); }
    for(int i=0; i<G.Weights1.length; i++) { G.Weights1[i] = constrain(Weights1[i%Weights1.length] + float(int(random(-0.1,0.1)*100))/100, -1, 1); }
    for(int i=0; i<G.Weights2.length; i++) { G.Weights2[i] = constrain(Weights2[i%Weights2.length] + float(int(random(-0.1,0.1)*100))/100, -1, 1); }

    G.rhythm_factor = constrain(rhythm_factor + random(-0.05, 0.05), 0.05, 1);

    return G;
  }
}
