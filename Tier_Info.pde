class Tier_Info {
  Tier T = null;
  PVector pos;
  float w = 380;
  float h = 500;

  // number of nodes in layer
  int layer1;
  int layer2;
  int layer3;
  int layer4;

  // specific layer - node spacing
  float p_sp;
  float h1_sp;
  float h2_sp;
  float a_sp;

  int node_size = 20;

  String[] actions = {"Move1", "Move2", "Move3", "Eat", "Birth"};
  String[] perceptions = {"StandOn", "WatchR", "WatchL", "Health", "Hunger", "Rhythm", "Const"};
  String[] locomotion = {"Reglos", "Zweibeinig", "Dreibeinig", "Vierbeinig", "Schlängelnd"};

  Tier_Info(float x, float y) {
    pos = new PVector(x, y);
  }

  void deselect() {
    if(T != null) { T.isSelected = false; }
    T = null;
  }

  void set_Tier(Tier T_) {
    if(T != null) { T.isSelected = false; }
    T = T_;

    layer1 = T.Perception.length;
    layer2 = T.G.numHidden1;
    layer3 = T.G.numHidden2;
    layer4 = T.Action.length;

    p_sp = 480 / layer1;
    h1_sp = 480 / layer2;
    h2_sp = 480 / layer3;
    a_sp = 480 / layer4;

    T.isSelected = true;
  }



  void display() {
    if(T != null) {
      /* Draw General */
      noStroke();
      fill(250, 150);
      rectMode(CENTER);
      rect(I.P.TLX0+pos.x, I.P.TLY0+pos.y-375, w, 200, 50, 0, 0, 50);

      // Draw Name
      fill(0);
      textSize(30);
      textAlign(CENTER, CENTER);
      text(T.name, I.P.TLX0+pos.x, I.P.TLY0+pos.y-450);

      // Draw Life
      fill(200, 100, 100);
      rect(I.P.TLX0+pos.x, I.P.TLY0+pos.y-420, w*0.75, 10);
      fill(100, 200, 100);
      rectMode(CORNER);
      rect(I.P.TLX0+pos.x-(w*3/8), I.P.TLY0+pos.y-420-5, constrain(T.health/T.B.healthMax, 0, 1)*w*0.75, 10);

      fill(0);
      textSize(10);
      textAlign(CENTER, CENTER);
      text(T.health, I.P.TLX0+pos.x, I.P.TLY0+pos.y-421);

      // Draw Hunger
      rectMode(CENTER);
      fill(200, 100, 100);
      rect(I.P.TLX0+pos.x, I.P.TLY0+pos.y-400, w*0.75, 30);
      fill(100, 100, 200);
      rectMode(CORNER);
      rect(I.P.TLX0+pos.x-(w*3/8), I.P.TLY0+pos.y-400-15, constrain(T.hunger/T.B.hungerMax, 0, 1)*w*0.75, 30);

      fill(0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(T.hunger, I.P.TLX0+pos.x, I.P.TLY0+pos.y-402);

      // Draw Movement
      fill(0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text("Bewegung: "+locomotion[T.B.movementType], I.P.TLX0+pos.x, I.P.TLY0+pos.y-372);

      // Draw Age
      fill(0);
      textSize(12);
      textAlign(CENTER, CENTER);
      long age = I.P.date - T.birthday;
      text("Alter: "+int(age/360)+" Jahre "+floor((age%360)/30+1)+" Monate "+(((age%360)%30)+1)+" Tage", I.P.TLX0+pos.x, I.P.TLY0+pos.y-292);

      /* Draw Brain */
      noStroke();
      fill(250, 150);
      rectMode(CENTER);
      rect(I.P.TLX0+pos.x, I.P.TLY0+pos.y, w, h, 50, 0, 0, 50);
      // draw perception nodes
      stroke(T.B.T.c);
      fill(T.B.T.c);
      strokeWeight(1);

      // drawing nodes in Perception-, first Hidden-layer and their connections
      for(int i=0; i<layer1; i++) {
        nodeStyle(T.Perception[i]);
        ellipse(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(layer1%2)-(layer1)/2)*p_sp, node_size, node_size);

        fill(0);
        textSize(12);
        textAlign(RIGHT, CENTER);
        text(perceptions[i], I.P.TLX0+pos.x-135-12, I.P.TLY0+pos.y+(i+0.5-0.5*(layer1%2)-(layer1)/2)*p_sp-2);

        for(int j=0; j<layer2; j++) {
          if(i==0) {
            nodeStyle(T.Hidden1[j]);
            ellipse(I.P.TLX0+pos.x-45, I.P.TLY0+pos.y+(j+0.5-0.5*(layer2%2)-(layer2)/2)*h1_sp, node_size, node_size);
          }
          weightStyle(T.Perception[i] * T.G.InputWeights[j*layer1+i]);
          line(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(layer1%2)-(layer1)/2)*p_sp,
          I.P.TLX0+pos.x-45, I.P.TLY0+pos.y+(j+0.5-0.5*(layer2%2)-(layer2)/2)*h1_sp);
        }
      }
      // drawing nodes in second Hidden-layer and their connections
      for(int j=0; j<layer2; j++) {
        for(int k=0; k<layer3; k++) {
          if(j==0) {
            nodeStyle(T.Hidden2[k]);
            ellipse(I.P.TLX0+pos.x+45, I.P.TLY0+pos.y+(k+0.5-0.5*(layer3%2)-(layer3)/2)*h2_sp, node_size, node_size);
          }
          //weightStyle(T.G.Weights[k+layer3*j]);
          weightStyle(T.Hidden1[j] * T.G.Weights1[k*layer2+j]);
          line(I.P.TLX0+pos.x-45, I.P.TLY0+pos.y+(j+0.5-0.5*(layer2%2)-(layer2)/2)*h1_sp,
          I.P.TLX0+pos.x+45, I.P.TLY0+pos.y+(k+0.5-0.5*(layer3%2)-(layer3)/2)*h2_sp);
        }
      }
      // drawing nodes in Action-layer and their connections
      for(int j=0; j<layer3; j++) {
        for(int k=0; k<layer4; k++) {
          if(j==0) {
            nodeStyle(T.Action[k]);
            ellipse(I.P.TLX0+pos.x+135, I.P.TLY0+pos.y+(k+0.5-0.5*(layer4%2)-(layer4)/2)*a_sp, node_size, node_size);

            fill(0);
            textSize(12);
            textAlign(LEFT, CENTER);
            text(actions[k], I.P.TLX0+pos.x+135+12, I.P.TLY0+pos.y+(k+0.5-0.5*(layer4%2)-(layer4)/2)*a_sp-2);
          }
          //weightStyle(T.G.Weights[k+layer3*j]);
          weightStyle(T.Hidden2[j] * T.G.Weights2[k*layer3+j]);
          line(I.P.TLX0+pos.x+45, I.P.TLY0+pos.y+(j+0.5-0.5*(layer3%2)-(layer3)/2)*h2_sp,
          I.P.TLX0+pos.x+135, I.P.TLY0+pos.y+(k+0.5-0.5*(layer4%2)-(layer4)/2)*a_sp);
        }
      }
    }
  }

  private void nodeStyle(float v) {
    noStroke();
    colorMode(HSB);
    fill(hue(T.B.T.c), saturation(T.B.T.c), v*127.5+127.5);
  }

  private void weightStyle(float w) {
    colorMode(RGB);
    strokeWeight(ceil(abs(w*3)));
    if(w>=0) {
      stroke(100, 200, 100, abs(w)*255);
    } else {
      stroke(200, 100, 100, abs(w)*255);
    }
  }

}
