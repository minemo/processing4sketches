/*
--Discrete Fourier Transform--
-> only rowwise
*/
PImage src,dst;

void setup() {
  size(512,512, P2D);
  src = loadImage("https://w.wallhaven.cc/full/dp/wallhaven-dpv8lj.jpg");
  src.resize(width,height);
  src.loadPixels();
  dst = createImage(src.width, src.height, RGB);
}

void draw() {
  clear();
  transform();
  image(dst,0,0);
}

void transform() {
  for(int y = 0; y<src.height;y++) {
    color[] pxls = new color[src.width];
    for(int x = 0; x<src.width;x++){
      pxls[x] = src.pixels[y*src.width+x];
    }
    
    //---Display averages---
    dst.loadPixels();
    color[] dftb = dft(pxls);
    for(int i = 0; i < dftb.length; i++) {
      if(brightness(dftb[i]) < 127){
        dst.pixels[y*dst.width+i] = color(255,0,0);
      }else{
        dst.pixels[y*dst.width+i] = dftb[i];
      }
    }
    dst.updatePixels();
    
  }
}

float averageBrght(color[] colors) {
  float acc = 0;
  for(color c: colors) {
    acc += brightness(c);
  }
  return acc / colors.length;
}

color averageClr(color[] colors) {
  int ar,ag,ab;
  ar = ab = ag = 0;
  for(color c: colors) {
    ar += red(c);
    ag += green(c);
    ab += blue(c);
  }
  ar /= colors.length;
  ag /= colors.length;
  ab /= colors.length;
  return color(ar,ag,ab);
}

color[] dft(color[] x) {
  int n = x.length;
  color[] out = new color[n];
  
  for(int k = 0; k < n; k++) {
    float sumr,sumg,sumb;
    sumr = 0;
    sumg = 0;
    sumb = 0;
    for(int t = 0; t < n; t++) {
      float val = 2*PI*t*k/n;
      sumr += red(x[k])*cos(val);
      sumg += green(x[k])*cos(val);
      sumb += blue(x[k])*cos(val);
    }
    out[k] = color(map(sumr, -1,1,0,255), map(sumg, -1,1,0,255), map(sumb, -1,1,0,255));
  }
  return out;
}
