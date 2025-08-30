// Priority tie-break.
// Two transitions compete for the same `inbox(msg(x))` token.
// The higher `priority` wins: `hi` (prio 10) fires instead of `lo` (prio 0).

forward first_fit

store inbox
store route

transition hi {
  priority 10
  in  inbox(msg(let x))
  out route(hi(let x))
}

transition lo {
  priority 0
  in  inbox(msg(let x))
  out route(lo(let x))
}

init { inbox msg(42) }