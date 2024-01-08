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
void Translate(double x, double y, double z)
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
void Scale(double x, double y, double z)
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
void RotateX(double theta)
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
void RotateY(double theta)
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
void RotateZ(double theta)
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
ArrayList<double[]> vertexList;
double[] orthoParams;
double[] perspectiveParams;
boolean isOrtho = true;
/*
  @param l for left
  @param r for right
  @param b for bottom
  @param t for top
  @param n for near
  @param f for far
*/
void Ortho(double l, double r, double b, double t, double n, double f)
{
  isOrtho = true;
  orthoParams = new double[]{l, r, b, t, n, f};
}

/*
  @param f for field of view
  @param near for near
  @param far for far
*/
void Perspective(double f, double near, double far)
{
  isOrtho = false;
  perspectiveParams = new double[]{f * PI / 180, near, far};
}
/*
  method to initialize a list of vertices for the shape
*/
void Begin_Shape()
{
  vertexList = new ArrayList<>();
}
/*
  method to add a vertex to vertexList
*/
void Vertex(double x, double y, double z)
{
  vertexList.add(new double[]{x, y, z});
}
/*
  @param matrix for matrix that will be multiplied
  @param vertex for the vertex that will be multiplied by the matrix
  @return the multiplied new vertex
*/
double[] multiplyVertex(double[][] matrix, double[] vertex)
{
  double[] newV = new double[vertex.length];
  for (int i = 0; i < newV.length; i++) {
    newV[i] = matrix[i][0] * vertex[0] + matrix[i][1] * vertex[1] + matrix[i][2] * vertex[2] + matrix[i][3];
  }
  return newV;
}
/*
  method to actually draw the shape
*/
void End_Shape()
{
  for (int i = 0; i < vertexList.size() - 1; i += 2) {
    double[] v1 = multiplyVertex(matrixStack.get(matrixStack.size() - 1), vertexList.get(i));
    double[] v2 = multiplyVertex(matrixStack.get(matrixStack.size() - 1), vertexList.get(i + 1));
    double x1, y1, x2, y2;
    if (isOrtho) {
      x1 = (v1[0] - orthoParams[0]) * width / (orthoParams[1] - orthoParams[0]);
      y1 = (v1[1] - orthoParams[2]) * height / (orthoParams[3] - orthoParams[2]);
      x2 = (v2[0] - orthoParams[0]) * width / (orthoParams[1] - orthoParams[0]);
      y2 = (v2[1] - orthoParams[2]) * height / (orthoParams[3] - orthoParams[2]);
    } else {
      float k = tan((float) perspectiveParams[0] / 2.0);
      x1 = (v1[0] / abs((float) v1[2]) + k) * width / (2 * k);
      y1 = (v1[1] / abs((float) v1[2]) + k) * height / (2 * k);
      x2 = (v2[0] / abs((float) v2[2]) + k) * width / (2 * k);
      y2 = (v2[1] / abs((float) v2[2]) + k) * height / (2 * k);
    }
    line((float) x1, (float) (height - y1), (float) x2, (float) (height - y2));
  }
}
