// Two opposite moves. `flop` leaves `z` unbound and relies on default grounding to fill it.
// Check the logs to see the error.

store a
store b

transition flip {
    in  a(let x)
    out b(let x)
}

transition flop {
    in  b(let y)
    out a(let z) // unbound -> default value if strategy = Default("undef")
}

init { 
	a hello 
}
