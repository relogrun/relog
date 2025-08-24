// Burst-and-batch: 7×increment run in one step (parallel), producing 7 counters.
// Next step, collect consumes 5 at once -> result(batch), leaving 2 counters.
// Also shows that batching cannot “chain” within the same atomic step.

store counter
store trigger
store result

transition increment {
    in trigger(tick)
    out counter(count)
}

transition collect {
    in counter(count) * 5
    out result(batch)
}

init {
    trigger tick * 7
}