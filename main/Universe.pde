class Universe{
  ArrayList<Organism> organisms;
  int maxOrganismCount;
  float avgScore;
  int genNum;
  
  Universe(){
    organisms = new ArrayList<Organism>();
    genNum = 0;
  }
  
  void run(){
    if(lifeSessionOver()){
      genNum += 1;
      println("--- Generation ", genNum, " ---");
      calcScores();
      produceNextGen();
      
    }
    else{
      for(Organism o: organisms){
        o.run();
      }
      for(Organism o: organisms){
        o.updateSeperations();
      }
      for(Organism o: organisms){
        o.update();
      }
    }
  }
  
  void calcScores(){
    for(Organism o: organisms){
        o.calcScore();
    }
    
  }
  
  void produceNextGen(){
    Organism first = null;
    Organism second = null;
    float firstScore = -100000;
    float secondScore = -100000;
    ArrayList<Organism> nextGen = new ArrayList<Organism>();
    avgScore = 0;
    for(Organism o: organisms){
      avgScore += o.getScore();
      if(o.getScore() > firstScore){
        first = o;
        firstScore = o.getScore();
      }
      else if(o.getScore() > secondScore){
        second = o;
        secondScore = o.getScore();
      }
    }
    avgScore = avgScore/organisms.size();
    println("Avg Score: ", avgScore);
    println("Best Score: ", firstScore);
    for(Organism o: organisms){
      Organism child = first.reproduceWith(o);
      nextGen.add(child);
    }
    
    
    //for(int i = 0; i < maxOrganismCount-1; i++){
      //nextGen.add(child.produceRandomVariant());
    //}
    
    organisms = nextGen;
  }
  
  boolean lifeSessionOver(){
    if(frameCount % 1800 == 0){
      return true;
    }
    return false;
  }
  
  int getRandomValueFromZeroToX(int x){
    return int(random(x));
  }
 
  void addNRandomlyPlacedOrganisms(int n){
    maxOrganismCount = n;
    for (int i = 0; i < n; i++) {
      addOrganism(new Organism(random(width),height/2, true)); //MAKE SEP CONSTRUC
    }
  }
  
  void addOrganism(Organism o){
    organisms.add(o);
  }

}
