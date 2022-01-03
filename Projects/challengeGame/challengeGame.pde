PImage space;
PVector playerLocation;
PVector playerVelocity;
PVector laserLocation;
PVector laserVelocity;


PVector alienLocation;
int alienWidth = 75;
int alienHeight = 50;

boolean alienIsGoingRight = true;
boolean alienIsGoingLeft = false;


PVector alienVelocity;

boolean leftIsPressed = false;
boolean rightIsPressed = false;
boolean fireIsPressed = false;

// 1 is default. <1 is easier. >1 is harder.
float difficulty = 1;

void setup() {
  size(1200,800);
  background(160);
  space = loadImage("background.jpg");
  //player
  playerLocation = new PVector(width/2 - 50, height - 60);
  playerVelocity = new PVector(5,0);
  //laser
  laserLocation = new PVector(0,0);
  laserVelocity = new PVector(0,10);
  
  // alien
  alienLocation = new PVector(100,100);
  alienVelocity = new PVector(10,0);
}

void draw() {
  background(160);
  image(space,0,0);
  alien();
  player();
}


void keyPressed() {
  if (key == 'a') { leftIsPressed = true; } // move left
  if (key == 'd') { rightIsPressed = true; } // move right
  if ((keyCode == 32) && (fireIsValid())) { fireIsPressed = true; } // fire laser
}

void keyReleased() {
  if (key == 'a') { leftIsPressed = false; } // stop moving left
  if (key == 'd') { rightIsPressed = false; } // stop moving right
}

void player() {
  fireLaser();
  movePlayer();
  drawPlayer();
  
}

void fireLaser() {
  if (fireIsPressed) {
    fireIsPressed = false;
    laserLocation = new PVector(playerLocation.x + 45,playerLocation.y - 60);
  }
  laserLocation.sub(laserVelocity);
  strokeWeight(2);
  fill(10,200,200);
  rect(laserLocation.x,laserLocation.y,10,20);
  
  
  //touching alien
  if ((laserLocation.x >= alienLocation.x) && (laserLocation.x <= alienLocation.x + alienWidth) && (laserLocation.y >= alienLocation.y) && (laserLocation.y <= alienLocation.y + alienHeight)) {
    println("Hit!");
  } else {
    println("Miss!");
  }
  
}

void movePlayer() {
  if ((leftIsPressed) && (playerLocation.x > 0)) {
    playerLocation.sub(playerVelocity);
  }
  if (rightIsPressed && (playerLocation.x + 100 < width)) {
    playerLocation.add(playerVelocity);
  }
}

void drawPlayer() {
  fill(255);
  rect(playerLocation.x + 35,playerLocation.y - 60,30,100);
  rect(playerLocation.x,playerLocation.y,100,40);
}

void alien() {
  drawAlien(alienLocation.x,alienLocation.y);
  
  //move alien
  if (alienLocation.x > width) {
    alienIsGoingRight = false;
    alienGoDown();
  } else if (alienLocation.x < 0) {
    alienIsGoingRight = true;
    alienGoDown();
  }
  if (alienIsGoingRight) {
    alienLocation.add(alienVelocity);
  } else {
    alienLocation.sub(alienVelocity);
  }
  
}
void alienGoDown() {
  alienLocation.y = alienLocation.y + 100;
  alienVelocity.x = randomSpeed();
}

int randomSpeed() {
  int speed = int(random(14*difficulty) + 1);
  return speed;
}

void drawAlien(float x, float y) {
  stroke(0);
  strokeWeight(5);
  fill(255,0,0);
  rect(x,y,alienWidth,alienHeight);
}

boolean fireIsValid() {
  if (laserLocation.y < 0) {
    return true;
  } else {
   return false; 
  }
}
