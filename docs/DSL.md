# Relog DSL

## Syntax

### Terms

- **Variables:** `let x`. Reusing a var enforces equality, e.g. `pair(let x, let x)`.
- **Literals:** identifiers (`hello`), strings (`"hello world"`), numbers (`123`).
  - Strings use double quotes and standard escapes: `\"`, `\\`, `\n`, `\t`, `\u1234`, `\u{1F600}`.
- **Applications:** n-ary terms, e.g. `foo(bar, baz)`.
- **Multiplicity:** `* N`. Inputs need **N distinct** matching tokens. Examples:
  - `in buffer(let x) * 3`
  - `init { free slot * 3 }`
- **Guards:** `guard <term>` after input matching; the term is algebra-normalized.
  The transition fires only if it becomes `true` (multiple guards allowed).

### Algebra & Types (experimental)

> ⚠️ **Experimental**: surface and semantics may change.

- **Algebra** is an optional rewrite system with operator properties:
  - `operator f { assoc, comm, id(_), rest(let r) }`
    - Canonicalization: flattens `assoc`, drops `id(_)`, sorts `comm` args.
    - Rules: `rule lhs => rhs`. Normalization runs until fixpoint or `max_steps`.
    - AC matching uses a backtracking budget `ac_branch_budget`; if exhausted, the rule doesn’t apply.
  - **All stored tokens are normalized**. Changing algebra re-normalizes the current marking.
- **Types** (optional) annotate stores: `any | sym | int | bool | head<T...>`.
  - `sym` covers both identifiers and strings; numbers are `int`, `true/false` are `bool`.
  - Inputs check compatibility and bind var types; outputs are checked too.
  - With `grounding strict`, outputs may not introduce unbound vars (except `_`).

### Compute directives

- **`#compute(...)`** — safe built-ins (math, comparisons, booleans, strings).  
  Ground-only; returns `int | bool | string`.
  - Errors in **guards** → guard = `false`. Errors in **outputs** → step fails.
- **`#rhai("...script...", args...)`** — inline Rhai script in a sandbox.  
  Ground-only; args are available as `args` (array); returns `int | bool | string`.
  - Same error semantics as above.

Full compute reference: [docs/COMPUTE.md](./docs/COMPUTE.md)

## Samples

### Minimal net (stores + transitions)

```relog
// Stores
store produced
store free
store buf
store done

// Transitions
transition push {
  in  produced(item(let x))
  in  free(slot)
  out buf(item(let x))
}

transition pop_pair {
  in  buf(item(let y)) * 2
  out done(pair(let y, let y))
  out free(slot) * 2
}

// Init
init {
  produced item(hello)
  produced item(world) * 2
  free slot * 2
}
```

### Guards & algebra

```relog
// Stores
store produced
store free
store buf
store done

// Algebra (optional)
algebra {
  operator set { assoc, comm, id(_), rest(let r) };

  rule member(let x, set(let x, let r)) => true;
  rule member(let _, let _) => false;
}

// Transitions
transition push {
  in  produced(item(let x))
  in  free(slot)
  guard member(let x, set(hello, world))  // must normalize to `true` (if no algebra → use literal `true`)
  out buf(item(let x))
}

transition pop_pair {
  in  buf(item(let y)) * 2
  out done(pair(let y, let y))
  out free(slot) * 2
}

// Init
init {
  produced item(hello)
  produced item(world) * 2
  free slot * 2
}
```

### Typed stores

```relog
// Built-in types: any | sym | int | bool
// Parametric types: head<T1, T2, ...>

// Stores (typed)
store produced: item<sym>
store free: sym
store buf: item<sym>
store done: pair<sym, sym>

// Algebra (optional)
algebra {
  operator set { assoc, comm, id(_), rest(let r) };
  rule member(let x, set(let x, let r)) => true;
  rule member(let _, let _) => false;
}

// Transitions (type-checked)
transition push {
  in  produced(item(let x))
  in  free(slot)
  guard member(let x, set(hello, world))
  out buf(item(let x))
}

transition pop_pair {
  in  buf(item(let y)) * 2
  out done(pair(let y, let y))
  out free(slot) * 2
}

// Init (type-safe)
init {
  produced item(hello)
  produced item(world) * 2
  free slot * 2
}
```

### Compute / Rhai

```relog
store names
store out

transition greet_long {
  in  names(val(let n))
  guard #rhai("let s = args[0]; s.len() >= 3", let n)
  out  out(val(#compute(concat(let n, "!"))))
}

init {
  names val("ann")
  names val("bo")
}
```

### Configs

```relog
// Runtime config
runtime natural            // natural | reactive; default: natural
max_ticks 1000             // N; default: none
delay 0                    // N(ms); default: 0

algebra {
  max_steps 10000          // default: 10000
  ac_branch_budget 64      // default: 64
  // operator f { assoc, comm, id(_), rest(let r) };
  // rule lhs => rhs;
}

// Stores
store produced {
  capacity unbounded       // unbounded | N; default: unbounded
}
store free
store buf {
  capacity 8
}

// Transitions
transition push {
  grounding strict         // strict | skip | default("v"); default: strict
  priority 1               // N; default: 0

  // Arc in
  in produced(item(let x)) {
    mode consume           // consume | read | inhib; default: consume
  }

  // Arc in
  in free(slot)

  // Arc out
  out buf(item(let x)) {
    mode consume           // consume | reset; default: consume
  }
}

// Init
init {
  produced item(hello)
  produced item(world) * 2
  free slot * 2
}
```
