
// The world pixel by pixel 2017
// Daniel Rozin
// tracks faces with opencv and applies edge effect to the face area
// uses PXP methods in the bottom
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {
  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 0, 0 );                         // show the live video
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();         // track the faces and put the results in array
  println(faces.length);                       // prints how many faces were found
  loadPixels();                                
  video.loadPixels();
  for (int i = 0; i < faces.length; i++) {                              // we will do this for all faces found
    // rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
    for (int x =  faces[i].x; x< faces[i].x+faces[i].width; x++) {     // visit all pixels x and y of the face ret
      for (int y = faces[i].y; y< faces[i].y+faces[i].height; y++) {  
        PxPGetPixel(x, y, video.pixels, width);                        // get the R,G,B of each pixel
        int thisR= R;                                     
        int thisG=G;                                                     // place the RGB of our pixel in variables
        int thisB=B;
        int edgeAmount =1;
        float colorDifference=0;                                          // this variable will sum all the differences
        for (int blurX=x- edgeAmount; blurX<=x+ edgeAmount; blurX++) {     // visit every pixel in the neighborhood
          for (int blurY=y- edgeAmount; blurY<=y+ edgeAmount; blurY++) {
            PxPGetPixel(blurX, blurY, video.pixels, width);                // get the RGB of our pixel and place in RGB globals

            colorDifference+=   dist(R, G, B, thisR, thisG, thisB);       // dist calclates the distance in 3D colorspace between the center pixel
          }                                                                // and the neighboring pixels and adds to "colorDifference"
        }
        if (colorDifference> 100) {
          PxPSetPixel(x, y, 0, 0, 0, 255, pixels, width);             // sets the pixels black
        } else {
          PxPSetPixel(x, y, 255, 255, 255, 255, pixels, width);         // sets the pixels white
        }
      }
    }
  }
  updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}






// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

int A, R, G, B;
//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}