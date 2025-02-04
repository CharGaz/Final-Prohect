/* autogenerated by Processing revision 1293 on 2025-01-23 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import g4p_controls.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Processing extends PApplet {

//Librairies:


//Global Variables:
ArrayList<Star> stars = new ArrayList<Star>(); //Array list of stars
int numStars = 10000; //Number of stars
int[] starColor = {color(255), color(255, 200, 150), color(255, 100, 100), color(100, 200, 255), color(255, 255, 100), color(255, 150, 50)}; //Possible star colours
int[] planetColor = {color(0,255,0), color(156,46,53), color(237,219,173), color(0,0,255)}; //Possilbe planet colours
//Spiral Galaxy:
float rad = 450; //Radius of the solar system/ max radius
float elip = 0.8f; //Making the solar system into a elips, not just a circle
float twist = 8/rad; //"Twist" of the solar system

float[] angle = new float[numStars];
float[] radius = new float[numStars]; //radius of a star


//Panning and Zooming:
float scale = 1;
float scalefactor = 0.1f;
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


public void setup(){  
    surface.setTitle("STELLAR EXPLORER");  //Name of the window
    surface.setLocation(300,0); //Setting the location of the main window    
    /* size commented out by preprocessor */;
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

public void draw(){
  
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
        t += 0.000015f; //updating t
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


public void mousePressed(){ //Runs every time the mouse is clicked
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

public void resetView(){
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
          fontSize-=0.25f;
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

public void spiralGalaxy(){
    float cx = width/2; //center x
    float cy = height/2; //center y
    float minDistance = 3.25f; //Minimum distance between stars

    for(int i = 0; i < numStars; i++){ //Drawing a star for the number of stars

        //Angles and radius for the spiral
        angle[i] = random(TWO_PI);
        radius[i] = random(1, rad);
        float r = radius[i];
        float a = angle[i];
        angle[i] = a;


        //getting points to allow a spiral shape to be formed
        float x = r*cos(a);
        float y = r*elip*sin(a);
        float b = r*twist;
        float s = sin(b);
        float c = cos(b);
         
        float finalX = cx + s * x + c * y; //Plotting the x to be on a spiral
        float finalY = cy + c * x - s * y; //Plotting the y to be on a spiral

        boolean overlaps = false;

        for (Star existingStar : stars){ //Going through all the already drawn stars to see if any are overlapping
            float distance = dist(finalX, finalY, existingStar.pos.x, existingStar.pos.y); //Checking distance between the stars
            float blackHoleDistance = dist(finalX, finalY, width/2, height/2 ); //Checking distance between the blackhole

            if (distance < minDistance || blackHoleDistance < 20) { //If any distance is overlapping then nothing is drawn
                overlaps = true;
                break; // Exit the loop if a star is too close
            }
        }

        // If the star doesn't overlap, add it
        if (!overlaps){
            int starCol = starColor[PApplet.parseInt(random(starColor.length))]; // color of the star

            float size = random(1, 1.75f); // size of the star

            if (starCol == color(255, 100, 100)) {
                size = random(1.5f,1.75f); // If the star is red, it is a red giant
            }

            int planets = PApplet.parseInt(random(2,8));

            stars.add(new Star(finalX, finalY, size, starCol, planets)); // Adding the star
        }
    }
}

public void drawBlackHole(){
    //drawing the blackhole at the center of the galaxy
    fill(0); 
    noStroke();
    circle(width/2, height/2, 20);  


    if(blackHole){ //Drawing the good black hole
        float angle = 0; //tracks wich angle the line is being drawn on, first line starts at 0

        pushMatrix(); //The push and popMatrix ensure nothing else is affected by the tanslate
        translate(width/2, height/2); //Putting the blackhole at the center of the screen

        for(int i = 0; i < numLines; i++){ //Draws lines for the size of numLines(300 lines)
            
            //x and y variables for the lines. They are made in the for loop because each line needs a new one
            float x1;
            float y1;
            float x2;
            float y2;

            //Creating a random length of the lines using perlin noise
            //Noise essentially makes random more "smooth"
            float randLength = map(noise(pNoiseX+i*0.1f, pNoiseY), 0, 1, 10, blackHoleRadius * 4); 

            strokeWeight(random(6,8)); 
            //Updating the x and y values for the lines to go around the circle
            x1 = blackHoleRadius * cos(angle);
            y1 = blackHoleRadius * sin(angle);
            x2 = x1 + randLength * cos(angle+PI/2);
            y2 = y1 + randLength * sin(angle+PI/2);

            //Colour of the lines
            stroke(128, 20);
            line(x1, y1, x2, y2);

            angle+=TWO_PI/numLines; //Increases the angle so the lines are drawn all across the circle, and do not overlap
        }
        popMatrix();

        //needed for the perlin noise, allows for animation aswell :)
        pNoiseX+=.05f;
        pNoiseY+=.01f;

        //Lines for the info about the blackhole
        sStartLine = 41;
        sEndLine = 45;

        surface.setTitle("Black Hole"); 

    }
}

class Planet{
    PVector planetPos;
    float size;
    int numMoons;
    float starSize;
    float rad;
    int life;
    float[] moonAngles;
    float[] moonDirections;
    int col;



    //CONSTRUCTOR:
    Planet(float x, float y, float size, float starSize, float rad, int moons){
        this.planetPos = new PVector(x,y);
        this.size = size;
        this.starSize = starSize;
        this.rad = rad;
        this.numMoons = moons;
        this.life = (random(1) < 0.8f)?-1:1; //20% chance of life on a planet
        this.moonAngles = new float[moons];
        this.moonDirections = new float[moons];
        this.col = planetColor[PApplet.parseInt(random(planetColor.length))]; //Random colour for the planets

        for (int i = 0; i < moons; i++) {
            this.moonAngles[i] = random(TWO_PI);       // Random initial angle
            this.moonDirections[i] = (random(1) < 0.5f) ? 1 : -1; // Random orbit direction
        }

        
    }

    public void drawPlanet(){
        stroke(this.col);
        fill(this.col);
        circle(this.planetPos.x, this.planetPos.y, this.size); //Drawing Planets
        


        //Checking if planet was clicked, also checks if planets are not moving, and checking if a planet is already selected:
        if(mousePressed && planetClicked(mouseX, mouseY, this.planetPos.x, this.planetPos.y, this.size) && !animation && !planetText){
            getInfo(); //Getting info for planets
            unSelect.setVisible(true);
        }

        if(planetText){
            surface.setTitle("Planet Selected"); //Changing title of the screen when a planet has been selected
        }

        //Updating the planets movement
        this.planetPos.x = 500 + this.rad * this.starSize * cos( (t * c * (pow(2,2)) *TWO_PI/360) +a);
        this.planetPos.y = 400 + this.rad * this.starSize * sin( (t * c* (pow(2,2)) *TWO_PI/360) +a);

        drawMoons(); 

    }

    public void drawMoons(){
        float z = 1.25f; //space between star and first moon
        float r = this.size;

        for(int i = 0; i < this.numMoons; i++){ //drawing the number of moon each star has


            //needed for calcuation
            a = this.moonAngles[i];
            c = this.moonDirections[i];

            //getting the x and y values of the elipticle orbits
            float moonX = this.planetPos.x + z * r * cos((( t * 1.5f) * c* (pow(2,3)) * TWO_PI/360) +a);
            float moonY = this.planetPos.y + z * r * sin((( t * 1.5f ) * c * (pow(2,3)) * TWO_PI/360) +a);
 
            stroke(128);
            fill(128);
            strokeWeight(r/6);
            circle(moonX,moonY, r/6); //Actually drawing the moons to the screen

            z+= r/5;
            

        }
        
    }

    public boolean planetClicked(float mouseX, float mouseY, float planetX, float planetY, float rad){
        //Undoing any transformations
        float x = ((mouseX - width/2) / scale) + xPan;
        float y = ((mouseY - height/2) / scale) + yPan;

        //Checking if clicked inbetween planet
        return dist(x, y, planetX, planetY) <= rad/2;
    }

    public void getInfo(){
        if(this.life == 1){ //If it can support life
            pStartLine = 0;
            pEndLine = 6;
        }
        else{ //if it cannot support life
            pStartLine = 7;
            pEndLine = 9;

        }
        moonsOrbtiting = "this planet has " + this.numMoons + " moons orbiting it";
        planetText = true;
    }
}
public void setupPlanets(){
    for(int i=0; i<1000; i++){
        initAngle[i]=TWO_PI*random(1); //Angle for orbit
        orbitDirection[i]=(random(1)<0.5f) ?1:-1; //50/50 chance for clockwise or counterclockwise orbit
    } 
}
class Star{
    PVector pos; 
    float size;
    int col;
    int numPlanets;
    boolean solarSystem;
    ArrayList<Planet> planets;


    //CONSTRUCTOR:
    Star(float x, float y, float size, int col, int planets){
        this.pos = new PVector(x,y);
        this.size = size;
        this.col = col;
        this.numPlanets = planets;
        this.solarSystem = false;
        this.planets = new ArrayList<Planet>();
        
    }

    public void drawStar(){ //Drawing the star
        stroke(this.col);
        strokeWeight(this.size);
        circle(this.pos.x, this.pos.y, this.size);
  
    } 

    

    public void solarSystem(float x, float y, float r){
        if(solarSystem){ //Only runs when the individual solar system is being called 
            //Drawing the star in the middle of the screen
            if(!planetText){ //Stops the title of the screen glitiching 
                surface.setTitle("Solar System"); //Chaning the title of the window
            }
            

            stroke(this.col);
            fill(this.col);
            circle(x,y,r);

            //Needed for the orbit calculations
            m = 0;
            
            

            float z = 1.5f; //Distance between planets and the first planet vs the stars
            
            for(int i = 0; i < this.numPlanets; i++){
                //Needed for the orbit angles and direction
                a=initAngle[m];
                c=orbitDirection[m++];  

                

                //adding planets to class, and drawing each planet
                if(this.planets.size() < this.numPlanets){ //only adding a certian number of planets
                    //Setting up how many moons each planet will have(It will be random)
                    int planetMoons = PApplet.parseInt(random(2,5));

                    //X and Y positions for the planet to be in an ellipse orbit. 
                    float planetX = x+ z * r * cos(( t * c * (pow(2,2)) *TWO_PI/360) + a);
                    float planetY = y+ z * r * sin(( t * c * (pow(2,2)) *TWO_PI/360) + a);

                    //Adding planet to planet class
                    this.planets.add(new Planet(planetX,planetY,r/(random(8,11)), r, z, planetMoons));
                }
                this.planets.get(i).drawPlanet();  //Drawing the planets of the solar system
        
                //How far apart each planet will be from each other
                z += r/40;
            } 
            
        } 
    }

    public void starInfo(){ //Lots of if statments for this :(
        if(showSolarSystem){ //Only run when the individual solar system is being called
            planetsOrbiting = "This star has " + this.numPlanets + " planets orbiting it"; //Getting the amount of planets orbiting the star


            //end and start lines are being updated according to the star color
            if(this.col == color(255, 100, 100)){ //Red star
                sStartLine = 2;
                sEndLine = 8;
            }

            if(this.col == color(255)){ //White star
                sStartLine = 9;
                sEndLine = 14;
            }

            if(this.col == color(255, 200, 150)){ //Light orange star
                sStartLine = 17;
                sEndLine = 20;

            }

            if(this.col == color(100, 200, 255)){ //Blue star
                sStartLine = 22;
                sEndLine = 26;

            }

            if(this.col == color(255, 255, 100)){ //Yellow star
                sStartLine = 28;
                sEndLine = 32;  
            }

            if(this.col == color(255, 150, 50)){ //Dark Orange star
                sStartLine = 34;
                sEndLine = 38;
            }

        }
    }
}




/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:915552:
  appc.background(0);
} //_CODE_:window1:915552:

public void zoom_Clicked(GButton source, GEvent event) { //_CODE_:zoom:736080:
  scale += scalefactor; //Increasing scale --> zooming in

} //_CODE_:zoom:736080:

public void zoomOut_Clicked(GButton source, GEvent event) { //_CODE_:zoomOut:358050
  if( scale - scalefactor > 0.225f){ //Making sure the user does not zoom out to far.
    scale -= scalefactor; //decreasing scale --> zooming out

  }
  
} //_CODE_:zoomOut:358050:

public void panLeft_Clickled(GButton source, GEvent event) { //_CODE_:panLeft:876359:
  if( 500/scale < xPan || showSolarSystem){
    xPan -= panfactor; //Shifting left
  }
  
} //_CODE_:panLeft:876359:

public void panRight_Clicked(GButton source, GEvent event) { //_CODE_:panRight:905221:
  if( xPan < 500*scale || showSolarSystem){
    xPan += panfactor; //Shifting right
  }
} //_CODE_:panRight:905221:

public void panUp_Clicked(GButton source, GEvent event) { //_CODE_:panUp:619938:
  if( 400/scale < yPan || showSolarSystem){
    yPan -= panfactor; //Shifting up
  }
} //_CODE_:panUp:619938:

public void panDown_Clicked(GButton source, GEvent event) { //_CODE_:panDown:224973:
  if( yPan < 400*scale || showSolarSystem){
    yPan += panfactor; //Shifting down
  }
} //_CODE_:panDown:224973:

public void scaleFactor_Change(GSlider source, GEvent event) { //_CODE_:scaleFactor:398326:
  scalefactor = scaleFactor.getValueF(); //getting the scale factor 
} //_CODE_:scaleFactor:398326:

public void panFactor_Change(GSlider source, GEvent event) { //_CODE_:panFactor:327259:
  panfactor = panFactor.getValueI(); //getting the pan factor
} //_CODE_:panFactor:327259:

public void resetClicked(GButton source, GEvent event) { //_CODE_:resetButton:256849:
  resetView(); //calling for the screen to be reset
} //_CODE_:resetButton:256849:

public void galaxyResetClicked(GButton source, GEvent event) { //_CODE_:galaxyReset:601214:
  //setting all of these to false since the galaxy is now being shown
  showSolarSystem = false;
  animation = true;
  planetText = false;
  blackHole = false;
  t = 0;

  //not needed for galaxy view
  pauseButton.setVisible(false);
  playButton.setVisible(false);
  galaxyReset.setVisible(false);
  unSelect.setVisible(false);
  //reseting the screen 
  resetView();

} //_CODE_:galaxyReset:601214:

public void pauseButtonClicked(GButton source, GEvent event) { //_CODE_:pauseButton:316338:
  animation = false; //pausing the planet movement
} //_CODE_:pauseButton:316338:


public void playButtonClicked(GButton source, GEvent event) { //_CODE_:playButton:622061:
  animation = true; //playing the planet movement
} //_CODE_:playButton:622061:

public void unSelect_Clicked(GButton source, GEvent event) { //_CODE_:unSelect:251590:
  unSelect.setVisible(false);
  planetText = false; //unselecting the planet
} //_CODE_:unSelect:251590:


// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  window1 = GWindow.getWindow(this, "Sliders and Such", 0, 0, 300, 300, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  zoom = new GButton(window1, 11, 15, 80, 30);
  zoom.setText("Zoom in");
  zoom.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  zoom.addEventHandler(this, "zoom_Clicked");
  zoomOut = new GButton(window1, 12, 55, 80, 30);
  zoomOut.setText("Zoom out");
  zoomOut.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  zoomOut.addEventHandler(this, "zoomOut_Clicked");
  panLeft = new GButton(window1, 110, 55, 42, 30);
  panLeft.setTextAlign(GAlign.CENTER, GAlign.CENTER);
  panLeft.setText("←");
  panLeft.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panLeft.addEventHandler(this, "panLeft_Clickled");
  panRight = new GButton(window1, 210, 55, 44, 30);
  panRight.setText("→");
  panRight.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panRight.addEventHandler(this, "panRight_Clicked");
  panUp = new GButton(window1, 160, 15, 44, 30);
  panUp.setText("↑");
  panUp.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panUp.addEventHandler(this, "panUp_Clicked");
  panDown = new GButton(window1, 160, 55, 44, 30);
  panDown.setText("↓");
  panDown.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panDown.addEventHandler(this, "panDown_Clicked");
  scaleFactor = new GSlider(window1, 10, 120, 80, 40, 10.0f);
  scaleFactor.setShowValue(true);
  scaleFactor.setLimits(0.1f, 0.1f, 1.0f);
  scaleFactor.setNbrTicks(5);
  scaleFactor.setNumberFormat(G4P.DECIMAL, 2);
  scaleFactor.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  scaleFactor.setOpaque(false);
  scaleFactor.addEventHandler(this, "scaleFactor_Change");
  panFactor = new GSlider(window1, 128, 120, 100, 40, 10.0f);
  panFactor.setShowValue(true);
  panFactor.setLimits(10, 10, 20);
  panFactor.setNumberFormat(G4P.INTEGER, 0);
  panFactor.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panFactor.setOpaque(false);
  panFactor.addEventHandler(this, "panFactor_Change");
  resetButton = new GButton(window1, 193, 173, 80, 30);
  resetButton.setText("Reset View");
  resetButton.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  resetButton.addEventHandler(this, "resetClicked");
  galaxyReset = new GButton(window1, 10, 215, 80, 30);
  galaxyReset.setText("Back to Galaxy");
  galaxyReset.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  galaxyReset.addEventHandler(this, "galaxyResetClicked");
  pauseButton = new GButton(window1, 193, 260, 80, 30);
  pauseButton.setText("Pause");
  pauseButton.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  pauseButton.addEventHandler(this, "pauseButtonClicked");
  playButton = new GButton(window1, 10, 260, 80, 30);
  playButton.setText("Play");
  playButton.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  playButton.addEventHandler(this, "playButtonClicked");
  unSelect = new GButton(window1, 193, 215, 80, 30);
  unSelect.setText("Undo Select");
  unSelect.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  unSelect.addEventHandler(this, "unSelect_Clicked");
  label1 = new GLabel(window1, 9, 96, 80, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Scale factor");
  label1.setLocalColorScheme(GCScheme.SCHEME_15);
  label1.setOpaque(false);
  label2 = new GLabel(window1, 139, 94, 80, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Pan Factor");
  label2.setLocalColorScheme(GCScheme.SCHEME_15);
  label2.setOpaque(false);
  label3 = new GLabel(window1, 3, 165, 120, 40);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("To select desired object, simply click");
  label3.setLocalColorScheme(GCScheme.SCHEME_15);
  label3.setOpaque(false);
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GButton zoom; 
GButton zoomOut; 
GButton panLeft; 
GButton panRight; 
GButton panUp; 
GButton panDown; 
GSlider scaleFactor; 
GSlider panFactor; 
GButton resetButton; 
GButton galaxyReset; 
GButton pauseButton; 
GButton playButton; 
GButton unSelect; 
GLabel label1; 
GLabel label2; 
GLabel label3; 


  public void settings() { size(1000, 800); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
