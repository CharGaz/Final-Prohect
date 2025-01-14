//Librairies:
import g4p_controls.*;

//Global Variables:
ArrayList<Star> stars = new ArrayList<Star>();
int numStars = 10000;
color[] starColor = {color(255), color(255, 200, 150), color(255, 100, 100), color(100, 200, 255), color(255, 255, 100), color(255, 150, 50)};

int numPlanets;
//Spiral Galaxy:
float rad = 450; //Radius of the solar system/ max radius
float elip = 0.8; //Making the solar system into a elips, not just a circle
float twist = 8/rad; //"Twist" of the solar system

float[] angle = new float[numStars];
float[] radius = new float[numStars]; //radius of a star


//Panning and Zooming:
float scale = 1;
float scalefactor = 0.1;
float xPan = 500;
float yPan = 400;
int panfactor = 12;

boolean showSolarSystem = false;
void setup(){           
    size(1000,800);
    background(0);
    createGUI();

    spiralGalaxy(); //Type of galaxy being drawn

    String args[] = {"Star info"};
    SecondApplet sa = new SecondApplet();
    PApplet.runSketch(args, sa);
    
}

void draw(){
  background(0);
  
  translate(width/2, height/2);  
  scale(scale);
  translate(-xPan, -yPan);
  

  

  for(Star s : stars){
    if(!showSolarSystem){
      s.drawStar();
    }
    s.solarSystem();
  }  
   
  
}
void mousePressed(){
  //Undoing the translations/scale on the coorodiantes of the mouse
  float x = ((mouseX - width/2) / scale) + xPan;
  float y = ((mouseY - height/2) / scale) + yPan;
  

  for(Star s : stars){
    //Cheking if mouse is within a star
    if(x >= s.pos.x - s.size && x <= s.pos.x + s.size && y >= s.pos.y-s.size && y <= s.pos.y + s.size ){
      showSolarSystem = true;
      s.solarSystem = true;
      resetView();
    }
    
  }
}

void resetView(){
  scale = 1;
  xPan = 500;
  yPan = 400;
}

public class SecondApplet extends PApplet {

  public void settings() {
    size(200, 300);
  }
  public void draw() {
    background(255);
    fill(0);
    text("This star has "+ numPlanets + " planets",50,100);
  }
}

