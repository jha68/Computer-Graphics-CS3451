// CS 3451 Project 1B

void setup() {
  size (500, 500);
  background (255, 255, 255);
}

void draw() {
  // unused in this program because we only want to draw with keyboard input
}

/******************************************************************************
When key is pressed, call one of the test cases.
******************************************************************************/

void keyPressed() {
  
  stroke (0, 0, 0);
  background (255, 255, 255);

  if (key == '1') { ortho_test(); }
  if (key == '2') { ortho_test_scale(); }
  if (key == '3') { ortho_test_rotate(); }
  if (key == '4') { face_test(); }
  if (key == '5') { faces(); }
  if (key == '6') { ortho_cube(); }
  if (key == '7') { ortho_cube2(); }
  if (key == '8') { perspective_cube(); }
  if (key == '9') { persp_multi_cube(); }
  if (key == '0') { persp_initials(); }
}

/******************************************************************************
Print where the mouse was clicked, possibly useful for debugging.
******************************************************************************/

void mousePressed() {
  if (mouseButton == LEFT) { println("you clicked on pixel ("+mouseX+", "+mouseY+")"); }
}

/******************************************************************************
Test square drawing.
******************************************************************************/

void ortho_test()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  square();
}

/******************************************************************************
Test square drawing with non-uniform scaling.
******************************************************************************/

void ortho_test_scale()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  Scale (1.0, 0.5, 1.0);
  square();
}

/******************************************************************************
Test square drawing with rotation.
******************************************************************************/

void ortho_test_rotate()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  RotateZ (20);
  square();
}

/******************************************************************************
Draw a square.
******************************************************************************/

void square()
{
  Begin_Shape();
  
  Vertex (-50.0, -50.0, 0.0);
  Vertex (-50.0,  50.0, 0.0);

  Vertex (-50.0, 50.0, 0.0);
  Vertex ( 50.0, 50.0, 0.0);

  Vertex (50.0, 50.0, 0.0);
  Vertex (50.0, -50.0, 0.0);

  Vertex (50.0, -50.0, 0.0);
  Vertex (-50.0, -50.0, 0.0);

  End_Shape();
}

/******************************************************************************
Draw a cube.
******************************************************************************/

void cube()
{
  Begin_Shape();

  /* top square */

  Vertex (-1.0, -1.0,  1.0);
  Vertex (-1.0,  1.0,  1.0);

  Vertex (-1.0,  1.0,  1.0);
  Vertex ( 1.0,  1.0,  1.0);

  Vertex ( 1.0,  1.0,  1.0);
  Vertex ( 1.0, -1.0,  1.0);

  Vertex ( 1.0, -1.0,  1.0);
  Vertex (-1.0, -1.0,  1.0);

  /* bottom square */

  Vertex (-1.0, -1.0, -1.0);
  Vertex (-1.0,  1.0, -1.0);

  Vertex (-1.0,  1.0, -1.0);
  Vertex ( 1.0,  1.0, -1.0);

  Vertex ( 1.0,  1.0, -1.0);
  Vertex ( 1.0, -1.0, -1.0);

  Vertex ( 1.0, -1.0, -1.0);
  Vertex (-1.0, -1.0, -1.0);

  /* connect top to bottom */

  Vertex (-1.0, -1.0, -1.0);
  Vertex (-1.0, -1.0,  1.0);

  Vertex (-1.0,  1.0, -1.0);
  Vertex (-1.0,  1.0,  1.0);

  Vertex ( 1.0,  1.0, -1.0);
  Vertex ( 1.0,  1.0,  1.0);

  Vertex ( 1.0, -1.0, -1.0);
  Vertex ( 1.0, -1.0,  1.0);

  End_Shape();
}

/******************************************************************************
Orthographic cube.
******************************************************************************/

void ortho_cube()
{
  Init_Matrix();
    
  Ortho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  Push_Matrix();
  Translate (0.0, 0.0, -4.0);
  RotateY(17.0);
  cube();
  Pop_Matrix();
}

/******************************************************************************
Orthographic cube rotated.
******************************************************************************/

void ortho_cube2()
{
  Init_Matrix();
    
  Ortho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  Push_Matrix();
  Translate (0.0, 0.0, -4.0);
  RotateZ(5.0);
  RotateX(25.0);
  RotateY(20.0);
  cube();
  Pop_Matrix();
}

/******************************************************************************
Perspective cube.
******************************************************************************/

void perspective_cube()
{
  Init_Matrix();
  Perspective (60.0, 1.0, 100.0);

  Push_Matrix();
  Translate (0.0, 0.0, -4.0);
  cube();
  Pop_Matrix();
}

/******************************************************************************
Draw multiple cubes in perspective.
******************************************************************************/

void persp_multi_cube()
{
  Init_Matrix();
  Perspective (60.0, 1.0, 100.0);

  Push_Matrix();
  Translate (0.0, 0.0, -20.0);
  RotateZ(5);
  RotateX(25);
  RotateY(20);

  // draw several cubes in three lines along the axes
  for (float delta = -12; delta <= 12; delta += 3) {
    Push_Matrix();
    Translate(delta, 0, 0);
    cube();
    Pop_Matrix();
    Push_Matrix();
    Translate(0, delta, 0);
    cube();
    Pop_Matrix();
    Push_Matrix();
    Translate(0, 0, delta);
    cube();
    Pop_Matrix();
  }

  Pop_Matrix();
}

/******************************************************************************
Draw a circle of unit radius.
******************************************************************************/

void circle()
{
  int i;
  float theta;
  float x0,y0,x1,y1;
  float steps = 50;

  Begin_Shape();

  x0 = 1.0;
  y0 = 0.0;
  for (i = 0; i <= steps; i++) {
    theta = 2 * 3.1415926535 * i / steps;
    x1 = cos (theta);
    y1 = sin (theta);
    Vertex (x0, y0, 0.0);
    Vertex (x1, y1, 0.0);
    x0 = x1;
    y0 = y1;
  }

  End_Shape();
}

/******************************************************************************
Draw a face.
******************************************************************************/

void face()
{
  /* head */

  Push_Matrix();
  Translate (0.5, 0.5, 0.0);
  Scale (0.4, 0.4, 1.0);
  circle();
  Pop_Matrix();

  /* right eye */

  Push_Matrix();
  Translate (0.7, 0.7, 0.0);
  Scale (0.1, 0.1, 1.0);
  circle();
  Pop_Matrix();

  /* left eye */

  Push_Matrix();
  Translate (0.3, 0.7, 0.0);
  Scale (0.1, 0.1, 1.0);
  circle();
  Pop_Matrix();

  /* nose */

  Push_Matrix();
  Translate (0.5, 0.5, 0.0);
  Scale (0.07, 0.07, 1.0);
  circle();
  Pop_Matrix();

  /* mouth */

  Push_Matrix();
  Translate (0.5, 0.25, 0.0);
  Scale (0.2, 0.1, 1.0);
  circle();
  Pop_Matrix();
}

/******************************************************************************
Test the matrix stack by drawing a face.
******************************************************************************/

void face_test()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  Init_Matrix ();

  Ortho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  face();
}

/******************************************************************************
Draw four faces.
******************************************************************************/

void faces()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  Init_Matrix ();

  Ortho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  Push_Matrix();
  Translate (0.75, 0.25, 0.0);
  Scale (0.5, 0.5, 1.0);
  Translate (-0.5, -0.5, 0.0);
  face();
  Pop_Matrix();

  Push_Matrix();
  Translate (0.25, 0.25, 0.0);
  Scale (0.5, 0.5, 1.0);
  Translate (-0.5, -0.5, 0.0);
  face();
  Pop_Matrix();

  Push_Matrix();
  Translate (0.75, 0.75, 0.0);
  Scale (0.5, 0.5, 1.0);
  Translate (-0.5, -0.5, 0.0);
  face();
  Pop_Matrix();

  Push_Matrix();
  Translate (0.25, 0.75, 0.0);
  Scale (0.5, 0.5, 1.0);
  RotateZ (30.0);
  Translate (-0.5, -0.5, 0.0);
  face();
  Pop_Matrix();
}
