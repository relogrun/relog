// Refund/Payout — At-Most-Once (pure tokens, no guards)
// At-most-once payouts via a one-time permit and duplicate drain: first attempt proceeds, retries queue but can’t re-execute, success drains leftovers. 

store req
store pending
store once

store reserved
store inflight
store paid
store released

store io_tx
store io_rx
store timeout

store duplicates
store log

transition enqueue {
  in  req(request(let id, let acct, let amt))
  out pending(request(let id, let acct, let amt))
  out log(event(request_enqueued(let id)))
}

transition start_payout {
  in  pending(request(let id, let acct, let amt))
  in  once(key(let id))
  out reserved(hold(let id, let acct, let amt))
  out inflight(tx(let id, let acct, let amt))
  out io_tx(send(tx(let id, let acct, let amt)))
  out log(event(payout_started(let id)))
}

transition payout_ack {
  in  io_rx(ack(tx(let id, let acct, let amt)))
  in  inflight(tx(let id, let acct, let amt))
  in  reserved(hold(let id, let acct, let amt))
  out paid(receipt(let id))
  out log(event(payout_succeeded(let id)))
}

transition payout_timeout {
  in  timeout(t(let id))
  in  inflight(tx(let id, let acct, let amt))
  in  reserved(hold(let id, let acct, let amt))
  out released(release(let id))
  out once(key(let id))                              
  out pending(request(let id, let acct, let amt))    
  out log(event(payout_timeout(let id)))
}

transition discard_duplicate {
  in  pending(request(let id, let acct, let amt))
  in  paid(receipt(let id))              
  out paid(receipt(let id))             
  out duplicates(drop(let id))
  out log(event(duplicate_discarded(let id)))
}

init {
  req  request(r1, acctA, 100)
  req  request(r1, acctA, 100)
  once key(r1)
  io_rx ack(tx(r1, acctA, 100))
}
