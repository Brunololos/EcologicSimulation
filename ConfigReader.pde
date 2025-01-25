public ArrayList<Biome> getBiomes() {
    ArrayList<Biome> biomes = new ArrayList<Biome>();
    BufferedReader reader = createReader("./config/world_gen.txt");
    String line;
    String[] split;

    line = readLine(reader);
    while(true) {
        line = readLine(reader);
        if(line == null) { return biomes; }
        if(line == "") { return biomes; }
        biomes.add(new Biome(line));
    }
}

public ArrayList<Biome> getDefaultBiomes() {
    ArrayList<Biome> biomes = new ArrayList<Biome>();
    BufferedReader reader = createReader("./config/default_world_gen.txt");
    String line;
    String[] split;

    line = readLine(reader);
    while(true) {
        line = readLine(reader);
        if(line == null) { return biomes; }
        if(line == "") { return biomes; }
        biomes.add(new Biome(line));
    }
}

public void writeBiomes(ArrayList<Biome> biomes) {
    PrintWriter writer = createWriter("./config/world_gen.txt");

    writer.println("current_biomes:");
    for(Biome B : biomes) {
        writer.println(B.toString());
    }
    writer.flush();
    writer.close();
}

public String readLine(BufferedReader reader) {
    String line = null;
    if(reader == null) { return line; }
    try {
        line = reader.readLine();
    } catch (IOException e) {
        e.printStackTrace();
        line = "";
    }
    return line;
}