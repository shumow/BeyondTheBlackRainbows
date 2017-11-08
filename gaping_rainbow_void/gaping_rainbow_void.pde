size(800,800, P2D);

colorMode(ARGB);

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

/*
for (int i = 0; i < imgMask.width*imgMask.height; i++) {
  if (0xFF000000 != imgMask.pixels[i]) {
    imgMask.pixels[i] &= 0x00FFFFFF;
  }
}

imgMask.updatePixels();
*/

PGraphics imgRainbowCircles = createGraphics(800,800);

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

background(0);

PImage img = imgRainbowCircles.get();
//img = imgMask.get();
img.mask(imgMask.get());
image(img, 0, 0);

/*
image(imgRainbowCircles, 0, 0);
mask((PImage)imgMask);
//image(imgMask, 0, 0);
*/

save("gaping_rainbow_void_" + year() + "" + month() + "" + day() + "" + hour() + "" + minute() + "" + second() + "" + millis() + ".png");
