```relog
// Net / runtime configs
forward first_fit          // first_fit (default) | max_cardinality(N)
multi_firing unlimited     // unlimited (default) | limited(N) | disabled
runtime natural            // natural (default) | reactive
max_ticks 1000             // N (default: none)
delay 0                    // N(ms) (default: 0)

// Stores
store produced {
    // Store configs
    capacity unbounded       // unbounded (default) | N
}
store free 
store buf {
    capacity 8              
}

// Transitions
transition push {
    // Transition configs
    grounding strict         // strict (default) | skip | default("v")
    priority 1               // N (default: 0)

    // Arc in
    in produced(item(let x)) {
        mode consume           // consume (default) | read | inhib
    }

    // Arc in
    in free(slot)

    // Arc out
    out buf(item(let x)) {
        mode consume           // consume (default) | reset
    }
}

// Init
init {
    produced item(hello)
    produced item(world) * 2
    free slot * 2
}
```