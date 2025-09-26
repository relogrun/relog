store users: user<sym, int>
store wishes: want<sym, sym>
store stock: item<sym>
store result: pair<sym, sym>

transition allocate_adult {
  in wishes(want(let u, let it))
  in users(user(let u, 18)) { mode read; }
  in stock(item(let it))
  out result(pair(let u, let it))
}

init {
  users user(alice, 18)
  users user(bob, 17)

  wishes want(alice, book)
  wishes want(bob, laptop)

  stock item(book)
  stock item(laptop)
}