// Fires only when a(let v) and b(let v) carry the same literal.
// From init: only v=42 matches; 17 and 99 do not.

store a
store b
store common

transition merge_equal {
    in  a(let v)
    in  b(let v)
    out common(let v)
}

init {
    a 42
    b 42
    a 17
    b 99
}
