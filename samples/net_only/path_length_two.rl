// Infers a 2-hop path from two edges that share the middle vertex: edges(u,v) & edges(v,w) -> path2(u,w). 
// Demonstrates two inputs from the same store with a shared variable (`let v`), i.e., a fan-in join.

store edges
store path2

transition step2 {
    in  edges(pair(let u, let v))
    in  edges(pair(let v, let w))
    out path2(pair(let u, let w))
}

init {
    edges pair(A, B)
    edges pair(B, C)
    edges pair(A, C)
}
