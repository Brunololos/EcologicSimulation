class Tier_Torso {
    color c;
    float size;

    //float carryMax;
    //float weight;

    Tier_Torso() {
        generate();
    }

    // TODO: calc recursively for all organs later
    public void generate() {
        c = color(random(0, 255), random(0, 255), random(0, 255));
        size = random(0.25, 0.75);
    }

    // TODO: calc recursively for all organs later
    public Tier_Torso replicate() {
        Tier_Torso T = new Tier_Torso();

        T.c = color(constrain(red(c) + random(-10, 10), 0, 255), constrain(green(c) + random(-10, 10), 0, 255), constrain(blue(c) + random(-10, 10), 0, 255));
        T.size = max(size + random(-0.05, 0.05), 0.25);

        return T;
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
        return 0.75 * size * size;
    }

    void display(PVector pos, float rot, boolean isSelected) {
        colorMode(RGB);
        if(debug && !dontShowDebug) {
            stroke(255,0,0);
            strokeWeight(0.0625*I.P.Z);
            line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot))*2*I.P.Z);
            stroke(0);
            line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot+30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot+30))*2*I.P.Z);
            line(pos.x*I.P.Z,pos.y*I.P.Z,pos.x*I.P.Z+cos(radians(rot-30))*2*I.P.Z,pos.y*I.P.Z+sin(radians(rot-30))*2*I.P.Z);

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