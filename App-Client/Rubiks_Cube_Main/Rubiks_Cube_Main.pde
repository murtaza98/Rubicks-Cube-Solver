import peasy.*;
import java.util.Map;
import http.requests.*;

PeasyCam cam;

float speed = 0.05;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

//map character notation of moves to internal representation
HashMap<String, Move> movesMap = new HashMap<String, Move>();


Move[] allMoves = new Move[] {
  new Move(-1, 0, 0, -1)
};

ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;

String moves = "R L";

boolean started = false;

Move currentMove;

void setup() {
  size(600, 600, P3D);
  
  //fill movesMap
  movesMap.put("F", new Move(0, 0, 1, 1));
  movesMap.put("F'", new Move(0, 0, 1, -1));
  movesMap.put("B", new Move(0, 0, -1, -1));
  movesMap.put("B'", new Move(0, 0, -1, 1));
  movesMap.put("D", new Move(0, 1, 0, -1));
  movesMap.put("D'", new Move(0, 1, 0, 1));
  movesMap.put("U", new Move(0, -1, 0, 1));
  movesMap.put("U'", new Move(0, -1, 0, -1));
  movesMap.put("R", new Move(1, 0, 0, 1));
  movesMap.put("R'", new Move(1, 0, 0, -1));
  movesMap.put("L", new Move(-1, 0, 0, -1));
  movesMap.put("L'", new Move(-1, 0, 0, 1));
  
  //fullScreen(P3D);
  cam = new PeasyCam(this, 400);
  int index = 0;
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);
        index++;
      }
    }
  }
  
  for(String move : moves.split("\\s+")){
    if(movesMap.containsKey(move)){
      // any move without no, eg F U F' U' .....
      Move cmove = movesMap.get(move);
      sequence.add(cmove);
    }else{
      // any move with no, eg F2 U2 ......
      Move cmove = movesMap.get(move.charAt(0)+"");
      sequence.add(cmove);
      sequence.add(cmove);
    }
  }

  currentMove = sequence.get(counter);

  for (int i = sequence.size()-1; i >= 0; i--) {
    Move nextMove = sequence.get(i).copy();
    nextMove.reverse();
    sequence.add(nextMove);
  }

  currentMove.start();
  
  GetRequest get = new GetRequest("http://localhost:3000/api/solve/U_F_R2_B'_D2_L'");
  get.send();
  println("Reponse Content: " + get.getContent());
  //println("Reponse Content-Length Header: " + get.getHeader("Content-Length"));
}

void draw() {
  background(51); 

  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 100, 100);
  cam.endHUD();

  rotateX(-0.5);
  rotateY(0.4);
  rotateZ(0.1);
  


  currentMove.update();
  if (currentMove.finished()) {
    if (counter < sequence.size()-1) {
      counter++;
      currentMove = sequence.get(counter);
      currentMove.start();
    }
  }


  scale(50);
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == currentMove.z) {
      rotateZ(currentMove.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == currentMove.x) {
      rotateX(currentMove.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y ==currentMove.y) {
      rotateY(-currentMove.angle);
    }   
    cube[i].show();
    pop();
  }
}
