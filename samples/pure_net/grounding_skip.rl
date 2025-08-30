// Grounding: skip.
// Ungrounded outputs are silently dropped, other outputs still happen.
// Here `a(let z)` is skipped, while `log(seen(y))` is produced and `b(y)` is consumed.

forward first_fit

store b
store a
store log

transition flop_skip {
  grounding skip
  in  b(let y)
  out a(let z)    
  out log(seen(let y))
}

init { b foo }