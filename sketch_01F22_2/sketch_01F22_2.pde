
PImage src, dst;
ArrayList<Integer> visited = new ArrayList<Integer>();
String url = "https://w.wallhaven.cc/full/z8/wallhaven-z8dg9y.png";
int maxit = 16;

void setup() {
  size(512, 512);
  background(0);
  noFill();
  noLoop();

  src = loadImage(url);
  src.resize(width, height);
  src.loadPixels();
  dst = createImage(src.width, src.height, RGB);
}

void draw() {
  clear();
  stroke(255);
  strokeWeight(1);
  //image(src, 0, 0);
  //greedyBoi(mouseX, mouseY, 0);
  loopXY(32,32);
}

void loopXY(int sx, int sy) {
  for(int x = 1; x < width; x+=sx) {
    for(int y = 1; y < height; y+=sy) {
      greedyBoi(x+16, y+16, 0);
    }
  }
}


void greedyBoi(int x, int y, int it) {
  if ((x > 0 && x < width)&&(y > 0 && y < height)) {
    if (it <= maxit) {
      it++;
      int nx, ny;
      //dst.loadPixels();
      for (int dx = -1; dx < 2; dx++) {
        for (int dy = -1; dy < 2; dy++) {
          nx = x+dx;
          ny = y+dy;
          if ((src.pixels[y*src.width+x] > src.pixels[ny*src.width+nx])&&
            (visited.indexOf(y*src.width+x) == -1 && visited.indexOf(dy*src.width+dx) == -1)) {
            stroke(src.pixels[y*src.width+x]);
            circle(x, y, it*5);
            visited.add(y*src.width+x);
            greedyBoi(nx, ny, it);
          } else {
            continue;
          }
        }
      }
    }
  }
}
