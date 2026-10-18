# Shader project index

This page tracks shader work hosted by ShaderFixES. Each project should have its own focused branch, with a project README and testing notes. Only list a project here once its branch actually exists.

## Active and completed projects

| Project | Branch | Track | Target environment | Status | Notes |
|---|---|---|---|---|---|
| No shader projects indexed yet | — | — | — | Not started | Add the first row when a real project branch is created. |

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