ArrayList<PVector> ps = new ArrayList<PVector>();
float timescale;
int numps;

void setup() {
  // Boring stuff
  size(768, 768);
  frameRate(30);
  noFill();
  stroke(255);
  
  // Number of Points and Timescale
  numps = 50;
  timescale = frameRate*4;
}

void draw() {
  clear();
  float time = frameCount/timescale;
  ps = generate(int(abs(sin(time))*width/2), int(abs(cos(time))*height/2), numps);
  for(PVector p: ps) {
    strokeWeight(ps.indexOf(p)/10);
    circle(p.x, p.y, p.z);
    circle(p.y, p.x, p.z);
    line(p.x, p.y, p.y, p.x);
  }
  // Enable if you want to save Frames
  /*
  if(frameCount < 756) {
    saveFrame();
  } else {
    println("Frames Saved...");
    delay(5000);
  }
  */
}

ArrayList<PVector> generate(int sx, int sy, int np) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for(int i=0; i <= np; i++) {
    // The stuff that actually animates everything
    float nx = sx*sin(i)+width/2;
    float ny = sy*cos(i)+height/2;
    // Here's another variant
    ny = sy*cos(i/sqrt(nx))+height/2;
    points.add(new PVector(nx, ny, tan(i)*10));
  }
  return points;
}
