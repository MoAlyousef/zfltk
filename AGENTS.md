# Repository Guidelines

## Project Structure & Module Organization
- `src/`: Zig wrapper modules (e.g., `window.zig`, `widget.zig`, `app.zig`, `zfltk.zig`).
- `examples/`: Small runnable demos (e.g., `simple.zig`, `editor.zig`).
- `build.zig` / `build.zig.zon`: Build configuration and dependencies.
- `zig-out/`: Build outputs (installed example binaries under `zig-out/bin`).
- `.github/workflows/`: CI for Linux, macOS, Windows.
- `screenshots/`: Images used in README.

## Build, Test, and Development Commands
- Build library: `zig build`
- Build examples: `zig build -Dzfltk-build-examples=true`
- Run an example (after build): `./zig-out/bin/simple`
- Format code: `zig fmt src examples`
- Non‑standard `cfltk` prefix: `zig build --search-prefix /path/to/cfltk`

Notes: Requires system `cfltk` (statically linked) and FLTK deps (see README for OS packages). CI uses Zig 0.14/0.15.

## Coding Style & Naming Conventions
- Formatting: Use `zig fmt` before pushing.
- File names: lowercase, short (e.g., `button.zig`).
- Types/Enums: UpperCamelCase (e.g., `Window`, `Message`).
- Functions/vars: lowerCamelCase (e.g., `build`, `setCallbackEx`).
- Keep modules focused (widget types in their respective files).

## Testing Guidelines
- No unit test suite yet; validate with examples.
- Smoke test: build all examples and run a few (`simple`, `editor`).
- Prefer adding minimal example code when fixing/adding wrapper APIs.
- If adding tests, follow Zig test blocks in relevant modules and run via `zig build`.

## Commit & Pull Request Guidelines
- Commits: short, imperative subject (e.g., "fix windows ci", "update build.zig"). Group related changes.
- PRs: include
  - What/why, platforms touched (Linux/macOS/Windows), and build notes.
  - Linked issues, screenshots for GUI changes if helpful.
  - Verification steps: commands run (e.g., `zig build -Dzfltk-build-examples=true`) and example binaries executed.

## Security & Configuration Tips
- Installing `cfltk` without a prefix defaults to system paths and may need sudo.
- On custom installs, pass include/lib via `--search-prefix` to ensure static linkage resolves.
