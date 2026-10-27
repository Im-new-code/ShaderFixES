# Cyan Sky Fog — standalone mod

A tiny client-side Fabric mod that ports the two fixed colours from the supplied **Cyan Sky 1.17.1** resource pack and reapplies atmospheric fog parameters even when OptiFine's **Details → Fog** option is set to **OFF**.

## Source colours

| Use | Original pack value |
|---|---|
| Overworld sky | \`#62CBF2\` |
| Overworld fog | \`#A0DEF1\` |

The original ZIP used Colormatic JSON at \`assets/colormatic/colormap/sky0.json\` and \`fog0.json\`. This mod uses the colour values directly, so it does **not** depend on Colormatic or parse Colormatic's resource format.

## Target

- Minecraft Java Edition 1.17.1
- Fabric Loader
- Client-side only
- OptiFine is the intended test target; compatibility depends on the OptiFine/Fabric bridge and render pipeline used by the launcher
- Designed to be inexpensive: no core-shader replacements, post-process effects, coloured lighting, or per-frame allocations

## Install

1. Download the built \`cyan-sky-fog-0.1.0+mc.1.17.1.jar\` from the branch's GitHub Actions artifact or Releases when available.
2. Place it in the instance's \`mods\` folder.
3. Keep Fabric Loader installed. **Colormatic and Fabric API are not required by this mod.**
4. Launch once to generate \`config/cyan-sky-fog.properties\`.
5. For the intended test, set OptiFine **Details → Fog → OFF** and enter an Overworld world.

## Configuration

The config is generated on first launch:

\`\`\`properties
enabled=true
force_fog=true
sky_color=62CBF2
fog_color=A0DEF1
terrain_fog_start=0.68
terrain_fog_end=1.0
sky_fog_start=0.0
sky_fog_end=1.0
\`\`\`

- \`enabled\`: toggles the mod's colour and fog overrides.
- \`force_fog\`: re-applies Minecraft shader fog start/end/color after the game's fog setup, including the intended OptiFine Fog OFF case.
- Colours are RGB hex values without the leading \`#\`.
- Fog start/end are ratios of the active render distance. Terrain defaults to the last 32% of the visible distance; sky/cloud fog fades across the full distance.
- Change the config and restart the world (or the game) to apply edits.

## Important limits

This mod ports the **colours and fog behavior**, not any fluffy cloud texture or custom cloud geometry. It does not install modified core shaders. It requests the normal Minecraft rendering pipeline's fog uniforms to be set after vanilla/OptiFine's fog setup. If a particular OptiFine build disables fog later in its render pipeline instead of merely changing the fog parameters, an additional OptiFine-specific hook may be needed; that has to be verified in the target launcher.

The GitHub Actions build checks compilation and packaging. It does not prove that OptiFine's Fog OFF path is overridden on every renderer, nor does it replace an in-game test on Pojav-Glow-Worm/MobileGlues and the OPPO A3s.

## Build

The repository workflow builds the remapped mod JAR with Gradle. Locally, use Java 17 and run:

\`\`\`sh
gradle build
\`\`\`

The build targets Java 16 bytecode for Minecraft 1.17.1.
