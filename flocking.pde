
// TODO Add border collision

public class Boid {
  public PVector pos;  // current position
  public PVector dir;  // current direction
}


ArrayList<Boid> boids = new ArrayList<Boid>();
int boidSize         = 10;
final int W          = 800;
final int H          = 600;
final float speed    = 0.01;
final int perception = 80;  // radius of peception
final int repulsion  = 30;  // radius of repulsion
color boidC          = color(255, 255, 255);
color repulsionC     = color(238, 0, 0);
color perceptionC    = color(205, 205, 0);



void setup() {
  size(800, 600);
  
  initBoids(10);

}


void draw() {
  background(204);
  
  displayBoids();
  updateBoidsDirection();
  updateBoidsPosition();
}




void updateBoidsDirection() {
  for (int i=0; i < boids.size(); ++i) {
    PVector accel = new PVector(0, 0);
    
    for (int j=0; j < boids.size(); ++j) {
      if(i != j) {
        // calculate acceleration vector
        PVector vect = PVector.sub(boids.get(j).pos, boids.get(i).pos);  // vector between 2 boids
        if( isBoidInRepulsionZone(boids.get(i).pos, boids.get(j).pos) ) {
          // TODO Add force
          accel = PVector.sub(accel, vect);  // repulsion
        } else if( isBoidInPerceptionZone(boids.get(i).pos, boids.get(j).pos) ) {
          // TODO Add force
          accel = PVector.add(accel, vect);  // attraction
        } else {
          // do nothing : out of perception zone
        }
        
        // update i-boid direction
        boids.get(i).dir = PVector.add(boids.get(i).dir, accel);
      }
    }
  }
}

void updateBoidsPosition() {
  for (int i=0; i < boids.size(); ++i) {
    PVector vect = PVector.mult(PVector.sub(boids.get(i).dir, boids.get(i).pos), speed);
    boids.get(i).pos = PVector.add(boids.get(i).pos, vect);

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
    //line(boids.get(i).pos.x, boids.get(i).pos.y, boids.get(i).dir.x, boids.get(i).dir.y);
  }
}


void initBoids(int boidsNum) {
  for (int i = 0; i < boidsNum; i++) {
    Boid boid = new Boid();
    boid.pos = new PVector(random(W), random(H));
    
    // generate random direction
    PVector temp = new PVector(random(W), random(H));        // random point
    PVector subV = PVector.sub(temp, boid.pos).normalize();  // normilized vector between 2 points
    PVector resMult = PVector.mult(subV, 100);                // increase normilized vector length
    boid.dir = PVector.add(boid.pos, resMult);               // move vector
    
    
    boids.add(boid);
  }
}


// c : center of perception zone
boolean isBoidInPerceptionZone(PVector c, PVector boid) {
  float a = pow(boid.x - c.x, 2);
  float b = pow(boid.y - c.y, 2);
  return a + b < pow(perception, 2);
}


// c : center of repulsion zone
boolean isBoidInRepulsionZone(PVector c, PVector boid) {
  float a = pow(boid.x - c.x, 2);
  float b = pow(boid.y - c.y, 2);
  return a + b < pow(repulsion, 2);
}