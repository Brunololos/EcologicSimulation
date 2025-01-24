static class Name_Generator {

    static String[] Consonants = { "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z" };
    static String[] consonants = { "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z" };
    static String[] vocals = { "a", "e", "i", "o", "u" };

    static String generate() {
        String name = calc_Cv();
        int iter = ((int) (Math.random()*3));
        for(int i=0; i<iter; i++) {
            name = name + calc_cv();
        }
        if(Math.random() >= 0.5) { name = name + calc_c(); }
        return name;
    }

    static String calc_Cv() {
        String cv = Consonants[floor((float) Math.random()*4.9)];
        cv = cv + vocals[floor((float) Math.random()*4.9)];
        if(Math.random() >= 0.5) {
            cv = cv + vocals[floor((float) Math.random()*4.9)];
        }
        return cv;
    }

    static String calc_cv() {
        String cv = consonants[floor((float) Math.random()*4.9)];
        cv = cv + vocals[floor((float) Math.random()*4.9)];
        if(Math.random() >= 0.5) {
            cv = cv + vocals[floor((float) Math.random()*4.9)];
        }
        return cv;
    }

    static String calc_c() {
        String c = consonants[floor((float) Math.random()*4.9)];
        if(Math.random() >= 0.5) {
            c = c + c;
        }
        return c;
    }

}
