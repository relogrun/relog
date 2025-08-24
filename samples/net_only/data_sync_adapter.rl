// Data Sync Adapter — versioning + idempotency (pure tokens)

store src_updates
store normalized
store expected
store vstep
store applied
store duplicates
store io_tx
store log

transition normalize {
  in  src_updates(update(user(let u), ver(let v), doc(let d)))
  out normalized(update(user(let u), ver(let v), doc(let d)))
  out log(event(normalized(user(let u), ver(let v))))
}

transition apply_next {
  in  normalized(update(user(let u), ver(let v), doc(let d)))
  in  expected(expect(user(let u), ver(let v)))
  in  vstep(step(ver(let v), ver(let v_next)))
  out applied(applied(user(let u), ver(let v)))
  out expected(expect(user(let u), ver(let v_next)))
  out io_tx(send(write(user(let u), ver(let v), doc(let d))))
  out log(event(applied_version(user(let u), ver(let v))))
  out vstep(step(ver(let v), ver(let v_next)))
}

transition discard_duplicate {
  in  normalized(update(user(let u), ver(let v), doc(let d)))
  in  applied(applied(user(let u), ver(let v)))
  out applied(applied(user(let u), ver(let v)))
  out duplicates(dup(user(let u), ver(let v)))
  out log(event(duplicate_discarded(user(let u), ver(let v))))
}

init {
  expected expect(user(alex), ver(v1))

  vstep step(ver(v1), ver(v2))
  vstep step(ver(v2), ver(v3))

  src_updates update(user(alex), ver(v2), doc(d2a))
  src_updates update(user(alex), ver(v1), doc(d1))
  src_updates update(user(alex), ver(v2), doc(d2b))
}