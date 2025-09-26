// Multiply via repeated addition on a 2-register (Minsky) machine.
// Outer loop: while r1 != 0 { r1--; acc += r2 } with a temp register to restore r2.
// State: pc(L), r1(N), r2(M), acc(K), tmp(T) where N/M/K/T are Peano naturals.
// Program is data in `code(...)`; rules re-emit code so it persists.

store pc
store r1
store r2
store acc
store tmp
store code
store halted_r1
store halted_r2
store halted_acc

// Instruction interpreters (re-emit `code(...)`)

// INC
transition inc_r1 {
    in   pc(let L)
    in   code(inc(r1, let L, let N))
    in   r1(let x)
    out  pc(let N)
    out  r1(succ(let x))
    out  code(inc(r1, let L, let N))
}

transition inc_r2 {
    in   pc(let L)
    in   code(inc(r2, let L, let N))
    in   r2(let x)
    out  pc(let N)
    out  r2(succ(let x))
    out  code(inc(r2, let L, let N))
}

transition inc_acc {
    in   pc(let L)
    in   code(inc(acc, let L, let N))
    in   acc(let x)
    out  pc(let N)
    out  acc(succ(let x))
    out  code(inc(acc, let L, let N))
}

transition inc_tmp {
    in   pc(let L)
    in   code(inc(tmp, let L, let N))
    in   tmp(let x)
    out  pc(let N)
    out  tmp(succ(let x))
    out  code(inc(tmp, let L, let N))
}

// DECZ (zero and succ branches)
transition decz_r1_zero {
    in   pc(let L)
    in   code(decz(r1, let L, let Z, let N))
    in   r1(zero)
    out  pc(let Z)
    out  r1(zero)
    out  code(decz(r1, let L, let Z, let N))
}

transition decz_r1_succ {
    in   pc(let L)
    in   code(decz(r1, let L, let Z, let N))
    in   r1(succ(let x))
    out  pc(let N)
    out  r1(let x)
    out  code(decz(r1, let L, let Z, let N))
}

transition decz_r2_zero {
    in   pc(let L)
    in   code(decz(r2, let L, let Z, let N))
    in   r2(zero)
    out  pc(let Z)
    out  r2(zero)
    out  code(decz(r2, let L, let Z, let N))
}

transition decz_r2_succ {
    in   pc(let L)
    in   code(decz(r2, let L, let Z, let N))
    in   r2(succ(let x))
    out  pc(let N)
    out  r2(let x)
    out  code(decz(r2, let L, let Z, let N))
}

transition decz_tmp_zero {
    in   pc(let L)
    in   code(decz(tmp, let L, let Z, let N))
    in   tmp(zero)
    out  pc(let Z)
    out  tmp(zero)
    out  code(decz(tmp, let L, let Z, let N))
}

transition decz_tmp_succ {
    in   pc(let L)
    in   code(decz(tmp, let L, let Z, let N))
    in   tmp(succ(let x))
    out  pc(let N)
    out  tmp(let x)
    out  code(decz(tmp, let L, let Z, let N))
}

// GOTO
transition goto {
    in   pc(let L)
    in   code(goto(let L, let N))
    out  pc(let N)
    out  code(goto(let L, let N))
}

// HALT - capture final registers
transition halt {
    in   pc(let L)
    in   code(halt(let L))
    in   r1(let n)
    in   r2(let m)
    in   acc(let k)
    out  halted_r1(let n)
    out  halted_r2(let m)
    out  halted_acc(let k)
    out  code(halt(let L))
}

// -------- Program --------
// Labels: L0 (outer test), Ladd_test/Ladd_inc_acc/Ladd_inc_tmp (inner add),
//         Lrestore/Lrestore_inc (restore r2 from tmp), Lhalt.

init {
    // while r1 != 0 { r1--; acc += r2 }:
    code decz(r1, L0, Lhalt, Ladd_test)

    // Inner add: while r2 != 0 { r2--; acc++; tmp++; }
    code decz(r2, Ladd_test, Lrestore, Ladd_inc_acc)
    code inc(acc, Ladd_inc_acc, Ladd_inc_tmp)
    code inc(tmp, Ladd_inc_tmp, Ladd_test)

    // Restore r2: while tmp != 0 { tmp--; r2++; } then back to outer L0
    code decz(tmp, Lrestore, L0, Lrestore_inc)
    code inc(r2, Lrestore_inc, Lrestore)

    // Halt
    code halt(Lhalt)

    // Initial registers: r1 = 4, r2 = 3, acc = 0, tmp = 0
    r1  succ(succ(succ(succ(zero))))
    r2  succ(succ(succ(zero)))
    acc zero
    tmp zero

    pc  L0
}
