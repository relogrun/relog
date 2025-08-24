// Nested matching: extracts name from user(id, name(n), age(a)).
// Two independent records -> two firings in one step.

store raw_users
store names

transition extract_name {
    in  raw_users(user(let id, name(let n), age(let a)))
    out names(name(let id, let n))
}

init {
    raw_users user(1, name(Ann), age(30))
    raw_users user(2, name(Bob), age(25))
}
