// The world pixel by pixel 2017
// Daniel Rozin
// portrait example- uses darwinian selection to create your image
// uses PXP methods in the bottom
import processing.video.*;

Capture ourVideo;          // variable to hold the video
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);       // open default video in the size of window
  ourVideo.start();                                  // start the video
  noStroke();                                        // so we can see the little smiley
}

void draw() {
  if (ourVideo.available())  ourVideo.read();       // get a fresh frame of video as often as we can
  ourVideo.loadPixels();                            // load the pixels array of the video 
   loadPixels();                                    // load the pixels array of the window 
  for (int i = 0; i<100; i++) {                      // lets do 100 rects at a time to make it fast
    int rectGray= int(random(0, 255));               // randomize color, position and size of a rect
    int rectX= int(random(0, width));
    int rectY= int(random(0, height));
    int rectWidth= int(random(2, 50));
    int rectHeight= int(random(2, 50));

    if (rectX+rectWidth> width-1)rectX= width-1-rectWidth;         // check our rect isnt outside of windw
    if (rectY+rectHeight> height-1)rectY= height-1-rectHeight;

    float distanceBefore = 0;                                    // these variables will sum the amount of difference
    float distanceWithRect = 0;                                  // between the image currently showing and the live image
    for (int x = rectX; x<rectX+rectWidth; x++) {                // and between the rect color and the live image
      for (int y = rectY; y<rectY+rectHeight; y++) {             // so we go over all pixels in the rect
        PxPGetPixel(x, y, ourVideo.pixels, width);               // get the color from the live video
        int videoR= R;
        int videoG= G;
        int videoB= B;
        PxPGetPixel(x, y, pixels, width);                        // get the current pixel color from the window
        distanceBefore += dist(R, G, B, videoR, videoB, videoG);   // sum up all the difference between current window and live video
        distanceWithRect += dist(rectGray, rectGray, rectGray, videoR, videoB, videoG);  // sum up all difference between rect and live video
      }
    }

    if (distanceWithRect<distanceBefore) {                      // if the placing of the rect will improve the image
      fill(rectGray);
      rect(rectX, rectY, rectWidth, rectHeight);               // draw the random rect on screen
    }
  }
}


// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
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