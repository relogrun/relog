// Splits inbox messages by shape: error(...) -> errors, ok(...) -> data.
// Demonstrates structural pattern matching and that multiple independent instances can fire together in a single atomic step.

store inbox
store errors
store data

transition classify_error {
    in  inbox(error(let e))
    out errors(let e)
}

transition classify_ok {
    in  inbox(ok(let x))
    out data(let x)
}

init {
    inbox error(broken_pipe)
    inbox ok(42)
    inbox ok(99)
}
