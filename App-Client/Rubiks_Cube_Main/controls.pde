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
}

void update(int x, int y) {
  if ( overRect(rectX, rectY, rectWidth, rectHeight) ) {
    rectOver = true;
  }else if(overRect(SrectX, SrectY, SrectWidth, SrectHeight)){
    SrectOver = true;
  } else {
    SrectOver = false;
    rectOver = false;
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
