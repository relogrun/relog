// Triangular number T(n) = 1 + 2 + ... + n in Peano arithmetic.
// Each step adds the current counter to the running sum.

store counter   // Counts from n down to 0
store sum       // Accumulates the sum
store result    // Final result

transition add_step {
    in   counter(succ(let n))
    in   sum(let s)
    out  counter(let n)
    out  sum(sum(succ(let n), let s))
}

transition finish {
    in   counter(zero)
    in   sum(let s)
    out  result(let s)
}

// Normalize nested sums in `sum(...)`.
transition add_zero_l {
    in   sum(sum(zero, let x))
    out  sum(let x)
}

transition add_zero_r {
    in   sum(sum(let x, zero))
    out  sum(let x)
}

transition add_succ_l {
    in   sum(sum(succ(let a), let b))
    out  sum(succ(sum(let a, let b)))
}

transition add_succ_r {
    in   sum(sum(let a, succ(let b)))
    out  sum(succ(sum(let a, let b)))
}

// Example: T(5) = 15
init {
    counter succ(succ(succ(succ(succ(zero)))))  // 5
    sum     zero
}
