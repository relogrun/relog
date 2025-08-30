// Output arc mode: reset.
// Clears *all* tokens from the target store atomically within the step,
// before adding other outputs (capacity is validated on the final state).
// `flush_all` consumes `flushed(go)`, wipes `buf`, then emits `flushed(done)`.

forward first_fit

store buf
store input
store flushed

transition fill {
  in  input(let x)
  out buf(let x)
}

transition flush_all {
  in  flushed(go)
  out buf(let _) { mode reset }
  out flushed(done)
}

init {
  buf item(A)
  buf item(B)
  flushed go
}