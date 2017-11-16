
void setup()
{
  size(800,800, P2D);
  
  colorMode(ARGB);
  
  make_rainbow_background();
  
  t = millis()/1000.0;
}


PImage draw_mask()
{
  PGraphics imgMask = createGraphics(800,800);
  
  imgMask.beginDraw();
  
  imgMask.colorMode(RGB);
  
  imgMask.background(0);
  imgMask.stroke(255);
  imgMask.strokeWeight(1);
  int n = 1080;
  
  for (int i = 0; i < n; i++) {
    float len = random(100,240);
    imgMask.line(400,400,400+len*cos(i*TWO_PI/n),400+len*sin(i*TWO_PI/n));
  }
  
  imgMask.endDraw();
  
  return imgMask.get();

}

PGraphics imgRainbowCircles = null;

void make_rainbow_background()
{
  imgRainbowCircles = createGraphics(800,800);
  
  imgRainbowCircles.beginDraw();
  
  imgRainbowCircles.colorMode(HSB, 100);
  
  imgRainbowCircles.noStroke();
  
  imgRainbowCircles.fill(0,100,100);
  imgRainbowCircles.ellipse(400, 400, 500, 500);
  
  for (int i = 0; i < 70; i++) {
    imgRainbowCircles.fill(i, 100, 100);
    imgRainbowCircles.ellipse(400,400,440-3*i,440-3*i);
  }
  
  imgRainbowCircles.fill(0,0,100);
  imgRainbowCircles.ellipse(400,400,205,205);
  
  imgRainbowCircles.fill(0,0,0);
  imgRainbowCircles.ellipse(400,400,200,200);
  
  imgRainbowCircles.endDraw();
}

float t;

void draw()
{
  background(0);
 
 t = millis()/1000.0;
  
  PImage img = imgRainbowCircles.get();
  img.mask(draw_mask());
  image(img, 0, 0);


}
