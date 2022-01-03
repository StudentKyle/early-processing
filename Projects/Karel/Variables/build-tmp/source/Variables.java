import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Stack; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Variables extends PApplet {

World world;
ArrayList<Robot> robots;

public void setup() {
  
  
  world = new World("minefield.kwld");
  robots = new RobotLoader().load("minefield.krbs", world);

  world.setDelay(25);
  
  println("\nPress space to start");
}

public void draw() {
  background(0xffeeeeee);
  world.draw();
  
  for (Robot robot : robots) {
    robot.draw();
  }
}

int pics = 0;
boolean started = false;
public void keyPressed() {
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
class Robot extends ExceptionalRobot {
  
  Robot (String name, World world, int x, int y, int dir, int beepers) {
    super(name, world, x, y, dir, beepers);
  }

  public void commands() {
  	clearRows();
    goHome();
  	turnOff();
  }

  public void clearRows() {
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

  public void clearRow() {
  	pickStackOfBeepers();
  	while(frontIsClear()) {
  		move();
  		pickStackOfBeepers();
  	}
  }

  public void pickStackOfBeepers() {
  	while (nextToABeeper()) {
  		pickBeeper();
  	}
  }

  public void faceIntoRow() {
  	turnLeft();
  	if (!frontIsClear()) {
  		turnAround();
  	}
  }

  public void turnAround() {
  	turnLeft();
  	turnLeft();
  }

  public void faceNorth() {
  	while (!facingNorth()) {
  		turnLeft();
  	}
  }

  public void faceEast() {
  	while (!facingEast()) {
  		turnLeft();
  	}
  }

  public void faceWest() {
    while (!facingWest()) {
      turnLeft();
    }
  }

  public void faceSouth() {
    while (!facingSouth()) {
      turnLeft();
    }
  }

  public void moveToWall() {
    while (frontIsClear()) {
      move();
    }
  }

  public void goHome() {
    faceSouth();
    moveToWall();
    
    faceWest();
    moveToWall();
    
    faceEast();
  }


};


class World {
  int ROW_COLOR = 0xffaa0000;
  int COL_COLOR = 0xffaa0000;
  int FONT_COLOR = 0;

  public int WALL_COLOR = 0;

  int rows;
  int cols;
  int colWidth;
  int rowHeight;

  Stack<Beeper>[][] beepers;
  int beeperSize, beeperFontSize;

  ArrayList<Wall> walls;
  int wallWidth;

  int delay = 100;

  World(String file) {
    BufferedReader reader = createReader(file);
    String line = null;

    try {
      line = reader.readLine();
      line = reader.readLine();
      
      String[] pieces = split(line, " ");
      this.rows = PApplet.parseInt(pieces[1]);
      
      line = reader.readLine();
      pieces = split(line, " ");
      
      this.cols = PApplet.parseInt(pieces[1]);
      this.colWidth  = PApplet.parseInt(width*0.9f/cols);
      this.rowHeight = PApplet.parseInt(height*0.9f/rows);
      
      this.beepers = (Stack<Beeper>[][]) new Stack[this.rows][this.cols];
      beeperSize = min(colWidth, rowHeight)/2;
      beeperFontSize = PApplet.parseInt(min(100.0f/rows + 8, 100.0f/cols + 8)*0.85f);
      
      walls = new ArrayList<Wall>();
      walls.add(new EastWestWall(0, 1, cols+5));
      walls.add(new NorthSouthWall(0, 1, rows+5));
      wallWidth = PApplet.parseInt(beeperSize/4.0f);
    } catch (IOException e) {
      e.printStackTrace();
    }

    
      try {
        while (line != null) {
          line = reader.readLine();
          // println(line);

          if (line != null) {
            String[] pieces = split(line, " ");
            if ("beepers".equals(pieces[0])) {
              int row = PApplet.parseInt(pieces[1])-1;
              int col = PApplet.parseInt(pieces[2])-1;
              int n   = PApplet.parseInt(pieces[3]);
              beepers[row][col] = new Stack<Beeper>();
              for (int i = 0; i < n; ++i) {
                beepers[row][col].push(new Beeper(this));
              }
            } else if ("eastwestwalls".equals(pieces[0])) {
              int row = PApplet.parseInt(pieces[1]);
              int col = PApplet.parseInt(pieces[2]);
              int n   = PApplet.parseInt(pieces[3]);
              walls.add(new EastWestWall(row, col));
            } else if ("northsouthwalls".equals(pieces[0])) {
              int row = PApplet.parseInt(pieces[1]);
              int col = PApplet.parseInt(pieces[2]);
              int n   = PApplet.parseInt(pieces[3]);
              walls.add(new NorthSouthWall(row, col));
            } else if ("randombeepers".equals(pieces[0])) {
              addRandomBeepers(
                new PVector(PApplet.parseInt(pieces[1]), PApplet.parseInt(pieces[2])), 
                new PVector(PApplet.parseInt(pieces[3]), PApplet.parseInt(pieces[4])),
                PApplet.parseInt(pieces[5]),
                PApplet.parseInt(pieces[6]), PApplet.parseInt(pieces[7])
              );
            }
          }
        }
      } catch (IOException e) {
        e.printStackTrace();
      } finally {
        try {
          reader.close();
        } catch(IOException e) {
          e.printStackTrace();
        }
      }
  }

  World(int rows, int cols){
    this.rows = rows;
    this.cols = cols;
    this.colWidth  = PApplet.parseInt(width*0.8f/cols);
    this.rowHeight = PApplet.parseInt(height*0.8f/rows);
    beepers = (Stack<Beeper>[][]) new Stack[rows][cols];
    beeperSize = min(colWidth, rowHeight)/2;
    beeperFontSize = PApplet.parseInt(min(100.0f/rows + 8, 100.0f/cols + 8)*0.85f);
    walls = new ArrayList<Wall>();
    // left and bottom boundaries
    walls.add(new EastWestWall(0, 1, cols+5));
    walls.add(new NorthSouthWall(0, 1, rows+5));
    walls.add(new NorthSouthWall(1, 1, 5));
    wallWidth = PApplet.parseInt(beeperSize/4.0f);
  }

  public void draw() {
    drawRows();
    drawCols();
    drawBeepers();
    drawWalls();
  }

  public int wallWidth() {
    return wallWidth;
  }

  public int colWidth() {
    return colWidth;
  }

  public int rowHeight() {
    return rowHeight;
  }

  public void setDelay(int delay) {
    this.delay = delay;
  }

  public float robotSize() {
    return min(colWidth, rowHeight)/1.5f;
  }


  public void addRandomBeepers(PVector start, PVector end, 
    int squares, int min, int max) {
    // start = PVector.sub(start, new PVector(1, 1));
    // end  = PVector.sub(end   , new PVector(1, 1));

    int length = abs(PApplet.parseInt(start.x - end.x)) + 1;
    int width  = abs(PApplet.parseInt(start.y - end.y)) + 1;
    int area = length*width;

    if (squares == -1) { // 50-50
      for (int i = 0; i < length; ++i) {
        for (int j = 0; j < width; ++j) {
          PVector rp = new PVector(i+start.x, j+start.y);
          int yes = PApplet.parseInt(random(0, 2));
          if (yes == 0) {
            int n = PApplet.parseInt(random(min, max + 1));
            for (int k = 0; k < n; ++k) {
              putBeeperAt(rp);
            }
          }
           
        }
      }
    } else if (squares >= area) {
      for (int i = 0; i < length; ++i) {
        for (int j = 0; j < width; ++j) {
           PVector rp = new PVector(i+start.x, j+start.y);
           int n = PApplet.parseInt(random(min, max + 1));
           for (int k = 0; k < n; ++k) {
             putBeeperAt(rp);
           }
        }
      }
    } else {
      while (squares > 0) {
        int l = PApplet.parseInt(random(length));
        int w = PApplet.parseInt(random(width));
        int n = PApplet.parseInt(random(min, max));

        PVector rp = new PVector(l+start.x, w+start.y);

        while (hasBeeperAt(rp)) {
          l = PApplet.parseInt(random(length));
          w = PApplet.parseInt(random(width));
          rp = new PVector(l+start.x, w+start.y);
        }

        for (int i = 0; i < n; ++i) {
          putBeeperAt(rp);
        }

        squares --;
      }
    }
  }

  public void drawBeepers() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (beepers[i][j] != null && !beepers[i][j].empty()) {
          beepers[i][j].peek().draw(
            coords(i+1,j+1), 
            beepers[i][j].size(),
            true);
        }
      }
    }
  }

  public void drawWalls() {
    for (Wall wall : walls) {
      wall.draw(this);
    }
  }

  public PVector coords(PVector p) {
    return coords(PApplet.parseInt(p.x), PApplet.parseInt(p.y));
  }

  public PVector coords(int row, int col) {
    int x = PApplet.parseInt(width*0.1f)+colWidth*col-colWidth/2;
    int y = PApplet.parseInt(height*0.9f)-rowHeight*row+rowHeight/2;
    return new PVector(x, y);
  }

  public void drawRows() {
    stroke(ROW_COLOR);
    strokeWeight(1);

    // font
    fill(FONT_COLOR);
    int fontSize = PApplet.parseInt(100.0f/rows + 8);
    textSize(fontSize);
    
    int h = PApplet.parseInt(height*0.9f)-rowHeight/2;
    int i = 1;
    while(h > 0) {
      // grid
      line(width*0.1f, h, width, h);
      
      // text
      int w = PApplet.parseInt(width*0.05f-fontSize*0.333f);
      if (i >= 10) {
        w -= fontSize/3;
      }
      text(i, w, h + fontSize*0.333333f);

      i++;
      h -= rowHeight;
    }
  }

  public void drawCols() {
    stroke(COL_COLOR);

    // font
    fill(FONT_COLOR);
    int fontSize = PApplet.parseInt(100.0f/cols + 8);
    textSize(fontSize);

    int w = PApplet.parseInt(width*0.1f)+colWidth/2;
    int i = 1;
    while(w < width) {
      // grid
      line(w, height*0.9f, w, 0);

      // text
      int offset = 0;
      if (i >= 10) {
        offset = fontSize/3;
      }
      text(i, w - fontSize*0.33f - offset, height*0.95f+fontSize*0.33f);

      i++;
      w += colWidth;
    }
  }

  public boolean frontIsClear(PVector p, int dir) {
    for (Wall wall : walls) {
      if (wall.blocks(p, dir)) {
        return false;
      }
    }

    return true;
  }

  public boolean hasBeeperAt(PVector p) {
    int x = PApplet.parseInt(p.x)-1;
    int y = PApplet.parseInt(p.y)-1;
    
    if (x < 0 || x >= rows) return false;
    if (y < 0 || y >= cols) return false;
    
    return beepers[x][y] != null && 
          !beepers[x][y].empty();
  }

  public int beeperCountAt(PVector p) {
    if (hasBeeperAt(p)) {
      return beepers[PApplet.parseInt(p.x)-1][PApplet.parseInt(p.y)-1].size();
    }

    return 0;
  }

  public void pickBeeperAt(PVector p) {
    if (hasBeeperAt(p)) {
      beepers[PApplet.parseInt(p.x)-1][PApplet.parseInt(p.y)-1].pop();
    }
  }

  public void putBeeperAt(PVector p) {
    if (beepers[PApplet.parseInt(p.x)-1][PApplet.parseInt(p.y)-1] == null) {
      beepers[PApplet.parseInt(p.x)-1][PApplet.parseInt(p.y)-1] = new Stack<Beeper>();
    }
    beepers[PApplet.parseInt(p.x)-1][PApplet.parseInt(p.y)-1].push(new Beeper(this));
  }

  public int getBeeperSize() {
    return beeperSize;
  }

  public int getBeeperFontSize() {
    return beeperFontSize;
  }

  public void delay() {
    delay(this.delay);
  }

  public void delay(int delay) {
    int time = millis();
    while(millis() - time <= delay);
  }
};

abstract class Wall {

  protected PVector p;
  protected int length;

  Wall(PVector p, int length) {
    this.p = p;
    this.length = length;
  }

  public PVector getPoint() {
    return p;
  }

  public int getLength() {
    return length;
  }

  public abstract void draw(World world);
  public abstract boolean blocks(PVector p, int dir);

};

class EastWestWall extends Wall {

  EastWestWall(int x, int y) {
    this(new PVector(x, y), 1);
  }

  EastWestWall(int x, int y, int length) {
    this(new PVector(x, y), length);
  }

  EastWestWall(PVector p, int length) {
    super(p, length);
  }

  public void draw(World world) {
    PVector pt = world.coords(p);
    strokeWeight(world.wallWidth());
    stroke(world.WALL_COLOR);
    line( pt.x-world.colWidth()/2, 
          pt.y-world.rowHeight()/2, 
          pt.x+length*world.colWidth()-world.colWidth()/2, 
          pt.y-world.rowHeight()/2);
  }

  public boolean blocks(PVector pt, int dir) {
    if (dir == Direction.EAST || dir == Direction.WEST) {
      return false;
    }

    return withinOne(pt, dir) && inRange(pt);
  }

  private boolean withinOne(PVector pt, int dir) {
    if (dir == Direction.NORTH) {
      return p.x - pt.x == 0;
    }
    
    return p.x - pt.x == -1;
  }

  private boolean inRange(PVector pt) {
    return pt.y >= p.y && pt.y < p.y + length;
  }

};

class NorthSouthWall extends Wall {

  NorthSouthWall(int x, int y) {
    this(new PVector(x, y), 1);
  }

  NorthSouthWall(int x, int y, int length) {
    this(new PVector(x, y), length);
  }

  NorthSouthWall(PVector p, int length) {
    super(new PVector(p.y, p.x), length);
  }

  public void draw(World world) {
    PVector pt = world.coords(p);
    strokeWeight(world.wallWidth());
    stroke(world.WALL_COLOR);
    line(pt.x+world.colWidth()/2, 
          pt.y+world.rowHeight()/2, 
          pt.x+world.colWidth()/2, 
          pt.y-length*world.rowHeight()+world.rowHeight()/2);
  }

  public boolean blocks(PVector pt, int dir) {
    if (dir == Direction.NORTH || dir == Direction.SOUTH) {
      return false;
    }
    
    return withinOne(pt, dir) && inRange(pt);
  }

  private boolean withinOne(PVector pt, int dir) {
    if (dir == Direction.EAST) {
      return p.y - pt.y == 0;
    }
    
    return p.y - pt.y == -1;
  }

  private boolean inRange(PVector pt) {
    return pt.x >= p.x && pt.x < p.x + length;
  }

};

class RobotLoader {

  RobotLoader() {}

  public ArrayList<Robot> load(String file, World w) {
    BufferedReader reader = createReader(file);
    ArrayList<Robot> robots = new ArrayList<Robot>();

    try {
      String line = reader.readLine();
      while(line != null) {
        String[] p = split(line, ",");
        Robot robot = new Robot(
          p[0], 
          w, 
          PApplet.parseInt(p[1]), 
          PApplet.parseInt(p[2]), 
          Direction.fromString(p[3]), 
          PApplet.parseInt(p[4])
        );

        if (p.length > 5) {
          robot.enableLogging();
        }
        robots.add(robot);

        line = reader.readLine();
      }

      reader.close();
    } catch (IOException e) {
      e.printStackTrace();
    }

    return robots;
  }

};

class WalkThroughWallException extends Exception {

  private static final String message = 
        "Tried to walk through a wall!";

  WalkThroughWallException() {
    super(message); 
  }

};

class BeeperBagException extends Exception {

  private static final String message = 
        "Tried to put a beeper but there are none in your bag!";

  BeeperBagException() {
    super(message); 
  }

};

class MissingBeeperException extends Exception {

  private static final String message = 
        "Tried to pick a beeper but there are none here!";

  MissingBeeperException() {
    super(message); 
  }

};

abstract class ExceptionalRobot 
              extends AbstractRobot
              implements Runnable {

  private PImage errorImg, shutdownImg;
  boolean destroyed = false;
  boolean shutdown  = false;

  boolean loggingEnabled = false;

  int initialDelay = 0;

  int moves, puts, picks, turns;

  Thread thread;

  ExceptionalRobot(String name, World world, 
      int x, int y, 
      int dir, int beepers) {
    super(name, world, x, y, dir, beepers);
    errorImg = loadImage("images/robot_error.png");
    shutdownImg = loadImage("images/robot_shutdown.png");

    thread = new Thread(this);
  }

  // begin running the robot in a new thread
  public void start() {
    thread.start();
  }

  // when thread starts
  public void run() {
    // world.delay(initialDelay);
    log();
    commands();
  }

  // user defined method of robot commands
  public abstract void commands();

  public void move() {
    if (done()) return;

    world.delay();

    try {
      super.move();
      
      moves++;
      log();
    } catch (WalkThroughWallException e) {
      destroy(e.getMessage());
    }
  }

  public void putBeeper() {
    if (done()) return;

    world.delay();

    try {
      super.putBeeper();

      puts++;
      log();
    } catch (BeeperBagException e) {
      destroy(e.getMessage());
    }
  }

  public void pickBeeper() {
    if (done()) return;

    world.delay();
    
    try {
      super.pickBeeper();

      picks++;
      log();
    } catch (MissingBeeperException e) {
      destroy(e.getMessage());
    }
  }

  public void turnLeft() {
    if (done()) return;

    world.delay();

    super.turnLeft();

    turns++;
    log();
  }

  public PImage chooseImage() {
    if (destroyed) return errorImg;
    if (shutdown) return shutdownImg;

    return super.chooseImage();
  }

  private void destroy(String message) {
    destroyed = true;
    println(getName() + " !!!Error!!! " + message);
  }

  public boolean done() {
    return destroyed || shutdown;
  }

  public void turnOff() {
    if (done()) return;

    world.delay();

    shutdown = true;
    
    if (loggingEnabled) {
      println("\n---------------------");
      println(getName() + " : Turned Off");
      println("---------------------");
      println("Moves : " + moves);
      println("Turns : " + turns);
      println("Puts  : " + puts);
      println("Picks : " + picks);
      println();
    }
  }

  public void log() {
    if (loggingEnabled) {
      println(this);
    }
  }

  public void enableLogging() {
    loggingEnabled = true;
  }

  public void disableLogging() {
    loggingEnabled = false;
  }
};

static class Direction {

  static final int NORTH = 0;
  static final int WEST  = 1;
  static final int SOUTH = 2;
  static final int EAST  = 3;

  public static int left(int dir) {
    dir++;
    if (dir > 3) dir = 0;
    return dir;
  }

  public static String toString(int dir) {
    if (dir == 0) return "North";
    if (dir == 1) return "West ";
    if (dir == 2) return "South";

    return "East ";
  }

  public static int fromString(String s) {
    s = s.toUpperCase();
    if ("EAST".equals(s))  return 3;
    if ("SOUTH".equals(s)) return 2;
    if ("WEST".equals(s))  return 1;

    return 0;
  }
};

class Beeper {

  World w;

  Beeper(World w) {
    this.w = w; 
  }

  public void draw(PVector p, int n, boolean free) {
    draw(p, n, free, 1.0f);
  }

  public void draw(PVector p, int n, boolean free, float scale) {
    float size     = w.getBeeperSize()*scale*1.25f;
    float fontSize = w.getBeeperFontSize()*scale*1.25f;
    
    fill(0);
    strokeWeight(4);
    if (free) {
      stroke(200, 200, 200);
    } else {
      fill(0, 0, 0, 150);
      stroke(0);
      strokeWeight(0);
    }
    ellipse(p.x, p.y, size, size);
    fill(255);
    textSize(fontSize);
    int offset = 0;
    if (n >= 10) {
      offset = PApplet.parseInt(fontSize*0.3333f);
    }
    text(n, p.x-fontSize*0.33333f-offset, p.y+fontSize*0.333f);
  }

};

abstract class AbstractRobot {
  private String name;
  private PVector p;
  private int dir;
  private int beepers;
  
  private PImage img;

  private World world;

  
  AbstractRobot (String name, World world, 
              int x, int y, int dir, int beepers) {
    this.name = name;
    this.world = world;
    this.p = new PVector(x, y);
    this.dir = dir;
    this.beepers = beepers;
    img = loadImage("images/robot.png");
  }


  public void draw() {
    PVector pt = world.coords(p);
    float size = world.robotSize();

    pushMatrix();
    translate(pt.x, pt.y);
    if (dir == Direction.NORTH) {
      rotate(-PI/2);
    } else if (dir == Direction.WEST) {
      rotate(PI);
    } else if (dir == Direction.SOUTH) {
      rotate(PI/2);
    }
    translate(-size/2, -size/2);
    image(chooseImage(), 0, 0,
      world.robotSize(), world.robotSize() );

    popMatrix();

    if (nextToABeeper()) {
      new Beeper(world).draw(
        PVector.add(pt, new PVector(size/2, -size/2)),
        world.beeperCountAt(p),
        true, 
        0.5f
      );
    }
    if (beepers > 0) {
      new Beeper(world).draw(
        PVector.add(pt, new PVector(-size/3, 0)),
        beepers,
        false,
        0.5f
      );
    }
  }

  public PImage chooseImage() {
    return img;
  }

  public abstract void commands();

  public void move() throws WalkThroughWallException {
    if (!frontIsClear()) {
      throw new WalkThroughWallException();
    }

    switch (dir) {
      case Direction.NORTH:
        p.x = p.x+1;
        break;
      case Direction.WEST:
        p.y = p.y-1;
        break;
      case Direction.SOUTH:
        p.x = p.x-1;
        break;
      case Direction.EAST:
        p.y = p.y+1;
        break;
    }
  }

  public void turnLeft() {
    dir = Direction.left(dir);
  }

  public boolean frontIsClear() {
    return world.frontIsClear(p, dir);
  }

  public boolean facingEast() {
    return dir == Direction.EAST;
  }

  public boolean facingNorth() {
    return dir == Direction.NORTH;
  }

  public boolean facingSouth() {
    return dir == Direction.SOUTH;
  }

  public boolean facingWest() {
    return dir == Direction.WEST;
  }

  public boolean anyBeepersInBeeperBag() {
    return beepers > 0 || beepers == -1;
  }

  public boolean nextToABeeper() {
    return world.hasBeeperAt(p);
  }

  public void putBeeper() throws BeeperBagException {
    if (!anyBeepersInBeeperBag()) {
      throw new BeeperBagException();
    }

    world.putBeeperAt(p);
    if (beepers != -1) {
      beepers--;
    }
  }

  public void pickBeeper() throws MissingBeeperException {
    if (!world.hasBeeperAt(p)) {
      throw new MissingBeeperException();
    }

    world.pickBeeperAt(p);
    if (beepers != -1) {
      beepers++;
    }
  }

  public String getName() {
    return name;
  }

  public String toString() {
    String beep = beepers == -1 ? "infinite" : ""+beepers;
    return name + " is facing " + Direction.toString(dir) + 
            " at [" + PApplet.parseInt(p.y) + ", " + PApplet.parseInt(p.x) + "]" + 
            " with " + beep + " beepers.";
  }

};
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Variables" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
