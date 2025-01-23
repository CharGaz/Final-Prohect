class Star{
    PVector pos; 
    float size;
    color col;
    int numPlanets;
    boolean solarSystem;
    ArrayList<Planet> planets;


    //CONSTRUCTOR:
    Star(float x, float y, float size, color col, int planets){
        this.pos = new PVector(x,y);
        this.size = size;
        this.col = col;
        this.numPlanets = planets;
        this.solarSystem = false;
        this.planets = new ArrayList<Planet>();
        
    }

    void drawStar(){ //Drawing the star
        stroke(this.col);
        strokeWeight(this.size);
        circle(this.pos.x, this.pos.y, this.size);
  
    } 

    

    void solarSystem(float x, float y, float r){
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
            
            

            float z = 1.5; //Distance between planets and the first planet vs the stars
            
            for(int i = 0; i < this.numPlanets; i++){
                //Needed for the orbit angles and direction
                a=initAngle[m];
                c=orbitDirection[m++];  

                

                //adding planets to class, and drawing each planet
                if(this.planets.size() < this.numPlanets){ //only adding a certian number of planets
                    //Setting up how many moons each planet will have(It will be random)
                    int planetMoons = int(random(2,5));

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

    void starInfo(){ //Lots of if statments for this :(
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




