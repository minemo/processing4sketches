import fisica.*;

FWorld world;
PImage source;


void setup() {
  size(512, 512, P2D);
  

  source = loadImage("https://w.wallhaven.cc/full/z8/wallhaven-z8dg9y.png");
  source.resize(width, height);
  source.loadPixels();

  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);

  //instanceCubes(12);
}

void draw() {
  clear();
  try{
    world.step();
    world.draw();
  } catch(AssertionError a){
    world.clear();
    println("---Physics are hard ok---");
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    //iterateBoxes(mouseX, mouseY);
    world.clear();
    world.setEdges();
  }
}

void mouseDragged() {
  if (mouseButton == RIGHT) {
    //iterateBoxes(mouseX, mouseY);
    spawnBox(mouseX, mouseY, 8);
  }
}


void instanceCubes(int step) {
  for (int x = 1; x < width; x+=step) {
    for (int y = 1; y < height; y+=step) {
      color fillcol = source.pixels[int(y*source.width+x)];
      FBox pixbox = new FBox(step/2, step/2);
      pixbox.adjustPosition(x, y);
      pixbox.setNoStroke();
      pixbox.setFillColor(fillcol);
      world.add(pixbox);
    }
  }
}

void spawnBox(int x, int y, int size) {
  color fillcol = source.pixels[int(y*source.width+x)];
  float siz = map(brightness(fillcol), 0, 255, 5, 10);
  FBox pixbox = new FBox(siz, siz);
  pixbox.adjustPosition(x+random(siz,siz*2), y+random(siz,siz*2));
  pixbox.setNoStroke();
  pixbox.setFillColor(fillcol);
  world.add(pixbox);
}

void iterateBoxes(int x, int y) {
  ArrayList<FBody> startbod = world.getBodies(x, y, false, 1);
  if (startbod.size() != 0) {
    ArrayList<FBody> visits = new ArrayList<FBody>();
    searchConnections(startbod.get(0), 0, visits);
  }
}
void iterateBody(float x, float y) {
  ArrayList<FBody> all = world.getBodies();
  for (FBody b : all) {
    if (!b.isStatic()) {
      b.addForce(x,y);
      int wx = floor(b.getX())%source.width;
      int wy = floor(b.getY())%source.height;
      b.setFillColor(source.pixels[wy*source.width+wx]);
    }
  }
}

void searchConnections(FBody body, int it, ArrayList<FBody> visited) {
  if (it < 32) {
    ArrayList<FBody> connections = body.getTouching();
    int conlen = connections.size();
    int wx = floor(body.getX())%source.width;
    int wy = floor(body.getY())%source.height;
    body.setFillColor(source.pixels[wy*source.width+wx]);
    if (conlen > 0) {
      for (FBody c : connections) {
        if (visited.indexOf(body) == -1) {
          visited.add(body);
          searchConnections(c, it++, visited);
          continue;
        } else {
          continue;
        }
      }
    } else {
      return;
    }
  } else {
    return;
  }
}
