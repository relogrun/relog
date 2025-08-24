# Relog (CLI Preview)

 **Toy, no-I/O runner** for a tiny Relog DSL and **algebraic** token networks.  
No persistence, no files, no sockets — just load a .rl and run it locally.

## Downloads

Grab the archive for your OS from **Releases**:

* **macOS (Universal)** — `relog-macos-universal.zip`
* **Linux x86\_64 (musl)** — `relog-linux-x86_64.tar.gz`
* **Windows x86\_64 (gnu)** — `relog-windows-x86_64.zip`

---

## Quick Start

### macOS

```bash
unzip relog-macos-universal.zip
cd relog-*
chmod +x ./relog-macos-universal

# run a sample
./relog-macos-universal ./samples/buffer_backpressure.rl --log debug --delay 500
```

> If macOS shows a quarantine warning:
> `xattr -dr com.apple.quarantine ./relog-macos-universal`

### Linux (x86\_64)

```bash
tar -xzf relog-linux-x86_64.tar.gz
cd relog-*
chmod +x ./relog-linux-x86_64

# run a sample
./relog-linux-x86_64 ./samples/buffer_backpressure.rl --log debug --delay 500
```

### Windows (x86\_64)

```powershell
Expand-Archive .\relog-windows-x86_64.zip -DestinationPath .\relog
cd .\relog

# run a sample
.\relog-windows-x86_64.exe .\samples\buffer_backpressure.rl --log debug --delay 500
```

> If SmartScreen warns about an unknown publisher, choose “More info” → “Run anyway”.

---

## Usage

```
relog <path-to-file.rl> [--log <level>] [--delay <ms>]
```

* `--log`: `off | error | warn | info | debug` (default: `info`)
* `--delay <ms>`: optional pause **between successful ticks** in natural mode (e.g. `--delay 1000` = 1s).
  No initial delay before the first step.

Examples:

```bash
# minimal
./relog-… ./samples/simple.rl

# verbose tracing
./relog-… ./samples/buffer_backpressure.rl --log debug

# throttle steps to 2/s
./relog-… ./samples/buffer_backpressure.rl --delay 500
```

Show built-in help & version:

```bash
relog --help
relog --version
```

---

## The DSL (tiny overview)

A program declares **stores**, **transitions** (with input/output arcs), and **initial tokens**:

```relog
// Stores
store buf
store free

// Transition
transition push {
  in  free(slot) * 2        
  out buf(item(42)) *2     
}

init {
  free slot * 2              
  buf item(1)              
}
```

* Variables: `let x`
* Literals: strings `"hello world"` or `hello`, numbers `123`, identifiers `ok`
* Applications: `foo(bar, baz)`
* Multiplicity: `* N` (e.g., `free(let _) * 3`)

---

## Troubleshooting

* **Permission denied** → `chmod +x ./relog-…` (macOS/Linux)
* **Quarantine (macOS)** → `xattr -dr com.apple.quarantine ./relog-macos-universal`
* **Very chatty logs** → use `--log info` or `--log warn`
* **Weird path issues on Windows** → wrap paths with spaces in quotes

---

## License

See **LICENSE.md**.
You may run the binary for any purpose, including commercial, and even host services on top of it — **but do not redistribute the binary**. Details inside the license.

---

## Contact

Questions / issues: open an issue on the repo or email **[q@relog.run](mailto:q@relog.run)**.

