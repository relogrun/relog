// Unification showcase: three core patterns in one miniature net.
// Repeated variable inside a single term - forces equality of fields:
//      s(pair(x, x)) -> out(eq(x))
// Shared variable across two inputs (equi-join):
//      a(val(x)) & b(val(x)) -> out(join(x))
// Deep structural match with a repeated variable: n(foo(bar(x), x)) -> out(nested(x))
// Non-matching facts stay in their stores so you can observe both positives and negatives.

store s
store a
store b
store n
store out

// pair(x, x) enforces equality of both arguments.
transition eq_pair {
  in  s(pair(let x, let x))
  out out(eq(let x))
}

// Equi-join on x between a(...) and b(...).
transition join_ab {
  in  a(val(let x))
  in  b(val(let x))
  out out(join(let x))
}

// Deep structural match with variable reuse.
transition nested {
  in  n(foo(bar(let x), let x))
  out out(nested(let x))
}

init {
  // For eq_pair:
  s pair(A, A)          // will match
  s pair(A, B)          // will NOT match
  s triple(A, A, A)     // different functor/arity - will NOT match

  // For join_ab:
  a val(42); b val(42)  // will match
  a val(7)              // left over
  b val(9)              // left over

  // For nested:
  n foo(bar(hello), hello)   // will match
  n foo(bar(hello), world)   // will NOT match
}
