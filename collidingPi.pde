import java.math.BigInteger;
import java.math.BigDecimal;
import java.math.MathContext;

int digits = 5;

MathContext mc = new MathContext(25);

Block block1 = new Block(200, 10, 20, 20, new BigInteger("1"), 0);
Block block2 = new Block(400, 10, 100, 100, new BigInteger("1"), -2);
Block wall = new Block(0, 0, 10, 200, new BigInteger("-1"), 0);
Block floor = new Block(0, 0, 800, 10, new BigInteger("-1"), 0);
BigDecimal wallEdge = wall.boundingBox().right;

BigInteger count = new BigInteger("0");

int start = 0;
int end = -1;

void setup() {
  size(800, 200);
  noStroke();
  
  BigInteger m2 = block1.m;
  BigInteger multiple = new BigInteger("100");
  for(int i=0; i<digits-1; i++) {
    m2 = m2.multiply(multiple);
  }
  block2.m = m2;
  
  println("Block 1 mass (m1) = " + block1.m + " kg");
  println("Block 2 mass (m2) = m1 * 100^" + (digits-1) + " = 1.00e" + (digits-1)*2 + " kg");
  start = millis();
}

void draw() {
  block1.move();
  block2.move();
  
  boolean blockCollision = collision(block1, block2);
  
  //While blockCollision || block1.x < wallEdge
  while(blockCollision || block1.x.compareTo(wallEdge) < 0) {    
    if(blockCollision) {
      count();
      bounce(block1, block2);
      block1.x = block1.x.max(wallEdge.subtract(BigDecimal.ONE));
    }
    
    if(block1.x.compareTo(wallEdge) == -1) {
      count();
      bounce(block1, wall);
      block1.x = block1.x.min(block2.x.add(BigDecimal.ONE));
    }
    
    blockCollision = collision(block1, block2);
  }
  
  
  background(200);
  fill(255);
  rect(block1.x.intValue(), height-block1.y.intValue()-block1.h, block1.w, block1.h);
  rect(block2.x.intValue(), height-block2.y.intValue()-block2.h, block2.w, block2.h);
  fill(0);
  rect(wall.x.intValue(), height-wall.y.intValue()-wall.h, wall.w, wall.h);
  rect(floor.x.intValue(), height-floor.y.intValue()-floor.h, floor.w, floor.h);
  
  //If block1.v >= 0 && block2.v >= block1.v
  if(block1.v.compareTo(BigDecimal.ZERO) >= 0 && block2.v.compareTo(block1.v) >= 0) {
    if(end == -1) {
      end = millis();
      
      BigDecimal pi = new BigDecimal(count).divide(new BigDecimal("10").pow(digits-1), new MathContext(digits));
      println("Total collisions: "+count);
      println("Pi "+char(126)+" "+pi);
      println("Time to compute: "+Float.toString(end/1000.0)+ " seconds");
    }
    
    //If block1.x > width of window
    if(block1.x.compareTo(new BigDecimal(Integer.toString(width))) == 1) {
      noLoop();
    }
  } else {
    //println(count);
  }
}


boolean collision(Block a, Block b) {
  BoundingBox bbA = a.boundingBox();
  BoundingBox bbB = b.boundingBox();
  
  if(
    bbA.right.compareTo(bbB.left) > 0 && bbA.left.compareTo(bbB.right) < 0 &&
    bbA.bottom.compareTo(bbB.top) > 0 && bbA.top.compareTo(bbB.bottom) < 0
    ) {
      return true;
    }
  
  return false;
}

void count() {
  count = count.add(BigInteger.ONE);
}

void bounce(Block a, Block b) {
  if(a.m.compareTo(new BigInteger("-1")) == 0) {
    b.v = b.v.negate();
    b.move();
  }
  else if(b.m.compareTo(new BigInteger("-1")) == 0) {
    a.v = a.v.negate();
    a.move();
  }
  else {
    BigDecimal v1 = a.v;
    BigDecimal v2 = b.v;
    BigDecimal m1 = new BigDecimal(a.m);
    BigDecimal m2 = new BigDecimal(b.m);
    
    
    BigDecimal mSum = m1.add(m2);
    
    a.v = m2.multiply(v2).multiply(new BigDecimal("2"));
    a.v = a.v.add( v1.multiply(m1.subtract(m2)) );
    a.v = a.v.divide( mSum, mc );
    
    b.v = m1.multiply(v1).multiply(new BigDecimal("2"));
    b.v = b.v.add( v2.multiply(m2.subtract(m1)) );
    b.v = b.v.divide( mSum , mc);
    
    a.move();
    b.move();
  }
}
