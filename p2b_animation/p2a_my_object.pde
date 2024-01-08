//I'm instantiating the project 2A's object, hachiware()
float time = 0;  // Keep track of the "time"
float cameraZ = 85.0;
float cameraY = 0.0;
float centerX = 0.0;
float centerY = 0.0;
float cameraX = 0.0;
float jump = 0;
float jumpVelocity = 0;
float gravity = 0.2;
float centerZ = -1.0;
float[] cyliPos = {0, 1000, 10};
void setup() {
  size (800, 800, P3D);  // Use 3D here!
  noStroke();  
}

void draw() {
  
  background(255, 255, 255);  // Clear the screen to white

  // Set up for perspective projection
  perspective(PI * 0.333, 1.0, 0.01, 1000.0);
  // Place the camera in the scene
  camera(cameraX, cameraY, cameraZ, 0.0, centerY, centerZ, 0.0, 1.0, 0.0);
  // Create an ambient light source
  ambientLight(70, 70, 70);
  // Create two directional light sources
  lightSpecular(100, 100, 100);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  if (time > 3.5 * 1.8 && time < 6 * 1.8) {
    cameraX -= 0.7;
    cameraY -= 0.5;
    cameraZ += 2;
    centerY += 0.2;
    centerZ += 1.3;
  }
  if (time < 8.25 * 1.8) {
      pushMatrix();
      if (time < 3.5 * 0.03 * 60) {
        rotateY(time);
      } else if (time > 7 * 1.8 && time < 7.5 * 1.8) {
        jumpVelocity = -2;
      }
    
      if (time > 7 * 1.8 && time < 8.25 * 1.8) {
        jump += jumpVelocity;
        jumpVelocity += gravity;
        translate(0, jump, 40 * (time - 7 * 1.8));
        rotateX(time);
      }
      hachiware();
      popMatrix();
      pushMatrix();
      fill(0);
      translate(cyliPos[0], cyliPos[1], cyliPos[2]);
      if (time > 6.955 * 1.8 && time < 7 * 1.8) {
        cyliPos[1] -= 30;
      } else if (time > 7 * 1.8){
        cyliPos[1] += 30;
      } else {
        cyliPos[1] -= 2.2;
      }
      cylinder(3, 800, 10);
      popMatrix();
  } else {
    if (jump < 500) {
      jump += jumpVelocity;
      jumpVelocity += gravity;
      for(int i = 2; i < 7; i++) {
          for(int j = 2; j < 7; j++) {
              if ((i == 2 && (j == 2 || j == 6)) || (i == 6 && (j == 2 || j == 6))) {
                  continue;
              }
              if (j ==2 || (j == 3 && i != 4)) {
                shattered(-35 + 8*i, jump, -18 + 8*j + 40*(time - 7*1.8), true);
              } else {
                if((i==4 && j==3) || (i==4 && j ==4) || (i==4 && j ==5) || (i==3 && j==4) || (i==5 && j==4)) {
                  shattered(-35 + 8*i, jump * 1.05, -18 + 8*j + 40*(time - 7*1.8), false);
                } else if (i==4 && j==4) {
                  shattered(-35 + 8*i, jump * 1.1, -18 + 8*j + 40*(time - 7*1.8), false);
                }else {
                  shattered(-35 + 8*i, jump, -18 + 8*j + 40*(time - 7*1.8), false);
                }
              }
          }
      }
    } else {
      if (time > 9.5 * 1.8 && time < 13 * 1.8) {
        centerY += 4;
        cameraZ -= 1;
        cameraY += 1.8;
      } else if ( time > 34 && time < 36) {
        cameraX += 1.2;
        cameraY += 2;
        cameraZ -= 0.32;
        centerX += 0.75;
        centerZ -= 0.4;
      }
      heart(13, 500, 160, PI/2,0,PI/2);
    }
  }
  pushMatrix();
  for (int i = 0; i < 10; i++) {
    net(-35 + 8*i, 70, 100, 0);
    net(0, 70, 65 + 8*i, PI/2);
  }
  popMatrix();
  // Step forward the time
  time += 0.03;
}
// Process key press events
void keyPressed()
{
  if (key == 's' || key == 'S') {
    save("hachiware.jpg");
    println("Screen shot was saved in JPG file.");
  }
}
/*
  @r for radius
  @h for height
*/
void cone(float r, float h) {
  int segments = 40;
  float angleStep = TWO_PI / segments;
  
  // Draw base
  beginShape(TRIANGLE_FAN);
  vertex(0, -h/2, 0);
  for (float angle = 0; angle <= TWO_PI; angle += angleStep) {
    float x = r * cos(angle);
    float z = r * sin(angle);
    vertex(x, -h/2, z);
  }
  endShape(CLOSE);
  
  // Draw sides
  beginShape(TRIANGLE_FAN);
  vertex(0, h/2, 0);
  for (float angle = 0; angle <= TWO_PI; angle += angleStep) {
    float x = r * cos(angle);
    float z = r * sin(angle);
    vertex(x, -h/2, z);
  }
  endShape(CLOSE);
}
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}
void net(float x, float y, float z, float ry) {
  pushMatrix();
  fill(0);
  translate(x, y, z);
  rotateY(ry);
  scale(0.01, 0.1);
  box(80);
  popMatrix();
}
/*
  @x for position x
  @y for position y
  @z for position z
  @yz for rotateY value
  @sc for y scale
*/
void cheeks(float x, float y, float z, float yz, float sc) {
  pushMatrix();
  fill(255, 62, 73);
  translate(x, y, z);
  rotateY(-yz * PI/180);
  rotateZ(50 * PI/180);
  scale(0.3, sc);
  box(2);
  popMatrix();
}
/*
  @x for position x
  @y for position y
  @z for position z
  @sc for y scale
*/
void pupils(float x, float y, float z, float sc) {
  pushMatrix();
  fill(255, 255, 255);
  translate(x, y, z);
  scale(sc);
  sphere(1);
  popMatrix();
}
void lilHachiware(float x, float y, float z, boolean param) {
  pushMatrix();
  translate(x,y,z);
  rotateX(-PI/5);
  scale(0.2);
  hachiware();
  popMatrix();
}
void hachiware() {
  pushMatrix();
  
  // Rotate based on time

  fill(255, 228, 196);
  sphere(20);
  popMatrix();
  // Draw eyes
  pushMatrix();
  fill(0);
  translate(-6, -5, 18);
  sphere(2);
  popMatrix();
  pushMatrix();
  fill(0);
  translate(6, -5, 18);
  sphere(2);
  popMatrix();
  pupils(-6.5, -5.5, 19, 1);
  pupils(-5.5, -4.5, 19.5, 0.5);
  pupils(6.5, -5.5, 19, 1);
  pupils(6.5, -4.5, 19.5, 0.5);
  //Draw hair
  pushMatrix();
  fill(70, 70, 200);
  translate(-3, -5, 0);
  sphere(16);
  popMatrix();
  pushMatrix();
  fill(70, 70, 200);
  translate(3, -5, 0);
  sphere(16);
  popMatrix();
  //Draw ears
  pushMatrix();
  fill(70, 70, 200);
  translate(-10,-18, 0);
  rotateY(180 * PI/ 180);
  rotateZ(210 * PI/ 180);
  cone(6, 15);
  popMatrix();
  pushMatrix();
  fill(70, 70, 200);
  translate(10,-18, 0);
  rotateZ(210 * PI/ 180);
  cone(6, 15);
  popMatrix();
  //Draw cheeks
  cheeks(-11, 0, 16, 20, 2);
  cheeks(-9, 0, 17, 20, 2.4);
  cheeks(-7, 0, 18, 20, 2);
  cheeks(7, 0, 18, -20, 2);
  cheeks(9, 0, 17, -20, 2.4);
  cheeks(11, 0, 16, -20, 2);
}
float jump2 = 0;
float jumpVelocity2 = -2;
void shattered(float x, float y, float z, boolean isBlue) {
    pushMatrix();
    if(isBlue){
      fill(70, 70, 200);
    } else {
      fill(255, 255, 255);
    }
    translate(x, y, z);
    sphere(4);
    popMatrix();
}
float r = 100;
float r2 = 50;
float r3 = 25;
void heart(float x, float y, float z, float rx, float ry, float rz) {
  if (r > 0 && time > 14 * 1.8) {
    r -= 0.4;
  }
  if (r2 > 0 && time > 14 * 1.8) {
    r2 -= 0.2;
  }
  if (r3 > 0 && time > 14 * 1.8) {
    r3 -= 0.1;
  }
  if (time < 33.5) {
    pushMatrix();
    translate(x, y, z);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    shattered(0 + r,0 + r2,0,false);
    shattered(6,-6 - r,0,true);
    shattered(14 + r3,-10,0,false);
    shattered(23,-6,0,true);
    shattered(28 + r2,1,0,false);
    shattered(30,10,0,true);
    shattered(28 + r3,19 - r,0,false);
    shattered(24,27,0,true);
    shattered(18 - r2,34,0,false);
    shattered(11 + r3,40,0,true);
    shattered(1,45 - r2,0,false);
    shattered(-6 + r,-6 + r3,0,true);
    shattered(-14 + r,-10,0,false);
    shattered(-22 - r3,-6 + r2,0,true);
    shattered(-27 + r3,1 - r2,0,false);
    shattered(-29,10 + r,0,true);
    shattered(-27 - r2,19,0,false);
    shattered(-22 + r3,27 + r,0,true);
    shattered(-16 + r,34,0,false);
    shattered(-9,40,0,true);
    popMatrix();
  } else {
    pushMatrix();
    translate(x, y, z);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    lilHachiware(0 + r,0 + r2,0,false);
    lilHachiware(6,-6 - r,0,true);
    lilHachiware(14 + r3,-10,0,false);
    lilHachiware(23,-6,0,true);
    lilHachiware(28 + r2,1,0,false);
    lilHachiware(30,10,0,true);
    lilHachiware(28 + r3,19 - r,0,false);
    lilHachiware(24,27,0,true);
    lilHachiware(18 - r2,34,0,false);
    lilHachiware(11 + r3,40,0,true);
    lilHachiware(1,45 - r2,0,false);
    lilHachiware(-6 + r,-6 + r3,0,true);
    lilHachiware(-14 + r,-10,0,false);
    lilHachiware(-22 - r3,-6 + r2,0,true);
    lilHachiware(-27 + r3,1 - r2,0,false);
    lilHachiware(-29,10 + r,0,true);
    lilHachiware(-27 - r2,19,0,false);
    lilHachiware(-22 + r3,27 + r,0,true);
    lilHachiware(-16 + r,34,0,false);
    lilHachiware(-9,40,0,true);
    popMatrix();
  }
}
