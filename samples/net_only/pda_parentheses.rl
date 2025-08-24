// PDA for balanced parentheses over {open, close}.
// Tape and stack are cons-lists; push on 'open', pop on 'close'.
// Accept iff both tape=nil and stack=nil; reject on premature 'close' or leftover opens when input ends.
// Demonstrates: PDA/CFG parsing, list patterns (cons/nil), multi-input joins.

store tape
store stack
store result

// Push on 'open'
transition push_open {
  in  tape(cons(open, let t))
  in  stack(let s)
  out tape(let t)
  out stack(cons(mark, let s))
}

// Pop on 'close' if stack non-empty
transition pop_close {
  in  tape(cons(close, let t))
  in  stack(cons(let top, let rest))
  out tape(let t)
  out stack(let rest)
}

// Reject on 'close' with empty stack
transition reject_close_empty {
  in  tape(cons(close, let t1))
  in  stack(nil)
  out result(reject)
}

// Accept when both input and stack are empty
transition accept_done {
  in  tape(nil)
  in  stack(nil)
  out result(accept)
}

// Reject when input empty but stack still has opens
transition reject_unmatched_opens {
  in  tape(nil)
  in  stack(cons(let x, let xs))
  out result(reject)
}

// "(()())" -> accept
init {
  tape
    cons(open,
      cons(open,
        cons(close,
          cons(open,
            cons(close,
              cons(close, nil)
            )
          )
        )
      )
    )
  stack nil
}