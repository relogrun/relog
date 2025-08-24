// Demonstrates that input multiplicity requires *distinct* token instances.
// Two identical tokens s(A), s(A) allow one firing: take_two: in s(x) * 2 -> out out(x)
// Attempting to satisfy * 2 with only one s(A) is not enabled (no reuse).

store s
store out

transition take_two {
    in  s(let x) * 2
    out out(let x)
}

init {
    s A
    s A
}
