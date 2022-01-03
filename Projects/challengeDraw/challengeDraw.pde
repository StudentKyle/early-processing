void setup() {
  size(1280,720);
  background(200,200,200);
  stroke(5);
  strokeWeight(1);
  pencil();
  waterBottle();
  flashDrive();
  headphones();
  backpack();
}

void draw() {
  println(mouseX,mouseY);
}

void pencil() {
  fill(#F7ED1E);
  rect(50,50,40,200);
  fill(#F7C51E);
  triangle(50,250,90,250,70,290);
  fill(#FF83F3);
  rect(50,20,40,30);
}

void waterBottle() {
  fill(#296DFC);
  strokeWeight(5);
  rect(200,200,150,100,20);
  rect(200,300,150,100,20);
  rect(200,400,150,100,20);
  quad(200,200,350,200,300,125,250,125);
  fill(210,210,210);
  rect(250,85,50,40);
}

void flashDrive() {
  fill(190,190,190);
  rect(500,100,40,50);
  fill(255,0,0);
  rect(475,150,90,200,20);
  fill(80,80,80);
  noStroke();
  rect(507,115,10,10);
  rect(523,115,10,10);
}

void headphones() {
  fill(150);
  stroke(255,0,0);
  ellipse(720,165,75,125);
  fill(0);
  noStroke();
  ellipse(720,165,30,50);
  fill(20);
  stroke(80);
  fill(150);
  stroke(255,0,0);
  ellipse(900,165,75,125);
  fill(0);
  noStroke();
  ellipse(900,165,30,50);
  strokeWeight(30);
  fill(20);
  stroke(80);
  line(720,100,900,100);
}

void backpack() {
  noStroke();
  fill(160);
  rect(700,350,250,300);
  fill(60);
  rect(745,270,50,200);
  fill(60);
  rect(850,270,50,200);
}
