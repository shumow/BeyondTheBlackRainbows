final boolean draw_segments = true;

void setup()
{ size(500, 500,P3D);}

void draw()
{
  background(0);
  //position the void in the middle
  translate(width/2, height/2);
  drawRainbowVoid();
}

void drawRainbowVoid()
{
  //cache tm as floating point seconds
  float tm = millis()/1000.f;
  float voidRadius = 100; 
  float lineCount = 100; 
  
  for (int i = 0; i < lineCount; i++)
  {
    float pct = i*1.f/lineCount;
    pushMatrix();
    rotate(TWO_PI*pct);
    //stroke weight - 6 modulated three times around the circumference and moving in time
    float wt = 6*(1+sin(-tm+3*pct*TWO_PI))/2;
    strokeWeight(wt);
    translate(voidRadius, 0);
    // line length 100 + some noise modulated around the circumference
    float lineLength = 100 + 55*noise(i/5.f+tm); 
    drawLine(lineLength);
    popMatrix();
  }
}

void drawLine(float len)
{
  pushStyle();
  // use HSB (hue saturation brightness) mode to just change the hue as  
  // we travel down the line producing a nice rainbow color scheme
  colorMode(HSB, 255);
  //number of segments in the line to draw more segments = finer gradient detail
  int segments = 100;
  
  if (!draw_segments)
  {
    segments = 20;
  }
  
  noFill();
  if (draw_segments)
  {
    beginShape();
  }
  for (int i = 0; i < segments; i++)
  {
    float pct = i*1.f/segments;
    //color could also be based on the relative distance between two points...
    int color_ = color(255*pct, 255, 255);
    stroke(color_);
    if (draw_segments)
    {
      vertex(len*pct, 0);
    } else {
      point(len*pct, 0);
    }
  }
  if (draw_segments)
  {
    endShape();
  }
  popStyle();
}

