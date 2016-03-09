//	Tkd-Alex alex.tkd.alex@gmail.com 
//	https://www.fb.com/tkdalex.social , https://github.com/Tkd-Alex , http://www.tkdalex.altervista.org

import static javax.swing.JOptionPane.*;

color backgroundColor = color(235,235,235); //Color of backgound.
color boxColor = color(56,56,56); //Color of box.
color textBox = color(108,187,106); //Color of text box.
color buttonColor = color(144,169,189); //Color of button.

int boxSize = 96; //Size of single box.
int boxMargin = 4; //Margin of box.
int newEmptyLocation, newEmptyX, newEmptyY; //Variable useed to swap the square and the empy field.

int totalMoves; //Total moves in the current game.
int bestTime = 0; //bestTime start to zero.
int bestMoves = 0; //bestMoves start to zero.

boolean playing; 
boolean gameOver;
boolean originalImg = true; //True if the game use the default img (Lenna).
boolean useImage = false; //True if the game is set to image, false if the game is set to number.

int nRowsCols = 4; //Number of colums and cells (the matrix is square, same colums and same cells).
int nBoxes = (nRowsCols*nRowsCols)-1; //Number of boxes, NxN - 1 because the last box is empty.

PImage img; //Image used for mosaic.
PImage[] imgArray = new PImage [nBoxes]; //Array containing the split image.

PFont myFont; //My personal font.

BoxActive[] boxes = new BoxActive[nBoxes]; //Array of box(my class), dimension = nBoxes.
BoxEmpty empty; //Empty square.

myButton buttonLoadImage, buttonRestart, buttonQuit, buttonSwitch; //Declaration of personal button.
int started = 1 ,sec = 0, min = 0, millisec = 0, start_time = 0, delay = 0;  //Time variables , initialized to zero.  

void setup() {
  size(400,560); //Size of application.
  background(backgroundColor); //Set the back ground of application.
  frameRate(15); //Set the frame rate.

  String setScore[] = loadStrings("data/Scores.txt"); //Upload best scores into array by txt.
  bestTime = (int(setScore[0])); //Casting str to int by the best scores array[0] = bestTime.
  bestMoves = (int(setScore[1])); //Casting str to int by the best scores array[1] = bestMoves.

  myFont = createFont("BebasNeue.otf",100); //Upload my font.
  gameOver = false; //Game over = false.
  totalMoves = 0; //Set the total moves to zero.

  //Set the new location of empty boxes.
  newEmptyLocation = 0; 
  newEmptyX = 350;
  newEmptyY = 250;

  //Inizialize the squares array with new BoxActive.
  int newSquareX = 50;
  int newSquareY = 50;
  for(int i=0;i<nBoxes;i++){
    boxes[i] = new BoxActive(newSquareX,newSquareY,i+1);
    newSquareX += boxSize+boxMargin;
    if( (i+1)%4==0 ){
      newSquareX = 50;
      newSquareY += boxSize+boxMargin;
    }  
  }

  empty = new BoxEmpty(350,350,0); //Inizialize the empty square.
  shuffleBoxes(); //Call the shuffleBoxes method.

  empty.display(backgroundColor); //Show (display) the empty box. 

  if(originalImg)  img = loadImage("Lenna.png"); //Load the default img.

  if(useImage)  puzzleImage(); //If the game is set to image, call the puzzleImage method (make a mosaic with img).
  else  for(int i=0; i<nBoxes; i++) boxes[i].display(boxColor); //If the game is set to "number", display all boxes.

  //Set the startTime variable.
  start_time = millis();
  delay = 1;

  if(useImage)  buttonSwitch = new myButton(5,410,120,30,"Number Mode",buttonColor); //If the game is set to image, create the button with the "Number Mode" string.
  else buttonSwitch = new myButton(5,410,120,30,"Image Mode",buttonColor); //If the game is set to number, create the button with the "Image Mode" string.
  buttonLoadImage = new myButton(5,410+35,120,30,"Load Image",buttonColor); //Create the button with the "Load Image" string.
  buttonRestart = new myButton(5,410+(35*2),120,30,"Restart",buttonColor); //Create the button with the "Restart" string.
  buttonQuit = new myButton(5,410+(35*3),120,30,"Quit",buttonColor); //Create the button with the "Quit" string.

  playing=true; //Playing = true.
}

void draw() {
  textFont(myFont); //Set myFont to default font of application.
  rectMode(CORNER);  //Set the rectMode to corner.
  fill(backgroundColor); //Set the background color of rect details. 
  rect(2,(boxSize*nRowsCols)+(nRowsCols*nRowsCols)+2 /*402*/ ,(boxSize*nRowsCols)+(3*nRowsCols) /*396*/ ,150); //Draw the rect details.
  
  fill(0); //Set the black color to text.
  
  if (delay == 1 && millis() - start_time >= 400) delay = 0;
  
  if (started == 1) {
    millisec = (millis() - start_time) % 1000;
    sec = int((millis() - start_time)/1000) % 60;
    min = int((millis() - start_time)/(60*1000)) % 60;
  }
  
  //Display details of game (score, time, etc.).
  displayDetailsGame();

  //Display all myButton.
  displayAllButton();
}

void displayDetailsGame(){
  textSize(22); //Set the size of details text.
  textAlign(LEFT); //Align the text details to left.
  text("Total Time: ", 135, 430); //Write "Total time" string. 
  text("Min: " +min+ " Sec: " +sec + " Millisec: " +millisec, 135,430+25); //Write the actually time.
  text("Total Moves: "+totalMoves,135,430+(25*2)); //Write the actually moves.
  text("Best Time: "+ bestTime, 135,430+(25*3)); //Write the best time ever.
  text("Best Moves: "+ bestMoves, 135,430+(25*4)); //Write the best moves ever.
}

void displayAllButton(){
  //Display all myButton.
  buttonLoadImage.display();
  buttonRestart.display();
  buttonQuit.display();
  buttonSwitch.display();
}

void shuffleBoxes(){
  int[] rndNumbArray = new int[nBoxes]; //Create a int array.
  int n = nBoxes; //Create a n variable initialized to boxes number.
  int rndNumb; //Create a rndNumb.
  
  for(int i=0;i<n;i++)  rndNumbArray[i] = i+1; //Load the number into the array. 1 to n=15.
  
  for(int i=0; i<nBoxes; i++) {
    rndNumb = int(random(n))+0; //Select a random number.
    boxes[i].number = rndNumbArray[rndNumb]; //Assigns the number associated of array[rnd] to boxes[i].
    for(int j=rndNumb;j<n-1;j++)  rndNumbArray[j]=rndNumbArray[j+1]; //Shift the array.
    n--;
  }
  
  checkIsSolvable(); //Check if the permutation in solvable.
}

void checkIsSolvable(){
  int sum=0; 
  for(int i=0; i<14; i++) {
    for(int j=i+1; j<15; j++) {
      if(boxes[j].number<boxes[i].number)  sum++; //Count the number minor of ni.
    } 
  }
  if(sum%2==1)  shuffleBoxes(); //If the sum is odd create a new permutation. 
}

void mouseReleased() {
  //If we are in game check all squares and search which is clicked and released.
  if(gameOver!=true) { 
    for(int i=0; i<=14; i++) {
      if(boxes[i].selected()==true) { 
        playBox(i);
        break;
      }
    }
  }
}

void mousePressed(){
  if(buttonLoadImage.selected()) selectInput("Select a img file to use:", "fileSelected"); //If click buttonLoadImage launch the selectInput function.
  if(buttonRestart.selected()){
    started=1;
    setup(); //If click buttonRestart re-call the setup.
  }
  if(buttonQuit.selected()) exit(); //If click buttonQuit exit.
  
  if(buttonSwitch.selected()) { //If click buttonSwitch...
    if(useImage)  useImage = false; //If the app use the image, set app to "number".
    else  useImage = true; //Else set app to "image".
    setup(); //Re-call the setup in any case.
  }
}

void playBox(int selected) {
  int boxesLocation = boxes[selected].location; //Search the position of clicked box.
  
  //With the rules +4 / +1 / -1 / -4 check the empty location to move the clicked box.
  if(boxesLocation == 6 || boxesLocation == 7 || boxesLocation == 10 || boxesLocation == 11)
    if(empty.location == boxesLocation+4 || empty.location == boxesLocation+1  || empty.location == boxesLocation-1 || empty.location == boxesLocation-4)
      moveBox(selected);
      
  if(boxesLocation == 5 || boxesLocation == 9)
    if(empty.location == boxesLocation+4 || empty.location == boxesLocation+1 || empty.location == boxesLocation-4)
      moveBox(selected);
      
  if(boxesLocation == 2 || boxesLocation == 3)
    if(empty.location == boxesLocation-1 || empty.location == boxesLocation+1 || empty.location == boxesLocation+4)
      moveBox(selected);
  
  if(boxesLocation == 14 || boxesLocation == 15)
    if(empty.location == boxesLocation-1 || empty.location == boxesLocation+1 || empty.location == boxesLocation-4)
      moveBox(selected);
      
  if(boxesLocation == 8 || boxesLocation == 12)
    if(empty.location == boxesLocation-1 || empty.location == boxesLocation+4 || empty.location == boxesLocation-4)
      moveBox(selected);
      
  if(boxesLocation == 1)  if(empty.location==2 /* +1 */ || empty.location==5 /* +4 */)  moveBox(selected);
  if(boxesLocation == 4)  if(empty.location==8 /* +4 */ || empty.location==3 /* -1 */ )  moveBox(selected);
  if(boxesLocation == 5)  if(empty.location==1 /* -4 */ || empty.location==9 /* +4 */ || empty.location==6 /* +1 */)  moveBox(selected);
  if(boxesLocation == 8)  if(empty.location==4 /* -4 */ ||  empty.location==7 /* -1 */ ||  empty.location==12 /* +4 */)  moveBox(selected);
  if(boxesLocation == 9)  if(empty.location==5 /* -4 */ || empty.location==13 /* +4 */|| empty.location==10 /* +1 */)  moveBox(selected);
  if(boxesLocation == 12)  if(empty.location==16 /* +4 */ || empty.location==11 /* -1 */ || empty.location==8 /* -4 */)  moveBox(selected);
  if(boxesLocation == 13)  if(empty.location==9 /* -4 */ || empty.location==14 /* +1 */)  moveBox(selected);
  if(boxesLocation == 16)  if(empty.location==15 /* -1 */ || empty.location==12 /* -4 */)  moveBox(selected);
  
  checkResult(); 
}

void moveBox(int selected) {
   //Move the clicked box to empty box with support variables.
   newEmptyLocation = boxes[selected].location;
   newEmptyX = boxes[selected].x;
   newEmptyY = boxes[selected].y;
  
   boxes[selected].location = empty.location;
   boxes[selected].x = empty.x;
   boxes[selected].y = empty.y;
   
   empty.location = newEmptyLocation;
   empty.x = newEmptyX;
   empty.y = newEmptyY;
  
   empty.display(backgroundColor); //Display the empty box.
   
   //Display the other box controlling the "type" of game; image or number.
   if(useImage)  boxes[selected].display(imgArray[(boxes[selected].number)-1]); 
   else  boxes[selected].display(boxColor);
   
   if (playing==true) totalMoves++; //If we are in game increase the move.
}

void checkResult() {

  int checkRight = 0;
  for(int i=1;i<nBoxes;i++)  if(boxes[i].location==boxes[i].number)  checkRight++; //Count the number of corresponding number <-> location.
  if(checkRight==14)  gameOver=true; //If we are 14 correspoding the game ends and the player won.

  //If the game will end...
  if (gameOver == true) {
    started = -1*started + 1; //Lock the time.
    delay = 1;
    empty.displayWin(); //Display the winBox (trophy).
    
    //Lock all boxes.
    for(int i=0; i<nBoxes; i++) {
       if(useImage)  boxes[i].display(imgArray[(boxes[i].number)-1]); 
       else  boxes[i].display(backgroundColor);
    }
    
    setNewScore(); //Set the new scores.
    showMessageDialog(null, "Congratulations you won.", "Done", INFORMATION_MESSAGE); //Show contratulations message.
  }
}

void setNewScore(){
  
  int newbestTime;
  newbestTime = sec; //Copy the second in to new variable.
  if(min>0) newbestTime += min*60; //If the minutes are greater than zero add the minutes per seconds to newbestTime.

  //If bestTime and bestMoves are different to zero update the new score.
  if(bestTime==0 && bestMoves==0){
    bestTime= newbestTime;
    bestMoves=totalMoves;
  }else{
    if(newbestTime<bestTime){
      bestTime = newbestTime;
      showMessageDialog(null, "Congratulations new bestTime! "+bestTime, "Done", INFORMATION_MESSAGE);
    }
    if(totalMoves<bestMoves){
      bestMoves = totalMoves;
      showMessageDialog(null, "Congratulations new bestMoves! "+bestMoves, "Done", INFORMATION_MESSAGE);
    }
  }
  
  //Save the new scores to file.txt.
  String t = str(bestTime), m = str(bestMoves); 
  String[] data ={t,m};
  saveStrings("data/Scores.txt",data);
}

void fileSelected(File selection) {
  if (selection!=null){

    if( selection.getAbsolutePath().endsWith(".png") ||selection.getAbsolutePath().endsWith(".jpg") || selection.getAbsolutePath().endsWith(".tga") || selection.getAbsolutePath().endsWith(".gif") ){
      img = loadImage(selection.getAbsolutePath()); //Load the new image selected to img.
      originalImg = false; //Set to false originalmg.
      showMessageDialog(null, "Image loaded.\nClick on restart button/image mode.", "Done", INFORMATION_MESSAGE);
    }else{
      showMessageDialog(null, "Unsupported type selected.\nPlease select a .gif, .jpg, .tga, .png type file.", "Error", ERROR_MESSAGE);
    }
  }
}

void keyPressed() {
  if (key=='i' || key=='I') {  
    showMessageDialog(null, "FifteenGame is developed by Tkd-Alex for a IEM University project.\nAlessandro Maggio (X81000134).", "About this app", INFORMATION_MESSAGE);
  }
}

void puzzleImage(){
  useImage = true; 
  img.resize(boxSize*nRowsCols, boxSize*nRowsCols); //Resize the img to NxN = (boxSize*nRowsCols)x(boxSize*nRowsCols).
  
  //Split the image to nBoxes (15) | Size = boxSize | x and y coordinates are "managed" by the size of single box.
  for(int i=0;i<4;i++) imgArray[i]=img.get(boxSize*i, 0, boxSize, boxSize); 
  for(int i=4;i<=7;i++) imgArray[i]=img.get(boxSize*(i-4), boxSize, boxSize, boxSize); 
  for(int i=8;i<=11;i++)  imgArray[i]=img.get(boxSize*(i-8), boxSize*2, boxSize, boxSize); 
  for(int i=12;i<=14;i++) imgArray[i]=img.get(boxSize*(i-12), boxSize*3, boxSize, boxSize);

  for(int i=0;i<nBoxes;i++)  boxes[i].display(imgArray[(boxes[i].number)-1]); //Display all boxes with the image.
}

class myButton{
  int x,y,w,h; //Coordinates x and y | Size Width (w) and Height (h).
  String text; //Text into the button.
  color bg; //Background color of button.
  
  //Method used for the click.
  boolean selected(){
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y+h) return true;
    else return false;
  }
  
  //Constructor.
  myButton(int newX, int newY, int newWidth , int newHeight, String newString, color newBg){
    x = newX;
    y = newY;
    h = newHeight;
    w = newWidth;
    text =  newString;
    bg = newBg;
  }
  
  //Draw the button.
  void display(){
    rectMode(CORNER);
    noStroke();
    fill(bg); //Set the background color.
    rect(x,y,w,h,7);
    
    noStroke();
    fill(255); //Set the text color of botton.
    textAlign(CENTER);
    textSize(20);
    text(text,(x+(h*2)),y+22);
  }
  
}

class Box {
  int number, location, x, y, s; //Number, location, coordinates x and y, s = size of box.
  color c; //Color of box.
  
  //Method used for the click.
  boolean selected() {
    if (mouseX >= x-(s/2) && mouseX <= x+(s/2) && mouseY >= y-(s/2) && mouseY <= y+(s/2))  return true;
    else return false;
  }
}
  
class BoxActive extends Box {
  //Constructor.
  BoxActive (int tempX, int tempY, int tempN) {
    x = tempX;
    y = tempY;
    s = boxSize ;
    location = tempN; 
  }
  
  //Draw the BoxActive.
  void display(int squareColor) {
    rectMode(CENTER);
    noStroke();
    fill(squareColor); //Set bg color.
    rect(x,y,s,s); //Draw.
    
    //Write the number inside the box.
    noStroke();
    fill(textBox);
    textFont(myFont);
    textSize(60);
    textAlign(CENTER);
    text(number,x,y+18);
  }
  
  //"Transform" the box into image.
  void display(PImage bg) {
    image(bg,x-48,y-48,s,s);
  }

}

class BoxEmpty extends Box {
  //Constructor.
  BoxEmpty(int tempX, int tempY, int tempN) {
    x = tempX;
    y = tempY;
    s = boxSize ;
    location = 16; //Default location for BoxEmpty = last (16).
  }
  
  //Draw the empty box.
  void display(int squareColor) {
    rectMode(CENTER);
    noStroke();
    fill(squareColor);
    rect(x,y,s,s);
  }
  
  //"Transform" the empty box in a trophy.
  void displayWin(){
    PImage bg = loadImage("Trophy.png");
    image(bg,x-40,y-40,s-20,s-20);
  }
}
