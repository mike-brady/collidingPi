Block block1 = new Block(200,10,10,10,1,0);
Block block2 = new Block(400,10,100,100,1000000000000L,-2);
Block wall = new Block(0,0,10,200,-1,0);
Block floor = new Block(0,0,600,10,0,0);

int count = 0;
float wallEdge = wall.boundingBox()[1];

void setup() {
  size(600, 200);
  noStroke();
}

void draw() {
  background(200);
  
  block1.move();
  block2.move();
  
  boolean blockCollision = collision(block1, block2);
  
  while(blockCollision || block1.x < wallEdge) {    
    if(blockCollision) {
      count++;
      bounce(block1, block2);
      block1.x = Math.max(block1.x, wallEdge-1);
    }
    
    if(block1.x < wallEdge) {
      count++;
      bounce(block1, wall);
      block1.x = Math.min(block1.x, block2.x+1);
    }
    
    blockCollision = collision(block1, block2);
  }
  
  fill(255);
  rect(block1.x, height-block1.y-block1.h, block1.w, block1.h);
  rect(block2.x, height-block2.y-block2.h, block2.w, block2.h);
  fill(0);
  rect(wall.x, height-wall.y-wall.h, wall.w, wall.h);
  rect(floor.x, height-floor.y-floor.h, floor.w, floor.h);
  
  if(block1.v >= 0 && block2.v > block1.v) {
    println("Total collisions: "+Integer.toString(count));
    if(block1.x > width) {
      noLoop();
    }
  } else {
    println(Integer.toString(count));
  }
}


boolean collision(Block a, Block b) {
  float[] bbA = a.boundingBox();
  float[] bbB = b.boundingBox();
  
  if(
    bbA[1] > bbB[0] && bbA[0] < bbB[1] &&
    bbA[3] > bbB[2] && bbA[2] < bbB[3]
    ) {
      return true;
    }
  
  return false;
}


void bounce(Block a, Block b) {
  if(a.m == -1) {
    b.v *= -1;
    b.move();
  }
  else if(b.m == -1) {
    a.v *= -1;
    a.move();
  }
  else {
    double v1 = a.v;
    double v2 = b.v;
    long m1 = a.m;
    long m2 = b.m;
    
    a.v = ((2*m2*v2) + v1*(m1 - m2)) / (m1 + m2);
    b.v = ((2*m1*v1) + v2*(m2 - m1)) / (m1 + m2);
    a.move();
    b.move();
  }
}
