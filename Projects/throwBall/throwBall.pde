PShape ball;
float ballWidth = 100;
float ballHeight = 100;
boolean ballIsDragged = false;

PVector ballLocation;
PVector ballVelocity;
PVector releaseSpeed;

PVector mouseLocation;
PVector mouseVelocity;
float averageMouseXVel;
float averageMouseYVel;
PVector averageMouseVel;

PVector lastMouseVel1;
PVector lastMouseVel2;
PVector lastMouseVel3;
PVector lastMouseVel4;
PVector lastMouseVel5;
PVector lastMouseVel6;
PVector lastMouseVel7;
PVector lastMouseVel8;
PVector lastMouseVel9;

float mouseCheck;
float mouseXVel;
float mouseYVel;




void setup() {
  size(800, 800);
  setupBall();
  setupMouse();
}

void draw() {
  background(200,200,200);
  shape(ball, ballLocation.x, ballLocation.y);
  if ((releaseSpeed != null) && (!ballIsDragged)) {
     ballLocation.add(releaseSpeed);
  }
}

void setupBall() {
  ball = createShape(ELLIPSE, 0, 0, ballWidth, ballHeight);
  ball.setFill(color(255, 120, 0));
  ball.setStroke(false);
  
  ballLocation = new PVector(400,400);
  ballVelocity = new PVector(0,0);
}

void setupMouse() {
  mouseLocation = new PVector(mouseX,mouseY);
}

void mouseDragged() {
  if (mouseInRange()) {
    ballIsDragged = true;
    ballLocation.x = mouseX;
    ballLocation.y = mouseY;
  } else {
    ballIsDragged = false;
  }
}

void mouseMoved() {
  ellipse(pmouseX,pmouseY,100,100);
  ellipse(mouseX,mouseY,50,50);
  averageMouseVelocity();
  
  println(lastMouseVel3);
  println(lastMouseVel2);
  println(lastMouseVel1);
  println(lastMouseVel4);
  println(lastMouseVel5);
  println(lastMouseVel6);
  println(lastMouseVel7);
  println(lastMouseVel8);
  println(lastMouseVel9);
  println(mouseVelocity);
  println("Average: " + averageMouseVel);
  println("Ball Velocity: " + releaseSpeed);
}

void mouseReleased() {
  ballIsDragged = false;
  if (mouseInRange()) {
    releaseSpeed = averageMouseVel;
  }
}
void averageMouseVelocity() {
  if ((mouseVelocity != null)) {
  lastMouseVel9 = lastMouseVel8;
  delay(1);
  lastMouseVel8 = lastMouseVel7;
  delay(1);
  lastMouseVel7 = lastMouseVel6;
  delay(1);
  lastMouseVel6 = lastMouseVel5;
  delay(1);
  lastMouseVel5 = lastMouseVel4;
  delay(1);
  lastMouseVel4 = lastMouseVel1;
  delay(1);
  lastMouseVel1 = lastMouseVel2;
  delay(1);
  lastMouseVel2 = lastMouseVel3;
  delay(1);
  lastMouseVel3 = mouseVelocity;
  }
  
  mouseVelocity = new PVector ((mouseX - pmouseX),(mouseY- pmouseY));
  if (
  (mouseVelocity != null) && (lastMouseVel1 != null) && (lastMouseVel2 != null) && (lastMouseVel3 != null) && (lastMouseVel4 != null) && (lastMouseVel5 != null) && (lastMouseVel6 != null)  && (lastMouseVel7 != null) && (lastMouseVel8 != null) && (lastMouseVel9 != null)
  ) {
  averageMouseXVel = ((mouseVelocity.x + lastMouseVel1.x + lastMouseVel2.x + lastMouseVel3.x + lastMouseVel4.x + lastMouseVel5.x + lastMouseVel6.x + lastMouseVel7.x + lastMouseVel8.x + lastMouseVel9.x)/10);
  averageMouseYVel = ((mouseVelocity.y + lastMouseVel1.y + lastMouseVel2.y + lastMouseVel3.y + lastMouseVel4.y + lastMouseVel5.y + lastMouseVel6.y + lastMouseVel7.y + lastMouseVel8.y + lastMouseVel9.y)/10);
  averageMouseVel = new PVector(averageMouseXVel,averageMouseYVel);
  
  line(mouseX,mouseY,(mouseX + averageMouseVel.x * 10), (mouseY + averageMouseVel.y * 10));
  }
}

boolean mouseInRange() {
  mouseCheck = sqrt(((ballLocation.x - mouseX) * (ballLocation.x - mouseX)) + ((ballLocation.y - mouseY) * (ballLocation.y - mouseY)));
  if (mouseCheck < ((ballWidth))/2) {
    return true;
  }
  return false;
}
