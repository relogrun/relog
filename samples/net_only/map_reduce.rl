// Map -> pairwise reduce -> finalize.
// `map` hashes tasks into partial(...).
// `reduce_pair` merges any two partials (two inputs, distinct variables).
// `finalize` consumes the last partial and emits a single result.

store tasks
store partial
store result

transition map {
    in  tasks(let t)
    out partial(hash(let t))
}

transition reduce_pair {
    in  partial(let p1)
    in  partial(let p2)
    out partial(merge(let p1, let p2))
}

transition finalize {
    in  partial(let h)
    out result(let h)
}

init {
    tasks foo
    tasks bar
    tasks baz
    tasks qux
}
