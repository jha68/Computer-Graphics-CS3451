// Dummy routines for drawing commands.
// These are for you to write.
float[][] vertexList = new float[3][3];
int vertexIndex = 0;
ArrayList<float[]> colorList = new ArrayList<float[]>();
void Set_Color(float r, float g, float b) {
  colorList.add(new float[] {r, g, b});
}
void Vertex(float x, float y, float z) {
  vertexList[vertexIndex][0] = x;
  vertexList[vertexIndex][1] = height - y;
  vertexList[vertexIndex][2] = z;
  vertexIndex++;
}
void Begin_Shape() {
  vertexIndex = 0;
}
void End_Shape() {
  while (colorList.size() < 3) {
    colorList.add(colorList.get(0));
  }
  for (int i = 0; i < 3; i++) {
    for (int j = i+1; j < 3; j++) {
      if (vertexList[j][1] < vertexList[i][1]) {
        float[] temp = vertexList[i];
        vertexList[i] = vertexList[j];
        vertexList[j] = temp;
        float[] rgb = colorList.get(i);
        colorList.set(i, colorList.get(j));
        colorList.set(j, rgb);
      }
    }
  }
  float yStart = ceil(vertexList[0][1]);
  float yMid = ceil(vertexList[1][1]);
  float yEnd = ceil(vertexList[2][1]);
  for (float y = yStart; y < yMid; y++) {
    float x1 = map(y, vertexList[0][1], vertexList[1][1], vertexList[0][0], vertexList[1][0]);
    float x2 = map(y, vertexList[0][1], vertexList[2][1], vertexList[0][0], vertexList[2][0]);
    float r1 = colorList.get(0)[0] + (y - vertexList[0][1]) * (colorList.get(2)[0] - colorList.get(0)[0]) / (vertexList[1][1] - vertexList[0][1]);
    float g1 = colorList.get(0)[1] + (y - vertexList[0][1]) * (colorList.get(2)[1] - colorList.get(0)[1]) / (vertexList[1][1] - vertexList[0][1]);
    float b1 = colorList.get(0)[2] + (y - vertexList[0][1]) * (colorList.get(2)[2] - colorList.get(0)[2]) / (vertexList[1][1] - vertexList[0][1]);
    float r2 = colorList.get(1)[0] + (y - vertexList[0][1]) * (colorList.get(2)[0] - colorList.get(1)[0]) / (vertexList[2][1] - vertexList[0][1]);
    float g2 = colorList.get(1)[1] + (y - vertexList[0][1]) * (colorList.get(2)[1] - colorList.get(1)[1]) / (vertexList[2][1] - vertexList[0][1]);
    float b2 = colorList.get(1)[2] + (y - vertexList[0][1]) * (colorList.get(2)[2] - colorList.get(1)[2]) / (vertexList[2][1] - vertexList[0][1]);
    if (x1 < x2){
      drawScanline(x1, x2, y, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
    } else {
      drawScanline(x2, x1, y, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
    }
  }
  for (float y = yMid; y < yEnd; y++) {
    float x1 = map(y, vertexList[1][1], vertexList[2][1], vertexList[1][0], vertexList[2][0]);
    float x2 = map(y, vertexList[0][1], vertexList[2][1], vertexList[0][0], vertexList[2][0]);
    float r1 = colorList.get(0)[0] + (y - vertexList[1][1]) * (colorList.get(2)[0] - colorList.get(0)[0]) / (vertexList[2][1] - vertexList[1][1]);
    float g1 = colorList.get(0)[1] + (y - vertexList[1][1]) * (colorList.get(2)[1] - colorList.get(0)[1]) / (vertexList[2][1] - vertexList[1][1]);
    float b1 = colorList.get(0)[2] + (y - vertexList[1][1]) * (colorList.get(2)[2] - colorList.get(0)[2]) / (vertexList[2][1] - vertexList[1][1]);
    float r2 = colorList.get(1)[0] + (y - vertexList[0][1]) * (colorList.get(2)[0] - colorList.get(1)[0]) / (vertexList[2][1] - vertexList[0][1]);
    float g2 = colorList.get(1)[1] + (y - vertexList[0][1]) * (colorList.get(2)[1] - colorList.get(1)[1]) / (vertexList[2][1] - vertexList[0][1]);
    float b2 = colorList.get(1)[2] + (y - vertexList[0][1]) * (colorList.get(2)[2] - colorList.get(1)[2]) / (vertexList[2][1] - vertexList[0][1]);
    if (x1 < x2){
      drawScanline(x1, x2, y, color(r2 * 255, g2 * 255, b2 * 255), color(r1 * 255, g1 * 255, b1 * 255));
    } else {
      drawScanline(x2, x1, y, color(r1 * 255, g1 * 255, b1 * 255), color(r2 * 255, g2 * 255, b2 * 255));
    }
  }
  colorList.clear();
}
void drawScanline(float xStart, float xEnd, float y, color colorX1, color colorX2) {
  for (float x = ceil(xStart); x < xEnd; x++) {
    float cr = red(colorX1) + (x - xStart) * (red(colorX2) - red(colorX1)) / (xEnd - xStart);
    float cg = green(colorX1) + (x - xStart) * (green(colorX2) - green(colorX1)) / (xEnd - xStart);
    float cb = blue(colorX1) + (x - xStart) * (blue(colorX2) - blue(colorX1)) / (xEnd - xStart);
    set(int(x), int(y), color(cr, cg, cb));
  }
}
