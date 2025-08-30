// Store capacity (bounded) + atomic validation.
// `store q { capacity 2 }`: if a step would push `q` over capacity,
// the whole step is rejected (no state change) and an error is emitted.
// Here `q` is already 2/2; `enqueue` would make it 3/2 → capacity error.

forward greedy

store q { capacity 2 }
store new
store ok

transition enqueue {
  in  new(let x)
  out q(let x)
  out ok(enqueued(let x))
}

init {
  q item(A)
  q item(B)
  new item(C)  
}