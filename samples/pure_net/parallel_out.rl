// External parallelism.
// Two independent transitions consume from disjoint stores and fire together in one atomic step.

store a
store b
store x
store y

transition move_a_b {
	in a(let p)
	out b(let p)
}

transition move_x_y {
	in x(let q)
	out y(let q)
}

init {
	a hello
	x world
}