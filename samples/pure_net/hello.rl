store produced
store free
store buf
store done

// Move one produced item into the buffer, consuming one slot.
transition push {
  in  produced(item(let x))
  in  free(slot)
  out buf(item(let x))
}

// Take two equal items from the buffer at once, return two slots.
transition pop_pair {
  in  buf(item(let y)) * 2
  out done(pair(let y, let y))
  out free(slot) * 2
}

init {
  produced item(hello)
  produced item(world) * 2 // enables pop_pair once for "world"
  free slot * 2
}
