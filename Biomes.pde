class Biomes {
  private ArrayList<Biome> biomes;

  Biomes() {
    biomes = getBiomes();
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
