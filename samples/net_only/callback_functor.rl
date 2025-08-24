// Carries the `function` name as data: requests call(f, arg) becomes responses result(f, arg). 
// Demonstrates higher-order style via structural pattern matching (no actual execution).

store requests
store responses

transition call {
    in  requests(call(let f, let arg))
    out responses(result(let f, let arg))
}

init {
    requests call(double, 21)
    requests call(inc, 99)
}
