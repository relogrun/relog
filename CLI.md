# Relog CLI

**Binary name in all archives:** `relog-cli` (Windows: `relog-cli.exe`).

## Modes

* **`run`** — run a single `.rl` locally until quiescence or limits.
* **`serve`** — start an HTTP + WebSocket API to run/control `.rl` files in a base directory (pass a dir **or** a file; if a file, its parent becomes the base).

---

## `run` command

`relog-cli run <path-to-file.rl> [options]`

| Arg / Flag          | Description                             | Default               |
| ------------------- | --------------------------------------- | --------------------- |
| `<path-to-file.rl>` | DSL file to execute (must be a file)    | —                     |
| `--log <level>`     | `off`\|`error`\|`warn`\|`info`\|`debug` | `info`                |
| `--runtime <mode>`  | Override runtime: `natural`\|`reactive` | from DSL or `natural` |
| `--max-ticks <N>`   | Stop after N ticks                      | from DSL or unlimited |
| `--delay <MS>`      | Delay between **successful** ticks (ms) | from DSL or `0`       |

Notes: CLI flags override corresponding values from DSL `.rl` file (except `--log`, which is CLI-only).

---

## `serve` command

`relog-cli serve <base-path-or-file> [options]`

| Arg / Flag                  | Description                                                   | Default |
| --------------------------- | ------------------------------------------------------------- | ------- |
| `<base-path-or-file>`       | Directory to serve, or a file inside it (parent becomes base) | —       |
| `--port <P>`                | HTTP port                                                     | `8080`  |
| `--autostart <rel-file.rl>` | Autostart this file **relative to base**                      | —       |
| `--log <level>`             | Log level                                                     | `info`  |

---

## Serve-mode API

Base: `http://HOST:PORT/api` • WS: `ws://HOST:PORT/api`

| Method | Path | Body (JSON) | Returns / Purpose |
| --- | --- | --- | --- |
| WS | `/api` | — | Stream of `{schema,type,payload}` where `type` = `status`\|`event`\|`error`. |
| POST | `/api/start` | `{file, paused?, delay_ms?, max_ticks?}` | `200` on success; `file` is path **relative to base**. |
| POST | `/api/stop` | — | Stop current run. |
| POST | `/api/pause` | — | Pause run (`200` or `400`). |
| POST | `/api/resume` | — | Resume run (`200` or `400`). |
| POST | `/api/step` | — | Single manual step (`200` or `400`). |
| POST | `/api/set_delay` | `{delay_ms}` | Set inter-step delay. |
| GET | `/api/status` | — | `{ "running": true \| false }`. |
| GET | `/api/file?path=<rel>` | — | Contents of `.rl` file (text). |
| GET | `/api/files` | — | JSON array of file names, e.g. `["foo.rl","bar.rl"]`. |
| POST | `/api/save` | `{path, content}` | Save `.rl` **inside base**. |
| GET | `/api/net?path=<rel>` | — | Compiled net `NetStateDto` for `path` (or current run if omitted). |

**I/O note:** API operates on `.rl` files. Paths are expected to be inside the base directory (relative to base).
