static class Movement {
  static float[] bipedal_terrain = {0.1, 0.25, 0.75, 1.0, 0.5, 0.25, 0.15, 0.1};
  static float[] tripedal_terrain = {0.1, 0.35, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25};
  static float[] quadrupedal_terrain = {0.1, 0.2, 0.75, 1.0, 0.5, 0.15, 0.05, 0.05};

  // move like human
  // int type, PVector pos, PVector vel, int terrain
  public static void bipedal(Tier T, Welt W) {
    float mode = T.Action[0];
    float turn_amt = T.Action[1];
    float move_amt = T.Action[2];

    T.vel.x *= 0.75;
    T.vel.y *= 0.75;

    /* TURN */
    if(mode <= 0) {
      T.rot = T.rot + turn_amt*T.B.turn_speed*1.0;

      // Hungern TODO: review energy cost
      float move_energy = abs(turn_amt*(T.B.turn_speed/360.0));
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      return;

    /* WALK */
    } else {
      PVector tile = W.getTile(T.pos.x, T.pos.y);
      int terrain_type = W.Welt[int(tile.x)][int(tile.y)];

      // erstelle Bewegungsvector
      PVector move;
      if(move_amt > 0) {
        move = PVector.fromAngle(radians(T.rot)).setMag(move_amt*T.B.frontal_speed*bipedal_terrain[terrain_type-1]*0.75); //0.75 bipedal movement modifier ?
      } else {
        move = PVector.fromAngle(radians(T.rot)).setMag(move_amt*T.B.frontal_speed*bipedal_terrain[terrain_type-1]*0.25*0.75); //0.25 backward move modifier
      }

      // Veränderung der Geschwindigkeit
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed);
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);
    }

    // Veränderung der Position aufgrund von Bewegung
    T.pos.x = constrain(T.pos.x + T.vel.x, 0, W.Aw);
    T.pos.y = constrain(T.pos.y + T.vel.y, 0, W.Aw);
  }

  // move like triped
  // int type, PVector pos, PVector vel, int terrain
  public static void tripedal(Tier T, Welt W) {
    float mode0 = T.Action[0];
    float mode1 = T.Action[1];
    float turn_amt = T.Action[2];
    float move_amt = constrain(T.Action[2], 0, 1);

    T.vel.x *= 0.75;
    T.vel.y *= 0.75;

    PVector move;
    PVector tile = W.getTile(T.pos.x, T.pos.y);
    int terrain_type = W.Welt[int(tile.x)][int(tile.y)];

    /* ROTATE */
    if(mode0 <= 0 && mode1 <= 0) {
      T.rot = T.rot + turn_amt*T.B.turn_speed*0.25;

      float move_energy = abs(turn_amt*(T.B.turn_speed/360.0));
      T.hunger(0.25 + 1.0 * move_energy * move_energy);

    /* WALK RIGHT BACK */
    } else if(mode0 <= 0 && mode1 > 0) {
      // erstelle Bewegungsvector
      move = PVector.fromAngle(radians((T.rot+120)%360)).setMag(move_amt*T.B.frontal_speed*tripedal_terrain[terrain_type-1]*0.5);
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed + turn_amt*T.B.turn_speed);
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);

    /* WALK LEFT BACK */
    } else if(mode0 > 0 && mode1 <= 0) {
      // erstelle Bewegungsvector
      move = PVector.fromAngle(radians((T.rot+240)%360)).setMag(move_amt*T.B.frontal_speed*tripedal_terrain[terrain_type-1]*0.5);
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed + turn_amt*T.B.turn_speed);
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);

    /* WALK FORWARD */
    } else if(mode0 > 0 && mode1 > 0) {
      // erstelle Bewegungsvector
      move = PVector.fromAngle(radians(T.rot)).setMag(move_amt*T.B.frontal_speed*tripedal_terrain[terrain_type-1]*0.5);
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed + turn_amt*T.B.turn_speed);
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);
    }

    // Veränderung der Position aufgrund von Bewegung
    T.pos.x = constrain(T.pos.x + T.vel.x, 0, W.Aw);
    T.pos.y = constrain(T.pos.y + T.vel.y, 0, W.Aw);
  }

  // move like horse
  // int type, PVector pos, PVector vel, int terrain (like Horse)
  public static void quadrupedal(Tier T, Welt W) {
    float mode = T.Action[0];
    float turn_amt = T.Action[1];
    float move_amt = T.Action[2];

    T.vel.x *= 0.85;
    T.vel.y *= 0.85;

    PVector move;
    PVector tile = W.getTile(T.pos.x, T.pos.y);
    int terrain_type = W.Welt[int(tile.x)][int(tile.y)];

    /* WALK FORWARD */
    if(mode > 0) {
      T.rot = T.rot + turn_amt*T.B.turn_speed*0.15;
      // erstelle Bewegungsvector
      if(move_amt > 0) {
        move = PVector.fromAngle(radians((T.rot)%360)).setMag(move_amt*T.B.frontal_speed*quadrupedal_terrain[terrain_type-1]);
      } else {
        move = PVector.fromAngle(radians((T.rot)%360)).setMag(move_amt*T.B.frontal_speed*quadrupedal_terrain[terrain_type-1]*0.25);
      }
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed + turn_amt*(T.B.turn_speed/360.0));
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);

    /* WALK SIDEWARD */
    } else {
      // erstelle Bewegungsvector
      move = PVector.fromAngle(radians((T.rot+90)%360)).setMag(move_amt*T.B.frontal_speed*quadrupedal_terrain[terrain_type-1]*0.05);
      T.vel.x = move.x;
      T.vel.y = move.y;

      // Hungern TODO: review energy cost
      float move_energy = abs(move_amt*T.B.frontal_speed);
      T.hunger(0.25 + 1.0 * move_energy * move_energy);
      // T.hunger(0.2 * move_energy * move_energy + 0.5 * move_energy);
      // T.hunger(0.5 * move_energy);
    }

    // Veränderung der Position aufgrund von Bewegung
    T.pos.x = constrain(T.pos.x + T.vel.x, 0, W.Aw);
    T.pos.y = constrain(T.pos.y + T.vel.y, 0, W.Aw);
  }

}
