int lineX = 0;
int lineSpeed = 10;
int lineWidth = 30;


void setup() {
  size(1280,720);
}

void draw() {
  if (mouseIsToTheRightOf(lineX)) {
    background(255,0,0);
  } else {
    background(0,0,255);
  }
  drawline();
  drawRect(400,400,100,50);
  drawRect(200,200,100,50);
}

void drawRect(int x, int y, int w, int h) {
  strokeWeight(0);
  if (mouseIsInside(x,y,w,h)) {
    fill(rgb(),rgb(),rgb());
  } else {
   fill(0); 
  }
  rect(x,y,w,h);
}

void drawline() {
  if (mouseIsInside(lineX,0,lineWidth,height)) {
    fill(rgb(),rgb(),rgb());
  } else {
   fill(0); 
  }
  rect(lineX,0,lineWidth,height);
  lineX = lineX + lineSpeed;
  
  if ((lineX >= width) || (lineX <= 0)) {
    lineSpeed = lineSpeed   * -1;
  }
}

boolean mouseIsToTheRightOf(int x) {
 if (mouseX > x) {
   return true;
 }
 return false;
}

boolean mouseIsInside(int x, int y, int w, int h) {
  return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
}

int rgb() {
  return int(random(255));
}
