// Forward strategy: first_fit.
// Competing transitions share the same tokens. Takes a single
// highest-priority compatible set — here the `big` transition wins,
// so only `big` fires in one atomic step (a + b -> big_out(pair(...))).

forward first_fit
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
