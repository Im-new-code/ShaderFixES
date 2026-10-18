# Contributing to ShaderFixES

Thanks for helping improve a shader. The goal is to keep every change reproducible, attributable, and easy to test.

## Before starting

- Check the branch and its README so you know the shader, target version, and current status.
- Keep one shader or closely related task per branch.
- Check the original project's license before copying, modifying, or redistributing shader code.
- Preserve upstream copyright and license notices.

## Branch names

- `fix/<shader>-<issue>`
- `create/<shader>`
- `port/<shader>-<source>-to-<target>`
- `experiment/<topic>`

## Report a bug

Include as much of the following as possible:

1. Minecraft version and edition.
2. Loader and version, if applicable.
3. Renderer and shader mod/version.
4. Device or GPU, operating system, and relevant graphics settings.
5. Exact steps to reproduce the issue.
6. Crash log or shader compilation error.
7. Screenshots showing the issue and the intended result.

Remove personal information from logs before sharing them.

## Submit a fix or port

- Explain the original problem and its likely cause.
- Describe the files changed and why.
- Include before/after screenshots for visual changes when possible.
- Record the exact environment used for testing.
- Clearly label untested behavior and known limitations.
- Note performance changes and trade-offs where measurable.
- Avoid unrelated formatting or refactoring that makes the fix harder to review.

## Testing checklist

- [ ] Shader loads without compilation errors.
- [ ] The original issue can no longer be reproduced.
- [ ] Important scenes and effects still render correctly.
- [ ] Target versions and renderer are recorded.
- [ ] Performance impact is understood or marked untested.
- [ ] Attribution and license requirements are preserved.
- [ ] README and known limitations are updated.

A successful test on one device or renderer is not proof of universal compatibility. State exactly what was tested.
