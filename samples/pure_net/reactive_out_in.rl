// "System calls" via stores: emit to the outside through `io_tx` (durable outbox), accept external responses on `io_rx`, correlate with `inflight`, and log results.
//
// Demonstrates: boundary I/O pattern, request/response correlation by unification, durable outbox, append-only log.

store outbox     // app-enqueued commands
store inflight   // pending requests (for correlation)
store io_tx      // outbound "syscalls" visible to the outside
store io_rx      // inbound responses coming from the outside
store log        // append-only log of completed ops

// Emit a command to the outside and remember it as inflight.
transition send {
  in  outbox(cmd(let x))
  out io_tx(send(let x))
  out inflight(pending(let x))
}

// When a matching reply arrives, complete and log.
transition apply_reply {
  in  io_rx(reply(let x))
  in  inflight(pending(let x))
  out log(done(let x))
}

// Example: two requests, two matching replies.
init {
  outbox cmd(ping1)
  outbox cmd(ping2)

  // Simulate external world answering:
  io_rx reply(ping1)
  io_rx reply(ping2)
}
