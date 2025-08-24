# Changelog

## [0.1.0] — 2025-08-24

### Added
- First public preview: toy no-I/O CLI for Relog DSL & algebraic token nets.
- CLI flags: `--help`, `--version`, `--log`, `--delay <ms>` (between successful ticks).
- Runtime: stores, transitions, input/output arcs, multiplicity, greedy concurrent firing.
- DSL basics: `store`, `transition { in/out }`, `init`, terms (`let x`, literals, `foo(a,b)`).
- Builds: macOS universal, Linux x86_64 (musl), Windows x86_64 (gnu).
- Bundled: `samples/`, `LICENSE.md`, `README.md`, `checksums.txt`.

### Known limitations
- No external I/O, persistence, or debugger; `trace` logs are very verbose.
