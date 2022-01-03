// Input Variables
  boolean WIsPressed = false;
  boolean SIsPressed = false;
  boolean AIsPressed = false;
  boolean DIsPressed = false;
  
  boolean spaceIsPressed = false;
  boolean FIsPressed = false;
  
  boolean upArrowIsPressed = false;
  boolean downArrowIsPressed = false;
  boolean leftArrowIsPressed = false;
  boolean rightArrowIsPressed = false;

// Player Variables
  PImage playerImg;
  PVector playerPos = new PVector(750,500); // starting player position
  float playerSpeed = 5; // starting player speed
  PVector playerVel = new PVector(playerSpeed,playerSpeed); 
  float playerWidth = 214/4;
  float playerHeight = 238/4;
  
  PImage heart;
  ArrayList<PlayerHealth> playerHealth = new ArrayList<PlayerHealth>();
  int playerStartingHealth = 6;


  // Laser Variables
    ArrayList<PlayerLaser> playerLasers = new ArrayList<PlayerLaser>();
    int laserWidth = 10;
    int laserHeight = 20;
    
    int cooldownFire = 0;
    int playerFireRate = 100; // lower is faster, higher is slower
    float fireCooldownHUDWidth;
    
    float playerLaserSpeed = 8;
    
    boolean playerCanFire = true;
  
  // Weapon Variables
    int startingWeaponDiameter = 40;
    PVector startingWeaponPos = new PVector();
    boolean playerHasStartingWeapon = false;
    int startingWeaponWarning = 0;
    
    boolean playerDeniedStartingWeapon = false;
    int startingWeaponShootPlayerTimer = 0;
    
  // Upgrade Variables
    int shopUpgradeDiameter = 100;
    
  //Weapons
    //Fire Rate Upgrade
      float fireRateIncrease = 15;
      PVector fireRateItemPos = new PVector(1200,350);
      int fireRateUpgradeCost = 6;
      int fireRateUpgradesBought = 0;
      boolean playerMaxedFireRate = false;
    // Laser Speed Upgrade
      float laserSpeedIncrease = 1.25;
      PVector laserSpeedItemPos = new PVector(1200,750);
      int laserSpeedUpgradeCost = 5;
      int laserSpeedUpgradesBought = 0;
      boolean playerMaxedLaserSpeed = false;
    //Auto Fire Upgrade
      boolean playerHasAutofire = false;
      boolean playerIsAutofiring = false;
      PVector autofireItemPos = new PVector(320,350);
      int autofireUpgradeCost = 20;
    //Backward Fire Upgrade
      boolean playerHasBackwardFire = false;
      PVector backwardFireItemPos = new PVector(320,750);
      int backwardFireUpgradeCost = 30;
      
  //Hull
    //Heart Up
      PVector heartItemPos = new PVector(700,250);
      int heartUpgradeCost = 3;
    //Player Speed Upgrade
      float playerSpeedIncrease = 1.1;
      PVector playerSpeedItemPos = new PVector(1200,350);
      int playerSpeedUpgradeCost = 8;
      int playerSpeedUpgradesBought = 0;
      boolean playerMaxedPlayerSpeed = false;
    
// Alien Variables
  ArrayList<Alien> aliens = new ArrayList<Alien>();
  
  int alienSpawnCooldown = 0;
  int alienSpawnRate = 50;
  
  boolean alienCanSpawn = true;
  boolean alienCanFire = false;
  boolean alienIsHit = false;
  //Laser Variables
    ArrayList<AlienLaser> alienLasers = new ArrayList<AlienLaser>();
  
// Background Variables
  int starCount = 200;
  PVector[] starPos = new PVector[starCount];
  int[] backgroundColor = new int[starCount];
  boolean backgroundDrawn = false;
  
  float starSpeed = 1;
  float maxStarSpeed; // transitional value of blur used when going INTO transit
  int motionBlurStrength = 220; //lower values mean more motion blur. Range 0-255, default = 220.
  int maxBlurStrength; // transitional value of blur, which sets which motion blur to actually pursue/reach by acceleration.
  
  boolean isTransitioningStarsToFaster = false;
  boolean isTransitioningStarsToSlower = false;
  
  boolean isTransitioningBlurToFaster = false;
  boolean isTransitioningBlurToSlower = false;


//Environment Variables
  ArrayList<Planet> planets = new ArrayList<Planet>();
  int amountOfPlanets = 0;
  
  int generatePlanetFails = 0;
  float generatePlanetChance;


//Explosions
  ArrayList<Explosion> alienExplosions = new ArrayList<Explosion>();
  int currentAlienExplosions = 0;
  int alienExplosionsRemoved = 0;
  int alienExplosionWeight = 50;
  
  ArrayList<Explosion> friendlyExplosions = new ArrayList<Explosion>();
  int currentFriendlyExplosions = 0;
  int friendlyExplosionsRemoved = 0;
  
  int playerExplosionWeight = 100;


// Shop Variables

PImage cart;
PImage arrow;
float arrowWidth = 360;
float arrowHeight = 594;
int shopButtonWidth = 80;
PVector shopButtonPos = new PVector(1500-shopButtonWidth,0);


PImage coins;
int moneyDisplayWidth = 721;
int moneyDisplayHeight = 768;
PVector moneyDisplayPos = new PVector(shopButtonPos.x-moneyDisplayWidth*3.5,10);
int money = 5000;

float costScaling = 1.2;
boolean shopIsAvailable = false;
boolean shopHasBeenEntered = false;
boolean inWeaponShop = false;
boolean inHullShop = false;

//Global Counters
  int numberOfAliensHitTotal = 0;
  int numberOfAliensHitHere = 0;
  int maxNumberOfAliens = 3;
  int numberOfAliensSpawnedHere = 0;
  int instanceTimer = 0;
  int textLine = 1;
  float difficulty = 1;
  int instancesTraveled = 0;


//Instance Organizers:
  boolean inStart = true;
  boolean inFirstInstance = false;
  
  boolean inCombat = false;
  boolean inShop = false;
  boolean gameIsLost = false;
  
  boolean byPlanet = false;
  boolean byFriendlyPlanet = false;
  boolean byHostilePlanet = false;
  
  boolean inFriendlyTransit = false;
  boolean inHostileTransit = false;


void setup() {
  size(1500,1000);
  initializeImages();
  initializeStartingValues();
  initializeBackground();
}

void draw()  {
  if (inStart) { drawStart(); }
  if (inShop) {
    drawShop();
  } else {
    if (inFirstInstance) { drawFirstInstance(); }
  
    if (byFriendlyPlanet) { drawFriendlyPlanet();}
    if (byHostilePlanet) { drawHostilePlanet();}
    if (inFriendlyTransit) { drawFriendlyTransit(); }
    if (inHostileTransit) { drawHostileTransit(); }
  }
  if (instanceTimer == 0) {
    resetEntities();
  }
}

void combatLoop() {
  if (!gameIsLost) {
    drawExplosions();
    if (!inFirstInstance) { alien(); }
    player();
    drawHUD();
  } else {
    drawExplosions();
    drawLose();
  }
}

void drawHUD() {
  playerHealthHUD();
  playerFireHUD();
  moneyCountHUD(money,1420-moneyDisplayWidth/15*3.5,10,moneyDisplayWidth/15,moneyDisplayHeight/15);
  if (shopIsAvailable && !shopHasBeenEntered && !inCombat) { shopButton(); }
}

void drawStart() {
  drawBackground();
  noStroke();
  fill(0,255,0);
  triangle(width/3,height/3,width/1.5,height/2,width/3,height/1.5);
  fill(0);
  textSize(40);
  text("Press Any Key To Start",width/3,height/1.97);
}

void drawFirstInstance() {
  if (instanceTimer == 0) {
    exitTransit();
    amountOfPlanets = 1;
    inFirstInstance = true;
    maxBlurStrength = 220;
  }
  if (instanceTimer == 1) {
    startingWeaponPos = new PVector(planets.get(0).x-planets.get(0).d/4,planets.get(0).y-planets.get(0).d/2.2);
  }
  transitionToSlower();
  drawBackground();
  drawEnvironment();
  combatLoop();
  firstInstanceText();
  startingWeapon();
  instanceTimer++;
  exitFirstInstance(); // ALL exit code must go AFTER instanceTimer++
}

void startingWeapon() {
  if (!playerHasStartingWeapon) {
    fill(255,255,100);
    if (!playerDeniedStartingWeapon) { stroke(0,255,0); } else { stroke(255,0,0); }
    strokeWeight(4);
    ellipse(startingWeaponPos.x,startingWeaponPos.y,40,40);
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,startingWeaponPos.x-startingWeaponDiameter/2,startingWeaponPos.y-startingWeaponDiameter/2,startingWeaponDiameter,startingWeaponDiameter)) {
      if (!playerDeniedStartingWeapon) { playerHasStartingWeapon = true; }
    }
  }
  if (playerDeniedStartingWeapon && !gameIsLost) {
    stroke(255,255,100);
    strokeWeight(8);
    startingWeaponShootPlayerTimer++;
    if (startingWeaponShootPlayerTimer > 50) {
      alienLasers.add(new AlienLaser(startingWeaponPos.x,startingWeaponPos.y,3));
      startingWeaponShootPlayerTimer = 0;
      }
    alienLaserDraw();
    hitPlayer();
    }
}

void drawFriendlyPlanet() {
  if (instanceTimer == 0) {
    
  }
  instanceTimer++;
  enterTransit();
}

void drawHostilePlanet() {
  if (instanceTimer == 0) {
    maxBlurStrength = 220;
    inCombat = true;
    if (planets.size() >= 1 && !inFriendlyTransit && !inHostileTransit && !inFirstInstance) {
    shopIsAvailable = true;
    } else {
      shopIsAvailable = false; 
    }
    if (shopIsAvailable) {
      if (rand100() <= 50) {
        inWeaponShop = true;
        inHullShop = false;
      } else {
        inHullShop = true;
        inWeaponShop = false;
      }
    }
  }
  transitionToSlower();
  drawBackground();
  drawEnvironment();
  combatLoop();
  instanceTimer++;
  enterTransit();
}

void drawFriendlyTransit() {
  if (instanceTimer == 0) {
    maxBlurStrength = 25;
  }
  transitionToFaster();
  drawBackground();
  drawEnvironment();
  player();
  drawHUD();
  instanceTimer++;
  exitTransit();
  stroke(100);
  fill(200);
  strokeWeight(8);
  rect(100,800,542,90);
  fill(0);
  textSize(25);
  text("Press S and the down arrow simultaniously",110,825);
  text("to deactivate your warp-drive.",110,850);
  text("Do this near a planet to access a shop.",110,875);
}

void drawHostileTransit() {
  if (instanceTimer == 0) {
    inCombat = true;
  }
  instanceTimer++;
  exitTransit();
}

void enterTransit() {
  if (WIsPressed && upArrowIsPressed) {
    resetInstances();
    inFriendlyTransit = true;
    isTransitioningStarsToFaster = true;
    isTransitioningBlurToFaster = true;
    increaseDifficulty();
  }
}

void exitTransit() {
  if (SIsPressed && downArrowIsPressed || inFirstInstance) {
    if (inFirstInstance) {
      resetInstances();
      inFirstInstance = true;
    } else {
      resetInstances();
      byHostilePlanet = true;
    }
    byPlanet = true;
    isTransitioningStarsToSlower = true;
    isTransitioningBlurToSlower = true;
  }
}

void resetInstances() {
  amountOfPlanets = 0;
  inStart = false;
  byPlanet = false;
  inFirstInstance = false;
  byFriendlyPlanet = false;
  byHostilePlanet = false;
  inFriendlyTransit = false;
  inHostileTransit = false;
  inCombat = false;
  numberOfAliensSpawnedHere = 0;
  inShop = false;
  shopIsAvailable = false;
  shopHasBeenEntered = false;
  instanceTimer = 0;
}

void increaseDifficulty() {
  difficulty *= 1.6;
  instancesTraveled++;
  if (instancesTraveled <= 3) {
    maxNumberOfAliens+= instancesTraveled;
  } else {
    maxNumberOfAliens+= int(random(2)) + 2;
  }
  
  
  if (alienSpawnRate > 10) {
    alienSpawnRate -= instancesTraveled*2;
  } else {
    alienSpawnRate = 10;
  }
  
}

void resetEntities() {
  if (playerLasers.size() > 0) {
    for (int i = playerLasers.size()-1; i >= 0; i--) {
      playerLasers.remove(i);
    }
  }
  if (aliens.size() > 0) {
    for (int i = aliens.size()-1; i >= 0; i--) {
      aliens.remove(i);
    }
  }
  if (alienLasers.size() > 0) {
    for (int i = alienLasers.size()-1; i >= 0; i--) {
      alienLasers.remove(i);
    }
  }
  if (alienExplosions.size() > 0) {
    for (int i = alienExplosions.size()-1; i >= 0; i--) {
      alienExplosions.remove(i);
      alienExplosionsRemoved++;
    }
  }
  if (friendlyExplosions.size() > 0) {
    for (int i = friendlyExplosions.size()-1; i >= 0; i--) {
      friendlyExplosions.remove(i);
      friendlyExplosionsRemoved++;
    }
  }
}

void transitionToFaster() {
  if (isTransitioningStarsToFaster) {
      if (starSpeed < 10) {
        if (starSpeed == 0) { starSpeed = .01; }
        starSpeed *= 1.05;
    } else {
        starSpeed = 10;
        isTransitioningStarsToFaster = false;
    } 
  }
  if (isTransitioningBlurToFaster) {
    if (motionBlurStrength > maxBlurStrength) {
      motionBlurStrength *= .9;
    } else {
      motionBlurStrength = maxBlurStrength;
      isTransitioningBlurToFaster = false;
    }
  }
}

void transitionToSlower() {
  if (isTransitioningStarsToSlower) {
    if (starSpeed > .01) {
      starSpeed *= .98;
    } else {
      starSpeed = 0;
      isTransitioningStarsToSlower = false;
    } 
  }
  if (isTransitioningBlurToSlower) {
    if (motionBlurStrength < maxBlurStrength) {
      motionBlurStrength *= 1.04;
    } else {
      motionBlurStrength = maxBlurStrength;
      isTransitioningBlurToFaster = false;
    }
  }
}

void firstInstanceText() {
  fill(200);
  stroke(100);
  strokeWeight(8);
  rect(100,100,1200,200);
  
  if (textLine >= 10) { stroke(0,255,0); }
  rect(100,800,542,90);
  fill(0);
  textSize(25);
  text("Press W and the up arrow simultaniously",110,825);
  text("to activate your warp-drive.",110,850);
  
  
  textSize(20);
  if (startingWeaponWarning == 0 && textLine != 8 && textLine < 10) {
    text("Press space to continue...",360,275); 
  } else if (textLine == 8) {
    text("Drag the planetary defense laser to your ship using your mouse to continue...",360,275);
  } else if (textLine >= 10) {
    text("Activate your warp drive to continue...",360,275);
  } else {
    text("Collect laser or activate your warp drive to continue...",360,275); 
  }
  
  textSize(40);
  if (textLine == 1) {
    text("Thank you for responding to our distress signal.",125,150);
  } else if (textLine == 2) {
    text("A group of pirates stole most of our supplies.",125,150);
    text("Now we can't fight the war.",125,200);
  } else if (textLine == 3) {
    text("...",125,150);
  } else if (textLine == 4) {
    textSize(30);
    text("What are we going to do with an exploration ship?",125,150);
  } else if (textLine == 5) {
    text("...",125,150);
  } else if (textLine == 6) {
    text("You have a micro warp-drive!",125,150);
  } else if (textLine == 7) {
    text("Take our planetary defense laser.",125,150);
    text("It's not much good in space, but it's all we have for you.",125,200);
  } else if (textLine == 8) {
    text("Use your tractor beam and DRAG it onto your ship.",125,150);
    if (playerHasStartingWeapon) { textLine++; }
  } else if (textLine == 9) {
    if (playerHasStartingWeapon) {
      textSize(40);   
      text("We wish you luck, on behalf of all those ravaged by pirates.",125,150);
    } else {
      textLine = 8;
    }
    
  } else if (textLine >= 10) {
    text("They should still be close, so please hurry.",125,150);
    text("Activate your micro warp-drive and go get them!",125,200);
  }
  
  
  forgetStartingWeapon();
  if (spaceIsPressed) { textLine++; spaceIsPressed = false; }

}

void exitFirstInstance() {
  if (upArrowIsPressed && WIsPressed) {
    if (playerHasStartingWeapon) {
      enterTransit();
    }
  }
}

void forgetStartingWeapon() {
  if (startingWeaponWarning > 0 && playerHasStartingWeapon) {
        textLine = 9;
        startingWeaponWarning = 0;
      }
  
  if (upArrowIsPressed && WIsPressed) {
    if (!playerHasStartingWeapon) {
      textLine = -100;
      startingWeaponWarning++;
      upArrowIsPressed = false;
      WIsPressed = false;
    }
  }
  
  if (startingWeaponWarning == 1 && !playerHasStartingWeapon) {
      fill(0);
      textSize(40);
      text("Wait! You haven't dragged our weapon onto your vessel.",125,150);
      text("You won't be able survive in this region of space without it.",125,200);
    } else if (startingWeaponWarning == 2 && !playerHasStartingWeapon) {
      fill(0);
      text("...",125,150);
    } else if (startingWeaponWarning >= 3 && !playerHasStartingWeapon) {
      fill(0);
      text("Clearly you are not a suitable for going after those pirates.",125,150);
      text("The salvage material from your ship will be a nice donation.",125,200);
      playerDeniedStartingWeapon = true;
    }
}

void alien() {
  spawnAliens();
  drawAliens();
  hitAliens();
  alienLaserDraw();
}

void alienLaserDraw() {
  fill(0,0,255);
  for (int i = alienLasers.size()-1; i >= 0; i--) {
    alienLasers.get(i).move();
    alienLasers.get(i).display();
    if (alienLasers.get(i).shouldRemove()) {
      alienLasers.remove(i);
    }
  }
}

void drawAliens() {
  for (int i = aliens.size()-1; i >= 0; i--) {
    aliens.get(i).move();
    aliens.get(i).display();
    aliens.get(i).fire();
    if (aliens.get(i).isOffScreen()) {
      aliens.get(i).reposition();
    }
  }
}

void hitAliens() {
  for (int i = playerLasers.size()-1; i >= 0; i--) {
    for (int j = aliens.size()-1; j >= 0; j--) {
      if (rectIsIntersectingRect(playerLasers.get(i).x,playerLasers.get(i).y,playerLasers.get(i).w,playerLasers.get(i).h,aliens.get(j).x,aliens.get(j).y,aliens.get(j).w,aliens.get(j).h)) {
        alienIsHit = true;
        drawNewAlienExplosion(alienExplosionWeight,aliens.get(j).x + aliens.get(j).w/2,aliens.get(j).y + aliens.get(j).h/2,4,4);
        aliens.remove(j);
      }
    }
    if (alienIsHit) {
        playerLasers.remove(i);
        alienIsHit = false;
        numberOfAliensHitTotal++;
        numberOfAliensHitHere++;
        money++;
        money++;
      }
  }
}

void spawnAliens() {
  if (alienCanSpawn) {
    alienCanSpawn = false;
    numberOfAliensSpawnedHere++;
    aliens.add(new Alien(randX(),randY()));
  }
  if (!alienCanSpawn) {
    alienSpawnCooldown++;
    if (alienSpawnCooldown > alienSpawnRate && numberOfAliensSpawnedHere < maxNumberOfAliens) {
      alienCanSpawn = true;
      alienSpawnCooldown = 0;
    }
  }
  if (aliens.size() == 0 && numberOfAliensSpawnedHere == maxNumberOfAliens) {
   inCombat = false;
  }
}

void playerHealthHUD() {
  for (int i = playerHealth.size()-1; i >= 0; i--) {
    playerHealth.get(i).display();
  }
}

void playerFireHUD() {
  if (playerHasStartingWeapon) {
    fireWeaponHUD(25,925,200,50);
  }
}

void fireWeaponHUD(int x, int y, int w, int h) {
  if (!playerCanFire) {
    fireCooldownHUDWidth = (w/playerFireRate) * (playerFireRate-cooldownFire);
    stroke(200);
  } else {
    stroke(255,0,0);
  }
  fill(255,255,100);
  
  strokeWeight(5);
  rect(x,y,w,h);
  fill(0);
  textSize(40);
  fill(150);
  strokeWeight(3);
  rect(x+w,y,-fireCooldownHUDWidth,h);
}

void moneyCountHUD(int m, float x, float y, float w, float h) {
  noStroke();
  image(coins,x,y,w,h);
  textSize((w/moneyDisplayWidth)*500); // 36
  fill(255);
  text("x",x+w,y+h-15);
  text(m,x+w+25+w/moneyDisplayWidth*100,y+h-13.5);
}

void shopButton() {
  fill(200);
  stroke(100);
  strokeWeight(5);
  rect(shopButtonPos.x,shopButtonPos.y,shopButtonWidth,shopButtonWidth);
  image(cart,shopButtonPos.x,shopButtonPos.y,shopButtonWidth,shopButtonWidth);
}

void drawShop() {
  if (instanceTimer == 0) {
    playerWidth *= 3;
    playerHeight *= 3;
    playerPos.x = width/2-playerWidth/2;
    playerPos.y = 516.5;
    
    // TODO - implement this random somewhere where jt wont re-generate multiple times in same instance
    
  }
  
  // background
  fill(200);
  stroke(100);
  strokeWeight(20);
  rect(0,0,width,height);
  
  //player in shop
  fill(200);
  stroke(100);
  strokeWeight(10);
  rect(657,500,playerWidth+25,500);
  
  drawExplosions();
  
  // choose shop
  if (inWeaponShop) {
    if (!mousePressed) {
    resetWeaponItemPositions();
    }
    weaponShop();
  }
  if (inHullShop) {
    if (!mousePressed) {
    resetHullItemPositions();
    }
    hullShop();
  }
  
  
  // currency display
  moneyCountHUD(money,10,10,moneyDisplayWidth/10,moneyDisplayHeight/10);
  
  
  instanceTimer++;
  exitShop();
  
  player(); 
}

void weaponShop() {
  // title
  fill(200);
  stroke(100);
  strokeWeight(10);
  rect(290,0,1010,80);
  textSize(60);
  fill(0);
  text("The InterGalactic Weapons Market",300,60);
  
  // fire rate
  fill(0);
  textSize(40);
  if (playerMaxedFireRate) {
    text("Fire Rate (MAX)",1120,250);
  } else {
    text("Fire Rate (" + fireRateUpgradesBought + ")",1120,250);
  }
  textSize(30);
  text("+" + round(fireRateIncrease) + "%",1150,280);
  fill(255,255,100);
  stroke(0,255,0);
  strokeWeight(5);
  ellipse(fireRateItemPos.x,fireRateItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(fireRateUpgradeCost,1120,400,moneyDisplayWidth/15,moneyDisplayHeight/15);
  
  // laser speed
  fill(0);
  textSize(40);
  if (playerMaxedLaserSpeed) {
    text("Laser Speed (MAX)",1120,650);
  } else {
    text("Laser Speed (" + laserSpeedUpgradesBought + ")",1120,650);
  }
  textSize(30);
  text("+" + round((laserSpeedIncrease - 1)*100) + "%",1150,680);
  fill(255,255,100);
  stroke(0,255,0);
  strokeWeight(5);
  ellipse(laserSpeedItemPos.x,laserSpeedItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(laserSpeedUpgradeCost,1120,800,moneyDisplayWidth/15,moneyDisplayHeight/15);
  
  // Autofire
  fill(0);
  textSize(40);
  if (playerHasAutofire) {
    text("Autofire Mode (MAX)",200,250);
  } else {
    text("Autofire Mode",200,250);
  }
  
  textSize(20);
  text("Unlocks Autofire Mode, toggled by F",200,275);
  fill(0,198,147);
  stroke(0,255,0);
  strokeWeight(5);
  ellipse(autofireItemPos.x,autofireItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(autofireUpgradeCost,250,400,moneyDisplayWidth/15,moneyDisplayHeight/15);
  
  // backward fire
  fill(0);
  textSize(40);
  if (playerHasBackwardFire) {
    text("Backward Fire (MAX)",200,650);
  } else {
    text("Backward Fire",200,650);
  }
  textSize(20);
  text("Unlocks Backward Fire Mode",200,675);
  fill(0,198,147);
  stroke(0,255,0);
  strokeWeight(5);
  ellipse(backwardFireItemPos.x,backwardFireItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(backwardFireUpgradeCost,250,800,moneyDisplayWidth/15,moneyDisplayHeight/15);
}

void hullShop() {
  // title
  fill(200);
  stroke(100);
  strokeWeight(10);
  rect(440,0,690,80);
  textSize(60);
  fill(0);
  text("Hulls, Boosters & More",450,60);
  
  // Heart Up
  fill(0);
  textSize(40);
  text("Heart Up",670,200);
  textSize(30);
  text("+1 heart",680,230);
  image(heart,heartItemPos.x,heartItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(heartUpgradeCost,680,350,moneyDisplayWidth/15,moneyDisplayHeight/15);
  
  // Player Speed Upgrade
  fill(0);
  textSize(40);
  if (playerMaxedPlayerSpeed) {
    text("Player Speed (MAX)",1120,250);
  } else {
    text("Player Speed (" + playerSpeedUpgradesBought + ")",1120,250);
  }
  textSize(30);
  text("+" + round((playerSpeedIncrease - 1)*100) + "%",1150,280);
  fill(255,255,100);
  stroke(0,255,0);
  strokeWeight(5);
  ellipse(playerSpeedItemPos.x,playerSpeedItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter);
  moneyCountHUD(playerSpeedUpgradeCost,1120,400,moneyDisplayWidth/15,moneyDisplayHeight/15);
}

void resetWeaponItemPositions() {
  // Fire Rate
  fireRateItemPos.x = 1200;
  fireRateItemPos.y = 350;
  
  // Laser Speed
  laserSpeedItemPos.x = 1200;
  laserSpeedItemPos.y = 750;
  
  //Autofire
  autofireItemPos.x = 320;
  autofireItemPos.y = 350;
  
  // Backward Fire
  backwardFireItemPos.x = 320;
  backwardFireItemPos.y = 750;
}

void resetHullItemPositions() {
  // heart up
  heartItemPos.x = 700;
  heartItemPos.y = 250;
  
  // player speed upgrade
  playerSpeedItemPos.x = 1200;
  playerSpeedItemPos.y = 350;
}

void exitShop() {
  // exit sign
  noFill();
  stroke(255,0,0);
  strokeWeight(5);
  rect(664,933.5,playerWidth + 12,60);
  fill(255,0,0);
  text("EXIT",696,933.5,playerWidth + 12, 60);
  image(arrow,710,770,arrowWidth/5,arrowHeight/5);
  
  // player exits
  if (playerPos.y > height) {
    playerWidth /= 3;
    playerHeight /= 3;
    inShop = false;
    inWeaponShop = false;
    inHullShop = false;
    instanceTimer = 0;
    if (planets.get(0).x > 0 && planets.get(0).x < width && planets.get(0).y > 0 || planets.get(0).y < height) {
      playerPos.x = planets.get(0).x - playerWidth/2;
      playerPos.y = planets.get(0).y - playerHeight/2;
    } else {
      playerPos.x = randX();
      playerPos.y = randY();
    }
  }
}

void player() {
  movePlayer();
  if (inCombat) {
   hitPlayer();
  }
   if (!inFirstInstance) { playerLaserLoop(); }
  image(playerImg,playerPos.x,playerPos.y,playerWidth,playerHeight);
}




void hitPlayer() {
  if (playerIsHit()) {
    if (playerHealth.size() > 1) {
      removeThisPlayerHealth(1);
      drawNewFriendlyExplosion(playerExplosionWeight,playerPos.x + playerWidth/2,playerPos.y + playerHeight/2,5,5);
    } else {
      if (playerHealth.size() > 0) {removeThisPlayerHealth(1);}
      gameIsLost = true;
      drawNewFriendlyExplosion(playerExplosionWeight*4,playerPos.x + playerWidth/2,playerPos.y + playerHeight/2,5,5);
      for (int i = aliens.size()-1; i >= 0; i--) {
        drawNewAlienExplosion(50,aliens.get(i).x + aliens.get(i).w/2,aliens.get(i).y + aliens.get(i).h/2,4,4);
        aliens.remove(i);
      }
    }
  }
}

void playerLaserLoop() {
  playerFire();
  playerLaserDraw();
}

void playerLaserDraw() {
  fill(0,255,0);
  for (int i = playerLasers.size()-1; i >= 0; i--) {
    playerLasers.get(i).move();
    playerLasers.get(i).display();
    if (playerLasers.get(i).isOffScreen()) {
      playerLasers.remove(i);
    }
  }
}

void playerFire() {
  if (!playerCanFire) {
    cooldownFire++;
    if (cooldownFire > playerFireRate) {
      playerCanFire = true;
      cooldownFire = 0;
    }
  }
  if (playerCanFire && (spaceIsPressed || playerIsAutofiring)) {
    if (spaceIsPressed) { spaceIsPressed = false; }
    playerLasers.add(new PlayerLaser(0,playerPos.x + playerWidth/2 - laserWidth/2,playerPos.y -laserHeight/2));
    if (playerHasBackwardFire) { playerLasers.add(new PlayerLaser(1,playerPos.x + playerWidth/2 - laserWidth/2,playerPos.y -laserHeight/2)); }
    playerCanFire = false;
  }
  
  if (playerHasAutofire && FIsPressed) {
    FIsPressed = false;
    if (playerIsAutofiring) {
      playerIsAutofiring = false;
    } else {
      playerIsAutofiring = true;
    }
  }
}

void drawExplosions() {
  drawAlienExplosions();
  drawFriendlyExplosions();
  decayExplosions();
}

void drawAlienExplosions() {
  fill(255,0,0); // alien explosions
  for (int i = alienExplosions.size()-1; i >= 0; i--) {
    alienExplosions.get(i).display();
    alienExplosions.get(i).move();
    if (alienExplosions.get(i).isOffScreen()) {
      alienExplosions.remove(i);
      alienExplosionsRemoved++;
    }
  }
}

void drawFriendlyExplosions() {
  fill(0,255,0); // friendly explosions
  for (int i = friendlyExplosions.size()-1; i >= 0; i--) {
    friendlyExplosions.get(i).display();
    friendlyExplosions.get(i).move();
    if (friendlyExplosions.get(i).isOffScreen()) {
      friendlyExplosions.remove(i);
      friendlyExplosionsRemoved++;
    }
  }
}

void decayExplosions() {
  
  if (currentAlienExplosions > 0 && alienExplosions.size() > 0 && !gameIsLost) {
    for (int i = 0; i < currentAlienExplosions && alienExplosions.size() > 0; i++) {
      alienExplosions.remove(int(random(alienExplosions.size()-1)));
      alienExplosionsRemoved++;
    }
  }
  
  if (alienExplosionsRemoved >= alienExplosionWeight) {
    currentAlienExplosions--;
    alienExplosionsRemoved = 0;
  }
  
  if (currentFriendlyExplosions > 0 && friendlyExplosions.size() > 0 && !gameIsLost) {
    for (int i = 0; i < currentFriendlyExplosions && friendlyExplosions.size() > 0; i++) {
      friendlyExplosions.remove(int(random(friendlyExplosions.size()-1)));
      friendlyExplosionsRemoved++;
      if (rand100() <= 75 && friendlyExplosions.size()-1 > 0) { friendlyExplosions.remove(int(random(friendlyExplosions.size()-1))); friendlyExplosionsRemoved++; }
    }
  }
  
  if (friendlyExplosionsRemoved >= playerExplosionWeight) {
    currentFriendlyExplosions--;
    friendlyExplosionsRemoved = 0;
  }
  
}

void drawLose() {
  fill(255);
  text("You Lose!",700,500);
  text("Score: " + numberOfAliensHitTotal,700,530);
  
}

void keyPressed() {
  controlsPress();
  if (inStart) { inStart = false; controlsReset(); inFirstInstance = true; }
}

void keyReleased() {
  controlsRelease();
}

void mousePressed() {
  pressShop();
}
void mouseDragged() {
  dragUpgrades();
}

void initializeBackground() {
  for (int i = 0; i < starCount; i++) {
    starPos[i] = new PVector(randX(),randY());
  }
}

void initializeImages() {
  playerImg = loadImage("ship.png"); // ship from Galaga
  heart = loadImage("heart.png");
  cart = loadImage("cart.png");
  coins = loadImage("coins.png");
  arrow = loadImage("arrow.png");
}

void initializeStartingValues() {
  addThisPlayerHealth(playerStartingHealth);
}

void drawBackground() {
  noStroke();
  fill(0,motionBlurStrength);
  rect(0,0,width,height); // motion blur area
  //fill(255);
  for (int i = 0; i < starCount; i++) { // stars
    if (inStart) { fill(randColor()); }
    if (!backgroundDrawn) { backgroundColor[i] = randColor(); }
    fill(backgroundColor[i]);
    rect(starPos[i].x,starPos[i].y,5,5);
    starPos[i].y += starSpeed; // star speed
    if (starPos[i].y > height) {
      starPos[i].y = 0;
      starPos[i].x = randX();
      backgroundColor[i] = randColor();
      fill(backgroundColor[i]);
    }
  }
  if (!backgroundDrawn) {
    backgroundDrawn = true;
  }
    
}

void drawEnvironment() {
  planets();
}

void planets() {
  if (inFirstInstance) {
      generatePlanet(); 
  } else if (inFriendlyTransit && (instanceTimer % 100) == 0) {
    amountOfPlanets = int(random(1,4));
    generatePlanetChance = generatePlanetFails * 15;
    if (rand100() <= generatePlanetChance) {
      generatePlanetFails = 0;
      generatePlanet();
    } else {
      generatePlanetFails++;
    }
  }
  if (planets.size() < 1) { amountOfPlanets = 0; }
  drawPlanet();

}

void generatePlanet() {
  if (planets.size() < amountOfPlanets) {
     for (int i = 0; i < amountOfPlanets; i++) {
      planets.add(new Planet());
    }
    for (int i = planets.size()-1; i >= 0; i--) {
      planets.get(i).generate();
    } 
  }
  
}

void drawPlanet() {
  
  for (int i = planets.size()-1; i >= 0; i--) {
    planets.get(i).display();
    planets.get(i).move();
    if (planets.get(i).isOffScreen()) {
      planets.remove(i);
    }
  }
  
 // if (planets.size() > 0 && amountOfPlanets == 0) {
 //   for (int i = planets.size()-1; i >= 0; i--) {
 //     planets.remove(i);
 //   }
 // }
}


void addThisPlayerHealth(int h) {
  for (int i = 0; i < h; i++) {
    playerHealth.add(new PlayerHealth(10 + (playerHealth.size()*40),10));
  }
}

void removeThisPlayerHealth(int h) {
  for (int i = 0; i < h; i++) {
    playerHealth.remove(playerHealth.size()-1);
  }
}

void drawNewAlienExplosion(int s, float x, float y, int w, int h) {
  for (int i = 0; i < s; i++) {
    alienExplosions.add(new Explosion(x,y,w,h));
  }
  currentAlienExplosions++;
}

void drawNewFriendlyExplosion(int s, float x, float y, int w, int h) {
  for (int i = 0; i < s; i++) {
    friendlyExplosions.add(new Explosion(x,y,w,h));
  }
  currentFriendlyExplosions++;
}


float rand100() { return (random(99) + 1); }
int randX() { return int(random(width)); }
int randY() { return int(random(height)); }
int randColor() { return int(random(255)); }

boolean rectIsIntersectingRect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return (
             (x1 >= x2 && x1 <= x2+w2 && y1 >= y2 && y1 <=y2+h2) // top left point 1 
           ||(x1+w1 >= x2 && x1+w1 <= x2+w2 && y1 >= y2 && y1 <=y2+h2) // top right point 1 
           ||(x1 >= x2 && x1 <= x2+w2 && y1+h1   >= y2 && y1+h1 <=y2+h2) // bottom left point 1 
           ||(x1+w1 >= x2 && x1+w1 <= x2+w2 && y1+h1 >= y2 && y1+h1 <=y2+h2) // bottom right point 1
           
           ||(x2 >= x1 && x2 <= x1+w1 && y2 >= y1 && y2 <=y1+h1) // top left point 2
           ||(x2+w2 >= x1 && x2+w2 <= x1+w1 && y2 >= y1 && y2 <=y1+h1) // top right point 2 
           ||(x2 >= x1 && x2 <= x1+w1 && y2+h2   >= y1 && y2+h2 <=y1+h1) // bottom left point 2
           ||(x2+w2 >= x1 && x2+w2 <= x1+w1 && y2+h2 >= y1 && y2+h2 <=y1+h1) // bottom right point 2
         );
}

boolean mouseIsInsideRect(float x, float y, float w, float h) {
  return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
}

boolean pointIsIntersectingEllipse(float x1, float y1, float x2, float y2, int r2) {
  float dist = sqrt(sq((x2-x1))+sq((y2-y1)));
  return dist <= r2;
}


boolean playerIsHit() {
  // player hits laser
  for (int i = alienLasers.size()-1; i >= 0; i--) {
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerHeight,alienLasers.get(i).x,alienLasers.get(i).y,alienLasers.get(i).w,alienLasers.get(i).h)) {
      alienLasers.remove(i);
      return true;
    }
  }
  // player hits alien
  for (int i = aliens.size()-1; i >= 0; i--) {
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerHeight,aliens.get(i).x,aliens.get(i).y,aliens.get(i).w,aliens.get(i).h)) {
      drawNewAlienExplosion(alienExplosionWeight,aliens.get(i).x + aliens.get(i).w/2,aliens.get(i).y + aliens.get(i).h/2,4,4);
      aliens.remove(i);
      numberOfAliensHitTotal++;
      numberOfAliensHitHere++;
      money++;
      money++;
      return true;
    }
  }
  return false;
}

float pointToPointAngle(float sx, float sy, float tx, float ty) { // credit to StackOverflow user: "Mike Nakis"
  return atan2(tx-sx, ty-sy);
}

//// Classes ////

class PlayerHealth {
  float x;
  float y;
  float w = 191/5;
  float h = 165/5;
  
  PlayerHealth(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void display() {
    noStroke();
    image(heart,x,y,w,h);
  }
}

class PlayerLaser {

  float x;
  float y;
  int w = 10;
  int h = 20;
  float ySpeed = playerLaserSpeed;
  int dir;
  
  PlayerLaser(int dir, float x, float y){
    this.x = x;
    this.y = y;
    this.dir = dir;
  }
 
  void move() {
    if (dir == 0) {
      y -= ySpeed;
    } else {
      y += ySpeed;
    }
  }

  void display() {
    stroke(0,255,0);
    strokeWeight(1);
    fill(255,255,100);
    rect(x, y, w, h);
  }
  
  boolean isOffScreen(){
    return (x < 0 || x > width || y < 0 || y > height);
  }
}

class Alien {
  float x;
  float y;
  int w = 30;
  int h = 30;
  int alienFireCooldown = 0;
  
  float xSpeed = (random(1) + 1) +instancesTraveled/20;
  float ySpeed = (random(1) + 1) +instancesTraveled/20;
  
  int moveType = int(random(3) + 1);
  int weaponType = int(random(3) + 1);
  
  Alien(float x, float y){
    if (weaponType == 1) {
      this.y = random(300) + 1;
      moveType = weaponType;
    } else {
      this.y = y;
    }
    this.x = x;
    
    if (rand100() <= 50) { xSpeed *= -1; }
    if (rand100() <= 25) { ySpeed *= -1; }
  }
  
  void move() {
    if (moveType == 1) {
      x += xSpeed;
    } else if (moveType == 2) {
      y += ySpeed;
    } else if (moveType == 3) {
      x += xSpeed;
      y += ySpeed;
    }
  }
  
  void display() {
    stroke(255,0,0);
    strokeWeight(4);
    if (weaponType == 1) { fill(0,0,255); }
    else if (weaponType == 2) { fill(226,10,255); }
    else if (weaponType == 3) { fill(255,10,174); }
    rect(x, y, w, h);
  }
  
  void fire() {
    float temp = alienFireRate() - instancesTraveled*2;
    if (temp < 20) {
      temp = 20;
    }
    if (alienFireCooldown > temp)  {
      alienLasers.add(new AlienLaser(x+w/2,y+h/2, weaponType));
      alienFireCooldown = 0;
    } else {
      alienFireCooldown++;
    }
  }
  
  void reposition() {
  moveType = int(random(3) + 1);
   if (weaponType == 1) {
     moveType = weaponType;
     y = random(300) + 1;
   } else {
     y = randY();
   }
   x = randX();
  }
  
  boolean isOffScreen(){
    return (x < 0 || x > width || y < 0 || y > height);
  }
  
  float alienFireRate() {
  return (random(50,500));
  }
}

class AlienLaser {

  float x;
  float y;
  int weaponType;
  int w;
  int h;
  float speed;
  int decayRate = 400;
  int decayTimer = 0;
  
  AlienLaser(float x, float y, int weaponType){
    this.weaponType = weaponType;
    if (weaponType == 1) {
     w = 10;
     h = 20;
     speed = 8 + instancesTraveled/4;
    } else if (weaponType == 2) {
     w = 20;
     h = 20;
     //speed = 0;
    } else if (weaponType == 3) {
     w = 20;
     h = 20;
     if (playerDeniedStartingWeapon) { speed = playerVel.x + 1; }
     else { speed = 2 + instancesTraveled/4; }
     while (speed > playerSpeed) {
       speed--;
     }
    }
    this.x = x - w/2;
    this.y = y - h/2;
    
  }
 
  void move() {
    if (weaponType == 1) {
      y += speed;
    } else if (weaponType == 2) {
     // does not move 
    } else if (weaponType == 3) {
      x += speed * sin(pointToPointAngle(x,y,playerPos.x+playerWidth/2,playerPos.y+playerWidth/2)); // move towards player
      y += speed * cos(pointToPointAngle(x,y,playerPos.x+playerWidth/2,playerPos.y+playerWidth/2));
    }
  }

  void display() {
    stroke(255,0,0);
    strokeWeight(1);
    if (weaponType == 1) {
      fill(0,0,255);
      rect(x, y, w, h);
    } else if (weaponType == 2) {
      fill(226,10,255);
      ellipseMode(CORNER);
      ellipse(x,y,w,h);
      ellipseMode(CENTER);
    } else if (weaponType == 3) {
      fill(255,10,174);
      triangle(x,y,x+w/2,y+h/2,x+w,y);
    }
  }
  
  boolean shouldRemove(){
    return (isOffScreen() || decayLaser());
  }
  
  boolean isOffScreen(){
    return (x < 0 || x > width || y < 0 || y > height);
  }
  
  boolean decayLaser(){
    if (playerDeniedStartingWeapon) { return false; }
    if (weaponType == 2) {
      if (decayTimer > decayRate) {
        decayTimer = 0;
        return true;
      } else { decayTimer++; }
    } else if (weaponType == 3) {
      if (decayTimer > decayRate/4) {
        decayTimer = 0;
        return true;
      } else {decayTimer++; }
    }
    return false;
  }
  
}

class Explosion {
  float x;
  float y;
  float w;
  float h;
  float xSpeed = random(-3, 3);
  float ySpeed = random(-3, 3);
  
  Explosion(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void move() {
    if (gameIsLost) { // space definitely has friction
      xSpeed *= .997;
      ySpeed *= .997; 
    } else {
      xSpeed *= .96;
      ySpeed *= .96; 
    }
    
    if (ySpeed <= .5) {
      y += starSpeed;
    }
    
    x += xSpeed;
    y += ySpeed;
  }
  
  void display() {
   noStroke();
   rect(x,y,w,h);
  }
  boolean isOffScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}

class Planet {
  float d;
  float r;
  float x;
  float y;
  
  float ySpeed = starSpeed*1.1;
  
  float fillColor1 = randColor();
  float fillColor2 = randColor();
  float fillColor3 = randColor();
  float strokeColor = randColor();
  float randStrokeWeight = int(random(5)+5);
  Planet() {}
  
  void move() {
    ySpeed = starSpeed*1.1;
    y += ySpeed;
  }
  
  void generate() {
    // basic values
    if (byPlanet) {
       d = randD() + 200;
       x = random(width/2+width/4,width-d);
       if (inFirstInstance) { y = random(height/2,height-d/2); } else {
         y = 0;
       }
    } else {
       d = randD();
       x = randPlanetX();
       y = randPlanetY();
    }
    r = d/2;
  }
  
  void display() {
    fill(fillColor1,fillColor2,fillColor3);
    stroke(strokeColor);
    strokeWeight(randStrokeWeight);
    ellipse(x,y,d,d);
  } //<>//
  
  float randD() { return random(150,400); }
  float randPlanetX() { return random(d,width-d); }
  
  float randPlanetY() {
    if (amountOfPlanets > 1) {
      return random(-d*5,-d);
    }
  return -d;
  }
  
  boolean isOffScreen() {
    return x < 0 || x > width || y-d-randStrokeWeight > height;
  }
  //float randXInPlanet() { return(random(x-r/1.5,x+r/1.5)); } // calculates from center for some reason
  //float randYInPlanet() { return(random(y-r/1.5,y+r/1.5)); } // calculates from center for some reason
}

void movePlayer() {
  if (!inShop) {
    if (playerPos.y > 0 && WIsPressed && !isTransitioningStarsToFaster) { playerPos.y-=playerVel.y; } // move up
    if (playerPos.y+playerHeight < height && SIsPressed) { playerPos.y+=playerVel.y; } // move down
    if (playerPos.x > 0 && AIsPressed) { playerPos.x-=playerVel.x; }                   // move left
    if (playerPos.x+playerWidth < width && DIsPressed) { playerPos.x+=playerVel.x; }  // move right
  } else {
   if (WIsPressed && playerPos.y > 516.5) {playerPos.y -= playerVel.y; } 
   if (SIsPressed) {playerPos.y += playerVel.y; } 
  }
  
  
}

void pressShop() {
  if (shopIsAvailable && !inShop && !shopHasBeenEntered && !inCombat && mouseIsInsideRect(shopButtonPos.x,shopButtonPos.y,shopButtonWidth,shopButtonWidth)) {
    inShop = true;
    shopHasBeenEntered = true;
    instanceTimer = 0;
  }
}

void dragUpgrades() {
  dragStartingWeapon();
  if (inShop) {
    if (inWeaponShop) {
      dragWeaponShopUpgrades();
    }
    if (inHullShop) {
      dragHullShopUpgrades();
    }
  }
  
}

void dragWeaponShopUpgrades() {
  // fire rate
  if (money >= fireRateUpgradeCost && !playerMaxedFireRate) {
    if (pointIsIntersectingEllipse(mouseX,mouseY,fireRateItemPos.x,fireRateItemPos.y,shopUpgradeDiameter)) {
      fireRateItemPos.x = mouseX;
      fireRateItemPos.y = mouseY;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,fireRateItemPos.x-shopUpgradeDiameter/2,fireRateItemPos.y-shopUpgradeDiameter/2,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,fireRateItemPos.x,fireRateItemPos.y,5,5);
      fireRateItemPos.x = 1200;
      fireRateItemPos.y = 350;
      if (playerFireRate > 20) {
        playerFireRate -= fireRateIncrease;
      } else {
        playerFireRate *= .6;
      }
      fireRateUpgradesBought++;
      if (playerFireRate < 1) {
        playerFireRate = 1;
        playerMaxedFireRate = true;
      }
      money -= fireRateUpgradeCost;
      fireRateUpgradeCost = round(fireRateUpgradeCost*costScaling);
      
    }
  }
  
  // laser speed
  if (money >= laserSpeedUpgradeCost && !playerMaxedLaserSpeed) {
    if (pointIsIntersectingEllipse(mouseX,mouseY,laserSpeedItemPos.x,laserSpeedItemPos.y,shopUpgradeDiameter)) {
      laserSpeedItemPos.x = mouseX;
      laserSpeedItemPos.y = mouseY;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,laserSpeedItemPos.x-shopUpgradeDiameter/2,laserSpeedItemPos.y-shopUpgradeDiameter/2,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,laserSpeedItemPos.x,laserSpeedItemPos.y,5,5);
      laserSpeedItemPos.x = 1200;
      laserSpeedItemPos.y = 350;
      playerLaserSpeed *= laserSpeedIncrease;
      laserSpeedUpgradesBought++;
      if (playerLaserSpeed > 15) {
        playerLaserSpeed = 15;
        playerMaxedLaserSpeed = true;
      }
      money -= laserSpeedUpgradeCost;
      laserSpeedUpgradeCost = round(laserSpeedUpgradeCost*costScaling);
    }
  }
  
  // auto fire mode
  if (money >= autofireUpgradeCost && !playerHasAutofire) {
    if (pointIsIntersectingEllipse(mouseX,mouseY,autofireItemPos.x,autofireItemPos.y,shopUpgradeDiameter)) {
      autofireItemPos.x = mouseX;
      autofireItemPos.y = mouseY;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,autofireItemPos.x-shopUpgradeDiameter/2,autofireItemPos.y-shopUpgradeDiameter/2,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,autofireItemPos.x,autofireItemPos.y,5,5);
      autofireItemPos.x = 320;
      autofireItemPos.y = 350;
      playerHasAutofire = true;
      money -= autofireUpgradeCost;
    }
  }
  
  // backward fire mode
  if (money >= backwardFireUpgradeCost && !playerHasBackwardFire) {
    if (pointIsIntersectingEllipse(mouseX,mouseY,backwardFireItemPos.x,backwardFireItemPos.y,shopUpgradeDiameter)) {
      backwardFireItemPos.x = mouseX;
      backwardFireItemPos.y = mouseY;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,backwardFireItemPos.x-shopUpgradeDiameter/2,backwardFireItemPos.y-shopUpgradeDiameter/2,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,backwardFireItemPos.x,backwardFireItemPos.y,5,5);
      autofireItemPos.x = 320;
      autofireItemPos.y = 750;
      playerHasBackwardFire = true;
      money -= backwardFireUpgradeCost;
    }
  }
}

void dragHullShopUpgrades() {
  // Heart Up
  if (money >= heartUpgradeCost) {
    if (mouseIsInsideRect(heartItemPos.x,heartItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter)) {
      heartItemPos.x = mouseX - shopUpgradeDiameter/2;
      heartItemPos.y = mouseY - shopUpgradeDiameter/2;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,heartItemPos.x,heartItemPos.y,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,heartItemPos.x,heartItemPos.y,5,5);
      heartItemPos.x = 700;
      heartItemPos.y = 250;
      money -= heartUpgradeCost;
      addThisPlayerHealth(1);
    }
  }
  
  //Player Speed
  if (money >= playerSpeedUpgradeCost && !playerMaxedPlayerSpeed) {
    if (pointIsIntersectingEllipse(mouseX,mouseY,playerSpeedItemPos.x,playerSpeedItemPos.y,shopUpgradeDiameter)) {
      playerSpeedItemPos.x = mouseX;
      playerSpeedItemPos.y = mouseY;
    }
    if (rectIsIntersectingRect(playerPos.x,playerPos.y,playerWidth,playerWidth,playerSpeedItemPos.x-shopUpgradeDiameter/2,playerSpeedItemPos.y-shopUpgradeDiameter/2,shopUpgradeDiameter,shopUpgradeDiameter)) {
      drawNewFriendlyExplosion(playerExplosionWeight,playerSpeedItemPos.x,playerSpeedItemPos.y,5,5);
      playerSpeedItemPos.x = 1200;
      playerSpeedItemPos.y = 350;
      playerSpeed *= playerSpeedIncrease;
      playerVel.x = playerSpeed;
      playerVel.y = playerSpeed;
      playerSpeedUpgradesBought++;
      if (playerSpeed > 7.5) {
        playerSpeed = 7.5;
        playerMaxedPlayerSpeed = true;
      }
      money -= playerSpeedUpgradeCost;
      playerSpeedUpgradeCost = round(playerSpeedUpgradeCost*costScaling);
    }
  }
}

void dragStartingWeapon() {
  // starting Weapon
  int forgiveDistance = 10;
  if (!(startingWeaponPos.x-startingWeaponDiameter/2 > 0 && startingWeaponPos.x+startingWeaponDiameter/2 < width && startingWeaponPos.y-startingWeaponDiameter/2 > 0 && startingWeaponPos.y+startingWeaponDiameter/2 < height)
      && instanceTimer > 0) {
    startingWeaponPos.x = planets.get(0).x-planets.get(0).d/4;
    startingWeaponPos.y = planets.get(0).y-planets.get(0).d/2.2;
  }
  if (!playerHasStartingWeapon && !playerDeniedStartingWeapon && pointIsIntersectingEllipse(mouseX,mouseY,startingWeaponPos.x,startingWeaponPos.y,startingWeaponDiameter+forgiveDistance)) {
    startingWeaponPos.x = mouseX;
    startingWeaponPos.y = mouseY;
    forgiveDistance = 100;
  } else {
    forgiveDistance = 10;
  }
}
void controlsPress() {
  if (key == 'w') { WIsPressed = true; }
  if (key == 's') { SIsPressed = true; }
  if (key == 'a') { AIsPressed = true; }
  if (key == 'd') { DIsPressed = true; }
  
  if (keyCode == 32) { spaceIsPressed = true; }
  if (key == 'f') { FIsPressed = true; }
  
  if (keyCode == 38) { upArrowIsPressed = true; }
  if (keyCode == 40) { downArrowIsPressed = true; }
  if (keyCode == 37) { leftArrowIsPressed = true; }
  if (keyCode == 39) { rightArrowIsPressed = true; }
  
}

void controlsRelease() {
  if (key == 'w') { WIsPressed = false; }
  if (key == 's') { SIsPressed = false; }
  if (key == 'a') { AIsPressed = false; }
  if (key == 'd') { DIsPressed = false; }
  
  if (keyCode == 32) { spaceIsPressed = false; }
  if (key == 'f') { FIsPressed = false; }
  
  if (keyCode == 38) { upArrowIsPressed = false; }
  if (keyCode == 40) { downArrowIsPressed = false; }
  if (keyCode == 37) { leftArrowIsPressed = false; }
  if (keyCode == 39) { rightArrowIsPressed = false; }
}

void controlsReset() {
  WIsPressed = false;
  SIsPressed = false;
  AIsPressed = false;
  DIsPressed = false;
  spaceIsPressed = false;
}
