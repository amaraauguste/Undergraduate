PImage img;  // original image
color avg; //represents average color of img
PImage avgImg;//second averaged image
boolean isAvgImg = false;//boolean set to false to display between original and average image

void setup() {
  size(550, 310);
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  img = loadImage("sita.png");  // Load the image into the program  
  avg = computeAverageColorFromImage(img); // calls computeAverageColorFromImage to find the avg color
  avgImg = averagedImage(img,avg);//
  
}

color computeAverageColorFromImage(PImage img) {//computes average color of pixels 
    img.loadPixels();
    int r = 0, g = 0, b = 0;
    for (int i = 0; i < img.pixels.length; i++) {//loops through image 
        color c = img.pixels[i];//takes color of each individual pixel
        r += c>>16&0xFF;//computes average
        g += c>>8&0xFF;
        b += c&0xFF;
    }
    r /= img.pixels.length;
    g /= img.pixels.length;
    b /= img.pixels.length;
 
    color average = color(r, g, b);
    return average; //returns average color
}

PImage averagedImage (PImage img, color average){ // creates new image with average color
    PImage newImg = img.get();  //makes copy of original img
    newImg.loadPixels();  
    // Loop through every pixel
    for (int i = 0; i < newImg.pixels.length; i++) {
      newImg.pixels[i] = average; //set individual pixels at that location to the average color
    }
    newImg.updatePixels(); //update the pixels of the new img
    return(newImg); //return the averaged image
}

void keyPressed() {
  if (key == 'A' || key == 'a'){//displays averaged image
    isAvgImg = true; 
  }
  
  if (keyCode == 'B' || keyCode == 'b'){//displays original image tinted blue
    isAvgImg = false;
    tint(0,0,255);
    image(img,0,0);
  }
  if (keyCode == 'G' || keyCode == 'g'){//displays original image tinted green
    isAvgImg = false;
    tint(0,255,0);
    image(img,0,0);
  }
  if (keyCode == 'R' || keyCode == 'r'){//displays original image tinted red
    isAvgImg = false;
    tint(255,0,0);
    image(img,0,0);
  }
  if (keyCode == 'Y' || keyCode == 'y'){//displays original image tinted yellow
    isAvgImg = false;
    tint(255, 204, 0);
    image(img,0,0);
  }
  if (keyCode == 'O' || keyCode == 'o'){//displays original image again
    isAvgImg = false;
    tint(255);  
    image(img,0,0); 
  }
  else if (keyCode != 'A' && keyCode != 'a' && keyCode != 'B' && keyCode != 'b' && keyCode != 'G' && keyCode != 'g' && keyCode != 'R' && keyCode != 'r' && keyCode != 'Y' && keyCode != 'y' && keyCode != 'O' && keyCode != 'o'){
  //when keys are pressed that were not previously specified, toggle between original and averaged image  
    if(!isAvgImg){ 
      isAvgImg = true;//display averaged image
    }
    else{
      isAvgImg = false;//display original image
    }
  }
}

void mousePressed() {//when mouse is pressed toggle between original and average image
  if(!isAvgImg){ 
    isAvgImg = true;//display averaged image
  }
  else{
     isAvgImg = false;//display original image
  }
}

void draw() {
  if(!isAvgImg){
    image(img, 0, 0);//displays original image 
  }
  if (isAvgImg){
    noTint();//reverts to displaying image at original hue
    image(avgImg,0,0);//displays averaged image
  }
  
}
