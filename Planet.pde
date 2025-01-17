class Planet{
    float xPos;
    float yPos;
    float distance;
    float speed;
    float size;
    int numMoons;
    float angle;

    // CONSTRUCTOR:
    Planet(float distance, float speed, float size){
        this.distance = distance;
        this.speed = speed;
        this.size = size;
        this.numMoons = int(random(1,6));
        this.angle = 0;
        this.xPos = width/2 + sin(0) * distance;
        this.yPos = height/2 + cos(0) * distance;
    }
    void drawPlanet(){
        this.angle += radians(speed);
        this.xPos = width/2 + sin(this.angle) * distance;
        this.yPos = height/2 + cos(this.angle) * distance;
        
        stroke(0,255,0);
        fill(0,255,0);
        circle(this.xPos, this.yPos, this.size);
    }
    
}