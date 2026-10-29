#version 120
#define DL_SKY_TUNE // Slightly enrich the vanilla sky colour.
#define DL_SKY_HAZE // Smooth atmospheric transition at the horizon.
#define DL_FLAT_CLOUDS // Stable angular cloud mapping that avoids horizon streaks.
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
        color.rgb = mix(vec3(luminance), color.rgb, 1.035);
        color.rgb *= vec3(0.995, 1.0, 1.012);
    #endif

    #ifdef DL_SKY_HAZE
        // Blend more strongly near the horizon, with a smooth vertical
        // transition instead of leaving a hard, pale-blue horizontal band.
        float height = max(ray.y, 0.0);
        float horizonFactor = 1.0 - smoothstep(0.015, 0.52, height);
        float blueSky = clamp((color.b - color.r * 0.84) * 2.2, 0.0, 1.0);
        vec3 hazeColor = mix(skyColor, fogColor, 0.56);
        float hazeAmount = horizonFactor * (0.18 + 0.24 * blueSky);
        color.rgb = mix(color.rgb, hazeColor, clamp(hazeAmount, 0.0, 0.46));
    #endif

    #ifdef DL_FLAT_CLOUDS
        if (ray.y > 0.015) {
            /*
             * Sample cloud noise in angular world-ray coordinates rather than
             * intersecting an infinite plane. Plane projection created large
             * derivatives near the horizon that appeared as long radial streaks
             * on mobile texture filtering. Longitude repeats cleanly at the seam.
             */
            float longitude = atan(ray.x, ray.z) * 0.1591549431 + 0.5;
            float latitude = asin(clamp(ray.y, -1.0, 1.0)) * 0.3183098862 + 0.5;
            vec2 cloudUV = vec2(longitude * 2.35, latitude * 3.40);

            vec2 drift = vec2(frameTimeCounter * 0.0040,
                              frameTimeCounter * 0.00125) * DL_CLOUD_SPEED;
            float warp = texture2D(noisetex, cloudUV * 0.65 + drift * 0.45).r;
            vec2 warpedUV = cloudUV + vec2(warp - 0.5, (warp - 0.5) * 0.34);
            float baseNoise = texture2D(noisetex, warpedUV + drift).r;
            float detailNoise = texture2D(noisetex, warpedUV * 2.65 - drift * 0.55).r;
            float cloudShape = baseNoise * 0.78 + detailNoise * 0.22;

            float amount = clamp(DL_CLOUD_AMOUNT + rainStrength * 0.10, 0.0, 0.90);
            float edge = 0.66 - amount * 0.28;
            float coverage = smoothstep(edge - 0.105, edge + 0.105, cloudShape);
            float horizonFade = smoothstep(0.035, 0.19, ray.y);
            float cloudAlpha = clamp(coverage * horizonFade * DL_CLOUD_OPACITY
                                     * mix(0.96, 1.08, rainStrength), 0.0, 0.82);

            vec3 sunDir = normalize(mat3(gbufferModelViewInverse) * sunPosition);
            float sunFacing = pow(max(dot(ray, sunDir), 0.0), 1.5);
            float cloudShade = clamp(0.48
                + smoothstep(0.32, 0.80, baseNoise) * 0.28
                + sunFacing * 0.24, 0.0, 1.0);
            vec3 cloudShadow = vec3(0.58, 0.65, 0.74);
            vec3 cloudLit = vec3(0.95, 0.975, 1.0);
            vec3 cloudColor = mix(cloudShadow, cloudLit, cloudShade);
            cloudColor = mix(cloudColor, fogColor, rainStrength * 0.45);
            color.rgb = mix(color.rgb, cloudColor, cloudAlpha);
        }
    #endif

    gl_FragColor = color;
}
