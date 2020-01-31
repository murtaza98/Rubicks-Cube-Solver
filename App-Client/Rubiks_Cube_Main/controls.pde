void updateButton(){
  update(mouseX, mouseY);
  //background(currentColor);
  
  if (rectOver) {
    fill(rectHighlight);
  }else{
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectWidth, rectHeight);
  fill(0);
  textSize(32);
  text("SCRAMBLE", rectX+10, rectY+47);
  
  if (SrectOver) {
    fill(SrectHighlight);
  }else{
    fill(SrectColor);
  }
  stroke(255);
  rect(SrectX, SrectY, SrectWidth, SrectHeight);
  fill(0);
  textSize(32);
  text("SOLVE", SrectX+10, SrectY+47);
  
  if (IrectOver) {
    fill(IrectHighlight);
  }else{
    fill(IrectColor);
  }
  stroke(255);
  rect(IrectX, IrectY, IrectWidth, IrectHeight);
  fill(0);
  textSize(32);
  text("INPUT", IrectX+10, IrectY+47);

  if (PrectOver) {
    fill(PrectHighlight);
  }else{
    fill(PrectColor);
  }
  stroke(255);
  rect(PrectX, PrectY, PrectWidth, PrectHeight);
  fill(0);
  textSize(32);
  text("+", PrectX+8, PrectY+30);

  if (MrectOver) {
    fill(MrectHighlight);
  }else{
    fill(MrectColor);
  }
  stroke(255);
  rect(MrectX, MrectY, MrectWidth, MrectHeight);
  fill(0);
  textSize(32);
  text("-", MrectX+10, MrectY+30);
}

void update(int x, int y) {
  if ( overRect(rectX, rectY, rectWidth, rectHeight) ) {
    rectOver = true;
  }else if(overRect(SrectX, SrectY, SrectWidth, SrectHeight)){
    SrectOver = true;
  } else if(overRect(IrectX, IrectY, IrectWidth, IrectHeight)){
    IrectOver = true;
  } else if(overRect(PrectX, PrectY, PrectWidth, PrectHeight)){
    PrectOver = true;
  } else if(overRect(MrectX, MrectY, MrectWidth, MrectHeight)){
    MrectOver = true;
  }else {
    SrectOver = false;
    rectOver = false;
    IrectOver = false;
    PrectOver = false;
    MrectOver = false;
  }
}

void mousePressed() {
  if (rectOver) {
    currentColor = rectColor;
    println("Scramble Pressed");
    scramble();
  }else if(SrectOver){
    ScurrentColor = SrectColor;
    solve();
    println("Solve Pressed");
  }else if(IrectOver){
    IcurrentColor = IrectColor;
    question();
    println("Input Pressed");
  }else if(PrectOver){
    IcurrentColor = IrectColor;
    if(dim+1 <= 7){
      dim++;
    }
    println("Plus Pressed");
  }else if(MrectOver){
    IcurrentColor = IrectColor;
    if(dim-1>=3){
      dim--;
    }
    println("Minus Pressed");
  }
  
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}



void keyPressed() {
  if (key == ' ') {
    scrambleCurrMove.start();
    counter = 0;
  }
  // applyMove(key);
}

void applyMove(char move) {
  switch (move) {
  case 'f': 
    turnZ(1, 1);
    break;
  case 'F': 
    turnZ(1, -1);
    break;  
  case 'b': 
    turnZ(-1, 1);
    break;
  case 'B': 
    turnZ(-1, -1);
    break;
  case 'u': 
    turnY(1, 1);
    break;
  case 'U': 
    turnY(1, -1);
    break;
  case 'd': 
    turnY(-1, 1);
    break;
  case 'D': 
    turnY(-1, -1);
    break;
  case 'l': 
    turnX(-1, 1);
    break;
  case 'L': 
    turnX(-1, -1);
    break;
  case 'r': 
    turnX(1, 1);
    break;
  case 'R': 
    turnX(1, -1);
    break;
  }
}
