class Star{
    PVector pos;
    float size;
    float brightness;
    color col;
    int numPlanets;
    ArrayList<Planet> planets;
    boolean solarSystem;

    //CONSTRUCTOR:
    Star(float x, float y, float size, float brightness, color col, int n){
        this.pos = new PVector(x,y);
        this.size = size;
        this.brightness = brightness;
        this.col = col;
        this.numPlanets = n;
        this.planets = new ArrayList<Planet>();
        this.solarSystem = false;
        
    }

    void drawStar(){ //Drawing the star
        stroke(this.col);
        strokeWeight(this.size);
        circle(this.pos.x, this.pos.y, this.size);
        
    } 
    void solarSystem(){
        if(solarSystem){
            //drawing star in the middle
            stroke(this.col);
            fill(this.col);
            circle(500,400,this.size*50);

            a=initAngle[m];
            c=orbitDirection[m++];  
            b=initAngle[m];
            d=orbitDirection[m++];

            int z = 2;
            for(int i = 0; i < this.numPlanets; i++){
                float x = 500+z*(this.size*50)*cos((t*c*(pow(2,2))*2.*PI/360)+a);
                float y = 400+z*(this.size*50)*sin((t*c*(pow(2,2))*2.*PI/360)+a);

                planets(x,y ,(this.size*50)/12);
                z += random(2,3);
            }
        }
         
    }

    void planets(float x, float y, float size){
        stroke(0,255,0);
        fill(0,255,0);
        circle(x, y,size);
    }
 

    void starInfo(){ //Lots of if statments for this :(
        if(showSolarSystem){
            numPlanets = this.numPlanets;

            if(this.col == color(255,100,100)){
                startLine = 2;
                endLine = 8;

            }

            if(this.col == color(255,255,255) && this.size < 1.5){
                startLine = 8;
                endLine = 14;
            }
        }
    
        else{ //If showing galaxy, it will print 'no star selected'
            startLine = 0;
            endLine = 1;
        }

       
    }
}

//void solarSystem(float x, float y, float r, int n){
    //     if(solarSystem){
    //         if(n == 1){
    //             stroke(this.col);
    //             fill(this.col);
    //         }
    //         else if(n==2){
    //             stroke(255,0,0);
    //             fill(255,0,0);
    //         }
    //         else if(n == 3){
    //             strokeWeight(r/12);
    //             stroke(0,255,0);
    //             fill(0,255,0);
    //         }
    //         else{
    //             stroke(0,0,255);
    //             fill(0,0,255);
    //         }
    //         circle(x,y, r);
    //         if(n == 1){
    //             m = 0;
    //         }

    //         a=initAngle[m];
    //         c=orbitDirection[m++];  
    //         b=initAngle[m];
    //         d=orbitDirection[m++];

    //         if( r > 1){
    //             int z = 2;
    //             for(int i = 0; i < this.systemBody; i++){
    //                 solarSystem(x+z*r*cos((t*c*(pow(2,n-1))*2.*PI/360)+a),y+z*r*sin((t*c*(pow(2,n-1))*2.*PI/360)+a),r/12,n+1);
    //                 z += random(2,3);
    //             }
    //         }
    //     } 
    // }


