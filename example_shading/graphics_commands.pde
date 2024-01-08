// Routines for graphics commands (especially for shading and z-buffer).
// Most of these are for you to write.

public enum Shading { WIREFRAME, CONSTANT, FLAT, GOURAUD, PHONG }
Shading shade = Shading.CONSTANT;  // the current shading mode

// current transformation matrix and its adjoint
PMatrix3D cmat;
PMatrix3D adj;

float field_of_view = 0.0;  // non-zero value indicates perspective projection


// you should initialize your z-buffer here, and also various material color parameters
float[][] zbuffer;
float[][] verticesList = new float[3][3];
float[][] normalList = new float[3][3];
int vertexIndex = 0;
ArrayList<float[]> colorList = new ArrayList<float[]>();
void Init_Scene() {
  
  // create the current transformation matrix, and its adjoint for transforming the normals
  cmat = new PMatrix3D();
  cmat.reset();             // sets the current transformation to the identity
    
  // calculate the adjoint of the transformation matrix
  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
  
  // initialize your z-buffer here
  zbuffer = new float[width][height];
  for (int i = 0; i < width; i++)
    for (int j = 0; j < height; j++)
      zbuffer[i][j] = Float.NEGATIVE_INFINITY;
  // set default values to material colors here
  ambientSpecularList.clear();
  ambientSpecularList.add(new float[] {0,0,0,0,0,0,0});
}

void Set_Field_Of_View (float fov)
{
  field_of_view = fov;
}

void Set_Color (float r, float g, float b)
{
  colorList.add(new float[] {r, g, b});
}

ArrayList<float[]> ambientSpecularList = new ArrayList<float[]>();
void Ambient_Specular (float ar, float ag, float ab, float sr, float sg, float sb, float pow) {
    ambientSpecularList.add(new float[] {ar, ag, ab, sr, sg, sb, pow});
}
float normal_x = 0, normal_y = 0, normal_z = 1;
void Normal(float nx, float ny, float nz)
{
  normal_x = nx;
  normal_y = ny;
  normal_z = nz;
}

float light_x, light_y, light_z;
float light_r, light_g, light_b;

void Set_Light (float x, float y, float z, float r, float g, float b)
{
  // set light value here
  // don't forget to normaize the direction of the light vector
  PVector light = new PVector(x, y, z);
  light.normalize();
  light_x = x;
  light_y = y;
  light_z = z;
  light_r = r;
  light_g = g;
  light_b = b;
}
void Begin_Shape() {
  vertexIndex = 0;
}

// some of this code is provided, but you should save the resulting projected coordinates
// and surface normals in your own data structures for vertices
void Vertex(float vx, float vy, float vz) {
  
  float x,y,z;

  // transform this vertex by the current transformation matrix
  x = vx * cmat.m00 + vy * cmat.m01 + vz * cmat.m02 + cmat.m03;
  y = vx * cmat.m10 + vy * cmat.m11 + vz * cmat.m12 + cmat.m13;
  z = vx * cmat.m20 + vy * cmat.m21 + vz * cmat.m22 + cmat.m23;
  // calculate the transformed surface normal (using the adjoint)
  // note that you need to provide normal_x, normal_y and normal_z set from the Normal() command
  float nx,ny,nz;
  nx = normal_x * adj.m00 + normal_y * adj.m01 + normal_z * adj.m02 + adj.m03;
  ny = normal_x * adj.m10 + normal_y * adj.m11 + normal_z * adj.m12 + adj.m13;
  nz = normal_x * adj.m20 + normal_y * adj.m21 + normal_z * adj.m22 + adj.m23;
  float xx = x;
  float yy = y;
  float zz = z;
  
  // field of view greater than zero means use perspective projection
  if (field_of_view > 0) {
    float theta = field_of_view * PI / 180.0;  // convert to radians
    float k = tan (theta / 2);
    xx = x / abs(z);
    yy = y / abs(z);
    xx = (xx + k) * width  / (2 * k);
    yy = (yy + k) * height / (2 * k);
    zz = z;
  }
  verticesList[vertexIndex][0] = xx;
  verticesList[vertexIndex][1] = yy;
  verticesList[vertexIndex][2] = zz;
  normalList[vertexIndex][0] = nx;
  normalList[vertexIndex][1] = ny;
  normalList[vertexIndex][2] = nz;
  vertexIndex++;
  // xx,yy,zz are screen space coordinates of the vertex, after transformation and projection

  // !!!! store xx,yy,zz and nx,ny,nz somewhere for you to use for rasterization and shading !!!!

}

// rasterize a triangle
void End_Shape() {
  while (colorList.size() < 3) {
    colorList.add(colorList.get(0));
  }
  for (int i = 0; i < 3; i++) {
    for (int j = i+1; j < 3; j++) {
      if (verticesList[j][1] < verticesList[i][1]) {
        float[] temp = verticesList[i];
        verticesList[i] = verticesList[j];
        verticesList[j] = temp;
        float[] temp2 = normalList[i];
        normalList[i] = normalList[j];
        normalList[j] = temp2;
        float[] rgb = colorList.get(i);
        colorList.set(i, colorList.get(j));
        colorList.set(j, rgb);
      }
    }
  }
  if (shade == Shading.FLAT) {
      PVector edge1 = PVector.sub(new PVector(verticesList[0][0], verticesList[0][1], verticesList[0][2]), 
                                  new PVector(verticesList[2][0], verticesList[2][1], verticesList[2][2]));
  
      PVector edge2 = PVector.sub(new PVector(verticesList[2][0], verticesList[2][1], verticesList[2][2]), 
                                  new PVector(verticesList[1][0], verticesList[1][1], verticesList[1][2]));
  
      PVector normal = edge1.cross(edge2);
      normal.normalize();
  
      PVector viewDirection = new PVector(0,0,1); // Assuming viewer is along the z-axis
      if (normal.dot(viewDirection) < 0) {
        normal.mult(-1);
      }

      float[] c = computeShadingColor(normal, 0);
      for (int i = 0; i < 3; i++) {
          colorList.set(i, c);
      }
  } else if (shade == Shading.GOURAUD) {
    for (int i = 0; i < 3; i++) {
      PVector normal = new PVector(normalList[i][0], normalList[i][1], normalList[i][2]);
      normal.normalize();
      float[] c = computeShadingColor(normal, i);
      colorList.set(i, c);
    }
  }
  // make wireframe (line) drawing if that is the current shading mode
  if (shade == Shading.WIREFRAME) {
    stroke (0, 0, 0);
    strokeWeight (2.0);
    // draw lines between your stored vertices (adjust to your data structures)
    line (verticesList[0][0], verticesList[0][1], verticesList[1][0], verticesList[1][1]);
    line (verticesList[0][0], verticesList[0][1], verticesList[2][0], verticesList[2][1]);
    line (verticesList[1][0], verticesList[1][1], verticesList[2][0], verticesList[2][1]);
    return;
  } else { 
    // this is where you should add your rasterization code from Project 3A
    float yStart = ceil(verticesList[0][1]);
    float yMid = ceil(verticesList[1][1]);
    float yEnd = ceil(verticesList[2][1]);
    for (float y = yStart; y < yMid; y++) {
      float z1 = verticesList[0][2] + (y - verticesList[0][1]) * (verticesList[1][2] - verticesList[0][2]) / (verticesList[1][1] - verticesList[0][1]);
      float z2 = verticesList[0][2] + (y - verticesList[0][1]) * (verticesList[2][2] - verticesList[0][2]) / (verticesList[2][1] - verticesList[0][1]);
      float x1 = verticesList[0][0] + (y - verticesList[0][1]) * (verticesList[1][0] - verticesList[0][0]) / (verticesList[1][1] - verticesList[0][1]);
      float x2 = verticesList[0][0] + (y - verticesList[0][1]) * (verticesList[2][0] - verticesList[0][0]) / (verticesList[2][1] - verticesList[0][1]);
      float r1 = colorList.get(0)[0] + (y - verticesList[0][1]) * (colorList.get(1)[0] - colorList.get(0)[0]) / (verticesList[1][1] - verticesList[0][1]);
      float g1 = colorList.get(0)[1] + (y - verticesList[0][1]) * (colorList.get(1)[1] - colorList.get(0)[1]) / (verticesList[1][1] - verticesList[0][1]);
      float b1 = colorList.get(0)[2] + (y - verticesList[0][1]) * (colorList.get(1)[2] - colorList.get(0)[2]) / (verticesList[1][1] - verticesList[0][1]);
      float r2 = colorList.get(0)[0] + (y - verticesList[0][1]) * (colorList.get(2)[0] - colorList.get(0)[0]) / (verticesList[2][1] - verticesList[0][1]);
      float g2 = colorList.get(0)[1] + (y - verticesList[0][1]) * (colorList.get(2)[1] - colorList.get(0)[1]) / (verticesList[2][1] - verticesList[0][1]);
      float b2 = colorList.get(0)[2] + (y - verticesList[0][1]) * (colorList.get(2)[2] - colorList.get(0)[2]) / (verticesList[2][1] - verticesList[0][1]);
      if(shade == Shading.PHONG){
        PVector normal0 = new PVector(normalList[0][0], normalList[0][1], normalList[0][2]);
        normal0.normalize();
        PVector normal1 = new PVector(normalList[1][0], normalList[1][1], normalList[1][2]);
        normal1.normalize();
        PVector normal2 = new PVector(normalList[2][0], normalList[2][1], normalList[2][2]);
        normal2.normalize();
        float t1 = (y - verticesList[0][1]) / (verticesList[1][1] - verticesList[0][1]);
        PVector n1 = new PVector(
          normal0.x + (normal1.x - normal0.x) * t1,
          normal0.y + (normal1.y - normal0.y) * t1,
          normal0.z + (normal1.z - normal0.z) * t1
        );
        n1.normalize();
        
        float t2 = (y - verticesList[0][1]) / (verticesList[2][1] - verticesList[0][1]);
        PVector n2 = new PVector(
          normal0.x + (normal2.x - normal0.x) * t2,
          normal0.y + (normal2.y - normal0.y) * t2,
          normal0.z + (normal2.z - normal0.z) * t2
        );
        n2.normalize();
        if (x1 < x2){
          drawScanlinePhong(x1, x2, y, z1, z2, n1, n2, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
        } else {
          drawScanlinePhong(x2, x1, y, z2, z1, n2, n1, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
        } 
      }else {
        if (x1 < x2){
          drawScanline(x1, x2, y, z1, z2, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
        } else {
          drawScanline(x2, x1, y, z2, z1, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
        }
      }
    }
    for (float y = yMid; y < yEnd; y++) {
      float z1 = verticesList[1][2] + (y - verticesList[1][1]) * (verticesList[2][2] - verticesList[1][2]) / (verticesList[2][1] - verticesList[1][1]);
      float z2 = verticesList[0][2] + (y - verticesList[0][1]) * (verticesList[2][2] - verticesList[0][2]) / (verticesList[2][1] - verticesList[0][1]);
      float x1 = verticesList[1][0] + (y - verticesList[1][1]) * (verticesList[2][0] - verticesList[1][0]) / (verticesList[2][1] - verticesList[1][1]);
      float x2 = verticesList[0][0] + (y - verticesList[0][1]) * (verticesList[2][0] - verticesList[0][0]) / (verticesList[2][1] - verticesList[0][1]);

      float r1 = colorList.get(1)[0] + (y - verticesList[1][1]) * (colorList.get(2)[0] - colorList.get(1)[0]) / (verticesList[2][1] - verticesList[1][1]);
      float g1 = colorList.get(1)[1] + (y - verticesList[1][1]) * (colorList.get(2)[1] - colorList.get(1)[1]) / (verticesList[2][1] - verticesList[1][1]);
      float b1 = colorList.get(1)[2] + (y - verticesList[1][1]) * (colorList.get(2)[2] - colorList.get(1)[2]) / (verticesList[2][1] - verticesList[1][1]);
      float r2 = colorList.get(0)[0] + (y - verticesList[0][1]) * (colorList.get(2)[0] - colorList.get(0)[0]) / (verticesList[2][1] - verticesList[0][1]);
      float g2 = colorList.get(0)[1] + (y - verticesList[0][1]) * (colorList.get(2)[1] - colorList.get(0)[1]) / (verticesList[2][1] - verticesList[0][1]);
      float b2 = colorList.get(0)[2] + (y - verticesList[0][1]) * (colorList.get(2)[2] - colorList.get(0)[2]) / (verticesList[2][1] - verticesList[0][1]);
      if(shade == Shading.PHONG){
        PVector normal0 = new PVector(normalList[0][0], normalList[0][1], normalList[0][2]);
        PVector normal1 = new PVector(normalList[1][0], normalList[1][1], normalList[1][2]);
        PVector normal2 = new PVector(normalList[2][0], normalList[2][1], normalList[2][2]);
        float t1 = (y - verticesList[1][1]) / (verticesList[2][1] - verticesList[1][1]);
        PVector n1 = new PVector(
          normal1.x + (normal2.x - normal1.x) * t1,
          normal1.y + (normal2.y - normal1.y) * t1,
          normal1.z + (normal2.z - normal1.z) * t1
        );
        n1.normalize();
        
        float t2 = (y - verticesList[0][1]) / (verticesList[2][1] - verticesList[0][1]);
        PVector n2 = new PVector(
          normal0.x + (normal2.x - normal0.x) * t2,
          normal0.y + (normal2.y - normal0.y) * t2,
          normal0.z + (normal2.z - normal0.z) * t2
        );
        n2.normalize();
        if (x1 < x2){
          drawScanlinePhong(x1, x2, y, z1, z2, n1, n2, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
        } else {
          drawScanlinePhong(x2, x1, y, z2, z1, n2, n1, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
        } 
      }else {
        if (x1 < x2){
          drawScanline(x1, x2, y, z1, z2, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
        } else {
          drawScanline(x2, x1, y, z2, z1, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
        }
      }
    }
    colorList.clear();
  }
}
void drawScanlinePhong(float xStart, float xEnd, float y, float zStart, float zEnd, PVector n1, PVector n2, color colorX1, color colorX2) {
    for (float x = ceil(xStart); x < xEnd; x++) {
        float cz = zStart + (x - xStart) * (zEnd - zStart) / (xEnd - xStart); // Interpolate Z value
        if (cz > zbuffer[int(x)][int(y)]) { // Check against Z-buffer
            float cr = red(colorX1) + (x - xStart) * (red(colorX2) - red(colorX1)) / (xEnd - xStart);
            float cg = green(colorX1) + (x - xStart) * (green(colorX2) - green(colorX1)) / (xEnd - xStart);
            float cb = blue(colorX1) + (x - xStart) * (blue(colorX2) - blue(colorX1)) / (xEnd - xStart);
            float[] c = new float[] {cr/255, cg/255, cb/255};
            colorList.add(c);
            float t = (x - xStart) / (xEnd - xStart);
            PVector nf = new PVector(
              n1.x + (n2.x - n1.x) * t,
              n1.y + (n2.y - n1.y) * t,
              n1.z + (n2.z - n1.z) * t
            );
            nf.normalize();
            float[] finalC = computeShadingColor(nf, colorList.size() - 1);
            set(int(x), int(height - y), color(finalC[0] * 255, finalC[1] * 255, finalC[2] * 255));
            zbuffer[int(x)][int(y)] = cz; // Update Z-buffer
        }
    }
}
void drawScanline(float xStart, float xEnd, float y, float zStart, float zEnd, color colorX1, color colorX2) {
    for (float x = ceil(xStart); x < xEnd; x++) {
        float cz = zStart + (x - xStart) * (zEnd - zStart) / (xEnd - xStart);
        if (cz > zbuffer[int(x)][int(y)]) {
            float cr = red(colorX1) + (x - xStart) * (red(colorX2) - red(colorX1)) / (xEnd - xStart);
            float cg = green(colorX1) + (x - xStart) * (green(colorX2) - green(colorX1)) / (xEnd - xStart);
            float cb = blue(colorX1) + (x - xStart) * (blue(colorX2) - blue(colorX1)) / (xEnd - xStart);
            set(int(x), int(height - y), color(cr, cg, cb));
            zbuffer[int(x)][int(y)] = cz;
        }
    }
}
float[] computeShadingColor(PVector normal, int vert) {
    PVector lightDirection = new PVector(light_x, light_y, light_z);
    lightDirection.normalize();
    float dotProduct = normal.dot(lightDirection);
    int a = ambientSpecularList.size() - 1;
    float ambientR = ambientSpecularList.get(a)[0];
    float ambientG = ambientSpecularList.get(a)[1];
    float ambientB = ambientSpecularList.get(a)[2];
    float diffuseR = max(dotProduct, 0) * light_r;
    float diffuseG = max(dotProduct, 0) * light_g;
    float diffuseB = max(dotProduct, 0) * light_b;
    PVector viewDirection = new PVector(0, 0, 1);  // Assuming viewer is along the z-axis
    PVector halfWay = PVector.add(lightDirection, viewDirection).div(2);
    halfWay.normalize();
    float specDot = max(halfWay.dot(normal), 0);
    float specularCoefficient = pow(specDot, ambientSpecularList.get(a)[6]);  // Using the shininess value from ambientSpecularList
    float specularR = specularCoefficient * ambientSpecularList.get(a)[3] * light_r;
    float specularG = specularCoefficient * ambientSpecularList.get(a)[4] * light_g;
    float specularB = specularCoefficient * ambientSpecularList.get(a)[5] * light_b;
    float finalR = (ambientR + diffuseR) * colorList.get(vert)[0] + specularR;
    float finalG = (ambientG + diffuseG) * colorList.get(vert)[1] + specularG;
    float finalB = (ambientB + diffuseB) * colorList.get(vert)[2] + specularB;

    return new float[]{min(finalR, 255), min(finalG, 255), min(finalB, 255)};
}

// set the current transformation matrix and its adjoint
void Set_Matrix (
float m00, float m01, float m02, float m03,
float m10, float m11, float m12, float m13,
float m20, float m21, float m22, float m23,
float m30, float m31, float m32, float m33)
{
  cmat.set (m00, m01, m02, m03, m10, m11, m12, m13,
            m20, m21, m22, m23, m30, m31, m32, m33);

  // calculate the adjoint of the transformation matrix
  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
}
