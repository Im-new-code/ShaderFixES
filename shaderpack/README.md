# Emissive Block Glow Shader Pack

This shader pack adds a screen-space bloom pass after the rendered scene. It does not change the lightmap, block-light propagation, or surface shading.

## Pipeline

1. `composite.fsh`: threshold the current scene for bright warm/cyan pixels, suppress sky pixels using depth, preserve the scene in `colortex3`, and put bloom candidates into half-resolution `colortex4`.
2. `composite1.fsh`: horizontal five-tap blur into half-resolution `colortex5`.
3. `composite2.fsh`: vertical five-tap blur into half-resolution `colortex6`.
4. `final.fsh`: add the blurred halo to the preserved scene.

The `GLOW_THRESHOLD`, `GLOW_RADIUS`, and `GLOW_STRENGTH` settings are intentionally conservative. The texture/color heuristic is not an exact emissive-material identifier, so visually inspect for false positives.

Target syntax is conservative GLSL 1.20. The shader has not yet been compiled with the user's OptiFine build or MobileGlues, so API and driver compatibility are unverified.
