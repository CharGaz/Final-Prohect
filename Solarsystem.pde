void setupPlanets(){
    for(int i=0;i<1000;i++){
        initAngle[i]=2.*PI*random(1);
        orbitDirection[i]=(random(1)<0.5) ?1:-1;
    } 
}