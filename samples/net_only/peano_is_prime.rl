// Prime checker sketch: try dividing N by all d=2..N-1 via repeated subtraction.
// If exact division is found -> not prime; if all divisors exhausted -> prime.

store number      // The number to check (Peano)
store divisor     // Current divisor being tested
store remainder   // Current remainder during division
store temp        // Counts how many subtractions done for this divisor
store is_prime    // yes | no

// One subtraction step: (remainder, divisor) -> (remainder-1, same divisor), temp++
transition divide_step {
  in  remainder(succ(let r))
  in  divisor(succ(let d))
  in  temp(let t)
  out remainder(let r)
  out divisor(succ(let d))
  out temp(succ(let t))
}

// Exact division hit (remainder==0, divisor>=2) -> composite.
transition found_divisor {
  in  remainder(zero)
  in  divisor(succ(succ(let d)))  // d >= 2
  out is_prime(no)
}

// Non-exact (remainder still > 0) and finished scanning one divisor -> try next.
transition next_divisor {
  in  remainder(succ(let r))
  in  divisor(zero)
  in  number(let n)
  in  temp(succ(succ(let next_d)))
  out remainder(let n)                     // reset remainder to N
  out divisor(succ(succ(let next_d)))      // move to next divisor
  out number(let n)
  out temp(zero)
}

// No divisor found up to n-1 -> prime.
transition confirmed_prime {
  in  number(succ(let n))
  in  temp(let n)   // scanned up to n-1
  out is_prime(yes)
}

// Example: check 7 (expected: yes)
init {
  number    succ(succ(succ(succ(succ(succ(succ(zero)))))))  // 7
  divisor   succ(succ(zero))    // 2
  remainder succ(succ(succ(succ(succ(succ(succ(zero)))))))  // 7
  temp      zero
}
