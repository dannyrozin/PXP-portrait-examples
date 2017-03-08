// The world pixel by pixel 2017
// Daniel Rozin
// portrait example - makes portrait of mother Teressa from flowers
// uses PXP methods for getting and setting pixel values fast

PImage ourImage, ourFlowerImage;             // variables for images  
float flowerSize = 800;                      // initial size of flowers
float speed = 0.999;                         // the rate in which the flowers will shrink

void setup() {
  size(800, 800);
  frameRate(120);
  ourImage= loadImage("https://www.biography.com/.image/c_fill,cs_srgb,dpr_1.0,g_face,h_300,q_80,w_300/MTE1ODA0OTcxODAxNTQ0MjA1/mother-teresa-9504160-1-402.jpg");
  ourImage.resize (width, height);        // make sure the image is the size of the window
  ourImage.loadPixels();                 // load the pixels array of the image

  ourFlowerImage=  loadImage("http://3.bp.blogspot.com/-Z9E1ivRGv7M/T3X2lPk-wLI/AAAAAAAAAeQ/HsaL1n_hnsM/s1600/WHT-FL-BCZ.png");
  imageMode(CENTER); 
}

void draw() {
  if (flowerSize > 20)flowerSize*=speed;              // shrink the flower but not less then 20
   int x = int(random(0, width-1));                    // randomize a position for the flower
  int y = int (random(0, height-1));
  PxPGetPixel(x, y, ourImage.pixels, width);     // get the RGB of our pixel and place in RGB globals


  tint (R, G, B);                                    // tint the flower to the color of the pixel it's above
  image(ourFlowerImage, x, y, flowerSize, flowerSize);
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