import peasy.*;
import java.util.Map;
import http.requests.*;
import java.util.Random;
import javax.swing.*; 
import java.util.*;
import java.lang.*;

PeasyCam cam;

final float SCRAMBLE_SPEED = 0.5;
final float SOLVE_SPEED = 0.10;
int scramble_moves_length = 50;

float speed = SCRAMBLE_SPEED;

int dim = 4;
Cubie[] cube = new Cubie[dim*dim*dim];

//map character notation of moves to internal representation
HashMap<String, Move> movesMap = new HashMap<String, Move>();

// dim to movesMap
HashMap<Integer, HashMap<String, Move>> dimToMoves = new HashMap<Integer, HashMap<String, Move>>();

ArrayList<Move> sequence = null;
ArrayList<Move> solveSequence = null;
int counter = 0;

String[] x3AllMoves = {"F", "F'", "D", "D'", "U", "U'", "B", "B'", "R", "R'", "L", "L'"};
String[] x4AllMoves = {"F", "F'", "D", "D'", "U", "U'", "D", "D'", "R", "R'", "L", "L'", "Fw", "Fw'", "Dw", "Dw'", "Uw", "Uw'", "Bw", "Bw'", "Rw", "Rw'", "Lw", "Lw'"};

String[] allMoves = null;
HashMap<Integer, String[]> dimToAllMoves = new HashMap<Integer, String[]>();
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
  
  
  dimToAllMoves.put(3, x3AllMoves);
  dimToAllMoves.put(4, x4AllMoves);
  
  dimToMoves.put(3, x3MovesMap);
  dimToMoves.put(4, x4MovesMap);
    
  
  //fullScreen(P3D);
  cam = new PeasyCam(this, 600);
  
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

      // translate moves to internal representation
      sequence = new ArrayList<Move>();
      translateMoves(response, "_", sequence, false);

      // start scramble
      scrambleCurrMove = sequence.get(counter);
      speed = SCRAMBLE_SPEED;
      scrambleCurrMove.start();
    }
    frmOpt.dispose();
}

void createCube(){
  
  movesMap = dimToMoves.get(dim);
  allMoves = dimToAllMoves.get(dim);

  int start=0,end=0;
  if(dim==3){
    start=-1;
    end=1;
  }else if(dim==4){
    start=-2;
    end=2;
  }
  
  int index = 0;
  for (int x = start; x <= end; x++) {
    for (int y = start; y <= end; y++) {
      for (int z = start; z <= end; z++) {
        if(x==0 || y==0 || z==0){
          continue;
        }
        float tx = x;
        float ty = y;
        float tz = z;
        
        if(dim==4){
          if(x<0){
            tx+= 0.5;
          }else{
            tx -= 0.5;
          }
          
          if(y<0){
            ty+= 0.5;
          }else{
            ty -= 0.5;
          }
          
          if(z<0){
            tz+= 0.5;
          }else{
            tz -= 0.5;
          }
        }
        
        
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(tx, ty, tz);
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
      String _cmove = allMoves[random.nextInt(allMoves.length)];
      moves += _cmove + "_";
  }
  // to remove last underscore
  moves = moves.substring(0, moves.length()-1);
  
  println(moves);
  

  // translate moves to internal representation
  sequence = new ArrayList<Move>();
  translateMoves(moves, "_", sequence, false);

  // start scramble
  scrambleCurrMove = sequence.get(counter);
  speed = SCRAMBLE_SPEED;
  scrambleCurrMove.start();
}

void translateMoves(String moves_, String seperator, ArrayList<Move> movesList, boolean reverse){
  moves = moves_;

  String[] extraMovesList = {"x", "x'", "y", "y'", "z", "z'"};
  HashSet<String> extraMoves = new HashSet<String>(Arrays.asList(extraMovesList));

  String[] movesArray = moves.split(seperator);
  if(reverse){
    // reverse array
    for(int i=0; i<movesArray.length/2; i++){
      String temp = movesArray[i];
      movesArray[i] = movesArray[movesArray.length -i -1];
      movesArray[movesArray.length -i -1] = temp;
    }
  }
  println(Arrays.toString(movesArray));
  
  for(String move : movesArray){
    if(extraMoves.contains(move)){
      continue;
    }
    if(movesMap.containsKey(move)){
      // any move without no, eg F U F' U' .....
      Move cmove = movesMap.get(move);
      movesList.add(cmove);
    }else{
      // any move with no, eg F2 U2, Fw2, Uw2 ......
      if(move.charAt(1)=='2'){
        // F2, U2 ...
        Move cmove = movesMap.get(move.charAt(0)+"");
        movesList.add(cmove);
        movesList.add(cmove);
      }else {
        // Fw2, Uw2, Fw, Fw' ....
        // Anything with w means inner layer rotation
        // i.e Fw2 --> f2, Fw' ---> f'

        // trick --> remove w and repeat for capital and small letter
        move = move.replace("w", "");
        
        // for capital char
        if(movesMap.containsKey(move)){
          // any move without no, eg F U F' U' .....
          Move cmove = movesMap.get(move);
          movesList.add(cmove);
        }else{
          // any move with no, eg F2 U2 ...
          Move cmove = movesMap.get(move.charAt(0)+"");
          movesList.add(cmove);
          movesList.add(cmove);
        }

        // for small char
        move = move.toLowerCase();
        if(movesMap.containsKey(move)){
          // any move without no, eg F U F' U' .....
          Move cmove = movesMap.get(move);
          movesList.add(cmove);
        }else{
          // any move with no, eg F2 U2 ...
          Move cmove = movesMap.get(move.charAt(0)+"");
          movesList.add(cmove);
          movesList.add(cmove);
        }
      }
    }
  }
}

void solve(){
  if(moves==null || moves==""){
    return;
  }

  if(dim==3){
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
  }else if(dim==4){
    GetRequest get = new GetRequest("http://localhost:4000?scramble="+moves);
    get.send();
    println("Reponse Content: " + get.getContent());
    String solveMoves = get.getContent();

    String[] tmp = solveMoves.trim().split("\\s+");
    println(Arrays.toString(tmp));

    solveSequence = new ArrayList<Move>();
    translateMoves(solveMoves, "\\s+", solveSequence, false);

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
