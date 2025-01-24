// static class ConfigReader {
//    public static ArrayList<Biome> getBiomes() {
//        ArrayList<Biome> biomes = new ArrayList<Biome>();
//        BufferedReader reader = createReader("./config/world_gen.txt");
//        String line;
//
//        line = ConfigReader.readLine(reader);
//        while(true) {
//            if(line == null) { return biomes; }
//            if(line == "") { return biomes; }
//
//        }
//    }

//    public static String readLine(BufferedReader reader) {
//        String line = null;
//        if(reader == null) { return line; }
//        try {
//            line = reader.readLine();
//        } catch (IOException e) {
//            e.printStackTrace();
//            line = "";
//        }
//        return line;
//    }
//}
