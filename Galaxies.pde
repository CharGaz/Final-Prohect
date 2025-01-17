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


        
        float brightness = random(50,255); //brightness of the star
        color starCol = starColor[int(random(starColor.length))]; // colour of the star

        float size = random(1,2); //size of the star
        if(starCol == color(255, 100, 100)){
            size = random(1.75,2); //If star is red, than it is a red gaint
        }

        int bodies = int(random(2,5));
            
        stars.add(new Star(finalX,finalY, size, brightness, starCol, bodies)); //Putting info into star class  
    }
}