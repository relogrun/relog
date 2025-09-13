forward max_cardinality(64)
multi_firing unlimited

store s
store ok

transition take_both {
  priority 1
  in  s(a)
  in  s(b)
  out ok(both)
}

transition take_a {
  in  s(a)
  out ok(a)
}

transition take_b {
  in  s(b)
  out ok(b)
}

init { s a; s b }