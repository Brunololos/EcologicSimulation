class Biome {
    int c = color(125);
    int maxSat = 30;                // Maximum saturation of this biomes tiles
    int initSatMax = 15;            // Upper bound for the initial saturation of one of this biomes tiles
    float averageGrowth = 0.5;      // average monthly saturation growth of one of this biomes tiles
    float upperElevationBorder;     // the upper elevation this biome ends at

    Biome(int biomeColor_, float upperElevationBorder_, float averageGrowth_, int maxSat_, int initSatMax_) {
        c = biomeColor_;
        upperElevationBorder = upperElevationBorder_;
        averageGrowth = averageGrowth_;
        maxSat = maxSat_;
        initSatMax = initSatMax_;
    }

    int calculateInitalSaturation() {
        return round(random(0, initSatMax));
    }

    int calculateGrowth() {
        return round(random(-1, 2));   // Growth of biome expected value is 0.5
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
}