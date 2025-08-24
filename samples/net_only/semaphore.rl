// Counting semaphore using tokens as capacity.
// Each job requires 2 worker tokens; after finishing, the transition returns both tokens, so the worker pool size stays constant.
// With 4 workers and 3 tasks: first step runs two jobs in parallel, second step runs the last one, then the net becomes idle.

store workers
store tasks
store completed

transition work {
    in  workers(worker) * 2
    in  tasks(let task)
    out completed(let task)
    out workers(worker) * 2
}

init {
    workers worker * 4
    tasks job1
    tasks job2
    tasks job3
}
