// Factorial as a fold over a Peano-encoded counter.
// `step` matches todo(task(succ(n))), moves to todo(task(n)),
// and multiplies the accumulator by the current value `succ(n)`.
// `finish` fires at zero and emits done(fact(acc)).
// Example: 4 = succ(succ(succ(succ(zero)))).

store todo
store acc
store done

transition step {
    in  todo(task(succ(let n)))
    in  acc(let s)
    out todo(task(let n))
    out acc(prod(let s, succ(let n)))
}

transition finish {
    in  todo(task(zero))
    in  acc(let res)
    out done(fact(let res))
}

init {
    todo task(succ(succ(succ(succ(zero)))))
    acc 1
}
