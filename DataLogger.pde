PrintWriter openDataLog(String name) {

    return createWriter("./logs/"+name+".txt");
}

public void logData(PrintWriter writer, float FPS, int population, int num_tiles, int num_tiere_rendered, int num_tiles_rendered) {
    writer.print(str(FPS)); writer.print(";");
    writer.print(str(population)); writer.print(";");
    writer.print(str(num_tiles)); writer.print(";");
    writer.print(str(num_tiere_rendered)); writer.print(";");
    writer.print(str(num_tiles_rendered)); writer.print(";");
    writer.println("");
}

void closeDataLog(PrintWriter writer) {
    writer.flush();
    writer.close();
}