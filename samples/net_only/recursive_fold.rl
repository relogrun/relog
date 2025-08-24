// Folds a cons-list while threading an accumulator.
// `step` rewrites list(cons(head, tail)) and updates acc -> sum(acc, head).
// `finish` fires at list(nil) and emits done(total(acc)).
// With cons(1, cons(2, cons(3, nil))) and acc 0, the final token is
// done(total(sum(sum(sum(0, 1), 2), 3))).

store list
store acc
store done

transition step {
    in  list(cons(let head, let tail))
    in  acc(let s)
    out list(let tail)
    out acc(sum(let s, let head))
}

transition finish {
    in  list(nil)
    in  acc(let s)
    out done(total(let s))
}

init {
    list cons(1, cons(2, cons(3, nil)))
    acc 0
}
