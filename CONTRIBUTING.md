# Contributing to ShaderFixES

Thanks for helping improve a shader. The goal is to keep every change reproducible, attributable, and easy to test.

## Before starting

- Search open issues and existing project branches to avoid duplicate work.
- Check the branch and its README so you know the shader, target version, and current status.
- Keep one shader or closely related task per branch.
- Check the original project's license before copying, modifying, or redistributing shader code.
- Preserve upstream copyright and license notices.
- Do not upload private information, credentials, or unredacted logs.

## Choose the right report

Use the GitHub issue forms where possible:

- **Bug report:** shader compilation failures, crashes, visual artifacts, or compatibility issues.
- **Shader port request:** adapting a shader to another Minecraft version or rendering pipeline.
- **Shader idea or effect request:** a new effect or focused improvement.

Include enough detail to reproduce the problem. A screenshot without version and renderer information is often insufficient.

## Branch names

- `fix/<shader>-<issue>`
- `create/<shader>`
- `port/<shader>-<source>-to-<target>`
- `experiment/<topic>`

## Submit a fix or port

- Explain the original problem and its likely cause.
- Describe the files changed and why.
- Include before/after screenshots for visual changes when possible.
- Record the exact environment used for testing.
- Clearly label untested behavior and known limitations.
- Note performance changes and trade-offs where measurable.
- Avoid unrelated formatting or refactoring that makes the fix harder to review.
- Update the [project index](docs/PROJECTS.md) when a real project branch is created or its status changes.
- Use the pull request template and complete its checklist.

## Testing checklist

- [ ] Shader loads without compilation errors, or the compile failure is recorded.
- [ ] The original issue can no longer be reproduced, where applicable.
- [ ] Important scenes and effects still render correctly.
- [ ] Target versions and renderer are recorded.
- [ ] Performance impact is measured or marked untested.
- [ ] Attribution and license requirements are preserved.
- [ ] README, testing notes, and project index are updated where needed.
- [ ] Logs and screenshots contain no private information.

A successful test on one device or renderer is not proof of universal compatibility. State exactly what was tested. See [Compatibility and verification](docs/COMPATIBILITY.md).

## Licensing and attribution

The root [LICENSE](LICENSE) covers only original repository documentation, templates, tooling, and artwork. It does not grant rights to third-party shader packs or assets. Check the applicable license before copying or redistributing files. If licensing is unclear, do not assume reuse is permitted.

## Security and responsible reporting

Do not post credentials, private data, or potentially harmful sensitive details in public issues. See [SECURITY.md](SECURITY.md) for the reporting guidance.
