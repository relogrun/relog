// Grounding: strict.
// Any ungrounded output is an error (e.g. `out a(let z)` with `z` unbound).
// The step aborts with: "Ungrounded term ... in store `a`".

forward greedy

store b
store a

transition flop_strict {
  grounding strict
  in  b(let y)
  out a(let z)  
}

init { b foo }