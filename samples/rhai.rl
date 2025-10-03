store raw_scores
store valid
store normalized
store rejected

transition validate {
    in  raw_scores(score(let player, let value))
    // args[0] = player, args[1] = value
    guard #rhai("args[1] > 0 && args[1] <= 1000", let player, let value)
    out valid(score(let player, let value))
}

transition reject {
    in  raw_scores(score(let player, let value))
    guard #rhai("args[1] <= 0 || args[1] > 1000", let player, let value)
    out rejected(invalid(let player, let value))
    priority 5
}

transition normalize {
    in  valid(score(let player, let value))
    // clamp(value / 10, 0..100)
    out normalized(player(
        let player,
        #rhai("let v = args[0] / 10; if v < 0 { 0 } else if v > 100 { 100 } else { v }", let value)
    ))
}

init {
    raw_scores score("alice", 850)
    raw_scores score("bob", -50)
    raw_scores score("charlie", 1200)
    raw_scores score("diana", 450)
}