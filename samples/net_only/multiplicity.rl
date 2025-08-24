// Input multiplicity (batching).
// The transition fires only when 3 matching tokens exist in `buffer`.
// From the init: `data * 3` produces `output(data)`, while `info * 2` is insufficient and remains in `buffer`.

store buffer
store output

transition process {
    in buffer(let x) * 3
    out output(let x)
}

init {
    buffer data * 3
    buffer info * 2
}