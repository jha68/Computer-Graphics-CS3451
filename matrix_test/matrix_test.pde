// Matrix Commands

void setup() {
  size (50, 50);
  mat_test();
}

// test the various matrix commands and print the current transformation matrix
void mat_test() {

  println ("Initialize Matrix");
  Init_Matrix();
  Print_CTM();
    
  println ("Test Stack Underflow");
  Init_Matrix();
  Pop_Matrix();
  println();

  println ("Translate");
  Init_Matrix();
  Translate (3, 2, 1.5);
  Print_CTM();

  println ("Translate and Matrix Stack");
  Init_Matrix();
  Translate (-1, 4, -2);
  Push_Matrix();
  Translate (2, -2.5, 0);
  Print_CTM();
  Pop_Matrix();
  Print_CTM();

  println ("Scale");
  Init_Matrix();
  Scale (2, 3, 4);
  Print_CTM();

  println ("Rotate X");
  Init_Matrix();
  RotateX (90);
  Print_CTM();

  println ("Rotate Y");
  Init_Matrix();
  RotateY (-15);
  Print_CTM();

  println ("Rotate Z and Matrix Stack");
  Init_Matrix();
  Push_Matrix();
  RotateZ (45);
  Print_CTM();
  Pop_Matrix();
  Print_CTM();

  println ("Rotate and Translate");
  Init_Matrix();
  RotateZ (90);
  Translate (7, 5, 3);
  Print_CTM();

  println ("Translate and Rotate");
  Init_Matrix();
  Translate (7, 5, 3);
  RotateZ (90);
  Print_CTM();

  println ("Translate and Scale");
  Init_Matrix();
  Translate (1.5, 2.5, 3.5);
  Scale (2, 2, 2);
  Print_CTM();

  println ("Scale and Translate");
  Init_Matrix();
  Scale (4, 2, 0.5);
  Translate (2, -2, 10);
  Print_CTM();
}

void draw() {}
