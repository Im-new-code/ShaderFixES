# DriftLite: Mobile Performance Shader

An independently maintained OptiFine-format shader experiment for Minecraft Java 1.17.1, aimed at PojavLauncher, MobileGlues, Android 8.1 and the Adreno 506. The visual target is a Complementary Reimagined-like Minecraft style, but the rendering path is deliberately much lighter.

## Features in this prototype

- Lightweight Flat-style clouds rendered as a 2D animated noise layer in the sky pass. The noise texture is reused under the MIT license, with attribution in `shaders/lib/MELLOW_MIT_NOTICE.txt`.
- Optional cloud amount, opacity and speed controls.
- Existing subtle terrain/entity colour treatment, green-dominant terrain tint, water tint, sky tuning and horizon haze.
- Emissive treatment for mapped light-source blocks using `block.properties`.
- Heuristic glow enhancement for vivid warm/cool pixels on item/entity textures.
- An inexpensive held-item light falloff using OptiFine's held block-light uniforms.
- Optional two-stage half-resolution bloom. Bloom has a bright-pixel extraction stage and a 9-tap blur stage; Potato disables those passes.
- POTATO and BALANCED profiles and individual Shader Options controls.

The custom Flat cloud sheet replaces vanilla clouds while this pack is active. Minecraft's clouds are disabled via shader properties to avoid drawing Fast clouds over the custom layer.

## Important limitations

- “Emissive” means the source block/item appears bright and can bloom; it does not create true coloured light propagation onto surrounding blocks.
- Item glow is a colour/brightness heuristic. Some bright warm or blue texture pixels may also be enhanced.
- The handheld lighting approximation uses the existing held-light value and distance. It is not real-time dynamic shadowing.
- There are no shadow maps, SSAO, SSR, volumetric effects or temporal post-processing in this lightweight baseline.

## Inspiration and licensing

DriftLite's broad visual direction is inspired by the style of Complementary Reimagined, but no Complementary source or assets are copied. This is not an official Complementary project.

Mellow's MIT-licensed cloud noise asset is attributed in the included notice. The flat cloud shader integration is a separate DriftLite implementation. Sildur's Enhanced Default is All Rights Reserved; none of its shader source is copied. Glow and handheld-light behavior are independently implemented from feature-level observation.

## Build and test

GitHub Actions checks required files, GLSL version tags, brace balance, and creates a ZIP artifact. It does not compile the shaders in OptiFine or MobileGlues. Runtime appearance and FPS are unverified until tested on the target device. Compare frame rates in the same scene, resolution and settings before claiming performance results.
