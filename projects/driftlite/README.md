# DriftLite: Mobile Performance Shader

An independently written OptiFine-format shader prototype for Minecraft Java 1.17.1. It takes broad aesthetic inspiration from polished stylized shaders while keeping the rendering path inexpensive for Android-class GPUs.

- **Target:** Minecraft 1.17.1 + OptiFine 1.17.1
- **Device target:** PojavLauncher, Android 8.1, MobileGlues, Adreno 506
- **Status:** Early prototype. Runtime compilation and on-device testing remain necessary.

## Lightweight visual features

- Subtle colour saturation and contrast adjustment for terrain and entities.
- Small boost to green-dominant terrain texels.
- Optional blue-teal water tint without additional texture samples.
- Optional richer vanilla sky colour.
- Optional sky-height-based horizon haze using sky/fog colours.
- Optional distance fog using existing fog uniforms.
- POTATO and BALANCED profiles and individual Shader Options toggles.

Fast clouds remain vanilla. There are no shadow maps, SSAO, SSR, bloom, volumetric effects, temporal post-processing, or coloured dynamic lighting.

## Inspiration and licensing

This project does not copy Complementary Reimagined source or redistribute its files. It uses aesthetic inspiration only and implements a separate minimal pipeline from original code. Upstream reference: https://github.com/ComplementaryDevelopment/ComplementaryReimagined

Original DriftLite source is MIT licensed in `LICENSE.txt`. This project is independent and not affiliated with or endorsed by Complementary Development.

## Build and testing

The GitHub Actions workflow validates the source structure and creates a shader ZIP artifact. Packaging success is not proof of OptiFine compilation, MobileGlues compatibility, appearance, or FPS. Test day/night, caves, water, foliage, weather, Nether and End before reporting compatibility or performance results.
