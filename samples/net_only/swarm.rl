// Swarm demo: two agents on a tiny graph bring food back to base.
// Graph: N1 <-> N0 <-> N2; base is N0; one food at N1 and one at N2.

store agent_at     // at(agent, node)
store edge         // edge(from, to) — directed; kept persistent by re-emitting
store base         // at(node) — base location (single node)
store steps        // steps(agent, peano) — movement budget per agent
store food         // at(node) — one token per food unit
store carrying     // carrying(agent) — agent is carrying one unit
store delivered    // item(agent) — proof that agent delivered a unit

// Move an idle agent to an adjacent node that has food (non-destructive read of food).
transition scout_to_adjacent_food {
  in  agent_at(at(let a, let x))
  in  steps(steps(let a, succ(let k)))
  in  edge(edge(let x, let y))
  in  food(at(let y))
  out agent_at(at(let a, let y))
  out steps(steps(let a, let k))
  out edge(edge(let x, let y))     // keep the graph persistent
  out food(at(let y))              // DO NOT consume food on scouting
}

// Pick up food at the current node (preserve agent position).
transition pickup_food {
  in  agent_at(at(let a, let x))
  in  food(at(let x))
  out carrying(let a)
  out agent_at(at(let a, let x))   // re-emit position (non-destructive read)
}

// While carrying, move one hop towards base (must be a direct neighbor).
transition return_step_to_base {
  in  agent_at(at(let a, let x))
  in  steps(steps(let a, succ(let k)))
  in  carrying(let a)
  in  base(at(let b))
  in  edge(edge(let x, let b))
  out agent_at(at(let a, let b))
  out steps(steps(let a, let k))
  out carrying(let a)              // keep carrying until delivered
  out base(at(let b))              // persist base fact
  out edge(edge(let x, let b))     // persist edge
}

// Deliver at base: drop the carried item.
transition deliver_at_base {
  in  agent_at(at(let a, let b))
  in  base(at(let b))
  in  carrying(let a)
  out delivered(item(let a))
  out agent_at(at(let a, let b))   // stay at base
  out base(at(let b))              // persist base
}

// World: N1 <-> N0 <-> N2; base at N0; two agents at N0; budgets = 2 steps each.
init {
  edge edge(N0, N1)
  edge edge(N1, N0)
  edge edge(N0, N2)
  edge edge(N2, N0)

  base at(N0)

  agent_at at(a1, N0)
  agent_at at(a2, N0)

  steps steps(a1, succ(succ(zero)))
  steps steps(a2, succ(succ(zero)))

  food  at(N1)
  food  at(N2)
}
