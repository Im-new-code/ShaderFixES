# Shader project index

This page tracks shader work hosted by ShaderFixES. Each project should have its own focused branch, with a project README and testing notes. Only list a project once its branch actually exists.

## Active and completed projects

| Project | Branch | Track | Target environment | Status | Notes |
|---|---|---|---|---|---|
| [Mellow v3.2 outline and water patch](https://github.com/Im-new-code/ShaderFixES/tree/fix/mellow-v3-2-performance-water-outline/projects/mellow-v3.2) | [`fix/mellow-v3-2-performance-water-outline`](https://github.com/Im-new-code/ShaderFixES/tree/fix/mellow-v3-2-performance-water-outline) | Fix / optimization | Not yet confirmed; source archive's supported target must be checked | Experimental, needs in-game testing | Median-based outline detection and vanilla-textured water mode. No performance or visual fix is claimed until tested. |

## Status definitions

- **Planned:** a goal is recorded, but implementation has not started.
- **In progress:** active investigation or development is underway.
- **Needs testing:** a candidate change exists but has not been adequately verified.
- **Verified:** the documented fix or effect passed the stated tests on the listed environment. This does not imply universal compatibility.
- **Blocked:** a known dependency, source restriction, or technical issue prevents progress.
- **Archived:** work is paused or superseded; keep useful findings and attribution.

## Adding a project

1. Create a branch from `main` using the naming rules in the root README.
2. Copy `templates/shader-project/README.md` and `templates/shader-project/TESTING.md` into the project branch root.
3. Record the source URL, version, author, and license before importing third-party files.
4. Add shader source, screenshots, and notes as needed.
5. Update this table with the real branch name, target environment, status, and a short factual note.
6. Keep the status conservative: distinguish a successful compile from a visually verified result.

## Branch naming

- `fix/<shader>-<issue>` for repairs.
- `create/<shader>` for original development.
- `port/<shader>-<source>-to-<target>` for version or pipeline ports.
- `experiment/<topic>` for isolated experiments.

Do not use a placeholder branch name as evidence that work exists. Link to the branch and project README once they are available.
