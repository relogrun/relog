// Forward strategy: max_cardinality(...).
// Chooses a truly maximal (by cardinality) non-conflicting set.
// Here `take_a` + `take_b` (2 firings) beat the single `big` (1 firing),
// so both small transitions fire together in one atomic step.

forward max_cardinality(64)
multi_firing unlimited

store a
store b
store big_out
store small_out

transition big {
  priority 10
  in  a(let x)
  in  b(let y)
  out big_out(pair(let x, let y))
}

transition take_a {
  priority 5
  in  a(let x)
  out small_out(a_only(let x))
}

transition take_b {
  priority 5
  in  b(let y)
  out small_out(b_only(let y))
}

init { 
  a A
  b B 
}