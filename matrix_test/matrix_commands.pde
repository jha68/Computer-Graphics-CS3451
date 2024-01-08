// Junseo Ha
import java.util.ArrayList;

ArrayList<double[][]> matrixStack;
/*
  initializing the identity matrix
*/
void Init_Matrix()
{
  double[][] mat = {
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
  };
  matrixStack = new ArrayList<>();
  matrixStack.add(mat);
}
/*
  replicate the matrix below and add on top of it
*/
void Push_Matrix()
{
  double[][] lastMatrix = matrixStack.get(matrixStack.size() - 1);
  double[][] newMatrix = new double[4][4];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      newMatrix[i][j] = lastMatrix[i][j];
    }
  }
  matrixStack.add(newMatrix);
}
/*
  delete the very top matrix
*/
void Pop_Matrix()
{
  if (matrixStack.size() <= 1) {
      System.out.println("Error: cannot pop the matrix stack");
  } else {
      matrixStack.remove(matrixStack.size() - 1);
  }
}
/*
  printing out the very top matrix
*/
void Print_CTM()
{
  double[][] currentMatrix = matrixStack.get(matrixStack.size() - 1);
  for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
          System.out.print(currentMatrix[i][j] + " ");
      }
      System.out.println();
  }
  System.out.println();
}
/*
  @param x to translate x amount
  @param y to translate y amount
  @param z to translate z amount
*/
void Translate(float x, float y, float z)
{
  double[][] translateMat = {
      {1, 0, 0, x},
      {0, 1, 0, y},
      {0, 0, 1, z},
      {0, 0, 0, 1}
  };
  multiplyMatrix(matrixStack.get(matrixStack.size() - 1), translateMat);
}
/*
  @param A: the first matrix to be multiplied
  @param B: the second matrix to be multiplied
*/
void multiplyMatrix(double[][] A, double[][] B) {
    double[][] result = new double[4][4];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            for (int k = 0; k < 4; k++) {
                result[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    matrixStack.set(matrixStack.size() - 1, result);
}
/*
  @param x to scale x amount
  @param y to scale y amount
  @param z to scale z amount
*/
void Scale(float x, float y, float z)
{
  double[][] scaleMat = {
    {x, 0, 0, 0},
    {0, y, 0, 0},
    {0, 0, z, 0},
    {0, 0, 0, 1}
  };
  multiplyMatrix(matrixStack.get(matrixStack.size() - 1), scaleMat);
}
/*
  @param theta to rotate theta along x-axis in degrees
*/
void RotateX(float theta)
{
  double rad = theta * PI / 180;
  double[][] rotateX = {
      {1, 0, 0, 0},
      {0, Math.cos(rad), -Math.sin(rad), 0},
      {0, Math.sin(rad), Math.cos(rad), 0},
      {0, 0, 0, 1}
  };
  multiplyMatrix(matrixStack.get(matrixStack.size() - 1), rotateX);
}
/*
  @param theta to rotate theta along y-axis in degrees
*/
void RotateY(float theta)
{
  double rad = theta * PI / 180;
  double[][] rotateY = {
      {Math.cos(rad), 0, Math.sin(rad), 0},
      {0, 1, 0, 0},
      {-Math.sin(rad), 0, Math.cos(rad), 0},
      {0, 0, 0, 1}
  };
  multiplyMatrix(matrixStack.get(matrixStack.size() - 1), rotateY);
}
/*
  @param theta to rotate theta along z-axis in degrees
*/
void RotateZ(float theta)
{
  double rad = theta * PI / 180;
  double[][] rotateZ = {
      {Math.cos(rad), -Math.sin(rad), 0, 0},
      {Math.sin(rad), Math.cos(rad), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
  };
  multiplyMatrix(matrixStack.get(matrixStack.size() - 1), rotateZ);
}
