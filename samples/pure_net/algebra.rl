algebra {
  operator sum { comm, assoc, id(0) }

  operator eq {}
  rule eq(let X, let X) => true
  rule eq(let _, let _) => false
}

store X: int
store Y: int 
store Z: int 
store Out: sym

transition t {
  in X(let x)
  in Y(let y)
  in Z(let z)
  guard eq(sum(let x, sum(let y, 0)), sum(let y, let z))
  out Out(ok)
}

init { X 10; Y 5; Z 10 }