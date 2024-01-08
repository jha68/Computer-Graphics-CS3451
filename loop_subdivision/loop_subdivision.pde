// Sample code for starting the subdivision project
import java.util.Arrays;
// parameters used for object rotation by mouse
float mouseX_old = 0;
float mouseY_old = 0;
PMatrix3D rot_mat = new PMatrix3D();
boolean flag, gouraud;
int currentCorner = 0;
Mesh mesh;
// initialize stuff
void setup() {
  size (800, 800, OPENGL);
}

// Draw the scene
void draw() {
  
  background (170, 170, 255);
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
    
  // create an ambient light source
  ambientLight (52, 52, 52);
  
  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);
  
  pushMatrix();
  
  applyMatrix (rot_mat);  // rotate object using the global rotation matrix
  
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  if (!gouraud) {
    stroke (0, 0, 0);
  } else {
    noStroke();
  }
  fill(200, 200, 200);

  // THIS IS WHERE YOU SHOULD DRAW THE MESH
/*
  beginShape();
  normal (0.0, 0.0, 1.0);
  vertex (-1.0, -1.0, 0.0);
  vertex ( 1.0, -1.0, 0.0);
  vertex ( 1.0,  1.0, 0.0);
  vertex (-1.0,  1.0, 0.0);
  endShape(CLOSE);
*/
  if (!flag) {
    beginShape();
    normal(0.0, 0.0, 1.0);
    vertex(-1.0, -1.0, 0.0);
    vertex( 1.0, -1.0, 0.0);
    vertex( 1.0,  1.0, 0.0);
    vertex(-1.0,  1.0, 0.0);
    endShape(CLOSE);
  } else {
    // Draw each face
    for (int i = 0; i < mesh.vertexTable.size(); i += 3) {
      beginShape();
      fill(200, 200, 200);
      if (gouraud) {
        for (int j = 0; j < 3; j++ ) {
          Vertex vertexNormal = mesh.vertexNormalList[mesh.vertexTable.get(i + j)];
          normal(vertexNormal.x, vertexNormal.y, vertexNormal.z);
          Vertex vert = mesh.geometryTable.get(mesh.vertexTable.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      } else {
        Vertex faceNormal = mesh.faceNormalList.get(i / 3);
        normal(faceNormal.x, faceNormal.y, faceNormal.z);

        for (int j = 0; j < 3; j++) {
          Vertex vert = mesh.geometryTable.get(mesh.vertexTable.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      }
      
      endShape(CLOSE);
    }
  }
  if (flag) {
    Vertex currentVertex = mesh.geometryTable.get(mesh.vertexTable.get(currentCorner));
    Vertex nextVertex = mesh.geometryTable.get(mesh.vertexTable.get(next(currentCorner)));
    Vertex prevVertex = mesh.geometryTable.get(mesh.vertexTable.get(prev(currentCorner)));
    float offsetFactor = 0.1;
    Vertex offset = new Vertex(
        currentVertex.x + (nextVertex.x - currentVertex.x) * offsetFactor + (prevVertex.x - currentVertex.x) * offsetFactor,
        currentVertex.y + (nextVertex.y - currentVertex.y) * offsetFactor + (prevVertex.y - currentVertex.y) * offsetFactor,
        currentVertex.z + (nextVertex.z - currentVertex.z) * offsetFactor + (prevVertex.z - currentVertex.z) * offsetFactor
    );
    translate(offset.x, offset.y, offset.z);
    sphere(0.025);
  }
  popMatrix();
}

// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply", 1.5);
    flag = true;
    currentCorner = 0;
  }
  else if (key == '2') {
    read_mesh ("octa.ply", 2.5);
    flag = true;
    currentCorner = 0;
  }
  else if (key == '3') {
    read_mesh ("icos.ply", 2.5);
    flag = true;
    currentCorner = 0;
  }
  else if (key == '4') {
    read_mesh ("star.ply", 1.0);
    flag = true;
    currentCorner = 0;
  }
  else if (key == '5') {
    read_mesh ("torus.ply", 1.6);
    flag = true;
    currentCorner = 0;
  }
  else if (key == 'n') {
    // next corner operation
    currentCorner = next(currentCorner);
  }
  else if (key == 'p') {
    // previous corner operation
    currentCorner = prev(currentCorner);
  }
  else if (key == 'o') {
    // opposite corner operation
    currentCorner = mesh.oppositeTable[currentCorner];
  }
  else if (key == 's') {
    // swing corner operation
    currentCorner = mesh.swing(currentCorner);
  }
  else if (key == 'f') {
    // flat shading, with black edges
    gouraud = false;
  }
  else if (key == 'g') {
    // Gouraud shading with per-vertex normals
    gouraud = true;
  }
  else if (key == 'd') {
    // subdivide mesh
    mesh = subdivide(mesh);
  }
  else if (key == 'q') {
    // quit program
    exit();
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename, float scale_value)
{
  String[] words;

  String lines[] = loadStrings(filename);

  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);

  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);
  mesh = new Mesh(num_vertices, num_faces);
  // read in the vertices
  for (int i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]) * scale_value;
    float y = float(words[1]) * scale_value;
    float z = float(words[2]) * scale_value;
    println ("vertex = " + x + " " + y + " " + z);
    mesh.geometryTable.add(new Vertex(float(words[0]), float(words[1]), float(words[2])));
  }

  // read in the faces
  for (int i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);
    println ("face = " + index1 + " " + index2 + " " + index3);
    mesh.vertexTable.add(index1);
    mesh.vertexTable.add(index2);
    mesh.vertexTable.add(index3);
  }
  mesh.constructMesh();
}
class Mesh {
  ArrayList<Integer> vertexTable;
  ArrayList<Vertex> geometryTable;
  int[] oppositeTable;
  Vertex[] vertexNormalList;
  ArrayList<Vertex> faceNormalList;
  int vertexCount;
  int faceCount;

  Mesh(int numOfVertex, int numOfFace) {
    vertexTable = new ArrayList<Integer>();
    geometryTable = new ArrayList<Vertex>();
    oppositeTable = new int[3 * numOfFace];
    vertexNormalList = new Vertex[numOfVertex];
    faceNormalList = new ArrayList<Vertex>();
    vertexCount = numOfVertex;
    faceCount = numOfFace;
  }
  
  int swing(int corner) {
    return next(oppositeTable[next(corner)]);
  }
  
  void constructMesh() {
    //construct opposite table
    for (int i = 0; i < vertexTable.size(); i++) {
      for (int j = 0; j < vertexTable.size(); j++) {
        if (vertexTable.get(next(i)).equals(vertexTable.get(prev(j))) && vertexTable.get(prev(i)).equals(vertexTable.get(next(j)))) {
          oppositeTable[i] = j;
          oppositeTable[j] = i;
        }
      }
    }
    //find face normals
    for (int i = 0; i < vertexTable.size(); i += 3) {
      Vertex v1 = geometryTable.get(vertexTable.get(i));
      Vertex v2 = geometryTable.get(vertexTable.get(i + 1));
      Vertex v3 = geometryTable.get(vertexTable.get(i + 2));
      Vertex faceNormal = v2.sub(v1).cross(v3.sub(v2)).norm();
      faceNormalList.add(faceNormal);
    }
    //find vertex normals
    boolean[] hasPassed = new boolean[geometryTable.size()];
    for (int i = 0; i < vertexTable.size(); i++) {
      if (!hasPassed[vertexTable.get(i)]) {
        Vertex vertexNormal = faceNormalList.get(i / 3);
        int swing = swing(i);
        while(swing != i) {
          vertexNormal = vertexNormal.add(faceNormalList.get(swing / 3));
          swing = swing(swing);
        }
        vertexNormalList[vertexTable.get(i)] = vertexNormal.norm();
        hasPassed[vertexTable.get(i)] = true;
      }
    }
  }
}
void edgeProcesser(Mesh mesh, ArrayList<Integer> vertexTable, ArrayList<Vertex> geometryTable) {
  ArrayList<int[]> edgeList = new ArrayList<int[]>();
  int[] idxList = new int[3];
  int idx1 = 0;
  int idx2 = 0;
  
  for (int i = 0; i < mesh.vertexTable.size(); i++) {
    int currentCorner = mesh.vertexTable.get(i);
    int nextCorner = mesh.vertexTable.get(next(i));
    int prevCorner = mesh.vertexTable.get(prev(i));

    int[] e1 = {currentCorner, nextCorner};
    Arrays.sort(e1);

    int[] e2 = {currentCorner, prevCorner};
    Arrays.sort(e2);

    boolean e1checker = false;
    boolean e2checker = false;
    
    for (int j = 0; j < edgeList.size(); j++) {
      if (edgeList.get(j)[0] == e1[0] && edgeList.get(j)[1] == e1[1]) {
        e1checker = true;
      }
      if (edgeList.get(j)[0] == e2[0] && edgeList.get(j)[1] == e2[1]) {
        e2checker = true;
      }
    }

    Vertex leftVert = mesh.geometryTable.get(prevCorner);
    Vertex rightVert = mesh.geometryTable.get(mesh.vertexTable.get(mesh.oppositeTable[prev(i)]));
    Vertex newVertex = mesh.geometryTable.get(currentCorner).add(mesh.geometryTable.get(nextCorner)).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));

    if (e1checker) {
      for (int j = 0; j < geometryTable.size(); j++) {
        if (geometryTable.get(j).equals(newVertex)) {
          idx1 = j;
          break;
        }
      }
    } else {
      edgeList.add(e1);
      idx1 = geometryTable.size();
      geometryTable.add(newVertex);
    }
    
    leftVert = mesh.geometryTable.get(nextCorner);
    rightVert = mesh.geometryTable.get(mesh.vertexTable.get(mesh.oppositeTable[next(i)]));
    newVertex = mesh.geometryTable.get(currentCorner).add(mesh.geometryTable.get(prevCorner)).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));
    
    if (e2checker){
      for (int j = 0; j < geometryTable.size(); j++) {
        if (geometryTable.get(j).equals(newVertex)) {
          idx2 = j;
          break;
        }
      }
    } else {      
      edgeList.add(e2);
      idx2 = geometryTable.size();
      geometryTable.add(newVertex);
    }
    vertexTable.add(currentCorner);
    vertexTable.add(idx1);
    vertexTable.add(idx2);
    if(i % 3 == 0) {
      idxList[0] = idx1;
    } else if (i % 3 == 1) {
      idxList[1] = idx1;
    } else {
      vertexTable.add(idxList[0]);
      vertexTable.add(idxList[1]);
      vertexTable.add(idx1);
    }
  }
}
Mesh subdivide(Mesh currentMesh) {
    ArrayList<Integer> newVertexTable = new ArrayList<Integer>();
    ArrayList<Vertex> newGeometryTable = new ArrayList<Vertex>();
    boolean[] hasPassed = new boolean[currentMesh.geometryTable.size()];

    for (int i = 0; i < currentMesh.geometryTable.size(); i++) {
        ArrayList<Integer> newVertices = new ArrayList<Integer>();

        if (!hasPassed[i]) {
            for (int j = 0; j < currentMesh.vertexTable.size(); j++) {
                if (currentMesh.vertexTable.get(j) == i) {
                    newVertices.add(currentMesh.vertexTable.get(next(j)));
                    int swing = currentMesh.swing(j);
                    while (swing != j) {
                        newVertices.add(currentMesh.vertexTable.get(next(swing)));
                        swing = currentMesh.swing(swing);
                    }
                }
            }
            hasPassed[i] = true;
        }

        Vertex vertexSum = new Vertex(0.0, 0.0, 0.0);
        for (int vertexIndex : newVertices) {
            vertexSum = vertexSum.add(currentMesh.geometryTable.get(vertexIndex));
        }

        float scaler;
        if (newVertices.size() == 3) {
            scaler = 3.0 / 16.0;
        } else {
            scaler = 3.0 / (8.0 * newVertices.size());
        }

        newGeometryTable.add(currentMesh.geometryTable.get(i).mult(1 - newVertices.size() * scaler).add(vertexSum.mult(scaler)));
    }

    edgeProcesser(currentMesh, newVertexTable, newGeometryTable);

    Mesh newMesh = new Mesh(newGeometryTable.size(), newVertexTable.size() / 3);
    newMesh.vertexTable = newVertexTable;
    newMesh.geometryTable = newGeometryTable;
    newMesh.constructMesh();

    return newMesh;
}

class Vertex {
  float x, y, z;

  Vertex(float x, float y, float z) {
    this.x = x; this.y = y; this.z = z;
  }
  Vertex mult(float scale) {
    return new Vertex(x * scale, y * scale, z * scale);
  }
  Vertex add(Vertex other) {
    return new Vertex(this.x + other.x, this.y + other.y, this.z + other.z);
  }
  Vertex cross(Vertex other) {
    return new Vertex(this.y * other.z - this.z * other.y, this.z * other.x - this.x * other.z, this.x * other.y - this.y * other.x);
  }
  Vertex sub(Vertex other) {
    return new Vertex(this.x - other.x, this.y - other.y, this.z - other.z);
  }
  Vertex norm() {
    return new Vertex(x / sqrt(x * x + y * y + z * z), y / sqrt(x * x + y * y + z * z), z / sqrt(x * x + y * y + z * z));
  }
  boolean equals(Vertex other) {
    return this.x == other.x && this.y == other.y && this.z == other.z;
  }
}

int next(int corner) {
  return corner / 3 * 3 + (corner + 1) % 3;
}

int prev(int corner) {
  return next(next(corner));
}
// remember currentMesh mouse position
void mousePressed()
{
  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

// modify rotation matrix when mouse is dragged
void mouseDragged()
{
  if (!mousePressed)
    return;
  
  float dx = mouseX - mouseX_old;
  float dy = mouseY - mouseY_old;
  dy *= -1;

  float len = sqrt (dx*dx + dy*dy);
  if (len == 0)
      len = 1;
  
  dx /= len;
  dy /= len;
  PMatrix3D rmat = new PMatrix3D();
  rmat.rotate (len * 0.005, dy, dx, 0);
  rot_mat.preApply (rmat);

  mouseX_old = mouseX;
  mouseY_old = mouseY;
}
