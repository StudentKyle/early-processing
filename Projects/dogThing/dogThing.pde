PImage dog;

PVector dogPos;
PVector dogVel;
int dogWidth = 200;

boolean dogIsRunning = false;
int tick = 0;
int points = 0;


void setup() {
  size(1280,720);
  dog = loadImage("dog.jpg");
  dogPos = new PVector(randomXPos(),randomYPos());
  dogVel = new PVector(randomVel() * .2,randomVel() * .2);
}

void draw() {
  motionBlur();
  drawDog();
  bounceDog();
  walkDog();
  displayPoints();
}

void motionBlur() {
  noStroke();
  fill(255,175);
  rect(0,0,width,height);
}

void drawDog() {
  if (dogVel.x < 0) {
    //scale(-1);
  } else {
    //scale(1);
  }
  image(dog,dogPos.x,dogPos.y,dogWidth,dogWidth);
    dogPos.add(dogVel);
}

void bounceDog() {
  if (rectTouchingWall(dogPos.x,dogWidth)) {
    dogVel.x = dogVel.x * -1;
  }
  if (rectTouchingCeiling(dogPos.y,dogWidth)) {
    dogVel.y = dogVel.y * -1;
  }
}

void mousePressed() {
  if (rectMouseIsInside(dogPos.x,dogPos.y,dogWidth,dogWidth)) {
    dogIsRunning = true;
    points++;
    dogVel = new PVector(randomVel(),randomVel());
  }
}

void walkDog() {
  if (dogIsRunning) {
    tick++;
  }
  if (tick >= 30) {
    dogIsRunning = false;
    tick = 0;
    dogVel = new PVector(randomVel(),randomVel());
    if (points > 1) {
      dogVel.x = (dogVel.x * .1) * sqrt(points);
      dogVel.y = (dogVel.y * .1) * sqrt(points);
    } else {
      dogVel.x = (dogVel.x * .1);
      dogVel.y = (dogVel.y * .1);
    }
    
  }
}

void displayPoints() {
 fill(0);
 textSize(50);
 text("Points: " + points,50,75); 
}

boolean rectTouchingWall(float x, int w) { return (x+w >= width || x <= 0); }
boolean rectTouchingCeiling(float y, int h) { return (y+h >= height || y <= 0); }
boolean rectMouseIsInside(float x, float y, int w, int h) { 
  return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h); 
}

float randomVel() {
  float vel = random(-10,10);
  while (vel == 0) {
    vel = random(-10,10);
  }
  return vel * 10;
}

float randomXPos() {
  return random(0,width - 100 - (dogWidth*2));
}

float randomYPos() {
  return random(0,height - 100 - (dogWidth*2));
}
