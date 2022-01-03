boolean inMenu = true;

boolean snowman = false;
boolean house = false;
boolean robot = false;
boolean custom = false;
boolean mouseIsDragged = false;

float rgbF;
int rgb;
int brushSize = 100;

PShape snowmanButton;
PShape houseButton;
PShape robotButton;
PShape customButton;
PShape customInfoBox;

void setup() {
  size(800,800);
  drawMenu();
}

void draw() {
  if ((!inMenu)) {
    if (!custom) { background(200,200,200); fill(255); stroke(8); }
    drawObject();
  }
}

void keyPressed() {
  if (custom == true) {
   if (key == 'd') { // increase brush size
     brushSize = brushSize + 5;
   }
   if (key == 'a') { // decrease brush size
     brushSize = brushSize - 5;
   }
  }
  if (key == 'x') { // go back to menu
   snowman = false;
   house = false;
   robot = false;
   custom = false;
   inMenu = true;
   drawMenu();
  }
}

void mouseDragged() {
  mouseIsDragged = true;
  if (custom) {
    ellipse(mouseX,mouseY,brushSize,brushSize);
  }
}

void mouseReleased() {
  if (mouseIsDragged) {
   mouseIsDragged = false; 
  }
  if (inMenu) {
    pressButtons();
  } else if (custom) {
    fill(randomColor(),randomColor(),randomColor());
  }
}

void mousePressed() {
  if (custom) {
    ellipse(mouseX,mouseY,brushSize,brushSize);
  }
}

void mouseMoved() {
  println(mouseX,mouseY);
}

void pressButtons() {
  if ((mouseX > 100) && (mouseX < 275) && (mouseY > 50) && (mouseY < 125)) { // snowman
      background(200,200,200);
      snowman = true;
      inMenu = false;
    } else if ((mouseX > 350) && (mouseX < 465) && (mouseY > 50) && (mouseY < 125)) { // house
      background(200,200,200);
      house = true;
      inMenu = false;
    } else if ((mouseX > 540) && (mouseX < 655) && (mouseY > 50) && (mouseY < 125)) { // robot
      background(200,200,200);
      robot = true;
      inMenu = false;
    } else if ((mouseX > 350) && (mouseX < 485) && (mouseY > 150) && (mouseY < 225)) { // custom
      background(200,200,200);
      custom = true;
      inMenu = false;
      noStroke();
    }
    
}

void drawMenu() {
  background(200,200,200);
  fill(255,255,255);
  stroke(0);
  strokeWeight(1);
  snowmanButton = createShape(RECT,100,50,175,75);
  houseButton = createShape(RECT,350,50,115,75);
  robotButton = createShape(RECT,540,50,115,75);
  customButton = createShape(RECT,350,150,135,75);
  shape(snowmanButton);
  shape(houseButton);
  shape(robotButton);
  shape(customButton);
  fill(0,0,0);
  textSize(32);
  text("Snowman",110,100);
  text("House",360,100);
  text("Robot",550,100);
  text("Custom",360,200);
}

void drawObject() {
  if (snowman == true) {
     drawSnowman(200,200);
    if (mouseIsDragged) {
      drawSnowman(mouseX,mouseY);
    }
    
  } else if (house == true) {
    drawHouse();
  } else if (robot == true) {
    drawRobot();
  } else if (custom == true) {
    drawCustom();
  }
}

void drawSnowman(int x, int y) {
  strokeWeight(4);
  //body
  ellipse(x,y + 200,200,200);
  ellipse(x,y + 100,150,150);
  ellipse(x,y,100,100);
  
  //face  
  fill(0);
  ellipse(x - 15,y,10,10);
  ellipse(x + 15,y,10,10);
  // fill(255);
  stroke(255,176,57);
  triangle(x,y + 10,x + 5,y + 20,x - 5,y + 20);
  stroke(0);
  line(x - 15,y + 30,x + 15,y + 30);
}

void drawHouse() {
  rect(300,75,75,150);
  strokeWeight(20);
  rect(250,250,300,300);
  strokeWeight(8);
  triangle(250,250,550,250,400,100);
}

void drawRobot() {
  
}

void drawTree() {
  
}

void drawCustom() {
  textSize(24);
  text("Brush Size: " + brushSize, 610,750);
  noStroke();
}

int randomColor() {
  rgbF = random(255);
  rgb = int(rgbF);
  return rgb;
}
