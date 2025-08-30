// Producer–buffer–consumer with a fixed-size buffer.
// `slot` tokens act as a counting semaphore for capacity: produce requires a slot and transfers it to `buf(item(x))`; consume returns a slot to `free_slots`.
// Invariant: |free_slots| + |buf| == capacity.

store free_slots
store buf
store produced
store consumed

transition produce {
    in  produced(item(let x))
    in  free_slots(slot)
    out buf(item(let x))
}

transition consume {
    in  buf(item(let y))
    out consumed(item(let y))
    out free_slots(slot)
}

init {
    produced item(1)
    produced item(2)
    produced item(3)
    free_slots slot * 2 // buffer holds two items max
}
