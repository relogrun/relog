// Two-stage semaphore with explicit holding across steps.
// `start` grabs capacity (2×workers) and marks the job as busy;
// `finish` completes the job and returns the same capacity back.
// This models "occupy resource while working", unlike single-step gating.

store workers
store tasks
store hold
store busy
store completed

transition start {
    in  workers(worker) * 2
    in  tasks(let t)
    out busy(let t)
    out hold(worker) * 2
}

transition finish {
    in  busy(let t)
    in  hold(worker) * 2
    out completed(let t)
    out workers(worker) * 2
}

init {
    workers worker * 4
    tasks job1
    tasks job2
    tasks job3
}
