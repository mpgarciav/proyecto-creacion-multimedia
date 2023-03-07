import processing.video.*;

CameraControl control;
Capture video;
int time;
JSONObject json;

float gap = 16;
int level = 255;
float normX = 0.9375;    // Normalization of x axis pixels between screen width and video width
float normY = 1.25;   // Normalization of y axis pixels between screen height and video height
int wait = 5000;

int SHAPE_MODE = int(random(5));    // 1: Boxes, 2: Spheres, 3: Hinges
int COLOR_MODE = int(random(4));    // 1: Normal, 2: Sensor, 3: B&W, 4: Palettes
Palette PALETTE = getRandomPalette();

public class Pixel {
  float posX;
  float posY;
  color clr;
  float avg;
  
  public Pixel (float posX, float posY, color clr) {
    this.posX = posX;
    this.posY = posY;
    this.clr = clr;
    this.avg = (red(clr) + green(clr) + blue(clr)) / 3;
  }
  
  void draw () {
    pushMatrix();
    
    switch(SHAPE_MODE){
      case 0: { // BOXES
        float grow = map(this.avg, 255, 0, 0, level);
        float posZ = grow / 2;

        translate(this.posX, this.posY, posZ);
        box(gap * normX, gap * normY, grow);
        
        break;
      }
      case 1: { // SPHERES
        noStroke();
        
        float grow = map(this.avg, 255, 0, gap, gap * 4);
        
        translate(this.posX, this.posY, 0);
        sphereDetail(10);
        sphere(grow);
        
        stroke(1);
        
        break;
      }
      case 2: { // XHINGES
        float rotation = map(this.avg, 0, 255, 0, 2 * PI);
        
        translate(this.posX, this.posY, 0);
        rotateX(rotation);
        box(gap * normX, gap * normY, 2);
        
        break;
      }
      case 3: { // YHINGES
        float rotation = map(this.avg, 0, 255, 0, 2 * PI);
        
        translate(this.posX, this.posY, 0);
        rotateY(rotation);
        box(gap * normX, gap * normY, 2);
        
        break;
      }
      case 4: { // ZHINGES
        float rotation = map(this.avg, 0, 255, 0, 2 * PI);
        
        translate(this.posX, this.posY, 0);
        rotateZ(rotation);
        box(gap * normX, gap * normY, 2);
        
        break;
      }
    }
    
    switch(COLOR_MODE){
      case 0: { // NORMAL
        colorMode(RGB);
        fill(this.clr);
        
        break;
      }
      case 1: { // SENSOR
        colorMode(HSB, 360, 100, 100);
        fill(map(this.avg, 0, 255, 0, 230), 100, 100);
        
        break;
      }
      case 2: { // B&W
        colorMode(RGB);
        fill(this.avg);
        
        break;
      }
      case 3: { // PALETTE
        colorMode(HSB, 360, 100, 100);
        fill(map(this.avg, 0, 255, PALETTE.fromColor, PALETTE.toColor), PALETTE.saturation, 100);
        
        break;
      }
    }

    popMatrix();
  }
}


void setup(){
  size(600, 600, P3D);
  // fullScreen(P3D);
 
  control = new CameraControl(this);
  video = new Capture(this);
  video.start();
  
  time = millis();
}

void keyPressed() {
  if (key == '+') {
      gap = gap / 2;
    }
    if (key == '-') {
      gap = gap * 2;
    }
}


void draw() {
  if(millis() - time >= wait){
    SHAPE_MODE = int(random(5));
    COLOR_MODE = int(random(4));
    PALETTE = getRandomPalette();
    time = millis();
  }

  if(video.available()){
    video.read();
  }
  
  image(video, 0, 0, width, height);
  
  background(255);
  
  video.loadPixels();
  
  for(int i = 0; i < video.width; i += gap){
    for(int j = 0; j < video.height; j += gap){
      int pixel = i + j * video.width;
      float posX = i * normX;
      float posY = j * normY;
      color c = video.pixels[pixel];

      Pixel p = new Pixel(posX, posY, c);

      p.draw();
    }  
  }
}

RangeColor[] getAvailableRanges(){
  RangeColor[] colors = new RangeColor[5];
  boolean reversed = round(random(1)) == 1 ? true : false;
  colors[0] = new RangeColor(0, 90, reversed);
  colors[1] = new RangeColor(40, 180, reversed);
  colors[2] = new RangeColor(180, 270, reversed);
  colors[3] = new RangeColor(270, 360, reversed);
  colors[4] = new RangeColor(0, 360, reversed);
  return colors;
}

Palette getRandomPalette(){
  RangeColor[] ranges = getAvailableRanges();
  RangeColor randomRangeColor = ranges[int(random(ranges.length))]; 
  return new Palette(randomRangeColor.from, randomRangeColor.to, random(50) + 50);
}

// RECOMENDACIONES
// * 1. Las constantes de normalización deben ser asignadas dependiendo del tamaño de la cámara. Ejemplo: 800/640
// * 2. 
