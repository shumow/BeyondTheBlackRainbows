final int void_width = 200;
final int halo_width = 5;

final int cnt_shapes = 20;

final float min_rotational_speed = TWO_PI/10;
final float max_rotational_speed = TWO_PI/3;

final float min_poly_radius = (float)(void_width + halo_width);
final float max_poly_radius = 440;

final int min_sides = 3;
final int max_sides = 17;

float[] speeds;
float[] radii;
float[] radial_latitudes;
int[] sides;

void setup()
{
  size(800,800, P2D);
  
  colorMode(ARGB);
  
  make_rainbow_background();

  speeds = new float[cnt_shapes];
  radii = new float[cnt_shapes];
  radial_latitudes = new float[cnt_shapes];
  sides = new int[cnt_shapes];
  
  for (int i = 0; i < cnt_shapes; i++)
  {
    float min_radii = 2*min_poly_radius/sqrt(3);
    float max_radii = max_poly_radius;
    float radial_lat = max_poly_radius - 2*min_poly_radius/sqrt(3);
    
    sides[i] = (int)floor(random(min_sides, max_sides+1));
    speeds[i] = random(min_rotational_speed, max_rotational_speed);
    radii[i] = random(min_radii, max_radii);
    //radial_latitudes[i] = random(-radial_lat, radial_lat);
    radial_latitudes[i] = 0.0;
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
    int cnt_sides = sides[i];
    float radius = radii[i];
    for (int j = 0; j < cnt_sides; j++)
    {
      imgMask.line(400 + (radius + lat)*cos(t*speed + TWO_PI*j/cnt_sides),
                   400 + (radius + lat)*sin(t*speed + TWO_PI*j/cnt_sides),
                   400 + (radius + lat)*cos(t*speed + TWO_PI*(j+1)/cnt_sides),
                   400 + (radius + lat)*sin(t*speed + TWO_PI*(j+1)/cnt_sides));      
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
