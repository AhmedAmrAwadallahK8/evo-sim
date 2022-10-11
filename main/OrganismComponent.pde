class OrganismComponent{
  PVector position;
  PVector startPos;
  PVector velocity;
  PVector acceleration;
  PVector tempAccel;
  int components_above;
  int components_below;
  float pForceFreq;
  float pForceMag;
  color c;
  float distTraveled;
  float seperation;
  float sepTime;
  Organism body;
  OrganismComponent parent;
  OrganismComponent child;
  static final float r = 2.0;
  static final float maxforce = 0;
  static final float maxspeed = 20;
  static final float size = 5;
  static final float minForceFreq = 0.001;
  static final float maxForceFreq = 100;
  static final float minForceMag = 0.001;
  static final float maxForceMag = 0.1;
  static final int framesPerSimStep = 15;

  
  OrganismComponent(float x, float y, Organism o, color c){
    acceleration = new PVector(0, 0);
    tempAccel = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    startPos = new PVector(x, y);
    components_above = 0;
    components_below = 0;
    pForceFreq = random(minForceFreq,maxForceFreq);
    pForceMag = random(minForceMag, maxForceMag);
    body = o;
    this.c = c;
    distTraveled = 0;
    seperation = 0;
    sepTime = 0;
  }
  
  OrganismComponent(OrganismComponent parent){
    parent.child = this;
    parent.components_below += 1;
    
    this.parent = parent;
    this.components_below += 1;
    acceleration = new PVector(0, 0);
    tempAccel = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(parent.position.x, parent.position.y+size+1);
    startPos = new PVector(parent.position.x, parent.position.y+size+1);
    components_above = 1;
    components_below = 0;
    pForceFreq = random(minForceFreq,maxForceFreq);
    pForceMag = random(minForceMag, maxForceMag);
    body = parent.body;
    c= parent.c;
    distTraveled = 0;
    seperation = 0;
    sepTime = 0;
  }
  void copyTraits(OrganismComponent source){
    pForceFreq = source.pForceFreq;
    pForceMag = source.pForceMag;
    
  }
  
  void perturbTraits(){
    pForceFreq = pForceFreq + random(0.01, 0.1)*minForceFreq;
    pForceMag = pForceMag + random(0.01, 0.1)*minForceMag;
  }
  
  void combineTraits(OrganismComponent parent1, OrganismComponent parent2){
    if(parent1 == null){
      pForceFreq = parent2.pForceFreq;
      pForceMag = parent2.pForceMag;
    }
    else if(parent2 == null){
      pForceFreq = parent1.pForceFreq;
      pForceMag = parent1.pForceMag;
    }
    else{
      int randomSwap = round(random(0.51, 3.49));
      if(randomSwap == 1){
        pForceFreq = parent1.pForceFreq;
        pForceMag = parent2.pForceMag;
      }
      else if(randomSwap == 2){
        pForceFreq = parent2.pForceFreq;
        pForceMag = parent1.pForceMag;
      }
      else if(randomSwap == 3){
        pForceFreq = (parent1.pForceFreq + parent2.pForceFreq)/2;
        pForceMag = (parent1.pForceMag + parent2.pForceMag)/2;
      }
      //pForceFreq = (parent1.pForceFreq + parent2.pForceFreq)/2;
      //pForceMag = (parent1.pForceMag + parent2.pForceMag)/2;
    }
    
    int randChance = round(random(1));
    if(randChance == 1){
      //Add some randomness
      pForceFreq = pForceFreq + random(-0.1, 0.1)*minForceFreq;
      pForceMag = pForceMag + random(-0.1, 0.1)*minForceMag;
    }  
  }
  
  void run() {
    if(frameCount % framesPerSimStep == 0){
      calcAndApplyForces();
    }
  }
  
  void calcAndApplyForces(){
    PVector pforce = calcPersonalForce();
    applyForce(pforce);
    calcTensionForce();
    
    
    
  }
  
  float getDistTraveled(){
    return distTraveled;
  }
  
  PVector calcPersonalForce(){
    //PVector pforce = new PVector(0, pForceMag);
    PVector pforce = new PVector(pForceMag, 0);
    pforce.mult(sin(frameCount*pForceFreq));
    return pforce;

  }
  
  void calcTensionForce(){
    int componentCount = body.getComponentCount();
    
    if(parent != null){
      PVector tforce = new PVector(1, 0);
      
      PVector deltaDist = PVector.sub(position, parent.position);
      float tensionDirection = deltaDist.heading();
      tforce.rotate(tensionDirection);
      
      //tforce.mult(PVector.dot(tforce,acceleration));
      tforce.mult(acceleration.mag());
      tforce.div(componentCount);
      //parent.applyTempForce(tforce);
      parent.applyForce(tforce);
      
      //tforce.rotate(PI);
      //applyForce(tforce);
    }
    if(child != null){
      PVector tforce = new PVector(1, 0);
      
      PVector deltaDist = PVector.sub(position, child.position);
      float tensionDirection = deltaDist.heading();
      tforce.rotate(tensionDirection);
      
      //tforce.mult(PVector.dot(tforce,acceleration));
      tforce.mult(acceleration.mag());
      tforce.div(componentCount);
      //child.applyTempForce(tforce);
      child.applyForce(tforce);
      
      //tforce.rotate(PI);
      //applyForce(tforce);
    }
    

    
  }
  
  void update() {
    updateVelocity();
    updatePosition();
    resetAcceleration();
    //borders();
    render();
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void applyTempForce(PVector force) {
    tempAccel.add(force);
  }
  
  void updateVelocity(){
    velocity = velocity.add(acceleration); 
  }
  
  void updatePosition(){
    distTraveled += velocity.mag();
    position = position.add(velocity);
  }
  
  void resetAcceleration(){
    acceleration.mult(0);
    tempAccel.mult(0);
  }
  
  float getTimeAvgSep(){
    return seperation/sepTime;
  }
  
  void updateSeperation(OrganismComponent other){
    float sep = PVector.sub(this.position, other.position).mag();
    sepTime += 1;
    if(sep < 0){
      sep = sep*-1;
      seperation += sep;
    }
    else{
      
      seperation += sep;
    }
  }
  
  float getDisplacement(){
    float displace = PVector.sub(position, startPos).mag();
    if(displace < 0){
      return displace*-1;
      
    }
    else{
      return displace;
      
    }
  }
  
  void borders() {
    if (beyondWestBorder()) position.x = width;
    if (beyondNorthBorder()) position.y = height;
    if (beyondEastBorder()) position.x = 0;
    if (beyondSouthBorder()) position.y = 0;
  }
  
  boolean beyondNorthBorder(){
    if (position.y < -r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondSouthBorder(){
    if (position.y > height+r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondEastBorder(){
    if (position.x > width+r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondWestBorder(){
    if (position.x < -r){
      return true;
    }
    else{
      return false;
    }
  }
  
  void render() {
    int maxColorVal = 255;
    float mag_v = velocity.mag();
    float blue = 0;
    float red = 0;
    float green = 0;
    
    fill(c);
    stroke(red, green, blue);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0,0,size,size);
    popMatrix();
  }
}
