class Tier_Body {
    float healthMax;    // maximum health
    float hungerMax;    // maximum hunger
    float upkeep;       // passive hunger upkeep each day

    // TODO: move into own classes
    ///////Movement///////
    int movementType;       // 0: Static, 1: Bipedal, 2: Tripedal, 3: Quadrupedal, 4: Slithering, 5: Swimming
    float turn_speed;       // turning speed in degrees
    float frontal_speed;    // forward movement speed
    float lateral_speed;    // sideward movement speed

    Tier_Torso T;

    Tier_Body() {
        T = new Tier_Torso();
        healthMax = T.calc_healthMax();
        hungerMax = T.calc_hungerMax();
        upkeep = T.calc_upkeep();

        // TODO: move to appropriate class later
        movementType = floor(random(0, 4.9));
        turn_speed = random(15.0, 30.0);
        frontal_speed = random(0.01, 1);
        lateral_speed = random(0.01, 1);
    }

    Tier_Body(Tier_Torso T_) {
        T = T_;
        healthMax = T.calc_healthMax();
        hungerMax = T.calc_hungerMax();
        upkeep = T.calc_upkeep();

        // TODO: move to appropriate class later
        movementType = floor(random(0, 4.9));
        turn_speed = random(15.0, 30.0);
        frontal_speed = random(0.01, 1);
        lateral_speed = random(0.01, 1);
    }

    public Tier_Body replicate() {
        Tier_Body B = new Tier_Body(T.replicate());
        B.movementType = (random(0, 1) >= 0.1) ? movementType : floor(random(0, 4.9));
        B.turn_speed = constrain(turn_speed + random(-0.05, 0.05), 15.0, 30.0);
        B.frontal_speed = constrain(frontal_speed + random(-0.05, 0.05), 0.01, 1);
        B.lateral_speed = constrain(lateral_speed + random(-0.05, 0.05), 0.01, 1);

        return B;
    }

    void display(PVector pos, float rot, boolean isSelected) {
        T.display(pos, rot, isSelected);
    }
}