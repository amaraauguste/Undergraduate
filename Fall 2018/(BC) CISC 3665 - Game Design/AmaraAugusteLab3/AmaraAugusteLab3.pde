/* Amara Auguste, CISC 3665 LAB 3
Elements of fun:
1) Submission - the game could be considered a "mindless pastime" as all the player has to do is click on the ball
2) Challenge - as the player increases their score, the game becomes harder because the speed increases. 
The objective would be for the player to get the highest score they can and to beat the current high score. 
*/
int ballPosition;//position of the ball
int speed=1;//initial speed
int ballDirection=1;//direction of the ball
int score=0;
int highScore = 0; 
int lives=3;
boolean ifLost=false;//determines if player has lost and game is over or not

void setup() {
  size (400,400);
  smooth();
  ballPosition=width/2;//positions ball in center of window
  fill(255,105,180);//sets ball and text to pink
  textSize(13);//Sets the size of our text
}

void draw() {                                     
  background (255);                               
  ellipse(ballPosition, height/2,40,40);                 
  ballPosition=ballPosition+(speed*ballDirection);//updates ball's position 
  if (ballPosition > width-20 || ballPosition<20) {//determines if ball hits edge
    ballDirection=-ballDirection;//reverses direction
  }
  text("score = "+score,10,10);//prints score
  text("lives = "+lives,width-80,10);//prints remaining lives
  text("high score = " + highScore, 10, 30);
  if (lives == 0) {//if out of lives
    textSize(20);
    text("Click to Restart", 125,100);
    noLoop();//stops looping draw
    ifLost=true;//player has lost
    textSize(13);
  }
}

void mousePressed() {                             
  if (dist(mouseX, mouseY, ballPosition, 200)<=20) {//if mouse hits target
    score=score+1;//score increases
    speed=speed+1;//speed increases
  }
  else {  
    lives=lives-1;//lose a life
  }
  if (ifLost==true) { //game is lost, reset now and start over 
    if (score > highScore){
      highScore = score;//new high score
    }
    speed=1;//reset all other variables to initial conditions
    lives=3;
    score=0;
    ballPosition=width/2;
    ballDirection=1;
    ifLost=false;
    loop();//loops draw function again
  }
}
