final int void_width = 200;
final int halo_width = 5;

final int cnt_shapes = 20;
final int cnt_sides = 11;

final float min_rotational_speed = TWO_PI/20;
final float max_rotational_speed = TWO_PI/7;

final float avg_radius = 167.0;
final float max_radial_latitude = 43.0;

float[] speeds;
float[] radial_latitudes;

void setup()
{
  size(800,800, P2D);
  
  colorMode(ARGB);
  
  make_rainbow_background();

  speeds = new float[cnt_shapes];
  radial_latitudes = new float[cnt_shapes];
  
   
  int[] dirs = {-1,1}; 
    

  
  for (int i = 0; i < cnt_shapes; i++)
  {
    int dir = dirs[(int)random(0,2)];
    speeds[i] = dir*random(min_rotational_speed, max_rotational_speed);
    radial_latitudes[i] = random(-max_radial_latitude, max_radial_latitude);
  }
  
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
    
  for (int i = 0; i < cnt_shapes; i++) {
    float speed = speeds[i];
    float lat = radial_latitudes[i];
    for (int j = 0; j < cnt_sides; j++)
    {
      imgMask.line(400 + (avg_radius + lat)*cos(t*speed + TWO_PI*j/cnt_sides),
                   400 + (avg_radius + lat)*sin(t*speed + TWO_PI*j/cnt_sides),
                   400 + (avg_radius + lat)*cos(t*speed + TWO_PI*(j+1)/cnt_sides),
                   400 + (avg_radius + lat)*sin(t*speed + TWO_PI*(j+1)/cnt_sides));      
    }
  }
  
  imgMask.noStroke();
  imgMask.fill(255);
  imgMask.ellipse(400, 400, void_width+halo_width, void_width+halo_width);
  
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
  imgRainbowCircles.ellipse(400,400,void_width+halo_width,void_width+halo_width);
  
  imgRainbowCircles.fill(0,0,0);
  imgRainbowCircles.ellipse(400,400,void_width,void_width);
  
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
