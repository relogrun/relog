// DFA recognizer over {a,b}: accept strings with an even number of 'a'.
// Tape is a cons-list; the transition table is data in `delta`; accepting/rejecting classes are data in `class`.
// Demonstrates data-driven state machines, multi-store joins, and non-destructive rule lookup by re-emitting facts.

// Stores
store tape     // cons(symbol, tail) ... or nil
store state    // current DFA state (q0/q1)
store delta    // transition table: delta(q, sym, q2)
store class    // class(q, accept|reject)
store result   // final decision

// One DFA step: read the head symbol and move to the next state.
// Important: re-emit the used delta(...) so the table remains available.
transition step {
  in  tape(cons(let h, let t))
  in  state(let q)
  in  delta(delta(let q, let h, let q2))
  out tape(let t)
  out state(let q2)
  out delta(delta(let q, let h, let q2))
}

// Decide on empty tape. Re-emit class(...) so the class map persists.
transition done {
  in  tape(nil)
  in  state(let q)
  in  class(class(let q, let c))
  out result(let c)
  out class(class(let q, let c))
}

// Transition table and classes for "even number of a".
// q0: accept, q1: reject. Start in q0.
init {
  // delta-transitions
  delta delta(q0, a, q1)
  delta delta(q0, b, q0)
  delta delta(q1, a, q0)
  delta delta(q1, b, q1)

  // accepting / rejecting states
  class class(q0, accept)
  class class(q1, reject)

  // Example input: "abba" -> even # of 'a' -> accept
  tape  cons(a, cons(b, cons(b, cons(a, nil))))
  state q0
}
