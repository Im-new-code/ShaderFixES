#version 120
#define DL_SKY_TUNE // Reduce the harsh white sun and give bright sky sprites a soft warm tint.

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

        float sunAlignment = dot(worldRay, worldSun);
        float directionalSun = smoothstep(0.955, 0.994, sunAlignment);

        // Some OptiFine/GLES combinations do not align the inverse sky matrices
        // exactly with the textured sun quad. Use a bright, near-white fallback
        // so the disk is still toned down rather than rendering as a blown-out tile.
        float brightest = max(color.r, max(color.g, color.b));
        float darkest = min(color.r, min(color.g, color.b));
        float brightWhite = smoothstep(0.62, 0.92, darkest)
                          * smoothstep(0.22, 0.62, brightest);
        float sunMask = max(directionalSun, brightWhite * 0.88);
        float lowSun = 1.0 - smoothstep(0.08, 0.60, abs(worldSun.y));
        vec3 neutralWarmth = vec3(1.0, 0.91, 0.78);
        vec3 horizonWarmth = vec3(1.0, 0.79, 0.58);
        vec3 warmTint = mix(neutralWarmth, horizonWarmth, lowSun * 0.75);
        vec3 softenedSun = color.rgb * warmTint * 0.84;
        color.rgb = mix(color.rgb, softenedSun, clamp(sunMask, 0.0, 1.0));
    #endif

    gl_FragColor = color;
}
