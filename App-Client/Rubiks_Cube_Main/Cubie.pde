class Cubie {
  PMatrix3D matrix;
  int x = 0;
  int y = 0;
  int z = 0;
  color c;
  Face[] faces = new Face[6];

  Cubie(PMatrix3D m, int x, int y, int z) {
    this.matrix = m;
    this.x = x;
    this.y = y;
    this.z = z;
    c = color(255);

    faces[0] = new Face(new PVector(0, 0, -1), color(0, 0, 255));
    faces[1] = new Face(new PVector(0, 0, 1), color(0, 255, 0));
    faces[2] = new Face(new PVector(0, 1, 0), color(255, 255, 255));
    faces[3] = new Face(new PVector(0, -1, 0), color(255, 255, 0));
    faces[4] = new Face(new PVector(1, 0, 0), color(255, 150, 0));
    faces[5] = new Face(new PVector(-1, 0, 0), color(255, 0, 0));
  }
  
  void turnFacesZ(int dir) {
    for (Face f : faces) {
      f.turnZ(dir*HALF_PI); 
    }
  }

  void turnFacesY(int dir) {
    for (Face f : faces) {
      f.turnY(dir*HALF_PI); 
    }
  }

    void turnFacesX(int dir) {
    for (Face f : faces) {
      f.turnX(dir*HALF_PI); 
    }
  }
  
  
  
  void update(int x, int y, int z) {
    matrix.reset(); 
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
    matrix.translate(tx, ty, tz);
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void show() {
    //fill(c);
    noFill();
    stroke(0);
    strokeWeight(0.1);
    pushMatrix(); 
    applyMatrix(matrix);
    box(1);
    for (Face f : faces) {
      f.show();
    }
    popMatrix();
  }
}
