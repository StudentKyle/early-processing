PVector ballLocation;
PVector ballVelocity;
int ballDiameter = 30;
int ballRadius;

PVector AIPaddleLocation;
PVector AIPaddleVelocity;
PVector playerPaddleLocation;
PVector playerPaddleVelocity;

int paddleWidth = 20;
int paddleHeight = 150;
int playerScore = 0;
int AIScore = 0;
float paddleSpeed = 14.4;

boolean upIsPressed = false;
boolean downIsPressed = false;

boolean gameIsWon = false;
boolean gameIsLost = false;

boolean inStart = true;


void setup() {
  size(1200,800);
  background(190);
  ballLocation = new PVector(width/2,height/2);
  ballVelocity = new PVector(18,randomBallVelocity());
  
  AIPaddleLocation = new PVector(width - 50, (height / 2.5));
  AIPaddleVelocity = new PVector(0,paddleSpeed);
  playerPaddleLocation = new PVector(25, (height / 2.5));
  playerPaddleVelocity = new PVector(0,paddleSpeed);
}

void draw() {
  if (inStart) {
    drawStart();
  } else {
  if (gameIsPlaying()) {
    playGame();
  } else if (gameIsWon) {
     showWin();
    } else if (gameIsLost) {
      showLose();
    }
  }
}

void playGame() {
  ballBlur();
  drawBall();
  AIPaddle();
  playerPaddle(); 
  
  if (ballLocation.x > AIPaddleLocation.x + paddleWidth) { gameIsWon = true; playerScore++; }
  if (ballLocation.x < playerPaddleLocation.x - paddleWidth) { gameIsLost = true; AIScore++; }
}
void playerPaddle() {
  fill(255);
  stroke(0);
  if (playerPaddleLocation.y >= 0) { // check barrier
    if (upIsPressed) { playerPaddleLocation.sub(playerPaddleVelocity); } // move up
  }
  if (playerPaddleLocation.y <= (height - paddleHeight)) { // check barrier
    if (downIsPressed) { playerPaddleLocation.add(playerPaddleVelocity); } // move down
  }
  rect(playerPaddleLocation.x, playerPaddleLocation.y, paddleWidth,paddleHeight); // draw paddle
}

void AIPaddle() {
  fill(255);
  stroke(0);
  AIPaddleVelocity = new PVector(0,abs(ballVelocity.y * 1)); // set paddle velocity
  rect(AIPaddleLocation.x, AIPaddleLocation.y, paddleWidth,paddleHeight); // draw paddle
  
  // follow ball
  if ((ballLocation.y >= AIPaddleLocation.y + (paddleHeight/2)) && (AIPaddleLocation.y <= (height - paddleHeight))) {
  AIPaddleLocation.add(AIPaddleVelocity); // move down
  } else if ((ballLocation.y <= AIPaddleLocation.y) && (AIPaddleLocation.y >= 0)) {
    AIPaddleLocation.sub(AIPaddleVelocity); // move up
  }
}

void keyPressed() {
  //move paddle
  if (key == 'w') { upIsPressed = true; }
  if (key == 's') { downIsPressed = true; }
  
  // start or restart
  if (!gameIsPlaying()) {
   if (keyCode == 32) {
     inStart = false;
     gameIsWon = false;
     gameIsLost = false;
     setup();
     }
   }
      
}

void keyReleased() {
  //stop paddle
  if (key == 'w') { upIsPressed = false; }
  if (key == 's') { downIsPressed = false; }
}

void drawBall() {
  ballRadius = ballDiameter / 2;
  ballLocation.add(ballVelocity);
  bounce();
  stroke(0);
  fill(175);
  ellipse(ballLocation.x,ballLocation.y,ballDiameter,ballDiameter);
}

void bounce() {
  if (gameIsPlaying()) {
    // bounce off player
    if ((ballLocation.x - ballRadius <= playerPaddleLocation.x + paddleWidth) && (ballLocation.y + ballRadius >= playerPaddleLocation.y) && (ballLocation.y <= playerPaddleLocation.y + paddleHeight)) {  
      ballVelocity.x = ballVelocity.x * -1;
      ballVelocity.y = randomBallVelocity();
    }
    // bounce off AI
    if ((ballLocation.x + ballRadius >= AIPaddleLocation.x) && (ballLocation.y + ballRadius >= AIPaddleLocation.y) && (ballLocation.y <= AIPaddleLocation.y + paddleHeight)) {
      ballVelocity.x = ballVelocity.x * -1;
      ballVelocity.y = randomBallVelocity();
    }
  }
  // bounce off floor/roof
  if ((ballLocation.y > (height - ballRadius)) || (ballLocation.y < ballRadius)) {
    ballVelocity.y = ballVelocity.y * -1;
  }
  if (inStart) {
  // bounce off walls
  if ((ballLocation.x - ballRadius <= 0) || (ballLocation.x + ballRadius >= width)) {
    ballVelocity.x = ballVelocity.x * -1;
    }
  }
  
  
}

void showWin() {
  background(200);
  textSize(50);
  fill(0);
  text("You won!",width/8, height/8);
  text("Press Space to Continue.",width/8,height/4);
  text("Player's Score: " + playerScore,width/8,height/2);
  text("AI's Score: " + AIScore,width/1.5,height/2);
}

void showLose() {
  background(200);
  textSize(50);
  fill(0);
  text("You lost!",width/8, height/8);
  text("Press space to try again.",width/8,height/4);
  text("Player's Score: " + playerScore,width/8,height/2);
  text("AI's Score: " + AIScore,width/1.5,height/2);
}

void drawStart() {
  drawBall();
  ballBlur();
  textSize(80);
  fill(255);
  rect(width/8,325,800,100);
  fill(0);
  text("Press Space to Start!",width/8,height/2);
  
}

boolean gameIsPlaying() {
  if (!gameIsWon && !gameIsLost && !inStart) {
    return true;
  } else {
    return false;
  }
}

void ballBlur() {
  noStroke();
  if (!inStart) {
    fill(200,100);
    rect(playerPaddleLocation.x + paddleWidth,0,width - 80,height);
    fill(200);
    rect(0,0,playerPaddleLocation.x + paddleWidth + 2,height);
    rect(AIPaddleLocation.x - 1,0,width - 80,height);
  } else {
    fill(200,10);
    rect(0,0,width,height);
  }
}

float randomBallVelocity() {
  float difficulty = 50; // sets relative difficulty by ball speed. 1 is normal
  float velocity = random(-39,39) + 1;
  while (velocity == 0) {
    velocity = random(-39,39) + 1;
  }
  return velocity * difficulty;
  }
