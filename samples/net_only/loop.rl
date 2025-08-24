store a
store b

transition fwd {
    in a(let x)
    out b(let x)
}

transition back {
    in b(let x)
    out a(let x)
}

init {
    a hello
}
