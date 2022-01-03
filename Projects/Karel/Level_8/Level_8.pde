World world;
ArrayList<Robot> robots;

void setup() {
  size(800, 800);
  
  world = new World("level.kwld");
  world.setDelay(50);

  robots = new RobotLoader().load("level.krbs", world);
  
  println("\nPress space to start");
}

void draw() {
  background(#eeeeee);
  world.draw();
  
  for (Robot robot : robots) {
    robot.draw();
  }
}

int pics = 0;
boolean started = false;
void keyPressed() {
  if (keyCode == 80) { // "p"
    saveFrame("level-img_"+pics+".png");
    pics++;
  } else if (keyCode == 32 && !started) { // spacebar
    for (Robot robot : robots) {
      robot.start();
    }
    started = true;
  }
}