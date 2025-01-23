void spiralGalaxy(){
    float cx = width/2; //center x
    float cy = height/2; //center y
    float minDistance = 3.25; //Minimum distance between stars

    for(int i = 0; i < numStars; i++){ //Drawing a star for the number of stars

        //Angles and radius for the spiral
        angle[i] = random(TWO_PI);
        radius[i] = random(1, rad);
        float r = radius[i];
        float a = angle[i];
        angle[i] = a;


        //getting points to allow a spiral shape to be formed
        float x = r*cos(a);
        float y = r*elip*sin(a);
        float b = r*twist;
        float s = sin(b);
        float c = cos(b);
         
        float finalX = cx + s * x + c * y; //Plotting the x to be on a spiral
        float finalY = cy + c * x - s * y; //Plotting the y to be on a spiral

        boolean overlaps = false;

        for (Star existingStar : stars){ //Going through all the already drawn stars to see if any are overlapping
            float distance = dist(finalX, finalY, existingStar.pos.x, existingStar.pos.y); //Checking distance between the stars
            float blackHoleDistance = dist(finalX, finalY, width/2, height/2 ); //Checking distance between the blackhole

            if (distance < minDistance || blackHoleDistance < 20) { //If any distance is overlapping then nothing is drawn
                overlaps = true;
                break; // Exit the loop if a star is too close
            }
        }

        // If the star doesn't overlap, add it
        if (!overlaps){
            color starCol = starColor[int(random(starColor.length))]; // color of the star

            float size = random(1, 1.75); // size of the star

            if (starCol == color(255, 100, 100)) {
                size = random(1.5,1.75); // If the star is red, it is a red giant
            }

            int planets = int(random(2,8));

            stars.add(new Star(finalX, finalY, size, starCol, planets)); // Adding the star
        }
    }
}

void drawBlackHole(){
    //drawing the blackhole at the center of the galaxy
    fill(0); 
    noStroke();
    circle(width/2, height/2, 20);  


    if(blackHole){ //Drawing the good black hole
        float angle = 0; //tracks wich angle the line is being drawn on, first line starts at 0

        pushMatrix(); //The push and popMatrix ensure nothing else is affected by the tanslate
        translate(width/2, height/2); //Putting the blackhole at the center of the screen

        for(int i = 0; i < numLines; i++){ //Draws lines for the size of numLines(300 lines)
            
            //x and y variables for the lines. They are made in the for loop because each line needs a new one
            float x1;
            float y1;
            float x2;
            float y2;

            //Creating a random length of the lines using perlin noise
            //Noise essentially makes random more "smooth"
            float randLength = map(noise(pNoiseX+i*0.1, pNoiseY), 0, 1, 10, blackHoleRadius * 4); 

            strokeWeight(random(6,8)); 
            //Updating the x and y values for the lines to go around the circle
            x1 = blackHoleRadius * cos(angle);
            y1 = blackHoleRadius * sin(angle);
            x2 = x1 + randLength * cos(angle+PI/2);
            y2 = y1 + randLength * sin(angle+PI/2);

            //Colour of the lines
            stroke(128, 20);
            line(x1, y1, x2, y2);

            angle+=TWO_PI/numLines; //Increases the angle so the lines are drawn all across the circle, and do not overlap
        }
        popMatrix();

        //needed for the perlin noise, allows for animation aswell :)
        pNoiseX+=.05;
        pNoiseY+=.01;

        //Lines for the info about the blackhole
        sStartLine = 41;
        sEndLine = 45;

        surface.setTitle("Black Hole"); 

    }
}

