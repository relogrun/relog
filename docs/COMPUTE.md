# Compute & Rhai

Inline evaluation for guards/outputs.

- **Directives:** `#compute(...)` (built-ins), `#rhai("...script...", args...)` (sandboxed Rhai).
- **Where:** inside `guard <term>` and output terms.
- **Ground-only:** all args must be constants after substitution.
- **Result type:** one constant: `int | bool | string (typed as sym)`.

## Semantics

- **Order:** substitute vars → evaluate (`#compute` / `#rhai`) → algebra normalize (where applicable).
- **Guards:** result must normalize to the constant `true`. Any error/non-ground ⇒ guard is `false`.
- **Outputs:** on error or non-ground, apply transition grounding:

  - `strict` ⇒ step fails,
  - `skip` ⇒ drop this output,
  - `default("v")` ⇒ use `"v"` (must be a simple string; no `? , ( )`).

---

## `#compute(...)` — built-ins

- Integers are 64-bit; overflow/div-by-zero are errors.
- Functions (arity):

**Math:**
`add(a,b)`, `sub(a,b)`, `mul(a,b)`, `div(a,b)`, `mod(a,b)`, `abs(x)`, `min(a,b)`, `max(a,b)`, `clamp(x,lo,hi)` (requires `lo ≤ hi`)

**Compare (→ bool):**
`gt(a,b)`, `ge(a,b)`, `lt(a,b)`, `le(a,b)`, `eq(a,b)`, `ne(a,b)`, `between(x,lo,hi)` (inclusive, `lo ≤ hi`)

**Bool:**
`and(a,b)`, `or(a,b)`, `not(a)`

**Strings:**
`concat(a,b)`, `len(s)` (UTF-8 chars)

**Example**

```relog
guard #compute(gt(#compute(add(2, 5)), 6))
out res(val(#compute(sub(10, #compute(add(4, 3))))))
```

**Sample**: [samples/compute.rl](../samples/compute.rl)

---

## `#rhai("...script...", args...)` — sandboxed script

- Signature: first arg is a string script; extra args are ground constants.
- Inside script: args available as `args` (array).
  Mapping: int→INT, bool→BOOL, string→STRING.
- Must return INT/BOOL/STRING.

**Sandbox profile**

- No I/O/time/random registered. `print`/`debug` are ignored.
- Limits: `max_operations = 20_000`, `max_call_levels = 32`, strict variables.

**Quoting**

- Strings use `"` with standard escapes: `\" \\ \n \t \u1234 \u{1F600}`.

**Example**

```relog
guard #rhai("let s = args[0]; s.len() >= 3", "alex")
out   out(val(#rhai("let n = args[0]; format!(\"user:{}\", n)", "ann")))
```

**Sample**: [samples/rhai.rl](../samples/rhai.rl)

---

## Rules

- Arguments must be **ground**; otherwise:

  - in guards ⇒ **false**,
  - in outputs ⇒ **grounding policy** applies.

- Only `int | bool | string` results are accepted.
- Algebra can rewrite results; guards must end up as the constant `true`.
- `#compute` is pure/deterministic.
- `#rhai` runs in a sandbox; no external effects; fuel-limited.
- Keep scripts small; they execute per firing attempt.
- `_` is an anonymous variable in patterns; use `"_"` if you need a literal underscore token.

---
