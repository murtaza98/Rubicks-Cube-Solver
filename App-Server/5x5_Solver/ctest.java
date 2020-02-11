import cs.cube555.Search;
import cs.cube555.Tools;
import cs.cube555.CubieCube;

public class ctest {
	public static void solveTest() {

		Search.init();
		Search search = new Search();
		cs.min2phase.Search search333 = new cs.min2phase.Search();

		CubieCube cube = new CubieCube();
		// System.out.println(cube);

		int[] moves = new int[]{0, 1, 2, 3, 6 ,11, 12, 3, 2, 5};
		cube.doCornerMove(moves);
		cube.doMove(moves);

		String facelet = cube.toFacelet();
		System.out.println(facelet);
		String[] solution = search.solveReduction(facelet, 0);
		System.out.println(solution[0] + " --- " + solution[1]);

		String solution333 = search333.solution(solution[1], 21, Integer.MAX_VALUE, 500, 0);
		System.out.println(solution333);

		// System.out.println(cube);
	}

	public static void main(String[] args) {
		solveTest();
	}
}