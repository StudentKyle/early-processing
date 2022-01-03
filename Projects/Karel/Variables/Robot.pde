class Robot extends ExceptionalRobot {
  
  Robot (String name, World world, int x, int y, int dir, int beepers) {
    super(name, world, x, y, dir, beepers);
  }

  void commands() {
  	clearRows();
    goHome();
  	turnOff();
  }

  void clearRows() {
  	clearRow();
  	faceNorth();

    while(frontIsClear()) {
    	move();
    	faceIntoRow();
    	clearRow();
    	faceNorth();
    }
    
    faceEast();
  }

  void clearRow() {
  	pickStackOfBeepers();
  	while(frontIsClear()) {
  		move();
  		pickStackOfBeepers();
  	}
  }

  void pickStackOfBeepers() {
  	while (nextToABeeper()) {
  		pickBeeper();
  	}
  }

  void faceIntoRow() {
  	turnLeft();
  	if (!frontIsClear()) {
  		turnAround();
  	}
  }

  void turnAround() {
  	turnLeft();
  	turnLeft();
  }

  void faceNorth() {
  	while (!facingNorth()) {
  		turnLeft();
  	}
  }

  void faceEast() {
  	while (!facingEast()) {
  		turnLeft();
  	}
  }

  void faceWest() {
    while (!facingWest()) {
      turnLeft();
    }
  }

  void faceSouth() {
    while (!facingSouth()) {
      turnLeft();
    }
  }

  void moveToWall() {
    while (frontIsClear()) {
      move();
    }
  }

  void goHome() {
    faceSouth();
    moveToWall();
    
    faceWest();
    moveToWall();
    
    faceEast();
  }


};
