class Biomes {
  Biome[] standard_biomes = {
    new Biome(color(154,186,244), 400, 0, 1, 1),          // Meer
    new Biome(color(154,131,255), 450, 0, 5, 5),          // Küstenwasser
    new Biome(color(39,169,239), 500, 0, 10, 10),         // Strand
    new Biome(color(64,189,232-15), 625, 0.25, 30, 20),   // Wiese
    new Biome(color(85,193,139-25), 725, 0.5, 50, 25),    // Wald
    new Biome(color(52,15,221), 765, 0, 5, 5),            // Gebirge - Tief
    new Biome(color(0,0,128), 825, 0, 3, 3),              // Gebirge - Mittelhoch
    new Biome(color(0,0,255), 1000, 0, 2, 2)
  };
  private ArrayList<Biome> biomes;

  Biomes() {
    biomes = new ArrayList<Biome>();
    // Standard Biomes values
    colorMode(HSB, 255);                                              //66,131,244
    biomes.add(new Biome(color(154,186,244), 400, 0, 1, 1));          // Meer
    biomes.add(new Biome(color(154,131,255), 450, 0, 5, 5));          // Küstenwasser
    biomes.add(new Biome(color(39,169,239), 500, 0, 10, 10));         // Strand
    biomes.add(new Biome(color(64,189,232-15), 625, 0.25, 30, 20));   // Wiese
    biomes.add(new Biome(color(85,193,139-25), 725, 0.5, 50, 25));    // Wald
    biomes.add(new Biome(color(52,15,221), 765, 0, 5, 5));            // Gebirge - Tief
    biomes.add(new Biome(color(0,0,128), 825, 0, 3, 3));              // Gebirge - Mittelhoch
    biomes.add(new Biome(color(0,0,255), 1000, 0, 2, 2));             // Gebirge - Hoch
  }

  Biomes(ArrayList<Biome> biomes_) {
    if(biomes_.size() == 0) { throw new IllegalArgumentException("Biomes cannot be initialized with an empty list of biomes!"); }
    biomes = biomes_;
  }

  Biome get(int index) {
    return biomes.get(index);
  }

  void add(Biome biome) {
    biomes.add(biome);
  }

  void add(int index, Biome biome) {
    biomes.add(index, biome);
  }

  void set(int index, Biome biome) {
    biomes.set(index, biome);
  }

  void set(ArrayList<Biome> biomes) {
    biomes.clear();
    biomes.addAll(biomes);
  }

  void removeAt(int index) {
    biomes.remove(index);
  }

  int count() {
    return biomes.size();
  }
}
