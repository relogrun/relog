// Infinite id stream: each step consumes seed next(n), emits two id_pool id(n), and advances the seed to next(succ(n)). After k steps you have ids for 0..k-1 (each duplicated) and the seed at next(succ^k(0)).

store seed
store id_pool

transition split {
    in  seed(next(let n))
    out id_pool(id(let n)) * 2
    out seed(next(succ(let n)))
}

init {
    seed next(0)
}
