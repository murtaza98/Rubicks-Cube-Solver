HashMap<String, Move> generateNxNMovesMap(int dim){

    //fill 3x3 movesMap
    HashMap<String, Move> x3MovesMap = new HashMap<String, Move>();
    x3MovesMap.put("F", new Move(0, 0, 1, 1));
    x3MovesMap.put("F'", new Move(0, 0, 1, -1));
    x3MovesMap.put("B", new Move(0, 0, -1, -1));
    x3MovesMap.put("B'", new Move(0, 0, -1, 1));
    x3MovesMap.put("D", new Move(0, 1, 0, -1));
    x3MovesMap.put("D'", new Move(0, 1, 0, 1));
    x3MovesMap.put("U", new Move(0, -1, 0, 1));
    x3MovesMap.put("U'", new Move(0, -1, 0, -1));
    x3MovesMap.put("R", new Move(1, 0, 0, 1));
    x3MovesMap.put("R'", new Move(1, 0, 0, -1));
    x3MovesMap.put("L", new Move(-1, 0, 0, -1));
    x3MovesMap.put("L'", new Move(-1, 0, 0, 1));
    
    // fill 4x4 MovesMap
    HashMap<String, Move> x4MovesMap = new HashMap<String, Move>();
    x4MovesMap.put("f", new Move(0, 0, 1, 1));
    x4MovesMap.put("f'", new Move(0, 0, 1, -1));
    x4MovesMap.put("b", new Move(0, 0, -1, -1));
    x4MovesMap.put("b'", new Move(0, 0, -1, 1));
    x4MovesMap.put("d", new Move(0, 1, 0, -1));
    x4MovesMap.put("d'", new Move(0, 1, 0, 1));
    x4MovesMap.put("u", new Move(0, -1, 0, 1));
    x4MovesMap.put("u'", new Move(0, -1, 0, -1));
    x4MovesMap.put("r", new Move(1, 0, 0, 1));
    x4MovesMap.put("r'", new Move(1, 0, 0, -1));
    x4MovesMap.put("l", new Move(-1, 0, 0, -1));
    x4MovesMap.put("l'", new Move(-1, 0, 0, 1));
    x4MovesMap.put("F", new Move(0, 0, 2, 1));
    x4MovesMap.put("F'", new Move(0, 0, 2, -1));
    x4MovesMap.put("B", new Move(0, 0, -2, -1));
    x4MovesMap.put("B'", new Move(0, 0, -2, 1));
    x4MovesMap.put("D", new Move(0, 2, 0, -1));
    x4MovesMap.put("D'", new Move(0, 2, 0, 1));
    x4MovesMap.put("U", new Move(0, -2, 0, 1));
    x4MovesMap.put("U'", new Move(0, -2, 0, -1));
    x4MovesMap.put("R", new Move(2, 0, 0, 1));
    x4MovesMap.put("R'", new Move(2, 0, 0, -1));
    x4MovesMap.put("L", new Move(-2, 0, 0, -1));
    x4MovesMap.put("L'", new Move(-2, 0, 0, 1));


    return x4MovesMap;
}

LinkedList<Move> translateMovesUtil(String move, int dim){
    
    boolean reverse = false;
    if(move.charAt(move.length()-1)=='\''){
        reverse = true;
        move = move.substring(0, move.length()-1);
    }

    // 2Uw, Uw and 2U all mean rotate the top 2 U rows
    // 3Uw and 3U mean rotate the top 3 U rows
    int no_of_rows = 1;
    if(move.length()>=2 && Character.isDigit(move.charAt(0)) && Character.isDigit(move.charAt(1))){
        no_of_rows = Integer.parseInt(move.substring(0, 2));
        // We've accounted for this so remove it
        move = move.substring(2);
    }else if(Character.isDigit(move.charAt(0))){
        no_of_rows = Integer.parseInt(move.substring(0, 1));
        // We've accounted for this so remove it
        move = move.substring(1);
    }else{
        // Uw also means rotate the top 2 U rows
        if(move.contains("w")){
            no_of_rows = 2;
            // We've accounted for this so remove it
            move = move.replaceAll("w", "");
        }else{
            no_of_rows = 1;
        }
    }

    int no_of_times = 1; // no of times to repeat the move, default = 1
    if(Character.isDigit(move.charAt(move.length()-1))){
        no_of_times = move.charAt(move.length()-1) - '0';
        // We've accounted for this so remove it
        move = move.substring(0, move.length()-1);
    }

    LinkedList<Move> moves = new LinkedList<Move>();
    LinkedList<Move> repeatedMoves = new LinkedList<Move>();

    int base = dim/2;

    switch(move){
        case "F":
            // Move(0, 0, 1, 1)
            for(int z=base;z>=base-no_of_rows+1;z--){
                int x = 0;
                int y = 0;
                int r = reverse ? -1 : 1;
                Move m = new Move(x, y, z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }

            return repeatedMoves;
        case "B":
            // Move(0, 0, -1, -1)
            for(int z=base;z>=base-no_of_rows+1;z--){
                int x = 0;
                int y = 0;
                int r = reverse ? 1 : -1;
                Move m = new Move(x, y, -1*z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }
            return repeatedMoves;
        case "R":
            // Move(1, 0, 0, 1)
            for(int x=base;x>=base-no_of_rows+1;x--){
                int y = 0;
                int z = 0;
                int r = reverse ? -1 : 1;
                Move m = new Move(x, y, z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }
            return repeatedMoves;
        case "L":
            // Move(-1, 0, 0, 1)
            for(int x=base;x>=base-no_of_rows+1;x--){
                int y = 0;
                int z = 0;
                int r = reverse ? 1 : -1;
                Move m = new Move(-1*x, y, z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }
            return repeatedMoves;
        case "U":
            // Move(0, -1, 0, 1)
            for(int y=base;y>=base-no_of_rows+1;y--){
                int x = 0;
                int z = 0;
                int r = reverse ? -1 : 1;
                Move m = new Move(x, -1*y, z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }
            return repeatedMoves;
        case "D":
            // Move(0, 1, 0, 1)
            for(int y=base;y>=base-no_of_rows+1;y--){
                int x = 0;
                int z = 0;
                int r = reverse ? 1 : -1;
                Move m = new Move(x, y, z, r);
                moves.add(m);
            }

            for(int i=1;i<=no_of_times;i++){
                for(Move m : moves){
                    repeatedMoves.add(m);
                }
            }
            return repeatedMoves;
        default: 
            println("Error- Unknown move " + move);
            return repeatedMoves;
    }
}
