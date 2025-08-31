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

| Method | Path | Body (JSON) | Returns | Notes |
| --- | --- | --- | --- | --- |
| WS | `/api` |  | Stream of `{schema,type,payload}` where `type`=`status`\|`event`\|`error`. | Realtime status/events/errors. |
| POST | `/api/start` | `{file, paused?, delay_ms?, max_ticks?}` | `200` | `file` is path **relative to base**; starts a run. |
| POST | `/api/stop` |  | `200` | Stops current run. |
| POST | `/api/pause` |  | `200` or `400` | Pauses run. |
| POST | `/api/resume` |  | `200` or `400` | Resumes run. |
| POST | `/api/step` |  | `200` or `400` | Executes single manual step. |
| POST | `/api/set_delay` | `{delay_ms}` | `200` | Sets inter-step delay. |
| GET | `/api/status` |  | `200`, `{ "running": true \| false }` | Current run state. |
| GET | `/api/file?path=<rel>` | — | `200`, `.rl` file (text) | Reads file inside base. |
| GET | `/api/files` |  | `200`, `["foo.rl","bar.rl"]` | Lists `.rl` files in base. |
| POST | `/api/save` | `{path, content}` | `200` | Saves `.rl` **inside base**. |
| GET | `/api/net?path=<rel>` |  | `200`, compiled `NetStateDto` | For provided path or current run if omitted. |

**I/O note:** API operates on `.rl` files. Paths are expected to be inside the base directory (relative to base).
