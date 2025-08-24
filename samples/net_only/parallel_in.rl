// Internal parallelism.
// Two identical tokens start in `a`. With unlimited multi-firing, both enabled instances of each transition fire atomically in one step. After three steps both tokens are back in `a`.

store a
store b
store c

transition move_a_to_b {
	in a(let x)
	out b(let x)
}

transition move_b_to_c {
	in b(let x)
	out c(let x)
}

transition move_c_to_a {
	in c(let x)
	out a(let x)
}

init {
	a hello * 2
}