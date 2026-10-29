# DriftLite: Complementary Reimagined visual target

DriftLite is an independent OptiFine-format shader experiment for Minecraft Java 1.17.1. The current priority is correct rendering and a polished visual style before performance tuning.

## Current feature work

- World-space, Mellow-style Flat clouds using animated 2D noise.
- Water tint, animated noise-based ripple normals and direct-light glints without reflections.
- Broken depth-aware shoreline foam.
- Uploaded World Outline Shader depth-slope method and finite-depth sky-ray reconstruction.
- Emissive source blocks, handheld-light approximation and item glow.
- Optional two-stage half-resolution bloom and configurable exposure/saturation/vibrance/contrast.

## Pipeline fix

The previous build incorrectly used `colortex1` for scene-color output. In OptiFine, `colortex1` is the depth-color attachment (`gdepth`), so using it for scene colour made the final pass sample depth data instead of the rendered world. The scene/outline output is now routed to `colortex3`, bloom extraction to `colortex4`, and blurred glow to `colortex5`. See the OptiFine shader documentation for color-attachment semantics: https://optifine.readthedocs.io/shaders_dev/color_attachments.html

## Important testing note

GitHub Actions packaging does not compile the shader inside OptiFine or emulate MobileGlues. Install and check this corrective build before evaluating the new appearance. Complementary Reimagined remains the visual reference; no Complementary code/assets are included.


## Latest visual correction

The sky shader now reconstructs a world-space viewing ray per fragment from screen coordinates and the inverse projection/view matrices instead of interpolating the sky mesh vertex direction. This is intended to prevent wide radial cloud streaks when the previous sky geometry interpolant did not represent the per-pixel camera ray. World outlines are now disabled in the BALANCED and REIMAGINED profiles by default because strong screen-space edge highlights are not part of the desired Complementary-like style; the outline control remains available for users who want it.


## Directional lighting update

The latest development pass adds a basic OptiFine shadow-map stage with alpha-tested foliage and a four-tap terrain receiver. The shadow map is configured to 1024 resolution and 96 block distance, and can be disabled through the shader options. This implementation is source-compiled in CI, but still requires in-game testing for bias, shadow direction, foliage and device performance.
