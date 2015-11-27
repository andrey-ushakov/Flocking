
public class Boid {
  public PVector pos;  // current position
  public PVector dir;  // current direction
}


ArrayList<Boid> boids = new ArrayList<Boid>();
int boidSize         = 10;
final float speed    = 4;
final int perception = 80;  // radius of perception
final int repulsion  = 30;  // radius of repulsion
color boidC          = color(255, 255, 255);
color repulsionC     = color(238, 0, 0);
color perceptionC    = color(205, 205, 0);
int maxDirLength     = 100;
PVector g            = new PVector(600, 200);
PVector r            = new PVector(200, 400);


void setup() {
  size(800, 600);
  //size(displayWidth, displayHeight);
  initBoids(30);

}


void draw() {
  background(204);
  
  displayBoids();
  updateBoidsPosition();
}



PVector alignment(Boid boid) {
  PVector res = new PVector(0, 0);
  int nearBoidsCount = 0;
  
  for (int i=0; i < boids.size(); ++i) {
    if(boid.pos == boids.get(i).pos) continue;
    
    if(isBoidInPerceptionZone(boid.pos, boids.get(i).pos)) {
      res = PVector.add(res, boids.get(i).dir);
      nearBoidsCount++;
    }
  }
  
  // no neighbors : return 0
  if (nearBoidsCount == 0) {
    return res;
  }
    
  // divide by nearBoidsCount and normalize
  res = PVector.div(res, nearBoidsCount).normalize();
  return res;
}


PVector cohesion(Boid boid) {
  PVector res = new PVector(0, 0);
  int nearBoidsCount = 0;
  
  for (int i=0; i < boids.size(); ++i) {
    if(boid.pos == boids.get(i).pos) continue;
    
    if(isBoidInPerceptionZone(boid.pos, boids.get(i).pos)) {
      res = PVector.add(res, boids.get(i).pos);
      nearBoidsCount++;
    }
  }
  
  // no neighbors : return 0
  if (nearBoidsCount == 0) {
    return res;
  }
  
  // divide by nearBoidsCount
  res = PVector.div(res, nearBoidsCount);
  // distance from current boid to the center of mass of his neighbors
  res = PVector.sub(res, boid.pos).normalize();
  return res;
}


PVector repulsion(Boid boid) {
  PVector res = new PVector(0, 0);
  int nearBoidsCount = 0;
  
  for (int i=0; i < boids.size(); ++i) {
    if(boid.pos == boids.get(i).pos) continue;
    
    if(isBoidInRepulsionZone(boid.pos, boids.get(i).pos)) {
      PVector dist = PVector.sub(boid.pos, boids.get(i).pos);
      res = PVector.add(res, dist);
      nearBoidsCount++;
    }
  }
  
  // no neighbors : return 0
  if (nearBoidsCount == 0) {
    return res;
  }
  
  // divide by nearBoidsCount
  res = PVector.div(res, nearBoidsCount);
  
  // distance from current boid to the center of mass of his neighbors
  res = PVector.sub(res, boid.pos).normalize();
  //res = PVector.mult(res, -1).normalize();
  return res;
}


void updateBoidsPosition() {
  for (int i=0; i < boids.size(); ++i) {
    PVector alignmentV  = alignment(boids.get(i)).mult(0.1);
    PVector cohesionV   = cohesion(boids.get(i)).mult(0.5);
    PVector repulsionV  = repulsion(boids.get(i)).mult(0.1);
    
    boids.get(i).dir = boids.get(i).dir.add(alignmentV).add(cohesionV).add(repulsionV);
    
    // normilize and set speed
    boids.get(i).dir.normalize();
    boids.get(i).dir = PVector.mult(boids.get(i).dir, speed);
    
    boids.get(i).pos = PVector.add(boids.get(i).pos, boids.get(i).dir);
    
    if (boids.get(i).pos.x <= 0 || boids.get(i).pos.x >= width){
      boids.get(i).dir.x = -boids.get(i).dir.y;
    }
    if (boids.get(i).pos.y <= 0 || boids.get(i).pos.y >= height){
      boids.get(i).dir.y = -boids.get(i).dir.y;
    }
  }
}

void displayBoids() {
  for (int i=0; i < boids.size(); ++i) {
    // perception
    noStroke();
    fill(perceptionC, 25);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, perception, perception);
    
    // repulsion
    fill(repulsionC, 25);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, repulsion, repulsion);
    
    // boid
    stroke(1);
    fill(boidC);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, boidSize, boidSize);
    strokeWeight(2);
    //line(boids.get(i).pos.x, boids.get(i).pos.y, boids.get(i).dir.x, boids.get(i).dir.y);
  }
}


void initBoids(int boidsNum) {
  for (int i = 0; i < boidsNum; i++) {
    Boid boid = new Boid();
    boid.pos = new PVector(random(width), random(height));
    
    // generate random direction
    PVector temp = new PVector(random(width), random(height));        // random point
    PVector subV = PVector.sub(temp, boid.pos).normalize();  // normilized vector between 2 points
    PVector resMult = PVector.mult(subV, maxDirLength);                // increase normilized vector length
    boid.dir = PVector.add(boid.pos, resMult);               // move vector
    //boid.dir = temp;
    
    boids.add(boid);
  }
}


// c : center of perception zone
boolean isBoidInPerceptionZone(PVector c, PVector boid) {
  return PVector.dist(c, boid) < perception;
}


// c : center of repulsion zone
boolean isBoidInRepulsionZone(PVector c, PVector boid) {
  return PVector.dist(c, boid) < repulsion;
}