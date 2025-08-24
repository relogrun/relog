// Two-register (Minsky) machine encoded in the net.
// State: pc(L), r1(N), r2(M) with Peano naturals: zero | succ(...).
// The program is data in `code(...)`. Each instruction is fired by matching pc.
// We re-emit the matched `code(...)` fact to keep the program persistent.
//
// Instruction schema (as data):
//   code(inc(Reg, L, Lnext))                  -- Reg ∈ {r1, r2}
//   code(decz(Reg, L, Lzero, Lnext))          -- if Reg==zero goto Lzero else dec(Reg) & goto Lnext
//   code(goto(L, Lnext))
//   code(halt(L))
//
// Demo program (labels: L0, L1, Lhalt):
//   L0: decz r1, Lhalt, L1
//   L1: inc  r2, L0
//   Lhalt: halt
//
// Semantics: while r1 != 0 { r1--; r2++; } then halt. So final r1=0, r2=r2+old(r1).

store pc
store r1
store r2
store code
store halted_r1
store halted_r2

// Dispatcher for each instruction kind (re-emit code)

// INC r1
transition inc_r1 {
  in  pc(let L)
  in  code(inc(r1, let L, let Lnext))
  in  r1(let n)
  out pc(let Lnext)
  out r1(succ(let n))
  out code(inc(r1, let L, let Lnext))
}

// INC r2
transition inc_r2 {
  in  pc(let L)
  in  code(inc(r2, let L, let Lnext))
  in  r2(let m)
  out pc(let Lnext)
  out r2(succ(let m))
  out code(inc(r2, let L, let Lnext))
}

// DECZ r1 — zero branch
transition decz_r1_zero {
  in  pc(let L)
  in  code(decz(r1, let L, let Lzero, let Lnext))
  in  r1(zero)
  out pc(let Lzero)
  out r1(zero)
  out code(decz(r1, let L, let Lzero, let Lnext))
}

// DECZ r1 — succ branch
transition decz_r1_succ {
  in  pc(let L)
  in  code(decz(r1, let L, let Lzero, let Lnext))
  in  r1(succ(let n))
  out pc(let Lnext)
  out r1(let n)
  out code(decz(r1, let L, let Lzero, let Lnext))
}

// DECZ r2 — zero branch
transition decz_r2_zero {
  in  pc(let L)
  in  code(decz(r2, let L, let Lzero, let Lnext))
  in  r2(zero)
  out pc(let Lzero)
  out r2(zero)
  out code(decz(r2, let L, let Lzero, let Lnext))
}

// DECZ r2 — succ branch
transition decz_r2_succ {
  in  pc(let L)
  in  code(decz(r2, let L, let Lzero, let Lnext))
  in  r2(succ(let m))
  out pc(let Lnext)
  out r2(let m)
  out code(decz(r2, let L, let Lzero, let Lnext))
}

// GOTO
transition goto {
  in  pc(let L)
  in  code(goto(let L, let Lnext))
  out pc(let Lnext)
  out code(goto(let L, let Lnext))
}

// HALT — capture final registers into separate stores
transition halt {
  in  pc(let L)
  in  code(halt(let L))
  in  r1(let n)
  in  r2(let m)
  out halted_r1(let n)
  out halted_r2(let m)
  out code(halt(let L))
}

// Program & initial state

// Program:
//   L0: decz r1, Lhalt, L1
//   L1: inc  r2, L0
//   Lhalt: halt
init {
  code decz(r1, L0, Lhalt, L1)
  code inc(r2, L1, L0)
  code halt(Lhalt)

  // Initial registers: r1 = 3, r2 = 2
  r1 succ(succ(succ(zero)))
  r2 succ(succ(zero))

  // Start at L0
  pc L0
}
