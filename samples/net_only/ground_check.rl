// Intentionally inserts a non-ground token in init (loop f(let y)).
// The engine enforces ground-only state, so initialization fails with StateError::NonGroundTerm. 
// Check the logs to see the error.

store loop

transition bad {
    in  loop(let x)
    out loop(f(let x))
}

init {
    loop f(let y)   // non-ground -> rejected
}
