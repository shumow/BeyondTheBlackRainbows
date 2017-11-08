import java.util.Iterator;
import java.util.LinkedList;

final float black_hole_radius = 100.0;
final float black_hole_halo_width = 10.0;

final float rainbowdius = 225.0;

final int color_param = 75;

class Particle
{
  PVector pos;
  PVector dir;
  
  float speed;
  
  Particle()
  {
    this.pos = new PVector(0,0);
    this.dir = new PVector(0,0);
    
    this.speed = 0.0;
  }
  
  Particle(PVector new_pos, PVector new_dir, float new_speed)
  {
    this.pos = new PVector(new_pos.x, new_pos.y);
    this.dir = new PVector(new_dir.x, new_dir.y);
    
    this.speed = new_speed;
  }
  
  void update(float dt)
  {
    PVector displacement = new PVector(dir.x, dir.y);
    
    displacement.mult(dt*speed);
    
    this.pos.add(displacement);
  }
}

final float min_speed = rainbowdius/10.0;
final float max_speed = rainbowdius/2.0;

Particle new_random_particle()
{
  float r = random(black_hole_radius, black_hole_radius+black_hole_halo_width);
  float theta = random(0, TWO_PI);

  PVector pos = new PVector(r*cos(theta), r*sin(theta));
  
  PVector dir = new PVector(pos.x, pos.y);
  dir.normalize();

  //println("direction of new particle: (" + dir.x + "," + dir.y + ")");

  float s = random(min_speed, max_speed);

  return new Particle(pos, dir, s);
}

color color_field(float magnitude)
{
  int h = (int)(color_param*((magnitude - (black_hole_radius+black_hole_halo_width))/rainbowdius));
  
  if (h < 0)
  {
    return color(0,0,100);
  }
  else
  {
    return color(h, 100, 100);
  }
}

LinkedList<Particle> particle_list;

int max_particle_count = 16384;

void initialize_particle_list()
{
  //int initial_particle_count = (int)(PI*(black_hole_radius*black_hole_radius*(black_hole_halo_width*black_hole_halo_width - 1))/3.0);
  int initial_particle_count = (int)(2.0*TWO_PI*black_hole_radius);
  
  println("Initial_particle_count: " + initial_particle_count);
  
  for (int i = 0; i < initial_particle_count; i++)
  {
    particle_list.add(new_random_particle());
  }
}

void setup()
{
  size(800,800);
  
  colorMode(HSB, 100);
  
  lastMillis = (float)millis();
  
  particle_list = new LinkedList<Particle>();
  initialize_particle_list();
}

final int new_particles_per_second = (int)(2.0*TWO_PI*black_hole_radius);

void add_new_particles(float dt)
{
  int cur_count = particle_list.size();
  
  if (cur_count < max_particle_count) {
    int new_particle_count = min((int)(new_particles_per_second*dt),(max_particle_count - cur_count));
    
    for (int i = 0; i < new_particle_count; i++)
    {
      particle_list.add(new_random_particle());
    }
    
  }
}

void update(float dt)
{
  if (particle_list.size() > 0)
  {
    Iterator<Particle> it = particle_list.iterator();

    while(it.hasNext())
    {
      Particle p = it.next();

      p.update(dt);

      if ((black_hole_radius + black_hole_halo_width + rainbowdius) < p.pos.mag())
      {
        it.remove();
      }
    }
    
    add_new_particles(dt);
  }
}

float lastMillis = 0.0;

void draw()
{
  
  pushMatrix();
  
  translate(width/2, height/2);
  
  float newMillis = (float)millis();
  
  float dt = (newMillis - lastMillis)/1000.0;
  
  lastMillis = newMillis;
  
  update(dt);
  
  background(0);
  
  pushStyle();
    for (Particle p : particle_list)
    {
      stroke(color_field(p.pos.mag()));
      point(p.pos.x, p.pos.y); 
    }
  popStyle();
  popMatrix();
}

