import java.util.Stack;

class World {
  int ROW_COLOR = #aa0000;
  int COL_COLOR = #aa0000;
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
      this.rows = int(pieces[1]);
      
      line = reader.readLine();
      pieces = split(line, " ");
      
      this.cols = int(pieces[1]);
      this.colWidth  = int(width*0.9/cols);
      this.rowHeight = int(height*0.9/rows);
      
      this.beepers = (Stack<Beeper>[][]) new Stack[this.rows][this.cols];
      beeperSize = min(colWidth, rowHeight)/2;
      beeperFontSize = int(min(100.0/rows + 8, 100.0/cols + 8)*0.85);
      
      walls = new ArrayList<Wall>();
      walls.add(new EastWestWall(0, 1, cols+5));
      walls.add(new NorthSouthWall(0, 1, rows+5));
      wallWidth = int(beeperSize/4.0);
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
              int row = int(pieces[1])-1;
              int col = int(pieces[2])-1;
              int n   = int(pieces[3]);
              beepers[row][col] = new Stack<Beeper>();
              for (int i = 0; i < n; ++i) {
                beepers[row][col].push(new Beeper(this));
              }
            } else if ("eastwestwalls".equals(pieces[0])) {
              int row = int(pieces[1]);
              int col = int(pieces[2]);
              int n   = int(pieces[3]);
              walls.add(new EastWestWall(row, col));
            } else if ("northsouthwalls".equals(pieces[0])) {
              int row = int(pieces[1]);
              int col = int(pieces[2]);
              int n   = int(pieces[3]);
              walls.add(new NorthSouthWall(row, col));
            } else if ("randombeepers".equals(pieces[0])) {
              addRandomBeepers(
                new PVector(int(pieces[1]), int(pieces[2])), 
                new PVector(int(pieces[3]), int(pieces[4])),
                int(pieces[5]),
                int(pieces[6]), int(pieces[7])
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
    this.colWidth  = int(width*0.8/cols);
    this.rowHeight = int(height*0.8/rows);
    beepers = (Stack<Beeper>[][]) new Stack[rows][cols];
    beeperSize = min(colWidth, rowHeight)/2;
    beeperFontSize = int(min(100.0/rows + 8, 100.0/cols + 8)*0.85);
    walls = new ArrayList<Wall>();
    // left and bottom boundaries
    walls.add(new EastWestWall(0, 1, cols+5));
    walls.add(new NorthSouthWall(0, 1, rows+5));
    walls.add(new NorthSouthWall(1, 1, 5));
    wallWidth = int(beeperSize/4.0);
  }

  void draw() {
    drawRows();
    drawCols();
    drawBeepers();
    drawWalls();
  }

  int wallWidth() {
    return wallWidth;
  }

  int colWidth() {
    return colWidth;
  }

  int rowHeight() {
    return rowHeight;
  }

  void setDelay(int delay) {
    this.delay = delay;
  }

  float robotSize() {
    return min(colWidth, rowHeight)/1.5;
  }


  void addRandomBeepers(PVector start, PVector end, 
    int squares, int min, int max) {
    // start = PVector.sub(start, new PVector(1, 1));
    // end  = PVector.sub(end   , new PVector(1, 1));

    int length = abs(int(start.x - end.x)) + 1;
    int width  = abs(int(start.y - end.y)) + 1;
    int area = length*width;

    if (squares == -1) { // 50-50
      for (int i = 0; i < length; ++i) {
        for (int j = 0; j < width; ++j) {
          PVector rp = new PVector(i+start.x, j+start.y);
          int yes = int(random(0, 2));
          if (yes == 0) {
            int n = int(random(min, max + 1));
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
           int n = int(random(min, max + 1));
           for (int k = 0; k < n; ++k) {
             putBeeperAt(rp);
           }
        }
      }
    } else {
      while (squares > 0) {
        int l = int(random(length));
        int w = int(random(width));
        int n = int(random(min, max));

        PVector rp = new PVector(l+start.x, w+start.y);

        while (hasBeeperAt(rp)) {
          l = int(random(length));
          w = int(random(width));
          rp = new PVector(l+start.x, w+start.y);
        }

        for (int i = 0; i < n; ++i) {
          putBeeperAt(rp);
        }

        squares --;
      }
    }
  }

  void drawBeepers() {
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

  void drawWalls() {
    for (Wall wall : walls) {
      wall.draw(this);
    }
  }

  PVector coords(PVector p) {
    return coords(int(p.x), int(p.y));
  }

  PVector coords(int row, int col) {
    int x = int(width*0.1)+colWidth*col-colWidth/2;
    int y = int(height*0.9)-rowHeight*row+rowHeight/2;
    return new PVector(x, y);
  }

  void drawRows() {
    stroke(ROW_COLOR);
    strokeWeight(1);

    // font
    fill(FONT_COLOR);
    int fontSize = int(100.0/rows + 8);
    textSize(fontSize);
    
    int h = int(height*0.9)-rowHeight/2;
    int i = 1;
    while(h > 0) {
      // grid
      line(width*0.1, h, width, h);
      
      // text
      int w = int(width*0.05-fontSize*0.333);
      if (i >= 10) {
        w -= fontSize/3;
      }
      text(i, w, h + fontSize*0.333333);

      i++;
      h -= rowHeight;
    }
  }

  void drawCols() {
    stroke(COL_COLOR);

    // font
    fill(FONT_COLOR);
    int fontSize = int(100.0/cols + 8);
    textSize(fontSize);

    int w = int(width*0.1)+colWidth/2;
    int i = 1;
    while(w < width) {
      // grid
      line(w, height*0.9, w, 0);

      // text
      int offset = 0;
      if (i >= 10) {
        offset = fontSize/3;
      }
      text(i, w - fontSize*0.33 - offset, height*0.95+fontSize*0.33);

      i++;
      w += colWidth;
    }
  }

  boolean frontIsClear(PVector p, int dir) {
    for (Wall wall : walls) {
      if (wall.blocks(p, dir)) {
        return false;
      }
    }

    return true;
  }

  boolean hasBeeperAt(PVector p) {
    int x = int(p.x)-1;
    int y = int(p.y)-1;
    
    if (x < 0 || x >= rows) return false;
    if (y < 0 || y >= cols) return false;
    
    return beepers[x][y] != null && 
          !beepers[x][y].empty();
  }

  int beeperCountAt(PVector p) {
    if (hasBeeperAt(p)) {
      return beepers[int(p.x)-1][int(p.y)-1].size();
    }

    return 0;
  }

  void pickBeeperAt(PVector p) {
    if (hasBeeperAt(p)) {
      beepers[int(p.x)-1][int(p.y)-1].pop();
    }
  }

  void putBeeperAt(PVector p) {
    if (beepers[int(p.x)-1][int(p.y)-1] == null) {
      beepers[int(p.x)-1][int(p.y)-1] = new Stack<Beeper>();
    }
    beepers[int(p.x)-1][int(p.y)-1].push(new Beeper(this));
  }

  int getBeeperSize() {
    return beeperSize;
  }

  int getBeeperFontSize() {
    return beeperFontSize;
  }

  void delay() {
    delay(this.delay);
  }

  void delay(int delay) {
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

  PVector getPoint() {
    return p;
  }

  int getLength() {
    return length;
  }

  abstract void draw(World world);
  abstract boolean blocks(PVector p, int dir);

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

  void draw(World world) {
    PVector pt = world.coords(p);
    strokeWeight(world.wallWidth());
    stroke(world.WALL_COLOR);
    line( pt.x-world.colWidth()/2, 
          pt.y-world.rowHeight()/2, 
          pt.x+length*world.colWidth()-world.colWidth()/2, 
          pt.y-world.rowHeight()/2);
  }

  boolean blocks(PVector pt, int dir) {
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

  void draw(World world) {
    PVector pt = world.coords(p);
    strokeWeight(world.wallWidth());
    stroke(world.WALL_COLOR);
    line(pt.x+world.colWidth()/2, 
          pt.y+world.rowHeight()/2, 
          pt.x+world.colWidth()/2, 
          pt.y-length*world.rowHeight()+world.rowHeight()/2);
  }

  boolean blocks(PVector pt, int dir) {
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

  ArrayList<Robot> load(String file, World w) {
    BufferedReader reader = createReader(file);
    ArrayList<Robot> robots = new ArrayList<Robot>();

    try {
      String line = reader.readLine();
      while(line != null) {
        String[] p = split(line, ",");
        Robot robot = new Robot(
          p[0], 
          w, 
          int(p[1]), 
          int(p[2]), 
          Direction.fromString(p[3]), 
          int(p[4])
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
  void start() {
    thread.start();
  }

  // when thread starts
  void run() {
    // world.delay(initialDelay);
    log();
    commands();
  }

  // user defined method of robot commands
  abstract void commands();

  void move() {
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

  void putBeeper() {
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

  void pickBeeper() {
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

  void turnLeft() {
    if (done()) return;

    world.delay();

    super.turnLeft();

    turns++;
    log();
  }

  PImage chooseImage() {
    if (destroyed) return errorImg;
    if (shutdown) return shutdownImg;

    return super.chooseImage();
  }

  private void destroy(String message) {
    destroyed = true;
    println(getName() + " !!!Error!!! " + message);
  }

  boolean done() {
    return destroyed || shutdown;
  }

  void turnOff() {
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

  void log() {
    if (loggingEnabled) {
      println(this);
    }
  }

  void enableLogging() {
    loggingEnabled = true;
  }

  void disableLogging() {
    loggingEnabled = false;
  }
};

static class Direction {

  static final int NORTH = 0;
  static final int WEST  = 1;
  static final int SOUTH = 2;
  static final int EAST  = 3;

  static int left(int dir) {
    dir++;
    if (dir > 3) dir = 0;
    return dir;
  }

  static String toString(int dir) {
    if (dir == 0) return "North";
    if (dir == 1) return "West ";
    if (dir == 2) return "South";

    return "East ";
  }

  static int fromString(String s) {
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

  void draw(PVector p, int n, boolean free) {
    draw(p, n, free, 1.0);
  }

  void draw(PVector p, int n, boolean free, float scale) {
    float size     = w.getBeeperSize()*scale*1.25;
    float fontSize = w.getBeeperFontSize()*scale*1.25;
    
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
      offset = int(fontSize*0.3333);
    }
    text(n, p.x-fontSize*0.33333-offset, p.y+fontSize*0.333);
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


  void draw() {
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
        0.5
      );
    }
    if (beepers > 0) {
      new Beeper(world).draw(
        PVector.add(pt, new PVector(-size/3, 0)),
        beepers,
        false,
        0.5
      );
    }
  }

  PImage chooseImage() {
    return img;
  }

  abstract void commands();

  void move() throws WalkThroughWallException {
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

  void turnLeft() {
    dir = Direction.left(dir);
  }

  boolean frontIsClear() {
    return world.frontIsClear(p, dir);
  }

  boolean facingEast() {
    return dir == Direction.EAST;
  }

  boolean facingNorth() {
    return dir == Direction.NORTH;
  }

  boolean facingSouth() {
    return dir == Direction.SOUTH;
  }

  boolean facingWest() {
    return dir == Direction.WEST;
  }

  boolean anyBeepersInBeeperBag() {
    return beepers > 0 || beepers == -1;
  }

  boolean nextToABeeper() {
    return world.hasBeeperAt(p);
  }

  void putBeeper() throws BeeperBagException {
    if (!anyBeepersInBeeperBag()) {
      throw new BeeperBagException();
    }

    world.putBeeperAt(p);
    if (beepers != -1) {
      beepers--;
    }
  }

  void pickBeeper() throws MissingBeeperException {
    if (!world.hasBeeperAt(p)) {
      throw new MissingBeeperException();
    }

    world.pickBeeperAt(p);
    if (beepers != -1) {
      beepers++;
    }
  }

  String getName() {
    return name;
  }

  String toString() {
    String beep = beepers == -1 ? "infinite" : ""+beepers;
    return name + " is facing " + Direction.toString(dir) + 
            " at [" + int(p.y) + ", " + int(p.x) + "]" + 
            " with " + beep + " beepers.";
  }

};