
PImage mole;
PImage whack;
PImage hole;
PVector molePos;
PVector whackPos;
int moleW = 100;


int holeW = moleW;
int holeSpace = 125;
int rows = 5;
int cols = 10;

PVector[][] holePos = new PVector[cols][rows];

void setup() {
  size(1280,720);
  initializePVectors();
  
  mole = loadImage("mole.jpg");
  whack = loadImage("whack.jpg");
  hole = loadImage("hole.png");
  
  molePos = new PVector(100,100);
  whackPos = new PVector(200,200);
  
}

void draw() {
  background(255);
  drawHoles();
  drawMoles();
  
}

void initializePVectors() {
  //for (int i = 0; i < holePos.length; i++) {
  //  holePos[i] = new PVector(0,0);
  //}
  
  
}

void mousePressed() {
  
}

void drawHoles() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      holePos[i][j] = new PVector(i*holeSpace+50,j*holeSpace+50);
      println(holePos[i][j]);
      image(hole,holePos[i][j].x,holePos[i][j].y,holeW,holeW);
  }
 }
}

void drawMoles() {
   image(mole,holePos[randH()][randL()].x,holePos[randH()][randL()].y,holeW,holeW);
}


int randL() { return int(random(rows)); }
int randH() { return int(random(cols)); }
boolean rectMouseIsInside(float x, float y, int w, int h) { return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h); }
