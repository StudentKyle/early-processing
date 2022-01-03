int speed = 5;
int snowmanX = 100;
int snowmanY = 200;

boolean upKeyPressed = false;
boolean downKeyPressed = false;
boolean leftKeyPressed = false;
boolean rightKeyPressed = false;

void setup() {
size(800,800);
strokeWeight(5);
background(200,200,200);
}

void draw() {
  background(200,200,200);
  drawSnowman(snowmanX,snowmanY);
  moveSnowman();
}

void moveSnowman() {
  if (upKeyPressed == true) { snowmanY = snowmanY - speed; }
  if (downKeyPressed == true) { snowmanY = snowmanY + speed; }
  if (leftKeyPressed == true) { snowmanX = snowmanX - speed; }
  if (rightKeyPressed == true) { snowmanX = snowmanX + speed; }
}

void keyPressed() {
  if (key == 'w') { upKeyPressed = true; }
  if (key == 's') { downKeyPressed = true; }
  if (key == 'a') { leftKeyPressed = true; }
  if (key == 'd') { rightKeyPressed = true; }
}

void keyReleased() {
  if (key == 'w') { upKeyPressed = false; }
  if (key == 's') { downKeyPressed = false; }
  if (key == 'a') { leftKeyPressed = false; }
  if (key == 'd') { rightKeyPressed = false; }
}
void drawSnowman(int x, int y) {
  //body
  ellipse(x,y + 200,200,200);
  ellipse(x,y + 100,150,150);
  ellipse(x,y,100,100);
  
  //face  
  fill(0);
  ellipse(x - 15,y,10,10);
  ellipse(x + 15,y,10,10);
   fill(255);
  stroke(255,176,57);
  triangle(x,y + 10,x + 5,y + 20,x - 5,y + 20);
  stroke(0);
  line(x - 15,y + 30,x + 15,y + 30);
}
