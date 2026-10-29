#version 120
/*
 * Adapted from the uploaded World Outline Shader r1.0 (MIT-licensed).
 * Output scene color plus outlines to colortex3. colortex1 is OptiFine's
 * depth-color attachment, so it must not be used as a scene-color buffer.
 */
#define WORLD_OUTLINE 1 // [0 1]
#define WORLD_OUTLINE_THICKNESS 2.0 // [1.0 2.0 3.0]
#define WORLD_OUTLINE_I 1.5 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.5 3.0 4.0]
#define WORLD_OUTLINE_DISTANCE_FADE 128.0 // [16.0 32.0 64.0 96.0 128.0 192.0 256.0 512.0 1024.0]
#define WORLD_OUTLINE_MIN_DISTANCE 0.5 // [0.0 0.25 0.5 0.75 1.0 1.5 2.0]
#define WORLD_OUTLINE_THRESHOLD 3.0 // [1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0]
#define DL_CHUNK_FOG 0 // [0 1]
#define DL_CHUNK_FOG_STRENGTH 0.75 // [0.25 0.5 0.75 1.0]

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform float renderDistance;
uniform vec3 fogColor;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

varying vec2 texcoord;

float GetLinearDepth(float depth) {
    return (2.0 * near) / max(far + near - depth * (far - near), 0.000001);
}

vec3 ReconstructViewPos(vec2 uv, float depth) {
    vec4 ndc = vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 view = gbufferProjectionInverse * ndc;
    float safeW = abs(view.w) < 0.000001 ? (view.w < 0.0 ? -0.000001 : 0.000001) : view.w;
    return view.xyz / safeW;
}

/* DRAWBUFFERS:3 */
void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    float z0 = texture2D(depthtex0, texcoord).r;

    // A far-plane sample can have homogeneous w=0. Use finite depth for the
    // world ray, otherwise a broken reconstruction can spoil horizon colour.
    if (z0 >= 0.999999) {
        vec3 viewPosSky = ReconstructViewPos(texcoord, 0.9999);
        vec3 worldDir = normalize(mat3(gbufferModelViewInverse) * viewPosSky);
        float horizonFactor = 1.0 - clamp(abs(worldDir.y), 0.0, 1.0);
        horizonFactor = horizonFactor * horizonFactor * horizonFactor;
        vec3 fCol = fogColor;
        if (dot(fCol, vec3(1.0)) < 0.01) fCol = vec3(0.62, 0.76, 0.94);
        color = mix(color, fCol, horizonFactor * 0.20);
        gl_FragData[0] = vec4(color, 1.0);
        return;
    }

    vec3 viewPos = ReconstructViewPos(texcoord, z0);
    float worldDist = length(viewPos);
    float z1 = texture2D(depthtex1, texcoord).r;
    vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;
    bool isCloud = (z1 >= 0.9999) && (worldPos.y > 75.0);
    float linearZ0 = GetLinearDepth(z0);

#if WORLD_OUTLINE
    if (worldDist >= WORLD_OUTLINE_MIN_DISTANCE) {
        vec2 resolution = vec2(max(viewWidth, 1.0), max(viewHeight, 1.0));
        vec2 scale = 1.0 / resolution;
        vec2 texCoordDirection = sign(texcoord - vec2(0.5));
        vec2 checkCoord = texcoord + scale * vec2(
            texCoordDirection.x * WORLD_OUTLINE_THICKNESS,
            texCoordDirection.y * WORLD_OUTLINE_THICKNESS
        );
        vec2 absCheckCoord = abs(checkCoord - vec2(0.5));
        float outlineMult = max(0.0, 0.5 - max(absCheckCoord.x, absCheckCoord.y));
        outlineMult = min(1.0, outlineMult * 0.1 / (scale.x * WORLD_OUTLINE_THICKNESS));

        float fadeOutline = isCloud ? 1.0 :
            1.0 - smoothstep(WORLD_OUTLINE_DISTANCE_FADE * 0.7,
                             WORLD_OUTLINE_DISTANCE_FADE, worldDist);
        outlineMult *= fadeOutline;

        if (outlineMult > 0.0001) {
            outlineMult *= 0.25;
            vec2 o = scale * WORLD_OUTLINE_THICKNESS;
            float r0 = 1.0 / GetLinearDepth(texture2D(depthtex0, texcoord + vec2(-o.x, -o.y)).r);
            float r1 = 1.0 / GetLinearDepth(texture2D(depthtex0, texcoord + vec2(-o.x,  o.y)).r);
            float r2 = 1.0 / GetLinearDepth(texture2D(depthtex0, texcoord + vec2( o.x, -o.y)).r);
            float r3 = 1.0 / GetLinearDepth(texture2D(depthtex0, texcoord + vec2( o.x,  o.y)).r);
            float rA = 0.25 * (r0 + r1 + r2 + r3);

            float slope = (1.0 / linearZ0 - rA) * (linearZ0 * linearZ0);
            float threshold = linearZ0 / 2000.0 * WORLD_OUTLINE_THICKNESS * WORLD_OUTLINE_THRESHOLD / 3.0;
            float rawOutline = clamp(slope / max(threshold, 0.000001), 0.0, 1.0);
            rawOutline = smoothstep(0.35, 0.65, rawOutline);

            float outline = rawOutline * WORLD_OUTLINE_I * outlineMult;
            float strength = isCloud ? 0.22 : 1.0;
            color += min(color * outline * strength, vec3(outline * strength));
        }
    }
#endif

#if DL_CHUNK_FOG
    if (!isCloud) {
        float refDist = renderDistance > 1.0 ? renderDistance * 16.0 : far;
        refDist = clamp(refDist, 32.0, 1024.0);
        float fogFactor = smoothstep(refDist * 0.55, refDist * 0.95, worldDist) * DL_CHUNK_FOG_STRENGTH;
        vec3 fCol = fogColor;
        if (dot(fCol, vec3(1.0)) < 0.01) fCol = vec3(0.62, 0.76, 0.94);
        color = mix(color, fCol, fogFactor);
    }
#endif

    gl_FragData[0] = vec4(color, 1.0);
}
