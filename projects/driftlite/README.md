# DriftLite: Mobile Performance Shader

An independently maintained OptiFine-format shader experiment for Minecraft Java 1.17.1, aimed at PojavLauncher, MobileGlues, Android 8.1 and the Adreno 506. The visual target is a Complementary Reimagined-like Minecraft style, but the rendering path is deliberately much lighter.

## Features in this prototype

- Lightweight Flat-style clouds rendered as a 2D animated noise layer in the sky pass. The noise texture is reused under the MIT license, with attribution in `shaders/lib/MELLOW_MIT_NOTICE.txt`.
- Adjustable cloud amount, opacity and animation speed.
- Subtle terrain/entity colour shaping, green-dominant terrain tint, blue-teal water tint and sky/horizon haze.
- Optional lightmap shaping and torch falloff, inspired by the general approach used by lightweight shaderpacks.
- Emissive treatment for mapped light-source blocks using `block.properties`.
- Heuristic glow enhancement for vivid warm/cool pixels on item/entity textures.
- An inexpensive held-item light falloff using OptiFine's held block-light uniforms.
- Optional two-stage half-resolution bloom. Bloom has a bright-pixel extraction stage and a 9-tap blur stage; Potato disables those passes.
- POTATO and BALANCED profiles and individual Shader Options controls.

## Cloud setting

The shader uses its own Flat-style clouds rather than vanilla Fast/Fancy clouds. OptiFine's Video Settings can override the shader-pack `clouds=off` property, so set **Options → Video Settings → Details → Clouds: OFF** while DriftLite is active. Then the shader draws the custom cloud sheet. If you disable `DL_FLAT_CLOUDS`, the result will be a clear sky, not vanilla Fast clouds.

## Important limitations

- “Emissive” means the source block/item appears bright and can bloom; it does not create true coloured light propagation onto surrounding blocks.
- Item glow is a colour/brightness heuristic. Some bright warm or blue texture pixels may also be enhanced.
- Handheld lighting approximates nearby illumination from OptiFine's held-light value and distance. It is not real-time dynamic shadowing.
- The lightmap curve is deliberately simple and uses no shadow maps. Actual caves/daylight brightness should be checked on the target device.
- Bloom is a selective bright-pixel threshold, so the sun, clouds and some white blocks can glow slightly as well.

## Inspiration and licensing

DriftLite's broad visual direction is inspired by the style of Complementary Reimagined, but no Complementary source or assets are copied. This is not an official Complementary project.

Mellow's MIT-licensed cloud noise asset is attributed in the included notice. The Flat cloud integration and world-lighting controls are implemented specifically for DriftLite. Sildur's Enhanced Default is All Rights Reserved; none of its shader source is copied. Glow and handheld-light behavior are independently implemented from feature-level observation.

## Build and test

GitHub Actions checks required files, GLSL version tags, brace balance, and creates a ZIP artifact. It does not compile shaders in OptiFine or MobileGlues. Runtime appearance and FPS are unverified until tested on the target device. Compare frame rates in the same scene, resolution and settings before claiming performance results.
