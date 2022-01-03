class Robot extends ExceptionalRobot {
  
  Robot (String name, World world, int x, int y, int dir, int beepers) {
    super(name, world, x, y, dir, beepers);
  }

  void commands() {
  	while (!nextToABeeper()) {
      isClear();
    }
    scoopBeepers();
    turnOff();
  }

  void isClear() {
   while (frontIsClear()) {
     move();
     turnLeft();
   }
   turnRight();
  }

  void scoopBeepers() {
     while (nextToABeeper()) {
      pickBeeper();
    }
  }
  void turnRight() {
    turnLeft();
    turnLeft();
    turnLeft();
  }
  
  
  
};
