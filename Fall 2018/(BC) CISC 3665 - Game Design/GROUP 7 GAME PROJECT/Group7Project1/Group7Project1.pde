/*
************************ Updated Game ****************************
 Authors: CISC 3665 Group 7 - Amara Auguste, Danny Gong, Hercules Lambrinoudis, Oscar Su, Alan Yau
 Last updated 11/2/18
 Description: Bronco dice game modified to be more "fun"
 This is a very simplified, digital version of the game "Bronco".
 The goal of the game is to roll three dice and a player's aim is to roll the same number as the current round.
 If a player rolls the same number as the current round, he/she will recieve points based
 on what was rolled. Rolling multiples of the same round will provide the player a multiple score of the round
 (e.g. 3 die*round 6 = 18 points).
 If a player rolls three numbers matching the current round number, he/she will also recieve a bonus point.
 The winner of the game is the player with the highest score after six rounds.
 
 -----------------List of changes---------------------
 Ability to reroll all die once per round, but in return what ever points the player gets is halved.
 Combination of any consecutive numbers in a row of 3 will allow the player to receive one bonus point.
 Changed all booleans to is_____ to properly display boolean variables.
 Fixed issues regarding the reroll button, limited user from clicking reroll multiple times even if the "reroll" box wasn't there
 Added visual dice component corresponding to each roll a player makes per turn
 */

//Various variables and arrays used in mousePressed() and keyPressed()
private int[] dieRoll = new int[3];
private int[] players;
private boolean isGameOver = false;
private boolean isPlayersSet = false;
//Only reason why this boolean 'isReroll' is true, is to prevent the first player from starting the game with a reroll instead of a standard roll
private boolean isReroll = true;
private boolean isRollOnce=false;
private int turn = 0;
private int round = 1;
private int points = 0;
int dieSides = 6;  
PImage[] die = new PImage[dieSides]; 

void setup() {
  background(#000000);
  size(750, 750);
  for(int i = 0; i <dieSides; i++){
    die[i] = loadImage("dieFace"+(i+1)+".png");//loads up die array with faces
  }
  gameStart();
}

void draw() {
}

/***********************
Mouse and keyboard actions:
Mouse action is used in the active game to decide between rolling the dice or rerolling the dice.
Keyboard action is used to determine the amount of players the current game has.
***********************/
//mouse activities, involves dice rolls and determining winning conditions
void mousePressed() {
  if (players!=null) {
    if (!isGameOver && round!=7) {
      if (turn == players.length) {
        turn=0;
        round++;
      }
      //This keeps track of how many times a player has taken a turn.
      //If the player has already seen a roll and hits "Roll Dice" the player will then end his turn
      if ((mouseX>=15 && mouseX<=340) && (mouseY>=525  && mouseY<=615)&& isRollOnce ) {
        isRollOnce = false;
        isReroll=false;
        points = 0;
        turn++;
        mousePressed();
      }
      //This generates the first roll of the player's turn.
      else if ((mouseX>=15 && mouseX<=340) && (mouseY>=525  && mouseY<=615)&& !isRollOnce) {
        isRollOnce = true;
        isReroll=false;
        genDieRoll();
      }
      //If a player has already taken a roll but wants to reroll their result, 
      //he/she is allowed to do so, without losing his/her turn.
      //However, player is not allowed to Reroll twice in a row.
      if (!isReroll && ((mouseX>=400 && mouseX<=675)&&(mouseY>=525 && mouseY<=615))) {
        isReroll=true;
        isRollOnce=false;
        genDieRoll();
        points = 0;
        turn++;
      }
      playGame();
    }
  }
  //After all 6 rounds are completed, the winner is found 
  if (round == 7) {
    isGameOver = true;
    findWinner();
  }
  //If invalid entry has been made, methods will be called to start over, (restart text)
  if (isGameOver && (mouseX>=275 && mouseX<= 500)&&(mouseY>=380 && mouseY<=420)) {
    clear();
    isGameOver = false;
    gameStart();
  }
}
//register how many players are in the game
void keyPressed() {
  if (round==1 && !isPlayersSet) {
    if ((50<=key) && (key<=57)) {
      clear();
      //This is the only difference between processing code and open processing code,
      //Opening processing has String(), while processing 3.4 does not so we use [int(""+key)];
      players = new int[int(""+(key))];
      playGame();
      isPlayersSet = true;
    }
    //If an invalid entry (not 2-9) has been made display an invalid entry, allows the player to restart
    //upon clicking the word restart
    else {
      isGameOver = true;
      clear();
      textSize(60);
      text("Invalid Entry", 225, 300);
      text("restart?", 275, 420);
      textSize(20);
      text("click the word restart", 275, 480);
    }
  }
}

/*******************************
Game Screens:
First screen displayed to the users is the gameStart() method, which displays the controls the users are limited to using.
This limits the player's keyboard entry between '2 and 9' which is the maximum amount of players the game is allowed.
The second screen the players will see displays the current turn, score, amount of players, and the options to roll and reroll their die.
The last screen is the game over screen defined by findWinner(). This method searches through the number of players
and finds the players with the highest score to award him/her with a final display screen with their player number and score on it.
*******************************/
//First display screen, used to prompt the player
void gameStart() {
  textSize(100);
  text("BRONCO", 176, 200);
  textSize(32);
  text("To begin: enter", 280, 250);
  text("the number of players", 232, 282);
  text("using the keyboard", 246, 314);
  textSize(20);
  text("(Valid entry: 2 to 9 players)", 266, 346);
}
//Displays the list of players, the roll dice box, and the current score board
void playGame() {
  textSize(45);
  text("Round "+round, 550, 45);
  for (int i=0; i<players.length; i++) {
    textSize(30);
    text("Player "+(i+1)+" = "+players[i], 20, (i+1)*40);
  }
  fill(#547BDB);
  rect(15, 525, 310, 90);
  fill(#ffffff);
  textSize(75);
  text("Roll Dice", 20, 600);
  if (!isReroll) {
    fill(#547BDB);
    rect(400, 550, 275, 60);
    fill(#ffffff);
    textSize(50);
    text("Reroll Dice", 415, 600);
  }
}
//Once game has been completed, find the winner and display the winner in the window
void findWinner() {
  textSize(50);
  int winner=0;
  int tie=0;
  boolean tieBool=false;
  for (int i=1; i<players.length; i++) {
    if (players[i]>players[winner]) {
      winner=i;
    }
  }
  for (int i=0; i<players.length; i++) {
    if ((players[i]==players[winner]) && (i!=winner)) {
      tie=i;
      tieBool=true;
    }
  }
  //If there is a tie, a different text will be displayed, giving both players the win
  clear();
  if (tieBool) {
    text("There is a tie, the two", 140, 300);
    text("winners are", 250, 350);
    text("Player "+(1+winner)+" And Player "+(1+tie), 145, 400);
    text(" With "+players[tie]+" Points", 145, 500);
  }
  //Displays one winner
  else {
    textSize(50);
    text("The Winner Is Player "+(1+winner), 100, 300);
    text(" With "+players[winner]+" Points", 175, 350);
  }
}

/****************
Calculations:
Generates three dice rolls at random and displays them accordingly.
The rolls will be tested with checkBonus().
This will allow the program to keep track of the score values of players.
There will also be a print statement of the valid combinations.
****************/
//Generate 3 random die rolls from 1 to 6
void genDieRoll() {
  clear();
  textSize(30);
  text("Player "+(1+turn), 300, 250);
  //rolls each die and finds winning rolls and if all three rolls are the same to reward bonus point
  if (!isReroll) {
    for (int i=0; i<3; i++) {
      dieRoll[i] = int(random(1, 7));
      text("Roll "+(i+1)+": "+dieRoll[i], 300, 250+40*(i+1));
      if (dieRoll[i] == round) {
        points+=dieRoll[i];
      }
    }
    checkBonus();
    text("Player "+(1+turn)+" gets "+points+" points", 300, 200);
    diceDraw();
  }
  //Rerolls a player's dice roll while forfeiting his/her previous roll and reducing the score of their new roll by half
  if (isReroll) {
    players[turn]-=points;
    points = 0;
    for (int i=0; i<3; i++) {
      dieRoll[i] = int(random(1, 7));
      text("Roll "+(i+1)+": "+dieRoll[i], 300, 250+40*(i+1));
      if (dieRoll[i] == round) {
        points+=dieRoll[i];
      }
    }
    points=int(points/2);
    checkBonus();
    //Bonus points are acquired even if the player rerolls the previous rolls. This gives the player the motivation to reroll
    //if the player received 0 points previously
    text("Player "+(1+turn)+" rerolled gets "+points+" points", 300, 200);
    diceDraw();
  }
  players[turn]+=points;
}

//Displays face of die corresponding to each roll
void diceDraw(){ 
    int dieNum1 = dieRoll[0]-1;
    PImage die1= die[dieNum1]; 
    image(die1, 300, 400, die1.width/5, die1.height/5);  
    int dieNum2 = dieRoll[1]-1;
    PImage die2 = die[dieNum2]; 
    image(die2, 300 + die2.width/5 , 400, die2.width/5, die2.height/5);  
    int dieNum3 = dieRoll[2]-1;
    PImage die3 = die[dieNum3]; 
    image(die3, (300 + die2.width/5) + die2.width/5 , 400, die3.width/5, die3.height/5);  
}

//Verifies if the rolls are capable of gaining a bonus point
void checkBonus(){
  if (dieRoll[0]==dieRoll[1]&& dieRoll[0]==dieRoll[2]&& dieRoll[0] == round) {
    points+=1;
    text("Bonus Point Achieved +1", 300, 150);
  } else if (dieRoll[0]==dieRoll[1]+1 && dieRoll[0]==dieRoll[2]+2) {
    points+=1;
    printCombin(dieRoll[2],dieRoll[1],dieRoll[0]);
  } else if (dieRoll[0]==dieRoll[2]+1 && dieRoll[0]==dieRoll[1]+2) {
    points+=1;
    printCombin(dieRoll[1],dieRoll[2],dieRoll[0]);
  } else if (dieRoll[1]==dieRoll[0]+1 && dieRoll[1]==dieRoll[2]+2) {
    points+=1;
    printCombin(dieRoll[2],dieRoll[0],dieRoll[1]);
  } else if (dieRoll[1]==dieRoll[2]+1 && dieRoll[1]==dieRoll[0]+2) {
    points+=1;
    printCombin(dieRoll[0],dieRoll[2],dieRoll[1]);
  } else if (dieRoll[2]==dieRoll[0]+1 && dieRoll[2]==dieRoll[1]+2) {
    points+=1;
    printCombin(dieRoll[1],dieRoll[0],dieRoll[2]);
  } else if (dieRoll[2]==dieRoll[1]+1 && dieRoll[2]==dieRoll[0]+2) {
    points+=1;
    printCombin(dieRoll[0],dieRoll[1],dieRoll[2]);
  }
}
//Displays the winning combinations and the bonus point acquired from the bonus.
void printCombin(int die1, int die2, int die3){
  text("Combination of "+die1+" ,"+die2+" ,"+die3+"", 300, 120);
  text("Bonus Point Achieved +1", 300, 150);
}
