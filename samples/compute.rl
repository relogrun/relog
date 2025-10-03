store raw_scores     
store valid         
store normalized     
store rejected      

transition validate {
    in  raw_scores(score(let player, let value))
    guard #compute(and(
        #compute(gt(let value, 0)),
        #compute(le(let value, 1000))
    ))
    out valid(score(let player, let value))
}

transition reject {
    in  raw_scores(score(let player, let value))
    guard #compute(or(
        #compute(le(let value, 0)),
        #compute(gt(let value, 1000))
    ))
    out rejected(invalid(let player, let value))
    priority 5
}

transition normalize {
    in  valid(score(let player, let value))
    // value * 100 / 1000 = value / 10
    out normalized(player(
        let player,
        #compute(clamp(#compute(div(let value, 10)), 0, 100))
    ))
}

init {
    raw_scores score("alice", 850)
    raw_scores score("bob", -50)
    raw_scores score("charlie", 1200)
    raw_scores score("diana", 450)
}