World world;
ArrayList<Robot> robots;

void setup() {
  size(800, 800);
  
  world = new World("minefield.kwld");
  robots = new RobotLoader().load("minefield.krbs", world);

  world.setDelay(25);
  
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