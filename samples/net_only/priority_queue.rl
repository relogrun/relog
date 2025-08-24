// Routes by wrapper shape: prio(high|medium|low, job).

store queue
store high
store low
store medium

transition take_high {
    in  queue(prio(high, let job))
    out high(let job)
}

transition take_low {
    in  queue(prio(low, let job))
    out low(let job)
}

transition take_medium {
    in  queue(prio(medium, let job))
    out medium(let job)
}

init {
    queue prio(low,  task_A)
    queue prio(high, task_B)
    queue prio(low,  task_C)
	queue prio(medium, task_D)
}
