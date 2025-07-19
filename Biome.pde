class Biome {
    int c = color(125);
    int maxSat = 30;                // Maximum saturation of this biomes tiles
    int initSatMax = 15;            // Upper bound for the initial saturation of one of this biomes tiles
    float averageGrowth = 0.5;      // average monthly saturation growth of one of this biomes tiles
    float baseSprinkle = 0.1;       // average monthly saturation growth stimulation for this biomes neighbor tiles
    float upperElevationBorder;     // the upper elevation this biome ends at

    Biome(int biomeColor_, float upperElevationBorder_, float averageGrowth_, int maxSat_, int initSatMax_) {
        c = biomeColor_;
        upperElevationBorder = upperElevationBorder_;
        averageGrowth = averageGrowth_;
        maxSat = maxSat_;
        initSatMax = initSatMax_;
    }

    Biome(String biome) {
        String[] split = biome.split(",");

        colorMode(HSB);
        int h = Integer.parseInt(split[0]);
        int s = Integer.parseInt(split[1]);
        int b = Integer.parseInt(split[2]);
        c = color(h, s, b);
        upperElevationBorder = Float.parseFloat(split[3]);
        averageGrowth = Float.parseFloat(split[4]);
        maxSat = Integer.parseInt(split[5]);
        initSatMax = Integer.parseInt(split[6]);
    }

    int calculateInitialSaturation() {
        return round(random(0, initSatMax));
    }

    int calculateGrowth() {
        return round(random(-1, 2));   // Growth of biome expected value is 0.5
    }

    int calculateSprinkle() {
        return round(random(0, 30));   // Sprinkle of biome expected value is 0.5
    }

    boolean shouldGrow() {
        float monthsGrowth = 0.5 * 30;  // 0.5 is the expected value of the growth and we grow 30 times a month.
        if(averageGrowth == 0) {
            return false;
        } else if(averageGrowth == monthsGrowth) {
            return true;
        } else if(averageGrowth < monthsGrowth) {
            return random(0, 1000) < 1000/(monthsGrowth/averageGrowth);
        } else {
            // in any other case we'd need to sample more often,
            // and cannot achieve the target average Growth by 
            // growing less. Thus to grow as much as still poss-
            // ible we simply always grow.
            return true;
        }
    }

    boolean shouldSprinkle(int current_sat) {
        float monthsSprinkle = 15 * 30;  // 0.5 is the expected value of the growth and we grow 30 times a month.
        float targetSprinkle = baseSprinkle + current_sat * current_sat / 50.0; // monthsSprinkle * (current_sat / maxSat);
        if(targetSprinkle == 0) {
            return false;
        } else if(targetSprinkle == monthsSprinkle) {
            return true;
        } else if(targetSprinkle < monthsSprinkle) {
            return random(0, 1000) < 1000/(monthsSprinkle/targetSprinkle);
        } else {
            // in any other case we'd need to sample more often,
            // and cannot achieve the target average Growth by 
            // growing less. Thus to grow as much as still poss-
            // ible we simply always grow.
            return true;
        }
    }

    String toString() {
        String biome = "";
        biome += Integer.toString(round(hue(c))) + ",";
        biome += Integer.toString(round(saturation(c))) + ",";
        biome += Integer.toString(round(brightness(c))) + ",";
        biome += Float.toString(upperElevationBorder) + ",";
        biome += Float.toString(averageGrowth) + ",";
        biome += Integer.toString(maxSat) + ",";
        biome += Integer.toString(initSatMax);
        return biome;
    }
}