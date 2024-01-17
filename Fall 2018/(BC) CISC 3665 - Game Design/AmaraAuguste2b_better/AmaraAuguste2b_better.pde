/* Amara Auguste, CISC 3665 LAB 2b
2) Drawing Curves */
int amount = 4; //amount of points to draw
Point[] points;//array of points
int backgroundCurrent = 255;//int holding rgb number corresponding to white (for background)
int lineCurrent = 0;//int holding rgb number corresponding to black (for curve)
float rand= random(255);
int pos1 = (int) random(amount);//random number for a point position in array
int pos2 = (int) random(amount);//random number for a point position in array that is not pos1
  

class Point {//point class 
 
  float x; //x-coordinate of a point
  float y;//y-coordinate of a point
 
  Point (float x1, float y1) { //point constructor
    x = x1; //sets x to whatever x1 is
    y = y1;//sets y to whatever y1 is
  }
  
  void display() {
    point(x,y);
  }
  
  void circle() {
    int radius = 25;
    ellipse(x, y, radius, radius);
  }
}

void setup(){
  size(500,500);
  points = new Point[amount];//creates array of points 
  for (int i = 0; i < amount; i++){ //loops four times 
    float x = random(0, width); //random value between 0 and width
    float y = random(0, height);//random between 0 and height
    points[i] = new Point(x, y);//creates new point   
  }
}

void draw(){
  background(backgroundCurrent);//sets background to the current value
  for (int i = 0; i < amount; i++){ //loops four times
     // fill(rand);
      points[i].circle();
  }
}

/*void drawSplineCurve () {
  if (pos1 == pos2){//
    pos2 = (int) random(amount);
  }

    if (pos1 != pos2){
      noFill();
      stroke(lineCurrent);//sets color of curve
      curve(random(100), random(100), points[pos1].x,points[pos1].y, points[pos2].x,points[pos2].y, random(100), random(100));
    }
 
  
  
}*/

/*void drawCurve() {
 int pos1 = (int) random(amount);//random number for a point position in array
 int pos2 = (int) random(amount);//random number for a point position in array that is not pos1
  
  if (pos1 == pos2){//
    pos2 = (int) random(amount);
  }
  if (backgroundCurrent == 255 && lineCurrent == 0){

    if (pos1 != pos2){
      noFill();
      stroke(lineCurrent);//sets color of curve
      curve(random(100), random(100), points[pos1].x,points[pos1].y, points[pos2].x,points[pos2].y, random(100), random(100));
    }
  }
  if (backgroundCurrent == 0 && lineCurrent == 255){
    if (pos1 != pos2){
      noFill();
      stroke(lineCurrent);//sets color of curve
      bezier(points[pos1].x,points[pos1].y, random(100), random(100),random(100), random(100), points[pos2].x,points[pos2].y);
    }
  } 
}*/

//Change the color of an ellipse if it's clicked
void mousePressed(){
  //If an ellipse is clicked, change its color
  for(int ellipseCounter = 0; ellipseCounter <4; ellipseCounter++)
  
  //Check the hit box of the ellipse
  if((mouseX > points[ellipseCounter].x-12.5) && (mouseX < points[ellipseCounter].x+12.5) &&
     (mouseY > points[ellipseCounter].y-12.5) && (mouseY < points[ellipseCounter].y + 12.5))
  {
    //If the ellipse is hit, change the color by redrawing an ellipse on top
    float randomRed = random(255);
    float randomGreen = random(255);
    float randomBlue = random(255);
    
    fill(randomRed, randomGreen, randomBlue);
    ellipse(points[ellipseCounter].x, points[ellipseCounter].y, 25, 25);
  }
}

void keyPressed() {
  if (backgroundCurrent == 255) {//if the background is white
    backgroundCurrent = 0;//set background to black when key pressed
    lineCurrent = 255;//set curve line to white
    //drawSplineCurve();
    //curve(random(100), random(100), points[pos1].x,points[pos1].y, points[pos2].x,points[pos2].y, random(100), random(100));
  } 
  else {//if the background is NOT white
    backgroundCurrent = 255;//set background to white when key pressed
    lineCurrent = 0;//set curve line to black
    //bezier(points[pos1].x,points[pos1].y, random(100), random(100),random(100), random(100), points[pos2].x,points[pos2].y);
  }
}
