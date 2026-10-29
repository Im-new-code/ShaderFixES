#version 120
#define DL_SKY_TUNE // Gentle warm tint for the sun, strongest near the horizon.

uniform sampler2D gtexture;
uniform vec3 sunPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 dlTexCoord;
varying vec4 dlVertexColor;

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;

    #ifdef DL_SKY_TUNE
        vec2 screenUV = gl_FragCoord.xy / vec2(max(viewWidth, 1.0), max(viewHeight, 1.0));
        vec4 viewPoint = gbufferProjectionInverse * vec4(screenUV * 2.0 - 1.0, -0.50, 1.0);
        float safeW = abs(viewPoint.w) < 0.000001 ? (viewPoint.w < 0.0 ? -0.000001 : 0.000001) : viewPoint.w;
        vec3 worldRay = normalize(mat3(gbufferModelViewInverse) * (viewPoint.xyz / safeW));
        vec3 worldSun = normalize(mat3(gbufferModelViewInverse) * sunPosition);

        // Restrict the colour shift to the sun's direction. The moon lies on
        // the opposite side of the sky and remains close to its vanilla colour.
        float sunAlignment = dot(worldRay, worldSun);
        float sunDisk = smoothstep(0.993, 0.9995, sunAlignment);
        float lowSun = 1.0 - smoothstep(0.08, 0.60, abs(worldSun.y));
        vec3 neutralWarmth = vec3(1.0, 0.94, 0.84);
        vec3 horizonWarmth = vec3(1.0, 0.79, 0.57);
        vec3 warmTint = mix(neutralWarmth, horizonWarmth, lowSun * 0.75);
        color.rgb *= mix(vec3(1.0), warmTint, sunDisk * 0.90);
    #endif

    gl_FragColor = color;
}
