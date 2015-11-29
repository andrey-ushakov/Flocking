// Class represents a boid
public class Boid {
  public PVector pos;  // current position
  public PVector dir;  // current direction
}


ArrayList<Boid> boids        = new ArrayList<Boid>();
final int boidSize           = 10;
final float speed            = 4;    // boids speed
final int perception         = 270;  // radius of perception
final int repulsion          = 40;   // radius of repulsion
final float alignmentWeight  = 1;
final float cohesionWeight   = 1;
final float repulsionWeight  = 1;


void setup() {
  size(800, 600);
  initBoids(100);    // generate 100 boids
}


void draw() {
  background(204);
  displayBoids();
  updateBoidsPosition();
}



PVector alignment(Boid boid) {
  PVector res = new PVector(0, 0);
  int nearBoidsCount = 0;
  
  for(int i=0; i<boids.size(); ++i) {
    if(boids.get(i).pos == boid.pos ) continue;
    
    if( isBoidInPerceptionZone(boid.pos, boids.get(i).pos) ) {
      res.add(boids.get(i).dir);
      nearBoidsCount++;
    }
  }
    
  if(nearBoidsCount == 0)
    return res;
  
  res.div(nearBoidsCount);
  res.sub(boid.dir).div(8);
  
  return res;
}


PVector cohesion(Boid boid) {
  PVector res = new PVector(0, 0);
  int nearBoidsCount = 0;
  
  for(int i=0; i<boids.size(); ++i) {
    if(boids.get(i).pos == boid.pos ) continue;
    
    if( isBoidInPerceptionZone(boid.pos, boids.get(i).pos) ) {
      res.add(boids.get(i).pos);
      nearBoidsCount++;
    }
  }
  
  if(nearBoidsCount == 0)
    return res;
  
  res.div(nearBoidsCount);
  res.sub(boid.pos).div(100);
  
  return res;
}


PVector repulsion(Boid boid) {
  PVector res = new PVector(0, 0);
  
  for(int i=0; i<boids.size(); ++i) {
    if(boids.get(i).pos == boid.pos ) continue;
    
    if( isBoidInRepulsionZone(boid.pos, boids.get(i).pos) ) {
      res.sub(PVector.sub(boids.get(i).pos, boid.pos));
    }
  }
  
  return res;
}


void updateBoidsPosition() {
  for (int i=0; i < boids.size(); ++i) {
    PVector alignmentV  = alignment(boids.get(i)).mult(alignmentWeight);
    PVector cohesionV   = cohesion(boids.get(i)).mult(cohesionWeight);
    PVector repulsionV  = repulsion(boids.get(i)).mult(repulsionWeight);

    // upd direction
    boids.get(i).dir.add(alignmentV).add(cohesionV).add(repulsionV).normalize().mult(speed);
    // upd position
    boids.get(i).pos.add(boids.get(i).dir);

    // screen bounds check
    if(boids.get(i).pos.x <= 0) {
      boids.get(i).pos.x = width;
    } else if(boids.get(i).pos.x >= width) {
      boids.get(i).pos.x = 0;
    }
    if(boids.get(i).pos.y <= 0) {
      boids.get(i).pos.y = height;
    } else if(boids.get(i).pos.y >= height) {
      boids.get(i).pos.y = 0;
    }
  }
}


void displayBoids() {
  for (int i=0; i < boids.size(); ++i) {
    strokeWeight(2);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, boidSize, boidSize);
  }
}


void initBoids(int boidsNum) {
   for (int i = 0; i < boidsNum; i++) {
     Boid boid = new Boid();
     boid.pos = new PVector(random(width), random(height));  // random position
     boid.dir = new PVector(random(width), random(height));  // random direction
     boids.add(boid);
   }
}


// c : center of perception zone
boolean isBoidInPerceptionZone(PVector c, PVector boid) {
  float dist = PVector.dist(c, boid);
  return dist < perception/2 && dist > repulsion/2;
}


// c : center of repulsion zone
boolean isBoidInRepulsionZone(PVector c, PVector boid) {
  return PVector.dist(c, boid) < repulsion/2;
}