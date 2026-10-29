# DriftLite: Mobile Performance Shader

An independently written OptiFine-format shader prototype for Minecraft Java 1.17.1. Its visual direction takes broad inspiration from polished stylized shaders, while keeping the rendering path inexpensive for Android-class GPUs.

- **Target:** Minecraft 1.17.1 + OptiFine 1.17.1
- **Device target:** PojavLauncher, Android 8.1, MobileGlues, Adreno 506
- **Status:** Early prototype. On-device testing is still required after each shader update.

## Current lightweight features

- Subtle saturation and contrast shaping for terrain and entities.
- Optional enhancement of green-dominant terrain texels.
- Optional blue-teal water tint, with no extra texture samples.
- Optional subtle sky colour enhancement.
- Optional distance fog using the existing fog uniforms.
- POTATO and BALANCED profiles, plus individual toggles under Shader Options.

These effects are intentionally simple. There are no shadow maps, SSAO, SSR, bloom, volumetric effects, temporal post-processing, or colored dynamic lighting.

## Inspiration and licensing

This project does not copy Complementary Reimagined source or redistribute its files. It uses aesthetic inspiration only and implements a separate minimal pipeline from original code. Upstream reference: https://github.com/ComplementaryDevelopment/ComplementaryReimagined

Original DriftLite source is MIT licensed in `LICENSE.txt`. This project is independent and not affiliated with or endorsed by Complementary Development.

## Build and test status

The GitHub Actions workflow packages `shaders/` into a ZIP artifact. Packaging success only verifies the source-file structure and ZIP creation. It is not proof of OptiFine compilation or MobileGlues compatibility.

After installation, test day/night, water, foliage, entities, weather, the Nether, and the End. Compare FPS in the same scene and at the same resolution before claiming a performance result.
