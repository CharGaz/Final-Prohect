void spiralGalaxy(){
    float cx = width/2; //center x
    float cy = height/2; //center y

    for(int i = 0; i < numStars; i++){

        angle[i] = random(TWO_PI);
        radius[i] = random(1, rad);
        float r = radius[i];
        float a = angle[i];
        angle[i] = a;

        float x = r*cos(a);
        float y = r*elip*sin(a);
        float b = r*twist;
        float s = sin(b);
        float c = cos(b);
        
        float finalX = cx + s * x + c * y; //Plotting the x to be on a spiral
        float finalY = cy + c * x - s * y; //Plotting the y to be on a spiral

       
        // for(Star otherStar : stars){
        //     float distance = dist(finalX, finalY, otherStar.pos.x, otherStar.pos.y);
        //     while(-1 < distance && distance > 1){

        //     }
        // }



        float size = random(1,3); //size of the star
        float brightness = random(50,255); //brightness of the star
        color starCol = starColor[int(random(starColor.length))]; // colour of the star
            
        stars.add(new Star(finalX,finalY, size, brightness, starCol)); //Putting info into star class  
    }
}