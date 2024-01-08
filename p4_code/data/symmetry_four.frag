// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

const int maxIterations = 20;
const float escapeRadius = 20.0 * 20.0;

void main() {
    vec2 z = (vertTexCoord.xy * 2.5) - vec2(1.25, 1.25);
    vec2 c = vec2(cx, cy);

    int i;
    for (i = 0; i < maxIterations; i++) {
        if (dot(z, z) > escapeRadius) {
            break;
        }

        float x = z.x * z.x - z.y * z.y;
        float y = 2.0 * z.x * z.y;
        float x2 = x * x - y * y;
        float y2 = 2.0 * x * y;

        z.x = x2 + c.x;
        z.y = y2 + c.y;
    }

    if (i == maxIterations) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    } else {
        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
}

