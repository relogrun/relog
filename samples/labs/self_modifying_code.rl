// Self-modifying "program as data": after K iterations, patch a goto target.
// We keep code in `code(...)` and interpret it; a patch transition replaces
// code(goto(from, old)) with code(goto(from, new)) — no net rebuilding needed.

store pc
store k // countdown
store r2 // will be incremented K times
store code
store halted_r2

// interpreters (re-emit code to keep it persistent)
transition inc_r2 {
  in  pc(let L)
  in  code(inc(r2, let L, let N))
  in  r2(let x)
  out pc(let N)
  out r2(succ(let x))
  out code(inc(r2, let L, let N))
}

transition decz_k_zero {
  in  pc(let L)
  in  code(decz(k, let L, let Z, let N))
  in  k(zero)
  out pc(let Z)
  out k(zero)
  out code(decz(k, let L, let Z, let N))
}

transition decz_k_succ {
  in  pc(let L)
  in  code(decz(k, let L, let Z, let N))
  in  k(succ(let x))
  out pc(let N)
  out k(let x)
  out code(decz(k, let L, let Z, let N))
}

transition goto {
  in  pc(let Lfrom)
  in  code(goto(let Lfrom, let Lto))
  out pc(let Lto)
  out code(goto(let Lfrom, let Lto))
}

// self-modifying patch: rewrite goto(from, old) -> goto(from, new)
transition patch_goto {
  in  pc(let Lpatch)
  in  code(patch_goto(let Lpatch, let from, let new_to, let cont))
  in  code(goto(let from, let old))
  out pc(let cont)
  out code(goto(let from, let new_to)) // write patched goto
}

// Halt (just to observe result)
transition halt {
  in  pc(let L)
  in  code(halt(let L))
  in  r2(let m)
  out halted_r2(let m)
  out code(halt(let L))
}

// program
// L0: if k==0 -> LPatch else -> L1
// L1: inc r2 ; goto L1_go
// L1_go: goto L0    (will be patched to goto Lhalt)
// LPatch: rewrite goto(L1_go, L0) -> goto(L1_go, Lhalt), then jump to L1_go
// Lhalt: halt

init {
  code decz(k, L0, LPatch, L1)
  code inc(r2, L1, L1_go)
  code goto(L1_go, L0)

  code patch_goto(LPatch, L1_go, Lhalt, L1_go)
  code halt(Lhalt)

  // example: K=3, r2 starts at 2 -> final r2 = 5
  k  succ(succ(succ(zero))) // 3
  r2 succ(succ(zero)) // 2
  pc L0
}
