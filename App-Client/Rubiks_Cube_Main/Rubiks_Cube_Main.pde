import peasy.*;
import java.util.Map;
import http.requests.*;
import java.util.Random;

PeasyCam cam;

float speed = 0.05;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

//map character notation of moves to internal representation
HashMap<String, Move> movesMap = new HashMap<String, Move>();

int scramble_moves_length = 20;

ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;

String[] allMoves = {"F", "F'", "D", "D'", "U", "U'", "D", "D'", "R", "R'", "L", "L'"};
String moves = "R L";

boolean started = false;

Move currentMove;

// Scramble Button
int rectX = 400;  // Position of square button
int rectY=500;
int rectWidth = 180;
int rectHeight = 70;
color rectColor = color(255);
color rectHighlight = color(0, 102, 153);
color currentColor;
boolean rectOver = false;

// Solve Button
int SrectX = 50;  // Position of square button
int SrectY=500;
int SrectWidth = 120;
int SrectHeight = 70;
color SrectColor = color(255);
color SrectHighlight = color(0, 102, 153);
color ScurrentColor;
boolean SrectOver = false;

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
  
  createCube();
 
  
  GetRequest get = new GetRequest("http://localhost:3000/api/solve/U_F_R2_B'_D2_L'");
  get.send();
  //println("Reponse Content: " + get.getContent());
  JSONObject resp_json = parseJSONObject(get.getContent());
  if (resp_json == null) {
    println("JSONObject could not be parsed");
  } else {
    String species = resp_json.getString("sequence");
    println(species);
  }
}

void draw() {
  background(51); 

  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 100, 100);
  cam.endHUD();
  
  updateFrame();
  
  cam.beginHUD();
  updateButton();
  cam.endHUD();
}

void createCube(){
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
}

void scramble(){
  
  moves = "";
  counter = 0;
  Random random = new Random();
  for(int i=0;i<scramble_moves_length;i++){
      moves += allMoves[random.nextInt(allMoves.length)] + "_";
  }
  // to remove last underscore
  moves = moves.substring(0, moves.length()-1);
  
  println(moves);
  
  sequence = new ArrayList<Move>();
  for(String move : moves.split("_")){
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
}

void updateFrame(){
  rotateX(-0.5);
  rotateY(0.4);
  rotateZ(0.1);
  
  if(currentMove==null){
    scale(50);
    push();
    for (int i = 0; i < cube.length; i++) {   
      cube[i].show();
    }
    pop();
    return;
  }


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
