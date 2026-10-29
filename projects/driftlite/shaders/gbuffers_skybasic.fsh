#version 120
#define DL_SKY_TUNE // Slightly enrich the vanilla sky colour.
#define DL_SKY_HAZE // Gentle horizon haze based on the true world-space view ray.
#define DL_FLAT_CLOUDS // World-anchored Flat-style clouds.
#define DL_CLOUD_OPACITY 0.72 // [0.40 0.50 0.60 0.70 0.72 0.82 0.90 1.00]
#define DL_CLOUD_AMOUNT 0.48 // [0.25 0.32 0.40 0.48 0.56 0.64 0.72]
#define DL_CLOUD_SPEED 1.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5]

uniform sampler2D noisetex;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec4 dlVertexColor;

vec3 DL_GetWorldRay() {
    vec2 screenUV = gl_FragCoord.xy / vec2(max(viewWidth, 1.0), max(viewHeight, 1.0));
    vec4 viewPoint = gbufferProjectionInverse * vec4(screenUV * 2.0 - 1.0, -0.50, 1.0);
    float safeW = abs(viewPoint.w) < 0.000001 ? (viewPoint.w < 0.0 ? -0.000001 : 0.000001) : viewPoint.w;
    return normalize(mat3(gbufferModelViewInverse) * (viewPoint.xyz / safeW));
}

void main() {
    vec4 color = dlVertexColor;
    vec3 ray = DL_GetWorldRay();

    #ifdef DL_SKY_TUNE
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        color.rgb = mix(vec3(luminance), color.rgb, 1.05);
        color.rgb *= vec3(0.995, 1.0, 1.015);
    #endif

    #ifdef DL_SKY_HAZE
        float blueSky = clamp((color.b - color.r * 0.84) * 2.2, 0.0, 1.0);
        float horizonFactor = pow(clamp(1.0 - abs(ray.y), 0.0, 1.0), 3.0);
        float hazeAmount = horizonFactor * blueSky * 0.18;
        vec3 hazeColor = mix(skyColor, fogColor, 0.30);
        color.rgb = mix(color.rgb, hazeColor, hazeAmount);
    #endif

    #ifdef DL_FLAT_CLOUDS
        if (ray.y > 0.015) {
            /*
             * Intersect the view ray with a horizontal cloud plane. The cloud
             * coordinates are anchored to world XZ, so turning the camera does
             * not rotate a radial noise pattern around the centre of the screen.
             * A lower bound protects the horizon from huge texture derivatives;
             * the matching horizon fade hides the clamp before it becomes visible.
             */
            float planeDistance = 128.0 / max(ray.y, 0.10);
            vec2 cloudWorldPos = cameraPosition.xz + ray.xz * planeDistance;
            vec2 drift = vec2(frameTimeCounter * 0.0050,
                              frameTimeCounter * 0.0032) * DL_CLOUD_SPEED;
            vec2 cloudUV = cloudWorldPos / 1024.0 + drift;

            float baseNoise = texture2D(noisetex, cloudUV).r;
            float detailNoise = texture2D(noisetex, cloudUV * 3.15 - drift * 0.45).r;
            float cloudShape = baseNoise * 0.80 + detailNoise * 0.20;

            float amount = clamp(DL_CLOUD_AMOUNT + rainStrength * 0.10, 0.0, 0.90);
            float edge = 0.70 - amount * 0.35;
            float coverage = smoothstep(edge - 0.12, edge + 0.11, cloudShape);
            float horizonFade = smoothstep(0.045, 0.26, ray.y);
            float cloudAlpha = clamp(coverage * horizonFade * DL_CLOUD_OPACITY
                                     * mix(0.96, 1.08, rainStrength), 0.0, 0.84);

            vec3 sunDir = normalize(mat3(gbufferModelViewInverse) * sunPosition);
            float sunFacing = pow(max(dot(ray, sunDir), 0.0), 1.5);
            float cloudShade = clamp(0.54
                + smoothstep(0.35, 0.78, baseNoise) * 0.27
                + sunFacing * 0.19, 0.0, 1.0);
            vec3 cloudShadow = vec3(0.57, 0.63, 0.72);
            vec3 cloudLit = vec3(0.96, 0.975, 0.995);
            vec3 cloudColor = mix(cloudShadow, cloudLit, cloudShade);
            cloudColor = mix(cloudColor, fogColor, rainStrength * 0.42);
            color.rgb = mix(color.rgb, cloudColor, cloudAlpha);
        }
    #endif

    gl_FragColor = color;
}
