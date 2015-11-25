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
  
  // display boids
  for (int i=0; i < boids.size(); ++i) {
    // perception
    fill(perceptionC);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, perception, perception);
    
    // repulsion
    fill(repulsionC);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, repulsion, repulsion);
    
    // boid
    fill(boidC);
    ellipse(boids.get(i).pos.x, boids.get(i).pos.y, boidSize, boidSize);
    line(boids.get(i).pos.x, boids.get(i).pos.y, boids.get(i).dir.x, boids.get(i).dir.y);
  }
  
  
  // update boids position
  for (int i=0; i < boids.size(); ++i) {
    PVector vect = PVector.mult(PVector.sub(boids.get(i).dir, boids.get(i).pos), speed);
    boids.get(i).pos = PVector.add(boids.get(i).pos, vect);

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