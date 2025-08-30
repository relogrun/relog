// Multi-firing: limited(1).
// At most one instance per transition may fire per tick.
// The `drain` transition moves at most one token from `a` to `out` per step.
// Switching to `unlimited` would drain all tokens in one step.

forward first_fit
multi_firing limited(1)

store a
store out

transition drain {
  in  a(let x)
  out out(let x)
}

init {
  a t1
  a t2
  a t3
  a t4
}