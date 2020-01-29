import cs.threephase.Search;

class CustomTest{
    public static void main(String[] args){
        String scrambleMoves = "f L' b";

        Search search = new Search();

        String solutionMoves = search.solve(scrambleMoves);

        System.out.println(solutionMoves);
    }
}