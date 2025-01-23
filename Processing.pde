//Librairies:
import g4p_controls.*;

//Global Variables:
ArrayList<Star> stars = new ArrayList<Star>(); //Array list of stars
int numStars = 10000; //Number of stars
color[] starColor = {color(255), color(255, 200, 150), color(255, 100, 100), color(100, 200, 255), color(255, 255, 100), color(255, 150, 50)}; //Possible star colours
color[] planetColor = {color(0,255,0), color(156,46,53), color(237,219,173), color(0,0,255)}; //Possilbe planet colours
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
float a,b,c;
float t=0; //This variable is for animation
float offset;
float adjustedT;
float initAngle[] = new float[1000];
float orbitDirection[] =new float[1000];
int m;



//second window:
SecondApplet sa; 
String args[] = {"Star info"};

//Booleans for buttons:
boolean showSolarSystem = false;
boolean animation = true;

//Text info
String[] starData;
String[] planetData;
int sStartLine = 0; //Start line for the star
int sEndLine = 1; //End line for the star
int pStartLine = 0; //Start line for the planet
int pEndLine = 0; //End line for the planet
String planetsOrbiting; //Will say the number of planets that the star has orbiting it
String moonsOrbtiting; //Will say the number of moons the planet has orbiting it

boolean planetText = false; //Boolean for if planet info should be put on screen/ if a planet is selected

//Black Hole:
boolean blackHole = false;
int blackHoleRadius = 100;
int numLines = 300;
float pNoiseX = 0;
float pNoiseY = 0;


void setup(){  
    surface.setTitle("STELLAR EXPLORER");  //Name of the window
    surface.setLocation(300,0); //Setting the location of the main window    
    size(1000,800);
    background(0);
    createGUI();

    spiralGalaxy(); //Type of galaxy being drawn
    setupPlanets(); //Setting up the orbits for planets

    //Loading text files
    starData = loadStrings("Star Info.txt"); 
    planetData = loadStrings("Planet Info.txt");


    //creating a new window for info of the stars and planets
    sa = new SecondApplet();
    PApplet.runSketch(args, sa);

    //Setting some GUI buttons invisible
    pauseButton.setVisible(false);
    playButton.setVisible(false);
    unSelect.setVisible(false);
    galaxyReset.setVisible(false);

}

void draw(){
  
  background(0);
  //Setting up panning(translate) and the zoom(sale)
  translate(width/2, height/2); //This makes the zooming into the middle of the screeing 
  scale(scale);
  translate(-xPan, -yPan);
  
  for(Star s : stars){ 
    if(!showSolarSystem && !blackHole){ //Checking to see if the galaxy should be displayed to the screen

      s.drawStar(); //Drawing all the stars
      s.solarSystem = false; //making sure that the stars are not drawing their solar system

      //Lines for text files(just says "no star selected")
      sStartLine = 0; 
      sEndLine = 1;

      surface.setTitle("STELLAR EXPLORER");  //Name of the window

    }

    else if(!blackHole){ //This is for drawing a single solar system

      s.solarSystem(500,400,s.size*50); //perameters for drawing the solar system
      

      if(animation){ //Animation variable, if user presses pause, t will not change, keeping the planets in place
        t += 0.000015; //updating t
        if(t == 256){
          //keeping t in the range of 256
          t = 0;
        }
      }

    } 
  } 
 
  if(!showSolarSystem){
    drawBlackHole(); //drawing black hole in the center of the galaxy
  }


}


void mousePressed(){ //Runs every time the mouse is clicked
  //Undoing the translations/scale on the coorodiantes of the mouse
  float x = ((mouseX - width/2) / scale) + xPan;
  float y = ((mouseY - height/2) / scale) + yPan;
  

  for(Star s : stars){ 
    //Cheking if mouse is within a star
    if(dist(x,y, s.pos.x, s.pos.y) <= s.size && !showSolarSystem && !blackHole){
      resetView(); //If a star was clicked, the translations are undone

      //This is for drawing the solar system
      showSolarSystem = true;
      s.solarSystem = true;

      //Allowing for the pause and play buttons to be visible as the animated solar system is on the screen
      pauseButton.setVisible(true);
      playButton.setVisible(true);
      galaxyReset.setVisible(true); //Button for returning back to the galaxy

      //Updating the info of the star
      s.starInfo();
    }
  }

  //Checking to see if the balck hole in the center of the galaxy was clicked
  if(dist(x,y, width/2, height/2) <= 20 && !showSolarSystem && !blackHole){
    resetView();
    blackHole = true;
    galaxyReset.setVisible(true);
    println("hello");
    
  }

}

void resetView(){
  //reseting all the scale and panning variables
  scale = 1;
  xPan = 500;
  yPan = 400;
}


public class SecondApplet extends PApplet{ //Creating the second window

  public void settings() { 
    size(300, 300); //size of the info window
  }
  
  public void setup(){
    surface.setLocation(0,375); //Setting the location of the window on the screen
    surface.setVisible(false);
  }

  public void draw() {
    background(255); //Background of the window
    fill(0); //Text colour

    //Starting x and y values of the text
    int x = 10;
    int y = 25;

    if(planetText){// checking to see if a planet was seleccted
      surface.setVisible(true); //Info screen is visible
      surface.setTitle("Planet Info"); //Setting the name of the window

      for(int i = pStartLine; i < pEndLine; i++){ //going through all the lines in the .txt document

        textSize(15); //Text size
        text(planetData[i],x,y); //printing current line of the .txt document

        y+= 18; //Moving down a line
      }
      text(moonsOrbtiting, x, y); //Putting the text to the screen. This line says how many moons are orbiting the planet
      text(planetData[11], x, y+18); //telling user to unselect planet to select another 
    }


    else if(showSolarSystem || blackHole){ //Only runs when a planet is not selected. Could be when the galaxy is being dispalyed or the solar system
      surface.setVisible(true); //Info screen is visible

      for(int i = sStartLine; i < sEndLine; i++){
        int fontSize = 15; //Size of the text
        textSize(fontSize);
        
        while(textWidth(starData[i]) > 290){ //If the text goes off the screen, it gets smaller until it fits
          fontSize-=0.25;
          textSize(fontSize);
        }

        text(starData[i],x,y); //Printing info of the star
        y += 18; //moving down a line
      }
      textSize(15);

      if(showSolarSystem){
        surface.setTitle(starData[sStartLine-1] + " Info"); //Setting the name of the window
        text(planetsOrbiting,x,y); //Outputing the amount of planets orbit the star

        textSize(12);
        text(starData[46],x,y+18); //Telling the user to pause program to select planet
      }

      else{
        surface.setTitle("Black Hole Info"); //Setting the name of the window
      }
      
    }
    
    else{
      surface.setVisible(false); //Making the screen invisible when the galaxy is being shown
    }


  }
}

