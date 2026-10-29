#version 120
#define DL_SKY_TUNE // Slightly enrich the vanilla sky colour.
#define DL_SKY_HAZE // Blend blue sky into a soft vanilla-coloured horizon haze.
#define DL_FLAT_CLOUDS // Lightweight, world-anchored Mellow-style Flat clouds.
#define DL_CLOUD_OPACITY 0.82 // [0.40 0.50 0.60 0.70 0.82 0.90 1.00]
#define DL_CLOUD_AMOUNT 0.48 // [0.25 0.32 0.40 0.48 0.56 0.64 0.72]
#define DL_CLOUD_SPEED 1.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5]

uniform sampler2D noisetex;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform mat4 gbufferModelViewInverse;

varying vec4 dlVertexColor;
varying vec3 dlWorldDirection;

void main() {
    vec4 color = dlVertexColor;
    vec3 ray = normalize(dlWorldDirection);

    #ifdef DL_SKY_TUNE
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        color.rgb = mix(vec3(luminance), color.rgb, 1.08);
        color.rgb *= vec3(0.99, 1.00, 1.025);
    #endif

    #ifdef DL_SKY_HAZE
        float blueSky = clamp((color.b - color.r * 0.82) * 2.4, 0.0, 1.0);
        float horizonFactor = pow(clamp(1.0 - abs(ray.y), 0.0, 1.0), 3.0);
        float hazeAmount = horizonFactor * blueSky * 0.26;
        vec3 hazeColor = mix(skyColor, fogColor, 0.38);
        color.rgb = mix(color.rgb, hazeColor, hazeAmount);
    #endif

    #ifdef DL_FLAT_CLOUDS
        if (ray.y > -0.015) {
            // Mellow's Flat approach projects a direction onto a single
            // cloud plane and uses a small number of 2D noise samples.
            // The camera translation scrolls clouds across the world, but
            // the world-space ray prevents them rotating with the player's head.
            float denom = max(ray.y + length(ray.xz) / 6.0, 0.025);
            vec2 cloudPos = ray.xz / denom;
            cloudPos += cameraPosition.xz / 512.0;
            cloudPos = (cloudPos + vec2(frameTimeCounter * 0.010,
                                        frameTimeCounter * 0.006) * DL_CLOUD_SPEED) * 32.0;

            float baseNoise = texture2D(noisetex, cloudPos / 256.0 * 0.75).r;
            float detailNoise = texture2D(noisetex, cloudPos / 256.0 * 5.0).r;
            float noiseValue = max(baseNoise - detailNoise * 0.10, 0.0);
            float amount = DL_CLOUD_AMOUNT + rainStrength * 0.18;
            float formation = smoothstep(0.0, 0.40, noiseValue - 0.60 + amount);
            noiseValue *= formation * smoothstep(0.0, 0.20, ray.y);

            float density = noiseValue * 1.5;
            float cloudAlpha = clamp(1.0 - exp(-density * DL_CLOUD_OPACITY), 0.0, 0.90);

            vec3 sunDirection = normalize(mat3(gbufferModelViewInverse) * sunPosition);
            float sunlight = clamp(sunDirection.y * 0.5 + 0.5, 0.0, 1.0);
            vec3 cloudShadow = vec3(0.53, 0.59, 0.70);
            vec3 cloudLit = vec3(0.96, 0.975, 1.0) * (0.88 + sunlight * 0.12);
            vec3 cloudColor = mix(cloudShadow, cloudLit, smoothstep(0.18, 0.72, baseNoise));
            cloudColor = mix(cloudColor, fogColor, rainStrength * 0.48);

            color.rgb = mix(color.rgb, cloudColor, cloudAlpha);
        }
    #endif

    gl_FragColor = color;
}
