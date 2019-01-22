class Block {
  BigDecimal x;
  BigDecimal y;
  int w;
  int h;
  BigInteger m;
  BigDecimal v;
  
  Block(float x, float y, int w, int h, BigInteger m, double v) {
    this.x = new BigDecimal(Float.toString(x));
    this.y = new BigDecimal(Float.toString(y));
    this.w = w;
    this.h = h;
    this.m = m;
    this.v = new BigDecimal(Double.toString(v));
  }
  
  BoundingBox boundingBox() {
    BigDecimal right = x.add(new BigDecimal(Integer.toString(w)));
    BigDecimal bottom = y.add(new BigDecimal(Integer.toString(h)));
    return new BoundingBox(x, right, y, bottom);
  }
  
  void move() {
    x = x.add(v);
  }
}
