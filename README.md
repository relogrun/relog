# Relog (Preview)

**Toy, no-I/O runner** for a tiny DSL for **algebraic token networks**.

No persistence, no files, no sockets — just load a .rl and run it locally.

## DSL (tiny overview)

A program declares **stores**, **transitions** (with input/output arcs), and **initial tokens**:

```relog
// Stores
store produced
store free
store buf
store done

// Move one produced item into the buffer, consuming one slot.
transition push {
  in  produced(item(let x))
  in  free(slot)
  out buf(item(let x))
}

// Take TWO equal items from the buffer at once, return two slots.
transition pop_pair {
  in  buf(item(let y)) * 2
  out done(pair(let y, let y))
  out free(slot) * 2
}

init {
  produced item(hello)
  produced item(world) * 2 // enables pop_pair once for "world"
  free slot * 2
}
```

- **Variables:** `let x`. Reusing a var enforces equality, e.g. `pair(let x, let x)`.
- **Literals:** identifiers (`hello`), strings (`"hello world"`), numbers (`123`).
- **Applications:** n-ary terms, e.g. `foo(bar, baz)`.
- **Multiplicity:** `* N`. Inputs need **N distinct** matching tokens. Examples: `in buffer(let x) * 3`, `init { free slot * 3 }`.
- **Configs**: set directly in the DSL (net/runtime/store/transition).

Full DSL reference: see [DSL.md](./DSL.md)

Samples: see [samples/](./samples)

---

## Downloads

Grab the archive for your OS from [latest release](https://github.com/relogrun/relog/releases/latest):

- **macOS (Universal)** — `relog-macos-universal.zip`
- **Linux x86_64 (musl)** — `relog-linux-x86_64.tar.gz`
- **Windows x86_64 (gnu)** — `relog-windows-x86_64.zip`

## Quick Start

### macOS

```bash
unzip relog-macos-universal.zip
cd relog-*
chmod +x ./relog-cli

# run a sample
./relog-cli ./samples/pure_net/buffer_backpressure.rl --log debug --delay 500
```

> If macOS shows a quarantine warning:
> `xattr -dr com.apple.quarantine ./relog-cli`

### Linux (x86_64)

```bash
tar -xzf relog-linux-x86_64.tar.gz
cd relog-*
chmod +x ./relog-cli

# run a sample
./relog-cli ./samples/pure_net/buffer_backpressure.rl --log debug --delay 500
```

For the full command reference (modes, flags, REST/WS API), see [CLI.md](./CLI.md).

### Windows (x86_64)

```powershell
Expand-Archive .\relog-windows-x86_64.zip -DestinationPath .\relog
cd .\relog

# run a sample
.\relog-cli.exe .\samples\pure_net\buffer_backpressure.rl --log debug --delay 500
```

> If SmartScreen warns about an unknown publisher, choose “More info” → “Run anyway”.

## Run via Docker (read-only sandbox)

Don’t want to run a local binary? Use a locked-down Linux container.
Requires Docker (works on macOS, Linux, and Windows with Docker Desktop).

### macOS / Linux

```bash
docker run --rm --platform=linux/amd64 \
  --read-only --cap-drop=ALL --pids-limit=256 \
  --memory=512m --cpus=1 --network none \
  --security-opt no-new-privileges:true \
  --tmpfs /tmp:rw,nosuid,nodev \
  -v "$PWD:/app:ro" \
  -w /app \
  -u "$(id -u):$(id -g)" \
  debian:stable-slim \
  /app/relog-cli /app/samples/pure_net/buffer_backpressure.rl --log debug --delay 500
```

### Windows (PowerShell)

```powershell
docker run --rm --platform=linux/amd64 `
  --read-only --cap-drop=ALL --pids-limit=256 `
  --memory=512m --cpus=1 --network none `
  --security-opt no-new-privileges:true `
  --tmpfs /tmp:rw,nosuid,nodev `
  -v "${PWD}:/app:ro" `
  -w /app `
  debian:stable-slim `
  /app/relog-cli /app/samples/pure_net/buffer_backpressure.rl --log debug --delay 500
```

> Notes:
>
> - The command expects you extracted the **Linux** archive into the current directory, so `relog-cli` and `samples/` are present under `./`.
> - `--platform=linux/amd64` makes it work on Apple Silicon too.
> - The container is read-only, has dropped capabilities, no network, a tmpfs `/tmp`, and (on macOS/Linux) runs as your user via `-u`.

---

## Usage

There are two modes:

**Direct mode (`run`)** — execute a single `.rl` locally.

```bash
./relog-cli run ./samples/pure_net/buffer_backpressure.rl --log debug --delay 500
```

**Server mode (`serve`)** — start an HTTP + WebSocket API for remote control (pass a base directory or a file inside it).

```bash
./relog-cli serve ./samples/pure_net --port 9000 --log debug
```

Help:

```bash
./relog-cli run --help
./relog-cli serve --help
```

For full details (all flags, API endpoints), see [CLI.md](./CLI.md).

---

## Troubleshooting

- **Permission denied** → `chmod +x ./relog-cli` (macOS/Linux)
- **Quarantine (macOS)** → `xattr -dr com.apple.quarantine ./relog-cli`
- **Weird path issues on Windows** → wrap paths with spaces in quotes

## License

You may run the binary for any purpose, including commercial, and even host services on top of it — **but do not redistribute the binary**. Details inside the [license](./LICENSE.md).

## Contact

**[q@relog.run](mailto:q@relog.run)**
