// Warehouse fulfillment pipeline: reserve -> pick -> pack (consolidate) -> ship.
// Highlights:
//  - Equi-joins across stores (order line + stock -> reservation)
//  - Resource pools (semaphores) for pickers/packing stations
//  - Consolidation by shared order id (carton for 2 lines)
//  - No chaining within one atomic step (you can observe staged phases)
//  - Durable outbox pattern for side effects (shipping)
// Notes:
//  - Each order line is one token: orders(order(OrderId, Sku)).
//  - Each unit in inventory is one token: stock(item(Sku)).
//  - Consolidation is opportunistic: if two packed lines exist for the same order a carton may be produced; otherwise a single-line parcel is produced.

store orders        // order(OrderId, Sku) — one token per line item
store stock         // item(Sku) — one token per available unit
store inbound       // po(Sku) — inbound replenishment to be received
store reserved      // res(OrderId, Sku)
store picking       // pick(OrderId, Sku)
store packed        // line(OrderId, Sku)
store shipment      // parcel(...) | carton(...)
store shipped       // shipped(...)
store outbox        // send(...) durable outbox to the outside

store pickers       // worker — capacity pool for picking
store stations      // station — capacity pool for packing

// Receive inbound PO into stock.
transition receive_restock {
  in  inbound(po(let sku))
  out stock(item(let sku))
}

// Reserve stock for an order line (one unit per firing).
transition reserve {
  in  orders(order(let oid, let sku))
  in  stock(item(let sku))
  out reserved(res(let oid, let sku))
}

// Start picking: consume a picker and the reservation, hold picker during the task.
transition start_pick {
  in  reserved(res(let oid, let sku))
  in  pickers(worker)
  out picking(pick(let oid, let sku))
  out pickers(hold)         // capacity is held explicitly
}

// Finish picking: release picker back to pool, produce a packed line.
transition finish_pick {
  in  picking(pick(let oid, let sku))
  in  pickers(hold)
  out packed(line(let oid, let sku))
  out pickers(worker)
}

// Pack two lines of the same order into one carton (consolidation).
transition pack_pair {
  in  packed(line(let oid, let s1))
  in  packed(line(let oid, let s2))
  in  stations(station)
  out shipment(carton(let oid, let s1, let s2))
  out stations(station)
}

// Pack a single line into a parcel (for single-line orders or leftovers).
transition pack_single {
  in  packed(line(let oid, let s))
  in  stations(station)
  out shipment(parcel(let oid, let s))
  out stations(station)
}

// Ship anything ready; also emit to outbox for the outside world.
transition ship {
  in  shipment(let p)
  out shipped(let p)
  out outbox(send(let p))
}

// Demo:
//   • O1 has two lines (A,B) -> likely consolidated carton.
//   • O2 has one line (C) that arrives via inbound PO -> parcel.
//   • O3 asks for B but there's no stock left -> remains in `orders`.
init {
  // Initial on-hand stock
  stock  item(A)
  stock  item(B)

  // Orders (one token per line item)
  orders order(O1, A)
  orders order(O1, B)
  orders order(O2, C)
  orders order(O3, B)

  // Inbound replenishment to make C available later
  inbound po(C)

  // Capacities
  pickers worker * 2
  stations station * 1
}