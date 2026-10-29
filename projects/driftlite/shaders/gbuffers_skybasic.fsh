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
uniform float viewWidth;
uniform float viewHeight;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec4 dlVertexColor;

vec3 DL_GetWorldRay() {
    vec2 screenUV = gl_FragCoord.xy / vec2(max(viewWidth, 1.0), max(viewHeight, 1.0));
    // Reconstruct a finite point on the view ray, then remove camera rotation.
    vec4 viewPoint = gbufferProjectionInverse * vec4(screenUV * 2.0 - 1.0, -0.85, 1.0);
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
        if (ray.y > 0.005) {
            // Direction-to-plane projection with a bounded denominator.
            // Sampling a reconstructed per-pixel world ray avoids the broad
            // view-interpolated radial streaks seen in the previous build.
            float horizontal = length(ray.xz);
            float denominator = max(ray.y + horizontal / 6.0, 0.08);
            vec2 cloudPos = ray.xz / denominator;
            cloudPos += cameraPosition.xz / 512.0;
            cloudPos += vec2(frameTimeCounter * 0.010, frameTimeCounter * 0.006) * DL_CLOUD_SPEED;
            cloudPos *= 32.0;

            float baseNoise = texture2D(noisetex, cloudPos / 255.0).r;
            float detailNoise = texture2D(noisetex, cloudPos / 51.0).r;
            float noiseValue = max(baseNoise - detailNoise * 0.08, 0.0);
            float amount = DL_CLOUD_AMOUNT + rainStrength * 0.18;
            float formation = smoothstep(0.0, 0.40, noiseValue - 0.60 + amount);
            float density = noiseValue * formation * smoothstep(0.0, 0.20, ray.y);
            float cloudAlpha = clamp(1.0 - exp(-density * 1.35 * DL_CLOUD_OPACITY), 0.0, 0.82);

            vec3 cloudShadow = vec3(0.58, 0.64, 0.73);
            vec3 cloudLit = vec3(0.94, 0.965, 0.99);
            vec3 cloudColor = mix(cloudShadow, cloudLit, smoothstep(0.24, 0.72, baseNoise));
            cloudColor = mix(cloudColor, fogColor, rainStrength * 0.40);
            color.rgb = mix(color.rgb, cloudColor, cloudAlpha);
        }
    #endif

    gl_FragColor = color;
}
