// Loop — 8-place ring with swaps + logs

store p1
store p2
store p3
store p4
store p5
store p6
store p7
store p8

store log   // event(...)

transition rot_1 {
  in  p1(ball(let c))
  out p2(ball(let c))
  out log(event(move(p1, p2, let c)))
}

transition rot_2 {
  in  p2(ball(let c))
  out p3(ball(let c))
  out log(event(move(p2, p3, let c)))
}

transition rot_3 {
  in  p3(ball(let c))
  out p4(ball(let c))
  out log(event(move(p3, p4, let c)))
}

transition rot_4 {
  in  p4(ball(let c))
  out p5(ball(let c))
  out log(event(move(p4, p5, let c)))
}

transition rot_5 {
  in  p5(ball(let c))
  out p6(ball(let c))
  out log(event(move(p5, p6, let c)))
}

transition rot_6 {
  in  p6(ball(let c))
  out p7(ball(let c))
  out log(event(move(p6, p7, let c)))
}

transition rot_7 {
  in  p7(ball(let c))
  out p8(ball(let c))
  out log(event(move(p7, p8, let c)))
}

transition rot_8 {
  in  p8(ball(let c))
  out p1(ball(let c))
  out log(event(move(p8, p1, let c)))
}

transition swap_1_5 {
  in  p1(ball(let a))
  in  p5(ball(let b))
  out p1(ball(let b))
  out p5(ball(let a))
  out log(event(swap(p1, p5, let a, let b)))
}

transition swap_3_7 {
  in  p3(ball(let a))
  in  p7(ball(let b))
  out p3(ball(let b))
  out p7(ball(let a))
  out log(event(swap(p3, p7, let a, let b)))
}

init {
  p1 ball(red)
  p3 ball(blue)
  p5 ball(green)
  p7 ball(yellow)
}
