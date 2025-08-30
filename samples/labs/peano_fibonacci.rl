// Fibonacci sequence in Peano arithmetic.
// fib(0) = 0, fib(1) = 1, and fib(n+2) = fib(n) + fib(n+1).
// Normalization rules on `next(...)` turn sums into successor chains.

store counter   // Counts down from N to 0
store current   // fib(i)
store next      // fib(i+1)
store result    // Final result

// Advance to next pair (i -> i+1).
transition fib_step {
    in   counter(succ(succ(let n)))
    in   current(let a)
    in   next(let b)
    out  counter(succ(let n))
    out  current(let b)
    out  next(sum(let a, let b))
}

// Base cases.
transition fib_finish_at_one {
    in   counter(succ(zero))
    in   current(let a)
    in   next(let b)
    out  counter(zero)
    out  result(let b)
}

transition fib_finish_at_zero {
    in   counter(zero)
    in   current(let a)
    out  result(let a)
}

// Normalize sum in `next(...)`.
transition add_zero_l {
    in   next(sum(zero, let x))
    out  next(let x)
}

transition add_zero_r {
    in   next(sum(let x, zero))
    out  next(let x)
}

transition add_succ_l {
    in   next(sum(succ(let a), let b))
    out  next(succ(sum(let a, let b)))
}

transition add_succ_r {
    in   next(sum(let a, succ(let b)))
    out  next(succ(sum(let a, let b)))
}

// Example: compute fib(7) = 13
init {
    counter succ(succ(succ(succ(succ(succ(succ(zero)))))))
    current zero
    next    succ(zero)
}
