class Planet{
    PVector planetPos;
    float size;
    int numMoons;

    // CONSTRUCTOR:
    Planet(float x, float y, float size){
        this.planetPos = new PVector(x,y);
        this.size = size;
        this.numMoons = int(random(1,6));
    }
    void drawPlanet(){
        stroke(0,255,0);
        fill(0,255,0);
        circle(this.planetPos.x, this.planetPos.y, this.size);
    }
    
}