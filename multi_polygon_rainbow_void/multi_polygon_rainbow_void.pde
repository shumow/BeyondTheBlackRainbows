final boolean breathing_polygons = true;

final int void_width = 200;
final int halo_width = 5;

final int cnt_shapes = 20;

final float min_rotational_speed = TWO_PI/20;
final float max_rotational_speed = TWO_PI/7;

final float min_poly_radius = (float)(void_width + halo_width)/2;
final float max_poly_radius = 220;

final int min_sides = 3;
final int max_sides = 17;

final float min_breath_speed = TWO_PI/20;
final float max_breath_speed = TWO_PI/13;

float[] speeds;
float[] radii;
float[] radial_latitudes;
int[] sides;
float[] breath_rates;

void setup()
{
  size(800,800, P2D);
  
  colorMode(ARGB);
  
  make_rainbow_background();

  speeds = new float[cnt_shapes];
  radii = new float[cnt_shapes];
  radial_latitudes = new float[cnt_shapes];
  sides = new int[cnt_shapes];
  breath_rates = new int[cnt_shapes];
  
  for (int i = 0; i < cnt_shapes; i++)
  {
    sides[i] = (int)floor(random(min_sides, max_sides+1));

    float alpha = HALF_PI - PI/sides[i];

    float min_radii = min_poly_radius/sin(alpha);
    float max_radii = max_poly_radius;
 
    int[] dirs = {-1,1}; 
    
    int dir = dirs[(int)random(0,2)];
    
    speeds[i] = dir*random(min_rotational_speed, max_rotational_speed);
    radii[i] = random(min_radii, max_radii);

    if (breathing_polygons)
    {
      float latitude_bound = min(radii[i] - min_radii, max_radii - radii[i]);
      radial_latitudes[i] = random(0, latitude_bound);
      breath_rates[i] = random(min_breath_speed, max_breath_speed);
    }
    else
    {
      radial_latitudes[i] = 0.0;
      breath_rates[i] = 0.0;
    }
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
    float breath_rate = breath_rates[i];
    for (int j = 0; j < cnt_sides; j++)
    {
      imgMask.line(400 + (radius + lat*sin(t*speed))*cos(t*speed + TWO_PI*j/cnt_sides),
                   400 + (radius + lat*sin(t*speed))*sin(t*speed + TWO_PI*j/cnt_sides),
                   400 + (radius + lat*sin(t*speed))*cos(t*speed + TWO_PI*(j+1)/cnt_sides),
                   400 + (radius + lat*sin(t*speed))*sin(t*speed + TWO_PI*(j+1)/cnt_sides));      
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
