// Equi-join by shared `id`: an order ships only if a matching payment exists.
// Demonstrates variable reuse across two inputs (fan-in) and single-instance firing.

store orders
store payments
store shipped

transition ship_if_paid {
    in  orders(order(let id, let item))
    in  payments(payment(let id, let amt))
    out shipped(shipped(let item, let amt))
}

init {
    orders   order(42, laptop)
    orders   order(100, phone)
    payments payment(42, 1200)
}
