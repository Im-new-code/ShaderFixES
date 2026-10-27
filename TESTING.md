# Cyan Sky Fog — testing checklist

## Build/packaging checks

- [ ] GitHub Actions Gradle build passes.
- [ ] JAR contains \`fabric.mod.json\`, \`cyan_sky.mixins.json\`, both mixin classes, and generated metadata.
- [ ] Fabric Loader detects \`cyan_sky_fog\` without requiring Colormatic or Fabric API.

## In-game checks

Test on Minecraft 1.17.1, Fabric, the user's OptiFine/Fabric bridge, Pojav-Glow-Worm, MobileGlues/GLES 3.2, and the OPPO A3s.

1. Set OptiFine **Details → Fog → OFF**.
2. Enter an Overworld with clear weather and look at terrain at medium/far distance.
3. Confirm the sky has the cyan-blue colour family and the horizon/terrain has pale cyan fog.
4. Look at clouds at a distance and confirm they fade instead of abruptly clipping.
5. Toggle fog OFF/ON and compare; note if OptiFine cancels the injected fog after \`BackgroundRenderer.applyFog\`.
6. Enter water and lava; confirm the mod does not replace their native fog.
7. Enter the Nether and End; confirm the mod does not apply its Overworld colours.
8. Check ReplayMod record and playback for rendering changes.
9. Record FPS before/after at the same location, render distance, and camera angle.
10. Test with \`enabled=false\` and \`force_fog=false\` in config to verify both disable paths.

## What counts as verified

A successful Gradle build is compile verification only. Mark the rendering behavior verified only after the in-game Fog OFF test passes on the target launcher/device, and report any OptiFine/ReplayMod conflicts separately.
