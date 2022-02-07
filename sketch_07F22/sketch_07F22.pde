import processing.svg.*;

PImage src;
ArrayList<PVector> points = new ArrayList<PVector>();
FloatDict dists = new FloatDict();

void setup() {
  // Setup some stuff
  size(768, 768);
  noSmooth();
  noFill();
  strokeWeight(1);
  stroke(255);
  frameRate(30);

  // Load Image to use
  String url = "https://w.wallhaven.cc/full/72/wallhaven-72rd8e.jpg";
  src = loadImage(url);
  src.resize(width, height);

  // Dither Image
  dither(src, 16);
  
  // Write to SVG ?
  //beginRecord(SVG, "dithercircles.svg");
}

void draw() {
  clear();
  background(0);
  
  // Draw dithered image 
  //image(src, 0, 0);
  
  // Set steps
  int step = 16;
  
  //Animated ?
  float xan = (width/2)+sin((frameCount/frameRate))*(width/3);
  float yan = (height/2)+cos((frameCount/frameRate))*(width/3);
  xan = mouseX;
  yan = mouseY;
  
  //draw for X and Y axis
  for (int x = step; x <= width-step; x+=step) {
    for (PVector p : points) {
      dists.set(str(points.indexOf(p)), dist(p.x, p.y, x, yan));
    }
    dists.sortValues();
    PVector closest = points.get(int(dists.keyArray()[0]));
    circle(closest.x, closest.y, dists.valueArray()[0]);
    line(x,yan, closest.x, closest.y);
  }
  for (int y = step; y <= height-step; y+=step) {
    for (PVector p : points) {
      dists.set(str(points.indexOf(p)), dist(p.x, p.y, xan, y));
    }
    dists.sortValues();
    PVector closest = points.get(int(dists.keyArray()[0]));
    circle(closest.x, closest.y, dists.valueArray()[0]);
    line(xan, y, closest.x, closest.y);
  }
  
  // Enable when writing SVG
  //endRecord();
}

// Not used threshold function
void thresh(PImage img, int thresh) {
  img.loadPixels();
  for (int i = 0; i<img.pixels.length; i++) {
    if (brightness(img.pixels[i]) < thresh) {
      img.pixels[i] = color(0);
    } else {
      img.pixels[i] = color(255);
    }
  }
  img.updatePixels();
}

// Dither function
void dither(PImage img, int step) {
  points.clear();
  img.loadPixels();
  for (int y = 1; y<img.height-1; y++) {
    for (int x = 1; x<img.width-1; x++) {
      float oldp = brightness(img.pixels[y*img.width+x])/step;
      float newp = round(oldp)*step;
      float error = oldp-newp;
      if (error == 0) {
        points.add(new PVector(x, y));
      }
      img.pixels[y*img.width+x] = color(newp);
      img.pixels[y*img.width+(x+1)] = color(brightness(img.pixels[y*img.width+(x+1)]) + error * 7/16);
      img.pixels[(y+1)*img.width+(x-1)] = color(brightness(img.pixels[(y+1)*img.width+(x-1)]) + error * 3/16);
      img.pixels[(y+1)*img.width+x] = color(brightness(img.pixels[(y+1)*img.width+x]) + error * 5/16);
      img.pixels[(y+1)*img.width+(x+1)] = color(brightness(img.pixels[(y+1)*img.width+(x+1)]) + error * 1/16);
    }
  }
  img.updatePixels();
  
  //Print out number of points where no error
  println(points.size());
}
