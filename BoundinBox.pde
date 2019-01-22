class BoundingBox {
  BigDecimal left;
  BigDecimal right;
  BigDecimal top;
  BigDecimal bottom;
  
  BoundingBox(BigDecimal left, BigDecimal right, BigDecimal top, BigDecimal bottom) {
    this.left = left;
    this.right = right;
    this.top = top;
    this.bottom = bottom;
  }
}
