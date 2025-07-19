
int num_unique_body_parts = 0;

public Body_Part generate_Body_Part() {
    return new Heart();
}
// static class Body_Inventory {
// 
// }

// Body_Part types: Eye, Heart
abstract class Body_Part {
    String type;
    int type_id;

    Body_Part(String type_) {
        type = type_;
    }

    /* Override */
    // Body_Part replicate() {

    // }

    IntDict enumerate(IntDict organs) {
        type_id = organs.get(type);
        organs.add(type, 1);
        // TODO: Call recursively for emplaced Body_Parts
        return organs;
    }

    /* Override */
    float calc_healthMax() {
        return 0;
    }

    /* Override */
    float calc_hungerMax() {
        return 0;
    }

    /* Override */
    float calc_upkeep() {
        return 0;
    }
    /* Override */
    void display() {};
}

// Eyes (Watch)
        // Ears (Hear, Height/Pressure?)
        // Nose (Sniff)
// ! Body & Skin (Health, Velocity)
        // Limbs (Position Proprioception)
        // Heart (Heartbeat)
        // Stomach (Hunger, Metabolism, what can be eaten)
        // Legs (Standon?)

// Mouths (Eat[From ground, carcasses], food efficiency?)
// Legs (Frontal/Lateral/Turn Move)
        // Wings
// Womb (Birth)
// Horn, Spikes, Claws (Attack)
// Boneplate (Protection)

// Body_Part properties:
        // Max Health
        // Max Energy
        // Energy upkeep
        // Weights
        // Carry capacity (for emplaced body parts)

        // Input delay (for perceptions depending on distance to brain? if it is modeled as a bodypart)
        // relative position on body & orientation for e.g. limbs or turning eyes

        // + additional variables like Heartbeat frequency for heart
        // + Near/Far vison for eyes & maximum view angle (lefts/right)?

// Question: Do I want different food types to be stored on the same tiles? & different mouths/stomachs make different foods accessible?
// Question: What do eyes see? Height? Food? Tiere? And how to modulate?
class Fixed_Eye extends Body_Part {

    Fixed_Eye() {
        super("Eye");
    }
}

// TODO: Make speed of metabolism depend on hearbeat?
class Heart extends Body_Part {
    float frequency;

    Heart() {
        super("Heart");
        frequency = random(0.05, 1);
    }

    // Body_Part replicate() {
    //    Heart H = new Heart();
    //    H.frequency = constrain(frequency + random(-0.05, 0.05), 0.05, 1);
    // }

    // float calc_healthMax() { return 0; }
    // float calc_hungerMax() { return 0; }
    float calc_upkeep() { return frequency*0.25; }
}