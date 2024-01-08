/******************************************************************************
Draw your initials below in perspective.
******************************************************************************/

void persp_initials()
{
  Init_Matrix();
  
  Perspective (50.0, 0.0, 0.0);

  Push_Matrix();
  
  Translate (0.0, 0.0, -5.0);
  RotateX(-55);
  
  Begin_Shape();

  Vertex(-1.0, 1.0, 0.0);
  Vertex(0.0, 1.0, 0.0);
  
  Vertex(-0.5, 1.0, 0.0);
  Vertex(-0.5, -1.0, 0.0);
  
  Vertex(-0.5, -1.0, 0.0);
  Vertex(-1.0, -1.0, 0.0);
  
  Vertex(-1.0, -1.0, 0.0);
  Vertex(-1.0, -0.5, 0.0);
  
  Vertex(0.0, 1.0, 0.0);
  Vertex(0.0, -1.0, 0.0);
  
  Vertex(0.0, 0.0, 0.0);
  Vertex(1.0, 0.0, 0.0);
  
  Vertex(1.0, 1.0, 0.0);
  Vertex(1.0, -1.0, 0.0);
  End_Shape();
  
  Pop_Matrix();
}
