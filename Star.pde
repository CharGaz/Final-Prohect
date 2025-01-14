class Star{
    PVector pos;
    float size;
    float brightness;
    color col;
    boolean solarSystem;

    //CONSTRUCTOR:
    Star(float x, float y, float size, float brightness, color col){
        this.pos = new PVector(x,y);
        this.size = size;
        this.brightness = brightness;
        this.col = col;
        this.solarSystem = false;
        
    }

    void drawStar(){ //Drawing the star
  
        stroke(this.col);
        strokeWeight(this.size);
        circle(this.pos.x, this.pos.y, this.size);
        
    } 

    void solarSystem(){
        
        if(solarSystem){
            //Drawing the star
            stroke(this.col);
            fill(this.col);
            circle(500,400, this.size*100);
            println(this.size);
        }
        
    }
}




