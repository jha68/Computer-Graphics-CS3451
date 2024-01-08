  // called just once at the start of program execution
void setup()
{
  size (800, 800); // set width and height of screen (in pixels)
}
  // called repeatedly, usually used to draw on screen
void draw() {
  background (255, 255, 255); // set background color to white
  noStroke(); // don't draw shape outlines
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  float baseRadius = width / 4.0;
  float shrink = map(mouseY, height, 0, 0, 0.5);
  float shift = map(mouseX, 0, width, 0, 1);
  drawPentagon(centerX, centerY, baseRadius, 5, shrink, shift);
}

void drawPentagon(float x, float y, float r, int level, float shrink, float shift) {
  if (level == 0) {
    return;
  }
  fill(level * 40, level * 50, level * 60);
  beginShape();
  float[][] vertices = new float[5][2];
  float angleOff = -PI / 10;
  if (level % 2 == 0) {
    angleOff = PI / 10;
  }
  for (int i = 0; i < 5; i++) {
    float angle = angleOff + 2 * PI / 5 * i;
    float x_vertex = x + r * cos(angle);
    float y_vertex = y + r * sin(angle);
    vertex(x_vertex, y_vertex);
    vertices[i][0] = x_vertex;
    vertices[i][1] = y_vertex;
  }
  endShape(CLOSE);
  for (int i = 0; i < 5; i++) {
    float x1 = vertices[i][0], y1 = vertices[i][1];
    float x2 = vertices[(i + 1) % 5][0], y2 = vertices[(i + 1) % 5][1];
    float midX = (x1 + x2) / 2;
    float midY = (y1 + y2) / 2;
    float newR = r * shrink;
    float d = r * (1 + shift);
    float angle;
    if (midX - x != 0) {
      angle = atan((midY - y) / (midX - x));
    } else {
      if (midY - y > 0) {
        angle = PI / 2;
      } else {
        angle = -PI / 2;
      }
    }
    if (midX - x < 0) {
      angle += PI;
    }
    float newX = x + d * cos(angle);
    float newY = y + d * sin(angle);
    drawPentagon(newX, newY, newR, level - 1, shrink, shift);
  }
}
