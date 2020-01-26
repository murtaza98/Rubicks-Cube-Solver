import cs.threephase.Search;

class CustomTest{
    public static void main(String[] args){
        String scrambleMoves = "U D R L U' R L B B L R L R B F U R L B B L R L B B L R L R B";

        Search search = new Search();

        String solutionMoves = search.solve(scrambleMoves);

        System.out.println(solutionMoves);
    }
}