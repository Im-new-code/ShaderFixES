# DriftLite: Mobile Performance Shader

An independently written OptiFine-format shader prototype for Minecraft Java 1.17.1. Its visual direction takes broad inspiration from polished stylized shaders: richer daylight, controlled contrast, and atmospheric distance, while keeping the rendering path deliberately inexpensive.

- **Target:** Minecraft 1.17.1 + OptiFine 1.17.1
- **Device target:** PojavLauncher, Android 8.1, MobileGlues, Adreno 506
- **Status:** Initial source prototype. Runtime compilation and gameplay testing are pending.

## Approach
This project does not copy Complementary Reimagined source or redistribute its files. It uses aesthetic inspiration only and implements a separate minimal pipeline from original code. Upstream reference: https://github.com/ComplementaryDevelopment/ComplementaryReimagined

First-stage trade-offs: no shadow maps, SSAO, SSR, bloom, volumetric effects, or temporal post-processing. The initial version focuses on low pass count, vanilla texture/lightmap sampling, a restrained optional color treatment, and low-cost distance fog.

## Build
The `DriftLite shader package` GitHub Actions workflow validates required source files and packages `shaders/` into a ZIP artifact. Download the artifact from the workflow run and place the ZIP in `.minecraft/shaderpacks/`, then select it under Options → Video Settings → Shaders.

## Verification
- Source structure: included in workflow checks.
- OptiFine compilation: **Not tested**.
- MobileGlues compatibility: **Not tested**.
- Visual correctness: **Not tested**.
- FPS/frame time: **Not measured**.

Packaging success is not proof of shader compilation or performance on-device. Report the first shader compile error from `latest.log` if it fails.

## License
Original DriftLite source is MIT licensed in `LICENSE.txt`. No Complementary shader code, assets, or license file are included. This project is independent and not affiliated with or endorsed by Complementary Development.
