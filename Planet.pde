class Planet{
    PVector planetPos;
    float size;
    int numMoons;
    float starSize;
    float rad;
    int life;
    float[] moonAngles;
    float[] moonDirections;
    color col;



    //CONSTRUCTOR:
    Planet(float x, float y, float size, float starSize, float rad, int moons){
        this.planetPos = new PVector(x,y);
        this.size = size;
        this.starSize = starSize;
        this.rad = rad;
        this.numMoons = moons;
        this.life = (random(1) < 0.8)?-1:1; //20% chance of life on a planet
        this.moonAngles = new float[moons];
        this.moonDirections = new float[moons];
        this.col = planetColor[int(random(planetColor.length))]; //Random colour for the planets

        for (int i = 0; i < moons; i++) {
            this.moonAngles[i] = random(TWO_PI);       // Random initial angle
            this.moonDirections[i] = (random(1) < 0.5) ? 1 : -1; // Random orbit direction
        }

        
    }

    void drawPlanet(){
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

    void drawMoons(){
        float z = 1.25; //space between star and first moon
        float r = this.size;

        for(int i = 0; i < this.numMoons; i++){ //drawing the number of moon each star has


            //needed for calcuation
            a = this.moonAngles[i];
            c = this.moonDirections[i];

            //getting the x and y values of the elipticle orbits
            float moonX = this.planetPos.x + z * r * cos((( t * 1.5) * c* (pow(2,3)) * TWO_PI/360) +a);
            float moonY = this.planetPos.y + z * r * sin((( t * 1.5 ) * c * (pow(2,3)) * TWO_PI/360) +a);
 
            stroke(128);
            fill(128);
            strokeWeight(r/6);
            circle(moonX,moonY, r/6); //Actually drawing the moons to the screen

            z+= r/5;
            

        }
        
    }

    boolean planetClicked(float mouseX, float mouseY, float planetX, float planetY, float rad){
        //Undoing any transformations
        float x = ((mouseX - width/2) / scale) + xPan;
        float y = ((mouseY - height/2) / scale) + yPan;

        //Checking if clicked inbetween planet
        return dist(x, y, planetX, planetY) <= rad/2;
    }

    void getInfo(){
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