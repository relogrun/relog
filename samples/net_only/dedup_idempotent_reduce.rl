// Idempotent reducer.
// Any duplicates are collapsed by a local rule: out(v) * 2 -> out(v).
// No matter the interleaving or parallelism, the final marking has exactly one token per distinct value.

store inbox
store out

// Fan-in: forward every incoming item to the 'out' bag.
transition forward {
  in  inbox(let x)
  out out(let x)
}

// Idempotent contraction: pairwise collapse duplicates.
// Repeatedly reduces multiplicity to 1.
transition dedup_pair {
  in  out(let v) * 2
  out out(let v)
}

init {
  inbox A
  inbox A
  inbox A
  inbox B
  inbox B
  inbox C
}
