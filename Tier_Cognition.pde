class Tier_Cognition {
  IntDict perception_to_idx;
  IntDict action_to_idx;
  String[] perceptions;
  String[] actions;
  ArrayList<float[]> weights;

  int num_perceptions;
  int[] hidden_layer_dims;
  int num_actions;
  int num_hidden_layers;

  // Active values
  float[] Perception;
  ArrayList<float[]> Hidden = new ArrayList<float[]>();
  float[] Action;

  Tier_Cognition(Tier_Body B) {
    // perceptions = B.get_perceptions();
    // actions = B.get_actions();
    perception_to_idx = build_perception_to_idx_mapping(B);
    action_to_idx = build_action_to_idx_mapping(B);
    // TODO: this needs to be sorted according to the indices, but isn't
    perceptions = perception_to_idx.keyArray();
    actions = action_to_idx.keyArray();
    generate();
  }

  public void generate() {
    num_perceptions = perceptions.length;
    num_actions = actions.length;
    Perception = new float[num_perceptions];
    Action = new float[num_actions];

    // generate weight arrays
    weights = new ArrayList<float[]>();
    num_hidden_layers = int(random(0, 3));
    hidden_layer_dims = new int[num_hidden_layers];

    if (num_hidden_layers == 0)
    {
      // input -> output weights
      weights.add(new float[perceptions.length * actions.length]);
    } else {
      int previous_layer_width;
      int random_layer_width = int(random(1, 5));

      // input -> first hidden layer weights
      weights.add(new float[perceptions.length * random_layer_width]);
      Hidden.add(new float[random_layer_width]);
      hidden_layer_dims[0] = random_layer_width;
      for (int i=0; i<num_hidden_layers-1; i++)
      {
        // hidden layer -> next hidden layer weights
        previous_layer_width = random_layer_width;
        random_layer_width = int(random(1, 5));
        weights.add(new float[previous_layer_width * random_layer_width]);
        Hidden.add(new float[random_layer_width]);
        hidden_layer_dims[i+1] = random_layer_width;
      }
      // last hidden layer -> output weights
      // weights.add(new float[weights.get(weights.size()-1).length * actions.length]);
      weights.add(new float[random_layer_width * actions.length]);
    }

    // initialize weights
    for (int i=0; i<weights.size(); i++)
    {
      float[] hidden_weights = weights.get(i);
      for (int j=0; j<hidden_weights.length; j++)
      {
        hidden_weights[j] = float(int(random(-1,1)*100))/100;
      }
      weights.set(i, hidden_weights);
    }
  }

  public Tier_Cognition replicate_for(Tier_Body B) {
    Tier_Cognition C = new Tier_Cognition(B);

    C.num_hidden_layers = constrain(num_hidden_layers + int(random(-1, 1)), 0, 5);
    C.hidden_layer_dims = new int[C.num_hidden_layers];
    C.weights.clear();
    C.Hidden.clear();

    // inherit perceptions x actions
    if (C.num_hidden_layers == 0)
    {
      // input -> output weights
      C.weights.add(new float[C.num_perceptions * C.num_actions]);

    // inherit hidden dimensionality
    } else {

      int previous_layer_width;
      C.hidden_layer_dims[0] = ceil(random(2, 5));
      if (num_hidden_layers > 0) {
        C.hidden_layer_dims[0] = constrain(hidden_layer_dims[0] + int(random(-2,2)), 1, 10);
      }
      C.weights.add(new float[C.num_perceptions * C.hidden_layer_dims[0]]);
      C.Hidden.add(new float[C.hidden_layer_dims[0]]);
      previous_layer_width = C.hidden_layer_dims[0];

      // hidden layer -> next hidden layer weights
      for (int layer=1; layer<C.num_hidden_layers; layer++)
      {
        C.hidden_layer_dims[layer] = ceil(random(2, 5));
        if (layer < num_hidden_layers) {
          C.hidden_layer_dims[layer] = constrain(hidden_layer_dims[layer] + int(random(-2,2)), 1, 10);
        }
        C.Hidden.add(new float[C.hidden_layer_dims[layer]]);
        C.weights.add(new float[previous_layer_width * C.hidden_layer_dims[layer]]);
        previous_layer_width = C.hidden_layer_dims[layer];
      }

      // last hidden layer -> output weights
      C.weights.add(new float[previous_layer_width * C.actions.length]);
    }

    // inherit weights
    if (C.num_hidden_layers == 0)
    {
      for (int i=0; i<C.num_actions; i++)
      {
        for (int j=0; j<C.num_perceptions; j++)
        {
          String perc = C.perceptions[j];
          String act = C.actions[i];
          if (hasp(perc) && hasa(act))
          {
            float weight = weights.get(0)[aidx(act)*num_perceptions + pidx(perc)];
            C.weights.get(0)[i*C.num_perceptions + j] = constrain(weight + float(int(random(-0.1, 0.1)*100))/100, -1, 1);
          } else {
            C.weights.get(0)[i*C.num_perceptions + j] = float(int(random(-1,1)*100))/100;
          }
        }
      }
    } else {
      for (int i=0; i<C.hidden_layer_dims[0]; i++)
      {
        for (int j=0; j<C.num_perceptions; j++)
        {
          String perc = C.perceptions[j];
          if (hasp(perc) && num_hidden_layers >= 1 && i < hidden_layer_dims[0])
          {
            float weight = weights.get(0)[i*num_perceptions + pidx(perc)];
            C.weights.get(0)[i*C.num_perceptions + j] = constrain(weight + float(int(random(-0.1, 0.1)*100))/100, -1, 1);
          } else {
            C.weights.get(0)[i*C.num_perceptions + j] = float(int(random(-1,1)*100))/100;
          }
        }
      }
      // TODO: hidden layers
      if (C.num_hidden_layers > 1)
      {
        for (int layer=2; layer<C.num_hidden_layers+1; layer++)
        {
          int prev_dims = C.hidden_layer_dims[layer-2];
          int next_dims = C.hidden_layer_dims[layer-1];
          for (int i=0; i<next_dims; i++)
          {
            for (int j=0; j<prev_dims; j++)
            {
              if (num_hidden_layers >= layer && i < hidden_layer_dims[layer-1] && j < hidden_layer_dims[layer-2])
              {
                float weight = weights.get(layer-1)[i*hidden_layer_dims[layer-2] + j];
                C.weights.get(layer-1)[i*prev_dims + j] = constrain(weight + float(int(random(-0.1, 0.1)*100))/100, -1, 1);
              } else {
                C.weights.get(layer-1)[i*prev_dims + j] = float(int(random(-1,1)*100))/100;
              }
            }
          }
        }
      }
      for (int i=0; i<C.num_actions; i++)
      {
        String act = C.actions[i];
        int last = num_hidden_layers-1;
        int next_last = C.num_hidden_layers-1;
        for (int j=0; j<C.hidden_layer_dims[next_last]; j++)
        {
          if (hasa(act) && num_hidden_layers >= 1 && j < hidden_layer_dims[last])
          {
            float weight = weights.get(num_hidden_layers)[aidx(act)*hidden_layer_dims[last] + j];
            C.weights.get(C.num_hidden_layers)[i*C.hidden_layer_dims[next_last] + j] = constrain(weight + float(int(random(-0.1, 0.1)*100))/100, -1, 1);
          } else {
            C.weights.get(C.num_hidden_layers)[i*C.hidden_layer_dims[next_last] + j] = float(int(random(-1,1)*100))/100;
          }
        }
      }
    }

    return C;
  }

  public boolean hasp(String string) { return perception_to_idx.hasKey(string); }
  public boolean hasa(String string) { return action_to_idx.hasKey(string); }
  public int pidx(String string) { return perception_to_idx.get(string); }
  public int aidx(String string) { return action_to_idx.get(string); }
  public float geta(String action) { if (hasa(action)) { return Action[aidx(action)]; } else { return 0; } }

  // TODO: create mapping from perception/actions names to matrix weight coordinates
  // I want to be able to get the index from the perception/action name
  // I want to collect all perception/actions names and order them accordingly i.e. first sight-perception, then standon perception, then health perception, then heartbeat, then constant input

  IntDict build_perception_to_idx_mapping(Tier_Body B)
  {
    IntDict perception_to_idx_ = new IntDict();
    int index = 0;

    IntDict organs = B.num_organs;
    if (organs.hasKey("Eye")) {
      for (int i=0; i<organs.get("Eye"); i++) {
        perception_to_idx_.set("Watch" + str(i), index); index++;
      }
    }

    perception_to_idx_.set("StandOn", index); index++;
    perception_to_idx_.set("Health", index); index++;
    perception_to_idx_.set("Hunger", index); index++;

    if (organs.hasKey("Heart")) {
      for (int i=0; i<organs.get("Heart"); i++) {
        perception_to_idx_.set("Heartbeat" + str(i), index); index++;
      }
    }

    perception_to_idx_.set("Const", index); index++;

    return perception_to_idx_;
  }

  IntDict build_action_to_idx_mapping(Tier_Body B)
  {
    IntDict action_to_idx_ = new IntDict();
    int index = 0;

    IntDict organs = B.num_organs;
    if (organs.hasKey("Legs")) {
      for (int i=0; i<organs.get("Legs"); i++) {
        action_to_idx_.set("Leg" + str(i) + "_Move0", index); index++;
        action_to_idx_.set("Leg" + str(i) + "_Move1", index); index++;
        action_to_idx_.set("Leg" + str(i) + "_Move2", index); index++;
      }
    }

    if (organs.hasKey("Mouth")) {
      for (int i=0; i<organs.get("Mouth"); i++) {
        action_to_idx_.set("Eat" + str(i), index); index++;
      }
    }

    if (organs.hasKey("Womb")) {
      for (int i=0; i<organs.get("Womb"); i++) {
        action_to_idx_.set("Birth" + str(i), index); index++;
      }
    }

    return action_to_idx_;
  }
}