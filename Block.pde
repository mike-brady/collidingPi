class Block {
  float x;
  float y;
  int w;
  int h;
  long m;
  double v;
  
  Block(float x, float y, int w, int h, long m, double v) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.m = m;
    this.v = v;
  }
  
  float[] boundingBox() {
    return new float[]{x,x+w,y,y+h};
  }
  
  void move() {
    x += v;
  }
}
