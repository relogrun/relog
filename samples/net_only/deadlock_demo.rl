// Natural quiescence (not an error): the transition needs two workers per task.
// With only 2 workers and 1 task, exactly one completion happens, workers are returned, and no transitions remain enabled.

store workers
store tasks
store completed

transition work {
    in  workers(worker) * 2
    in  tasks(let t)
    out completed(let t)
    out workers(worker) * 2
}

init {
    workers worker * 2
    tasks job1
}
