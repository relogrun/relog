algebra {
  operator sum { comm, assoc, id(0) }

  operator eq {}
  rule eq(let x, let x) => true
  rule eq(let _, let _) => false
}

store x: int
store y: int 
store z: int 
store out: sym

transition t {
  in x(let x)
  in y(let y)
  in z(let z)
  guard eq(sum(let x, sum(let y, 0)), sum(let y, let z))
  out Out(ok)
}

init { z 10; y 5; z 10 }