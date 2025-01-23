void setupPlanets(){
    for(int i=0; i<1000; i++){
        initAngle[i]=TWO_PI*random(1); //Angle for orbit
        orbitDirection[i]=(random(1)<0.5) ?1:-1; //50/50 chance for clockwise or counterclockwise orbit
    } 
}