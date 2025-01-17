//Librairies:
import g4p_controls.*;

//Global Variables:
ArrayList<Star> stars = new ArrayList<Star>();
int numStars = 10000;
color[] starColor = {color(255), color(255, 200, 150), color(255, 100, 100), color(100, 200, 255), color(255, 255, 100), color(255, 150, 50)};

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


//Planets/solar system thingys:
float a,b,c,d;
float t=0;
float initAngle[] =new float[1000];
float orbitDirection[] =new float[1000];
int m;

SecondApplet sa; 
String args[] = {"Star info"};

boolean showSolarSystem = false;
boolean animation = true;

//Text info
String[] starData;
int startLine = 0; 
int endLine = 1;
int numPlanets = 0;


void setup(){       
    colorMode(RGB, 255);    
    size(1000,800);
    background(0);
    createGUI();

    spiralGalaxy(); //Type of galaxy being drawn
    setupPlanets();

    starData = loadStrings("Star Info.txt");

    

    
    sa = new SecondApplet();
    PApplet.runSketch(args, sa);

    pauseButton.setVisible(false);
    playButton.setVisible(false);
}

void draw(){
  background(0);
  translate(width/2, height/2);  
  scale(scale);
  translate(-xPan, -yPan);
  

  

  for(Star s : stars){
    if(!showSolarSystem){
      s.drawStar();
      s.solarSystem = false;
    }

    else{
      s.solarSystem();
      if(animation){
        t = (t+0.00005) % 720; //keeping t in the range of 720 degrees
      }
    } 
    s.starInfo();

  }   
}


void mousePressed(){
  //Undoing the translations/scale on the coorodiantes of the mouse
  float x = ((mouseX - width/2) / scale) + xPan;
  float y = ((mouseY - height/2) / scale) + yPan;
  

  for(Star s : stars){
    //Cheking if mouse is within a star
    if(x >= s.pos.x - s.size && x <= s.pos.x + s.size && y >= s.pos.y-s.size && y <= s.pos.y + s.size && !showSolarSystem){
      resetView();

      showSolarSystem = true;
      s.solarSystem = true;

      pauseButton.setVisible(true);
      playButton.setVisible(true);
    }
    
  }
}

void resetView(){
  scale = 1;
  xPan = 500;
  yPan = 400;
}

public class SecondApplet extends PApplet{

  public void settings() {
    size(300, 300);
  }
  
  public void setup(){
    surface.setTitle("Solar system info");
    surface.setLocation(0,475);
    
  }
  public void draw() {
    background(255);
    fill(0);
    int x = 10;
    int y = 25;
    
    

    for(int i = startLine; i < endLine; i++){
      int fontSize = 15;
      textSize(fontSize);
      
      while(textWidth(starData[i]) > 290){
        fontSize-=0.25;
        textSize(fontSize);
      }
      text(starData[i],x,y);
      y += 18;
    }
    if(showSolarSystem){
      textSize(15);
      text("This star has "+ numPlanets + " planets orbiting it",x,y);
    }
  }
}

