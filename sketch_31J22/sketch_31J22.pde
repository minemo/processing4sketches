import g4p_controls.*;

GWindow debugWindow;
PImage source, dest;
ArrayList<Integer> visited = new ArrayList<Integer>();
boolean both = true;
int maxit = 1024;

void setup() {
  //Setup Processing stuff
  size(512,512, P2D);
  background(0);
  noLoop();
  surface.setTitle("Main View");
  
  //Setup Images
  source = loadImage("https://w.wallhaven.cc/full/z8/wallhaven-z8dg9y.png");
  source.resize(512,512);
  source.loadPixels();
  dest = createImage(source.width,source.height,RGB);
  System.out.println("Ready");
  
  
  //Setup 2nd window
  if(both) {
    debugWindow = GWindow.getWindow(this, "Debug View", 100, 50, source.width, source.height, P2D);
    debugWindow.addDrawHandler(this, "debugDraw");
  }
  
}

void draw() {
  clear();
  for(int x = 1; x < width; x+=16){
    for(int y = 1; y < height; y+=16){
      drawVisited();
      process(x,y,0);
    }
  }
  image(dest,0,0);
}

void debugDraw(PApplet app, GWinData data) {
  //app.clear();
  app.image(source,0,0);
}


void mouseDragged() {
  process(mouseX,mouseY,0);
}



void drawVisited(){
  source.loadPixels();
  for(int v: visited) {
    source.pixels[v] = color(255,0,0);
  }
  source.updatePixels();
}

void process(int x, int y, int it) {
  it++;
  if((x>0 && y>0)&&(x<width-1 && y<height-1)){
    if(it <= maxit) {
      int nx,ny;
      dest.loadPixels();
      for(int dx = -1; dx < 2; dx++) {
        for(int dy = -1; dy < 2; dy++) {
          nx = x+dx;
          ny = y+dy;
          if((source.pixels[ny*source.width+nx] <= source.pixels[y*source.width+x])&&(visited.indexOf(ny*source.width+nx)==-1)) {
            //dest.pixels[y*source.width+x] = lerpColor(color(0),source.pixels[y*source.width+x], 1-it/maxit);
            dest.pixels[y*source.width+x] = color(it/4);
            visited.add(y*source.width+x);
            process(nx, ny, it);
          }
          continue;
        }
      }
      dest.updatePixels();
    } else {
      return;
    }
  } else {
    return;
  }
}
