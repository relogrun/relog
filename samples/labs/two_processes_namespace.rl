// Two independent processes (pA, pB) run the same program in parallel (namespaced via proc(p, ...)):
// while r1 != 0 { r1--; r2++; } then halt.

store pc
store r1
store r2
store code
store halted_r1
store halted_r2

// INC r2 for process p
transition inc_r2 {
  in  pc(proc(let p, let L))
  in  code(inc(r2, let L, let N))
  in  r2(proc(let p, let x))
  out pc(proc(let p, let N))
  out r2(proc(let p, succ(let x)))
  out code(inc(r2, let L, let N))
}

// DECZ r1 - zero
transition decz_r1_zero {
  in  pc(proc(let p, let L))
  in  code(decz(r1, let L, let Z, let N))
  in  r1(proc(let p, zero))
  out pc(proc(let p, let Z))
  out r1(proc(let p, zero))
  out code(decz(r1, let L, let Z, let N))
}

// DECZ r1 - succ
transition decz_r1_succ {
  in  pc(proc(let p, let L))
  in  code(decz(r1, let L, let Z, let N))
  in  r1(proc(let p, succ(let n)))
  out pc(proc(let p, let N))
  out r1(proc(let p, let n))
  out code(decz(r1, let L, let Z, let N))
}

// HALT - snapshot per process
transition halt {
  in  pc(proc(let p, let L))
  in  code(halt(let L))
  in  r1(proc(let p, let n))
  in  r2(proc(let p, let m))
  out halted_r1(proc(let p, let n))
  out halted_r2(proc(let p, let m))
  out code(halt(let L))
}

// Program: while r1 != 0 { r1--; r2++; }
init {
  code decz(r1, L0, Lhalt, L1)
  code inc(r2, L1, L0)
  code halt(Lhalt)

  // Process pA: r1=2, r2=5 -> r2=7
  r1 proc(pA, succ(succ(zero)))
  r2 proc(pA, succ(succ(succ(succ(succ(zero))))))
  pc proc(pA, L0)

  // Process pB: r1=3, r2=1 -> r2=4
  r1 proc(pB, succ(succ(succ(zero))))
  r2 proc(pB, succ(zero))
  pc proc(pB, L0)
}
