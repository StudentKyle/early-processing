World world;
ArrayList<Robot> robots;

int numMazes = 7;

void setup() {
  size(800, 800);
  
  setupWorld(6);
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
  } else if (keyCode >= 48 && keyCode < 48 + numMazes) {
    // standard number keys
    setupWorld(keyCode - 48);
  } else if (keyCode >= 96 && keyCode < 96 + numMazes) {
    // numpad number keys
    setupWorld(keyCode - 96);
  }
}

void setupWorld(int maze) {
  world = new World("maze" + maze + ".kwld");
  robots = new RobotLoader().load("maze" + maze + ".krbs", world);
  world.setDelay(10);
  started = false;
  println("\nPress space to start maze " + maze);
}
