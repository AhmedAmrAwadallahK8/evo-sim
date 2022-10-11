Universe sim;

/*
Combine Mean of Top1 and Top2 performer for Next Gen
Randomly make 6 versions of the combo
Repeat
Observe
Reward Displacement
Punish Seperation
Allow Shrinking
Set max extension and max shrinkage length
Change Perturb to be lower
Equally Space out Organisms
When parents m8 dont use mean score, interchange values
*/

void setup(){
  size(1000,800);
  sim = new Universe();
  sim.addNRandomlyPlacedOrganisms(50);
}
 
void draw(){
  fill(200, 140); //140
  rect(-2,-2,width+2,height+2);
  sim.run();
}
 
void mouseDragged(){
  sim.addOrganism(new Organism(mouseX, mouseY, true));
}
 
void mousePressed(){
  sim.addOrganism(new Organism(mouseX, mouseY, true));
}
