// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

const int numSpokes = 6;
const int numCirclesPerSpoke = 3;
const float centralCircleRadius = 0.05;

bool inCircle(vec2 point, vec2 center, float radius) {
  return length(point - center) < radius;
}

void main() {
  vec2 center = vec2(0.5, 0.5);
  float distanceToCenter = distance(vertTexCoord.xy, center);

  bool isInCircle = inCircle(vertTexCoord.xy, center, centralCircleRadius);

  for (int i = 0; i < numSpokes; i++) {
    float angle = 2.0 * 3.14159 * float(i) / float(numSpokes);
    for (int j = 1; j <= numCirclesPerSpoke; j++) {
      float radius = centralCircleRadius - float(j)*0.01 ;
      vec2 circleCenter = center + 0.13*vec2(cos(angle), sin(angle)) * float(j);
      if (inCircle(vertTexCoord.xy, circleCenter, radius)) {
        isInCircle = true;
      }
    }
  }

  vec4 diffuse_color = vec4 (0.0, 1.0, 1.0, 1.0);
  float diffuse = clamp(dot(vertNormal, vertLightDir), 0.0, 1.0);
  gl_FragColor = vec4(diffuse * diffuse_color.rgb, 0.8);

  if (isInCircle) {
    gl_FragColor.a = 0.0;
  } else {
    gl_FragColor.a = 1.0;
  }
}
