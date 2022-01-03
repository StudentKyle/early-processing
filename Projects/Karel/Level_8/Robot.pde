class Robot extends ExceptionalRobot {
  
  Robot (String name, World world, int x, int y, int dir, int beepers) {
    super(name, world, x, y, dir, beepers);
  }
  
  int operationNumber;
  int firstBeeperValue;
  int secondBeeperValue;
  int answer;
  int placeFirstBeeperValue;
  int placeSecondBeeperValue;
  
  void commands() {
    checkNorthBeeper();
    getNumbers();
    doMathOperation();
    printResult();
    turnOff();
  }
  
  void checkNorthBeeper() {
    turnLeft();
    move();
    while (nextToABeeper()) {
      pickBeeper();
      operationNumber++;
    }
    turnAround();
    move();
    turnLeft();
  }
  
  void getNumbers() {
   move();
   getFirstNumber();
   move();
   getSecondNumber();
  }
  
  void doMathOperation() {
    if (operationNumber==5) {
     addBeepers();
    } else if (operationNumber==4) {
     subractBeepers();
    } else if (operationNumber==3) {
     multiplyBeepers();
    } else if (operationNumber==2) {
     divideBeepers();
   } else {
     remainingBeepers();
    }
  }
  
  void addBeepers() {
      answer = firstBeeperValue + secondBeeperValue;
    }
  
  void subractBeepers() {
      if (firstBeeperValue > secondBeeperValue) {
        answer = firstBeeperValue - secondBeeperValue;
      } else {
        answer = secondBeeperValue - firstBeeperValue;
      }
  }
  
  void multiplyBeepers() {
      answer = firstBeeperValue * secondBeeperValue;
  }
  
  void divideBeepers() {
      answer = firstBeeperValue/secondBeeperValue;
  }
  
  void remainingBeepers() {
      answer = firstBeeperValue % secondBeeperValue;
  }
  
  
  void getFirstNumber() {
    while (nextToABeeper()) {
      pickBeeper();
      firstBeeperValue++;
      placeFirstBeeperValue++;
    }
    while (placeFirstBeeperValue > 0) {
      putBeeper();
      placeFirstBeeperValue--;
    }
  }
  
  void getSecondNumber() {
    while (nextToABeeper()) {
      pickBeeper();
      secondBeeperValue++;
      placeSecondBeeperValue++;
    }
    while (placeSecondBeeperValue > 0) {
      putBeeper();
      placeSecondBeeperValue--;
    }
   }
  
  void printResult() {
    move();
    move();
    while (answer > 0) {
      putBeeper();
      answer--;
    }
    turnAround();
    move();
  }
  
  void turnRight() {
   turnLeft();
   turnLeft();
   turnLeft();
  }
  
  void turnAround() {
   turnLeft();
   turnLeft();
  }
};
