// The world pixel by pixel 2017
// Daniel Rozin
// portrait example, makes Newton from falling apples
// uses PXP methods for getting and setting pixel values fast

PImage ourImage, ourAppleImage;           // variables to hold our images

float transp = 255;
int x=100, y=100;
void setup() {
  size(600, 600);
  frameRate(120);
  ourImage= loadImage("http://www.asimov.es/wp-content/uploads/2014/09/isaac-newton-gout-400x400.jpg");
  ourImage.resize (width, height);        // make sure the image is the size of the window
  ourImage.loadPixels();                 // load the pixels array of the image

  ourAppleImage=  loadImage("Apple-Fruit.png");   // this is the apple, it has to be png with transparent background
  imageMode(CENTER);
}

void draw() {
  y+=2;                       // make the apple go down
  transp-=2;                  // make he apple fade gradualy
  if (y>height-1 || transp < 1) {         // when we are on the bottom, randomize a new apple position
    x = int(random(0, width-1));
    y = int (random(0, height-1));
    transp = 255;
  }
  PxPGetPixel(x, y, ourImage.pixels, width);     // get the RGB of our pixel and place in RGB globals

  tint (R, G, B, transp);                          // tint the apple to the color of the pixel it's above
  image(ourAppleImage, x, y, 40, 40);              // draw te apple


  tint (255, 255, 255);                            // draw a tiny Newton in the corner
  image (ourImage, 25, 25, 50, 50);
}


// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global variables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}