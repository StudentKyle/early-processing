int x1 = 100;
int y1 = 200;
int d1 = 50;
int r1 = d1/2;

int x2 = 200;
int y2 = 300;
int d2 = 100;
int r2 = d2/2;

int speed = 10;

boolean AIsPressed = false;
boolean DIsPressed = false;
boolean WIsPressed = false;
boolean SIsPressed = false;

boolean upIsPressed = false;
boolean downIsPressed = false;
boolean leftIsPressed = false;
boolean rightIsPressed = false;

void setup() {
  size(1200,800);
}

void draw() {
  background(200);
  ellipse(x2,y2,d2,d2);
  ellipse(x1,y1,d1,d1);
  
  movePlayer();
  intersection();
  
}

void intersection() {
  if (areIntersecting(x1,y1,r1,x2,y2,r2)) {
    fill(255,0,0);
  } else {
    fill(255); 
  }
}

void keyPressed() {
  println(keyCode);
  // small circle
  if (key == 'w') { WIsPressed = true; }
  if (key == 's') { SIsPressed = true; }
  if (key == 'a') { AIsPressed = true; }
  if (key == 'd') { DIsPressed = true; }
  // large circle
  if (keyCode == 38) { upIsPressed = true; }
  if (keyCode == 40) { downIsPressed = true; }
  if (keyCode == 37) { leftIsPressed = true; }
  if (keyCode == 39) { rightIsPressed = true; }
}

void keyReleased() {
  if (key == 'w') { WIsPressed = false; }
  if (key == 's') { SIsPressed = false; }
  if (key == 'a') { AIsPressed = false; }
  if (key == 'd') { DIsPressed = false; }
  // large circle
  if (keyCode == 38) { upIsPressed = false; }
  if (keyCode == 40) { downIsPressed = false; }
  if (keyCode == 37) { leftIsPressed = false; }
  if (keyCode == 39) { rightIsPressed = false; }
}

void movePlayer() {
  // small
  if (WIsPressed) { y1 = y1 - speed;}
  if (SIsPressed) { y1 = y1 + speed;}
  if (AIsPressed) { x1 = x1 - speed;}
  if (DIsPressed) { x1 = x1 + speed;}
  
  // large
  if (upIsPressed) { y2 = y2 - speed;}
  if (downIsPressed) { y2 = y2 + speed;}
  if (leftIsPressed) { x2 = x2 - speed;}
  if (rightIsPressed) { x2 = x2 + speed;}
}

boolean areIntersecting(int x1, int y1, int r1, int x2, int y2, int r2) {
  float d = distance(x1,y1,x2,y2);
  int radii = r1 + r2;
  return d <= radii;
}

float distance(int x1, int y1, int x2, int y2) {
 int xdiff = x2 - x1;
 int ydiff = y2 - y1;
 
 xdiff = xdiff * xdiff;
 ydiff = ydiff * ydiff;
 return sqrt(xdiff + ydiff);
}
