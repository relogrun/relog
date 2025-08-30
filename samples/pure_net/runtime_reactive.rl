// Runtime: reactive (with delay / max_ticks in DSL).
// Reactive runs steps until quiescent, then waits for external input.
// `max_ticks` acts as a safety stop for demos/tests.
// With `a hello * 3` and default multi-firing (unlimited), all three
// `move` instances fire in a single atomic step.

runtime reactive
max_ticks 10
delay 250

store a
store b

transition move {
  in  a(let x)
  out b(let x)
}

init { a hello * 3 }