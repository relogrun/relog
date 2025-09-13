# Relog DSL

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

// Built-in sorts: any | sym | int | bool
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

### Configs

```relog
// Net / runtime configs
forward first_fit          // first_fit | max_cardinality(N); default: first_fit
multi_firing unlimited     // unlimited | limited(N) | disabled; default: unlimited
runtime natural            // natural | reactive; default: natural
max_ticks 1000             // N; default: none
delay 0                    // N(ms); default: 0

// Algebra configs 
algebra {
  max_steps 10000          // default: 10000
  ac_branch_budget 64      // default: 64
  // operator f { assoc, comm, id(_), rest(let r) };
  // rule lhs => rhs;
}

// Stores
store produced {
  // Store configs
  capacity unbounded       // unbounded | N; default: unbounded
}
store free
store buf {
  capacity 8
}

// Transitions
transition push {
  // Transition configs
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
