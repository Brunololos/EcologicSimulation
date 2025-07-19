class Tier_Torso {
    color c;
    float size;
    ArrayList<Body_Part> body_parts;

    //float carryMax;
    //float weight;

    Tier_Torso() {
        generate();
    }

    public void generate() {
        c = color(random(30, 225), random(30, 225), random(30, 225));
        size = random(0.25, 0.75);

        body_parts = new ArrayList<Body_Part>();
        int num_body_parts = int(random(0,7));
        for (int i=0; i<num_body_parts; i++) {
            body_parts.add(generate_Body_Part());
        }
    }

    // TODO: calc recursively for all organs later
    public Tier_Torso replicate() {
        Tier_Torso T = new Tier_Torso();

        T.c = color(constrain(red(c) + random(-10, 10), 0, 255), constrain(green(c) + random(-10, 10), 0, 255), constrain(blue(c) + random(-10, 10), 0, 255));
        T.size = max(size + random(-0.05, 0.05), 0.25);
        // TODO:
        // T.body_parts = new ArrayList<Body_Part>();
        // for (int i=0; i<body_parts.size(); i++) {
        //     T.body_parts.add(body_part.get(i).replicate());
        // }

        return T;
    }

    // TODO: calc recursively for all organs later
    public IntDict enumerate_organs() {
        IntDict organs = new IntDict();
        // TODO: remove placeholder initialization
        organs.set("Mouth", 1);
        // organs.set("Eye", 2);
        organs.set("Heart", 1);
        organs.set("Womb", 1);
        organs.set("Legs", 1);
        organs.set("Total", 5);
        // TODO: set name property of each organ: e.g. Eye0, Eye1, Eye2 if multiple (They can use this key later to get perception/action idcs)
        return organs;
    }

    // TODO: calc recursively for all organs later
    public float calc_healthMax() {
        return 100 * size * size;
    }

    // TODO: calc recursively for all organs later
    public float calc_hungerMax() {
        return 2 * 100 * size * size;
    }

    // TODO: calc recursively for all organs later
    public float calc_upkeep() {
        return 0.75 * size * size + 0.5;
    }

    void display(PVector pos, float rot, boolean isSelected) {
        colorMode(RGB);
        if(debug) {
            if (show_perception_indicators || isSelected) {
                stroke(255,0,0);
                strokeWeight(0.0625*I.P.Z);
                line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot))*2*I.P.Z);
                stroke(0);
                line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot+30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot+30))*2*I.P.Z);
                line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot-30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot-30))*2*I.P.Z);
            }

            if(isSelected) {
                strokeWeight(1);
                stroke(0);
                fill(0, 0);
                ellipse(pos.x*I.P.Z,pos.y*I.P.Z,I.P.Z*4,I.P.Z*4);
            }
        }
        noStroke();
        fill(c);
        ellipse(pos.x*I.P.Z,pos.y*I.P.Z,size*I.P.Z,size*I.P.Z);
    }
}