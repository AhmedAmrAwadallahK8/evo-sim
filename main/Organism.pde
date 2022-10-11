class Organism{
  ArrayList<OrganismComponent> components;
  OrganismComponent tail;
  OrganismComponent head;
  float score;
  float distTraveled;
  float food_consumed;
  float displacement;
  float seperation;
  color c;
  
  
  Organism(float x, float y, boolean notChild){
    components = new ArrayList<OrganismComponent>();
    c = color(random(255), random(255), random(255));
    OrganismComponent start_comp = new OrganismComponent(x,y,this,c);
    head = start_comp;
    tail = start_comp;
    distTraveled = 0;
    displacement = 0;
    seperation = 0;
    
    components.add(start_comp);
    extend();
    if(notChild){
      int extensionAmount = round(random(18));
      //extensionAmount = 10; //TEMP
      for(int i = 0; i < extensionAmount; i++){
        extend();
      }
    }
  }
  
  void run() {
    for(OrganismComponent oc: components){
      oc.run();
    }
  }
  
  Organism produceRandomVariant(){
    Organism copy = copyOrganism();
    for(int i = 0; i < copy.components.size(); i++){
      copy.components.get(i).perturbTraits();
    }
    
    int chanceToExtend = round(random(150));
    if(components.size() < 20){
      if(chanceToExtend <= 2){
        copy.extend();
        return copy;
      }
    }
    
    int chanceToShrink = round(random(200));
    if(components.size() > 2){
      if(chanceToShrink <=2){
        copy.shrink();
        return copy;
        
      }
      
    }
   
    
    return copy;
  }
  
  Organism copyOrganism(){
    Organism copy = new Organism(random(width), height/2, false); //MAKE SEP CONSTRUC
    copy.extendNTimes(components.size()-2);
    for(int i = 0; i < copy.components.size(); i++){
      copy.components.get(i).copyTraits(components.get(i));
    }
    return copy;
  }
  
  Organism reproduceWith(Organism partner){
    Organism child = new Organism(random(width), height/2, false); //MAKE SEP CONSTRUC
    int lengthChance = round(random(1));
    if(lengthChance == 0){
      int meanSize = (components.size() + partner.components.size())/2;
      int meanSizeChance = round(random(1));
      if(meanSizeChance == 0){
        child.extendNTimes(meanSize-2);
      }
      else{
        child.extendNTimes(meanSize-2);
      }
      
    }
    else{
      //Extend size of child to one of the parents size
      if(components.size() < partner.components.size()){
        int randChance = round(random(1));
        if(randChance == 1){
          child.extendNTimes(partner.components.size()-2);
        }
        else{
          child.extendNTimes(components.size()-2);
        }
      }
      else{
        child.extendNTimes(components.size()-2);
      }
    }
    
    
    
    for(int i = 0; i < child.components.size(); i++){
      if(i < child.components.size()){
        if(i >= components.size()){
          child.components.get(i).combineTraits(null, partner.components.get(i));
        }
        else if(i >= partner.components.size()){
          child.components.get(i).combineTraits(components.get(i), null);
        }
        else{
          child.components.get(i).combineTraits(components.get(i), partner.components.get(i));
        }
      }
      
    }
    int chanceToExtend = round(random(100));
    //chanceToExtend = 0; //TEMP
    if(components.size() < 20){
      if(chanceToExtend <= 2){
        child.extend();
        return child;
      }
    }
    
    int chanceToShrink = round(random(100));
    //chanceToShrink = 0; //TEMP
    if(components.size() > 3){
      if(chanceToShrink <=2){
        child.shrink();
        return child;
        
      }
      
    }
    return child;
    
  }
  
  float getScore(){
    return score;
    
  }
  
  void calcScore(){
    calcSeperation();
    calcDisplacement();
    score = displacement - seperation*50; // displacement - seperation*50
  }
  
  void updateSeperations(){
    for(OrganismComponent oc1: components){
      for(OrganismComponent oc2: components){
        oc1.updateSeperation(oc2);
      }
    }
  }
  
  void calcDisplacement(){
    float tempDisplacement = 0;
    for(OrganismComponent oc: components){
      tempDisplacement += oc.getDisplacement();
    }
    tempDisplacement = tempDisplacement/components.size();
    displacement = tempDisplacement;
    
  }
  
  
  void calcSeperation(){
    float tempSeperation = 0;
    for(OrganismComponent oc: components){
      tempSeperation += oc.getTimeAvgSep();
    }
    tempSeperation = tempSeperation/components.size();
    seperation = tempSeperation;
  }
  
  void calcDist(){
    float tempDistTrav = 0;
    for(OrganismComponent oc: components){
      tempDistTrav += oc.getDistTraveled();
    }
    tempDistTrav = tempDistTrav/components.size();
    distTraveled = tempDistTrav;
  }
  
  void processTension() {
    for(OrganismComponent oc: components){
      oc.calcTensionForce();
    }
  }  
   
  void update(){
    for(OrganismComponent oc: components){
      oc.update();
    }
  }
  
  void extend(){
    OrganismComponent new_comp = new OrganismComponent(tail);
    tail = new_comp;
    components.add(new_comp);
  }
  
  void shrink(){
    OrganismComponent componentToRemove = tail;
    tail = tail.parent;
    components.remove(componentToRemove);
  }
  
  void extendNTimes(int n){
    for(int i = 0; i < n; i++){
      extend();
    }
  }
  
  int getComponentCount(){
    return components.size();
  }
  
  
}
