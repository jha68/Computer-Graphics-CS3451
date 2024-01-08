// Fragment shader
// The fragment shader is run once for every pixel
// It can change the color and transparency of the fragment.

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D my_texture;
uniform float cx;
uniform float cy;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

float grayscale(vec3 color) {
    return (color.r + color.g + color.b) / 3.0;
}

void main() {
    vec2 texCoord = vertTexCoord.xy;
    vec2 texsize = textureSize(my_texture, 0);
    float dx = 1.0/texsize.x;
    float dy = 1.0/texsize.y;

    float v_center = grayscale(texture2D(my_texture, texCoord).rgb);
    float v00 = grayscale(texture2D(my_texture, vec2(vertTexCoord.x, vertTexCoord.y + dy)).rgb);
    float v01 = grayscale(texture2D(my_texture, vec2(vertTexCoord.x, vertTexCoord.y - dy)).rgb);
    float v10 = grayscale(texture2D(my_texture, vec2(vertTexCoord.x + dx, vertTexCoord.y)).rgb);
    float v11 = grayscale(texture2D(my_texture, vec2(vertTexCoord.x - dx, vertTexCoord.y)).rgb);

    float laplacian = 0.25 * (v00 + v01 + v10 + v11) - v_center;
    float edgeStrength = clamp(laplacian * 25.0 + 0.5, 0.0, 1.0);
    float distToCenter = distance(vertTexCoord.xy, vec2(cx, cy));

    if (distToCenter < 0.2) {
        gl_FragColor = vec4(vec3(edgeStrength), 1.0);
    } else {
        gl_FragColor = texture2D(my_texture, vertTexCoord.xy);
    }
}
