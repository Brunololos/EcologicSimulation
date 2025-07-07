class Tier_Info {
  Tier T = null;
  PVector pos;
  float w = 380;
  float h = 500;

  // number of nodes in layer
  int[] layer_nodes;

  // specific layer - node spacing
  float[] layer_sp;

  int node_size = 20;

  String[] actions;
  String[] perceptions;
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
    actions = T.C.actions;
    perceptions = T.C.perceptions;

    // get nodes
    layer_nodes = new int[T.C.num_hidden_layers+2];
    layer_nodes[0] = T.C.num_perceptions;
    for (int i=1; i<T.C.num_hidden_layers+1; i++) {
      layer_nodes[i] = T.C.hidden_layer_dims[i-1];
    }
    layer_nodes[T.C.num_hidden_layers+1] = T.C.num_actions;

    // calculate spacing
    layer_sp = new float[layer_nodes.length];
    for (int i=0; i<layer_nodes.length; i++) { layer_sp[i] = (480 / layer_nodes[i]); }

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
      // draw perception nodes & connections
      stroke(T.B.T.c);
      fill(T.B.T.c);
      strokeWeight(1);

      int nodes; int next_nodes;
      float sp; float next_sp; float h_sp;
      if (T.C.num_hidden_layers == 0)
      {
        nodes = layer_nodes[0];
        next_nodes = layer_nodes[1];
        sp = layer_sp[0];
        next_sp = layer_sp[1];
        h_sp = 270 / (T.C.num_hidden_layers+1);
        for(int i=0; i<nodes; i++) {
          nodeStyle(T.C.Perception[i]);
          ellipse(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp, node_size, node_size);

          fill(0);
          textSize(12);
          textAlign(RIGHT, CENTER);
          text(T.C.perceptions[i], I.P.TLX0+pos.x-135-12, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp-2);

          for(int j=0; j<next_nodes; j++) {
            if(i==0) {
              nodeStyle(T.C.Action[j]);
              ellipse(I.P.TLX0+pos.x-135+h_sp, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp, node_size, node_size);

              fill(0);
              textSize(12);
              textAlign(LEFT, CENTER);
              text(T.C.actions[j], I.P.TLX0+pos.x+135+12, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp-2);
            }
            if(tierinfo_display_activations){ weightStyle(T.C.Perception[i] * T.C.weights.get(0)[j*nodes+i]); }
            else { weightStyle(T.C.weights.get(0)[j*nodes+i]); }
            line(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp,
            I.P.TLX0+pos.x-135+h_sp, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp);
          }
        }
      }
      else
      {
        nodes = layer_nodes[0];
        next_nodes = layer_nodes[1];
        sp = layer_sp[0];
        next_sp = layer_sp[1];
        h_sp = 270 / (T.C.num_hidden_layers+1);
        for(int i=0; i<nodes; i++) {
          nodeStyle(T.C.Perception[i]);
          ellipse(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp, node_size, node_size);

          fill(0);
          textSize(12);
          textAlign(RIGHT, CENTER);
          text(T.C.perceptions[i], I.P.TLX0+pos.x-135-12, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp-2);

          for(int j=0; j<next_nodes; j++) {
            if(i==0) {
              nodeStyle(T.C.Hidden.get(0)[j]);
              ellipse(I.P.TLX0+pos.x-135+h_sp, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp, node_size, node_size);
            }
            if(tierinfo_display_activations){ weightStyle(T.C.Perception[i] * T.C.weights.get(0)[j*nodes+i]); }
            else { weightStyle(T.C.weights.get(0)[j*nodes+i]); }
            line(I.P.TLX0+pos.x-135, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp,
            I.P.TLX0+pos.x-135+h_sp, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp);
          }
        }

        for (int layer=2; layer<T.C.num_hidden_layers+1; layer++)
        {
          nodes = layer_nodes[layer-1];
          next_nodes = layer_nodes[layer];
          sp = layer_sp[layer-1];
          next_sp = layer_sp[layer];
          for(int j=0; j<nodes; j++) {
            for(int k=0; k<next_nodes; k++) {
              if(j==0) {
                nodeStyle(T.C.Hidden.get(layer-1)[k]);
                ellipse(I.P.TLX0+pos.x-135+layer*h_sp, I.P.TLY0+pos.y+(k+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp, node_size, node_size);
              }
              if(tierinfo_display_activations){ weightStyle(T.C.Hidden.get(layer-2)[j] * T.C.weights.get(layer-1)[k*nodes+j]); }
              else { weightStyle(T.C.weights.get(layer-1)[k*nodes+j]); }
              line(I.P.TLX0+pos.x-135+h_sp*(layer-1), I.P.TLY0+pos.y+(j+0.5-0.5*(nodes%2)-(nodes)/2)*sp,
              I.P.TLX0+pos.x-135+h_sp*layer, I.P.TLY0+pos.y+(k+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp);
            }
          }
        }

        nodes = layer_nodes[layer_nodes.length-2];
        next_nodes = layer_nodes[layer_nodes.length-1];
        sp = layer_sp[layer_nodes.length-2];
        next_sp = layer_sp[layer_nodes.length-1];
        for(int i=0; i<nodes; i++) {
          for(int j=0; j<next_nodes; j++) {
            if(i==0) {
              nodeStyle(T.C.Action[j]);
              ellipse(I.P.TLX0+pos.x+135, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp, node_size, node_size);

              fill(0);
              textSize(12);
              textAlign(LEFT, CENTER);
              text(T.C.actions[j], I.P.TLX0+pos.x+135+12, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp-2);
            }
            if(tierinfo_display_activations){ weightStyle(T.C.Hidden.get(T.C.num_hidden_layers-1)[i] * T.C.weights.get(T.C.num_hidden_layers)[j*nodes+i]); }
            else { weightStyle(T.C.weights.get(T.C.num_hidden_layers)[j*nodes+i]); }
            line(I.P.TLX0+pos.x+135-h_sp, I.P.TLY0+pos.y+(i+0.5-0.5*(nodes%2)-(nodes)/2)*sp,
            I.P.TLX0+pos.x+135, I.P.TLY0+pos.y+(j+0.5-0.5*(next_nodes%2)-(next_nodes)/2)*next_sp);
          }
        }
      }

      // MLP net edge display mode
      fill(0);
      textSize(12);
      textAlign(CENTER, CENTER);
      if (tierinfo_display_activations) {
        text("Display mode: Activations (toggle with ä)", I.P.TLX0+pos.x+12, I.P.TLY0+pos.y+h/2-20);
      } else {
        text("Display mode: Edge Weights (toggle with ä)", I.P.TLX0+pos.x+12, I.P.TLY0+pos.y+h/2-20);
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
