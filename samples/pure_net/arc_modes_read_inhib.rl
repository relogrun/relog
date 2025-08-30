// Input arc modes: read and inhib.
// - read: requires presence but does not consume (lock stays).
// - inhib: requires absence of any matching token (blocks if present).
// `start_when_locked` uses read on `lock(token)`.
// `spawn_when_idle` uses inhib on `running(_)`.
// Result: `running(task1)` starts; `task2` stays queued while something runs.


forward greedy

store lock
store queue
store jobs
store running

transition start_when_locked {
  in  jobs(let x)
  in  lock(token) { mode read }
  out running(let x)
}

transition spawn_when_idle {
  in  queue(let x)
  in  running(let _) { mode inhib }
  out jobs(let x)
}

init {
  lock token
  queue task1
  queue task2
}