# Compatibility and verification

Shader compatibility depends on more than the Minecraft version. Record the full rendering environment for each result.

## Record these details

- Minecraft edition and version.
- Loader and version, where applicable.
- Shader mod and version.
- Rendering backend or compatibility layer, including version.
- Device, GPU, operating system, and Java version when relevant.
- Resolution, render distance, graphics settings, and shader options.
- Shader project version or commit tested.
- Whether the result is a compile check, visual check, stability check, or performance measurement.

## Verification levels

| Level | Meaning | What may be claimed |
|---|---|---|
| Source review | Code or shader files were inspected without running them. | Likely cause or proposed change only. |
| Compile checked | The target shader pipeline accepted the shader. | Compilation passed in the recorded environment. |
| Visually checked | Key scenes and effects were inspected in game. | The recorded visual behavior was observed. |
| Stability checked | Relevant scenes were tested for crashes or rendering failures. | No failure was observed during the stated test. |
| Performance measured | FPS or frame-time data was collected under recorded settings. | Only the measured result and test conditions. |

A higher level does not automatically imply every lower level was tested. State what was actually done and avoid claiming universal support based on one device.

## Before and after evidence

When practical, use the same scene, time, camera position, resolution, graphics settings, and shader options for comparisons. Identify any differences. Do not use post-processing to disguise regressions.

## Mobile and constrained devices

For mobile testing, record device/GPU and renderer details, memory settings, resolution, render distance, and relevant options. A shader may be visually correct but too expensive for a target device. Treat performance as a separate result from visual correctness.

## Unsupported or unknown environments

Use **Not tested** or **Unknown** instead of guessing. Report a known incompatibility only when there is reproducible evidence or a clearly documented upstream limitation.