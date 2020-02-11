import peasy.*;
import java.util.Map;
import http.requests.*;
import java.util.Random;
import javax.swing.*; 
import java.util.*;
import java.lang.*;
import java.util.concurrent.ThreadLocalRandom;

PeasyCam cam;

final float SCRAMBLE_SPEED = 0.5;
final float SOLVE_SPEED = 0.10;
int scramble_moves_length = 50;

float speed = SCRAMBLE_SPEED;

int dim = 4;
Cubie[] cube = new Cubie[dim*dim*dim];

//map character notation of moves to internal representation
HashMap<String, Move> movesMap = new HashMap<String, Move>();


ArrayList<Move> sequence = null;
ArrayList<Move> solveSequence = null;
int counter = 0;

String[] x3AllMoves = {"F", "F'", "D", "D'", "U", "U'", "B", "B'", "R", "R'", "L", "L'"};
String[] x4AllMoves = {
      "F", "F'", "D", "D'", "U", "U'", "D", "D'", "R", "R'", "L", "L'", 
      "Fw", "Fw'", "Dw", "Dw'", "Uw", "Uw'", "Bw", "Bw'", "Rw", "Rw'", "Lw", "Lw'"
    };
String[] x5AllMoves = {
      "U", "U2", "U'", "R", "R2", "R'", "F", "F2", "F'",
      "D", "D2", "D'", "L", "L2", "L'", "B", "B2", "B'",
      "u", "u2", "u'", "r", "r2", "r'", "f", "f2", "f'",
      "d", "d2", "d'", "l", "l2", "l'", "b", "b2", "b'"
  };

String[] allMoves = null;
HashMap<Integer, String[]> dimToAllMoves = new HashMap<Integer, String[]>();
String moves = "";

boolean started = false;

HashMap<Integer, Integer> dimToScale = new HashMap<Integer, Integer>();

Move scrambleCurrMove;
Move solveCurrMove;

// Scramble Button
int rectX = 470;  // Position of square button
int rectY=600;
int rectWidth = 180;
int rectHeight = 70;
color rectColor = color(255);
color rectHighlight = color(0, 102, 153);
color currentColor;
boolean rectOver = false;

// Solve Button
int SrectX = 50;  // Position of square button
int SrectY=600;
int SrectWidth = 120;
int SrectHeight = 70;
color SrectColor = color(255);
color SrectHighlight = color(0, 102, 153);
color ScurrentColor;
boolean SrectOver = false;

// custom scramble sequence input
int IrectX = 260;  // Position of square button
int IrectY=600;
int IrectWidth = 120;
int IrectHeight = 70;
color IrectColor = color(255);
color IrectHighlight = color(0, 102, 153);
color IcurrentColor;
boolean IrectOver = false;

// cube dimention plus button
int PrectX = 50;  // Position of square button
int PrectY=50;
int PrectWidth = 40;
int PrectHeight = 40;
color PrectColor = color(255);
color PrectHighlight = color(0, 102, 153);
color PcurrentColor;
boolean PrectOver = false;

// cube dimention minus button
int MrectX = 50;  // Position of square button
int MrectY=150;
int MrectWidth = 40;
int MrectHeight = 40;
color MrectColor = color(255);
color MrectHighlight = color(0, 102, 153);
color McurrentColor;
boolean MrectOver = false;

String scrambleInput;
boolean txtFieldInitialized = false;
JFrame frmOpt;  //dummy JFrame

void setup() {
  size(700, 700, P3D);

  dimToAllMoves.put(3, x3AllMoves);
  dimToAllMoves.put(4, x4AllMoves);


  dimToScale.put(3, 70);
  dimToScale.put(4, 50);
  dimToScale.put(5, 50);
  dimToScale.put(6, 40);
  dimToScale.put(7, 35);
  dimToScale.put(8, 35);
  dimToScale.put(9, 30);
  dimToScale.put(10, 28);
  dimToScale.put(11, 26);



  //fullScreen(P3D);
  cam = new PeasyCam(this, 600);
  
  createCube();
}

void draw() {
  background(51); 

  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 600, 100);
  textSize(17);
  text("Counter", 580, 60);
  cam.endHUD();

  cam.beginHUD();
  fill(255);
  textSize(32);
  if(dim<=9){
    // single digit
    text(dim, 60, 132);
  }else{
    // double digit
    text(dim, 52, 132);
  }
  
  textSize(17);
  text("Change Dimentions", 5, 35);
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
  

  int start=0,end=0;
  start = -1 * (dim/2);
  end = 1 * (dim/2);

  cube = new Cubie[dim*dim*dim];

  allMoves = dimToAllMoves.get(dim);
  
  int index = 0;
  for (int x = start; x <= end; x++) {
    for (int y = start; y <= end; y++) {
      for (int z = start; z <= end; z++) {
        if(dim%2==0 && (x==0 || y==0 || z==0)){
          continue;
        }
        float tx = x;
        float ty = y;
        float tz = z;
        
        if(dim%2==0){
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
  if(dim==3){
    for(int i=0;i<scramble_moves_length;i++){
      String _cmove = x3AllMoves[random.nextInt(x3AllMoves.length)];
      moves += _cmove + "_";
    }
  }else if(dim==5){
    // dim 5 have a different notation
    for(int i=0;i<scramble_moves_length;i++){
      String _cmove = x5AllMoves[random.nextInt(x5AllMoves.length)];
      moves += _cmove + "_";
    }
  }else{
    // generic scramble code
    String[] nxnAllMoves = {"F", "D", "U", "B", "R", "L"};

    for(int i=0;i<scramble_moves_length;i++){
      int c_no_of_rows = ThreadLocalRandom.current().nextInt(1, (dim/2) + 1);

      String c_move = nxnAllMoves[random.nextInt(nxnAllMoves.length)];
      if(c_no_of_rows==1){
        // no need to change c_move
      }else if(c_no_of_rows==2){
        // change F to Fw
        c_move += "w";
      }else{
        // change F to 3F or 4F ... . nF 
        c_move = c_no_of_rows + c_move;
      }

      // int c_no_of_turns = ThreadLocalRandom.current().nextInt(1, 2+1);
      // if(c_no_of_turns==2){   // no need to include 1
      //   c_move += "2";
      // }

      // for random direction, take mod of 2 of a random no
      String direction = (random.nextInt(100)%2==0) ? "" : "'";
      c_move += direction;

      moves += c_move + "_";
    }
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

    LinkedList<Move> translatedMoves = translateMovesUtil(move, dim);
    for(Move m : translatedMoves){
      movesList.add(m);
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
      
      //solveSequence = new ArrayList<Move>();
      //for(String move : solveMoves.split(" ")){
      //  if(movesMap.containsKey(move)){
      //    // any move without no, eg F U F' U' .....
      //    Move cmove = movesMap.get(move);
      //    solveSequence.add(cmove);
      //  }else{
      //    // any move with no, eg F2 U2 ......
      //    Move cmove = movesMap.get(move.charAt(0)+"");
      //    solveSequence.add(cmove);
      //    solveSequence.add(cmove);
      //  }
      //}
      
      solveSequence = new ArrayList<Move>();
      translateMoves(solveMoves, "\\s+", solveSequence, false);
      
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
  }else if(dim==5){
    GetRequest get = new GetRequest("http://localhost:4010?scramble="+moves);
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
  }else{
    // for dim 6 ... 11
    GetRequest get = new GetRequest(String.format("http://localhost:2000?dim=%s&scramble=%s", dim, moves));
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
    scale(dimToScale.get(dim));
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
  scale(dimToScale.get(dim));
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
