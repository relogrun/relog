// Grounding: default("undef").
// Ungrounded outputs are replaced with the given constant.
// Here `a(let z)` becomes `a(undef)`.

forward first_fit

store b
store a

transition flop_default {
  grounding default("undef")
  in  b(let y)
  out a(let z)      
}

init { b foo }