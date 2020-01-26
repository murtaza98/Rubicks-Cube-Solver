import peasy.*;
import java.util.Map;
import http.requests.*;
import java.util.Random;
import javax.swing.*; 

PeasyCam cam;

final float SCRAMBLE_SPEED = 0.5;
final float SOLVE_SPEED = 0.10;

float speed = SCRAMBLE_SPEED;

int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

//map character notation of moves to internal representation
HashMap<String, Move> movesMap = new HashMap<String, Move>();

int scramble_moves_length = 50;

ArrayList<Move> sequence = null;
ArrayList<Move> solveSequence = null;
int counter = 0;

String[] allMoves = {"F", "F'", "D", "D'", "U", "U'", "D", "D'", "R", "R'", "L", "L'"};
String moves = "";

boolean started = false;

Move scrambleCurrMove;
Move solveCurrMove;

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

// custom scramble sequence input
int IrectX = 225;  // Position of square button
int IrectY=500;
int IrectWidth = 120;
int IrectHeight = 70;
color IrectColor = color(255);
color IrectHighlight = color(0, 102, 153);
color IcurrentColor;
boolean IrectOver = false;

String scrambleInput;
boolean txtFieldInitialized = false;
JFrame frmOpt;  //dummy JFrame

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
  // button
  updateButton();  
  cam.endHUD();
  
  if(!txtFieldInitialized){
    txtFieldInitialized = true;
    //question();
  }
}

void question() {
    moves = "";
    counter = 0;
    if (frmOpt == null) {
        frmOpt = new JFrame();
    }
    frmOpt.setVisible(true);
    frmOpt.setLocation(400, 400);
    frmOpt.setAlwaysOnTop(true);
    String response = JOptionPane.showInputDialog(frmOpt, "Enter the Scramble Sequence", "");
    if(response!=null && response.length()>0){
      // replace space with _
      response = response.replaceAll(" ", "_");
      println(response);
      translateMoves(response, "_");
    }
    frmOpt.dispose();
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
  
  translateMoves(moves, "_");
}

void translateMoves(String moves_, String seperator){
  moves = moves_;
  sequence = new ArrayList<Move>();
  for(String move : moves.split(seperator)){
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
  
  scrambleCurrMove = sequence.get(counter);

  speed = SCRAMBLE_SPEED;
  scrambleCurrMove.start();
}

void solve(){
  if(moves==null || moves==""){
    return;
  }
  
  GetRequest get = new GetRequest("http://localhost:3000/api/solve/"+moves);
  get.send();
  //println("Reponse Content: " + get.getContent());
  JSONObject resp_json = parseJSONObject(get.getContent());
  if (resp_json == null) {
    println("JSONObject could not be parsed");
  } else {
    String solveMoves = resp_json.getString("sequence");
    println(solveMoves);
    
    solveSequence = new ArrayList<Move>();
    for(String move : solveMoves.split(" ")){
      if(movesMap.containsKey(move)){
        // any move without no, eg F U F' U' .....
        Move cmove = movesMap.get(move);
        solveSequence.add(cmove);
      }else{
        // any move with no, eg F2 U2 ......
        Move cmove = movesMap.get(move.charAt(0)+"");
        solveSequence.add(cmove);
        solveSequence.add(cmove);
      }
    }
    
    println(solveSequence.size());
    
    counter = 0;
    speed = SOLVE_SPEED;
    solveCurrMove = solveSequence.get(counter);
    solveCurrMove.start();
  }
}

void updateFrame(){
  rotateX(-SCRAMBLE_SPEED);
  rotateY(0.4);
  rotateZ(0.1);
  
  if(scrambleCurrMove==null && solveCurrMove==null){
    scale(50);
    push();
    for (int i = 0; i < cube.length; i++) {   
      cube[i].show();
    }
    pop();
    return;
  }
  
  Move currMove = null;
  boolean isSolve = false;
  if(solveCurrMove != null){
    currMove = solveCurrMove;
    isSolve = true;
  }else{
    currMove = scrambleCurrMove;
    isSolve = false;
  }
  
  currMove.update();
  if (currMove.finished()) {
    if(isSolve){
      if (counter < solveSequence.size()-1) {
        counter++;
        solveCurrMove = solveSequence.get(counter);
        solveCurrMove.start();
      }else{
        solveCurrMove = null;
        currMove = null;
      }
    }else{
      if (counter < sequence.size()-1) {
        counter++;
        scrambleCurrMove = sequence.get(counter);
        scrambleCurrMove.start();
      }else{
        scrambleCurrMove = null;
        currMove = null;
      }  
    }
  }

  if(currMove==null){
    return;
  }
  scale(50);
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == currMove.z) {
      rotateZ(currMove.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == currMove.x) {
      rotateX(currMove.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y ==currMove.y) {
      rotateY(-currMove.angle);
    }   
    cube[i].show();
    pop();
  }
}
