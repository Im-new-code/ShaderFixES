# DriftLite: Mellow techniques, Complementary Reimagined visual target

DriftLite is a separate OptiFine-format shader project for Minecraft Java 1.17.1. The current goal is to correct the rendering pipeline and build toward the Complementary Reimagined look while preserving Mellow-like soft stylization, cloud design and configurable colour.

## Current feature work

- World-anchored Flat-style clouds based on a small animated 2D noise projection.
- Blue/teal water tint, two-scale animated ripple normals and direct-light glints without reflections.
- Broken depth-aware shoreline foam, based on the difference between water surface and opaque scene depth.
- Uploaded World Outline Shader r1.0 depth-slope outline algorithm, adapted to output through DriftLite's scene/composition buffers. It includes finite-depth sky-ray reconstruction and optional chunk-edge fog.
- Emissive mapping for light sources, handheld-light approximation and heuristic item glow.
- Optional restrained bloom and configurable exposure/saturation/vibrance/contrast.
- Profiles: POTATO, BALANCED and REIMAGINED. The REIMAGINED profile disables bloom by default.

## Settings reference

The uploaded settings file suggests colour scheme 4, saturation 1.1, vibrance 1.2, contrast 1.0, and bloom/reflections/water normals/extra fog disabled. DriftLite uses equivalent style intentions where practical, but numerical values are not interchangeable across different shader implementations. Water ripple normals are enabled in BALANCED/REIMAGINED because the requested water appearance needs a surface-lighting cue; reflections remain off. Chunk-edge fog remains off by default.

The uploaded Mellow v3.4.1a.zip.txt is a settings file, not the actual shader source ZIP. Current cloud-noise attribution is in shaders/lib/MELLOW_MIT_NOTICE.txt. The uploaded World Outline source is MIT-licensed according to its project listing; see shaders/lib/WORLD_OUTLINE_NOTICE.txt.

## Compatibility status

The ZIP workflow checks file presence, GLSL version markers, balanced braces, and packaging. It does **not** compile GLSL under OptiFine, guarantee MobileGlues support, or measure FPS. Shader runtime, water depth sampling, outline behavior and the correct cloud transform must be tested in-game.

Complementary Reimagined is the visual reference, not a source-code base. No Complementary shader source/assets are included.
