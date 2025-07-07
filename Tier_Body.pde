class Tier_Body {
    IntDict num_organs; // number of each organ type
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
        num_organs = T.enumerate_organs();
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
        num_organs = T.enumerate_organs();
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

    // public String[] get_perceptions() {
    //     String[] perceptions = {"StandOn", "WatchR", "WatchL", "Health", "Hunger", "Heartbeat", "Const"};
    //     // TODO: call recursively on torso
    //     // Eyes (Watch)
    //             // Ears (Hear, Height/Pressure?)
    //             // Nose (Sniff)
    //     // ! Body & Skin (Health, Velocity)
    //             // Limbs (Position Proprioception)
    //             // Heart (Heartbeat)
    //             // Stomach (Hunger, Metabolism, what can be eaten)
    //             // Legs (Standon?)
    //     return perceptions;
    // }

    // public String[] get_actions() {
    //     String[] actions = {"Move1", "Move2", "Move3", "Eat", "Birth"};
    //     // TODO: call recursively on torso
    //     // Mouths (Eat[From ground, carcasses], food efficiency?)
    //     // Legs (Frontal/Lateral/Turn Move)
    //             // Wings
    //     // Womb (Birth)
    //     // Horn, Spikes, Claws (Attack)
    //     // Boneplate (Protection)
    //     return actions;
    // }
    // Add brain as organ (only brained animals can think) [Maybe, maybe not]
    // Add delay to perceptions scaling with the tree distance of the organs from the brain

    // Each organ needs idx to interact with (Maybe leave key and let it look up when needed)
    // Organs are not ordered in the tree (They need to be ordered in the idx list)
    // Idcs need to be accessible by organ name keys
    // public void build_perceptions(Tier_Cognition C) {
    //     C.perception_to_idx.set("Const", -1);

    //     // TODO: remove placeholder later with recursion
    //     C.perception_to_idx.set("Heartbeat", -1);
    //     C.perception_to_idx.set("Hunger", -1);
    //     C.perception_to_idx.set("Health", -1);
    //     C.perception_to_idx.set("WatchL", -1);
    //     C.perception_to_idx.set("WatchR", -1);
    //     C.perception_to_idx.set("StandOn", -1);
    //     C.build_perception_idcs();
    // }

    // public void build_actions(Tier_Cognition C) {

    //     // TODO: remove placeholder later with recursion
    //     C.action_to_idx.set("Eat", -1);
    //     C.action_to_idx.set("Move1", -1);
    //     C.action_to_idx.set("Move2", -1);
    //     C.action_to_idx.set("Birth", -1);
    //     C.action_to_idx.set("Move3", -1);
    //     C.build_action_idcs();
    // }

    void display(PVector pos, float rot, boolean isSelected) {
        T.display(pos, rot, isSelected);
    }
}
