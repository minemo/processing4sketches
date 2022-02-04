import g4p_controls.*;

import de.voidplus.leapmotion.*;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

DwFluid2D fluid;

PGraphics2D pg_fluid;

PImage source;

String[] images = {"1.png", "2.png", "3.png", "4.png"};

void setup() {
  size(768, 768, P2D);
  
  
  source = loadImage(images[int(random(0,images.length))]);
  source.resize(width,height);
  
  
  DwPixelFlow context = new DwPixelFlow(this);
  
  fluid = new DwFluid2D(context, width, height, 1);
  
  fluid.param.dissipation_velocity = 0.7;
  fluid.param.dissipation_density = 0.99;
  
  fluid.addCallback_FluiData(new  DwFluid2D.FluidData() {
    public void update(DwFluid2D fluid) {
      if (mousePressed && mouseButton == LEFT) {
        source.loadPixels();
        for(int x=1; x < width;x+=8){
          for(int y=1; y < height;y+=8){
            int px = x;
            int py = height-y;
            int r = (source.pixels[y*width+x] >> 16) & 0xFF;
            int g = (source.pixels[y*width+x] >> 8) & 0xFF;  
            int b = source.pixels[y*width+x] & 0xFF;
            float vx     = (r/255.0)*50;
            float vy     = (b/255.0)*50;
            fluid.addVelocity(px, py, ((r+g+b)/23)/2, vx, vy);
            fluid.addDensity (px, py, ((r+g+b)/33)+5, r/255.0, g/255.0, b/255.0, 1.0f);
          }
        }
      } else if(mousePressed && mouseButton == RIGHT) {
        fluid.addVelocity(mouseX, height-mouseY, 10, random(1,50), random(1,50));
      }
    }
  });

  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
}

void draw() {
  // Update simulation
  fluid.update();

  // Clear render target
  pg_fluid.beginDraw();
  pg_fluid.background(0);
  pg_fluid.endDraw();

  // Render fluid stuff
  fluid.renderFluidTextures(pg_fluid, 0);

  // Display
  image(pg_fluid, 0, 0);
}
