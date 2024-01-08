// CS 3451 Project 3B
// Example scenes to test your hidden surfaces and shading

// vertex class to use for contructing objects such as sphere and torus
class Vert {
  float x,y,z;
  float nx,ny,nz;
  
  Vert (float xx, float yy, float zz, float xn, float yn, float zn) {
    x = xx; y = yy; z = zz;
    nx = xn; ny = yn; nz = zn;
  }
}

/******************************************************************************
Initizlize the window.
******************************************************************************/

void setup() {
  size (500, 500);
  background (225, 225, 255);
  noStroke();
}

// we don't use the draw() function for this project
void draw() { }

// set the background color
void set_background()
{
  background (225, 225, 255);
}

/******************************************************************************
When key is pressed, call one of the test cases.
******************************************************************************/

void keyPressed() {
  
  // different scenes
  if (key == '1') { triangle_0(); }
  if (key == '2') { triangle_1(); }
  if (key == '3') { triangle_overlap(); }
  if (key == '4') { sphere_two_colors(); }
  if (key == '5') { two_spheres(); }
  if (key == '6') { sphere_one_color(); }
  if (key == '7') { torus_in_perspective(); }
  if (key == '8') { three_shapes(); }
  if (key == '9') { three_tori(); } 
  
  // select a shading mode
  if (key == 'a') { shade = Shading.WIREFRAME; }
  if (key == 's') { shade = Shading.CONSTANT; }
  if (key == 'd') { shade = Shading.FLAT; }
  if (key == 'f') { shade = Shading.GOURAUD; }
  if (key == 'g') { shade = Shading.PHONG; }

  if (key == 'w') {
    save ("image_file.jpg");
    println ("Screen shot was saved in JPG file.");
    return;
  }
}

/******************************************************************************
Draw one triangle, using the default identity transformation.
******************************************************************************/

void triangle_0()
{
  Init_Scene();
  set_background();
  
  Set_Field_Of_View (0);  // orthographic projection
  
  Set_Light (0, 0, 1, 1, 1, 1);

  Normal (0, 0, 1);

  Set_Color (1, 0, 0);
  
  Begin_Shape();
  Vertex (250, 100, 0);
  Vertex (400, 400, 0);
  Vertex (100, 400, 0);
  End_Shape();
}

/******************************************************************************
Draw two triangles.
******************************************************************************/

void triangle_1()
{
  Init_Scene();
  set_background();
  
  Set_Field_Of_View (0);  // orthographic projection
  
  Set_Light (0, 0, 1, 1, 1, 1);

  Normal (0, 0, 1);

  Set_Color (1, 0, 0);

  // scale and translate the triangle
  Set_Matrix (100.0, 0.0, 0.0, 150.0, 
              0.0, 100.0, 0.0, 250.0, 
              0.0, 0.0, 100.0, 0.0, 
              0.0, 0.0, 0.0, 1.0);
    
  eq_tri();
    
  Set_Color (0, 1, 0);

  // scale, translate and rotate by 180 degrees (flip upside-down)
  Set_Matrix (-100.0, 0.0, 0.0, 350.0, 
               0.0, -100.0, 0.0, 250.0, 
               0.0, 0.0, 100.0, 0.0, 
               0.0, 0.0, 0.0, 1.0);
  
  eq_tri();
}

/******************************************************************************
Draw three overlapping triangles.  Note that the z-values will cause the
red one to be drawn in front of the green one, even though it is drawn first.
******************************************************************************/

void triangle_overlap()
{
  Init_Scene();
  set_background();

  Set_Field_Of_View (0);  // orthographic projection

  Normal (0, 0, 1);

  Set_Light (0, 0, 1, 1, 1, 1);

  Set_Color (1, 0, 0);
  
  Set_Matrix (120.0, 0.0, 0.0, 200.0, 
              0.0, 120.0, 0.0, 200.0, 
              0.0, 0.0, 120.0, -40.0, 
              0.0, 0.0, 0.0, 1.0);
    
  eq_tri();
  
  Set_Color (0, 1, 0);

  Set_Matrix (120.0, 0.0, 0.0, 250.0, 
              0.0, 120.0, 0.0, 250.0, 
              0.0, 0.0, 120.0, -60.0, 
              0.0, 0.0, 0.0, 1.0);
              
  eq_tri();
  
  Set_Color (0, 0, 1);

  Set_Matrix (120.0, 0.0, 0.0, 300.0, 
              0.0, 120.0, 0.0, 300.0, 
              0.0, 0.0, 120.0, -20.0, 
              0.0, 0.0, 0.0, 1.0);
              
  eq_tri();
}

/******************************************************************************
Test the sphere drawing.
******************************************************************************/

void sphere_two_colors()
{
  Init_Scene();
  set_background();
  
  Set_Light (0.5, 0.5, 0.5, 1, 1, 1);

  Set_Field_Of_View (0);  // orthographic projection
  
  Set_Matrix (1.0, 0.0, 0.0, 250.0, 
              0.0, 0.70710677, 0.70710677, 250.0, 
              0.0, -0.70710677, 0.70710677, 0.0, 
              0.0, 0.0, 0.0, 1.0);
    
  sphere (180, 20, 12, 1, 0.3, 0.5, .3, .5, 1);
}

/******************************************************************************
Test the sphere drawing.
******************************************************************************/

void sphere_one_color()
{
  Init_Scene();
  set_background();
  
  Set_Light (0.5, 0.5, 0.5, 1, 1, 1);

  Set_Field_Of_View (0);  // orthographic projection
  
  Set_Matrix (1.0, 0.0, 0.0, 250.0, 
              0.0, 0.70710677, 0.70710677, 250.0, 
              0.0, -0.70710677, 0.70710677, 0.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, .6, .6, .6, 30);
  
  sphere (180, 20, 12, .9, 0.3, 0.5, .9, 0.3, 0.5);
}

/******************************************************************************
Test the sphere drawing.
******************************************************************************/

void two_spheres()
{
  Init_Scene();
  set_background();
  
  Set_Light (0.0, 1.0, 0.2, 1, 1, 1);

  Set_Field_Of_View (0);  // orthographic projection
  
  Set_Matrix (1.0, 0.0, 0.0, 130.0, 
              0.0, 1.0, 0.0, 250.0, 
              0.0, 0.0, 1.0, 0.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, 0, 0, 0, 30);
  
  sphere (110, 20, 12, .9, 0.3, 0.5, .9, 0.3, 0.5);
  
  Set_Matrix (1.0, 0.0, 0.0, 370.0, 
              0.0, 1.0, 0.0, 250.0, 
              0.0, 0.0, 1.0, 0.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0.2, 0.2, 0.2, 0, 0, 0, 30);
  
  sphere (110, 20, 12, .9, 0.3, 0.5, .9, 0.3, 0.5);
}

/******************************************************************************
Draw an object in perspective.
******************************************************************************/

void torus_in_perspective()
{
  Init_Scene();
  set_background();
  
  Set_Light (0.5, 0.5, 0.5, 1, 1, 1);

  Set_Field_Of_View (60);   // perspective projection

  Set_Color (1, 0, 0);
  
  Set_Matrix (1.0, 0.0, 0.0, 0.0, 
              0.0, 0.5, 0.86602545, 0.0, 
              0.0, -0.86602545, 0.5, -600.0, 
              0.0, 0.0, 0.0, 1.0);
  
  torus (180, 50, 20, 12, 1, 0.3, 0.5, .3, .5, 1);
}

/******************************************************************************
Draw three shapes.
******************************************************************************/

void three_shapes()
{
  Init_Scene();
  set_background();

  Set_Field_Of_View (60);    // perspective projection

  Set_Light (0.2, 0.2, 1.0, 1, 1, 1);

  Set_Color (1, 0, 0);
  
  Set_Matrix (65.77848, 0.0, -23.94141, 0.0, 
              16.929134, 49.497475, 46.512413, 0.0, 
              16.929134, -49.497475, 46.512413, -700.0, 
              0.0, 0.0, 0.0, 1.0);
  
  cube (1, 0.3, 0.5, .3, .5, 1, 0.3, 1, 0.5);
  
  Set_Matrix (1.0, 0.0, 0.0, -230.0, 
              0.0, 0.70710677, 0.70710677, 0.0, 
              0.0, -0.70710677, 0.70710677, -700.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, .6, .6, .6, 30);
  
  sphere (100, 20, 12, .9, 0.3, 0.5, .9, 0.3, 0.5);

  Set_Matrix (1.0, 0.0, 0.0, 230.0, 
              0.0, 0.70710677, 0.70710677, 0.0, 
              0.0, -0.70710677, 0.70710677, -700.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, .6, .6, .6, 30);
  
  torus (100, 30, 20, 12, .3, 0.9, 0.5, .3, 0.9, 0.5);
}

/******************************************************************************
Draw three tori with different surface shading.
******************************************************************************/

void three_tori()
{
  Init_Scene();
  set_background();

  Set_Field_Of_View (30);    // perspective projection

  Set_Light (0.2, 0.5, 0.8, .8, .8, .8);

  Set_Color (1, 0, 0);
  
  Set_Matrix (0.34202003, 0.66446304, 0.66446304, -100.0, 
              -0.9396927, 0.24184468, 0.24184468, 0.0, 
              0.0, -0.70710677, 0.70710677, -600.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, 0, 0, 0, 30);

  torus (40, 15, 20, 12, .3, 0.7, 0.5, .3, 0.7, 0.5);
  
  Set_Matrix (0.34202003, 0.66446304, 0.66446304, 0.0, 
              -0.9396927, 0.24184468, 0.24184468, 0.0, 
              0.0, -0.70710677, 0.70710677, -600.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0.2, 0.2, 0.2, 0, 0, 0, 30);
  
  torus (40, 15, 20, 12, .3, 0.7, 0.5, .3, 0.7, 0.5);

  Set_Matrix (0.34202003, 0.66446304, 0.66446304, 100.0, 
              -0.9396927, 0.24184468, 0.24184468, 0.0, 
              0.0, -0.70710677, 0.70710677, -600.0, 
              0.0, 0.0, 0.0, 1.0);
  
  Ambient_Specular (0, 0, 0, .6, .6, .6, 30);
  
  torus (40, 15, 20, 12, .3, 0.7, 0.5, .3, 0.7, 0.5);
}

/******************************************************************************
Draw an equilateral triangle.
Center = (0, 0, 0), radius = 1
******************************************************************************/

void eq_tri()
{
  float rad = 1.0;
  
  Normal (0, 0, 1);
  
  Begin_Shape();

  for (int i = 0; i < 3; i++) {
    float theta = (i + 0.25) * 2 * PI / 3.0;
    float x = rad * cos (theta);
    float y = rad * sin (theta);
    Vertex (x, y, 0);
  }
  
  End_Shape();
}

/******************************************************************************
Draw a cube centered at (0,0,0) with sides lengths of 2 (-1 to 1 ranges).
r1,g1,b1 - first color
r2,g2,b2 - second color
******************************************************************************/

void cube (float r1, float g1, float b1, float r2, float g2, float b2,
           float r3, float g3, float b3)
{
  // first make 2D array of vertex positions
  
  Vert[] v = new Vert[8];
  
  // define the eight vertices of a cube
  
  v[0] = new Vert (-1, -1, -1, 0, 0, 0);
  v[1] = new Vert ( 1, -1, -1, 0, 0, 0);
  v[2] = new Vert ( 1,  1, -1, 0, 0, 0);
  v[3] = new Vert (-1,  1, -1, 0, 0, 0);
  v[4] = new Vert (-1, -1,  1, 0, 0, 0);
  v[5] = new Vert ( 1, -1,  1, 0, 0, 0);
  v[6] = new Vert ( 1,  1,  1, 0, 0, 0);
  v[7] = new Vert (-1,  1,  1, 0, 0, 0);
  
  // now create the six square faces (two triangles per square)
  
  Normal (0, 0, -1);

  Set_Color (r1, g1, b1);
  Begin_Shape();
  Vertex (v[0].x, v[0].y, v[0].z);
  Vertex (v[3].x, v[3].y, v[3].z);
  Vertex (v[2].x, v[2].y, v[2].z);
  End_Shape();
  
  Set_Color (r1, g1, b1);
  Begin_Shape();
  Vertex (v[2].x, v[2].y, v[2].z);
  Vertex (v[1].x, v[1].y, v[1].z);
  Vertex (v[0].x, v[0].y, v[0].z);
  End_Shape();
  
  Normal (0, 0, 1);
  
  Set_Color (r1, g1, b1);
  Begin_Shape();
  Vertex (v[4].x, v[4].y, v[4].z);
  Vertex (v[5].x, v[5].y, v[5].z);
  Vertex (v[6].x, v[6].y, v[6].z);
  End_Shape();
  
  Set_Color (r1, g1, b1);
  Begin_Shape();
  Vertex (v[6].x, v[6].y, v[6].z);
  Vertex (v[7].x, v[7].y, v[7].z);
  Vertex (v[4].x, v[4].y, v[4].z);
  End_Shape();
  
  Normal (1, 0, 0);
  
  Set_Color (r2, g2, b2);
  Begin_Shape();
  Vertex (v[5].x, v[5].y, v[5].z);
  Vertex (v[1].x, v[1].y, v[1].z);
  Vertex (v[2].x, v[2].y, v[2].z);
  End_Shape();
  
  Set_Color (r2, g2, b2);
  Begin_Shape();
  Vertex (v[2].x, v[2].y, v[2].z);
  Vertex (v[6].x, v[6].y, v[6].z);
  Vertex (v[5].x, v[5].y, v[5].z);
  End_Shape();
  
  Normal (-1, 0, 0);

  Set_Color (r2, g2, b2);
  Begin_Shape();
  Vertex (v[0].x, v[0].y, v[0].z);
  Vertex (v[4].x, v[4].y, v[4].z);
  Vertex (v[7].x, v[7].y, v[7].z);
  End_Shape();
  
  Set_Color (r2, g2, b2);
  Begin_Shape();
  Vertex (v[7].x, v[7].y, v[7].z);
  Vertex (v[3].x, v[3].y, v[3].z);
  Vertex (v[0].x, v[0].y, v[0].z);
  End_Shape();
  
  Normal (0, 1, 0);

  Set_Color (r3, g3, b3);
  Begin_Shape();
  Vertex (v[2].x, v[2].y, v[2].z);
  Vertex (v[3].x, v[3].y, v[3].z);
  Vertex (v[7].x, v[7].y, v[7].z);
  End_Shape();
  
  Set_Color (r3, g3, b3);
  Begin_Shape();
  Vertex (v[7].x, v[7].y, v[7].z);
  Vertex (v[6].x, v[6].y, v[6].z);
  Vertex (v[2].x, v[2].y, v[2].z);
  End_Shape();
  
  Normal (0, -1, 0);

  Set_Color (r3, g3, b3);
  Begin_Shape();
  Vertex (v[0].x, v[0].y, v[0].z);
  Vertex (v[1].x, v[1].y, v[1].z);
  Vertex (v[5].x, v[5].y, v[5].z);
  End_Shape();
  
  Set_Color (r3, g3, b3);
  Begin_Shape();
  Vertex (v[5].x, v[5].y, v[5].z);
  Vertex (v[4].x, v[4].y, v[4].z);
  Vertex (v[0].x, v[0].y, v[0].z);
  End_Shape();
}

/******************************************************************************
Draw a sphere.
center = (0, 0, 0), radius = 1

count1, count2 - how many polygons in major and minor direction
r1,g1,b1 - first color
r2,g2,b2 - second color
******************************************************************************/

void sphere (float rad, int count1, int count2,
            float r1, float g1, float b1, float r2, float g2, float b2)
{
  // first make 2D array of vertex positions
  
  Vert[][] verts = new Vert[count1][count2];
  
  for (int i = 0; i < count1; i++) {
    float theta = i * 2 * PI / (float) count1;   // 0 to 2*pi
    
    for (int j = 0; j < count2; j++) {
      float alpha = j * PI / (float) (count2-1);  // 0 to pi
      alpha -= 0.5 * PI;                          // -pi/2 to pi/2
      
      // half-circle in xz-plane
      float xx = cos(alpha);
      float zz = sin(alpha);
      
      // take (xx, zz) and rotate in the xy-plane
      float x = xx * cos(theta);
      float y = xx * sin(theta);
      float z = zz;
      verts[i][j] = new Vert (rad * x, rad * y, rad * z, x, y, z);
    }
  }
  
  // now connect together the vertices with triangles
  for (int i = 0; i < count1; i++) {
    int ii = (i + 1) % count1;
    
    for (int j = 0; j < count2-1; j++) {
      int jj = j + 1;
      
      Vert v00 = verts[i][j];
      Vert v01 = verts[i][jj];
      Vert v10 = verts[ii][j];
      Vert v11 = verts[ii][jj];
      
      if (j > 0 && j < count2-2) {  // main body, away from the poles
        Set_Color (r1, g1, b1);
        Begin_Shape();
        Normal (v00.nx, v00.ny, v00.nz);
        Vertex (v00.x, v00.y, v00.z);
        Normal (v10.nx, v10.ny, v10.nz);
        Vertex (v10.x, v10.y, v10.z);
        Normal (v01.nx, v01.ny, v01.nz);
        Vertex (v01.x, v01.y, v01.z);
        End_Shape();
        
        Set_Color (r2, g2, b2);
        Begin_Shape();
        Normal (v10.nx, v10.ny, v10.nz);
        Vertex (v10.x, v10.y, v10.z);
        Normal (v11.nx, v11.ny, v11.nz);
        Vertex (v11.x, v11.y, v11.z);
        Normal (v01.nx, v01.ny, v01.nz);
        Vertex (v01.x, v01.y, v01.z);
        End_Shape();
      }
      else {  // triangles at the poles of altrnating colors
        if (i % 2 == 0)
          Set_Color (r1, g1, b1);
        else
          Set_Color (r2, g2, b2);
        if (j > 0) {
          Begin_Shape();
          Normal (v00.nx, v00.ny, v00.nz);
          Vertex (v00.x, v00.y, v00.z);
          Normal (v10.nx, v10.ny, v10.nz);
          Vertex (v10.x, v10.y, v10.z);
          Normal (v01.nx, v01.ny, v01.nz);
          Vertex (v01.x, v01.y, v01.z);
          End_Shape();
        }
        else {
          Begin_Shape();
          Normal (v10.nx, v10.ny, v10.nz);
          Vertex (v10.x, v10.y, v10.z);
          Normal (v11.nx, v11.ny, v11.nz);
          Vertex (v11.x, v11.y, v11.z);
          Normal (v01.nx, v01.ny, v01.nz);
          Vertex (v01.x, v01.y, v01.z);
          End_Shape();
        }
      }
      
    }
    
  }
}

/******************************************************************************
Draw a torus.
Center = (0, 0, 0)

rad1 - major radius
rad2 - minor radius
count1, count2 - how many polygons in major and minor direction
r1,g1,b1 - first color
r2,g2,b2 - second color
******************************************************************************/

void torus (float rad1, float rad2, int count1, int count2,
            float r1, float g1, float b1, float r2, float g2, float b2)
{
  // first make 2D array of vertex positions
  
  Vert[][] verts = new Vert[count1][count2];
  
  for (int i = 0; i < count1; i++) {
    float theta = i * 2 * PI / (float) count1;
    
    for (int j = 0; j < count2; j++) {
      float alpha = j * 2 * PI / (float) count2;
      
      // circle in xz-plane, moved over by rad1 in x
      float xx = rad2 * cos(alpha) + rad1;
      float zz = rad2 * sin(alpha);
      
      float nx = cos(alpha);
      float nz = sin(alpha);
      
      // take (xx, zz) and rotate in the xy-plane
      float x = xx * cos(theta);
      float y = xx * sin(theta);
      float z = zz;
      
      float xn = nx * cos(theta);
      float yn = nx * sin(theta);
      float zn = nz;
      verts[i][j] = new Vert (x, y, z, xn, yn, zn);
    }
  }
  
  // now connect together the vertices with triangles
  for (int i = 0; i < count1; i++) {
    int ii = (i + 1) % count1;
    
    for (int j = 0; j < count2; j++) {
      int jj = (j+1) % count2;
      
      Vert v00 = verts[i][j];
      Vert v01 = verts[i][jj];
      Vert v10 = verts[ii][j];
      Vert v11 = verts[ii][jj];
      
      Set_Color (r1, g1, b1);
      Begin_Shape();
      Normal (v00.nx, v00.ny, v00.nz);
      Vertex (v00.x,  v00.y,  v00.z);
      Normal (v10.nx, v10.ny, v10.nz);
      Vertex (v10.x,  v10.y,  v10.z);
      Normal (v01.nx, v01.ny, v01.nz);
      Vertex (v01.x,  v01.y,  v01.z);
      End_Shape();
      
      Set_Color (r2, g2, b2);
      Begin_Shape();
      Normal (v10.nx, v10.ny, v10.nz);
      Vertex (v10.x,  v10.y,  v10.z);
      Normal (v11.nx, v11.ny, v11.nz);
      Vertex (v11.x,  v11.y,  v11.z);
      Normal (v01.nx, v01.ny, v01.nz);
      Vertex (v01.x,  v01.y,  v01.z);
      End_Shape();
    }
    
  }
}

/******************************************************************************
Print where the mouse was clicked, hopefully useful for debugging.
******************************************************************************/

void mousePressed() {
  if (mouseButton == LEFT) {
    int x = mouseX;
    int y = mouseY;
    println ("you clicked on pixel:");
    println ("  ("+x+", "+y+")   [origin upper left]");
    y = height - y - 1;
    println ("  ("+x+", "+y+")   [origin lower left]"); 
  }
}
