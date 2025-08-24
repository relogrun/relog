// Duplicate-and-consume pairing.
// `produce` duplicates each `source(x)` into two `buffer(x)` tokens;
// `consume` takes pairs `buffer(x) * 2` and emits `sink(x)`.
// Net effect: one `sink(x)` per `source(x)`, with no leftovers.

store source
store buffer
store sink

transition produce {
    in source(let x)
    out buffer(let x) * 2
}

transition consume {
    in buffer(let x) * 2
    out sink(let x)
}

init {
    source task1
    source task2
    source task3
}