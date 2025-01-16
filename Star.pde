class Star{
    PVector pos;
    float size;
    float brightness;
    color col;
    int systemBody;
    boolean solarSystem;

    //CONSTRUCTOR:
    Star(float x, float y, float size, float brightness, color col, int body){
        this.pos = new PVector(x,y);
        this.size = size;
        this.brightness = brightness;
        this.col = col;
        this.systemBody = body;
        this.solarSystem = false;
        
    }

    void drawStar(){ //Drawing the star
  
        stroke(this.col);
        strokeWeight(this.size);
        circle(this.pos.x, this.pos.y, this.size);
        
    } 

    

    void solarSystem(float x, float y, float r, int n){
        if(solarSystem){
            if(n == 1){
                stroke(this.col);
                fill(this.col);
            }
            else if(n==2){
                stroke(255,0,0);
                fill(255,0,0);
            }
            else if(n == 3){
                strokeWeight(r/12);
                stroke(0,255,0);
                fill(0,255,0);
            }
            else{
                stroke(0,0,255);
                fill(0,0,255);
            }
            circle(x,y, r);
            if(n == 1){
                m = 0;
            }

            a=initAngle[m];
            c=orbitDirection[m++];  
            b=initAngle[m];
            d=orbitDirection[m++];

            if( r > 1){
                int z = 2;
                for(int i = 0; i < this.systemBody; i++){
                    solarSystem(x+z*r*cos((t*c*(pow(2,n-1))*2.*PI/360)+a),y+z*r*sin((t*c*(pow(2,n-1))*2.*PI/360)+a),r/12,n+1);
                    z += random(2,3);
                }
            }
        } 
    }

    void starInfo(){ //Lots of if statments for this :(
        if(!showSolarSystem){ //If showing galaxy, it will print 'no star selected'
            startLine = 0;
            endLine = 1;
        }

        if(this.col == color(255, 100, 100) && this.size >= 1.5){
            startLine = 2;
            endLine = 7;
        }

       
    }
}




