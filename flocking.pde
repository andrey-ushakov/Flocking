
// TODO Add border collision
// TODO Max direction length : 

public class Boid {
  public PVector pos;  // current position
  public PVector dir;  // current direction
}


ArrayList<Boid> boids = new ArrayList<Boid>();
int boidSize         = 10;
final int W          = 800;
final int H          = 600;
final float speed    = 0.01;
final int perception = 80;  // radius of perception
final int repulsion  = 30;  // radius of repulsion
color boidC          = color(255, 255, 255);
color repulsionC     = color(238, 0, 0);
color perceptionC    = color(205, 205, 0);
int maxDirLength     = 100;


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
    PVector accel = boids.get(i).pos;//new PVector(0, 0);
    
    for (int j=0; j < boids.size(); ++j) {
      if(i != j) {
        // calculate acceleration vector
        PVector vectSub = new PVector(repulsion/2, repulsion/2);
        //PVector vect = PVector.sub(boids.get(j).pos, vectSub);  // vector between 2 boids
        PVector vect = new PVector(boids.get(j).pos.x, boids.get(j).pos.y);
        
        //stroke(255,0,0); strokeWeight(1);
        //line(boids.get(i).pos.x, boids.get(i).pos.y, vect.x, vect.y);
        
        
        if( isBoidInRepulsionZone(boids.get(i).pos, boids.get(j).pos) ) {
          // TODO Add force
          // TODO Vector - 2 * repulsion
          println("repulsion");
          PVector diff = PVector.sub(vect, boids.get(i).pos);
          accel = PVector.sub(accel, diff);  // repulsion
        } else if( isBoidInPerceptionZone(boids.get(i).pos, boids.get(j).pos) ) {
          // TODO Add force
          println("attraction");
          PVector diff = PVector.sub(vect, boids.get(i).pos);
          accel = PVector.add(accel, diff);  // attraction
        } else {
          // do nothing : out of perception zone
        }
        
        // update i-boid direction
        //boids.get(i).dir = PVector.add(boids.get(i).dir, accel);
        
        PVector diff = PVector.sub(accel, boids.get(i).pos);
        PVector tempDir  = PVector.add(boids.get(i).dir, diff);
        //stroke(0, 255, 0); strokeWeight(1);
        //line(boids.get(i).pos.x, boids.get(i).pos.y, tempDir.x, tempDir.y);
       
        boids.get(i).dir = tempDir;
      }
    }
    //break;
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
    strokeWeight(2);
    line(boids.get(i).pos.x, boids.get(i).pos.y, boids.get(i).dir.x, boids.get(i).dir.y);
  }
}


void initBoids(int boidsNum) {
  
  /*Boid boid1 = new Boid();
  boid1.pos = new PVector(300, 300);
  PVector temp = new PVector(500, 500);        // random point
    PVector subV = PVector.sub(temp, boid1.pos).normalize();  // normilized vector between 2 points
    PVector resMult = PVector.mult(subV, 100);                // increase normilized vector length
    boid1.dir = PVector.add(boid1.pos, resMult);               // move vector
    
    Boid boid2 = new Boid();
  boid2.pos = new PVector(240, 300);
  PVector temp2 = new PVector(200, 200);        // random point
    PVector subV2 = PVector.sub(temp2, boid2.pos).normalize();  // normilized vector between 2 points
    PVector resMult2 = PVector.mult(subV2, 100);                // increase normilized vector length
    boid2.dir = PVector.add(boid2.pos, resMult2);               // move vector
    
    boids.add(boid1);
    boids.add(boid2);*/
  
  
  for (int i = 0; i < boidsNum; i++) {
    Boid boid = new Boid();
    boid.pos = new PVector(random(W), random(H));
    
    // generate random direction
    PVector temp = new PVector(random(W), random(H));        // random point
    PVector subV = PVector.sub(temp, boid.pos).normalize();  // normilized vector between 2 points
    PVector resMult = PVector.mult(subV, maxDirLength);                // increase normilized vector length
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