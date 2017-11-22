import java.util.Iterator;
import java.util.LinkedList;

final boolean do_ye_olde_blending_trick = false;

final float black_hole_radius = 100.0;
final float black_hole_halo_width = 10.0;

final float rainbowdius = 225.0;

final int color_param = 75;

class OrbitalParticle
{
  float alpha;
  float beta;
  
  float gamma;
  float delta;
  
  float angular_speed;

  PVector pos;
  
  OrbitalParticle()
  {
    this.alpha = 0.0;
    this.beta = 0.0;
    
    this.gamma = 0.0;
    this.delta = 0.0;
    
    pos = new PVector(0.0, 0.0);
  }
  
  OrbitalParticle(float new_alpha, float new_beta, float new_gamma, float new_delta)
  {
    this.alpha = new_alpha;
    this.beta = new_beta;
    
    this.gamma = new_gamma;
    this.delta = new_delta;
  
    float theta = beta;

    float r = gamma*sin(theta) + delta;
  
    pos = new PVector(r*cos(theta), r*sin(theta));
  }
  
  void update(float t)
  {
    float theta = alpha*t + beta;
    
    float r = gamma*sin(theta) + delta;
    
    this.pos.x = r*cos(theta);
    this.pos.y = r*sin(theta);
  }
}

final float min_alpha = TWO_PI/20.0;
final float max_alpha = TWO_PI/13.0;

final float min_beta = 0.0;
final float max_beta = TWO_PI;

final float min_delta = black_hole_radius + black_hole_halo_width;
final float max_delta = black_hole_radius + black_hole_halo_width + rainbowdius;

OrbitalParticle new_random_orbital_particle()
{
  int[] dir ={-1,1};

  //int sign_alpha = dir[(int)random(0,2)];
  
  int sign_alpha = 1;
  
  float alpha = sign_alpha*random(min_alpha, max_alpha);
  float beta = random(min_beta, max_beta);

  float delta = random(min_delta, max_delta);
  
  float gamma = random(0, min(delta-min_delta, max_delta-delta));

  println("" + alpha + " " + beta + " " + gamma + " " + delta );

  return new OrbitalParticle(alpha, beta, gamma, delta);
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

LinkedList<OrbitalParticle> particle_list;

int max_particle_count = 16384;

void initialize_particle_list()
{
  int initial_particle_count = (int)(2.0*TWO_PI*black_hole_radius);
  
  println("Initial_particle_count: " + initial_particle_count);
  
  for (int i = 0; i < initial_particle_count; i++)
  {
    particle_list.add(new_random_orbital_particle());
  }
}

void setup()
{
  size(800,800);
  
  colorMode(HSB, 100);
  
  particle_list = new LinkedList<OrbitalParticle>();
  initialize_particle_list();
  background(0);
}

/*
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
 */
 
void update(float t)
{
  if (particle_list.size() > 0)
  {
    Iterator<OrbitalParticle> it = particle_list.iterator();

    while(it.hasNext())
    {
      OrbitalParticle p = it.next();

      p.update(t);
      
      /*
      if ((black_hole_radius + black_hole_halo_width + rainbowdius) < p.pos.mag())
      {
        it.remove();
      }
      */
    }
    
    //add_new_particles(dt);
  }
}

void draw()
{
  
  pushMatrix();
  
  translate(width/2, height/2);
  
  float t = millis()/1000.0;
   
  update(t);
  
  if (do_ye_olde_blending_trick)
  {
    pushStyle();
    colorMode(ARGB);
    fill(0,0,0,254);
    rectMode(CENTER);
    fill(0,0,width,height);
    popStyle();
  } else {
    background(0);
  }
  
  pushStyle();
    for (OrbitalParticle p : particle_list)
    {
      stroke(color_field(p.pos.mag()));
      point(p.pos.x, p.pos.y); 
    }
  popStyle();
  popMatrix();
}

