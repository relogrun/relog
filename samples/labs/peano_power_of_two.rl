// Compute 2^n by repeated doubling in Peano arithmetic.
// `double` does: result := result + result; normalization flattens sums.

store counter  // Counts down from N
store result   // Current power of 2

transition double {
    in   counter(succ(let n))
    in   result(let x)
    out  counter(let n)
    out  result(sum(let x, let x))
}

// Normalize sum in `result(...)`.
transition add_zero_l {
    in   result(sum(zero, let x))
    out  result(let x)
}

transition add_zero_r {
    in   result(sum(let x, zero))
    out  result(let x)
}

transition add_succ_l {
    in   result(sum(succ(let a), let b))
    out  result(succ(sum(let a, let b)))
}

transition add_succ_r {
    in   result(sum(let a, succ(let b)))
    out  result(succ(sum(let a, let b)))
}

// Example: 2^4 = 16
init {
    counter succ(succ(succ(succ(zero))))
    result  succ(zero)  // 1
}
